import 'package:flutter/material.dart';
import 'package:notes_firebase_ddd_course/domain/notes/note_failure.dart';

class CriticalFailureDisplay extends StatelessWidget {
  final NoteFailure failure;

  const CriticalFailureDisplay({Key key, this.failure}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "😱",
            style: TextStyle(fontSize: 100.0),
          ),
          Text(
            failure.maybeMap(
              insufficientPermission: (_) => "Insufficient permissions.",
              orElse: () => "Unexpected Error. \n Please contact Support.",
            ),
            style: const TextStyle(fontSize: 24.0),
            textAlign: TextAlign.center,
          ),
          FlatButton(
              onPressed: () {
                print("Sending email!");
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.mail),
                  const SizedBox(
                    width: 4.0,
                  ),
                  const Text("I NEED HELP"),
                ],
              ))
        ],
      ),
    );
  }
}
