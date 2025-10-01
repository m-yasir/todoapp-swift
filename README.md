# TodoApp Todo Experience

This SwiftUI sample now surfaces a three-tab todo workflow backed by a shared task store.

## Current Features
- **Tasks tab**: Inline text field for adding tasks, list of incomplete items, swipe right to complete, swipe left to delete, and a celebratory empty state.
- **Archive tab**: Shows completed tasks with their completion timestamps and a placeholder when nothing is archived yet.
- **Profile tab**: Aggregates weekly completion percentages, showing totals, percentages, and a progress bar for the most recent weeks.
- **Keyboard controls**: Tap anywhere in the list or use the keyboard toolbar’s Done button to dismiss the inline add field while editing.
- **Persistence**: Tasks and their completion timestamps are saved to disk so they survive relaunches and drive weekly stats.

## Product Spec
- **Goal**: Lightweight personal todo tracker that makes it easy to add tasks, swipe through daily work, and monitor consistency week over week.
- **Personas**: Busy individual contributors who rely on quick capture and completion flows; solo founders tracking milestones without heavyweight project tools.
- **User Stories**: As a user I can add a task inline without leaving the list; complete or delete tasks with familiar swipe gestures; review completed items in an archive; check weekly completion percentages to spot trends.
- **Task Flows**: Launch app → land on Tasks tab → type new item and hit return or tap plus → swipe right to mark done (moves to Archive) → optionally review Archive list → jump to Profile tab for weekly progress stats. First launch seeds empty lists yet keeps prior data when returning.
- **Release Criteria**: Core tabs load under one second with persisted data; keyboard dismisses via tap or toolbar; completing a task immediately updates Archive and Profile metrics; no crashes observed in a five-minute manual session covering add, complete, delete, and navigation.
- **Success Metrics**: Daily active users retaining >70% task completion rate per week; median of five tasks added per active day; <2% crash-free sessions over seven-day rolling window; time-to-complete (add → mark done) under ten seconds for 90th percentile sessions.

## Architecture Notes
- `TaskStore` (`Sources/TodoApp/Models/TaskStore.swift`) maintains all tasks, slices them into incomplete/completed sets, and calculates weekly summaries while coordinating persistence.
- `TaskPersistence` (`Sources/TodoApp/Models/TaskPersistence.swift`) serializes tasks to JSON under Application Support.
- Feature-specific SwiftUI views live under `Sources/TodoApp/Features/`, each consuming the shared store via `EnvironmentObject`.
- Preview providers are wrapped in `#if DEBUG` to avoid build issues with the freestanding preview macro.

## Using the App
1. Launch with `xtool dev run` (or `xtool dev build` to compile without running).
2. Add todos from the inline text field on the **Tasks** tab.
3. Swipe right on a task to mark it complete; it moves to the **Archive** tab and influences weekly stats.
4. Swipe left to delete unneeded tasks.

## Follow-Up Ideas
- Restore/undo actions in the archive.
- Persist tasks beyond the in-memory store (e.g., `AppStorage` or Core Data).
- Unit tests covering `TaskStore` mutations and weekly-summary calculations.
