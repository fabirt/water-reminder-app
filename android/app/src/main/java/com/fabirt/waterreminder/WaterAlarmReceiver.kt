package com.fabirt.waterreminder

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import java.time.Instant
import java.time.ZoneId

class WaterAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == WaterAlarmService.ACTION_START_ALARM_SERVICE && context != null) {
            if (isOutOfHours()) return

            val dataStoreProvider = DataStoreProvider(context)
            GlobalScope.launch {
                val settings = dataStoreProvider.waterSettingsFlow.first()

                if (!settings.alarmEnabled) return@launch

                dataStoreProvider.verifyDailyReset()

                if (settings.currentMilliliters >= settings.recommendedMilliliters) return@launch

                val remainingMilliliters = settings.recommendedMilliliters - settings.currentMilliliters

                val contentText = "You still have to drink $remainingMilliliters ml of water more today. Remember to stay hydrated."

                WaterAlarmService.displayFullScreenNotification(context, contentText)
                /*
                val serviceIntent = Intent(context, WaterAlarmService::class.java).apply {
                    action = intent.action
                }
                ContextCompat.startForegroundService(context, serviceIntent)
                 */
            }
        }
    }

    private fun isOutOfHours(): Boolean {
        val date = Instant.ofEpochMilli(System.currentTimeMillis()).atZone(ZoneId.systemDefault())
        return date.hour !in 8..20
    }
}