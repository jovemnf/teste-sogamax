import 'package:flutter/material.dart';
import 'package:sogamax_canhotos/helpers/canhoto_helper.dart';
import 'package:sogamax_canhotos/helpers/me_helper.dart';
import 'package:sogamax_canhotos/models/canhoto.dart';
import 'package:sogamax_canhotos/screens/home/home_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  HomeBloc _bloc = HomeBloc();

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

      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image.asset("assets/logo.png"),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () {
                AuthHelper().reset().then((value) {
                  Navigator.pushReplacementNamed(context, '/login');
                });
              },
            ),
          ],
        ),
      ),

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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _build (List<Canhoto> list) {
    print("BUILD");
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
