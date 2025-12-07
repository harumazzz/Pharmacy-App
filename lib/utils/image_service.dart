import 'dart:math';

class ProductImageService {
  static const List<String> medicineImages = [
    'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300&h=300&fit=crop',
    'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=300&h=300&fit=crop',
    'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=300&h=300&fit=crop',
    'https://images.unsplash.com/photo-1550572017-5cb3b7c3bbe7?w=300&h=300&fit=crop',
    'https://images.unsplash.com/photo-1628771065518-0d82f1938462?w=300&h=300&fit=crop',
    'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=300&h=300&fit=crop',
    'https://images.unsplash.com/photo-1559181567-c3190ca9959b?w=300&h=300&fit=crop',
    'https://images.unsplash.com/photo-1628771065658-2ee2b8581ca4?w=300&h=300&fit=crop',
    'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=300&h=300&fit=crop',
    'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300&h=300&fit=crop',
  ];

  static String getRandomImage() {
    final random = Random();
    return medicineImages[random.nextInt(medicineImages.length)];
  }

  static String getImageByType(String productName) {
    final name = productName.toLowerCase();

    if (name.contains('vitamin') || name.contains('omega')) {
      return 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300&h=300&fit=crop';
    } else if (name.contains('máy') || name.contains('nhiệt kế')) {
      return 'https://images.unsplash.com/photo-1628771065658-2ee2b8581ca4?w=300&h=300&fit=crop';
    } else if (name.contains('băng') || name.contains('bông')) {
      return 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=300&h=300&fit=crop';
    } else {
      return 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300&h=300&fit=crop';
    }
  }

  static String getPlaceholder(String productName) {
    final encodedName = Uri.encodeComponent(productName);
    return 'https://via.placeholder.com/300x300/0066CC/FFFFFF?text=$encodedName';
  }
}
