import SwiftUI

struct ArchiveView: View {
    @EnvironmentObject private var store: TaskStore

    var body: some View {
        NavigationStack {
            List {
                if store.completedTasks.isEmpty {
                    emptyState
                } else {
                    ForEach(store.completedTasks) { task in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.title)
                                .font(.headline)
                            if let completedAt = task.completedAt {
                                Text("Completed \(completedAt.formatted())")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Archive")
        }
    }

    private var emptyState: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: "archivebox")
                .font(.system(size: 32))
                .foregroundStyle(.secondary)
            Text("No completed tasks yet")
                .font(.headline)
            Text("Finish tasks to see them here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 32)
        .listRowSeparator(.hidden)
    }
}

#if DEBUG
struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView()
            .environmentObject(TaskStore.mock)
    }
}
#endif
