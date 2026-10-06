package com.app.spare_shop

import android.content.Intent
import android.media.MediaScannerConnection
import android.net.Uri
import android.util.Log
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.voltspare.shop/native_pdf_channel"
    private val TAG = "VoltSpareShare"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "scanFile" -> {
                    val filePath = call.argument<String>("filePath")
                    if (filePath != null) {
                        try {
                            MediaScannerConnection.scanFile(
                                applicationContext,
                                arrayOf(filePath),
                                arrayOf("application/pdf")
                            ) { path, uri ->
                                Log.d(TAG, "MediaScanner indexed: $path -> $uri")
                            }
                            result.success(true)
                        } catch (e: Exception) {
                            Log.e(TAG, "MediaScanner error: ${e.message}", e)
                            result.error("SCAN_ERROR", e.localizedMessage, null)
                        }
                    } else {
                        result.error("INVALID_PATH", "File path is null", null)
                    }
                }
                "openFile" -> {
                    val filePath = call.argument<String>("filePath")
                    if (filePath != null) {
                        try {
                            val file = File(filePath)
                            if (!file.exists()) {
                                Log.e(TAG, "openFile: PDF does not exist at $filePath")
                                result.error("FILE_NOT_FOUND", "File not found at $filePath", null)
                                return@setMethodCallHandler
                            }

                            val uri: Uri = FileProvider.getUriForFile(
                                context,
                                "${context.packageName}.fileprovider",
                                file
                            )
                            Log.d(TAG, "Opening PDF content URI: $uri")

                            val intent = Intent(Intent.ACTION_VIEW).apply {
                                setDataAndType(uri, "application/pdf")
                                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            }
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            Log.e(TAG, "openFile error: ${e.message}", e)
                            result.error("OPEN_FAILED", e.localizedMessage, null)
                        }
                    } else {
                        result.error("INVALID_PATH", "File path is null", null)
                    }
                }
                "shareFile" -> {
                    val filePath = call.argument<String>("filePath")
                    val title = call.argument<String>("title") ?: "Share Tax Invoice"
                    val subject = call.argument<String>("subject") ?: "VoltSpare Tax Invoice"
                    val text = call.argument<String>("text") ?: ""

                    if (filePath != null) {
                        try {
                            val file = File(filePath)
                            val fileExists = file.exists()
                            val fileSize = if (fileExists) file.length() else 0L

                            Log.d(TAG, "=== SHARE INVOICE PROCESS START ===")
                            Log.d(TAG, "PDF path: $filePath")
                            Log.d(TAG, "PDF exists: $fileExists")
                            Log.d(TAG, "PDF file size: $fileSize bytes")
                            Log.d(TAG, "MIME type: application/pdf")

                            if (!fileExists || fileSize == 0L) {
                                Log.e(TAG, "PDF file does not exist or is empty")
                                result.error("FILE_NOT_FOUND", "Invoice file does not exist or is empty", null)
                                return@setMethodCallHandler
                            }

                            val uri: Uri = FileProvider.getUriForFile(
                                context,
                                "${context.packageName}.fileprovider",
                                file
                            )
                            Log.d(TAG, "Content URI: $uri")

                            val shareIntent = Intent(Intent.ACTION_SEND).apply {
                                type = "application/pdf"
                                putExtra(Intent.EXTRA_STREAM, uri)
                                putExtra(Intent.EXTRA_SUBJECT, subject)
                                if (text.isNotEmpty()) {
                                    putExtra(Intent.EXTRA_TEXT, text)
                                }
                                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                            }
                            Log.d(TAG, "Share intent created: $shareIntent")

                            val chooser = Intent.createChooser(shareIntent, title).apply {
                                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            }

                            startActivity(chooser)
                            Log.d(TAG, "Share intent launched: success")
                            Log.d(TAG, "=== SHARE INVOICE PROCESS END ===")
                            result.success(true)
                        } catch (e: Exception) {
                            Log.e(TAG, "shareFile error: ${e.message}", e)
                            result.error("SHARE_FAILED", e.localizedMessage, null)
                        }
                    } else {
                        result.error("INVALID_PATH", "File path is null", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
