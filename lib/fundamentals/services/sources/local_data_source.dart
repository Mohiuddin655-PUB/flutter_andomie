part of 'sources.dart';

abstract class LocalDataSource<T extends Entity> extends DataSource<T> {
  final String path;
  final SharedPreferences db;

  const LocalDataSource({
    required this.path,
    required this.db,
  });
}
