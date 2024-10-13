const problem4 = @import("problem4.zig");
const utils = @import("utils");
const std = @import("std");

test "should solve problem 4 part 1" {
    const cases = [_]utils.testUtils.ProblemCase(u64){
        .{
            .input = "111111-111112",
            .expectedResult = 1,
        },
        .{
            .input = "223450-223451",
            .expectedResult = 0,
        },
    };

    for (cases) |case| {
        const result = problem4.solve(case.input, utils.problemUtils.ProblemPart.Part1);
        try std.testing.expectEqual(case.expectedResult, result);
    }
}

test "should solve problem 4 part 2" {
    const cases = [_]utils.testUtils.ProblemCase(u64){
        .{
            .input = "112233-112234",
            .expectedResult = 1,
        },
        .{
            .input = "123444-123445",
            .expectedResult = 0,
        },
        .{
            .input = "111122-111123",
            .expectedResult = 1,
        },
    };

    for (cases) |case| {
        const result = problem4.solve(case.input, utils.problemUtils.ProblemPart.Part2);
        try std.testing.expectEqual(case.expectedResult, result);
    }
}
