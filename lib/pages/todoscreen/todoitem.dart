import 'package:flutter/material.dart';
import 'package:takip_deneme/pages/todoscreen/model/tasktype.dart';

import 'model/Task.dart';

class TodoItem extends StatefulWidget {
  const TodoItem ({super.key,required this.task,required this.onTaskCompleted,required this.onDelete});
  final Task task;
  final Function(Task) onTaskCompleted;
  final Function(Task) onDelete;

  @override
  State<TodoItem> createState() => _TodoItemState();



}
bool isChecked = false;

class _TodoItemState extends State<TodoItem> {
  void toggleTaskCompletion(){
    setState(() {
      widget.task.isCompleted = !widget.task.isCompleted;

      if(widget.task.isCompleted){
        widget.onTaskCompleted(widget.task);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Card (
      color: widget.task.isCompleted ? Colors.grey : Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          children: [
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                shape: const CircleBorder() ,
                value: widget.task.isCompleted,
                activeColor: const Color.fromRGBO(95, 21, 225, 1),
                side: const BorderSide(
                    width: 1.5,
                    color: Colors.grey

                ),
                onChanged: (bool? val) {
                  toggleTaskCompletion();
                },
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                      widget.task.title,
                      style: widget.task.isCompleted ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.black54,decoration: TextDecoration.lineThrough)//if
                          : const TextStyle(fontWeight: FontWeight.bold,fontSize: 19,color :Colors.black)//else
                  ),
                  Text(
                    widget.task.description,
                    style: const TextStyle(

                    ),
                  )
                ],
              ),
            ),
            widget.task.type == TaskType.notes ? Image.asset(
              "lib/assets/images/category1.png",
              color: widget.task.isCompleted ? Colors.black.withOpacity(0.3) : null,
              colorBlendMode: widget.task.isCompleted ? BlendMode.dstIn : null,):// ternory operation
            widget.task.type == TaskType.calendar ? Image.asset(
              "lib/assets/images/category2.png",
              color: widget.task.isCompleted ? Colors.black.withOpacity(0.3) : null,
              colorBlendMode: widget.task.isCompleted ? BlendMode.dstIn : null,):
            Image.asset(
              "lib/assets/images/category3.png",
              color: widget.task.isCompleted ? Colors.black.withOpacity(0.3) : null,
              colorBlendMode: widget.task.isCompleted ? BlendMode.dstIn : null,),

            widget.task.isCompleted ? IconButton(
                onPressed:() {
                  widget.onDelete(widget.task);
                }, icon: const Icon(Icons.delete,color: Colors.deepPurple,)

            ): const Icon(Icons.list_outlined,color: Colors.white,)
          ],
        ),
      ),
    );
  }
}
