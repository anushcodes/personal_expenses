import 'package:flutter/material.dart';
String dateToString(DateTime date){
  String val = date.toString();
  int index = val.indexOf(' ');
  String dateVal = val.substring(0,index);
  //final chars = Characters(dateVal);  
  //dateVal=chars.toList().reversed.join();
  return dateVal;
}
// Just for implementation purpose