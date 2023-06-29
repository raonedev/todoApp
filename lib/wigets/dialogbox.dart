import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoappfinal/wigets/inputfield.dart';

class DialogBox extends StatelessWidget {
  const DialogBox({super.key, this.t1, required this.submit, required this.cancel});
  final t1;
  final VoidCallback submit,cancel;
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(

      title: Text("Enter Task"),
      content: Card(
        color: Colors.transparent,
        elevation: 0.0,
        child: Column(
          children: <Widget>[
            InputField(hint: '',controller: t1,labeltext: "gym"),

          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          child: Text("Cancel"),
          onPressed:cancel
        ),
        CupertinoDialogAction(
          child: Text("Submit"),
          onPressed: submit
        ),
      ],
      // insetPadding: EdgeInsets.all(20),
      // contentPadding: EdgeInsets.all(20),
    );
  }
}
//InputField(hint: '', controller: t1, labeltext: "enter task")