import 'package:flutter/material.dart';
import 'package:takip_deneme/pages/todoscreen/database/DataBaseHelper.dart';
import 'package:takip_deneme/pages/todoscreen/model/Task.dart';
import 'package:takip_deneme/pages/todoscreen/todoitem.dart';

import 'NewTask.dart';


class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<TodoHomeScreen> {

  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Task> todos = [];
  List<Task> completed = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final incompleteTasks = await _dbHelper.getIncompleteTasks();
    final completedTasks = await _dbHelper.getCompletedTasks();
    setState(() {
      todos = incompleteTasks;
      completed = completedTasks;
    });
  }

  void onTaskCompleted(Task task) async {
    task.isCompleted = true;
    await _dbHelper.updateTask(task);
    await _loadTasks(); // Reload tasks from database
  }

  void addNewTask(Task newTask) async {
    await _dbHelper.insertTask(newTask);
    await _loadTasks(); // Reload tasks from database
  }

  void deleteTask(Task task) async {
    await _dbHelper.deleteTask(task.id!);
    await _loadTasks(); // Reload tasks from database
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(241, 245, 249, 1),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 95, 51, 225),
            title: const Text(
              "Görevlerim",
              style: TextStyle(
                fontSize: 25,
                fontFamily: "Fonts",
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(3, 10, 3, 10),
                  child: SingleChildScrollView(
                      child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          return TodoItem(
                            task: todos[index],
                            onTaskCompleted: onTaskCompleted,
                            onDelete: deleteTask,
                          );
                        },
                      )),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Tamamlanan Görevler",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                    )),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(3, 10, 3, 10),
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: completed.length,
                      itemBuilder: (context, index) {
                        return TodoItem(
                          task: completed[index],
                          onTaskCompleted: onTaskCompleted,
                          onDelete: deleteTask,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9, // Ekran genişliğinin %90'ı kadar
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewTaskScreen(
                            addNewTask: (newTask) => addNewTask(newTask),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 95, 51, 225),
                      padding: const EdgeInsets.symmetric(vertical: 12), // Dikey padding
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      "Yeni Görev Ekle",
                      style: TextStyle(
                        fontFamily: "Fonts",
                        fontSize: 19,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

