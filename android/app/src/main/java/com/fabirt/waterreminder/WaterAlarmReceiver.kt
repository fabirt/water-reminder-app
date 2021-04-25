package com.fabirt.waterreminder

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import java.time.Instant
import java.time.ZoneId

class WaterAlarmReceiver: BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == WaterAlarmService.ACTION_START_ALARM_SERVICE && context != null) {
            if (isOutOfHours()) {
                return
            }

            val dataStoreProvider = DataStoreProvider(context)
            GlobalScope.launch {
                if (dataStoreProvider.notificationEnabledFlow.first()) {
                    WaterAlarmService.displayFullScreenNotification(context)
                    /*
                    val serviceIntent = Intent(context, WaterAlarmService::class.java).apply {
                        action = intent.action
                    }
                    ContextCompat.startForegroundService(context, serviceIntent)
                     */
                }
            }
        }
    }

    private fun isOutOfHours(): Boolean {
        val date = Instant.ofEpochMilli(System.currentTimeMillis()).atZone(ZoneId.systemDefault())
        return date.hour !in 8..20
    }
}