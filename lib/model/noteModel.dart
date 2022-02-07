import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  Note({
    required this.imagePath,
    required this.pickedImagePath,
    required this.distilleryName,
    required this.aging,
    required this.region,
    required this.date,
    required this.nose,
    required this.taste,
    required this.finish,
    required this.comment,
  });

  final String imagePath;
  final String pickedImagePath;
  final String distilleryName;
  final String aging;
  final String region;
  final Timestamp date;
  final String nose;
  final String taste;
  final String finish;
  final String comment;
}

class NoteList extends StateNotifier<List<Note>> {
  NoteList([initialNote]) : super(initialNote ?? []);

  void updateNote(List<Note> newNote) {
    state = [for (final note in newNote) note];
  }
}
