package com.fabirt.waterreminder

import android.os.Bundle
import androidx.annotation.NonNull
import androidx.core.view.WindowCompat
import androidx.lifecycle.lifecycleScope
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

class MainActivity : FlutterActivity(), MethodChannel.MethodCallHandler {

    private lateinit var callbackChannel: MethodChannel
    lateinit var dataStoreProvider: DataStoreProvider

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, false)
        createAlarmNotificationChannel()
        dataStoreProvider = DataStoreProvider(this)
        createAlarmIfNotRunning()
    }

    override fun onResume() {
        super.onResume()
        lifecycleScope.launch {
            dataStoreProvider.verifyDailyReset()
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        callbackChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, K.METHOD_CHANNEL_NAME).apply {
            setMethodCallHandler(this@MainActivity)
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            K.METHOD_DRINK_WATER -> {
                val milliliters = call.arguments as Int
                lifecycleScope.launch {
                    dataStoreProvider.setWaterMilliliters(milliliters)
                }
                result.success(null)
            }
            K.METHOD_CHANGE_NOTIFICATION_ENABLED -> {
                lifecycleScope.launch {
                    val enabled = call.arguments as Boolean
                    dataStoreProvider.setNotificationEnabled(enabled)
                }
                result.success(null)
            }
            K.METHOD_SUBSCRIBE_TO_DATA_STORE -> {
                subscribeToDataStore()
                result.success(null)
            }
            K.METHOD_CLEAR_DATA_STORE -> {
                clearDataStore()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun subscribeToDataStore() {
        lifecycleScope.launch {
            dataStoreProvider.waterSettingsFlow.collect { settings ->
                callbackChannel.invokeMethod(K.METHOD_WATER_SETTINGS_CHANGED, settings.asMap())
            }
        }
    }

    private fun createAlarmIfNotRunning() {
        lifecycleScope.launch {
            if (!dataStoreProvider.isAlarmRunning()) {
                setRepeatingWaterAlarm()
                dataStoreProvider.setAlarmRunning(true)
            }
        }
    }

    private fun clearDataStore() {
        lifecycleScope.launch {
            dataStoreProvider.clearPreferences()
            setRepeatingWaterAlarm()
            dataStoreProvider.setAlarmRunning(true)
        }
    }
}
