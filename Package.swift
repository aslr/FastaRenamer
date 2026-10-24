// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FastaRenamer",
    dependencies: [
        .package(url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.19.2")
    ],
    targets: [
        .target(name: "FastaRenamerCore"),
        .executableTarget(
            name: "FastaRenamer",
            dependencies: [
                "FastaRenamerCore",
                .product(name: "JavaScriptKit", package: "JavaScriptKit")
            ]
        ),
        .testTarget(
            name: "FastaRenamerCoreTests",
            dependencies: ["FastaRenamerCore"]
        ),
    ],
    swiftLanguageModes: [.v5]
)
