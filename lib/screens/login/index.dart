import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sogamax_canhotos/api/auth.dart';
import 'package:sogamax_canhotos/helpers/canhoto_helper.dart';
import 'package:sogamax_canhotos/helpers/me_helper.dart';
import 'package:sogamax_canhotos/models/auth.dart';
import 'package:toast/toast.dart';

import 'login_form.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final usernameControler = TextEditingController();
  final passwordControler = TextEditingController();

  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        body: LoadingOverlay(
          child: LoginForm(
            backgroundColor: Colors.white,
            logo: Image.asset("assets/logo.png"),
            onPressed: _onpressed,
            buttonColor: Colors.blue,
            primaryColor: Colors.blue,
            usernameController: usernameControler,
            passwordController: passwordControler,
          ),
          isLoading: _saving
        ),
      ),
    );
  }

  _onpressed () async {
    try {
      setState(() {
        _saving = true;
      });
      var res = await AuthApi().autentica(usernameControler.text, passwordControler.text);

      var body = res.data;

      await AuthHelper().reset();
      await CanhotoHelper().reset();
      await AuthHelper().insert(new Auth(body['nome'], body['access_token']));

      Navigator.pushReplacementNamed(context, '/home');
      setState(() {
        _saving = false;
      });
    } on DioError catch(e) {
      print(e);
      setState(() {
        _saving = false;
      });
      if (e.response != null) {
        if (e.response.statusCode == 401) {
          Toast.show("Usuário ou senha incorreta!", context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP, backgroundColor: Colors.red);
        } else {
          Toast.show("Problemas no login!", context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP, backgroundColor: Colors.red);
        }
      } else {
        Toast.show("Problemas para solicitar o login!", context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP, backgroundColor: Colors.red);
      }
    }
  }
}
