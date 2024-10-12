const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const module = b.createModule(.{
        .root_source_file = b.path("src/module.zig"),
    });

    const mainexe = b.addExecutable(.{
        .name = "main",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const testStep = b.step("test", "Run unit tests");
    const unitTests = b.addTest(.{
        .root_source_file = b.path("src/problems/2019/problems_test.zig"),
        .target = b.resolveTargetQuery(.{}),
    });
    unitTests.addRPath(b.path("src/utils"));
    unitTests.root_module.addImport("AdventOfCode", module);
    const runTests = b.addRunArtifact(unitTests);
    testStep.dependOn(&runTests.step);

    b.installArtifact(mainexe);
}
