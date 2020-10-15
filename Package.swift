// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UICreator",
    platforms: [
        .iOS(.v10), .tvOS(.v10), .macOS(.v10_13)
    ],
    products: [
        .library(
            name: "UICreator",
            targets: ["UICreator"])
    ],
    dependencies: [
        .package(url: "https://github.com/umobi/ConstraintBuilder", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        .target(
            name: "UICreator",
            dependencies: ["ConstraintBuilder"]),
        .testTarget(
            name: "UICreatorTests",
            dependencies: ["UICreator"])
    ]
)
