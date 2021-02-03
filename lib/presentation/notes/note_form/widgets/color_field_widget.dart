import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_firebase_ddd_course/application/notes/note_form/note_form_bloc.dart';
import 'package:notes_firebase_ddd_course/domain/notes/value_objects.dart';

class ColorField extends StatelessWidget {
  const ColorField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteFormBloc, NoteFormState>(
      buildWhen: (previous, current) =>
          previous.note.color != current.note.color,
      builder: (context, state) {
        // Horizonal ListView needs to be wrapped with a Container to be able to define height
        return Container(
          height: 80.0,
          child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final Color itemColor = NoteColor.predefinedColors[index];
                return GestureDetector(
                  onTap: () {
                    BlocProvider.of<NoteFormBloc>(context)
                        .add(NoteFormEvent.colorChanged(itemColor));
                  },
                  child: Material(
                    color: itemColor,
                    elevation: 4.0,
                    shape: CircleBorder(
                      side: state.note.color.value.fold(
                        (l) => BorderSide.none,
                        (r) => r == itemColor
                            ? const BorderSide(width: 1.5)
                            : BorderSide.none,
                      ),
                    ),
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 12.0,
                );
              },
              itemCount: NoteColor.predefinedColors.length),
        );
      },
    );
  }
}
