const testing = @import("std").testing;
const problem1 = @import("./problem1.zig");

const utils = @import("utils");
const tutils = utils.testUtils;
const putils = utils.problemUtils;

test "should solve problem 1 part 1" {
    const inputs = [_]tutils.ProblemCase(u64){
        .{
            .input = "12\n",
            .expectedResult = 2,
        },
        .{
            .input = " 12    \n",
            .expectedResult = 2,
        },
        .{
            .input = "100756\n14\n",
            .expectedResult = 33585,
        },
    };

    for (inputs) |case| {
        try testing.expectEqual(
            case.expectedResult,
            problem1.solve(case.input, putils.ProblemPart.Part1),
        );
    }
}

test "should solve problem 1 part 2" {
    const inputs = [_]tutils.ProblemCase(u64){
        .{
            .input = "14\n",
            .expectedResult = 2,
        },
        .{
            .input = " 1969    \n",
            .expectedResult = 966,
        },
        .{
            .input = "100756\n14\n",
            .expectedResult = 50348,
        },
    };

    for (inputs) |case| {
        try testing.expectEqual(
            case.expectedResult,
            problem1.solve(case.input, putils.ProblemPart.Part2),
        );
    }
}
