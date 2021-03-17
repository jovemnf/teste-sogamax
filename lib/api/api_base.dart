import 'package:sogamax_canhotos/models/auth.dart';

import '../helpers/me_helper.dart';

class ApiBase {
  String uri = "http://209.126.11.40:8000";

  Future<Map<String, String>> getHeader ({Auth me = null}) async {

    if (me == null) {
      me = await AuthHelper().get();
    }

    Map<String, String> headers = Map<String, String>();
    headers["authorization"] = "Bearer ${me.access_token}";
    return headers;
  }
}