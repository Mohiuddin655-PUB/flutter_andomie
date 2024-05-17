typedef SingletonInstanceCaller<T extends Object> = T Function();
typedef SingletonAsyncInstanceCaller<T extends Object> = Future<T> Function();

class Singleton {
  const Singleton._();

  static final Map<Type, dynamic> _proxies = {};

  /// Singleton class like:
  ///
  /// class A {
  ///   A._(); // Private constructor
  ///
  ///   static A get instance => Singleton.instanceOf(() => A._());
  /// }
  static T instanceOf<T extends Object>(
    SingletonInstanceCaller<T> caller,
  ) {
    return _proxies[T] ??= caller.call();
  }

  /// Async singleton class like:
  ///
  /// class A {
  ///   A._(); // Private constructor
  ///
  ///   static Future<A> get instance => Singleton.asyncInstanceOf(() async => A._());
  /// }
  static Future<T> asyncInstanceOf<T extends Object>(
    SingletonAsyncInstanceCaller<T> callback,
  ) async {
    return _proxies[T] ??= await callback.call();
  }
}
