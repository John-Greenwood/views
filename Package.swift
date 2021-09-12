// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Views",
    platforms: [.iOS(.v10)],
    products: [.library(name: "Views", targets: ["Views"])],
    dependencies: [],
    targets: [.target(name: "Views")]
)
