class ApiConstants {
  static const String baseUrl = 'https://api.imgflip.com';
  static const String memesEndpoint = '/get_memes';
  
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
}

class StorageKeys {
  static const String memes = 'cached_memes';
  static const String offlineMode = 'offline_mode';
  static const String isDarkMode = 'is_dark_mode';
  static const String editedMemes = 'edited_memes';
}
