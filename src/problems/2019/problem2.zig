const std = @import("std");
const putils = @import("utils").problemUtils;

const Opcodes = enum(u8) {
    Add = 1,
    Multiply = 2,
    Stop = 99,
};

pub fn solve(allocator: std.mem.Allocator, inputData: []const u8, replaceStart: bool) putils.ProblemError![]u64 {
    var iterator = std.mem.splitSequence(u8, inputData, ",");
    var elements = std.ArrayList(u64).init(allocator);

    while (iterator.next()) |element| {
        const value = std.mem.trim(u8, element, " \n");
        const intValue = std.fmt.parseInt(u64, value, 10) catch {
            std.debug.print("Unable to convert {s} to integer\n", .{element});
            return putils.ProblemError.UnproccessableElementError;
        };
        elements.append(intValue) catch {
            return putils.ProblemError.MemoryAllocationError;
        };
    }

    const output = elements.toOwnedSlice() catch {
        return putils.ProblemError.MemoryAllocationError;
    };
    if (replaceStart) {
        output[1] = 12;
        output[2] = 2;
    }

    var i: usize = 0;
    while (i < output.len) : (i += 4) {
        switch (output[i]) {
            @intFromEnum(Opcodes.Add) => processInstruction(output, Opcodes.Add, i),
            @intFromEnum(Opcodes.Multiply) => processInstruction(output, Opcodes.Multiply, i),
            @intFromEnum(Opcodes.Stop) => break,
            else => return putils.ProblemError.UnproccessableElementError,
        }
    }
    return output;
}

fn processInstruction(elements: []u64, operation: Opcodes, startIndex: usize) void {
    var newValue: u64 = undefined;
    if (operation == .Add) {
        newValue = elements[elements[startIndex + 1]] + elements[elements[startIndex + 2]];
    } else {
        newValue = elements[elements[startIndex + 1]] * elements[elements[startIndex + 2]];
    }
    elements[elements[startIndex + 3]] = newValue;
}
