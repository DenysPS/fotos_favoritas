package br.com.denysps.fotos_favoritas

import android.Manifest
import android.content.ContentResolver
import android.content.ContentUris
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import com.bumptech.glide.Glide
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class MainActivity : FlutterFragmentActivity() {
    private var methodResult: MethodChannel.Result? = null
    private var queryLimit: Int = 0

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        MethodChannel(messenger, "br.com.Denysps.fotos_favoritas")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getPhotos" -> {
                        methodResult = result
                        queryLimit = 100
                        getPhotos()
                    }
                    "fetchImage" -> fetchImage(call.arguments()!!, result)
                    else -> result.notImplemented()
                }
            }
    }

    private fun getPhotos() {
        if (queryLimit == 0 || !hasStoragePermission()) return

        lifecycleScope.launch(Dispatchers.IO) {
            val ids = mutableListOf<String>()
            val cursor = getCursor(queryLimit)
            cursor?.use {
                while (cursor.moveToNext()) {
                    val columnIndex = cursor.getColumnIndexOrThrow(MediaStore.Images.Media._ID)
                    val long = cursor.getLong(columnIndex)
                    ids.add(long.toString())
                }
            }
            methodResult?.success(ids)
        }

    }

    private fun fetchImage(args: Map<String, Any>, result: MethodChannel.Result) {
        val id = (args["id"] as String).toLong()
        val width = (args["width"] as Double).toInt()
        val height = (args["height"] as Double).toInt()
        val uri = ContentUris.withAppendedId(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, id)
        getImageBytes(uri, width, height) {
            result.success(it)
        }

    }


    private fun hasStoragePermission(): Boolean {
        val permission = Manifest.permission.READ_EXTERNAL_STORAGE
        val state = ContextCompat.checkSelfPermission(this, permission)
        if (state == PackageManager.PERMISSION_GRANTED) return true
        permissionLauncher.launch(permission)
        return false
    }


    private fun getImageBytes(uri: Uri?, width: Int, height: Int, onComplete: (ByteArray) -> Unit) {
        lifecycleScope.launch(Dispatchers.IO) {
            try {
                val r = Glide.with(this@MainActivity)
                    .`as`(ByteArray::class.java)
                    .load(uri)
                    .submit(width, height).get()
                onComplete(r)
            } catch (t: Throwable) {
                onComplete(byteArrayOf())
            }
        }
    }


    private fun getCursor(limit: Int): Cursor? {
        val uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
        val projection = arrayOf(MediaStore.Images.Media._ID)

        return if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
            val sort = "${MediaStore.Images.ImageColumns.DATE_MODIFIED} DESC LIMIT $limit"
            contentResolver.query(uri, projection, null, null, sort)
        } else {
            val args = Bundle().apply {
                putInt(ContentResolver.QUERY_ARG_LIMIT, limit)
                putStringArray(
                    ContentResolver.QUERY_ARG_SORT_COLUMNS,
                    arrayOf(MediaStore.Images.ImageColumns.DATE_MODIFIED)
                )
                putInt(
                    ContentResolver.QUERY_ARG_SORT_DIRECTION,
                    ContentResolver.QUERY_SORT_DIRECTION_DESCENDING
                )
            }
            contentResolver.query(uri, projection, args, null)
        }
    }



    private val permissionLauncher =
        registerForActivityResult(ActivityResultContracts.RequestPermission()) { granted ->
            if (granted) {
                getPhotos()
            } else {
                methodResult?.error("0", "Permission denied", "")
            }
        }


}

