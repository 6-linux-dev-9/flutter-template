import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:template_app/presentation/screens/dev/inputs.dart';
import 'package:template_app/presentation/screens/objeto/create_objeto_screen.dart';
import 'package:template_app/presentation/screens/objeto/editar_objeto_screen.dart';
import 'package:template_app/presentation/screens/objeto/objeto_screen.dart';
import 'package:template_app/presentation/screens/producto/create_producto_screen.dart';
import 'package:template_app/presentation/screens/producto/editar_producto_screen.dart';
import 'package:template_app/presentation/screens/producto/productos_screen.dart';
import 'package:template_app/presentation/screens/usuario/crear_usuario_2.dart';
import 'package:template_app/presentation/screens/usuario/editar_usuario_screen.dart';
import 'package:template_app/presentation/screens/usuario/usuarios_screen.dart';
import '../../presentation/screens/home/home_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/',
  routes: [
    // Raíz
    GoRoute(name: 'home', path: '/', builder: (_, __) => const HomeScreen()),

    // Sección Usuarios (padre) + hijos anidados
    GoRoute(
      name: 'usuarios',
      path: '/usuarios',
      builder: (_, __) => const UsuariosScreen(),
      routes: [
        GoRoute(
          name: 'usuarioNew',
          path: 'new',
          builder: (_, __) => const CrearUsuarioScreen(),
        ),
        GoRoute(
          name: 'usuarioEdit',
          path: ':id/edit',
          builder: (c, s) => EditarUsuarioScreen(id: s.pathParameters['id']!),
        ),
      ],
    ),
    GoRoute(
      name: 'productos',
      path: '/productos',
      builder: (_, __) => const ProductosScreen(),
      routes: [
        GoRoute(
          name: 'productoNew',
          path: 'new',
          builder: (_, __) => const CrearProductoScreen(),
        ),
        GoRoute(
          name: 'productoEdit',
          path: ':id/edit',
          builder: (c, s) => EditarProductoScreen(id: s.pathParameters['id']!),
        ),
      ],
    ),
    GoRoute(
      name: 'objetos',
      path: '/objetos',
      builder: (_, __) => const ObjetoScreen(),
      routes: [
        GoRoute(
          name: 'objetoNew',
          path: 'new',
          builder: (_, __) => const CrearObjetoScreen(),
        ),
        GoRoute(
          name: 'objetoEdit',
          path: ':id/edit',
          builder: (c, s) => EditarObjetoScreen(id: s.pathParameters['id']!),
        ),
      ],
    ),
    GoRoute(
      name: 'dev',
      path: '/dev',
      builder: (_,__) => InputsCatalogScreen()
    )
    
  ],
);
