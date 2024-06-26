// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MoWine.Domain",
    platforms: [
        .iOS("15.0"), .macOS("12.0.0")
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MoWine.Domain",
            targets: ["MoWine.Domain"]),
        .library(
            name: "MoWine.Domain.TestKit",
            targets: ["MoWine.Domain.TestKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Nimble", from: "9.2.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MoWine.Domain",
            dependencies: []),
        .target(
            name: "MoWine.Domain.TestKit",
            dependencies: ["MoWine.Domain", "Nimble"]),
        .testTarget(
            name: "MoWine.DomainTests",
            dependencies: ["MoWine.Domain", "MoWine.Domain.TestKit"]),
    ]
)
