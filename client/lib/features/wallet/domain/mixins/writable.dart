mixin Writable<T> {
  Future<bool> create(T entity);
  Future<bool> update(T entity);
  Future<bool> delete(int id);
}
