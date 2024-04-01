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
}
