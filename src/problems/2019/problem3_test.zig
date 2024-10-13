const std = @import("std");
const problem3 = @import("./problem3.zig");
const tutils = @import("utils").testUtils;
const putils = @import("utils").problemUtils;

test "should solve problem 3 part 1" {
    const cases = [_]tutils.ProblemCase(u32){
        .{
            .input = "R8,U5,L5,D3\nU7,R6,D4,L4",
            .expectedResult = 6,
        },
        .{
            .input = "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83",
            .expectedResult = 159,
        },
        .{
            .input = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7",
            .expectedResult = 135,
        },
    };

    for (cases) |case| {
        const result = problem3.solve(std.testing.allocator, case.input, putils.ProblemPart.Part1);
        try std.testing.expectEqual(case.expectedResult, result);
    }
}

test "should solve problem 3 part 2" {
    const cases = [_]tutils.ProblemCase(u32){
        .{
            .input = "R8,U5,L5,D3\nU7,R6,D4,L4",
            .expectedResult = 30,
        },
        .{
            .input = "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83",
            .expectedResult = 610,
        },
        .{
            .input = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7",
            .expectedResult = 410,
        },
    };

    for (cases) |case| {
        const result = problem3.solve(std.testing.allocator, case.input, putils.ProblemPart.Part2);
        try std.testing.expectEqual(case.expectedResult, result);
    }
}
