abstract class CatApiAbstract {
  Future<List<Map<String, dynamic>>> getCatImages(final int limit, final int page);
  Future<List<String>> getCatFacts(final int limit);
  Future<Map<String, dynamic>> addCatToFavorite(final String catId, final String userId);
  Future<Map<String, dynamic>> removeCatFromFavorite(final dynamic favoriteId);
  Future<List<Map<String, dynamic>>> getFavorites(final String userId, final int limit, final int page);
}