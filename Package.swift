// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "SBExtensions",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(name: "SBExtensions", targets: ["SBExtensions"]),
    ],
    targets: [
        .target(name: "SBExtensions", path: "Sources"),
    ],
    swiftLanguageVersions: [
        .v5,
    ]
)
