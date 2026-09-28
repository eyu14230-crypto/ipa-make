import Foundation

final class CacheCleaner {

    static func clean() -> String {

        let fileManager = FileManager.default
        var removedCount = 0
        var failedCount = 0

        let cacheURL = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first

        let tempURL = fileManager.temporaryDirectory

        for directory in [cacheURL, tempURL] {
            guard let directory else { continue }

            guard let items = try? fileManager.contentsOfDirectory(
                at: directory,
                includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles]
            ) else {
                continue
            }

            for item in items {
                do {
                    try fileManager.removeItem(at: item)
                    removedCount += 1
                } catch {
                    failedCount += 1
                }
            }
        }

        return """
        缓存清理完成

        已清理项目：\(removedCount)
        无法清理项目：\(failedCount)
        """
    }
}
