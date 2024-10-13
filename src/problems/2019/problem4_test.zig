const problem4 = @import("problem4.zig");
const tutils = @import("utils").testUtils;
const std = @import("std");

test "should solve problem 4 part 1" {
    const cases = [_]tutils.ProblemCase(u64){
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
        const result = problem4.solve(case.input);
        try std.testing.expectEqual(case.expectedResult, result);
    }
}
