import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_firebase_ddd_course/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:notes_firebase_ddd_course/domain/notes/note.dart';
import 'package:notes_firebase_ddd_course/presentation/notes/notes_overview/widgets/critical_failure_display_widget.dart';
import 'package:notes_firebase_ddd_course/presentation/notes/notes_overview/widgets/error_note_card_widget.dart';
import 'package:notes_firebase_ddd_course/presentation/notes/notes_overview/widgets/note_card_widget.dart';

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
              return ErrorNoteCard(
                note: note,
              );
            } else {
              return NoteCard(
                note: note,
              );
            }
          },
          itemCount: state.notes.size,
        ),
        loadFailure: (state) => CriticalFailureDisplay(
          failure: state.noteFailure,
        ),
      ),
    );
  }
}
