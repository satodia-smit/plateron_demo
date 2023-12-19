class ProductDataModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
   int count; // Added count field

  ProductDataModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.count=0, // Default count to 0

  });

  factory ProductDataModel.fromJson(Map<String, dynamic> json) {
    return ProductDataModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      count: json['count'] as int
    );
  }
  @override
  String toString() {
    return 'ProductDataModel{id: $id, name: $name, description: $description, price: $price, imageUrl: $imageUrl, count: $count}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'count': count
    };
  }
}
