import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_app/data/models/producto/output/producto_model.dart';
import 'package:template_app/data/models/usuario/output/user_model.dart';
import 'package:template_app/data/remote/server.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/remote/api_client.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment(
        'API_URL',
        defaultValue: Server.API_URL,
      ),
    ),
  );
});

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.read(dioProvider)),
);

// final userRepositoryProvider = Provider<UserRepository>(
//   (ref) => UserRepositoryImpl(ref.read(apiClientProvider)),
// );
// final productRepositoryProvider = Provider<ProductRepository>(
//   (ref) => ProductRepositoryImpl(ref.read(apiClientProvider)),
// );


// // Lista de usuarios
// final usuariosProvider = FutureProvider<List<UsuarioModel>>((ref) async {
//   final repo = ref.read(userRepositoryProvider);
//   return repo.list();
// });

// // Usuario por ID
// final usuarioByIdProvider = FutureProvider.family<UsuarioModel, String>((
//   ref,
//   id,
// ) async {
//   final repo = ref.read(userRepositoryProvider);
//   return repo.findById(id);
// });


// // Lista de productos
// final productosProvider = FutureProvider<List<ProductoModel>>((ref) async {
//   final repo = ref.read(productRepositoryProvider);
//   return repo.list();
// });

// // Producto por ID
// final productoByIdProvider = FutureProvider.family<ProductoModel, String>((
//   ref,
//   id,
// ) async {
//   final repo = ref.read(productRepositoryProvider);
//   return repo.findById(id);
// });
