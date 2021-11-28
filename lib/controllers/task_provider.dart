import 'package:fiona/classes/tarea.dart';
import 'package:flutter/cupertino.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> taskList = [];
  String title = '';

  void addTask(Task task) {
    title = task.title;
    taskList.add(task);
    notifyListeners();  
  }

  void updateTask(int index){
    taskList[index].isDone = !taskList[index].isDone;
    notifyListeners();
  }

  void deleteTask(int index){
    taskList.removeAt(index);
    notifyListeners();
  }
}