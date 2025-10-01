import Foundation

struct TaskPersistence {
    private let fileURL: URL
    private let fileManager: FileManager
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(filename: String = "tasks.json", fileManager: FileManager = .default) {
        self.fileManager = fileManager

        let resolvedDirectory: URL
        if let applicationSupport = try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
            resolvedDirectory = applicationSupport
        } else if let documents = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
            resolvedDirectory = documents
        } else {
            resolvedDirectory = fileManager.temporaryDirectory
        }

        fileURL = resolvedDirectory.appendingPathComponent(filename)

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        self.encoder = encoder

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    func loadTasks() throws -> [Task] {
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return []
        }
        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([Task].self, from: data)
    }

    func saveTasks(_ tasks: [Task]) throws {
        let directory = fileURL.deletingLastPathComponent()
        if !fileManager.fileExists(atPath: directory.path) {
            try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        }
        let data = try encoder.encode(tasks)
        try data.write(to: fileURL, options: .atomic)
    }
}
