const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const utils = b.createModule(.{
        .root_source_file = b.path("src/utils/utils.zig"),
    });

    const problems = b.createModule(.{
        .root_source_file = b.path("src/problems/problems.zig"),
    });
    problems.addImport("utils", utils);

    const mainexe = b.addExecutable(.{
        .name = "main",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    mainexe.root_module.addImport("utils", utils);
    mainexe.root_module.addImport("problems", problems);

    const testStep = b.step("test", "Run unit tests");
    const unitTests = b.addTest(.{
        .root_source_file = b.path("src/problems/2019/problems_test.zig"),
        .target = b.resolveTargetQuery(.{}),
    });
    unitTests.root_module.addImport("utils", utils);
    const runTests = b.addRunArtifact(unitTests);
    testStep.dependOn(&runTests.step);

    b.installArtifact(mainexe);
}
