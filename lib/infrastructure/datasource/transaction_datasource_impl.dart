import 'package:dio/dio.dart';
import 'package:spendwise_1/config/constants/Environment.dart';
import 'package:spendwise_1/domain/datasource/transaction_datasource.dart';
import 'package:spendwise_1/domain/entity/totals.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';
import 'package:spendwise_1/infrastructure/mappers/totals_mapper.dart';
import 'package:spendwise_1/infrastructure/mappers/transaction_mapper.dart';
import 'package:spendwise_1/infrastructure/models/totals_model.dart';
import 'package:spendwise_1/infrastructure/models/transaction_model.dart';

class TransactionDatasourceImpl implements TransactionDatasource {
  final Dio dio;

  TransactionDatasourceImpl() : dio = Dio(BaseOptions(baseUrl: Environment.apiBaseUrl));
  
  @override
  Future<List<Transaction>> getTransactions() async {
    try {
      final response = await dio.get('/transaction');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        final models = jsonList.map((json) => TransactionModel.fromJson(json)).toList();
        return TransactionMapper.toEntities(models);
      } else {
        throw Exception('Error al cargar las transacciones: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la petición: $e');
    }
  }

  @override
  Future<Totals> getTotals(int year, int month) async {
    try {
      final response = await dio.get('/transaction/totals?year=$year&month=$month');
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        if (jsonList.isEmpty) {
          throw Exception('No se recibieron datos de los totales.');
        }
        final model = TotalsModel.fromJson(jsonList.first as Map<String, dynamic>);
        return TotalsMapper.toEntity(model);
      } else {
        throw Exception('Error al cargar los totales: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la petición de totales: $e');
    }
  }
}