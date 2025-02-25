class CategoryModel {
  final String catId;
  final String catName;
  final String category;
  final String createdAt;
  final String updatedAt;

  CategoryModel({
    required this.catId,
    required this.catName,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'catId': catId,
      'catName': catName,
      'category': category,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> json) {
    return CategoryModel(
      catId: json['catId'] ,
      catName: json['catName'] ,
      category: json['category'] ,
      createdAt: json['createdAt'] ,
      updatedAt: json['updatedAt'],
    );
  }
}
