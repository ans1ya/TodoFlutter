import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/todo.dart';


class ToDoDetailsScreen extends StatelessWidget {
  final ToDo todo;

  const ToDoDetailsScreen({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${todo.todoText}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: ${todo.description}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Date: ${DateFormat.yMd().format(todo.date)}', // Use the intl package for formatting
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
