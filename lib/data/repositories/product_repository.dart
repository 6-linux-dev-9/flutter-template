import '../models/product_model.dart';
import '../remote/api_client.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> list();
  Future<ProductModel> findById(String id);
  Future<void> create(ProductModel p);
  Future<void> update(ProductModel p);
  Future<void> delete(String id);
}

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient api;
  ProductRepositoryImpl(this.api);

  @override
  Future<List<ProductModel>> list() async {
    final r = await api.get<List>('/productos');
    final data = (r.data as List).cast<Map<String, dynamic>>();
    return data.map(ProductModel.fromJson).toList();
  }

  @override
  Future<ProductModel> findById(String id) async {
    final r = await api.get<Map<String, dynamic>>('/productos/$id');
    return ProductModel.fromJson(r.data!);
  }

  @override
  Future<void> create(ProductModel p) async {
    await api.post('/productos', data: p.toJson());
  }

  @override
  Future<void> update(ProductModel p) async {
    await api.put('/productos/${p.id}', data: p.toJson());
  }

  @override
  Future<void> delete(String id) async {
    await api.delete('/productos/$id');
  }
}
