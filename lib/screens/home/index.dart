import 'package:flutter/material.dart';
import 'package:sogamax_canhotos/helpers/canhoto_helper.dart';
import 'package:sogamax_canhotos/helpers/me_helper.dart';
import 'package:sogamax_canhotos/models/auth.dart';
import 'package:sogamax_canhotos/models/camera_argument.dart';
import 'package:sogamax_canhotos/models/canhoto.dart';
import 'package:sogamax_canhotos/screens/home/home_bloc.dart';
import 'package:sogamax_canhotos/screens/home/home_drawer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  HomeBloc _bloc = HomeBloc();

  Auth auth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.fetch();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _bloc.fetch();
    }
  }

  void _incrementCounter() async {
    await Navigator.pushNamed(context, '/barcode');
    print("Reload");
    _bloc.fetch();
  }

  final TextEditingController numeroController = new TextEditingController();
  final FocusNode _numeroFocus = FocusNode();

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Canhoto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  controller: numeroController,
                  style: TextStyle(color: Colors.blue),
                  keyboardType: TextInputType.number,
                  focusNode: _numeroFocus,
                  decoration: InputDecoration(
                    hintText: 'Número do Canhoto',
                    hintStyle: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Tirar Foto'),
              onPressed: () {
                Navigator.of(context).pop();
                if (numeroController.text.isNotEmpty) {
                  Navigator.pushNamed(context, '/camera', arguments: CameraArguments(numeroController.text, step: 1),);
                  numeroController.text = "";
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Últimas imagens"),
        centerTitle: true,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _bloc.fetch();
                },
                child: Icon(
                  Icons.update,
                  size: 26.0,
                ),
              )
          ),
        ],
      ),

      drawer: HomeDrawer(),

      body: StreamBuilder(
        stream: _bloc.stream,
        builder: (BuildContext context, snap) {
          if (snap.hasData) {
            return _build(snap.data);
          }

          if (snap.hasError) {
            return Center(child: Text("Problemas para buscar os alertas!"));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              heroTag: 'Icons.keyboard',
              onPressed: _showMyDialog,
              backgroundColor: Colors.red,
              tooltip: 'Increment',
              child: Icon(Icons.keyboard),
            ),
          ),
          Positioned(
            bottom: 90,
            right: 10,
            child: FloatingActionButton(
              heroTag: 'Icons.camera_rear',
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: Icon(Icons.camera_rear),
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _build (List<Canhoto> list) {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Colors.black,
        ),
        itemCount: list.length,
        itemBuilder: (context, idx) {

          return Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 8),

            child: ListTile(
              leading: CircleAvatar(
                child: list[idx].transmitido ? Icon(Icons.check_circle_sharp) : Icon(Icons.cancel),
              ),
              subtitle: Text(list[idx].numero),
              title: Text(list[idx].dataDMY()),
            ),
          );

        }
    );
  }

}
