# Repository Guidelines

## Project Structure & Module Organization
- `Package.swift` defines a single SwiftUI target named `TodoApp`; keep public APIs scoped to that module.
- Source code lives under `Sources/TodoApp/`. Entry points include `TodoAppApp.swift` and `ContentView.swift`; organize new features in subfolders (for example `Sources/TodoApp/Features/Home`).
- Reusable assets (images, JSON, localized strings) belong in a `Resources/` subdirectory inside the target so Swift Package Manager can bundle them.
- `.build/` and `xtool/TodoApp.app` are generated artifacts; avoid committing edits and purge them before creating archives.

## Build, Test, and Development Commands
- `xtool dev build` — compiles the Swift package with the Darwin toolchain; run after dependency or API changes.
- `xtool dev run` — builds and runs the app target using SwiftPM via xtool for rapid previews.
- `swift test` — executes the package test suite once tests exist; append `--enable-code-coverage` to gather metrics.

## Coding Style & Naming Conventions
- Follow Swift API Design Guidelines: UpperCamelCase for types, lowerCamelCase for values, and verbs for async actions.
- Use four-space indentation, trailing commas in multiline literals, and group SwiftUI modifiers by layout → style → accessibility.
- Keep preview providers next to their view definitions with `#if DEBUG` guards and prefer protocol-first abstractions.
- Run `swift format --in-place Sources` if SwiftFormat is available; otherwise match the existing style closely.

## Testing Guidelines
- Add unit or snapshot suites under `Tests/`, mirroring source folders (for example `Tests/TodoAppTests/ContentViewTests.swift`).
- Name test cases `<Subject>Tests` and methods `test_<condition>_<expectedResult>()` for clarity.
- Use `XCTAssert` families for logic and `ViewInspector` (if added) for SwiftUI hierarchy checks.
- Target ≥80% coverage on new modules and note any intentional gaps in pull requests.

## Commit & Pull Request Guidelines
- Repository snapshot lacks Git history; adopt Conventional Commit-style messages such as `feat: add profile card view` or `fix: correct globe icon tint` (present tense, ≤72 characters).
- Reference tracking issues with `#ID` in the body, list notable UI changes, and attach simulator screenshots when visuals shift.
- Pull requests should cover motivation, implementation notes, test evidence (`swift test` output), and any follow-up tasks.

## Configuration & Environment Notes
- `xtool.yml` stores the bundle identifier (`com.example.TodoApp`); update it alongside any Info.plist changes in downstream tooling.
- The project targets iOS 17 and macOS 14—keep APIs within those platform availability windows and gate newer APIs with `@available` where required.
