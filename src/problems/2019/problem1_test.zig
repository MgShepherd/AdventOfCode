const testing = @import("std").testing;

const problem1 = @import("problem1.zig");

const ProblemCase = struct { input: []const u8, expectedResult: u64 };

test "should solve problem 1 part 1" {
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
        try testing.expectEqual(
            case.expectedResult,
            problem1.solve(case.input, problem1.ProblemPart.Part1),
        );
    }
}

test "should solve problem 1 part 2" {
    const inputs = [_]ProblemCase{
        ProblemCase{
            .input = "14\n",
            .expectedResult = 2,
        },
        ProblemCase{
            .input = " 1969    \n",
            .expectedResult = 966,
        },
        ProblemCase{
            .input = "100756\n14\n",
            .expectedResult = 50348,
        },
    };

    for (inputs) |case| {
        try testing.expectEqual(
            case.expectedResult,
            problem1.solve(case.input, problem1.ProblemPart.Part2),
        );
    }
}
