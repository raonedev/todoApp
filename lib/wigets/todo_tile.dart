import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todoappfinal/constants/colors.dart';

class TodoTile extends StatelessWidget {
  const TodoTile(
      {super.key,
      required this.text,
      required this.checked,
      this.onChanged,
      this.onPressed});
  final String text;
  final bool checked;
  final void Function(BuildContext)? onPressed;
  final void Function(bool?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        children: [
          SlidableAction(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
            onPressed: onPressed,
            icon: Icons.delete,
            backgroundColor: red,
            borderRadius: BorderRadius.circular(20),
          )
        ],
        motion: StretchMotion(),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
      ),
    );
  }
}
