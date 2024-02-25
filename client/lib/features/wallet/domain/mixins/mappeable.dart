mixin Mappeable<T, K extends T> {
  T modelToEntity(K model);
  K entityToModel(T entity);
  // K mapToModel(Map<String, dynamic> data);
}
