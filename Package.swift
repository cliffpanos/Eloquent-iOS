// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Eloquent",
    dependencies: [
        .package(url: "https://github.com/tid-kijyun/Kanna.git", from: "5.0.0")
        // .package(url: "https://github.com/quinquice/Reductio.git", from: "master")
    ],
    products: [
      .library(name: "NLP", targets: ["NLP"]),
    ],
    targets: [
        .target(
            name: "NLP",
            dependencies: ["Kanna"],
            path: "NLP"),
    ]
)