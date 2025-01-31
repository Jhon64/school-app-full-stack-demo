import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Página no encontrada")),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          const Text("Error 404: Página no existe",
              style: TextStyle(fontSize: 18)),
          ElevatedButton(
              onPressed: () {
                context.go('/home');
              },
              child: const Text("Home"))
        ],
      )),
    );
  }
}
