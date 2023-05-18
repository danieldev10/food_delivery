
import 'package:flutter/material.dart';
import 'package:food_delivery/jsonobjects/FoodDescription.dart';

class JsonObjectTesting extends StatefulWidget {
  @override
  _JsonObjectTestingState createState() => _JsonObjectTestingState();
}

class _JsonObjectTestingState extends State<JsonObjectTesting> {

  FoodDescription foodDescription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foodDescription = FoodDescription.defaultc();
    //foodDescription.jEncoder();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
