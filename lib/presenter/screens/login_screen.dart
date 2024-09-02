import 'package:drivemanager/presenter/controllers/login_controller.dart';
import 'package:drivemanager/presenter/widgets/load_panel.dart';
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
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.grey.shade700),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.hintColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: Colors.grey.shade700),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.hintColor),
                      ),
                    ),
                    obscureText: true, // Oculta o texto da senha
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed:
                        _isLoading ? null : _handleSignIn, // Desabilita o botão enquanto carrega
                    style: ElevatedButton.styleFrom(backgroundColor: theme.hintColor),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const LoadPanel(
              label: 'Carregando',
              bgColor: Colors.black54,
            ),
        ],
      ),
    );
  }
}
