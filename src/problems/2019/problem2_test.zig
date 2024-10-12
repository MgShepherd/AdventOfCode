const std = @import("std");

const problem2 = @import("./problem2.zig");
const tutils = @import("utils").testUtils;

test "should solve problem 2 part 1 examples" {
    const cases = [_]tutils.ProblemCase([]const u8){
        .{
            .input = "1,0,0,0,99",
            .expectedResult = "2,0,0,0,99",
        },
        .{
            .input = "1,9,10,3,2,3,11,0,99,30,40,50",
            .expectedResult = "3500,9,10,70,2,3,11,0,99,30,40,50",
        },
    };

    for (cases) |case| {
        const result = problem2.solve(std.testing.allocator, case.input, false) catch {
            return error.TestExpectedEqual;
        };
        defer std.testing.allocator.free(result);
        try compareArrays(case.expectedResult, result);
    }
}

test "should solve problem 2 part 1 using real data and program alarm updates" {
    const actualInput = tutils.ProblemCase(u64){
        .input = "1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,9,1,19,1,9,19,23,1,23,5,27,2,27,10,31,1,6,31,35,1,6,35,39,2,9,39,43,1,6,43,47,1,47,5,51,1,51,13,55,1,55,13,59,1,59,5,63,2,63,6,67,1,5,67,71,1,71,13,75,1,10,75,79,2,79,6,83,2,9,83,87,1,5,87,91,1,91,5,95,2,9,95,99,1,6,99,103,1,9,103,107,2,9,107,111,1,111,6,115,2,9,115,119,1,119,6,123,1,123,9,127,2,127,13,131,1,131,9,135,1,10,135,139,2,139,10,143,1,143,5,147,2,147,6,151,1,151,5,155,1,2,155,159,1,6,159,0,99,2,0,14,0",
        .expectedResult = 6627023,
    };
    const result = problem2.solve(std.testing.allocator, actualInput.input, true) catch {
        return error.TestExpectedEqual;
    };
    defer std.testing.allocator.free(result);
    try std.testing.expectEqual(actualInput.expectedResult, result[0]);
}

fn compareArrays(expected: []const u8, actual: []u64) !void {
    var iterator = std.mem.splitSequence(u8, expected, ",");
    var index: usize = 0;
    while (iterator.next()) |element| : (index += 1) {
        const intElement = try std.fmt.parseInt(u64, element, 10);
        try std.testing.expectEqual(intElement, actual[index]);
    }
}
