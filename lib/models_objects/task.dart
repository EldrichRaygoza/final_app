class Task{
  String? name;
  double? calories;

  Task({required this.name, required this.calories});

  Task.fromMAPSQL(Map<String, dynamic> mapSQL){
    name = mapSQL["name"];
    calories = mapSQL["calories"];
  }

  Map<String, dynamic> toMapSQL(){
    return{
      "name": name,
      "calories": calories
    };
  }
}