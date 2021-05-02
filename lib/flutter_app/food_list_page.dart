import 'package:final_app/database_food.dart';
import 'package:final_app/flutter_app/food_form_page.dart';
import 'package:final_app/models_objects/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class FoodListPage extends StatefulWidget{
  @override
  _FoodListPageState createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {

  List<Task>? listFood;

  AppBar _appBar() {
    return AppBar(title: Text("Food List"));
  }

  Widget _body() {
    if (listFood == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (listFood!.isEmpty)
      return Center(
        child: Text("Not Data"),
      );
    return ListView(
        children: listFood!
            .map((task) => Text("${task.name}, Seconds: ${task.calories}"))
            .toList());
  }

  Widget _fabGoToForm() {
    return FloatingActionButton.extended(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => FoodFormPage()))
            .whenComplete(() => _readDataFromDB()),
        label: Text("Add Task"),
        icon: Icon(Icons.add));
  }

  @override
  void initState() {
    // TODO: implement initState
    _readDataFromDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      floatingActionButton: _fabGoToForm(),
    );
  }

  void _readDataFromDB() async {
    final Database? db = await DatabaseFoods.db.database;
    List<dynamic>? results = await db!.query("task");
    if (results == null || results!.isEmpty) return null;
    listFood = results.map((results) => Task.fromMAPSQL(results)).toList();
    setState(() {});
  }
}
