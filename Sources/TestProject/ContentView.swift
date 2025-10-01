import SwiftUI

struct ContentView: View {
    @StateObject private var store: TaskStore

    init(store: TaskStore = TaskStore()) {
        _store = StateObject(wrappedValue: store)
    }

    var body: some View {
        TabView {
            TasksView()
                .tabItem {
                    Label("Tasks", systemImage: "checklist")
                }

            ArchiveView()
                .tabItem {
                    Label("Archive", systemImage: "archivebox")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .environmentObject(store)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: TaskStore.mock)
    }
}
#endif
