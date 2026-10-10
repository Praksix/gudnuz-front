import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gudnuz/services/api_service.dart';
import 'package:gudnuz/theme/colors.dart';
import '../utils/constants.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les deux mots de passe ne correspondent pas')),
      );
      return;
    }

    // Même règle que le @Size(min = 8) du back : on évite d'envoyer une requête vouée à l'échec.
    // Le back garde sa validation (on peut appeler l'API sans passer par l'app).
    if (_newPasswordController.text.length < minPasswordLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le nouveau mot de passe doit faire au moins $minPasswordLength caractères')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final formData = FormData.fromMap({
        'currentPassword': _currentPasswordController.text,
        'newPassword': _newPasswordController.text,
      });

      await ApiService.dio.patch(
        '/users/me',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mot de passe modifié !')),
      );
      Navigator.pop(context);

    } on DioException catch (e) {
      final message = e.response?.statusCode == 400
          ? 'Mot de passe actuel incorrect'
          : 'Une erreur est survenue, réessaie plus tard';
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EDE1),
      appBar: AppBar(
        title: const Text('Mot de passe', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe actuel',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nouveau mot de passe',
                border: OutlineInputBorder(),
                helperText: '8 caractères minimum',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirme le nouveau mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: kYellow),
                    )
                  : const Text('Valider', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kYellow)),
            ),
          ],
        ),
      ),
    );
  }
}