import 'package:flutter/material.dart';
import 'package:sogamax_canhotos/helpers/me_helper.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check();
  }

  check () async {
    var auth = await AuthHelper().get();
    if (auth != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12,),
              Text("Por favor aguarde")
            ],
          ),
        ),
      ),
    );
  }
}
