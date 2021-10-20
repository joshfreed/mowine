// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MoWine.Infrastructure",
    platforms: [
        .iOS("15.0"), .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MoWine.Infrastructure",
            targets: ["MoWine.Infrastructure"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../MoWine.Application"),
        .package(path: "../MoWine.Domain"),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", from: "1.9.3"),
        .package(url: "https://github.com/Quick/Nimble", from: "9.2.1"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "8.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MoWine.Infrastructure",
            dependencies: [
                "MoWine.Application",
                "MoWine.Domain",
                "SwiftyBeaver",
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
            ]),
        .testTarget(
            name: "MoWine.InfrastructureTests",
            dependencies: [
                "MoWine.Infrastructure",
                "Nimble",
                .product(name: "MoWine.Domain.TestKit", package: "MoWine.Domain"),
            ]),
    ]
)
