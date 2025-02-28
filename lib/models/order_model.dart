class OrderModel {
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
  int productQuantity;
  num productTotalPrice;
  final String customerId;
  final bool status;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerDeviceId;

  OrderModel({
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
    required this.productQuantity,
    required this.productTotalPrice,
    required this.customerId,
    required this.status,
    required this.customerPhone,
    required this.customerName,
    required this.customerAddress,
    required this.customerDeviceId,
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
      'productQuantity': productQuantity,
      'productTotalPrice': productTotalPrice,
      'customerId': customerId,
      'status': status,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'customerDeviceId': customerDeviceId,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> json) {
    print(json);
    return OrderModel(
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
      productQuantity: json['productQuantity'],
      productTotalPrice: json['productTotalPrice'],
      customerId: json['customerId'],
      status: json['status'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerAddress: json['customerAddress'],
      customerDeviceId: json['customerDeviceId'],
    );
  }
}
