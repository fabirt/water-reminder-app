package com.fabirt.waterreminder

import android.animation.ObjectAnimator
import android.animation.PropertyValuesHolder
import android.app.KeyguardManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.Bundle
import android.os.IBinder
import android.view.View
import android.view.WindowManager
import android.view.animation.BounceInterpolator
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch

class WaterAlarmActivity : AppCompatActivity() {

    private var mService: WaterAlarmService? = null
    private lateinit var dataStoreProvider: DataStoreProvider
    private lateinit var cancelButton: View
    private lateinit var contentText: TextView

    private val connection = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
            val binder = service as WaterAlarmService.WaterAlarmBinder
            mService = binder.getService()
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            mService = null
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_water_alarm)
        configureWindow()
        dataStoreProvider = DataStoreProvider(this)

        cancelButton = findViewById(R.id.btn_cancel)
        contentText = findViewById(R.id.tv_content)

        startButtonAnimation()
        cancelButton.setOnClickListener {
            NotificationManagerCompat.from(this).cancel(WaterAlarmService.ALARM_NOTIFICATION_ID)
            finish()
        }

        startDestroyTimer()

        lifecycleScope.launch {
            val settings = dataStoreProvider.waterSettingsFlow.first()
            val remaining = settings.recommendedMilliliters - settings.currentMilliliters
            contentText.text = "Remaining $remaining ml"
        }
    }

    override fun onStart() {
        super.onStart()
        Intent(this, WaterAlarmService::class.java).also {
            bindService(it, connection, Context.BIND_AUTO_CREATE)
        }
    }

    override fun onStop() {
        super.onStop()
        unbindService(connection)
        mService = null
    }

    private fun configureWindow() {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
            ContextCompat.getSystemService(this, KeyguardManager::class.java)?.apply {
                requestDismissKeyguard(this@WaterAlarmActivity, null)
            }
        } else {
            window.addFlags(
                    WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
                            or WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
                            or WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
            )
        }
    }

    override fun onDestroy() {
        mService?.stopAlarmService()
        super.onDestroy()
    }

    private fun startDestroyTimer() {
        lifecycleScope.launch {
            delay(35000)
            finish()
        }
    }

    private fun startButtonAnimation() {
        val animator = ObjectAnimator.ofPropertyValuesHolder(
                cancelButton,
                PropertyValuesHolder.ofFloat("scaleX", 1.14f),
                PropertyValuesHolder.ofFloat("scaleY", 1.14f)
        ).apply {
            duration = 400
            repeatCount = ObjectAnimator.INFINITE
            repeatMode = ObjectAnimator.RESTART
            interpolator = BounceInterpolator()
        }

        animator.start()
    }
}