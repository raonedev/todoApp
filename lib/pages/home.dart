import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

class _HomeScreenState extends State<HomeScreen>  with SingleTickerProviderStateMixin{
  //reference the box
  final mybox = Hive.box('notes');
  List foundToDo = [];
  List done = [];
  List notdone = [];

  ToDoClass db = ToDoClass();
  TextEditingController title = TextEditingController();
  TextEditingController subtitle = TextEditingController();
  TextEditingController search = TextEditingController();
  late TabController _tabController=TabController(vsync: this, length: 2);

  int findIndexStrict(List list, String value) {
    for (int i = 0; i < list.length; i++) {
      if (list[i][0] == value) {
        return i;
      }
    }
    return -1;
  }

  //delete history
  void deletehis(int index){
    print("index");
    setState(() {
      int temp = findIndexStrict(db.tododata, done[index][0]);
      print(done);
      db.tododata.removeAt(temp);
      done.removeAt(index);
      print(done);
    });
    db.UpdatData();
  }

  //checkbox changed
  void onchanged(bool? value, int index) {
    setState(() {
      int temp = findIndexStrict(db.tododata, foundToDo[index][0]);
      print(temp);
      print(db.tododata[temp][0]);
      foundToDo[index][1] = !foundToDo[index][1];
      db.tododata[temp][1]= foundToDo[index][1];
      print(db.tododata);
      db.UpdatData();
    });
  }

  //create a new task
  void showdialog() {
    DateTime _currentDate = DateTime.now();
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            t1: title,
            submit: () {
              print("submit");
              setState(() {
                db.tododata.add([title.text,false,
                  _currentDate.day.toString() +"/" +_currentDate.month.toString(),
                  _currentDate.hour.toString() +":" +_currentDate.minute.toString()
                ]);
                notdone.add([title.text,false,
                  _currentDate.day.toString() +"/" +_currentDate.month.toString(),
                  _currentDate.hour.toString() +":" +_currentDate.minute.toString()
                ]);
                db.UpdatData();
                title.clear();
              });
              print(notdone);
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
    print("delete");
    showDialog(context: context, builder: (context){
      return CupertinoAlertDialog(
        insetAnimationCurve: Curves.bounceInOut,
        insetAnimationDuration: Duration(seconds: 2),
        title: Text("Delete a task"),
        content: Card(
          color: Colors.transparent,
          elevation: 0.0,
          child: Text("are you sure ?"),
        ),
        actions: [
          CupertinoDialogAction(
              child: Text("Yes",style: TextStyle(color: red),),
              onPressed: (){
                print("yes");
                setState(() {
                  db.tododata.removeAt(index);
                  notdone.removeAt(index);
                });
                db.UpdatData();
                Navigator.pop(context);
              }
          ),
          CupertinoDialogAction(
            child: Text("no",style: TextStyle(color: Colors.blue),),
            onPressed:()=> Navigator.pop(context),
          ),
        ],
      );
    });

  }

  //searching a task
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

  //edit function
  void edit(String? value, int index) {
    title.clear();
    title.text=value!;
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            t1: title,
            submit: () {
              print("submit");
              setState(() {
                notdone[index][0] = title.text;
                db.tododata[index][0] = title.text;
                db.UpdatData();
                title.clear();
              });
              print(notdone);
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

  @override
  void initState() {
    if (mybox.get('key') == null) {
      db.createInitailData();
      foundToDo=db.tododata;
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
        foundToDo.clear();
        foundToDo = notdone;
        print(foundToDo);
      });
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
                TitleText(title: 'Welcome Back ',subtitle: 'let\'s see what To Do. '),
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
                Container(
                  child: TabBar(
                    unselectedLabelColor: grey,
                    isScrollable: true,
                    padding: EdgeInsets.only(right: 20),
                    controller: _tabController,
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: "To Do"),
                      Tab(text: "History",),
                    ],
                  ),
                ),
                //task title end here
              ],
            ),
          ),
          //list start here
          Expanded(
            child: TabBarView(
              controller: _tabController ,
              children: [
                Container(
                  child: ListView.builder(
                    itemCount: foundToDo.length,
                    itemBuilder: ((context, index) {
                      return Container(
                        margin: EdgeInsets.only(left: 10,right: 10,bottom: 20),
                        child: TodoTile(
                          edit: (context)=>edit(foundToDo[index][0],index),
                          date: foundToDo[index][2],
                          time: foundToDo[index][3],
                          onPressed: (context) => deletetask(index),
                          text: foundToDo[index][0],
                          checked: foundToDo[index][1],
                          onChanged: (value) => onchanged(value, index),
                        ),
                      );
                    }),
                  ),
                ),
                ListView.builder(
                  itemCount: done.length,
                  itemBuilder: ((context, index) {
                    return Container(
                      // date: done[index][2],
                      // time: done[index][3],
                      margin: EdgeInsets.only(left: 10,right: 10,bottom: 20),
                      child:Slidable(
                        endActionPane: ActionPane(
                          children: [
                            //delete
                            SlidableAction(
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                              onPressed: (context)=>deletehis(index),
                              icon: Icons.delete,
                              backgroundColor: red,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            )
                          ],
                          motion: DrawerMotion(),
                        ),
                        closeOnScroll: true,
                        child: ListTile(
                          title: Text(done[index][0]),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          tileColor: Colors.white,
                          trailing: Icon(Icons.check_box_rounded,color: Colors.green,),
                        ),
                      ),

                      // ListTile(
                      //   title: Text(done[index][0]),
                      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      //   tileColor: Colors.white,
                      //   trailing: Icon(Icons.check_box_rounded,color: Colors.green,),
                      // ),
                    );
                  }),
                ),
              ],
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
