import 'package:deepseek/deepseek.dart';
import 'package:pharmacy_app/config/env.dart';
import 'package:pharmacy_app/data/models/product.dart';

class DeepseekChatService {
  late final DeepSeek _deepseek;
  final List<Product> products;

  DeepseekChatService({required this.products}) {
    _deepseek = DeepSeek(Env.deepseekApiKey);
  }

  String _buildProductContext() {
    if (products.isEmpty) {
      return 'No products available in the database.';
    }

    final productList = products
        .map(
          (p) =>
              'ID: ${p.id}, Name: ${p.name}, Price: ${p.price} VND, Stock: ${p.stockQuantity}, Category ID: ${p.categoryId}, Description: ${p.description}',
        )
        .join('\n');

    return '''Available products in our pharmacy:
$productList''';
  }

  String _buildSystemPrompt() {
    return '''You are a helpful pharmacy assistant AI that ONLY answers questions about our products. You must follow these rules strictly:

1. ONLY answer questions related to products available in our pharmacy database
2. When users ask about products, provide relevant information from the database
3. If someone asks something NOT related to products, politely refuse and redirect them to product-related questions
4. Always respond in Vietnamese
5. Be helpful and provide product recommendations when appropriate
6. If a product is not available in stock, inform the user and suggest similar alternatives if possible

${_buildProductContext()}

If a user asks about anything that is NOT related to these products, respond with: "Xin lỗi, tôi chỉ có thể trả lời các câu hỏi liên quan đến sản phẩm của chúng tôi. Vui lòng hỏi tôi về các loại thuốc hoặc dụng cụ y tế mà chúng tôi có."''';
  }

  Future<String> chatWithContext(
    String userMessage,
    List<Map<String, String>> conversationHistory,
  ) async {
    try {
      final systemPrompt = _buildSystemPrompt();
      final messages = [
        Message(role: 'system', content: systemPrompt),
        ...conversationHistory.map(
          (msg) => Message(role: msg['role']!, content: msg['content']!),
        ),
        Message(role: 'user', content: userMessage),
      ];

      final response = await _deepseek.createChat(
        messages: messages,
        model: Models.chat.name,
        options: {'temperature': 0.7, 'max_tokens': 1024},
      );

      return response.text;
    } on DeepSeekException catch (e) {
      throw Exception('DeepSeek API Error ${e.statusCode}: ${e.message}');
    } catch (e) {
      throw Exception('Error communicating with AI: $e');
    }
  }
}
