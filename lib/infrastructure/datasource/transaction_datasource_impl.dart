import 'package:dio/dio.dart';
import 'package:spendwise_1/config/constants/Environment.dart';
import 'package:spendwise_1/domain/datasource/transaction_datasource.dart';
import 'package:spendwise_1/domain/entity/monthly_totals.dart';
import 'package:spendwise_1/domain/entity/totals.dart';
import 'package:spendwise_1/domain/entity/totals_by_category.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';
import 'package:spendwise_1/infrastructure/mappers/monthly_totals_mapper.dart';
import 'package:spendwise_1/infrastructure/mappers/totals_by_category_mapper.dart';
import 'package:spendwise_1/infrastructure/mappers/totals_mapper.dart';
import 'package:spendwise_1/infrastructure/mappers/transaction_mapper.dart';
import 'package:spendwise_1/infrastructure/models/monthly_totals_model.dart';
import 'package:spendwise_1/infrastructure/models/totals_by_category_model.dart';
import 'package:spendwise_1/infrastructure/models/totals_model.dart';
import 'package:spendwise_1/infrastructure/models/transaction_model.dart';

class TransactionDatasourceImpl implements TransactionDatasource {
  final Dio dio;

  TransactionDatasourceImpl()
    : dio = Dio(BaseOptions(baseUrl: Environment.apiBaseUrl));

  @override
  Future<List<Transaction>> getTransactions() async {
    try {
      final response = await dio.get('/transaction');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        final models = jsonList
            .map((json) => TransactionModel.fromJson(json))
            .toList();
        return TransactionMapper.toEntities(models);
      } else {
        throw Exception(
          'Error al cargar las transacciones: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error en la petición: $e');
    }
  }

  @override
  Future<Totals> getTotals(int year, int month) async {
    try {
      final response = await dio.get(
        '/transaction/totals?year=$year&month=$month',
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        if (jsonList.isEmpty) {
          return Totals(income: 0, expense: 0);
        }
        final model = TotalsModel.fromJson(
          jsonList.first as Map<String, dynamic>,
        );
        return TotalsMapper.toEntity(model);
      } else {
        throw Exception('Error al cargar los totales: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la petición de totales: $e');
    }
  }

  @override
  Future<String> createTransaction(Transaction transaction) async {
    try {
      final model = TransactionMapper.toModel(transaction);
      final requestBody = model.toCreateJson();
      final response = await dio.post('/transaction', data: requestBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final message = response.data['message'] as String;
        return message;
      } else {
        throw Exception(
          'Error al crear la transacción: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error en la petición de creación: $e');
    }
  }

  @override
  Future<List<TotalsByCategory>> getTotalsByCategory(
    int year,
    int month,
  ) async {
    try {
      final response = await dio.get(
        '/transaction/totals/by-category?year=$year&month=$month',
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        final models = jsonList
            .map((json) => TotalsByCategoryModel.fromJson(json))
            .toList();
        return TotalsByCategoryMapper.toEntities(models);
      } else {
        throw Exception(
          'Error al cargar los totales por categoría: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error en la petición de totales por categoría: $e');
    }
  }

  @override
  Future<List<MonthlyTotals>> getMonthlyTotals(int year) async {
    try {
      final response = await dio.get('/transaction/totals/monthly?year=$year');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        final models = jsonList
            .map((json) => MonthlyTotalsModel.fromJson(json))
            .toList();
        return MonthlyTotalsMapper.toEntities(models);
      } else {
        throw Exception(
          'Error al cargar los totales mensuales: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error en la petición de totales mensuales: $e');
    }
  }
}
