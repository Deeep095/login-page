import 'package:flutter/material.dart';
import 'package:untitled1/Backend/ClassModel.dart';

class ClassInfoProvider extends ChangeNotifier {
  int classindex = 121;

  List<ClassModel> _classes = [];

  List<ClassModel> get classes => _classes;

  void setClasses(List<ClassModel> newClasses) {
    _classes = newClasses;
    notifyListeners(); // Notify listeners when the data changes
  }

  void addClass(ClassModel newClass) {
    _classes.add(newClass);
    print(" not done");
    notifyListeners(); // Notify when a class is added
  }

  int getClassIndex()
  {
    return _classes.length;
  } 

  void UpdateClassIndex(ClassModel newclass) {
    int index = _classes.length;
    int newclassindex = index + classindex;

    newclass.classid = newclassindex as String;
  }
}
