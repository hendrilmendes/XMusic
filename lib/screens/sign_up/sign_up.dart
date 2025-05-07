import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', true);

      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      setState(() => errorMessage = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (errorMessage.isNotEmpty)
                Text(errorMessage, style: const TextStyle(color: Colors.red)),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator:
                    (value) => value!.contains('@') ? null : 'E-mail inválido',
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator:
                    (value) => value!.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _createAccount,
                    child: const Text('Criar Conta'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
