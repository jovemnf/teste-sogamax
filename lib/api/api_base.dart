import 'package:sogamax_canhotos/models/auth.dart';

import '../helpers/me_helper.dart';

class ApiBase {
  String uri = "http://canhotos.sogamax.com.br:9970";

  Future<Map<String, String>> getHeader ({Auth me = null}) async {

    if (me == null) {
      me = await AuthHelper().get();
    }

    Map<String, String> headers = Map<String, String>();
    headers["authorization"] = "Bearer ${me.access_token}";
    return headers;
  }
}