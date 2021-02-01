import 'package:dartz/dartz.dart';
import 'package:kt_dart/kt.dart';
import 'package:notes_firebase_ddd_course/domain/notes/note.dart';
import 'package:notes_firebase_ddd_course/domain/notes/note_failure.dart';

abstract class INoteRepository {
  /// Watch notes
  Stream<Either<NoteFailure, KtList<Note>>> watchAll();

  /// Watch uncompleted notes
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted();

  /// Create a note
  Future<Either<NoteFailure, Unit>> create(Note note);

  /// Update a note
  Future<Either<NoteFailure, Unit>> update(Note note);

  /// Delete
  Future<Either<NoteFailure, Unit>> delete(Note note);
}
