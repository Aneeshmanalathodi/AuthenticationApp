import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({required super.id, required super.name, required super.image});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['title'],
      image: "${ApiConstants.imageBaseUrl}${json['image']}",
    );
  }
}
