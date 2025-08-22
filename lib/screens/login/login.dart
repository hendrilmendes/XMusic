import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Adicionamos 'SingleTickerProviderStateMixin' para a animação
class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;

  // Controladores para a animação de entrada
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _checkSavedLogin();

    // Configuração da animação
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
       CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Inicia a animação
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // --- Lógica de autenticação (sem alterações) ---
  Future<void> _checkSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('loggedIn') ?? false;
    if (loggedIn && _auth.currentUser != null) {
      _navigateToHome();
    }
  }

  Future<void> _signInWithGoogle() async {
    if (isLoading) return;
    setState(() => isLoading = true);
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => isLoading = false);
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await _auth.signInWithCredential(credential);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', true);
      if (mounted) _navigateToHome();
    } catch (e) {
      debugPrint('Erro no login com Google: $e');
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _navigateToHome() {
    context.pushReplacement('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.9)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.music_note_rounded, color: Colors.white, size: 30),
                          const SizedBox(width: 8),
                          Text(
                            'XMusic',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Text(
                            'Música para todos.',
                            style: GoogleFonts.montserrat(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'A trilha sonora perfeita para a sua vida está a um clique de distância.',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          _buildGoogleButton(),
                          const SizedBox(height: 20),
                          _buildTermsText(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _signInWithGoogle,
        icon: isLoading
            ? const SizedBox.shrink()
            : Image.asset('assets/images/google_logo.png', height: 22.0),
        label: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                    strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
            : Text(
                'Continuar com o Google',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildTermsText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        'Ao continuar, você concorda com os nossos Termos de Uso e a nossa Política de Privacidade.',
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(
          fontSize: 11,
          color: Colors.white.withOpacity(0.6),
        ),
      ),
    );
  }
}