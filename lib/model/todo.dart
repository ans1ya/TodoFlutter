import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';


class ToDo {
  String? id;
  String? todoText;
  bool isDone;
  String description;
  final DateTime date;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false, required,
    this.description = '', 
    required this.date,
  });
factory ToDo.fromParseObject(ParseObject parseObject) {
    return ToDo(
      id: parseObject['objectId'] as String?,
      todoText: parseObject['title'] as String? ?? '',
      isDone: parseObject['isDone'] as bool? ?? false,
      description: parseObject['description'] as String? ?? '',
      date: parseObject['date'] as DateTime? ?? DateTime.now(), // Provide a default value if 'date' is null

    );
  }

  get objectId => null;
Future<List<ToDo>> todoList() async {
    QueryBuilder<ParseObject> queryTodo = QueryBuilder<ParseObject>(ParseObject('Task'));

    final ParseResponse apiResponse = await queryTodo.query();

    if (apiResponse.success && apiResponse.results != null) {
      List<ToDo> todos = apiResponse.results!.map((parseObject) {
        return ToDo.fromParseObject(parseObject);
      }).toList();

      return todos;
    } else {
      return [];
    }
  }
  Future<void> editTodo({String? newTodoText, bool? newIsDone, String? newDescription}) async {
    final ParseObject task = ParseObject('Task')..set('objectId', id);
    
    if (newTodoText != null) {
      task.set('title', newTodoText);
    }
    
    if (newIsDone != null) {
      task.set('done', newIsDone);
    }
    
    if (newDescription != null) {
      task.set('description', newDescription);
    }

    final ParseResponse apiResponse = await task.save();

    if (apiResponse.success) {
      // Update the local state if needed
      if (newTodoText != null) {
        todoText = newTodoText;
      }

      if (newIsDone != null) {
        isDone = newIsDone;
      }

      if (newDescription != null) {
        description = newDescription;
      }

      if (kDebugMode) {
        print('Todo updated successfully');
      }
    } else {
      if (kDebugMode) {
        print('Failed to update todo: ${apiResponse.error?.message}');
      }
    }
  }
}