// lib/app/core/state/profile_state.dart
import '../data/models/user_model.dart';
import 'base_state.dart';

class ProfileState extends BaseState {
  const ProfileState();
}

class ProfileLoadingState extends ProfileState {
  const ProfileLoadingState();
}

class ProfileLoadedState extends ProfileState {
  final UserModel user;
  const ProfileLoadedState(this.user);
}

class ProfileUpdateLoadingState extends ProfileState {
  const ProfileUpdateLoadingState();
}

class ProfileUpdateSuccessState extends ProfileState {
  final String message;
  const ProfileUpdateSuccessState(this.message);
}

class ProfileUpdateErrorState extends ProfileState {
  final String message;
  final List<String>? errors;
  const ProfileUpdateErrorState({required this.message, this.errors});
}

class PasswordState extends BaseState {
  const PasswordState();
}

class PasswordLoadingState extends PasswordState {
  const PasswordLoadingState();
}

class PasswordSuccessState extends PasswordState {
  final String message;
  const PasswordSuccessState(this.message);
}

class PasswordErrorState extends PasswordState {
  final String message;
  final List<String>? errors;
  const PasswordErrorState({required this.message, this.errors});
}