import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hustle/api/AuthAPI.dart';
import 'package:hustle/api/TodoAPI.dart';
import 'package:hustle/models/Todo.dart';
import 'package:logger/logger.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  AuthAPI authAPI = AuthAPI();
  List<Todo> todoList = [];
  final _todoController = TextEditingController();

  var logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  Widget build(BuildContext context) {
    TodoAPI todoAPI = TodoAPI(authAPI: authAPI);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Column(
                children: [
                  FutureBuilder<List<Todo>>(
                    future: todoAPI.getTodos(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
      
                      todoList = snapshot.data!;
      
                      return Expanded(
                          child: ListView(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 50,
                                  bottom: 20,
                                ),
                                child: const Text(
                                  'All ToDos',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              for (Todo todo in snapshot.data!)
                                buildTodo(todo, todoAPI)
                            ],
                          ),
                        );
                    },
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                      left: 20,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                          hintText: 'Add a new todo item',
                          border: InputBorder.none),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Todo newTodo = Todo(name: _todoController.text, finished: false);
                    await todoAPI.addTodo(newTodo);
                    _todoController.clear(); 
                    setState(() {
                      
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                    ),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue
                    ),
                    child: const Text(
                        '+',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white
                        ),
                      ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTodo(Todo todo, TodoAPI todoAPI) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: const Color.fromARGB(255, 236, 236, 236),
        leading: Icon(
          todo.finished ? Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.blue,
        ),
        title: Text(
          todo.name,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            decoration: todo.finished ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await todoAPI.deleteTodo(todo);
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}
