import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notes_firebase_ddd_course/domain/core/failures.dart';
import 'package:notes_firebase_ddd_course/domain/core/value_objects.dart';
import 'package:notes_firebase_ddd_course/domain/notes/value_objects.dart';

part "todo_item.freezed.dart";

/// TodoItem entity represents a todo item within a note
/// Needs to implement [_$TodoItem] instead of mixin because of custom getters
@freezed
abstract class TodoItem implements _$TodoItem {
  /// This private ctor is required for implementing [_$TodoItem] with custom getters
  const TodoItem._();

  // ignore: sort_unnamed_constructors_first
  const factory TodoItem({
    @required UniqueId id,
    @required TodoName name,
    @required bool done,
  }) = _TodoItem;

  factory TodoItem.empty() => TodoItem(
        id: UniqueId(),
        name: TodoName(""),
        done: false,
      );

  Option<ValueFailure<dynamic>> get failureOption {
    return name.value.fold((f) => some(f), (_) => none());
  }
}
