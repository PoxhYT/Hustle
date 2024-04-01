import 'package:cloud_firestore/cloud_firestore.dart';
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
}
