const std = @import("std");

const ProblemError = error{UnproccessableLine};
pub const ProblemPart = enum { Part1, Part2 };

pub fn solve(inputData: []const u8, part: ProblemPart) ProblemError!u64 {
    var iterator = std.mem.splitSequence(u8, inputData, "\n");
    var requiredFuel: u64 = 0;
    while (iterator.next()) |line| {
        const value = std.mem.trim(u8, line, " \n");
        if (value.len == 0) break;

        const intValue = std.fmt.parseInt(u64, value, 10) catch {
            return ProblemError.UnproccessableLine;
        };

        switch (part) {
            .Part1 => {
                requiredFuel += intValue / 3 - 2;
            },
            .Part2 => {
                requiredFuel += getFuelRecursively(intValue);
            },
        }
    }
    return requiredFuel;
}

fn getFuelRecursively(mass: u64) u64 {
    const fuelForMass = mass / 3;

    if (fuelForMass <= 2) return 0;
    return (fuelForMass - 2) + getFuelRecursively(fuelForMass - 2);
}
