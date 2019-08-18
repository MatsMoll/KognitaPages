// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var dependencies: [Package.Dependency] = [
    // Fast and type-safe templating
    .package(url: "https://github.com/vapor-community/HTMLKit.git", from: "1.3.0")
]

// Kognita Core
#if os(macOS) // Local development
dependencies.append(
    .package(path: "../KognitaCore")
)
#else
dependencies.append(
    .package(url: "https://MatsKognita:dyjdov-bupgev-goffY8@bitbucket.org/MatsEikelandMollestad/kognita-core.git", .branch("master"))
)
#endif

let package = Package(
    name: "KognitaViews",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "KognitaViews",
            targets: ["KognitaViews"]),
    ],
    dependencies: dependencies,
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "KognitaViews",
            dependencies: ["HTMLKit", "KognitaCore"]),
        .testTarget(
            name: "KognitaViewsTests",
            dependencies: ["KognitaViews"]),
    ]
)
