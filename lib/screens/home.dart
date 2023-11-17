// ignore_for_file: unnecessary_new

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:todo_app/widgets/todo_detail.dart';
import '../model/todo.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';
import 'package:toast/toast.dart';
//import 'package:pager/pager.dart';
import 'package:intl/intl.dart';
//import '../widgets/todo_detail.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ToDo _toDoInstance;
   DateTime? _selectedDate; 
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();
  final _descriptionController = TextEditingController(); 
  bool _isAddingTodo = false;
  bool isVisible = false;
   late List<ToDo> _todosList = [];
  //get todosList => null;
  //final int _currentPage = 1;
  //final int _pageSize = 3; // Number of todos to fetch per page
  //late PageController _pageController; 
  get todosList => _todosList;
  
  //ToDo get todoo => todo;
  ToDo get todoo => _toDoInstance;


  @override
  void initState() {
    _toDoInstance = ToDo(id: '', todoText: '', description: '',date: _selectedDate ?? DateTime.now(),);
    //_pageController = PageController(initialPage: _currentPage);
    //_toDoInstance = ToDo(id: '', todoText: '', description:'');
     _fetchTodoList();
    _foundToDo = todosList;
    super.initState();
  }

  Future<void> _fetchTodoList() async {
  final List<ToDo> todosList = await _toDoInstance.todoList();
  setState(() {
    _foundToDo = todosList.map((toDo) {
       if (kDebugMode) {
         print('Title: ${toDo.todoText}, Description: ${toDo.description}');
       }
      return ToDo(
        id: toDo.id,
        todoText: toDo.todoText,
        isDone: toDo.isDone,
        description: toDo.description,
        date:toDo.date,
      );
    }).toList();
    _todosList = todosList;
  });
  if (kDebugMode) {
    print('Updated _foundToDo: $_foundToDo');
  } else {
    if (kDebugMode) {
      print('Unable to fetch');
    }
  }
}


  /*Future<void> _fetchTodoList() async {
    final List<ToDo> todosList = await _toDoInstance.todoList();
    setState(() {
      _foundToDo = todosList.map((parseObject) {
        return ToDo(
          id: parseObject.objectId!,
          todoText: parseObject['title'] ?? '',
          isDone: parseObject['done'] ?? false,
          description: parseObject['description'] ?? '',
        );
      }).toList();
    });
    if (kDebugMode) {
      print('Updated _foundToDo: $_foundToDo');
    }else{
      if (kDebugMode) {
        print('unable to fdetc');
      }
    }
  }*/
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                searchBox(),
                Expanded(
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
                      for (ToDo todoo in _foundToDo.reversed)
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            ToDoItem(
                              todo: todoo,
                              onToDoChanged: _handleToDoChange,
                              onDeleteItem: _deleteToDoItem,
                              onEditItem: (newTitle, newDescription) {
                                _editToDoItem(todoo, newTitle, newDescription);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  _navigateToDetailsScreen(todoo);
                                },
                                child: const Text('View'), // This is your "View" link
                              ),
                            ),
                          ],
                        ),
                      ),

                      /*Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text(todoo.todoText!),
                          subtitle: Text(todoo.description!),
                          trailing: GestureDetector(
                            onTap: () {
                              _navigateToDetailsScreen(todoo);
                            },
                            child: const Text('View'), // This is your "View" link
                          ),
                          onTap: () {
                            _navigateToDetailsScreen(todoo);
                          },
                        ),
                      ),*/

                      /*GestureDetector(
                        onTap: () {
                          // Navigate to details screen
                          _navigateToDetailsScreen(todoo);
                        },
                        child: ToDoItem(
                          todo: todoo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                          onEditItem: (newTitle, newDescription) {
                            _editToDoItem(todoo, newTitle, newDescription);
                          },
                        ),
                      ),*/
                      
                        
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
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
                  child: _isAddingTodo
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: _todoController,
                                decoration: const InputDecoration(
                                  hintText: 'Add title',
                                  border: InputBorder.none,
                                ),
                              ),
                              TextField(
                                controller: _descriptionController,
                                decoration: const InputDecoration(
                                  hintText: 'Add a description',
                                  border: InputBorder.none,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  );

                                  if (pickedDate != null && pickedDate != _selectedDate) {
                                    setState(() {
                                      _selectedDate = pickedDate;
                                    });
                                  }
                                },
                              ),
                              if (_selectedDate != null)
                                Text(
                                  'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      String title = _todoController.text;
                                      String description =_descriptionController.text;
                                          
                                      _addToDoItem(title, description);
                                      setState(() {
                                        _isAddingTodo = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: tdBlue,
                                    ),
                                    child: const Text('Add'),
                                  ),
                                  const SizedBox(width: 10),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isAddingTodo = false;
                                      });
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  size: 20,),
                                onPressed: () {
                                  setState(() {
                                    _isAddingTodo = true;
                                    _selectedDate = null;
                                  });
                                },
                              ),     
                              const SizedBox(width: 4),
                              const Text(
                              'Add a new todo item',
                              style: TextStyle(
                              color: Colors.grey,

                              ),
                              ),
                               
                            ],
                          ),
                  ),
                  /*child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                        hintText: 'Add a new todo item',
                        border: InputBorder.none),
                  ),*/
                ),
              //),
              /*Container(
                margin: const EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                ),
                child: ElevatedButton(
                  onPressed: () {
                     String title = _todoController.text;
                     String description = _descriptionController.text;
                    _addToDoItem(title, description);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tdBlue,
                    minimumSize: const Size(60, 60),
                    elevation: 10,
                  ),
                  child: const Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                ),
              ),*/
            ]),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

void _navigateToDetailsScreen(ToDo todo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ToDoDetailsScreen(todo: todo),
      ),
    );
  }

  void _deleteToDoItem(String id) async {
  try {
    final ParseObject todo = ParseObject('Task')..objectId = id;
    final ParseResponse apiResponse = await todo.delete();

    if (apiResponse.success) {
      setState(() {
        _foundToDo.removeWhere((item) => item.id == id);
      });
    } else {
      if (kDebugMode) {
        print('Error deleting ToDo item: ${apiResponse.error?.message}');
      }
      // Handle the error as needed
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error deleting ToDo item: $e');
    }
    // Handle the error as needed
  }
}
void _editToDoItem(ToDo todo, String newTitle, String newDescription) async {
  // Call the editTodo method on the existing ToDo instance
  await todo.editTodo(newTodoText: newTitle, newDescription: newDescription);
  // Optionally, you can re-fetch the todo list after editing
  await _fetchTodoList();
}

void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }

  
  void _addToDoItem(String title, String? description) async {
  try {
    FocusScope.of(context).requestFocus(FocusNode());
    final ParseObject newTodo = ParseObject('Task')
      ..set('title', title)
      ..set('description', description)
      ..set('done', false)
      ..set('date', _selectedDate); 
    await newTodo.save();
    showToast("Test Toast", gravity: Toast.bottom);  


    setState(() {
      _todosList.add(ToDo(
        id: newTodo.objectId!,
        todoText: newTodo['title'] ?? '',
        description: newTodo['description'] ?? '',
        isDone: newTodo['done'] ?? false,
        date: newTodo['date'],
      ));
    });
    _todoController.clear();
    _descriptionController.clear(); 
  } catch (e) {
    if (kDebugMode) {
      print('Error adding ToDo item: $e');
    }
    // Handle the error as needed
  }
}
void _runFilter(String enteredKeyword) {
  if (kDebugMode) {
    print('Entered Keyword: $enteredKeyword');
  }
  if (kDebugMode) {
    print('Original Todos List: $todosList');
  }

  setState(() {
    _foundToDo = todosList
        .where((ToDo item) =>
            item.todoText!.toLowerCase().contains(enteredKeyword.toLowerCase()))
        .toList();

    if (kDebugMode) {
      print("Filtered Results: $_foundToDo");
    }
  });
}


 /*void _runFilter(String enteredKeyword) {
    if (kDebugMode) {
      print('Entered Keyword: $enteredKeyword');
    }
    if (kDebugMode) {
      print('Original Todos List: $todosList');
    }
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      if (kDebugMode) {
        print("hi");
      }
      results = todosList;
    } else {
       if (kDebugMode) {
        print("hi123");
      }
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
          if (kDebugMode) {
            print("search results: $results");
          }
    }
    setState(() {
      _foundToDo = results;
      
        print("Filtered Results: $_foundToDo");
      
    });
  }*/

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
         onSubmitted: (value) => _runFilter(value),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Icon(
          Icons.menu,
          color: tdBlack,
          size: 30,
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/girl.png'),
          ),
        ),
      ]),
    );
  }
}