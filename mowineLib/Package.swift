// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "mowineLib",
    platforms: [
        .iOS("15.0"), .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "mowineLib",
            targets: ["Model"]),
        .library(
            name: "ModelTestHelpers",
            targets: ["ModelTestHelpers"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", from: "1.9.3"),
         .package(url: "https://github.com/Quick/Nimble", from: "9.2.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Model",
            dependencies: ["SwiftyBeaver"]),
        .target(
            name: "ModelTestHelpers",
            dependencies: ["Model", "Nimble"]),
        .testTarget(
            name: "ModelTests",
            dependencies: ["Model", "ModelTestHelpers"]),
    ]
)