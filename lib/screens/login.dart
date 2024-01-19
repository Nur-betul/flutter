import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ticket_app/screens/theaters.dart';

User? globaluser;

class LoginPage extends StatefulWidget {
  final SupabaseClient client;

  const LoginPage({required this.client});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _imageUrl; 
  Future<void> signUp() async {
    try {
      final AuthResponse response = await widget.client.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kayıt başarılı!")),
        );

        // Navigate to the Dashboard page after successful sign-up
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventWidget(
              eventData: {},
            ),
          ),
        );
        //await createPersonalDatabase(_emailController.text);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Kayıt başarısız!")));
      }
    } catch (e) {
      if (e is AuthException) {
        print("Sign Up/In failed: ${e.message}, statusCode: ${e.statusCode}");
        if (e.statusCode == 429) {
          // Handle rate limit exceeded error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text("Fazla giriş denemesi. Daha sonra tekrar deneyiniz.")),
          );
        } else if (e.statusCode == 400) {
          // Handle invalid credentials error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Geçersiz kimlik bilgileri. Lütfen e-postanızı ve şifrenizi kontrol edin.")),
          );
        } else {
          // Handle other errors if needed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Kayıt/Giriş hatalı. Lütfen daha sonra tekrar deneyin.")),
          );
        }
      } else {
        // Handle other types of exceptions if needed
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Bir hata oluştu. Lütfen daha sonra tekrar deneyiniz.")),
        );
      }
    }
  }

  Future<void> signIn(BuildContext context) async {
    try {
      final response_real = await widget.client.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (response_real.user != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Giriş başarılı!")));

        globaluser = response_real.user;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => TheaterList()),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Giriş başarısız")));
      }
    } catch (e) {
      if (e is AuthException) {
        print("Sign Up/In failed: ${e.message}, statusCode: ${e.statusCode}");
        if (e.statusCode == 429) {
          // Handle rate limit exceeded error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text("Fazla giriş denemesi. Daha sonra tekrar deneyiniz.")),
          );
        } else if (e.statusCode == 400) {
          // Handle invalid credentials error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Geçersiz kimlik bilgileri. Lütfen e-postanızı ve şifrenizi kontrol edin.")),
          );
        } else {
          // Handle other errors if needed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Kayıt/Giriş hatalı. Lütfen daha sonra tekrar deneyin.")),
          );
        }
      } else {
        // Handle other types of exceptions if needed
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Bir hata oluştu. Lütfen daha sonra tekrar deneyiniz.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giriş Ekranı")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Şifre'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () => signIn(context),
                child: const Text('Giriş yap')),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: signUp, child: const Text('Kayıt ol')),
          ],
        ),
      ),
    );
  }
}
