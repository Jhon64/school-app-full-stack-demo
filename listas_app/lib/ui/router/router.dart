import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listas_app/security/service/auth_service.dart';
import 'package:listas_app/ui/layout/home_layout.dart';
import 'package:listas_app/ui/router/not_found_page.dart';

import '../screens/generales/compras/compras_page.dart';
import '../screens/auth/login/login_screen.dart';
import '../screens/generales/products/product_page.dart';

class AuthNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

/// The route configuration.
final GoRouter router = GoRouter(
  initialLocation: '/home', // Ruta inicial
  refreshListenable: AuthNotifier(),
  // ✅ Manejo de rutas inexistentes (404)
  errorPageBuilder: (context, state) {
    return MaterialPage(child: NotFoundPage());
  }, //
  redirect: (context, state) async {
    bool isAuthenticated = await isLoggedIn();

    if (isAuthenticated) {
      String path = state.fullPath ?? '/home';
      return path; // Si está autenticado, evita volver al login
    } else if (!isAuthenticated) {
      return '/compras'; // Si no está autenticado, redirige al login
    }
    return null; // Permite continuar con la navegación normal
  },

  routes: <RouteBase>[
    GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        }),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeLayout();
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/productos',
          builder: (BuildContext context, GoRouterState state) {
            return const ProductPage();
          },
        ),
        GoRoute(
          path: '/compras',
          builder: (BuildContext context, GoRouterState state) {
            return const ComprasPage();
          },
        ),
      ],
    ),
  ],
);
