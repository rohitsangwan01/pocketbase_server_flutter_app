package com.rohit.pocketbase_mobile_flutter

import android.Manifest
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import pocketbaseMobile.PocketbaseMobile
import java.net.Inet4Address
import java.net.NetworkInterface
import java.net.SocketException

class MainActivity : FlutterActivity(), MethodChannel.MethodCallHandler {
    private val notificationPermissionResultCode = 11
    private var messageConnector: BasicMessageChannel<Any>? = null
    private var channel: MethodChannel? = null
    private var mainThreadHandler: Handler? = null

    companion object {
        const val broadcastEventAction = "pocketbase_broadcast_action"
        const val broadcastEventType = "pocketbase_broadcast_event_type"
        const val broadcastEventData = "pocketbase_broadcast_event_data"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        val binaryMessenger: BinaryMessenger = flutterEngine.dartExecutor.binaryMessenger
        mainThreadHandler = Handler(Looper.getMainLooper())
        channel = MethodChannel(binaryMessenger, "com.pocketbase.mobile.channel")
        messageConnector = BasicMessageChannel(
            binaryMessenger,
            "com.pocketbase.mobile.message_connector",
            StandardMessageCodec.INSTANCE
        )
        channel?.setMethodCallHandler(this)
        context.registerReceiver(broadcastReceiver, IntentFilter(broadcastEventAction))
        super.configureFlutterEngine(flutterEngine)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "start" -> startPocketbaseService(call.arguments, result)
            "stop" -> stopPocketbaseService(result)
            "isRunning" -> result.success(PocketbaseService.isRunning)
            "version" -> result.success(PocketbaseMobile.getVersion())
            "getLocalIpAddress" -> result.success(getLocalIpAddress())
            else -> result.notImplemented()
        }
    }

    private fun sendMessage(type: String, data: String) {
        mainThreadHandler?.post {
            messageConnector?.send(
                mapOf(
                    "type" to type,
                    "data" to data
                )
            )
        }
    }

    private fun startPocketbaseService(args: Any?, result: MethodChannel.Result) {
        if (PocketbaseService.isRunning) {
            result.error("alreadyRunning", "PocketbaseService is already running", null)
            return
        }
        if (!haveNotificationPermission()) {
            result.error("notificationPermission", "Notification permission required", null)
            return
        }
        val intent = Intent(this, PocketbaseService::class.java)
        initializeArguments(intent, args)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
        result.success(null)
    }

    private fun initializeArguments(intent: Intent, args: Any?) {
        val arguments = args as Map<*, *>
        (arguments["hostName"] as String?)?.let {
            intent.putExtra("hostName", it)
        }
        (arguments["port"] as String?)?.let {
            intent.putExtra("port", it)
        }
        (arguments["dataPath"] as String?)?.let {
            intent.putExtra("dataPath", it)
        }
        (arguments["enablePocketbaseApiLogs"] as Boolean?)?.let {
            intent.putExtra("enablePocketbaseApiLogs", it)
        }

    }

    private fun stopPocketbaseService(result: MethodChannel.Result) {
        if (!PocketbaseService.isRunning) {
            result.error("pocketbaseNotRunning", "Pocketbase not running", null)
            return
        }
        val intent = Intent(this, PocketbaseService::class.java)
        intent.action = PocketbaseService.stopServiceAction
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
        result.success(null)
    }

    private fun getLocalIpAddress(): String? {
        try {
            val en = NetworkInterface.getNetworkInterfaces()
            while (en.hasMoreElements()) {
                val enumIpAddress = en.nextElement().inetAddresses
                while (enumIpAddress.hasMoreElements()) {
                    val inetAddress = enumIpAddress.nextElement()
                    if (!inetAddress.isLoopbackAddress && inetAddress is Inet4Address) {
                        return inetAddress.getHostAddress()
                    }
                }
            }
        } catch (ex: SocketException) {
            ex.printStackTrace()
        }
        return null
    }
    
    private fun haveNotificationPermission(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) return true
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.POST_NOTIFICATIONS
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                notificationPermissionResultCode
            )
            return false
        }
        return true
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        if (requestCode == notificationPermissionResultCode
            && grantResults.isNotEmpty()
            && grantResults.first() == PackageManager.PERMISSION_GRANTED
        ) {
            //  startPocketbaseService()
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    private val broadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent) {
            val eventType: String =
                intent.getStringExtra(broadcastEventType) ?: return
            val eventData: String =
                intent.getStringExtra(broadcastEventData) ?: return
            sendMessage(eventType, eventData)
        }
    }

    override fun onDestroy() {
        context.unregisterReceiver(broadcastReceiver)
        channel?.setMethodCallHandler(null)
        messageConnector = null
        mainThreadHandler = null
        super.onDestroy()
    }
}
