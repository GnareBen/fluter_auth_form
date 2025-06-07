import 'package:fluter_auth_form/bloc/auth_bloc.dart';
import 'package:fluter_auth_form/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated || state is AuthLogoutSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Accueil'),
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthLogoutRequested());
              },
              icon: const Icon(Icons.logout),
              tooltip: 'Se déconnecter',
            ),
          ],
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AuthAuthenticated) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 50),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Bienvenue !',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.email),
                              title: const Text('Email'),
                              subtitle: Text(
                                state.user.email ?? 'Non disponible',
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.verified_user),
                              title: const Text('Email vérifié'),
                              subtitle: Text(
                                state.user.emailVerified ? 'Oui' : 'Non',
                              ),
                              trailing: state.user.emailVerified
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : const Icon(
                                      Icons.warning,
                                      color: Colors.orange,
                                    ),
                            ),
                            if (state.user.displayName != null)
                              ListTile(
                                leading: const Icon(Icons.person),
                                title: const Text('Nom'),
                                subtitle: Text(state.user.displayName!),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(
              child: Text('État d\'authentification inconnu'),
            );
          },
        ),
      ),
    );
  }
}
