import 'package:fluter_auth_form/bloc/auth_bloc.dart';
import 'package:fluter_auth_form/common/form_validator.dart';
import 'package:fluter_auth_form/screens/auth/login_screen.dart';
import 'package:fluter_auth_form/screens/home_screen.dart';
import 'package:fluter_auth_form/widget/custom_buton.dart';
import 'package:fluter_auth_form/widget/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          _emailController.text.trim(),
          _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inscription réussie ! Bienvenue !'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                label: 'Email',
                hint: 'Entrez votre email',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (value) => Validator.email(value),
                enabled: !isLoading,
              ),
              const SizedBox(height: 18),
              CustomTextFormField(
                label: 'Mot de passe',
                hint: 'Créez un mot de passe',
                prefixIcon: Icons.lock,
                suffixIcon: _isPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                obscureText: !_isPasswordVisible,
                controller: _passwordController,
                onSuffixIconPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                validator: (value) => Validator.password(value),
                enabled: !isLoading,
              ),
              const SizedBox(height: 18),
              CustomTextFormField(
                label: 'Confirmer le mot de passe',
                hint: 'Confirmez votre mot de passe',
                prefixIcon: Icons.lock_outline,
                suffixIcon: _isConfirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                obscureText: !_isConfirmPasswordVisible,
                controller: _confirmPasswordController,
                onSuffixIconPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
                validator: (value) =>
                    Validator.confirmPassword(value, _passwordController.text),
                enabled: !isLoading,
              ),
              const SizedBox(height: 24),

              // Message d'information
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withAlpha(1)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Votre mot de passe doit contenir au moins 6 caractères',
                        style: TextStyle(color: Colors.blue[700], fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              state is AuthError
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : const SizedBox.shrink(),

              // Bouton d'inscription
              state is AuthLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      text: "S'inscrire",
                      backgroundColor: Colors.blue[800],
                      textColor: Colors.white,
                      onPressed: _register,
                    ),

              const SizedBox(height: 16),

              // Lien vers la connexion
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Déjà un compte ? '),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                    child: const Text(
                      'Se connecter',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
