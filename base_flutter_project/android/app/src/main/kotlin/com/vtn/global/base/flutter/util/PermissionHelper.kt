package com.vtn.global.base.flutter.util

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Handler
import android.os.Looper
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.MethodChannel
import com.vtn.global.base.flutter.MainActivity

open class PermissionHelper(
    private val context: Context,
    private val permission: String,
    val result: MethodChannel.Result
) {
    protected var handler: Handler? = null
    protected var runnable: Runnable? = null
    protected var isWatching = false


    open fun isGranted(): Boolean {
        return ContextCompat.checkSelfPermission(
            context,
            permission
        ) == PackageManager.PERMISSION_GRANTED
    }

    open fun openAppSettings() {
        val intent = Intent(android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
        intent.data = Uri.fromParts("package", context.packageName, null)
        context.startActivity(intent)
    }

    open fun backToApp() {
        val intent = Intent(context, MainActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        context.startActivity(intent)
    }

    open fun watchPermission(interval: Long = 500) {
        isWatching = true
        handler = Handler(Looper.getMainLooper())
        runnable = object : Runnable {
            override fun run() {
                if (isGranted()) {
                    stopWatching()
                    backToApp()
                    result.success(true)
                } else {
                    handler?.postDelayed(this, interval)
                }
            }
        }
        handler?.post(runnable!!)
    }

    open fun stopWatching() {
        if (isWatching) {
            isWatching = false
            handler?.removeCallbacks(runnable!!)
            runnable = null
            handler = null
        }
    }

    fun onAppResume() {
        if (isWatching) {
            stopWatching()
            result.success(isGranted())
        }
    }
}
