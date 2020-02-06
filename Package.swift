// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var dependencies: [Package.Dependency] = [
    // 💧 A server-side Swift web framework.
]

// Kognita Core
#if os(macOS) // Local development
dependencies.append(contentsOf: [
    .package(path: "../KognitaCore"),
    .package(path: "../../BootstrapKit")
])
#else
dependencies.append(contentsOf: [
    .package(url: "https://Kognita:dyjdov-bupgev-goffY8@github.com/MatsMoll/KognitaCore", from: "2.0.0"),
    .package(url: "https://github.com/MatsMoll/BootstrapKit.git", from: "1.0.0-beta.5")
])
#endif

let package = Package(
    name: "KognitaViews",
    platforms: [
        .macOS(.v10_15),
    ],
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
            dependencies: ["BootstrapKit", "KognitaCore"]),
        .testTarget(
            name: "KognitaViewsTests",
            dependencies: ["KognitaViews"]),
    ]
)
