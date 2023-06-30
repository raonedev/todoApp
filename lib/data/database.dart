import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ToDoClass {
  List tododata = [];
  List his = [];
  //reference the box
  final mybox = Hive.box('notes');
  //run this method if this is the forst time ever opening this app
  void createInitailData() {
    tododata = [
      ["swipe left to delete", true]
    ];
  }

  void initialHistory() {
    his = [
      ["swipe left to delete", true]
    ];
  }

  void loadData() {
    tododata = mybox.get('key');
  }

  void loadHisData() {
    his = mybox.get('his');
  }

  void UpdatData() {
    mybox.put('key', tododata);
    mybox.put('his', tododata);
  }

  void UpdatHisData() {
    mybox.put('his', tododata);
  }
}
