import Foundation

enum AppSupportPaths {
    static let appName = "SuperVoiceAssistant"

    static var applicationSupportDirectory: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let directory = base.appendingPathComponent(appName, isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }

    static func configFileCandidates(named filename: String) -> [URL] {
        var urls: [URL] = [
            applicationSupportDirectory.appendingPathComponent(filename)
        ]

        if let resourceURL = Bundle.main.resourceURL {
            urls.append(resourceURL.appendingPathComponent(filename))
        }

        if let moduleResourceURL = Bundle.module.resourceURL {
            urls.append(moduleResourceURL.appendingPathComponent(filename))
        }

        let currentDirectory = FileManager.default.currentDirectoryPath
        urls.append(URL(fileURLWithPath: currentDirectory).appendingPathComponent(filename))

        return urls
    }

    static func firstExistingConfigFile(named filename: String) -> URL? {
        configFileCandidates(named: filename).first {
            FileManager.default.fileExists(atPath: $0.path)
        }
    }
}
