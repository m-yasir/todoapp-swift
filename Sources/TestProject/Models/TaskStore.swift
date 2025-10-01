import Foundation
import Combine

@MainActor
final class TaskStore: ObservableObject {
    @Published private(set) var tasks: [Task]
    private let calendar: Calendar
    private let persistence: TaskPersistence?

    init(tasks: [Task] = [], calendar: Calendar = .current, persistence: TaskPersistence? = TaskPersistence()) {
        self.persistence = persistence
        if let persistence {
            let restored = (try? persistence.loadTasks()) ?? tasks
            self.tasks = restored
        } else {
            self.tasks = tasks
        }
        self.calendar = calendar
    }

    var incompleteTasks: [Task] {
        tasks.filter { !$0.isCompleted }
    }

    var completedTasks: [Task] {
        tasks.filter(\.isCompleted)
    }

    func addTask(title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let task = Task(title: trimmed)
        tasks.insert(task, at: 0)
        persistTasks()
    }

    func delete(task: Task) {
        tasks.removeAll { $0.id == task.id }
        persistTasks()
    }

    func complete(task: Task) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        guard !tasks[index].isCompleted else { return }
        tasks[index].isCompleted = true
        tasks[index].completedAt = Date()
        persistTasks()
    }

    func summaryByWeek(limit: Int = 6) -> [WeeklyCompletionSummary] {
        let grouped = Dictionary(grouping: tasks) { task -> Date in
            beginOfWeek(for: task.createdAt)
        }

        let summaries = grouped.compactMap { weekStart, tasks in
            WeeklyCompletionSummary(weekStart: weekStart, tasks: tasks, calendar: calendar)
        }
        .sorted { $0.weekStart > $1.weekStart }

        if limit > 0 {
            return Array(summaries.prefix(limit))
        }
        return summaries
    }

    private func beginOfWeek(for date: Date) -> Date {
        calendar.dateInterval(of: .weekOfYear, for: date)?.start ?? date
    }

    private func persistTasks() {
        guard let persistence else { return }
        do {
            try persistence.saveTasks(tasks)
        } catch {
#if DEBUG
            debugPrint("Failed to save tasks:", error)
#endif
        }
    }
}

struct WeeklyCompletionSummary: Identifiable {
    let id: Date
    let weekStart: Date
    let completedCount: Int
    let totalCount: Int
    private let calendar: Calendar

    init(weekStart: Date, tasks: [Task], calendar: Calendar) {
        self.weekStart = weekStart
        self.id = weekStart
        self.calendar = calendar
        self.totalCount = tasks.count
        self.completedCount = tasks.filter(\.isCompleted).count
    }

    var completionPercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }

    var weekLabel: String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "MMM d"

        let end = calendar.date(byAdding: .day, value: 6, to: weekStart) ?? weekStart
        return "\(formatter.string(from: weekStart)) - \(formatter.string(from: end))"
    }
}

extension TaskStore {
    static var mock: TaskStore {
        let calendar = Calendar.current
        let now = Date()
        let tasks: [Task] = [
            Task(title: "Buy groceries", createdAt: now),
            Task(title: "Water plants", createdAt: now),
            Task(title: "Call mom", isCompleted: true, createdAt: calendar.date(byAdding: .day, value: -2, to: now) ?? now, completedAt: now),
            Task(title: "Finish report", isCompleted: true, createdAt: calendar.date(byAdding: .day, value: -8, to: now) ?? now, completedAt: calendar.date(byAdding: .day, value: -1, to: now)),
            Task(title: "Plan weekend", createdAt: calendar.date(byAdding: .day, value: -8, to: now) ?? now)
        ]
        return TaskStore(tasks: tasks, calendar: calendar, persistence: nil)
    }
}
