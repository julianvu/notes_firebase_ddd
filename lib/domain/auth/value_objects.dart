import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notes_firebase_ddd_course/domain/core/failures.dart';
import 'package:notes_firebase_ddd_course/domain/core/value_objects.dart';
import 'package:notes_firebase_ddd_course/domain/core/value_validators.dart';

/// A wrapper for strings to represent email addresses.
///
/// This class is more expressive and safe than just using a String since values
/// are validated on creation.
/// Validation during object creation makes illegal states unrepresentable!
class EmailAddress extends ValueObject<String> {
  /// The value of this email address.
  @override
  final Either<ValueFailure<String>, String> value;

  /// Factory constructor for creating EmailAddress objects.
  ///
  /// Passes [input] into [validateEmailAddress] before calling private ctor.
  factory EmailAddress(String input) {
    assert(input != null);
    return EmailAddress._(validateEmailAddress(input));
  }

  /// Private constructor for EmailAddress that accepts a validated input
  ///
  /// Value passed to constructor is validated by [validateEmailAddress].
  /// Privatized for safety.
  const EmailAddress._(this.value);
}

/// A wrapper for strings to represent passwords.
///
/// This class is more expressive and safe than just using a String since values
/// are validated on creation.
class Password extends ValueObject<String> {
  /// The value of this email address.
  @override
  final Either<ValueFailure<String>, String> value;

  /// Factory constructor for creating Password objects.
  ///
  /// Passes [input] into [validateEmailAddress] before calling private ctor.
  factory Password(String input) {
    assert(input != null);
    return Password._(validatePassword(input));
  }

  /// Private constructor for Password that accepts a validated input
  ///
  /// Value passed to constructor is validated by [validatePassword].
  /// Privatized for safety.
  const Password._(this.value);
}
