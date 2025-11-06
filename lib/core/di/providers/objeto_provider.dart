import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_app/core/di/service_locator.dart';
import 'package:template_app/data/models/objeto/output/objeto_model.dart';
import 'package:template_app/data/repositories/objeto_repository.dart';

final objetoRepositoryProvider = Provider<ObjetoRepository>(
  (ref) => ObjetoRepositoryImpl(ref.read(apiClientProvider)),
);

final objetoProvider = FutureProvider<List<ObjetoModel>>((ref) async {
  return ref.read(objetoRepositoryProvider).list();
});

final objetoByIdProvider = FutureProvider.family<ObjetoModel, String>(
  (ref, id) async => ref.read(objetoRepositoryProvider).findById(id),
);
