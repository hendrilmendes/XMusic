import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;
  bool rememberMe = true;

  @override
  void initState() {
    super.initState();
    _checkSavedLogin();
  }

  Future<void> _checkSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('loggedIn') ?? false;
    if (loggedIn && _auth.currentUser != null) {
      _navigateToHome();
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => isLoading = true);
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', true);

      _navigateToHome();
    } catch (e) {
      debugPrint('Erro no login: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    var size = MediaQuery.of(context).size;

    final primaryColor =
        isDarkMode
            ? const Color.fromARGB(255, 0, 47, 255)
            : const Color.fromARGB(255, 70, 115, 255);
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final cardColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final dividerColor = isDarkMode ? Colors.grey : Colors.grey[400];
    final iconColor = isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      body: Stack(
        children: [
          // Fundo
          Container(
            height: size.height,
            width: size.width,
            color: backgroundColor,
          ),

          // Forma decorativa no topo
          Container(
            height: size.height * 0.65,
            width: size.width,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.elliptical(500, 180),
              ),
            ),
          ),

          // Card central
          Positioned(
            top: 240,
            left: 40,
            child: SizedBox(
              height: size.height * 0.55,
              width: size.width * 0.8,
              child: Card(
                color: cardColor,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bem-vindo ao XMusic',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Botão de login por email
                      SignInButton(
                        Buttons.Email,
                        onPressed:
                            () =>
                                Navigator.of(context).pushNamed('/email_login'),
                        text: "Entrar com E-mail",
                      ),
                      const SizedBox(height: 12),

                      // Indicador de carregamento
                      if (isLoading) ...[
                        CircularProgressIndicator(color: primaryColor),
                        const SizedBox(height: 12),
                      ],

                      // Botão de login com Google
                      SignInButton(
                        Buttons.Google,
                        onPressed: _signInWithGoogle,
                        text: "Entrar com o Google",
                      ),
                      const SizedBox(height: 24),

                      // Divisor
                      Row(
                        children: [
                          Expanded(child: Divider(color: dividerColor)),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              'ou',
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                          Expanded(child: Divider(color: dividerColor)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Botão para criação de conta
                      TextButton(
                        onPressed:
                            () => Navigator.of(
                              context,
                            ).pushNamed('/create_account'),
                        child: Text(
                          "Criar conta",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Ícone do app
          Positioned(
            top: 78,
            left: 0,
            right: 0,
            child: Center(
              child: Icon(Icons.music_note_rounded, color: iconColor, size: 64),
            ),
          ),

          // Mensagem de slogan
          Positioned(
            top: 190,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Milhões de músicas, gratuitas no XMusic',
                style: TextStyle(color: iconColor, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
