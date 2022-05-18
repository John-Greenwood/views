// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Views",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "Table", targets: ["Table"]),
        .library(name: "Collection", targets: ["Collection"]),
        .library(name: "Indicator", targets: ["Indicator"])
    ],
    dependencies: [],
    targets: [
        .target(name: "Table"),
        .target(name: "Collection"),
        .target(name: "Indicator")
    ]
)
