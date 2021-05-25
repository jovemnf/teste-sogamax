import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {

  final Color primaryColor;
  final Color buttonColor;
  final Color backgroundColor;
  final Widget logo;
  final Function onPressed;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  final FocusNode _usuarioFocus = FocusNode();
  final FocusNode _senhaFocus = FocusNode();
  final showLogo;

  LoginForm({
    Key key,
    this.showLogo = false,
    this.buttonColor = Colors.blue,
    this.primaryColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.logo,
    this.onPressed,
    this.usernameController,
    this.passwordController
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Form(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            showLogo ? Container(

              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  top: 80.0,
                  bottom: 40.0
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Center(
                      child: logo,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30,),
                  )
                ],
              ),
            ) : SizedBox(height: 80,),

            Padding(
              padding: const EdgeInsets.only(left: 40.0,top: 44),
              child: Text(
                "USUÁRIO",
                style: TextStyle(color: primaryColor, fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: primaryColor.withOpacity(0.5),
                  width: 1.0,
                ),
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              margin:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Row(
                children: <Widget>[
                  new Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Icon(
                      Icons.person_outline,
                      color: primaryColor,
                    ),
                  ),
                  Container(
                    height: 30.0,
                    width: 1.0,
                    color: primaryColor.withOpacity(0.5),
                    margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                  ),
                  new Expanded(
                    child: TextFormField(
                      autofocus: true,
                      controller: usernameController,
                      style: TextStyle(color: primaryColor),
                      focusNode: _usuarioFocus,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context).requestFocus(_senhaFocus);
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Entre com seu usuário',
                        hintStyle: TextStyle(color: primaryColor),
                      ),
                    ),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 40.0, top: 16),
              child: Text(
                "SENHA",
                style: TextStyle(color: primaryColor, fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: primaryColor.withOpacity(0.5),
                  width: 1.0,
                ),
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              margin:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Row(
                children: <Widget>[
                  new Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Icon(
                      Icons.lock_open,
                      color: primaryColor,
                    ),
                  ),
                  Container(
                    height: 30.0,
                    width: 1.0,
                    color: primaryColor.withOpacity(0.5),
                    margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                  ),
                  new Expanded(
                    child: TextFormField(
                      focusNode: _senhaFocus,
                      style: TextStyle(color: primaryColor),
                      controller: passwordController,
                      onFieldSubmitted: (term) {
                        onPressed();
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Entre com sua senha',
                        hintStyle: TextStyle(color: primaryColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      splashColor: this.buttonColor,
                      color: this.buttonColor,
                      child: new Row(
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "ACESSAR",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          new Expanded(
                            child: Container(),
                          ),
                          new Transform.translate(
                            offset: Offset(15.0, 0.0),
                            child: new Container(
                              padding: const EdgeInsets.all(5.0),
                              child: FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(28.0)),
                                splashColor: Colors.white,
                                color: Colors.white,
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: this.buttonColor,
                                ),
                                onPressed: onPressed,
                              ),
                            ),
                          )
                        ],
                      ),
                      onPressed: onPressed,
                    ),
                  ),
                ],
              ),
            ),

            /*
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: FlatButton(
                      child: Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "ESQUECI A MINHA SENHA!",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => RememberScreen())
                        )
                      },
                    ),
                  ),
                ],
              ),
            ),

             */

          ],
        ),
      ),
    );
  }
}

