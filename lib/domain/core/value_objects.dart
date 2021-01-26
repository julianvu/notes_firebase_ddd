import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notes_firebase_ddd_course/domain/core/errors.dart';
import 'package:notes_firebase_ddd_course/domain/core/failures.dart';
import 'package:uuid/uuid.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();

  /// The value of this ValueObject.
  Either<ValueFailure<T>, T> get value;

  /// Throws [UnexpectedValueError] containing the [ValueFailure]
  T getOrCrash() {
    // id = identity = same as (right) => right
    return value.fold((left) => throw UnexpectedValueError(left), id);
  }

  /// Returns `true` if the value is valid.
  bool isValid() => value.isRight();

  /// Returns `true` if the values are equal or identical.
  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ValueObject<T> && o.value == value;
  }

  /// The hashcode of this EmailAddress.
  @override
  int get hashCode => value.hashCode;

  /// Returns the string representation of this EmailAddress.
  @override
  String toString() => 'Value(value: $value)';
}

class UniqueId extends ValueObject<String> {
  @override
  // TODO: implement value
  final Either<ValueFailure<String>, String> value;

  factory UniqueId() {
    return UniqueId._(
      right(Uuid().v1()),
    );
  }

  factory UniqueId.fromUniqueString(String uniqueId) {
    assert(uniqueId != null);
    return UniqueId._(
      right(uniqueId),
    );
  }

  const UniqueId._(this.value);
}
