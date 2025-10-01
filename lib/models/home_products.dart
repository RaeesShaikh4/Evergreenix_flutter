class ProductResponse {
  final List<Product> products;

  ProductResponse({required this.products});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      products: (json['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((e) => e.toJson()).toList(),
    };
  }
}

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      thumbnail: json['thumbnail'],
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
      'thumbnail': thumbnail,
    };
  }
}
