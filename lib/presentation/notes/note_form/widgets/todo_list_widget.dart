import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:kt_dart/kt.dart';
import 'package:notes_firebase_ddd_course/application/notes/note_form/note_form_bloc.dart';
import 'package:notes_firebase_ddd_course/domain/notes/value_objects.dart';
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
          return ImplicitlyAnimatedReorderableList<TodoItemPrimitive>(
            shrinkWrap: true,
            items: formTodos.value.asList(),
            areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
            onReorderFinished: (item, from, to, newItems) {
              context.formTodos = newItems.toImmutableList();
              BlocProvider.of<NoteFormBloc>(context)
                  .add(NoteFormEvent.todosChanged(context.formTodos));
            },
            itemBuilder: (context, itemAnimation, item, index) {
              return Reorderable(
                key: ValueKey(item.id),
                builder: (context, dragAnimation, inDrag) {
                  return ScaleTransition(
                    scale: Tween<double>(begin: 1, end: 0.95)
                        .animate(dragAnimation),
                    child: TodoTile(
                      index: index,
                      elevation: dragAnimation.value * 4,
                    ),
                  );
                },
              );
            },
            removeDuration: const Duration(),
          );
        },
      ),
    );
  }
}

class TodoTile extends HookWidget {
  final int index;
  final double elevation;

  const TodoTile({
    double elevation,
    @required this.index,
    Key key,
  })  : elevation = elevation ?? 0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final TodoItemPrimitive todo =
        context.formTodos.getOrElse(index, (_) => TodoItemPrimitive.empty());

    final TextEditingController textEditingController =
        useTextEditingController(text: todo.name);

    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      secondaryActions: [
        IconSlideAction(
          caption: "Delete",
          icon: Icons.delete,
          color: Colors.red,
          onTap: () {
            context.formTodos = context.formTodos.minusElement(todo);
            BlocProvider.of<NoteFormBloc>(context)
                .add(NoteFormEvent.todosChanged(context.formTodos));
          },
        )
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Material(
          elevation: elevation,
          animationDuration: const Duration(milliseconds: 50),
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0)),
            child: ListTile(
              leading: Checkbox(
                onChanged: (value) {
                  context.formTodos = context.formTodos.map(
                    (listTodo) => listTodo == todo
                        ? todo.copyWith(done: value)
                        : listTodo,
                  );
                  BlocProvider.of<NoteFormBloc>(context)
                      .add(NoteFormEvent.todosChanged(context.formTodos));
                },
                value: todo.done,
              ),
              trailing: const Handle(
                child: Icon(Icons.list),
              ),
              title: TextFormField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: "Todo",
                  counterText: "",
                  border: InputBorder.none,
                ),
                maxLength: TodoName.maxLength,
                onChanged: (value) {
                  context.formTodos = context.formTodos.map((listTodo) =>
                      listTodo == todo ? todo.copyWith(name: value) : listTodo);
                  BlocProvider.of<NoteFormBloc>(context)
                      .add(NoteFormEvent.todosChanged(context.formTodos));
                },
                validator: (_) {
                  return BlocProvider.of<NoteFormBloc>(context)
                      .state
                      .note
                      .todos
                      .value
                      .fold(
                        // Failure stemming from TodoList length should NOT be displayed by individual TextFormFields
                        (l) => null,
                        (todoList) => todoList[index].name.value.fold(
                              // If a failure exists
                              (l) => l.maybeMap(
                                empty: (_) => "Cannot be empty",
                                exceedingLength: (_) => "Todo name is too long",
                                multiline: (_) =>
                                    "Todo name can only be one line",
                                orElse: () => null,
                              ),
                              (r) => null, // Return null if no errors
                            ),
                      );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
