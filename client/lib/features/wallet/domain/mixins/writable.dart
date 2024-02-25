mixin Writable<T> {
  Future<bool> create(T entity);
  Future<T> update(T entity);
  Future<bool> delete(int id);
}
