const testing = @import("std").testing;

const problem1 = @import("problem1.zig");

const ProblemCase = struct { input: []const u8, expectedResult: u64 };

test "should solve problem 1" {
    const inputs = [_]ProblemCase{
        ProblemCase{
            .input = "12\n",
            .expectedResult = 2,
        },
        ProblemCase{
            .input = " 12    \n",
            .expectedResult = 2,
        },
        ProblemCase{
            .input = "100756\n14\n",
            .expectedResult = 33585,
        },
    };

    for (inputs) |case| {
        try testing.expectEqual(case.expectedResult, problem1.solve(case.input));
    }
}
