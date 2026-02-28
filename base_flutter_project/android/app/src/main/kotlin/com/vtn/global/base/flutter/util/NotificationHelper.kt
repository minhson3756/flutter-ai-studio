package com.vtn.global.base.flutter.util

import android.Manifest
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import io.flutter.plugin.common.MethodChannel


class NotificationPermissionHelper(
    val context: Context,
    result: MethodChannel.Result
) : PermissionHelper(context, "", result) {
    private val notificationManagerCompat = NotificationManagerCompat.from(context)

    override fun isGranted(): Boolean {
        return notificationManagerCompat.areNotificationsEnabled()
    }

    override fun openAppSettings() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val intent = Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
            intent.putExtra(Settings.EXTRA_APP_PACKAGE, context.packageName)
            context.startActivity(intent)
        } else {
            super.openAppSettings()
        }
    }
}