// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VPOnboardingKit",
    platforms: [
      .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "VPOnboardingKit",
            targets: ["VPOnboardingKit"]),
    ],
    dependencies: [
      .package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "VPOnboardingKit",
            dependencies: ["SnapKit"]),
        .testTarget(
            name: "VPOnboardingKitTests",
            dependencies: ["VPOnboardingKit"]),
    ]
)
