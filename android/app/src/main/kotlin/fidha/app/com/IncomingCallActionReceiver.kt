package fidha.app.com

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class IncomingCallActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.getStringExtra(IncomingCallFirebaseMessagingService.EXTRA_NOTIFICATION_ACTION).orEmpty()
        val payload = intent.getStringExtra(IncomingCallFirebaseMessagingService.EXTRA_NOTIFICATION_PAYLOAD).orEmpty()
        val callId = intent.getStringExtra("callId").orEmpty()

        if (callId.isNotBlank()) {
            val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.cancel(callId.hashCode())
            manager.cancel(callId, callId.hashCode())
        }

        val launchIntent = Intent(context, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            putExtra(IncomingCallFirebaseMessagingService.EXTRA_NOTIFICATION_ACTION, action)
            putExtra(IncomingCallFirebaseMessagingService.EXTRA_NOTIFICATION_PAYLOAD, payload)
            putExtra("callId", callId)
        }
        context.startActivity(launchIntent)
    }
}
