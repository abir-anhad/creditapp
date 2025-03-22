// lib/app/core/state/base_state.dart
abstract class BaseState {
  const BaseState();
}

class InitialState extends BaseState {
  const InitialState();
}

class LoadingState extends BaseState {
  const LoadingState();
}

class ErrorState extends BaseState {
  final String message;
  final List<String>? errors;

  const ErrorState({required this.message, this.errors});
}

class SuccessState extends BaseState {
  final String message;

  const SuccessState(this.message);
}