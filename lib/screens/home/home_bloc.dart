import 'dart:async';

import 'package:sogamax_canhotos/helpers/canhoto_helper.dart';

class HomeBloc {
  HomeBloc();

  var _controller = StreamController();

  fetch () async {
    CanhotoHelper().getLasts().then((value) {
      _controller.sink.add(value);
    });
  }

  get stream => _controller.stream;

  close () => _controller.close();
}