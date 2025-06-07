import 'package:fluter_auth_form/bloc/auth_bloc.dart';
import 'package:fluter_auth_form/common/form_validator.dart';
import 'package:fluter_auth_form/screens/auth/register_screen.dart';
import 'package:fluter_auth_form/screens/home_screen.dart';
import 'package:fluter_auth_form/widget/auth/register_form.dart';
import 'package:fluter_auth_form/widget/custom_buton.dart';
import 'package:fluter_auth_form/widget/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomFormField extends StatefulWidget {
  const CustomFormField({super.key});

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
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
        if (state is AuthLoginSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Connexion réussie !')));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
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
              ),
              const SizedBox(height: 18),
              CustomTextFormField(
                label: 'Mot de passe',
                hint: 'Entrez votre mot de passe',
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

              // Bouton de connexion
              state is AuthLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      text: "Se connecter",
                      backgroundColor: Colors.blue[800],
                      textColor: Colors.white,
                      onPressed: () {
                        _signIn();
                      },
                    ),

              const SizedBox(height: 16),

              // Lien vers la connexion
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Vous n\'avez pas de compte ? '),
                  TextButton(
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                    child: const Text(
                      'S\'inscrire',
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
