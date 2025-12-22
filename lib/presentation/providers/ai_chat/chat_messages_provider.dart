import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pharmacy_app/presentation/providers/ai_chat/chat_message.dart';

part 'chat_messages_provider.g.dart';

@riverpod
class ChatMessages extends _$ChatMessages {
  @override
  List<ChatMessage> build() => [];

  void addMessage(String content, String role) {
    state = [
      ...state,
      ChatMessage(
        content: content,
        role: role,
        timestamp: DateTime.now(),
      ),
    ];
  }

  void clearMessages() {
    state = [];
  }

  List<Map<String, String>> getConversationHistory() {
    return state
        .map((msg) => {
              'role': msg.role,
              'content': msg.content,
            })
        .toList();
  }
}
