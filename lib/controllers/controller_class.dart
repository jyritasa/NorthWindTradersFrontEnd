import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:northwind/models/shared/model_class.dart';

import '../conf/logger.dart';

///Controller with HTTP call methods [getAll], [getByID] for retrieving data from the backend.
///
///Infers routes from the [Model] name.
class Controller<T extends Model> {
  Controller({required this.fromJson});
  //Due to limitations of Dart lang, you cannot inherit named constructors from classes.
  //That is why fromJson() constructor needs to be supplied as a parameter.
  final T Function(Map<String, dynamic> json) fromJson;

  final Dio _dio = Dio();
  final String? _url = dotenv.env['URL'];
  final String _modelName = T.toString();

  Future<List<T>> getAll() async {
    try {
      //for example: www.example.com/models/
      Response response = await _dio.get('$_url/${_modelName}s');
      if (response.statusCode == 200) {
        return List<T>.from(
          response.data.map(
            (data) => fromJson(data),
          ),
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        logger.e("${e.response?.statusCode}:\n${e.response?.statusMessage}");
        rethrow;
      }
    } catch (e, s) {
      logger.e(e.toString());
      logger.e(s.toString());
      rethrow;
    }
    return [];
  }

  Future<T?> getByID(int id) async {
    try {
      //for example: www.example.com/models/1
      Response response = await _dio.get('$_url/${_modelName}s/$id');
      if (response.statusCode == 200) {
        return fromJson(response.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        logger.e("${e.response?.statusCode}:\n${e.response?.statusMessage}");
        rethrow;
      }
    } catch (e, s) {
      logger.e(e.toString());
      logger.e(s.toString());
      rethrow;
    }
    return null;
  }
}
