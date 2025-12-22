import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';

@freezed
sealed class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String content,
    required String role,
    required DateTime timestamp,
  }) = _ChatMessage;
}
