const std = @import("std");

const utils = @import("utils");
const fileUtils = utils.fileUtils;
const problemUtils = utils.problemUtils;
const problem = @import("problems").Problem32019;

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const status = gpa.deinit();
        if (status == .leak) {
            std.debug.print("Memory Leak Detected\n", .{});
        }
    }
    const allocator = gpa.allocator();

    const fileContents = fileUtils.readProblemFile(allocator, 3) catch |err| {
        std.debug.print("Unable to read file: {any}\n", .{err});
        return;
    };
    defer allocator.free(fileContents);

    const result = problem.solve(allocator, fileContents, problemUtils.ProblemPart.Part2) catch |err| {
        std.debug.print("Problem encountered while solving problem: {any}\n", .{err});
        return;
    };
    std.debug.print("{d}\n", .{result});
}
