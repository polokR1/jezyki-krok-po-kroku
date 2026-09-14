import '../domain/models/course.dart';

LocalizedText text(String pl, String uk) => LocalizedText(pl: pl, uk: uk);

class ItemSeed {
  const ItemSeed(
    this.id,
    this.target,
    this.pl,
    this.uk, {
    this.pronunciation,
    this.exampleTarget,
    this.examplePl,
    this.exampleUk,
  });

  final String id;
  final String target;
  final String pl;
  final String uk;
  final String? pronunciation;
  final String? exampleTarget;
  final String? examplePl;
  final String? exampleUk;

  LearningItem build() => LearningItem(
    id: id,
    target: target,
    translation: text(pl, uk),
    pronunciation: pronunciation,
    exampleTarget: exampleTarget,
    exampleTranslation: examplePl == null || exampleUk == null
        ? null
        : text(examplePl!, exampleUk!),
  );
}

CourseLesson seedLesson({
  required String id,
  required String titlePl,
  required String titleUk,
  required String objectivePl,
  required String objectiveUk,
  required List<ItemSeed> items,
}) => CourseLesson(
  id: id,
  title: text(titlePl, titleUk),
  objective: text(objectivePl, objectiveUk),
  items: items.map((item) => item.build()).toList(growable: false),
);

CourseModule seedModule({
  required String id,
  required String titlePl,
  required String titleUk,
  required String descriptionPl,
  required String descriptionUk,
  required String level,
  required List<CourseLesson> lessons,
}) => CourseModule(
  id: id,
  title: text(titlePl, titleUk),
  description: text(descriptionPl, descriptionUk),
  level: level,
  lessons: lessons,
);
