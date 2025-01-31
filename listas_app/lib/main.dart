import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:listas_app/security/provider/auth_provider.dart';
import 'package:listas_app/settings/loadConfigureInit.dart';
import 'package:listas_app/ui/layout/home_layout.dart';
import 'package:listas_app/ui/router/router.dart';
import 'package:listas_app/ui/screens/generales/compras/compras_page.dart';
import 'package:listas_app/ui/screens/auth/login/login_screen.dart';
import 'package:listas_app/ui/screens/generales/products/product_page.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'security/service/auth_service.dart';

Future<void> main() async {
  loadConfigureInit();
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    const AppPage(),
  );
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
          return const Center(
            child: SpinKitCubeGrid(
              color: Colors.white,
              size: 50.0,
            ),
          );
        },
        child: MaterialApp.router(
          routerConfig: router,
          title: 'Productos page',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
        ));
  }
}
