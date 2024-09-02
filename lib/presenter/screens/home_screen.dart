// Importa pacotes e classes necessários para o funcionamento da tela inicial.
import 'package:drivemanager/core/themes/app_theme.dart';
import 'package:drivemanager/presenter/controllers/login_controller.dart';
import 'package:drivemanager/presenter/routes/navigation_service.dart';
import 'package:drivemanager/presenter/screens/fleet_screen.dart';
import 'package:drivemanager/presenter/screens/map_screen.dart';
import 'package:drivemanager/presenter/screens/message_screen.dart';
import 'package:drivemanager/presenter/widgets/load_panel.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Define a tela inicial do aplicativo que exibe diferentes seções.
class HomeScreen extends StatefulWidget {
  // Controlador de login passado como argumento para a tela.
  final LoginController loginController;

  // Construtor da tela inicial.
  const HomeScreen({super.key, required this.loginController});

  @override
  HomeScreenState createState() => HomeScreenState();
}

// Estado da tela inicial.
class HomeScreenState extends State<HomeScreen> {
  // Instância do cliente Supabase para interagir com o banco de dados.
  final SupabaseClient _supabase = Supabase.instance.client;

  // Lista de mensagens recebidas para exibir na tela de mensagens.
  List<Map<String, dynamic>> _messages = [];
  // Índice da página atualmente selecionada.
  int _selectedIndex = 0;
  // Flag para indicar se o usuário está saindo.
  bool _isLoggingOut = false;

  // Lista de páginas exibidas no corpo da tela com base no índice selecionado.
  final List<Widget> _pages = [
    const FleetScreen(),
    const MapScreen(),
  ];

  // Canal de notificações em tempo real do Supabase.
  late final RealtimeChannel _notificationChannel;

  @override
  void initState() {
    super.initState();
    // Inicializa a tela buscando mensagens e assinando notificações.
    _fetchMessages();
    _subscribeNotifications();
  }

  // Função assíncrona para buscar mensagens da tabela 'notifications'.
  Future<void> _fetchMessages() async {
    final response = await _supabase.from('notifications').select();

    setState(() {
      _messages = List<Map<String, dynamic>>.from(response);
    });
  }

  // Função assíncrona para assinar o canal de notificações e receber atualizações.
  Future<void> _subscribeNotifications() async {
    _notificationChannel = _supabase
        .channel('public:notifications')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'notifications',
            callback: (payload) {
              final message = payload.newRecord['message'];
              _showSnackBar(message);
              _fetchMessages();
            })
        .subscribe();
  }

  // Função para exibir uma Snackbar com a mensagem recebida.
  void _showSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      final snackBar = SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey.shade200,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Fechar',
          textColor: Colors.black,
          onPressed: () {
            scaffoldMessenger.hideCurrentSnackBar();
          },
        ),
      );

      scaffoldMessenger.showSnackBar(snackBar);
    });
  }

  @override
  void dispose() {
    // Cancela a assinatura do canal de notificações ao descartar a tela.
    _notificationChannel.unsubscribe();
    super.dispose();
  }

  // Função para alterar a página exibida com base no item selecionado na barra de navegação.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Função para lidar com a seleção do menu suspenso na AppBar.
  Future<void> _handleMenuSelection(String result) async {
    switch (result) {
      case 'info':
        // Navega para a tela de informações.
        NavigationService.pushNamed('/info');
        break;
      case 'sair':
        setState(() {
          _isLoggingOut = true;
        });

        // Realiza o logout do usuário.
        await widget.loginController.signOut();

        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          setState(() {
            _isLoggingOut = false;
          });

          // Navega de volta para a tela de login.
          NavigationService.pushReplacementNamed('/login');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define o título da AppBar com base na página selecionada.
    String appBarTitle;
    switch (_selectedIndex) {
      case 0:
        appBarTitle = 'Frotas registradas';
        break;
      case 1:
        appBarTitle = 'Mapa';
        break;
      default:
        appBarTitle = 'Frotas registradas';
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Botão para abrir a tela de mensagens.
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageScreen(messages: _messages),
                  ),
                );
              },
            ),
            Center(child: Text(appBarTitle)),
          ],
        ),
        centerTitle: true,
        actions: [
          // Menu suspenso para opções adicionais.
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'info',
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Informativo'),
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
          // Exibe a página atual com base no índice selecionado.
          _pages[_selectedIndex],
          // Exibe o painel de carregamento se o usuário estiver saindo.
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
          // Itens da barra de navegação inferior.
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Frotas',
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
