package com.fabirt.waterreminder

import android.app.KeyguardManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.IBinder
import android.view.View
import android.view.WindowManager
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class WaterAlarmActivity : AppCompatActivity() {
    private var mService: WaterAlarmService? = null

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

        findViewById<View>(R.id.btn_cancel).setOnClickListener {
            NotificationManagerCompat.from(this).cancel(WaterAlarmService.ALARM_NOTIFICATION_ID)
            finish()
        }
        startDestroyTimer()
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
}