import 'package:final_app/database_food.dart';
import 'package:final_app/methods/public.dart';
import 'package:final_app/models_objects/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class FoodFormPage extends StatefulWidget {
  @override
  _FoodFormPageState createState() => _FoodFormPageState();
}

class _FoodFormPageState extends State<FoodFormPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name = "";
  String _calories = "";

  AppBar _appBar() {
    return AppBar(title: Text("Food Form"));
  }

  Widget _inputName() {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.name,
        onSaved: (val) => _name = val ?? "",
        style: TextStyle(fontWeight: FontWeight.bold),
        validator: (val) =>
        (val != null && val.length > 5) ? null : "Issue in Name",
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            prefixIcon: Icon(Icons.person),
            labelText: "Name",
            hintText: "Enter ur Name"),
      ),
    );
  }

  Widget _inputCalories() {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        onSaved: (val) => _calories = val ?? "",
        style: TextStyle(fontWeight: FontWeight.bold),
        validator: (val) =>
        (val != null && val.isNotEmpty && double.tryParse(val) != null)
            ? null
            : "Issue in Calories",
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            prefixIcon: Icon(Icons.person),
            labelText: "Calories",
            hintText: "Enter a Calories"),
      ),
    );
  }

  SizedBox _space() {
    return SizedBox(height: 5);
  }

  Widget _formTask() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            _space(),
            _inputName(),
            _space(),
            _inputCalories()
          ],
        ));
  }

  Widget _fabSaveTask() {
    return FloatingActionButton.extended(
        onPressed: _saveData, label: Text("Save Data"), icon: Icon(Icons.add));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _formTask(),
      floatingActionButton: _fabSaveTask(),
    );
  }

  void _saveData() async {
    final FormState? _formState = _formKey.currentState;
    if (_formState != null && _formState.validate()) {
      _formState.save();

      try {
        Task _task = Task(name: _name, calories: double.tryParse(_calories));
        await _insertDataDB(_task);
        snackMessage(message: "Saved :D", context: context);
        Navigator.of(context).pop();
      } catch (error) {
        snackMessage(
            message: "${error.toString()}", context: context, isError: true);
      }
    } else {
      snackMessage(
          message: "Issue Inside the Form", context: context, isError: true);
    }
  }

  Future<void> _insertDataDB(Task task) async {
    final Database? db = await DatabaseFoods.db.database;
    await db!.insert("task", task.toMapSQL());
  }
}
