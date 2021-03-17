import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:sogamax_canhotos/api/api_base.dart';
import 'canhoto.dart';

class Imagem extends ApiBase {

  Future<Response> upload(XFile file, Canhoto canhoto) async {
    String fileName = file.path.split('/').last;

    FormData formData = FormData.fromMap({
      "canhoto": await MultipartFile.fromFile(
          file.path, filename:fileName,
          contentType: new MediaType("image", "jpeg")
      ),
      "id": canhoto.numero
    });

    Dio dio = new Dio();

    return await dio.post("$uri/api/canhotos/upload",
        data: formData,
        options: Options(
            headers: await getHeader()
        )
    );
  }

}