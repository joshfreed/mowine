// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MoWine.Application",
    platforms: [
        .iOS("15.0"), .macOS("12.0.0")
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MoWine.Application",
            targets: ["MoWine.Application"]),
        .library(
            name: "MoWine.Application.TestKit",
            targets: ["MoWine.Application.TestKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", from: "1.9.3"),
        .package(url: "https://github.com/Quick/Nimble", from: "9.2.1"),
        .package(path: "../MoWine.Domain"),
        .package(name: "Dip", url: "https://github.com/AliSoftware/Dip", from: "7.1.1"),
        .package(name: "JFLib", path: "../JFLib"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MoWine.Application",
            dependencies: [
                "Dip",
                "SwiftyBeaver",
                "MoWine.Domain",
                .product(name: "JFLib.Mediator", package: "JFLib")
            ]),
        .target(
            name: "MoWine.Application.TestKit",
            dependencies: ["MoWine.Application", "Nimble"]),
        .testTarget(
            name: "MoWine.ApplicationTests",
            dependencies: [
                "MoWine.Application",
                "MoWine.Application.TestKit",
                .product(name: "MoWine.Domain.TestKit", package: "MoWine.Domain"),
                "Nimble"
            ]),
    ]
)
