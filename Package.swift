// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

var dependencies: [Package.Dependency] = [
    // 💧 A server-side Swift web framework.
    .package(url: "https://github.com/MatsMoll/BootstrapKit.git", from: "1.0.2")
]

switch ProcessInfo.processInfo.environment["BUILD_TYPE"] {
case "LOCAL":
    dependencies.append(contentsOf: [
            .package(path: "../KognitaModels"),
        ]
    )
case "DEV":
    let branch = ProcessInfo.processInfo.environment["KOGNITA_MODELS"] ?? "develop"
    dependencies.append(contentsOf: [
        .package(name: "KognitaModels", url: "https://github.com/MatsMoll/KognitaModels", .branch(branch)),
        ]
    )
default:
    let version = ProcessInfo.processInfo.environment["KOGNITA_MODELS"] ?? "1.0.3"
    dependencies.append(contentsOf: [
        .package(name: "KognitaModels", url: "https://github.com/MatsMoll/KognitaModels", from: .init(stringLiteral: version)),
        ]
    )
}

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
            dependencies: ["BootstrapKit", "KognitaModels"]),
        .testTarget(
            name: "KognitaViewsTests",
            dependencies: ["KognitaViews"]),
    ]
)
