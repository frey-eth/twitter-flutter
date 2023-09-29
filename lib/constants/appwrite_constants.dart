class AppwriteConstants {
  static const String databaseId = '64d07f777ef79308f5ab';
  static const String projectId = '64d07b93837ed2c342b4';
  static const String endPoint = 'http://172.17.23.73:80/v1';
  static const String usersCollection = '64d39d8b35cae5c2364b';
  static const String tweetsCollection = '64e6154e93ced692aa12';
  static const String storageImagesBucket = '64e6dacfe35af4c1d201';
  static String imageUrl(String imageID) =>
      '$endPoint/storage/buckets/$storageImagesBucket/files/$imageID/view?project=$projectId&mode=admin';
}
