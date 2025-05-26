import 'package:flutter/material.dart';

class CardView extends StatefulWidget {
  final Icon _icon;
  final String _text;
  final double _textSize;
  final Function() _function;
  final Color _color;

  CardView(this._icon, this._color, this._text, this._textSize, this._function);

  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      color: widget._color,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget._color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          padding: const EdgeInsets.all(7.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: widget._icon,
            ),
            Text(
              widget._text,
              style: TextStyle(
                color: Colors.white,
                fontSize: widget._textSize,
              ),
            ),
          ],
        ),
        onPressed: widget._function,
      ),
    );
  }
}
