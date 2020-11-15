import 'package:flutter/material.dart';

const textInputDecoration =  InputDecoration(
    hintStyle: TextStyle(color: Colors.white,fontFamily: "WorkSansLight", fontSize: 15.0),
    filled: true,
    fillColor: Colors.white24,
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(90.0)),
        borderSide: BorderSide(color: Colors.white24, width: 0.5)
    ),
);

const textInputDecorantionPerfil = InputDecoration(
    hintStyle: TextStyle(
        color: Colors.black, fontFamily: "WorkSansLight", fontSize: 15.0),
    filled: true,
    fillColor: Colors.white24,
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black)
    ),
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.deepOrange),
    )
);