import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Widget textField({String hint, Function SaveVal(String s), bool error}) {
  return Expanded(
    child: TextField(
      style: TextStyle(color: Colors.black),
      onChanged: (val) {
        SaveVal(val);
      },
      keyboardType: TextInputType.numberWithOptions(signed: false),
      decoration: InputDecoration(
        icon: error
            ? Icon(
                Icons.error,
                color: Colors.yellow,
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 11,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
      ),
    ),
  );
}

Container SysInformationsCard(
    {String informations, Widget widget, String result, double width}) {
  return Container(
    width: width,
    height: 50,
    margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
    decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(
            color: Colors.white, width: 2 //error ? Colors.red : activeColour
            )),
    child: Row(
      children: <Widget>[
        FittedBox(
          child: Text(
            informations,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        if (widget != null) widget,
        if (result != null && result != "")
          FittedBox(
              child: Text(
            result,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          )),
      ],
    ),
  );
}

double CheckingDouble(String n, bool error) {
  double d = -1;
  try {
    List<String> a = n.split("/");
    if (a.length == 1)
      d = double.parse(n);
    else
      d = double.parse(a[0]) / double.parse(a[1]);
  } catch (e) {
    error = true;
  }
  return d;
}

int CheckingInt(String n, bool error) {
  int out = -1;
  try {
    out = int.parse(n);
  } catch (e) {
    error = true;
  }
  return out;
}

Alert alert(String ErrorMessage, context) {
  return Alert(
    context: context,
    type: AlertType.error,
    style: AlertStyle(
        titleStyle: TextStyle(
          color: Colors.red,
        ),
        descStyle: TextStyle(
          color: Colors.white,
        )),
    title: "WRONG INPUT",
    desc: ErrorMessage,
    buttons: [
      DialogButton(
        child: Text(
          "CANCEL",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  );
}
