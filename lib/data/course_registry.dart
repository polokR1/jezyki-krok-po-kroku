import '../domain/models/course.dart';
import 'courses/english_course.dart';
import 'courses/greek_course.dart';
import 'courses/spanish_course.dart';
import 'courses/swedish_course.dart';

final courses = <LanguageCourse>[
  englishCourse,
  spanishCourse,
  greekCourse,
  swedishCourse,
];

LanguageCourse? courseById(String? id) {
  if (id == null) return null;
  for (final course in courses) {
    if (course.id == id) return course;
  }
  return null;
}
