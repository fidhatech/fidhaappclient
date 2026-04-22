package fidha.app.com

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.view.WindowManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

	companion object {
		private const val CHANNEL = "fidha.app/call_foreground_service"
		private const val ACTION_CHANNEL = "fidha.app/notification_actions"
		private const val METHOD_START = "start"
		private const val METHOD_STOP = "stop"
		private const val METHOD_ON_ACTION = "onNotificationAction"
		private const val METHOD_CANCEL_NOTIFICATION = "cancelIncomingCallNotification"
		private const val METHOD_BRING_TO_FOREGROUND = "bringAppToForeground"
	}

	private var actionChannel: MethodChannel? = null
	private var pendingActionEvent: Map<String, Any>? = null

	override fun onCreate(savedInstanceState: android.os.Bundle?) {
		window.setFlags(
			WindowManager.LayoutParams.FLAG_SECURE,
			WindowManager.LayoutParams.FLAG_SECURE,
		)
		super.onCreate(savedInstanceState)
	}

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
			.setMethodCallHandler { call, result ->
				when (call.method) {
					METHOD_START -> {
						val callId = call.argument<String>("callId") ?: ""
						val callType = call.argument<String>("callType") ?: "call"
						startCallForegroundService(callId, callType)
						result.success(null)
					}

					METHOD_STOP -> {
						stopCallForegroundService()
						result.success(null)
					}

					else -> result.notImplemented()
				}
			}

		actionChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ACTION_CHANNEL)
		actionChannel?.setMethodCallHandler { call, result ->
			when (call.method) {
				METHOD_BRING_TO_FOREGROUND -> {
					bringAppToForeground()
					result.success(null)
				}

				METHOD_CANCEL_NOTIFICATION -> {
					val callId = call.argument<String>("callId").orEmpty()
					cancelIncomingCallNotification(callId)
					result.success(null)
				}

				else -> result.notImplemented()
			}
		}
		pendingActionEvent?.let {
			actionChannel?.invokeMethod(METHOD_ON_ACTION, HashMap(it))
			pendingActionEvent = null
		}
		dispatchNotificationAction(intent)
	}

	override fun onNewIntent(intent: Intent) {
		super.onNewIntent(intent)
		setIntent(intent)
		dispatchNotificationAction(intent)
	}

	private fun dispatchNotificationAction(intent: Intent?) {
		if (intent == null) return

		val payload = intent.getStringExtra(
			IncomingCallFirebaseMessagingService.EXTRA_NOTIFICATION_PAYLOAD,
		).orEmpty()
		if (payload.isBlank()) return

		val action = intent.getStringExtra(
			IncomingCallFirebaseMessagingService.EXTRA_NOTIFICATION_ACTION,
		).orEmpty()

		val callId = intent.getStringExtra("callId").orEmpty()
		cancelIncomingCallNotification(callId)

		val event = mutableMapOf<String, Any>(
			"payload" to payload,
		)
		if (action.isNotBlank()) {
			event["action"] = action
		}

		if (actionChannel != null) {
			actionChannel?.invokeMethod(METHOD_ON_ACTION, HashMap(event))
		} else {
			pendingActionEvent = event
		}
	}

	private fun cancelIncomingCallNotification(callId: String) {
		if (callId.isBlank()) return
		val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
		manager.cancel(callId.hashCode())
		manager.cancel(callId, callId.hashCode())
	}

	private fun bringAppToForeground() {
		val launchIntent = Intent(this, MainActivity::class.java).apply {
			addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
		}
		startActivity(launchIntent)
	}

	private fun startCallForegroundService(callId: String, callType: String) {
		val intent = Intent(this, CallForegroundService::class.java).apply {
			putExtra(CallForegroundService.EXTRA_CALL_ID, callId)
			putExtra(CallForegroundService.EXTRA_CALL_TYPE, callType)
		}

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
			startForegroundService(intent)
		} else {
			startService(intent)
		}
	}

	private fun stopCallForegroundService() {
		val intent = Intent(this, CallForegroundService::class.java)
		stopService(intent)
	}
}
