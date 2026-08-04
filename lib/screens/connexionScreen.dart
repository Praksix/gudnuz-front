import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gudnuz/services/auth_service.dart';
import 'package:gudnuz/theme/colors.dart';

class ConnexionScreen extends StatefulWidget {
  const ConnexionScreen({super.key});

  @override
  State<ConnexionScreen> createState() => _ConnexionScreenState();
}

class _ConnexionScreenState extends State<ConnexionScreen> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService        = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onConnexion() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
      }
    } on DioException catch (e) {
      setState(() {
        _errorMessage = e.response?.statusCode == 401
            ? 'Email ou mot de passe incorrect'
            : 'Erreur réseau, réessaie plus tard';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text("GUDNUZ", style: TextStyle(fontSize: 62, fontWeight: FontWeight.w900)),
            const SizedBox(height: 50),
            Image.asset('assets/images/black-spark.png'),
            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                  const SizedBox(height: 50),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Mot de passe',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ],
              ),
            ),

            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_errorMessage!, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
              ),

            const SizedBox(height: 39),

            ElevatedButton(
              onPressed: _isLoading ? null : _onConnexion,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 7),
                backgroundColor: Colors.black,
                side: const BorderSide(color: Colors.black, width: 1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: kYellow, strokeWidth: 2))
                  : const Text('Connexion', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: kYellow)),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/inscription'),
              child: const Text(
                "Pas encore de compte ? S'inscrire",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}