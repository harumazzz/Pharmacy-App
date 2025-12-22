import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_app/data/services/deepseek_chat_service.dart';
import 'package:pharmacy_app/presentation/providers/ai_chat/chat_messages_provider.dart';
import 'package:pharmacy_app/presentation/providers/product_list/product_list_provider.dart';
import 'package:pharmacy_app/presentation/widgets/loading_spinner.dart';

class AIChatDialog extends ConsumerStatefulWidget {
  const AIChatDialog({super.key});

  @override
  ConsumerState<AIChatDialog> createState() => _AIChatDialogState();
}

class _AIChatDialogState extends ConsumerState<AIChatDialog> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();

    final chatNotifier = ref.read(chatMessagesProvider.notifier);
    chatNotifier.addMessage(message, 'user');
    _scrollToBottom();

    setState(() => _isLoading = true);

    try {
      final productsAsync = ref.read(productListProvider(categoryId: null));

      productsAsync.whenData((products) async {
        final chatService = DeepseekChatService(products: products);
        final conversationHistory = chatNotifier.getConversationHistory();

        final response = await chatService.chatWithContext(
          message,
          conversationHistory,
        );

        chatNotifier.addMessage(response, 'assistant');
        _scrollToBottom();
      });
    } catch (e) {
      chatNotifier.addMessage('Lỗi: ${e.toString()}', 'assistant');
      _scrollToBottom();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatMessages = ref.watch(chatMessagesProvider);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trợ lý AI Nhà thuốc',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 300,
                maxHeight: 500,
                minWidth: 350,
                maxWidth: 600,
              ),
              child: chatMessages.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Xin chào! Tôi là trợ lý AI của nhà thuốc. Hỏi tôi bất kỳ điều gì về sản phẩm của chúng tôi.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: chatMessages.length,
                      itemBuilder: (context, index) {
                        final msg = chatMessages[index];
                        final isUser = msg.role == 'user';

                        return Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            constraints: const BoxConstraints(maxWidth: 250),
                            child: Text(
                              msg.content,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: isUser ? Colors.white : Colors.black,
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      hintText: 'Nhập câu hỏi của bạn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: _isLoading ? null : _sendMessage,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: LoadingSpinner(size: 20),
                          )
                        : const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
