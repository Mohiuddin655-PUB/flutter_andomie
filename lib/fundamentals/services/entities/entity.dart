abstract class Entity {
  final String id;
  final int timeMills;

  const Entity({
    required this.id,
    this.timeMills = 0,
  });

  Map<String, dynamic> get source;
}
