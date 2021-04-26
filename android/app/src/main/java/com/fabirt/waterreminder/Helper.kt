package com.fabirt.waterreminder

import android.app.*
import android.content.Context
import android.content.Intent
import android.content.res.Resources
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.os.Build
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat

fun Activity.createAlarmNotificationChannel() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        val soundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)

        val audioAttributes = AudioAttributes.Builder()
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .setUsage(AudioAttributes.USAGE_ALARM)
                .build()

        val channel = NotificationChannel(
                K.ALARM_CHANNEL_ID,
                K.ALARM_CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = K.ALARM_CHANNEL_DESCRIPTION
            setShowBadge(false)
            setSound(soundUri, audioAttributes)
        }

        NotificationManagerCompat.from(this).createNotificationChannel(channel)
    }
}

fun Context.setRepeatingWaterAlarm() {
    val intent = Intent(WaterAlarmService.ACTION_START_ALARM_SERVICE, null, this, WaterAlarmReceiver::class.java)
    val requestCode = 100867734
    val pendingIntent = PendingIntent.getBroadcast(this, requestCode, intent, PendingIntent.FLAG_UPDATE_CURRENT)

    val alarmManager = ContextCompat.getSystemService(this, AlarmManager::class.java)
    val intervalMillis = 10_800_000L

    alarmManager?.setRepeating(
            AlarmManager.RTC_WAKEUP,
            System.currentTimeMillis() + intervalMillis,
            intervalMillis,
            pendingIntent
    )
}

val Int.dp: Int
    get() = (this * Resources.getSystem().displayMetrics.density + 0.5f).toInt()

val Float.dp: Int
    get() = (this * Resources.getSystem().displayMetrics.density + 0.5f).toInt()