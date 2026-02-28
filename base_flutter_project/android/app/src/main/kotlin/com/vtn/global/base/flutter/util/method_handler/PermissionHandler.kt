package com.vtn.global.base.flutter.util.method_handler

import android.Manifest
import android.content.Context
import android.os.Build
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.ProcessLifecycleOwner
import com.vtn.global.base.flutter.util.NotificationPermissionHelper
import com.vtn.global.base.flutter.util.PermissionHelper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class PermissionHandler(
    private val context: Context,
    messenger: BinaryMessenger,
) : MethodCallHandler, DefaultLifecycleObserver {

    private val channel = MethodChannel(messenger, "com.app.permission/request")

    init {
        channel.setMethodCallHandler(this)
        ProcessLifecycleOwner.get().lifecycle.addObserver(this)
    }

    private var storagePermissionHelper: PermissionHelper? = null
    private var cameraPermissionHelper: PermissionHelper? = null
    private var microphonePermissionHelper: PermissionHelper? = null
    private var notificationPermissionHelper: NotificationPermissionHelper? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "openStorageSetting" -> {
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
                    storagePermissionHelper = PermissionHelper(
                        context,
                        Manifest.permission.READ_EXTERNAL_STORAGE,
                        result
                    ).apply {
                        openAppSettings()
                        watchPermission()
                    }
                } else {
                    result.error(
                        "UNSUPPORTED_VERSION",
                        "Storage permission handling is only supported on Android versions below Tiramisu (API 33).",
                        null
                    )
                }
            }

            "openPhotoSetting" -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    storagePermissionHelper = PermissionHelper(
                        context,
                        Manifest.permission.READ_MEDIA_IMAGES,
                        result
                    ).apply {
                        openAppSettings()
                        watchPermission()
                    }
                } else {
                    result.error(
                        "UNSUPPORTED_VERSION",
                        "Photo permission handling is only supported on Android versions Tiramisu (API 33) and above.",
                        null
                    )
                }

            }

            "openCameraSetting" -> {
                cameraPermissionHelper = PermissionHelper(
                    context,
                    Manifest.permission.CAMERA,
                    result
                ).apply {
                    openAppSettings()
                    watchPermission()
                }
            }

            "openNotificationSetting" -> {
                notificationPermissionHelper = NotificationPermissionHelper(
                    context,
                    result
                ).apply {
                    openAppSettings()
                    watchPermission()
                }
            }
        }
    }

    override fun onResume(owner: LifecycleOwner) {
        super.onResume(owner)
        storagePermissionHelper?.onAppResume()
        cameraPermissionHelper?.onAppResume()
        microphonePermissionHelper?.onAppResume()
        notificationPermissionHelper?.onAppResume()
    }

    override fun onDestroy(owner: LifecycleOwner) {
        super.onDestroy(owner)
        ProcessLifecycleOwner.get().lifecycle.removeObserver(this)
    }
}