import 'package:template_app/data/models/producto/input/producto_create_model.dart';
import 'package:template_app/data/models/producto/input/producto_update_model.dart';
import 'package:template_app/data/models/producto/output/producto_model.dart';
import '../remote/api_client.dart';

abstract class ProductRepository {
  Future<List<ProductoModel>> list();
  Future<ProductoModel> findById(String id);
  Future<void> create(ProductoCreateModel p);
  Future<void> update(String id, ProductoUpdateModel p);
  Future<void> delete(String id);
}

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient api;
  static const String basePath = '/producto';
  ProductRepositoryImpl(this.api);

  @override
  Future<List<ProductoModel>> list() async {
    final r = await api.get<List>('$basePath/get-list/');
    final data = (r.data as List).cast<Map<String, dynamic>>();
    return data.map(ProductoModel.fromJson).toList();
  }

  @override
  Future<ProductoModel> findById(String id) async {
    final r = await api.get<Map<String, dynamic>>('$basePath/$id/get/');
    return ProductoModel.fromJson(r.data!);
  }

  @override
  Future<void> create(ProductoCreateModel p) async {
    await api.post('$basePath/create/', data: p.toJson());
  }

  @override
  Future<void> update(String id, ProductoUpdateModel p) async {
    await api.put('$basePath/$id/update/', data: p.toJson());
  }

  @override
  Future<void> delete(String id) async {
    await api.delete('$basePath/$id/delete/');
  }
}
