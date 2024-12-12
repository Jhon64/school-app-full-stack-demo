import 'package:go_router/go_router.dart';
import 'package:listas_app/ui/screens/products/product_page.dart';

final _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => ProductPage(),
    ),
  ],
);