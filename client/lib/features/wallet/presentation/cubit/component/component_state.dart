part of 'component_cubit.dart';

sealed class ComponentState extends Equatable {
  const ComponentState();

  @override
  List<Object> get props => [];
}

final class ComponentInitial extends ComponentState {}

final class ComponentLoading extends ComponentState {}

final class ComponentError extends ComponentState {
  const ComponentError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

final class ComponentLoaded extends ComponentState {
  const ComponentLoaded(this.components);
  final List<Component> components;

  @override
  List<Object> get props => [components];
}
