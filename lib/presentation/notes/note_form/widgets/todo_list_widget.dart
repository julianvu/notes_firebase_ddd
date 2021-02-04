import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kt_dart/kt.dart';
import 'package:notes_firebase_ddd_course/application/notes/note_form/note_form_bloc.dart';
import 'package:notes_firebase_ddd_course/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:provider/provider.dart';
import 'package:notes_firebase_ddd_course/presentation/notes/note_form/misc/build_context_x.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (previous, current) =>
          previous.note.todos.isFull != current.note.todos.isFull,
      listener: (context, state) {
        if (state.note.todos.isFull) {
          FlushbarHelper.createAction(
            message: "Want longer lists? Activate Premium 🤩",
            duration: const Duration(seconds: 5),
            button: FlatButton(
              onPressed: () {},
              child: const Text(
                "BUY NOW",
                style: TextStyle(color: Colors.yellow),
              ),
            ),
          ).show(context);
        }
      },
      child: Consumer<FormTodos>(
        builder: (context, formTodos, child) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: formTodos.value.size,
            itemBuilder: (context, index) {
              return TodoTile(index: index);
            },
          );
        },
      ),
    );
  }
}

class TodoTile extends HookWidget {
  final int index;

  const TodoTile({
    @required this.index,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TodoItemPrimitive todo =
        context.formTodos.getOrElse(index, (_) => TodoItemPrimitive.empty());

    return ListTile(
      leading: Checkbox(
        onChanged: (value) {
          context.formTodos = context.formTodos.map(
            (listTodo) =>
                listTodo == todo ? todo.copyWith(done: value) : listTodo,
          );
          BlocProvider.of<NoteFormBloc>(context)
              .add(NoteFormEvent.todosChanged(context.formTodos));
        },
        value: todo.done,
      ),
    );
  }
}
