// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UICreator",
    platforms: [
        .iOS(.v10), .tvOS(.v10), .macOS(.v10_13)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "UICreator",
            targets: ["UICreator"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/umobi/ConstraintBuilder", .upToNextMajor(from: "1.0.5"))
    ],
    targets: [
        // Targets are the basic building blocks of a package.
        // A target can define a module or a test suite.
        // Targets can depend on other targets in this package,
        // and on products in packages which this package depends on.
        .target(
            name: "UICreator",
            dependencies: ["ConstraintBuilder"]),
        .testTarget(
            name: "UICreatorTests",
            dependencies: ["UICreator"])
    ]
)
