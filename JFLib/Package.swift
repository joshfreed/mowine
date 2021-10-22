// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JFLib",
    platforms: [
        .iOS("15.0"), .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "JFLib.DI",
            targets: ["JFLib.DI"]),
        .library(
            name: "JFLib.Mediator",
            targets: ["JFLib.Mediator"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "JFLib.DI",
            dependencies: []),
        .target(
            name: "JFLib.Mediator",
            dependencies: ["JFLib.DI"]),
        .testTarget(
            name: "JFLib.MediatorTests",
            dependencies: ["JFLib.Mediator"]),
    ]
)
