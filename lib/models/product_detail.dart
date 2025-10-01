class ProductDetail {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final double weight;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<String> images;
  final String thumbnail;

  ProductDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.images,
    required this.thumbnail,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      brand: json['brand'] ?? '',
      sku: json['sku'] ?? '',
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      warrantyInformation: json['warrantyInformation'] ?? '',
      shippingInformation: json['shippingInformation'] ?? '',
      availabilityStatus: json['availabilityStatus'] ?? '',
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      thumbnail: json['thumbnail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'tags': tags,
      'brand': brand,
      'sku': sku,
      'weight': weight,
      'warrantyInformation': warrantyInformation,
      'shippingInformation': shippingInformation,
      'availabilityStatus': availabilityStatus,
      'images': images,
      'thumbnail': thumbnail,
    };
  }
}

