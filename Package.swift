// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

var dependencies: [Package.Dependency] = [
    // 💧 A server-side Swift web framework.
    .package(url: "https://github.com/MatsMoll/BootstrapKit.git", from: "1.0.0-beta.5")
]

switch ProcessInfo.processInfo.environment["BUILD_TYPE"] {
case "LOCAL":
    dependencies.append(contentsOf: [
            .package(path: "../KognitaCore"),
        ]
    )
case "DEV":
    let coreBranch = ProcessInfo.processInfo.environment["KOGNITA_CORE"] ?? "develop"
    dependencies.append(contentsOf: [
            .package(url: "https://Kognita:dyjdov-bupgev-goffY8@github.com/MatsMoll/KognitaCore", .branch(coreBranch)),
        ]
    )
default:
    dependencies.append(contentsOf: [
        .package(url: "https://Kognita:dyjdov-bupgev-goffY8@github.com/MatsMoll/KognitaCore", from: "2.0.0"),
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
            dependencies: ["BootstrapKit", "KognitaCore"]),
        .testTarget(
            name: "KognitaViewsTests",
            dependencies: ["KognitaViews"]),
    ]
)
