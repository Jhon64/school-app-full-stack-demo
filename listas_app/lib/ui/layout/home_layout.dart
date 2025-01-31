import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  bool _isExpandedSettings = false; // Controla la expansión del submenú
  Widget _buildHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 69, 72, 245),
      ),
      accountName: Text(
        "Nombre Usuario",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      accountEmail: Text("usuario@email.com"),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.person, size: 40, color: Colors.blue.shade900),
      ),
    );
  }

  /// Ítem de submenú (sin icono)
  Widget _subMenuItem({required String title, required VoidCallback onTap}) {
    return Padding(
      padding: EdgeInsets.only(left: 40),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 14)),
        onTap: onTap,
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Column(
      children: [
        _menuItem(
          icon: Icons.home,
          title: "Inicio",
          onTap: () => context.go('/home'),
        ),
        _menuItem(
          icon: Icons.settings,
          title: "Productos",
          onTap: () => context.go('/home/productos'),
        ),
        ExpansionTile(
          leading: Icon(
            Icons.settings,
          ),
          title: Text(
            "Configuración",
          ),
          children: [
            _subMenuItem(
                title: "Perfil", onTap: () => context.go('/settings/profile')),
            _subMenuItem(
                title: "Notificaciones",
                onTap: () => context.go('/settings/notifications')),
          ],
          initiallyExpanded: _isExpandedSettings,
          onExpansionChanged: (expanded) =>
              setState(() => _isExpandedSettings = expanded),
        ),
        _menuItem(
          icon: Icons.info,
          title: "Acerca de",
          onTap: () => _showAboutDialog(context),
        ),
      ],
    );
  }

  Widget _menuItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(
        icon,
      ),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.exit_to_app, color: Colors.redAccent),
      title: Text("Cerrar sesión",
          style: TextStyle(color: Colors.redAccent, fontSize: 16)),
      onTap: () async {
        // await _authService.logout();
        context.go('/login');
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: "Mi App",
      applicationVersion: "1.0.0",
      applicationIcon: Icon(Icons.app_blocking, size: 40),
      children: [
        Text("Esta es una aplicación de ejemplo con un Drawer personalizado."),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        drawer: Drawer(
          child: Container(
            // color: Colors.blue.shade700, // Fondo del Drawer
            child: Column(
              children: [
                _buildHeader(), // Cabecera con perfil
                _buildMenuItems(context), // Elementos del menú
                Spacer(), // Empuja "Cerrar sesión" al final
                _buildLogoutButton(context),
              ],
            ),
          ),
        ));
  }
}
