const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const exe = b.addExecutable("zig_build_system", "build_system.zig");
    exe.linkLibC();
    exe.addObjectFile("libadd.a");
    exe.setOutputDir(".");
    exe.install();

}
