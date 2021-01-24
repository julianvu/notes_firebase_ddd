import 'package:notes_firebase_ddd_course/domain/core/failures.dart';

class UnexpectedValueError extends Error {
  final ValueFailure valueFailure;

  UnexpectedValueError(this.valueFailure);

  @override
  String toString() => Error.safeToString(
      'Encounted a ValueFailure at an unrecoverable point. Terminating...\nUnexpectedValueError(valueFailure: $valueFailure)');
}
