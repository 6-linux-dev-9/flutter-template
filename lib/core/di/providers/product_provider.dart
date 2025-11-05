import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_app/core/di/service_locator.dart';
import 'package:template_app/data/models/producto/output/producto_model.dart';
import 'package:template_app/data/repositories/product_repository.dart';
//import 'api_client_provider.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(ref.read(apiClientProvider)),
);

final productosProvider = FutureProvider<List<ProductoModel>>((ref) async {
  return ref.read(productRepositoryProvider).list();
});

final productoByIdProvider = FutureProvider.family<ProductoModel, String>(
  (ref, id) async => ref.read(productRepositoryProvider).findById(id),
);
