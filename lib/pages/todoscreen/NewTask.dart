import 'package:flutter/material.dart';
import 'package:takip_deneme/pages/todoscreen/model/Task.dart';
import 'package:takip_deneme/pages/todoscreen/model/tasktype.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key, required this.addNewTask});
  final void Function(Task newTask) addNewTask;

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TaskType taskType = TaskType.notes;

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 95, 51, 225),
          title: const Text("Yeni Görev Ekle",style:
          TextStyle(color: Colors.white,fontFamily: "Fonts",fontSize: 24),
          ),
        ),
        backgroundColor: const Color(0xFFF1F5F9),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text("Görev Adı", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(controller: titleController, decoration: _inputDecoration("Örn: Tyt denemesi çöz")),
              const SizedBox(height: 16),
              const Text("Kategori", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => taskType = TaskType.notes),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: taskType == TaskType.notes ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                      child: Image.asset("lib/assets/images/category1.png"),
                    ),
                  ),

                  GestureDetector(
                    onTap: () => setState(() => taskType = TaskType.calendar),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: taskType == TaskType.calendar ? Colors.purpleAccent.withOpacity(0.3) : Colors.transparent,
                      child: Image.asset("lib/assets/images/category2.png"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => taskType = TaskType.contest),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: taskType == TaskType.contest ? Colors.yellow.withOpacity(0.3) : Colors.transparent,
                      child: Image.asset("lib/assets/images/category3.png"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Görev Detayı", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: TextField(
                  controller: descriptionController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: _inputDecoration("Detayları giriniz..."),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9, // Ekran genişliğinin %90'ı kadar
                  child: ElevatedButton(
                    onPressed: () {
                      Task newTask = Task(
                        type: taskType,
                        title: titleController.text,
                        description: descriptionController.text,
                        isCompleted: false,
                      );
                      widget.addNewTask(newTask);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 95, 51, 225),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12), // Yalnızca dikey padding
                    ),
                    child: const Text(
                      "Kaydet",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
