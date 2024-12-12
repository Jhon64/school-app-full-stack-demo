import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Nombre'),
            accountEmail: Text('Email'),
          ),
          ListTile(
            title: const Text('Productos'),
            onTap: () {
              print('redireccionando a compras');
              context.go('/products');
            },
          ),
          ListTile(
              title: const Text('Compras'),
              onTap: () {
                print('redireccionando a compras');
                context.go('/compras');
                // Navigator.pushNamed(context, '/compras');
              }),
        ]),
      ),
      body: Center(
        child: Text("Contenido principal"),
      ),
    );
  }
}
