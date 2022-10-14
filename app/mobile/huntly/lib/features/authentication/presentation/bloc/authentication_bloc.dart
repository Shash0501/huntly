import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:huntly/features/authentication/data/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/constants.dart';
import '../../data/profile_datasource.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) async {
      const String oAuthClientId =
          '363088523272-orkcfiqub7hshaq29pisji796or7ohpq.apps.googleusercontent.com';
      final GoogleSignIn googleSignIn = GoogleSignIn(
        // Optional clientId
        // serverClientId: '500990447063-tclvi1rdaaugi424hsnkt5kmdj0vfhhg.apps.googleusercontent.com',
        serverClientId: oAuthClientId,
        scopes: <String>[
          'email',
          'profile',
        ],
      );

      if (event is AuthenticationStarted) {
        emit(AuthenticationLoading());
        GoogleSignInAccount? _currentUser;
        String _contactText = '';

        googleSignIn.onCurrentUserChanged
            .listen((GoogleSignInAccount? account) {
          _currentUser = account;
        });
        googleSignIn.signInSilently();

        try {
          final googleUser = await googleSignIn.signIn();
          final googleAuth = await googleUser!.authentication;

          var params = {
            "access_token": googleAuth.accessToken,
          };

          Response response = await Dio().post(
            "${url}users/auth/social/google-oauth2/",
            options: Options(
              headers: {
                "Accept": "application/json",
                "Content-Type": "application/json",
              },
            ),
            data: jsonEncode(params),
          );

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("token", response.data["token"]);
          emit(AuthenticationSuccess());
        } catch (e) {
          // Authentication Failure

          print("Authentication Failure");
          //!! remove the below line
          emit(AuthenticationFailure());
          debugPrint(e.toString());
        }
      } else if (event is AuthenticationLogOut) {
        googleSignIn.disconnect();
      } else if (event is AddProfileEvent) {
        print("Add profile Model");
        print(event.bio);
        emit(Loading());
        try {
          final googleUser = await googleSignIn.signIn();
          final googleAuth = await googleUser!.authentication;

          Map<String, String> interestParams = {};
          event.interests.forEach((element) {
            if (interestParams[element.category] == null) {
              interestParams[element.category] = element.interest;
            } else {
              interestParams[element.category] =
                  "${interestParams[element.category]} , ${element.interest}";
            }
          });

          var interestParamsJson = jsonEncode(interestParams);
          print("Interests : $interestParamsJson");
          var params = {
            "first_name": googleUser.displayName,
            "last_name": "",
            "gender": "M",
            "date_of_birth": "1999-01-01",
            "phone_no": "",
            "bio": event.bio,
            "interests": interestParamsJson
          };
          final _prefs = await SharedPreferences.getInstance();
          Response response = await Dio().put(
            "${url}users/update/",
            options: Options(
              headers: {
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "Token ${_prefs.getString("token")}"
              },
            ),
            data: jsonEncode(params),
          );

          print("Response => ${response.data}");
          // response.data = {token : 213414124}
          // get token from response
          // save token in shared preferences
          // print("Token: $token");

          final prefs = await SharedPreferences.getInstance();
          // prefs.setString("token", token);

          prefs.setInt("profile", 1);
          emit(ProfileAdded());
        } catch (e) {
          // Authentication Failure
          print("Failure");
          emit(AuthenticationFailure());
          debugPrint(e.toString());
        }
      } else if (event is GetProfileEvent) {
        print("Get Profile Event");
        emit(Loading());
        try {
          // get profile from profile_datasource.dart
          ProfileDataSourceImpl profileDataSourceImpl = ProfileDataSourceImpl();
          ProfileModel profile = await profileDataSourceImpl.fetchProfile();

          emit(ProfileLoaded(profileModel: profile));
        } catch (e) {
          // Authentication Failure
          print("Failure");
          emit(AuthenticationFailure());
          debugPrint(e.toString());
        }
      }
    });
  }
}
