// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TestProject",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        // An xtool project should contain exactly one library product,
        // representing the main app.
        .library(
            name: "TestProject",
            targets: ["TestProject"]
        ),
    ],
    targets: [
        .target(
            name: "TestProject"
        ),
    ]
)
