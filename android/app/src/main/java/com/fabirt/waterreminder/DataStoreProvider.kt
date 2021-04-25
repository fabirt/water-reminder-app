package com.fabirt.waterreminder

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.*
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import java.time.Instant
import java.time.ZoneId

class DataStoreProvider(private val context: Context) {

    private val waterMilliliters = intPreferencesKey("water_milliliters")
    private val lastUpdate = longPreferencesKey("last_update")
    private val notificationEnabled = booleanPreferencesKey("notification_enabled")
    private val alarmRunning = booleanPreferencesKey("alarm_running")

    val waterMillilitersFlow: Flow<Int> = context.dataStore.data.map { preferences ->
        preferences[waterMilliliters] ?: 0
    }

    val notificationEnabledFlow: Flow<Boolean> = context.dataStore.data.map { preferences ->
        preferences[notificationEnabled] ?: true
    }

    suspend fun verifyDailyReset() {
        context.dataStore.edit { settings ->
            val lastUpdateMillis = settings[lastUpdate] ?: 0L
            val currentMillis = System.currentTimeMillis()

            val lastUpdateDate = Instant.ofEpochMilli(lastUpdateMillis).atZone(ZoneId.systemDefault())
            val currentDate = Instant.ofEpochMilli(currentMillis).atZone(ZoneId.systemDefault())

            if (currentDate.year != lastUpdateDate.year
                    || currentDate.monthValue != lastUpdateDate.monthValue
                    || currentDate.dayOfMonth != lastUpdateDate.dayOfMonth) {
                settings[waterMilliliters] = 0
            }
        }
    }

    suspend fun drinkWater(milliliters: Int) {
        context.dataStore.edit { settings ->
            val currentMilliliters = settings[waterMilliliters] ?: 0
            settings[waterMilliliters] = currentMilliliters + milliliters
            settings[lastUpdate] = System.currentTimeMillis()
        }
    }

    suspend fun changeNotificationEnabled(enabled: Boolean) {
        context.dataStore.edit { settings ->
            settings[notificationEnabled] = enabled
        }
    }

    suspend fun isAlarmRunning(): Boolean {
        return context.dataStore.data.map { preferences ->
            preferences[alarmRunning] ?: false
        }.first()
    }

    suspend fun updateAlarmRunning(isRunning: Boolean) {
        context.dataStore.edit { settings ->
            settings[alarmRunning] = isRunning
        }
    }
}

private val Context.dataStore: DataStore<Preferences> by preferencesDataStore(name = "settings")
