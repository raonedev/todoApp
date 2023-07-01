import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todoappfinal/constants/colors.dart';

class TodoTile extends StatelessWidget {
  const TodoTile(
      {super.key,
      required this.text,
      required this.checked,
      this.onChanged,
      this.onPressed,
      required this.date,
      required this.time, this.edit});

  final String text, date, time;
  final bool checked;
  final void Function(BuildContext)? onPressed;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? edit;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      closeOnScroll: true,
      endActionPane: ActionPane(
        children: [
          //edit
          SlidableAction(
            autoClose: true,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
            onPressed: edit,
            icon: Icons.edit,
            backgroundColor: Colors.blue,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10), topLeft: Radius.circular(10)),
          ),
          //delete
          SlidableAction(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
            onPressed: onPressed,
            icon: Icons.delete,
            backgroundColor: red,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10)),
          )
        ],
        motion: DrawerMotion(),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.white,
        leading: Checkbox(value: checked, onChanged: onChanged),
        title: Text(
          text,
          style: TextStyle(
              fontSize: 16,
              color: black,
              decoration:
                  checked ? TextDecoration.lineThrough : TextDecoration.none),
        ),
        trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(date),
              Text(time, style: TextStyle(color: Colors.grey))
            ]),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
    );
  }
}
