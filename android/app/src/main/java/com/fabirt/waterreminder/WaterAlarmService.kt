package com.fabirt.waterreminder

import android.app.Notification
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.media.RingtoneManager
import android.os.Binder
import android.os.IBinder
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

class WaterAlarmService : Service() {
    private val binder = WaterAlarmBinder()

    override fun onBind(intent: Intent?): IBinder = binder

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_START_ALARM_SERVICE -> {
                startForeground(ALARM_NOTIFICATION_ID, buildNotification(this, ""))
                stopForeground(false)
            }
            ACTION_STOP_ALARM_SERVICE -> {
                stopAlarmService()
            }
        }
        return START_NOT_STICKY
    }

    fun stopAlarmService() {
        stopForeground(true)
        stopSelf()
    }

    inner class WaterAlarmBinder : Binder() {
        // Return this instance of LocalService so clients can call public methods
        fun getService(): WaterAlarmService = this@WaterAlarmService
    }

    companion object {
        const val ACTION_START_ALARM_SERVICE = "com.fabirt.waterreminder.ACTION_START_ALARM_SERVICE"
        const val ACTION_STOP_ALARM_SERVICE = "com.fabirt.waterreminder.ACTION_STOP_ALARM_SERVICE"
        const val ALARM_NOTIFICATION_ID = 1

        fun displayFullScreenNotification(context: Context, contentText: String) {
            NotificationManagerCompat.from(context).notify(
                    ALARM_NOTIFICATION_ID,
                    buildNotification(context, contentText)
            )
        }

        fun buildNotification(context: Context, contentText: String): Notification {
            val contentIntent = Intent(context, MainActivity::class.java)
            val contentPendingIntent = PendingIntent.getActivity(context, 0, contentIntent, PendingIntent.FLAG_UPDATE_CURRENT)

            val fullScreenIntent = Intent(context, WaterAlarmActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP or
                        Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS or
                        Intent.FLAG_ACTIVITY_NO_HISTORY
            }
            val fullScreenPendingIntent = PendingIntent.getActivity(context, 0, fullScreenIntent, PendingIntent.FLAG_UPDATE_CURRENT)

            val deleteIntent = Intent(ACTION_STOP_ALARM_SERVICE, null, context, WaterAlarmService::class.java)
            val deletePendingIntent = PendingIntent.getService(context, 0, deleteIntent, PendingIntent.FLAG_UPDATE_CURRENT)

            val soundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)

            return NotificationCompat.Builder(context, K.ALARM_CHANNEL_ID)
                    .setSmallIcon(R.drawable.ic_water_glass)
                    .setContentTitle("It is water time! \uD83D\uDCA7\uD83E\uDD5B")
                    .setContentText(contentText)
                    .setColor(context.getColor(R.color.color_water))
                    .setStyle(NotificationCompat.BigTextStyle().bigText(contentText))
                    .setPriority(NotificationCompat.PRIORITY_MAX)
                    .setCategory(NotificationCompat.CATEGORY_ALARM)
                    .setContentIntent(contentPendingIntent)
                    .setFullScreenIntent(fullScreenPendingIntent, true)
                    .setDeleteIntent(deletePendingIntent)
                    .setOngoing(false)
                    .setAutoCancel(true)
                    .setSound(soundUri)
                    .build()
                    .apply {
                        // flags = flags or Notification.FLAG_INSISTENT
                    }
        }
    }
}