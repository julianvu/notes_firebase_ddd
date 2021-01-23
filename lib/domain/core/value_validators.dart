import 'package:dartz/dartz.dart';
import 'package:notes_firebase_ddd_course/domain/core/failures.dart';

/// Validates [input] to ensure it is properly formatted as an email address
Either<ValueFailure<String>, String> validateEmailAddress(String input) {
  // May not be safest email validation regex
  const emailRegex =
      r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
  if (RegExp(emailRegex).hasMatch(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidEmail(failedValue: input));
  }
}

/// Validates [input] to ensure it is a password
Either<ValueFailure<String>, String> validatePassword(String input) {
  if (input.length >= 6) {
    return right(input);
  } else {
    return left(ValueFailure.shortPassword(failedValue: input));
  }
}
