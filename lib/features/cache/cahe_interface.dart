abstract class ICache {
  // Set data to cache
  Future<void> setLocalData(data);

  // Get data from cache
  Future getLocalData();
}
