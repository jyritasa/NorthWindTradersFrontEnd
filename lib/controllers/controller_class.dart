import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:northwind/models/shared/model_class.dart';

import '../conf/logger.dart';

///Controller with HTTP call methods [getAll], [getByID], [post] and [delete]
///for retrieving, modifying and deleting data with the backend.
///
///Infers routes from the [Model] name.
///Requires the corresponding .fromJson method of the model due to limitations of
///Dart as a language not allowing for inherited Constructors.
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
      if (e.response != null && kDebugMode) {
        final dynamic data = e.response!.data;
        logger.e("${e.response?.statusCode}: ${e.response?.statusMessage}");
        logger.e("Response Data: $data");
      }
      rethrow;
    } catch (e, s) {
      if (kDebugMode) {
        logger.e(e.toString());
        logger.e(s.toString());
      }
      rethrow;
    }
    return [];
  }

  Future<T?> getByID(dynamic id) async {
    try {
      //for example: www.example.com/models/1
      Response response = await _dio.get('$_url/${_modelName}s/$id');
      if (response.statusCode == 200) {
        return fromJson(response.data);
      }
    } on DioException catch (e) {
      if (e.response != null && kDebugMode) {
        final dynamic data = e.response!.data;
        logger.e("${e.response?.statusCode}: ${e.response?.statusMessage}");
        logger.e("Response Data: $data");
      }
      rethrow;
    } catch (e, s) {
      if (kDebugMode) {
        logger.e(e.toString());
        logger.e(s.toString());
      }
      rethrow;
    }
    return null;
  }

  ///Returns List<T> where [Model]s have only required or couple of fields.
  ///
  ///For example: Customers has customerId and companyName fields.
  Future<List<T>> getMinimal() async {
    try {
      //for example: www.example.com/models/modelminimal
      Response response =
          await _dio.get('$_url/${_modelName}s/${_modelName}minimal');
      if (response.statusCode == 200) {
        return List<T>.from(
          response.data.map(
            (data) => fromJson(data),
          ),
        );
      }
    } on DioException catch (e) {
      if (e.response != null && kDebugMode) {
        final dynamic data = e.response!.data;
        logger.e("${e.response?.statusCode}: ${e.response?.statusMessage}");
        logger.e("Response Data: $data");
      }
      rethrow;
    } catch (e, s) {
      if (kDebugMode) {
        logger.e(e.toString());
        logger.e(s.toString());
      }
      rethrow;
    }
    return [];
  }

  Future<T?> post(T model) async {
    try {
      if (kDebugMode) logger.d("Sending: ${json.encode(model.toJson())}");
      Response response =
          //for example: www.example.com/models/
          await _dio.post('$_url/${_modelName}s',
              data: model.toJson(),
              options: Options(headers: {
                'Content-Type': 'application/json',
              }));
      if (response.statusCode == 201) {
        if (kDebugMode) logger.i("Post Success!");
        return fromJson(response.data);
      }
    } on DioException catch (e) {
      if (e.response != null && kDebugMode) {
        final dynamic data = e.response!.data;
        logger.e("${e.response?.statusCode}: ${e.response?.statusMessage}");
        logger.e("Response Data: $data");
      }
      rethrow;
    } catch (e, s) {
      if (kDebugMode) {
        logger.e(e.toString());
        logger.e(s.toString());
      }
      rethrow;
    }
    return null;
  }

  Future<T?> update(dynamic id, T model) async {
    try {
      if (kDebugMode) logger.d("Updating: ${json.encode(model.toJson())}");
      Response response = await _dio.put('$_url/${_modelName}s/$id',
          data: model.toJson(),
          options: Options(headers: {
            'Content-Type': 'application/json',
          }));
      if (response.statusCode == 200) {
        if (kDebugMode) logger.i("Update Success!");
        return fromJson(response.data);
      }
    } on DioException catch (e) {
      if (e.response != null && kDebugMode) {
        final dynamic data = e.response!.data;
        logger.e("${e.response?.statusCode}: ${e.response?.statusMessage}");
        logger.e("Response Data: $data");
      }
      rethrow;
    } catch (e, s) {
      if (kDebugMode) {
        logger.e(e.toString());
        logger.e(s.toString());
      }
      rethrow;
    }
    return null;
  }

  Future<bool> delete(dynamic id) async {
    try {
      Response response = await _dio.delete('$_url/${_modelName}s/$id');
      if (response.statusCode == 204) {
        logger.i("Delete Success!");
        return true;
      }
    } on DioException catch (e) {
      if (e.response != null && kDebugMode) {
        final dynamic data = e.response!.data;
        logger.e("${e.response?.statusCode}: ${e.response?.statusMessage}");
        logger.e("Response Data: $data");
      }
      rethrow;
    } catch (e, s) {
      if (kDebugMode) {
        logger.e(e.toString());
        logger.e(s.toString());
      }
      rethrow;
    }
    return false;
  }
}
