class Product {
  final String id;
  final String? imageUrl;
  final String title;
  final String location;
  final String price;
  final int likes;
  final int views;
  final int comments;
  final String category;
  final String condition;
  final String seller;
  final String postedDate;
  final String status; // 'available' or 'sold'

  const Product({
    required this.id,
    this.imageUrl,
    required this.title,
    required this.location,
    required this.price,
    required this.likes,
    required this.views,
    required this.comments,
    required this.category,
    required this.condition,
    required this.seller,
    required this.postedDate,
    this.status = 'available',
  });
}

class ChatItem {
  final String id;
  final String username;
  final String timestamp;
  final String messagePreview;
  final bool hasImage;
  final String? imageUrl;

  const ChatItem({
    required this.id,
    required this.username,
    required this.timestamp,
    required this.messagePreview,
    this.hasImage = false,
    this.imageUrl,
  });
}

class Message {
  final String id;
  final String text;
  final String timestamp;
  final bool isSent;
  final String? senderName;

  const Message({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isSent,
    this.senderName,
  });
}

class AppNotification {
  final String id;
  final String type; // message, like, view, sale, offer, system
  final String title;
  final String message;
  final String timestamp;
  bool isRead;
  final String? avatar;
  final String? productImage;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
    this.avatar,
    this.productImage,
  });
}
