part of 'component_cubit.dart';

sealed class ComponentState extends Equatable {
  const ComponentState();

  @override
  List<Object> get props => [];
}

final class ComponentInitial extends ComponentState {}

final class ComponentLoading extends ComponentState {}

final class ComponentError extends ComponentState {
  final String message;

  const ComponentError(this.message);

  @override
  List<Object> get props => [message];
}

final class ComponentLoaded extends ComponentState {
  final List<Component> components;

  const ComponentLoaded(this.components);

  @override
  List<Object> get props => [components];
}
