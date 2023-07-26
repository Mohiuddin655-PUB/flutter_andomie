part of 'entities.dart';

typedef EntityBuilder<T> = T Function(dynamic value);

extension EntityObjectHelper on Object? {
  bool get isEntity => this is Map<String, dynamic>;

  String? get entityId => isEntity ? Entity.autoId(this) : null;

  int? get entityTimeMills => isEntity ? Entity.autoTimeMills(this) : null;

  T? entityObject<T>(
    String key,
    EntityBuilder<T> builder,
  ) {
    return isEntity ? Entity.object(key, this, builder) : null;
  }

  List<T>? entityObjects<T>(
    String key,
    EntityBuilder<T> builder,
  ) {
    return isEntity ? Entity.objects(key, this, builder) : null;
  }

  T? entityType<T>(
    String key,
    EntityBuilder<T> builder,
  ) {
    return isEntity ? Entity.type(key, this, builder) : null;
  }

  T? entityValue<T>(String key) {
    return isEntity ? Entity.value(key, this) : null;
  }

  List<T>? entityValues<T>(String key) {
    return isEntity ? Entity.values(key, this) : null;
  }
}

extension EntityMapHelper on Map<String, dynamic>? {
  String? get id => use[EntityKey.i.id];

  Map<String, dynamic> withId(String id) => attach({EntityKey.i.id: id});
}

class Entity<KEY extends EntityKey> {
  String? _id;
  int? _timeMills;

  String get id => _id ?? generateID;

  int get idInt => int.tryParse(id).use;

  int get timeMills => _timeMills ?? generateTimeMills;

  set id(String value) => _id = value;

  set timeMills(int value) => _timeMills = value;

  Entity({
    String? id,
    int? timeMills,
  })  : _id = id ?? generateID,
        _timeMills = timeMills ?? generateTimeMills;

  factory Entity.from(dynamic source) {
    return Entity(
      id: Entity.autoId(source),
      timeMills: Entity.autoTimeMills(source),
    );
  }

  factory Entity.root(dynamic source) => Entity.from(source);

  KEY get keys => EntityKey.i as KEY;

  Map<String, dynamic> get source {
    return {
      keys.id: id,
      keys.timeMills: timeMills,
    };
  }

  static String get generateID => generateTimeMills.toString();

  static int get generateTimeMills => DateTime.now().millisecondsSinceEpoch;

  static dynamic _v(String key, dynamic source) {
    if (source is Map<String, dynamic>) {
      return source[key];
    } else {
      return null;
    }
  }

  static String? autoId(dynamic source) {
    final data = _v(EntityKey.i.id, source);
    if (data is int || data is String) {
      return "$data";
    } else {
      return null;
    }
  }

  static int? autoTimeMills(dynamic source) {
    final data = _v(EntityKey.i.timeMills, source);
    if (data is int) {
      return data;
    } else if (data is String) {
      return int.tryParse(data);
    } else {
      return null;
    }
  }

  static T? value<T>(String key, dynamic source) {
    final data = _v(key, source);
    if (data is T) {
      return data;
    } else {
      return null;
    }
  }

  static List<T>? values<T>(String key, dynamic source) {
    final data = _v(key, source);
    if (data is List) {
      final list = <T>[];
      for (var item in data) {
        if (item is T) {
          list.add(item);
        }
      }
      return list;
    } else {
      return null;
    }
  }

  static T? type<T>(
    String key,
    dynamic source,
    EntityBuilder<T> builder,
  ) {
    final data = _v(key, source);
    if (data is String) {
      return builder.call(data);
    } else {
      return null;
    }
  }

  static T? object<T>(
    String key,
    dynamic source,
    EntityBuilder<T> builder,
  ) {
    final data = _v(key, source);
    if (data is Map) {
      return builder.call(data);
    } else {
      return null;
    }
  }

  static List<T>? objects<T>(
    String key,
    dynamic source,
    EntityBuilder<T> builder,
  ) {
    final data = _v(key, source);
    if (data is List<Map<String, dynamic>>) {
      return data.map((e) => builder.call(e)).toList();
    } else {
      return null;
    }
  }

  String get time {
    final date = DateTime.fromMillisecondsSinceEpoch(timeMills);
    return DateFormat("hh:mm a").format(date);
  }

  String get date {
    final date = DateTime.fromMillisecondsSinceEpoch(timeMills);
    return DateFormat("MMM dd, yyyy").format(date);
  }

  String get realtime => DateProvider.toRealtime(timeMills, showRealtime: true);

  @override
  String toString() => source.toString();
}

class EntityKey<Child> {
  const EntityKey({
    this.id = "id",
    this.timeMills = "time_mills",
  });

  final String id;
  final String timeMills;

  static EntityKey? _proxy;

  static EntityKey get i => _proxy ??= const EntityKey();

  static EntityKey get I => i;

  static EntityKey get instance => i;
}
