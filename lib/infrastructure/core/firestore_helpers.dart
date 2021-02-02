import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:notes_firebase_ddd_course/domain/auth/i_auth_facade.dart';
import 'package:notes_firebase_ddd_course/domain/auth/user.dart';
import 'package:notes_firebase_ddd_course/domain/core/errors.dart';
import 'package:notes_firebase_ddd_course/injection.dart';

extension FirestoreX on FirebaseFirestore {
  Future<DocumentReference> userDocument() async {
    // Get signed in user
    final Option<User> userOption =
        await getIt<IAuthFacade>().getSignedInUser();

    // If getting the user fails, throw a NotAuthenticatedError
    final user = userOption.getOrElse(() => throw NotAuthenticatedError());

    return FirebaseFirestore.instance
        .collection("users")
        .doc(user.id.getOrCrash());
  }
}

extension DocumentReferenceX on DocumentReference {
  CollectionReference get noteCollection => collection("notes");
}
