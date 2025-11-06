import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_app/core/di/service_locator.dart';
import 'package:template_app/data/models/usuario/output/user_model.dart';
import 'package:template_app/data/repositories/user_repository.dart';


final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepositoryImpl(ref.read(apiClientProvider)),
);

final usuariosProvider = FutureProvider<List<UsuarioModel>>((ref) async {
  return ref.read(userRepositoryProvider).list();
});

final usuarioByIdProvider = FutureProvider.autoDispose.family<UsuarioModel, String>(
  (ref, id) async => ref.read(userRepositoryProvider).findById(id),
);
