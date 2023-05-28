class ProductEntity {
  final String code;
  final bool recent;
  final String title;
  final List weight;
  final List color;
  final double wage;
  final int discount;
  final List description;
  final List imageUrls;

  ProductEntity(
      {required this.imageUrls,
      required this.code,
      required this.recent,
      required this.title,
      required this.weight,
      required this.color,
      required this.wage,
      required this.discount,
      required this.description});
  ProductEntity.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        weight = json['weight'],
        color = json['color'],
        wage = json['wage'],
        title = json['title'],
        discount = json['discount'],
        description = json['description'],
        recent = json['recent'],
        imageUrls = json['image_url'];
}
