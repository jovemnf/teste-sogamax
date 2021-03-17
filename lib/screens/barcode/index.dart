import 'dart:async';
import 'dart:io';
import 'package:sogamax_canhotos/helpers/canhoto_helper.dart';
import 'package:sogamax_canhotos/models/canhoto.dart';
import 'package:sogamax_canhotos/models/imagem.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:camera_camera/camera_camera.dart';

class BarcodePage extends StatefulWidget {
  @override
  _BarcodePage createState() => _BarcodePage();
}

class _BarcodePage extends State<BarcodePage> {
  String _scanBarcode = null;

  @protected
  void initState() {
    super.initState();

    new Future.delayed(const Duration(seconds: 1), () {
      scanBarcodeNormal();
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancelar", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      Toast.show("Failed to get platform version.", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    print("barcodeScanRes: ${barcodeScanRes}");

    setState(() {
      if (barcodeScanRes != "-1") {
        _scanBarcode = barcodeScanRes;
        //Navigator.pushNamed(context, '/camera', arguments: CameraArguments(_scanBarcode),);
      } else {
        _scanBarcode = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
        appBar: AppBar(title: const Text('Barcode scan')),
        body: Center(
          child:  _scanBarcode == null ? CircularProgressIndicator() : Text(_scanBarcode),
        ),
        /*
        floatingActionButton: _scanBarcode != null ? FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/camera', arguments: CameraArguments(_scanBarcode),);
          },
          tooltip: 'Increment',
          child: Icon(Icons.forward),
        ) : SizedBox()

         */
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => Camera(
                    onFile: (File file) {
                      //When take foto you should close camera
                      _uploaded(file);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      setState(() {});
                    },
                  )));
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  _uploaded (File file) async {
    try {
      var c = await CanhotoHelper().get(_scanBarcode);

      if (c != null) {
        c.image = file.path;
        c.data = DateTime.now().millisecondsSinceEpoch;

        new CanhotoHelper().update(c).then((value) {
          _upload(file, c);
        });
      } else {
        var canhoto = new Canhoto(
            image: file.path,
            numero:  _scanBarcode,
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

  _upload (File file, Canhoto value) {
    Imagem().upload(file, value).then((_) {
      value.transmitido = true;
      CanhotoHelper().update(value);
    });
  }

}
