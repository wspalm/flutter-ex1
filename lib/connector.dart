import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Food.dart';

const server_url = 'http://192.168.1.41:1880/getinfo';

//implement function that will return content body
//from server's response
get_data() async {
  //get data
  var output = await http.get(Uri.parse(server_url));

  if (output.statusCode == 200) {
    return output.body;
  } //end of if
  else {
    return null;
  } //end of else
} //end of get data function

//create functon that return future list
//in this function I will use get_data function to get data

Future<List<Food>> foods() async {
  var _info = await get_data();
  //check if the get_data function return null
  if (_info == null) {
    print("data not yet arrive");
    return [];
  } //end of if
  else {
    //decode json data
    //and map it into the local class <Food>
    //also make it as list
    var mapping = json.decode(_info) as List;
    //return all
    return mapping.map((e) => Food.fromMap(e)).toList();
  } //end of else
} //end of function future of all food

Future<List<Food>> main_dishes() async {
  var _info = await get_data();
  if (_info == null) {
    return [];
  } //end of if
  else {
    var mapping = json.decode(_info) as List;
    List<Food> _list = mapping.map((e) => Food.fromMap(e)).toList();
    List<Food> filtered_list =
        _list.where((element) => element.type == 'main').toList();
    return filtered_list;
  } //end of else
} //end of function main dish

Future<List<Food>> desserts() async {
  var _info = await get_data();
  if (_info == null) {
    return [];
  } //end of if
  else {
    var mapping = json.decode(_info) as List;
    List<Food> _list = mapping.map((e) => Food.fromMap(e)).toList();
    return _list.where((element) => element.type == 'dessert').toList();
  } //end of else
} //end of dessert

Future<List<Food>> beverages() async {
  var _info = await get_data();
  if (_info == null) {
    return [];
  } //end of if
  else {
    var mapping = json.decode(_info) as List;
    List<Food> _list = mapping.map((e) => Food.fromMap(e)).toList();
    return _list.where((element) => element.type == 'beverage').toList();
  } //end of else
}

//take in alert function and goTo function
//to be the alert and navigator
void alert(context, String text) {
  final snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
} //end of alert function

void goTo(context, Widget w) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => w),
  );
} //end of goTo function