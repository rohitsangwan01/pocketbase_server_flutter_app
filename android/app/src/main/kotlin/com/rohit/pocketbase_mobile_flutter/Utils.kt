package com.rohit.pocketbase_mobile_flutter

import android.content.Context

class Utils {
    companion object {
        const val defaultHostName = "127.0.0.1"
        const val defaultPort = "8090"

        fun getStoragePath(context: Context): String {
            val directory = context.getExternalFilesDir(null) ?: context.filesDir
            return directory.absolutePath
        }
    }
}
