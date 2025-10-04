import 'package:dio/dio.dart';
import 'package:spendwise_1/config/constants/Environment.dart';
import 'package:spendwise_1/domain/datasource/category_datasource.dart';
import 'package:spendwise_1/domain/entity/category.dart';
import 'package:spendwise_1/infrastructure/mappers/category_mapper.dart';
import 'package:spendwise_1/infrastructure/models/category_model.dart';

class CategoryDatasourceImpl implements CategoryDatasource {
  final Dio dio;

  CategoryDatasourceImpl() : dio = Dio(BaseOptions(baseUrl: Environment.apiBaseUrl));

  @override
  Future<List<Category>> getCategories() async {
    try {
      final response = await dio.get('/category');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        final models = jsonList.map((json) => CategoryModel.fromJson(json)).toList();
        return CategoryMapper.toEntities(models);
      } else {
        throw Exception('Error al cargar las categorías: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la petición: $e');
    }
  }
}