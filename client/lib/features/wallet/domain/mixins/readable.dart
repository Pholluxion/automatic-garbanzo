mixin Readable<T> {
  Future<List<T>> getAll();
  Future<T> getById(int id);
}

mixin ReadableWithParams<T, P> {
  Future<List<T>> getAllById(P params);
}
