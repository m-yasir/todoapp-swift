import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var store: TaskStore

    var body: some View {
        NavigationStack {
            List {
                if summaries.isEmpty {
                    emptyState
                } else {
                    Section("Weekly Completion") {
                        ForEach(summaries) { summary in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(summary.weekLabel)
                                        .font(.headline)
                                    Text("\(summary.completedCount) of \(summary.totalCount) tasks completed")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer(minLength: 12)
                                VStack(alignment: .trailing, spacing: 6) {
                                    Text(summary.completionPercentage, format: .percent.precision(.fractionLength(0)))
                                        .bold()
                                    ProgressView(value: summary.completionPercentage)
                                        .progressViewStyle(.linear)
                                        .frame(width: 120)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }

    private var summaries: [WeeklyCompletionSummary] {
        store.summaryByWeek(limit: 8)
    }

    private var emptyState: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: "chart.bar")
                .font(.system(size: 32))
                .foregroundStyle(.secondary)
            Text("Not enough data")
                .font(.headline)
            Text("Complete tasks to unlock your weekly progress chart.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 32)
        .listRowSeparator(.hidden)
    }
}

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(TaskStore.mock)
    }
}
#endif
