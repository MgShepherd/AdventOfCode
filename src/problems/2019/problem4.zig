const std = @import("std");
const putils = @import("utils").problemUtils;

const NUMBER_LENGTH = 6;

pub fn solve(data: []const u8) putils.ProblemError!u64 {
    var iterator = std.mem.splitSequence(u8, data, "-");

    const rangeStart = try readNextItemAsInt(iterator.next());
    const rangeEnd = try readNextItemAsInt(iterator.next());

    var numValidPasswords: u64 = 0;
    for (rangeStart..rangeEnd) |element| {
        const digitArray = try convertToDigitArray(element);
        if (doesMeetCriteria(&digitArray)) {
            numValidPasswords += 1;
        }
    }

    return numValidPasswords;
}

fn readNextItemAsInt(item: ?[]const u8) putils.ProblemError!u64 {
    return std.fmt.parseInt(u64, item.?, 10) catch {
        return putils.ProblemError.UnproccessableElementError;
    };
}

fn convertToDigitArray(element: u64) putils.ProblemError![NUMBER_LENGTH]u8 {
    var buf: [NUMBER_LENGTH]u8 = undefined;
    const elementAsString = std.fmt.bufPrint(&buf, "{}", .{element}) catch {
        return putils.ProblemError.UnproccessableElementError;
    };

    var digitArray: [NUMBER_LENGTH]u8 = undefined;
    for (elementAsString, 0..) |digit, index| {
        digitArray[index] = digit - '0';
    }
    return digitArray;
}

fn doesMeetCriteria(digitArray: []const u8) bool {
    var adjacentDigitsSame = false;

    for (0..(digitArray.len - 1)) |index| {
        if (digitArray[index] == digitArray[index + 1]) {
            adjacentDigitsSame = true;
        } else if (digitArray[index] > digitArray[index + 1]) {
            return false;
        }
    }
    return adjacentDigitsSame;
}
