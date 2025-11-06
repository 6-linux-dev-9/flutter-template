import 'package:template_app/data/models/usuario/input/user_create_model.dart';
import 'package:template_app/data/models/usuario/input/user_update_model.dart';

import '../models/usuario/output/user_model.dart';
import '../remote/api_client.dart';

abstract class UserRepository {
  Future<List<UsuarioModel>> list();
  Future<UsuarioModel> findById(String id);
  Future<void> create(UsuarioCreateModel u);
  Future<void> update(String id, UsuarioUpdateModel u);
  Future<void> delete(String id);
}

class UserRepositoryImpl implements UserRepository {
  final ApiClient api;
  UserRepositoryImpl(this.api);
   static const String _base = '/usuario';
//static const String API_URL = "http://192.168.100.4:8000/api";
  @override
  Future<List<UsuarioModel>> list() async {
    final r = await api.get<List>('$_base/get-list/'); // ← ajusta endpoints
    final data = (r.data as List).cast<Map<String, dynamic>>();
    return data.map(UsuarioModel.fromJson).toList();
  }

  @override
  Future<UsuarioModel> findById(String id) async {
    final r = await api.get<Map<String, dynamic>>('$_base/$id/get/');
    return UsuarioModel.fromJson(r.data!);
  }

  @override
  Future<void> create(UsuarioCreateModel u) async {
    print(u.toJson());
    await api.post('$_base/create/', data: u.toJson());
  }

  @override
  Future<void> update(String id, UsuarioUpdateModel u) async {
    await api.put('$_base/$id/update/', data: u.toJson());
  }

  @override
  Future<void> delete(String id) async {
    await api.delete('$_base/$id/delete/');
  }
}
