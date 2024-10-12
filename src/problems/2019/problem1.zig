const std = @import("std");

const ProblemError = error{UnproccessableLine};

pub fn solve(inputData: []const u8) ProblemError!u64 {
    var iterator = std.mem.splitSequence(u8, inputData, "\n");
    var requiredFuel: u64 = 0;
    while (iterator.next()) |line| {
        const value = std.mem.trim(u8, line, " \n");
        if (value.len == 0) break;

        const intValue = std.fmt.parseInt(u64, value, 10) catch {
            return ProblemError.UnproccessableLine;
        };

        requiredFuel += intValue / 3 - 2;
    }
    return requiredFuel;
}
