package fidha.app.com

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.os.Build
import androidx.core.app.NotificationCompat
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import org.json.JSONObject

class IncomingCallFirebaseMessagingService : FirebaseMessagingService() {

    companion object {
        const val CHANNEL_ID = "incoming_call_channel_v2"
        private const val CHANNEL_NAME = "Incoming Calls"
        private const val CHANNEL_DESCRIPTION = "High-priority incoming call alerts"
        private const val STALE_CALL_GRACE_MS = 90_000L

        const val EXTRA_NOTIFICATION_ACTION = "notificationAction"
        const val EXTRA_NOTIFICATION_PAYLOAD = "notificationPayload"

        const val ACTION_ACCEPT_CALL = "accept_call"
        const val ACTION_DECLINE_CALL = "decline_call"
    }

    override fun onMessageReceived(message: RemoteMessage) {
        super.onMessageReceived(message)

        val data = message.data
        if (data.isEmpty()) return

        if (data["type"] != "call") return

        val expiresAt = data["callExpiresAt"]?.toLongOrNull()
        if (expiresAt != null && System.currentTimeMillis() > expiresAt + STALE_CALL_GRACE_MS) {
            return
        }

        showIncomingCallNotification(data)
    }

    private fun showIncomingCallNotification(data: Map<String, String>) {
        createCallChannelIfNeeded()

        val callId = data["callId"].orEmpty()
        if (callId.isBlank()) return

        val callerName = data["callerName"].takeUnless { it.isNullOrBlank() } ?: "Unknown Caller"
        val callTypeDisplay = data["callTypeDisplay"].takeUnless { it.isNullOrBlank() }
            ?: "Call"

        val payloadJson = JSONObject(data as Map<*, *>).toString()

        val openIntent = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            putExtra(EXTRA_NOTIFICATION_PAYLOAD, payloadJson)
            putExtra("callId", callId)
        }
        val openPendingIntent = PendingIntent.getActivity(
            this,
            callId.hashCode(),
            openIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val acceptOpenIntent = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            putExtra(EXTRA_NOTIFICATION_ACTION, ACTION_ACCEPT_CALL)
            putExtra(EXTRA_NOTIFICATION_PAYLOAD, payloadJson)
            putExtra("callId", callId)
        }
        val acceptPendingIntent = PendingIntent.getActivity(
            this,
            (callId + ACTION_ACCEPT_CALL).hashCode(),
            acceptOpenIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val declineIntent = Intent(this, IncomingCallActionReceiver::class.java).apply {
            putExtra(EXTRA_NOTIFICATION_ACTION, ACTION_DECLINE_CALL)
            putExtra(EXTRA_NOTIFICATION_PAYLOAD, payloadJson)
            putExtra("callId", callId)
        }
        val declinePendingIntent = PendingIntent.getBroadcast(
            this,
            (callId + ACTION_DECLINE_CALL).hashCode(),
            declineIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val builder = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher_monochrome)
            .setContentTitle("Incoming $callTypeDisplay")
            .setContentText("$callerName is calling...")
            .setCategory(NotificationCompat.CATEGORY_CALL)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setOngoing(true)
            .setAutoCancel(false)
            .setOnlyAlertOnce(false)
            .setFullScreenIntent(openPendingIntent, true)
            .setContentIntent(openPendingIntent)
            .setTimeoutAfter(45_000)
            .setVibrate(longArrayOf(0, 1000, 800, 1000, 800, 1200, 700, 1200))
            .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE))
            .addAction(0, "Accept", acceptPendingIntent)
            .addAction(0, "Decline", declinePendingIntent)

        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(callId, callId.hashCode(), builder.build())
    }

    private fun createCallChannelIfNeeded() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val existing = manager.getNotificationChannel(CHANNEL_ID)
        if (existing != null) return

        val ringtoneUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
        val audioAttributes = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_ALARM)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()

        val channel = NotificationChannel(
            CHANNEL_ID,
            CHANNEL_NAME,
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            description = CHANNEL_DESCRIPTION
            setSound(ringtoneUri, audioAttributes)
            enableVibration(true)
            vibrationPattern = longArrayOf(0, 1000, 800, 1000, 800, 1200, 700, 1200)
            lockscreenVisibility = android.app.Notification.VISIBILITY_PUBLIC
        }

        manager.createNotificationChannel(channel)
    }
}
