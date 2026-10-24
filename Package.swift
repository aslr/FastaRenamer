// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FastaRenamer",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.60.0")
    ],
    targets: [
        .target(
            name: "FastaRenamerCore",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ]
        ),
        .executableTarget(
            name: "FastaRenamer",
            dependencies: [
                "JavaScriptKit",
                "FastaRenamerCore"
            ],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ]
        ),
        .testTarget(
            name: "FastaRenamerCoreTests",
            dependencies: ["FastaRenamerCore"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ]
        ),
    ]
)
