abstract class DataBaseprovider<T, K> {
  Future<void> initialize();

  Future<void> create({required K key, required T data});

  Future<Iterable<T>> retrieve({required Iterable<K> keys});

  Future<void> update({required K key, required T data});

  Future<void> delete({required K key});
}
