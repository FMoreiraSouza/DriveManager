import 'package:flutter/material.dart';

class LoginTextFieldWidget extends StatelessWidget {
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final String labelText;
  final TextInputAction textInputAction;
  final bool obscureText;
  final IconData suffixIcon;

  const LoginTextFieldWidget({
    super.key,
    required this.focusNode,
    this.nextFocusNode,
    required this.onChanged,
    this.onSubmitted,
    required this.labelText,
    required this.textInputAction,
    this.obscureText = false,
    required this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted ??
          (value) {
            if (nextFocusNode != null) {
              nextFocusNode!.requestFocus();
            } else {
              focusNode.unfocus();
            }
          },
      textInputAction: textInputAction,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: Icon(suffixIcon, color: theme.primaryColor),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onSignIn;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onSignIn,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 300.0,
          height: 300.0,
          child: Image.asset('assets/images/drive_manager_logo.png'),
        ),
        const SizedBox(height: 32.0),
        LoginTextFieldWidget(
          focusNode: emailFocusNode,
          nextFocusNode: passwordFocusNode,
          onChanged: onEmailChanged,
          labelText: 'Email',
          textInputAction: TextInputAction.next,
          suffixIcon: Icons.email,
        ),
        const SizedBox(height: 16.0),
        LoginTextFieldWidget(
          focusNode: passwordFocusNode,
          onChanged: onPasswordChanged,
          labelText: 'Senha',
          textInputAction: TextInputAction.done,
          obscureText: true,
          suffixIcon: Icons.lock,
        ),
        const SizedBox(height: 32.0),
        ElevatedButton(
          onPressed: isLoading ? null : onSignIn,
          child: const Text(
            'Entrar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
