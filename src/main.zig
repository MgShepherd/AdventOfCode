const std = @import("std");

const fileUtils = @import("./utils/file_utils.zig");
const problemUtils = @import("./utils/problem_utils.zig");
const problem = @import("./problems/2019/problem1.zig");

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const status = gpa.deinit();
        if (status == .leak) {
            std.debug.print("Memory Leak Detected\n", .{});
        }
    }
    const allocator = gpa.allocator();

    const fileContents = fileUtils.readProblemFile(allocator, 1) catch |err| {
        std.debug.print("Unable to read file: {any}\n", .{err});
        return;
    };
    defer allocator.free(fileContents);

    const result = problem.solve(fileContents, problemUtils.ProblemPart.Part2) catch |err| {
        std.debug.print("Problem encountered while solving problem: {any}\n", .{err});
        return;
    };
    std.debug.print("{any}\n", .{result});
}
