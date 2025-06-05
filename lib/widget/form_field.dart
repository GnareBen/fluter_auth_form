import 'package:fluter_auth_form/widget/custom_buton.dart';
import 'package:fluter_auth_form/widget/text_form_field.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre email';
              }
              if (!value.contains('@')) {
                return 'Email invalide';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre mot de passe';
              }
              if (value.length < 6) {
                return 'Le mot de passe doit contenir au moins 6 caractères';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: "Se connecter",
            backgroundColor: Colors.blue[800],
            textColor: Colors.white,
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                // Process the login
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connexion réussie')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
