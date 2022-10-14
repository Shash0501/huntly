part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {}

class AuthenticationFailure extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationLogout extends AuthenticationState {}

class Loading extends AuthenticationState {}

class ProfileAdded extends AuthenticationState {}

class ProfileLoaded extends AuthenticationState {
  ProfileModel profileModel;

  ProfileLoaded({required this.profileModel});
}
