import 'package:drivemanager/presenter/controllers/login_controller.dart';
import 'package:drivemanager/core/utils/load_panel.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Tela de login do usuário
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(); // Controlador para o campo de email
  final _passwordController = TextEditingController(); // Controlador para o campo de senha
  late LoginController _loginController; // Controlador de login
  bool _isLoading = false; // Indicador de carregamento

  @override
  void initState() {
    super.initState();
    _loginController = LoginController(
        Supabase.instance.client); // Inicializa o controlador com o cliente Supabase
  }

  // Função para lidar com o login
  Future<void> _handleSignIn() async {
    setState(() {
      _isLoading = true; // Inicia o carregamento
    });

    await Future.delayed(const Duration(seconds: 1)); // Simula um atraso

    await _loginController.signIn(
      email: _emailController.text, // Email do usuário
      password: _passwordController.text, // Senha do usuário
    );

    setState(() {
      _isLoading = false; // Finaliza o carregamento
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Obtém o tema atual

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 64.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300.0,
                    height: 300.0,
                    child: Image.asset('assets/images/drive_manager_logo.png'), // Logo da aplicação
                  ),
                  const SizedBox(height: 32.0),
                  TextField(
                    controller: _emailController, // Controlador do campo de email
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                      suffixIcon: Icon(
                        Icons.email,
                        color: theme.primaryColor, // Cor do ícone do email
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController, // Controlador do campo de senha
                    obscureText: true, // Oculta o texto da senha
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: const OutlineInputBorder(),
                      suffixIcon: Icon(
                        Icons.lock,
                        color: theme.primaryColor, // Cor do ícone da senha
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: _handleSignIn, // Função de login
                    child: const Text(
                      'Entrar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const LoadPanel(
              label: 'Carregando',
            ),
        ],
      ),
    );
  }
}
