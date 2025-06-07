class Validator {
  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ est requis';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email est requis';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email invalide';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mot de passe est requis';
    }
    if (value.length < 8) {
      return 'Mot de passe doit contenir au moins 8 caractères';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Mot de passe est requis';
    }
    if (value != password) {
      return 'Mot de passe ne correspond pas';
    }
    return null;
  }
}
