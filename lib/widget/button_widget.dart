import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    @required this.text,
    @required this.onClicked,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => RaisedButton(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
        shape: StadiumBorder(),
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textColor: Colors.white,
        onPressed: onClicked,
      );
}

class IButtonWidget extends StatelessWidget {
  final String imagepath;
  final VoidCallback onClicked;

  const IButtonWidget({
    @required this.imagepath,
    @required this.onClicked,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => RaisedButton(
        child: Image.asset(imagepath),
        shape: CircleBorder(side: BorderSide(width: 20, color: Colors.green)),
        color: Colors.white,
        // color: Theme.of(context).primaryColor,
        // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // textColor: Colors.white,
        onPressed: onClicked,
      );
}
