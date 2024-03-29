import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:sogamax_canhotos/helpers/canhoto_helper.dart';
import 'package:sogamax_canhotos/models/camera_argument.dart';
import 'package:sogamax_canhotos/models/canhoto.dart';
import 'package:sogamax_canhotos/models/imagem.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {

  CameraController controller;

  bool _open = false;

  List<CameraDescription> cameras;

  _startShot () {

  }

  Future _initCameraController() async {

  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);

    super.initState();
    availableCameras().then((value) {
      if (value.isNotEmpty) {
        controller = CameraController(value[0], ResolutionPreset.high);

        controller.initialize().then((_) {
          cameraArguments = ModalRoute.of(context).settings.arguments;
          setState(() {
            _open = true;
          });
          new Future.delayed(const Duration(seconds: 3), () async {
            try {
              await controller.lockCaptureOrientation();
              await controller.setFocusMode(FocusMode.auto);
              var value = await controller.takePicture();
              if (value != null) {
                value.saveTo(value.path);
                _uploaded(value);
              } else {
                Toast.show("Problemas na leitura da foto", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
              }

              Navigator.pop(context);

              if (cameraArguments.step >= 2) {
                Navigator.pop(context);
              }

            } catch (e) {
              Toast.show(e.toString(), context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
            }
          });
        });
      } else {
        Toast.show("Cameras não disponível", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
    print("DISPOSE");
  }

  @override
  Widget build(BuildContext context) {
    if (! _open) {
      return Container();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RotatedBox(
        quarterTurns: 0,
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPlatform.instance.buildPreview(controller.cameraId),
        ),
      )
    );
  }

  CameraArguments cameraArguments;

  _uploaded (XFile file) async {
    try {

      var c = await CanhotoHelper().get(cameraArguments.barcode);

      if (c != null) {
        c.image = file.path;
        c.data = DateTime.now().millisecondsSinceEpoch;

        new CanhotoHelper().update(c).then((value) {
          _upload(file, c);
        });
      } else {
        var canhoto = new Canhoto(
            image: file.path,
            numero: int.parse(cameraArguments.barcode).toString(),
            transmitido: false,
            data: DateTime.now().millisecondsSinceEpoch
        );
        new CanhotoHelper().insert(canhoto).then((value) {
          _upload(file, value);
        });
      }
    } catch (e) {
      Toast.show(e.toString(), context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }
  }

  _upload (XFile file, Canhoto value) {

    Imagem().upload(file, value).then((_) {
      value.transmitido = true;
      CanhotoHelper().update(value);
    });
  }

}
