import SwiftUI

struct TasksView: View {
    @EnvironmentObject private var store: TaskStore
    @State private var newTaskTitle: String = ""
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        NavigationStack {
            List {
                addTaskField

                if store.incompleteTasks.isEmpty {
                    emptyState
                } else {
                    ForEach(store.incompleteTasks) { task in
                        Text(task.title)
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    withAnimation {
                                        store.complete(task: task)
                                    }
                                } label: {
                                    Label("Complete", systemImage: "checkmark")
                                }
                                .tint(.green)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        store.delete(task: task)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
            .navigationTitle("Tasks")
            .scrollDismissesKeyboard(.interactively)
            .simultaneousGesture(
                TapGesture().onEnded {
                    if isTextFieldFocused {
                        isTextFieldFocused = false
                    }
                }
            )
        }
        .toolbar { keyboardToolbar }
    }

    private var addTaskField: some View {
        HStack {
            TextField("Add a task", text: $newTaskTitle)
                .textFieldStyle(.roundedBorder)
                .focused($isTextFieldFocused)
                .onSubmit(addTask)

            Button(action: addTask) {
                Image(systemName: "plus.circle.fill")
                    .symbolRenderingMode(.hierarchical)
            }
            .disabled(newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.vertical, 8)
    }

    private var emptyState: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 32))
                .foregroundStyle(.green)
            Text("All tasks complete! 🎉")
                .font(.headline)
            Text("Add more to keep the streak going.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 32)
        .listRowSeparator(.hidden)
    }

    private var keyboardToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button("Done") {
                isTextFieldFocused = false
            }
        }
    }

    private func addTask() {
        store.addTask(title: newTaskTitle)
        newTaskTitle = ""
        isTextFieldFocused = true
    }
}

#if DEBUG
struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
            .environmentObject(TaskStore.mock)
    }
}
#endif
