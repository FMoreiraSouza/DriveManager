import 'package:drivemanager/presenter/controllers/login_controller.dart';
import 'package:drivemanager/core/utils/load_panel.dart';
import 'package:drivemanager/routes/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  late LoginController _loginController;
  bool _isLoading = false;
  bool _checkingAuth = true;
  String _email = '';
  String _password = '';

  // FocusNodes para controle de foco
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    _loginController = LoginController(supabase: supabase);

    // Verifica se o usuário já está autenticado
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    try {
      final isAuthenticated = await _loginController.isAuthenticated();
      if (isAuthenticated && mounted) {
        // Se já estiver autenticado, redireciona para home
        NavigationService.pushReplacementNamed('/home');
      }
    } catch (e) {
      throw Exception('Erro ao verificar autenticação: $e');
    } finally {
      if (mounted) {
        setState(() {
          _checkingAuth = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _loginController.signIn(
        email: _email,
        password: _password,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao fazer login: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleEmailSubmitted(String value) {
    _passwordFocusNode.requestFocus();
  }

  void _handlePasswordSubmitted(String value) {
    _passwordFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Mostra loading enquanto verifica autenticação
    if (_checkingAuth) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                    child: Image.asset('assets/images/drive_manager_logo.png'),
                  ),
                  const SizedBox(height: 32.0),
                  TextField(
                    focusNode: _emailFocusNode,
                    onChanged: (value) => _email = value,
                    onSubmitted: _handleEmailSubmitted,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                      suffixIcon: Icon(
                        Icons.email,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    focusNode: _passwordFocusNode,
                    onChanged: (value) => _password = value,
                    onSubmitted: _handlePasswordSubmitted,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: const OutlineInputBorder(),
                      suffixIcon: Icon(
                        Icons.lock,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: _handleSignIn,
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
