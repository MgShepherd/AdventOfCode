const std = @import("std");

const utils = @import("utils");
const fileUtils = utils.fileUtils;
const problemUtils = utils.problemUtils;
const problem = @import("problems").Problem42019;

pub fn main() void {
    const result = problem.solve("245318-765747") catch |err| {
        std.debug.print("Problem encountered while solving problem: {any}\n", .{err});
        return;
    };
    std.debug.print("{d}\n", .{result});
}
