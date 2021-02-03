import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:notes_firebase_ddd_course/application/notes/note_form/note_form_bloc.dart';
import 'package:notes_firebase_ddd_course/domain/notes/value_objects.dart';

class BodyField extends HookWidget {
  const BodyField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController =
        useTextEditingController();

    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (previous, current) =>
          previous.isEditing != current.isEditing,
      listener: (context, state) {
        textEditingController.text = state.note.body.getOrCrash();
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          controller: textEditingController,
          decoration: const InputDecoration(
            labelText: "Note",
            counterText: "",
          ),
          maxLength: NoteBody.maxLength,
          maxLines: null,
          minLines: 5,
          onChanged: (value) => BlocProvider.of<NoteFormBloc>(context)
              .add(NoteFormEvent.bodyChanged(value)),
          validator: (value) => BlocProvider.of<NoteFormBloc>(context)
              .state
              .note
              .body
              .value
              .fold(
                (l) => l.maybeMap(
                    empty: (l) => "Cannot be empty",
                    exceedingLength: (l) => "Exceeding length. Max: ${l.max}",
                    orElse: () => null),
                (r) => null,
              ),
        ),
      ),
    );
  }
}
