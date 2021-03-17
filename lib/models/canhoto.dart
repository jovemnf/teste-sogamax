import 'package:sogamax_canhotos/helpers/canhoto_helper.dart';
import 'package:intl/intl.dart';

class Canhoto {
  String numero;
  String image;
  bool transmitido;
  int data;

  Canhoto({
    this.numero,
    this.image,
    this.data,
    this.transmitido: false
  });

  @override
  String toString() {
    return '$numero: $image';
  }

  Canhoto.fromMap(Map map) {
    numero = map[numeroColumn];
    image = map[imageColumn];
    data = map[dataColumn];
    transmitido = map[transmitidoColumn] == 1;
  }

  String dataDMY() {
    try {
      if (data == null) {
        data = 0;
      }
      var datas = DateTime.fromMillisecondsSinceEpoch(data);
      var format = new DateFormat("dd-MM-yyyy HH:mm:ss");
      return format.format(datas);
    } catch (e) {
      print(e);
    }
    return null;
  }

  String dataYMD() {
    try {
      if (data == null) {
        data = 0;
      }
      var datas = DateTime.fromMillisecondsSinceEpoch(data);
      var format = new DateFormat("yyyy-MM-dd HH:mm:ss");
      return format.format(datas);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'numero': numero,
      'image': image,
      'transmitido': transmitido ? 1 : 0,
      'data': data
    };
  }

}
