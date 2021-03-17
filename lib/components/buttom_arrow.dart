import 'package:flutter/material.dart';

class ButtonArrow extends StatelessWidget {

  ButtonArrow(this.textButton, {
    this.keypress,
    this.colorButton = Colors.blue
  });

  final Function keypress;
  final String textButton;
  final Color colorButton;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlatButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        splashColor: colorButton,
        color: colorButton,
        child: new Row(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                this.textButton,
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
                    color: colorButton,
                  ),
                  onPressed: keypress,
                ),
              ),
            )
          ],
        ),
        onPressed: keypress,
      ),
    );
  }
}
