import 'package:drivemanager/presenter/controllers/login_controller.dart';
import 'package:drivemanager/core/utils/load_panel.dart';
import 'package:drivemanager/routes/navigation_service.dart';
import 'package:drivemanager/view/widgets/login_text_field_widget.dart';
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

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    _loginController = LoginController(supabase: supabase);
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    try {
      final isAuthenticated = await _loginController.isAuthenticated();
      if (isAuthenticated && mounted) {
        NavigationService.pushReplacementNamed('/home');
      }
    } catch (e) {
      throw Exception('Erro ao verificar autenticação: $e');
    } finally {
      if (mounted) setState(() => _checkingAuth = false);
    }
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    setState(() => _isLoading = true);
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingAuth) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 64.0),
              child: LoginForm(
                onEmailChanged: (value) => _email = value,
                onPasswordChanged: (value) => _password = value,
                onSignIn: _handleSignIn,
                emailFocusNode: _emailFocusNode,
                passwordFocusNode: _passwordFocusNode,
                isLoading: _isLoading,
              ),
            ),
          ),
          if (_isLoading) const LoadPanel(label: 'Carregando'),
        ],
      ),
    );
  }
}
