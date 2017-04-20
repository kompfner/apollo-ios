import Apollo
import ApolloSQLite

enum TestCacheProvider {

  /// Execute a test block rather than return a cache synchronously, since cache setup may be
  /// asynchronous at some point.
  static func withCache(initialRecords: RecordSet? = nil, clearCache: Bool = true, execute test: (NormalizedCache) -> ()) {
    if clearCache {
      try? FileManager.default.removeItem(at: sqliteFileURL)
    }
    let cache = try! SQLiteNormalizedCache(fileURL: sqliteFileURL)
    if let initialRecords = initialRecords {
      _ = cache.merge(records: initialRecords) // This is synchronous
    }
    test(cache)
  }

  private static var sqliteFileURL: URL {
    let docDirURL = URL(fileURLWithPath:NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)
    return docDirURL.appendingPathComponent("db.sqlite3")
  }
}