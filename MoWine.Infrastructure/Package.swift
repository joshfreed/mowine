// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MoWine.Infrastructure",
    platforms: [
        .iOS("15.0"), .macOS("12.0.0")
    ],
    products: [
        .library(
            name: "MoWine.Infrastructure",
            targets: ["MoWine.Infrastructure"]),
    ],
    dependencies: [
        .package(name: "JFLib", url: "https://github.com/joshfreed/JFLib", from: "1.0.0"),
        .package(path: "../MoWine.Application"),
        .package(path: "../MoWine.Domain"),
        .package(url: "https://github.com/Quick/Nimble", from: "9.2.1"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.0.0"),
        .package(url: "https://github.com/facebook/facebook-ios-sdk", from: "17.0.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "7.0.0"),
        .package(name: "Dip", url: "https://github.com/AliSoftware/Dip", from: "7.1.1"),
    ],
    targets: [
        .target(
            name: "MoWine.Infrastructure",
            dependencies: [
                "MoWine.Application",
                "MoWine.Domain",

                .product(name: "JFLib.Combine", package: "JFLib"),
                .product(name: "JFLib.Services", package: "JFLib"),
                .product(name: "JFLib.Mediator", package: "JFLib"),

                .product(name: "Dip", package: "Dip"),

                .product(name: "FacebookCore", package: "facebook-ios-sdk"),
                .product(name: "FacebookLogin", package: "facebook-ios-sdk"),

                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),

                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalyticsSwift", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreCombine-Community", package: "firebase-ios-sdk"),
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
