import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../data/database.dart';
import '../wigets/dialogbox.dart';
import '../constants/colors.dart';
import '../wigets/titletext.dart';
import '../wigets/todo_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //reference the box
  final mybox = Hive.box('notes');
  List foundToDo = [];
  List done = [];
  List notdone = [];
  ToDoClass db = ToDoClass();
  TextEditingController title = TextEditingController();
  TextEditingController subtitle = TextEditingController();
  TextEditingController search = TextEditingController();

  void onchanged(bool? value, int index) {
    setState(() {
      notdone[index][1] = !notdone[index][1];
      db.tododata[index][1] = notdone[index][1];
      print(notdone);
      db.UpdatData();
    });
  }

  //create a new task
  void showdialog() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            t1: title,
            submit: () {
              print("submit");
              setState(() {
                db.tododata.add([title.text, false]);
                notdone.add([title.text, false]);
                db.UpdatData();
                title.clear();
              });
              Navigator.pop(context);
            },
            cancel: () {
              title.clear();
              Navigator.pop(context);
              print("cancel");
            },
          );
        });
  }

  //deleting a task
  void deletetask(int index) {
    setState(() {
      db.tododata.removeAt(index);
      notdone.removeAt(index);
    });
    db.UpdatData();
  }

  void _search(String searchTerm) {
    List resultsList = [];
    resultsList.clear();
    if (searchTerm.isEmpty) {
      resultsList = notdone;
    } else {
      for (var item in notdone) {
        if (item[0].toLowerCase().contains(searchTerm.toLowerCase())) {
          resultsList.add(item);
        }
      }
    }
    setState(() {
      foundToDo = resultsList;
      print(foundToDo);
    });
  }

  @override
  void initState() {
    if (mybox.get('key') == null) {
      db.createInitailData();
    } else {
      db.loadData();
      for (var item in db.tododata) {
        if (item[1]) {
          done.add(item);
        } else {
          notdone.add(item);
        }
      }
      setState(() {
        foundToDo = notdone;
      });
    }

    if (mybox.get('his') == null) {
      db.createInitailData();
    } else {
      db.loadHisData();
    }
    super.initState();
  }

  @override
  void dispose() {
    title.dispose();
    subtitle.dispose();
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //top section start here
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.5,
                color: Colors.white.withOpacity(0.2),
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.6),
                ],
                begin: AlignmentDirectional.topCenter,
                end: AlignmentDirectional.bottomEnd,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //titlebar
                TitleText(
                    title: 'Welcome Back ',
                    subtitle: 'let\'s see what To Do. '),
                //title bar end here
                const SizedBox(height: 30),
                //searchbar start here
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 32,
                        offset: Offset(0, 16),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) => _search(value),
                    controller: search,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      hintText: 'Start searching here...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: const Icon(
                        Icons.filter_alt_rounded,
                        color: blue,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                //searchBar End here
                const SizedBox(height: 30),
                //task title start here
                Text(
                  "To Do",
                  style: const TextStyle(
                    color: Color(0xFF0D0D0D),
                    fontSize: 30,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.48,
                  ),
                ),
                //task title end here
              ],
            ),
          ),
          //list start here
          Container(
            child: Expanded(
              child: ListView.builder(
                itemCount: foundToDo.length,
                itemBuilder: ((context, index) {
                  return TodoTile(
                    onPressed: (context) => deletetask(index),
                    text: foundToDo[index][0],
                    checked: foundToDo[index][1],
                    onChanged: (value) => onchanged(value, index),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        onPressed: showdialog,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
