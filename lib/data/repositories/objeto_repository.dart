
import 'package:template_app/data/models/objeto/input/objeto_create_model.dart';
import 'package:template_app/data/models/objeto/input/objeto_update_model.dart';
import 'package:template_app/data/models/objeto/output/objeto_model.dart';

import '../remote/api_client.dart';

abstract class ObjetoRepository {
  Future<List<ObjetoModel>> list();
  Future<ObjetoModel> findById(String id);
  Future<void> create(ObjetoCreateModel p);
  Future<void> update(String id, ObjetoUpdateModel p);
  Future<void> delete(String id);
}

class ObjetoRepositoryImpl implements ObjetoRepository {
  final ApiClient api;
  static const String basePath = '/objeto';
  ObjetoRepositoryImpl(this.api);

  @override
  Future<List<ObjetoModel>> list() async {
    final r = await api.get<List>('$basePath/get-list-soft/');
    final data = (r.data as List).cast<Map<String, dynamic>>();
    return data.map(ObjetoModel.fromJson).toList();
  }

  @override
  Future<ObjetoModel> findById(String id) async {
    final r = await api.get<Map<String, dynamic>>('$basePath/$id/get/');
    return ObjetoModel.fromJson(r.data!);
  }

  @override
  Future<void> create(ObjetoCreateModel p) async {
    await api.post('$basePath/create/', data: p.toJson());
  }

  @override
  Future<void> update(String id, ObjetoUpdateModel p) async {
    await api.put('$basePath/$id/update/', data: p.toJson());
  }

  @override
  Future<void> delete(String id) async {
    await api.delete('$basePath/$id/delete/');
  }
}
