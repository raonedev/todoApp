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

  ToDoClass db = ToDoClass();
  TextEditingController t1 = TextEditingController();
  List remain = ["", false];
  List history = ["", true];

  void onchanged(bool? value, int index) {
    setState(() {
      db.tododata[index][1] = !db.tododata[index][1];
      db.UpdatData();
    });
  }

  //create a new task
  void showdialog() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            t1: t1,
            submit: () {
              print("submit");
              setState(() {
                db.tododata.add([t1.text, false]);
                db.UpdatData();
                t1.clear();
              });
              Navigator.pop(context);
            },
            cancel: () {
              t1.clear();
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
    });
    db.UpdatData();
  }

  @override
  void initState() {
    // if this is the 1st time to ever to open in the app,them create default data
    if (mybox.get('key') == null) {
      db.createInitailData();
    } else {
      db.loadData();
      for (var i in db.tododata) {
        print(i[0].toString() + " " + i[1].toString());
        if (i[1] == true) {
          history.add((i[0], i[1]));
          // print('hsitory');
        } else {
          remain.add((i[0], i[1]));
          // print('remain');
        }
      }
      print(remain.length.toString() + " " + history.length.toString());
      // print(history.length);
    }
    super.initState();
  }

  @override
  void dispose() {
    t1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopSection(),
          //list start here
          Container(
            child: Expanded(
              child: ListView.builder(
                itemCount: db.tododata.length,
                itemBuilder: ((context, index) {
                  return TodoTile(
                    onPressed: (context) => deletetask(index),
                    text: db.tododata[index][0],
                    checked: db.tododata[index][1],
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

class TopSection extends StatelessWidget {
  const TopSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              title: 'Welcome Back ', subtitle: 'let\'s see what To Do. '),
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
              // controller: ,
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
    );
  }
}
