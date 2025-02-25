class ProductModel {
  final String productId;
  final String catId;
  final String productName;
  final String catName;
  final String salePrice;
  final String fullPrice;
  final String productImg;
  final String deliveryTime;
  final bool isSale;
  final String productDescription;
  final dynamic createdAt;
  final dynamic updatedAt;

  ProductModel({
    required this.productId,
    required this.catId,
    required this.productName,
    required this.catName,
    required this.salePrice,
    required this.fullPrice,
    required this.productImg,
    required this.deliveryTime,
    required this.isSale,
    required this.productDescription,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'catId': catId,
      'productName': productName,
      'catName': catName,
      'salePrice': salePrice,
      'fullPrice': fullPrice,
      'productImg': productImg,
      'deliveryTime': deliveryTime,
      'isSale': isSale,
      'productDescription': productDescription,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'] ?? '',
      catId: json['catId'] ?? '',
      productName: json['productName'] ?? '',
      catName: json['catName'] ?? '',
      salePrice: json['salePrice'] ?? '',
      fullPrice: json['fullPrice'] ?? '',
      productImg: json['productImg'] ?? '',
      deliveryTime: json['deliveryTime'] ?? '',
      isSale: json['isSale'] ?? false,
      productDescription: json['productDescription'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
