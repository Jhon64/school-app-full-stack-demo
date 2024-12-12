import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:listas_app/settings/loadConfigureInit.dart';
import 'package:listas_app/ui/homeScreen.dart';
import 'package:listas_app/ui/screens/compras/compras_page.dart';
import 'package:listas_app/ui/screens/login/login_screen.dart';
import 'package:listas_app/ui/screens/products/product_page.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// The route configuration.
final GoRouter _router = GoRouter(
  initialLocation: '/login', // Ruta inicial
  routes: <RouteBase>[
    GoRoute(path: '/login',builder: (BuildContext context,GoRouterState state){
      return const LoginPage();
    }),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'products',
          builder: (BuildContext context, GoRouterState state) {
            return const ProductPage();
          },
        ),
        GoRoute(
          path: 'compras',
          builder: (BuildContext context, GoRouterState state) {
            return const ComprasPage();
          },
        ),
      ],
    ),
  ],
);



Future<void> main() async {
  loadConfigureInit();
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const AppPage());
}


class AppPage extends StatelessWidget {
  const AppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
        duration: Durations.medium4,
        reverseDuration: Durations.medium4,
        overlayColor: Colors.grey.withOpacity(0.8),
        overlayWidgetBuilder: (_) {
          //ignored progress for the moment
          return Center(
            child: SpinKitCubeGrid(
              color: Colors.red,
              size: 50.0,
            ),
          );
        },
        child: MaterialApp.router(
          routerConfig: _router,
          title: 'Productos page',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
        ));
  }
}
