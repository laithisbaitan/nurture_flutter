import '../../../core/api/api_client.dart';
import '../domain/entities/food_item.dart';
import '../domain/foods_repository.dart';

class FoodsRepositoryImpl implements FoodsRepository {
  const FoodsRepositoryImpl(this._api);

  final ApiClient _api;

  @override
  Future<List<FoodItem>> list() async {
    final data = await _api.get('/api/foods/') as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;
    return results.cast<Map<String, dynamic>>().map(FoodItem.fromJson).toList();
  }

  @override
  Future<List<FoodItem>> search(String query) async {
    final data = await _api.get('/api/foods/search/', query: {'q': query});
    final list = data as List<dynamic>;
    return list.cast<Map<String, dynamic>>().map(FoodItem.fromJson).toList();
  }

  @override
  Future<FoodItem> getById(int id) async {
    final data = await _api.get('/api/foods/$id/') as Map<String, dynamic>;
    return FoodItem.fromJson(data);
  }

  @override
  Future<FoodItem> create(FoodWrite draft) async {
    final data =
        await _api.post('/api/foods/', body: draft.toJson())
            as Map<String, dynamic>;
    return FoodItem.fromJson(data);
  }

  @override
  Future<FoodItem> update(int id, FoodWrite draft) async {
    final data =
        await _api.patch('/api/foods/$id/', body: draft.toJson())
            as Map<String, dynamic>;
    return FoodItem.fromJson(data);
  }

  @override
  Future<FoodItem> uploadPhoto(String filePath) async {
    final data =
        await _api.postMultipart(
              '/api/foods/photo/',
              fieldName: 'photo',
              filePath: filePath,
            )
            as Map<String, dynamic>;
    return FoodItem.fromJson(data);
  }
}
