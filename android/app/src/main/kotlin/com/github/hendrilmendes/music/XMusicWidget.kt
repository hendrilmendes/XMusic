package com.github.hendrilmendes.music

import MainActivity
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.media.MediaMetadata
import android.media.session.MediaController
import android.media.session.MediaSession
import android.util.Log
import android.widget.RemoteViews

class XMusicWidget : AppWidgetProvider() {
    private var mediaSession: MediaSession? = null
    private var mediaController: MediaController? = null

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)

        Log.d("MyWidgetProvider", "Initializing MediaSession and MediaController")

        // Initialize MediaSession
        mediaSession = MediaSession(context, "XMusicWidget")
        mediaSession?.isActive = true

        // Initialize MediaController
        mediaController = MediaController(context, mediaSession!!.sessionToken)

        // Update each widget
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context?, intent: android.content.Intent?) {
        super.onReceive(context, intent)

        Log.d("MyWidgetProvider", "Received intent")

        // Handle media playback state changes
        if (intent?.action == "com.github.hendrilmendes.music.ACTION_PLAYBACK_STATE_CHANGED") {
            context?.let {
                val appWidgetManager = AppWidgetManager.getInstance(it)
                val appWidgetIds = appWidgetManager.getAppWidgetIds(ComponentName(it, XMusicWidget::class.java))
                onUpdate(it, appWidgetManager, appWidgetIds)
            }
        }
    }

    private fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
        Log.d("MyWidgetProvider", "Updated intent")
        val views = RemoteViews(context.packageName, R.layout.x_music_widget).apply {
            // Get the currently playing song title
            val metadata: MediaMetadata? = mediaController?.metadata
            Log.d("MyWidgetProvider", "Currently playing: $metadata")
            if (metadata != null) {
                // Get the currently playing song title
                val songTitle = metadata.getString(MediaMetadata.METADATA_KEY_TITLE)
                // Get the currently playing song artist
                val songArtist = metadata.getString(MediaMetadata.METADATA_KEY_ARTIST)
                Log.d("MyWidgetProvider", "Currently playing: $songTitle")

                setTextViewText(R.id.widget_title_text, songTitle ?: "Title")
                setTextViewText(R.id.widget_subtitle_text, songArtist ?: "Subtitle")
            }

            // Open App on Widget Click
            val pendingIntent = getActivity(
                context,
                MainActivity::class.java
            )
            setOnClickPendingIntent(R.id.widget_container, pendingIntent)

            val skipNextIntent = getPendingIntent(
                context,
                "xmusic://controls/skipNext"
            )
            setOnClickPendingIntent(R.id.widget_button_next, skipNextIntent)

            val skipPreviousIntent = getPendingIntent(
                context,
                "xmusic://controls/skipPrevious"
            )
            setOnClickPendingIntent(R.id.widget_button_prev, skipPreviousIntent)

            val playPauseIntent = getPendingIntent(
                context,
                "xmusic://controls/playPause"
            )
            setOnClickPendingIntent(R.id.widget_button_play_pause, playPauseIntent)
        }

        appWidgetManager.updateAppWidget(appWidgetId, views)
        val componentName = ComponentName(context, XMusicWidget::class.java)
        appWidgetManager.updateAppWidget(componentName, views)
    }

    private fun getActivity(context: Context, cls: Class<*>): PendingIntent {
        val intent = android.content.Intent(context, cls)
        return PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)
    }

    private fun getPendingIntent(context: Context, action: String): PendingIntent {
        val intent = android.content.Intent(action)
        return PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)
    }
}
