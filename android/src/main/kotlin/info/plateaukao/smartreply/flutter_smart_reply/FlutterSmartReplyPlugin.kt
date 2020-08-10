package info.plateaukao.smartreply.flutter_smart_reply

import androidx.annotation.NonNull;
import com.google.mlkit.nl.smartreply.SmartReply
import com.google.mlkit.nl.smartreply.SmartReplySuggestion
import com.google.mlkit.nl.smartreply.TextMessage

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.ArrayList

/** FlutterSmartReplyPlugin */
class FlutterSmartReplyPlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var channel : MethodChannel
    private val smartReply = SmartReply.getClient()
    private val tempList = listOf<Message>(
        Message("Hello, how are you?", System.currentTimeMillis(), true)
    )

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_smart_reply")
        channel.setMethodCallHandler(this);
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "getSmartReplies" -> getSmartReplies(result, tempList)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }


    private fun getSmartReplies(result: Result, messages: List<Message>) {
        val chatHistory = ArrayList<TextMessage>()
        for (message in messages) {
            if (message.isLocalUser) {
                chatHistory.add(TextMessage.createForLocalUser(message.text, message.timestamp))
            } else {
                chatHistory.add(TextMessage.createForRemoteUser(message.text, message.timestamp, "0421"))
            }
        }

        smartReply.suggestReplies(chatHistory)
            .continueWith { task ->
                result.success(
                    task.result?.suggestions?.map { it.text } ?: emptyList<SmartReplySuggestion>()
                )
            }
    }
}

class Message(val text: String, val timestamp: Long, val isLocalUser: Boolean = false)

