import 'package:sogamax_canhotos/api/api_base.dart';
import 'package:dio/dio.dart';

class AuthApi extends ApiBase {

  Future<Response> autentica (String username, String password) async {
    Dio dio = new Dio();
    var url = '$uri/api/auth';

    var param = {
      "usuario": username,
      "senha": password
    };

    return await dio.post(url, data: param);
  }

}