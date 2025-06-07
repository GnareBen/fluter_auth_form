import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluter_auth_form/common/auth_exception.dart';
import 'package:fluter_auth_form/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();

  AuthBloc() : super(AuthInitial()) {
    // Écouter les changements d'état d'authentification
    _authRepository.authStateChanges.listen((user) {
      add(AuthUserChanged(user));
    });

    on<AuthUserChanged>(_onAuthUserChanged);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);

    // Vérifier l'état initial
    final currentUser = _authRepository.currentUser;
    if (currentUser != null) {
      add(AuthUserChanged(currentUser));
    } else {
      add(AuthUserChanged(null));
    }
  }

  Future<void> _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.user != null) {
      emit(AuthAuthenticated(user: event.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  FutureOr<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authRepository.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      if (userCredential.user != null) {
        emit(AuthAuthenticated(user: userCredential.user!));
        emit(AuthLoginSuccess());
      }
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(
        AuthError(
          message: 'Une erreur inattendue est survenue lors de la connexion',
        ),
      );
    }
  }

  FutureOr<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authRepository.signUpWithEmailAndPassword(
        event.email,
        event.password,
      );
      if (userCredential.user != null) {
        emit(AuthRegisterSuccess());
        emit(AuthAuthenticated(user: userCredential.user!));
      }
    } on AuthException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(
        AuthError(
          message: 'Une erreur inattendue est survenue lors de l\'inscription',
        ),
      );
    }
  }

  FutureOr<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthLogoutSuccess());
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(
        AuthError(message: 'Une erreur est survenue lors de la déconnexion'),
      );
      // Même en cas d'erreur, on considère que l'utilisateur est déconnecté localement
      emit(AuthUnauthenticated());
    }
  }
}
