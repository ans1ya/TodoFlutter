// ignore_for_file: dead_code

//import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:flutter/services.dart';
import './screens/home.dart';
import 'package:toast/toast.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = 'pQjbbo0Fh5d6yvY7sT9Ady5D6EapFcctiex6QJjJ';
  const keyClientKey = 'emQWsLqjflkXY79rzhTGgfCDMBWO36yc8BaDQlt9';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);

  runApp(const MaterialApp(
    home: Home(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      home: Home(),
    );
  }
}

/*class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoController = TextEditingController();
  final descriptionController = TextEditingController();

  void addToDo() async {
    if (todoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Empty title"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    await saveTodo(todoController.text, descriptionController.text);
    setState(() {
      todoController.clear();
      descriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
              child: Column(
                children: <Widget>[
                  const Text(
                  "Add Todo",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 3, 74, 197),
                  ),
                ),
                  TextField(
                    autocorrect: true,
                    textCapitalization: TextCapitalization.sentences,
                    controller: todoController,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      labelStyle: TextStyle(color: Color.fromARGB(255, 255, 180, 68)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    autocorrect: true,
                    textCapitalization: TextCapitalization.sentences,
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      labelStyle: TextStyle(color: Color.fromARGB(255, 255, 180, 68)),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: addToDo,
                      child: const Text("ADD")),
                ],
              )),
          Expanded(
              child: FutureBuilder<List<ParseObject>>(
                  future: getTodo(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Center(
                          child: SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator()),
                        );
                      default:
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("Error..."),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("No Data..."),
                          );
                        } else {
                          return ListView.builder(
                              padding: const EdgeInsets.only(top: 10.0),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                              
                                //Get Parse Object Values
                                final varTodo = snapshot.data![index];
	                              final varTitle = varTodo.get<String>('title')!;
	                              final varDone =  varTodo.get<bool>('done')!;
                            

                                return ListTile(
                                  title:  Text(varTitle),
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        varDone ? Colors.green : Colors.blue,
                                    foregroundColor: Colors.white,
                                    child: Icon(
                                        varDone ? Icons.check : Icons.error),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Checkbox(
                                          value: varDone,
                                          onChanged: (value) async {
                                            await updateTodo(
                                                varTodo.objectId!, value!);
                                            setState(() {
                                              //Refresh UI
                                            });
                                          }),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () async {
                                          await deleteTodo(varTodo.objectId!);
                                          setState(() {
                                            const snackBar = SnackBar(
                                              content: Text("Todo deleted!"),
                                              duration: Duration(seconds: 2),
                                            );
                                            ScaffoldMessenger.of(context)
                                              ..removeCurrentSnackBar()
                                              ..showSnackBar(snackBar);
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                );
                              });
                        }
                    }
                  }))
        ],
      ),
    );
  }

  Future<void> saveTodo(String title, String description) async {
  final todo = ParseObject('Task')
    ..set('title', title)
    ..set('description', description)
    ..set('done', false);

  await todo.save();
  }

  Future<List<ParseObject>> getTodo() async {
    QueryBuilder<ParseObject> queryTodo =
        QueryBuilder<ParseObject>(ParseObject('Task'));
    final ParseResponse apiResponse = await queryTodo.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<void> updateTodo(String id, bool done) async {
    await Future.delayed(const Duration(seconds: 1), () {});
  }

  Future<void> deleteTodo(String id) async {
    await Future.delayed(const Duration(seconds: 1), () {});
  }
}*/