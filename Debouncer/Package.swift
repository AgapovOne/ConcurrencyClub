// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Debouncer",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Debouncer",
            targets: ["Debouncer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-concurrency-extras.git", from: "1.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Debouncer",
            dependencies: [
                .product(name: "ConcurrencyExtras", package: "swift-concurrency-extras"),
            ],
            swiftSettings: [.swiftLanguageVersion(.v6), .enableExperimentalFeature("IsolatedAny")]
        ),
        .testTarget(
            name: "DebouncerTests",
            dependencies: ["Debouncer"]
        ),
    ]
)
