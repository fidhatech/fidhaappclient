package fidha.app.com

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class CallForegroundService : Service() {

    companion object {
        const val CHANNEL_ID = "fidha_active_call_channel"
        const val CHANNEL_NAME = "Active Call"
        const val NOTIFICATION_ID = 24007

        const val EXTRA_CALL_ID = "extra_call_id"
        const val EXTRA_CALL_TYPE = "extra_call_type"
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val callId = intent?.getStringExtra(EXTRA_CALL_ID) ?: ""
        val callType = intent?.getStringExtra(EXTRA_CALL_TYPE) ?: "call"

        createNotificationChannel()
        val notification = buildNotification(callId, callType)
        startForeground(NOTIFICATION_ID, notification)

        return START_STICKY
    }

    override fun onDestroy() {
        stopForeground(STOP_FOREGROUND_REMOVE)
        super.onDestroy()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return

        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channel = NotificationChannel(
            CHANNEL_ID,
            CHANNEL_NAME,
            NotificationManager.IMPORTANCE_LOW
        ).apply {
            description = "Keeps active call session stable while app is backgrounded"
            setShowBadge(false)
        }
        manager.createNotificationChannel(channel)
    }

    private fun buildNotification(callId: String, callType: String): Notification {
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val contentText = if (callId.isBlank()) {
            "Active $callType in progress"
        } else {
            "Active $callType in progress · $callId"
        }

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Fidha call is active")
            .setContentText(contentText)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setOngoing(true)
            .setAutoCancel(false)
            .setOnlyAlertOnce(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setContentIntent(pendingIntent)
            .build()
    }
}
