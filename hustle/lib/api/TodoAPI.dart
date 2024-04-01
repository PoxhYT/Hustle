import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hustle/api/AuthAPI.dart';
import 'package:hustle/models/Todo.dart';
import 'package:logger/logger.dart';

class TodoAPI {
  final AuthAPI authAPI;

  TodoAPI({
    required this.authAPI,
  });

  Future<List<Todo>> getTodos() async {
    List<Todo> todos = [];
    try {
      DocumentSnapshot todosSnapshot = await FirebaseFirestore.instance
          .collection('todos')
          .doc(authAPI.getUID())
          .get();

      if (todosSnapshot.exists) {
        Map<String, dynamic> todosData =
            todosSnapshot.data() as Map<String, dynamic>;
        todos = (todosData['todos'] as List<dynamic>)
            .map((todoJson) => Todo.fromJson(todoJson as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return todos;
  }

  Future<void> addTodo(Todo newTodo) async {
    var logger = Logger(printer: PrettyPrinter());

    try {
      DocumentReference todosRef =
          FirebaseFirestore.instance.collection('todos').doc(authAPI.getUID());

      DocumentSnapshot todosSnapshot = await todosRef.get();

      if (todosSnapshot.exists) {
        Map<String, dynamic> todosData =
            todosSnapshot.data() as Map<String, dynamic>;
        List<dynamic> existingTodos = todosData['todos'] ?? [];
        existingTodos.add(newTodo.toJson());
        await todosRef.update({'todos': existingTodos});
        logger.i("ADDED NEW TODO");
      } else {
        await todosRef.set({
          'todos': [newTodo.toJson()]
        });
      }
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  Future<void> deleteTodo(Todo targetTodo) async {
    try {
      DocumentReference todosRef =
          FirebaseFirestore.instance.collection('todos').doc(authAPI.getUID());

      DocumentSnapshot todosSnapshot = await todosRef.get();

      if (todosSnapshot.exists) {
        Map<String, dynamic> todosData =
            todosSnapshot.data() as Map<String, dynamic>;
        List<dynamic> existingTodos = todosData['todos'] ?? [];

        int todoIndex = existingTodos.indexWhere((todo) =>
            (todo as Map<String, dynamic>)['name'] == targetTodo.name);

        if (todoIndex != -1) {
          existingTodos.removeAt(todoIndex);
          await todosRef.update({'todos': existingTodos});
        }
      }
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }

  Future<bool> todoExists(String todoName) async {
    try {
      DocumentReference todosRef =
          FirebaseFirestore.instance.collection('todos').doc(authAPI.getUID());

      DocumentSnapshot todosSnapshot = await todosRef.get();

      if (todosSnapshot.exists) {
        Map<String, dynamic> todosData =
            todosSnapshot.data() as Map<String, dynamic>;
        List<dynamic> existingTodos = todosData['todos'] ?? [];

        return existingTodos
            .any((todo) => (todo as Map<String, dynamic>)['name'] == todoName);
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking if todo exists: $e');
      return false;
    }
  }

  Future<void> showTodoExistsDialog(
      String todoName, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Todo Exists'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('The todo item "$todoName" already exists.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> toggleTodoStatus(String todoName) async {
    try {
      DocumentReference todosRef =
          FirebaseFirestore.instance.collection('todos').doc(authAPI.getUID());

      DocumentSnapshot todosSnapshot = await todosRef.get();

      if (todosSnapshot.exists) {
        Map<String, dynamic> todosData =
            todosSnapshot.data() as Map<String, dynamic>;
        List<dynamic> existingTodos = todosData['todos'] ?? [];

        int todoIndex = existingTodos.indexWhere(
            (todo) => (todo as Map<String, dynamic>)['name'] == todoName);

        if (todoIndex != -1) {
          Map<String, dynamic> updatedTodo =
              existingTodos[todoIndex] as Map<String, dynamic>;
          updatedTodo['finished'] = !updatedTodo['finished'];
          existingTodos[todoIndex] = updatedTodo;

          await todosRef.update({'todos': existingTodos});
        } else {
          print('Todo not found: $todoName');
        }
      } else {
        print('No todos found for the current user');
      }
    } catch (e) {
      print('Error toggling todo status: $e');
    }
  }
}
