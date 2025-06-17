import 'package:flutter/material.dart';
import '../services/supabase_services.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const RegisterScreen({super.key, required this.onToggleTheme});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String error = '';

  void register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final response = await SupabaseService.signUp(email, password);

      if (response != null && response.user != null) {
        await SupabaseService.upsertUserProfile(
          userId: response.user!.id,
          email: email,
          dailyGoal: 4000,
        );

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen(onToggleTheme: widget.onToggleTheme),
            ),
          );
        }
      } else {
        setState(() {
          error = 'Registration failed. Try again.';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Unexpected error: $e';
      });
    }
  }

  void goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(onToggleTheme: widget.onToggleTheme),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kayıt Ol"),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Ayarlar',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Tema Değiştir'),
              onTap: widget.onToggleTheme,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                autocorrect: false,
                enableSuggestions: false,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
                autocorrect: false,
                enableSuggestions: false,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: register,
                child: const Text("Kayıt Ol"),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: goToLogin,
                child: const Text("Zaten hesabın var mı? Giriş yap"),
              ),
              if (error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(error, style: const TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
