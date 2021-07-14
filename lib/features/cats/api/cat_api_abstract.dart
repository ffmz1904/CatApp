abstract class CatApiAbstract {
  Future<List<Map<String, dynamic>>> getCatImages(int limit, int page);
  Future<List<String>> getCatFacts(int limit);
  Future<Map<String, dynamic>> addCatToFavorite(String catId, String userId);
  Future<Map<String, dynamic>> removeCatFromFavorite(dynamic favoriteId);
  Future<List<Map<String, dynamic>>> getFavorites(String userId, int limit, int page);
}