abstract class CatApiAbstract {
  Future getCatImages(int limit, int page);
  Future getCatFacts(int limit);
  Future addCatToFavorite(String catId, String userId);
  Future removeCatFromFavorite(dynamic favoriteId);
  Future getFavorites(String userId, int limit, int page);
}