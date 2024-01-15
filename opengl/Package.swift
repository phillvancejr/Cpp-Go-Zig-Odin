// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "opengl",
    //dependencies: [
    //    .package(path: "Sources/GLFW")
    //],
    targets: [
        .target(
            name: "GLFW",
            path: "GLFW"
        ),
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "opengl",
            //dependencies: ["GLFW"],
            path: "Sources",
            cSettings: [.define("GL_SILENCE_DEPRECATION")],
            linkerSettings: [
                .unsafeFlags(["-L../deps/glfw/mac"]),
                .linkedLibrary("glfw3-arm"),
                .linkedFramework("Cocoa"),
                .linkedFramework("IOKit")
            ])
    ]
)
