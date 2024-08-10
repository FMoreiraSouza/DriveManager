import 'package:drivemanager/core/themes/app_theme.dart';
import 'package:drivemanager/presenter/controllers/login_controller.dart';
import 'package:drivemanager/presenter/routes/navigation_service.dart';
import 'package:drivemanager/presenter/screens/fleet_list_screen.dart';
import 'package:drivemanager/presenter/screens/map_screen.dart';
import 'package:drivemanager/presenter/screens/report_screen.dart';
import 'package:drivemanager/presenter/widgets/load_panel.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final LoginController loginController;

  const HomeScreen({super.key, required this.loginController});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isLoggingOut = false;

  final List<Widget> _pages = [
    const FleetListScreen(),
    const ReportScreen(),
    const MapScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _handleMenuSelection(String result) async {
    switch (result) {
      case 'cadastro_frotas':
        NavigationService.pushNamed('/fleet-register');
        break;
      case 'meu_perfil':
        NavigationService.pushNamed('/profile');
        break;
      case 'sobre':
        NavigationService.pushNamed('/about');
        break;
      case 'sair':
        setState(() {
          _isLoggingOut = true;
        });

        await widget.loginController.signOut();

        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          setState(() {
            _isLoggingOut = false;
          });

          NavigationService.pushReplacementNamed('/login');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frotas registradas'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'cadastro_frotas',
                child: ListTile(
                  leading: Icon(Icons.plus_one),
                  title: Text('Cadastro de Veículos'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'meu_perfil',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Meu Perfil'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'sobre',
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Sobre'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'sair',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sair'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          _pages[_selectedIndex],
          if (_isLoggingOut)
            const LoadPanel(
              label: 'Saindo...',
              bgColor: Colors.black54,
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Frotas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Relatórios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
        ],
        selectedItemColor: AppTheme.theme.hintColor,
      ),
    );
  }
}
