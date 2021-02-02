import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_firebase_ddd_course/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:notes_firebase_ddd_course/domain/notes/note.dart';

class NotesOverviewBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteWatcherBloc, NoteWatcherState>(
      builder: (context, state) => state.map(
        initial: (_) => Container(),
        loadInProgress: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
        loadSuccess: (state) => ListView.builder(
          itemBuilder: (context, index) {
            final Note note = state.notes[index];
            if (note.failureOption.isSome()) {
              return Container(
                color: Colors.red,
                width: 100,
                height: 100,
              );
            } else {
              return Container(
                color: Colors.green,
                width: 100,
                height: 100,
              );
            }
          },
          itemCount: state.notes.size,
        ),
        loadFailure: (state) => Container(
          color: Colors.yellow,
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
