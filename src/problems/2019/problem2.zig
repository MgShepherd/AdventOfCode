const std = @import("std");
const putils = @import("utils").problemUtils;

const Opcodes = enum(u8) {
    Add = 1,
    Multiply = 2,
    Stop = 99,
};

pub fn solvePart1(allocator: std.mem.Allocator, inputData: []const u8, comptime replaceValues: bool) putils.ProblemError![]u64 {
    comptime var replaceValue1: ?u64 = null;
    comptime var replaceValue2: ?u64 = null;

    if (replaceValues) {
        replaceValue1 = 12;
        replaceValue2 = 2;
    }

    const output = try createSliceFromInput(allocator, inputData);
    try processInstructions(output, replaceValue1, replaceValue2);
    return output;
}

pub fn solvePart2(allocator: std.mem.Allocator, inputData: []const u8, comptime desiredOutput: u64) putils.ProblemError!u64 {
    const startInstructionData = try createSliceFromInput(allocator, inputData);
    const modifyableData = allocator.alloc(u64, startInstructionData.len) catch {
        return putils.ProblemError.MemoryAllocationError;
    };
    defer {
        allocator.free(startInstructionData);
        allocator.free(modifyableData);
    }

    var nounInput: u64 = 0;
    var verbInput: u64 = 0;
    while (true) : (increment(&nounInput, &verbInput)) {
        @memcpy(modifyableData, startInstructionData);

        try processInstructions(modifyableData, nounInput, verbInput);
        if (modifyableData[0] == desiredOutput) break;
    }
    return 100 * nounInput + verbInput;
}

fn createSliceFromInput(allocator: std.mem.Allocator, inputData: []const u8) putils.ProblemError![]u64 {
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

    return elements.toOwnedSlice() catch {
        return putils.ProblemError.MemoryAllocationError;
    };
}

fn processInstructions(instructionData: []u64, replaceValue1: ?u64, replaceValue2: ?u64) putils.ProblemError!void {
    if (replaceValue1 != null and replaceValue2 != null) {
        instructionData[1] = replaceValue1.?;
        instructionData[2] = replaceValue2.?;
    }

    var i: usize = 0;
    while (i < instructionData.len) : (i += 4) {
        switch (instructionData[i]) {
            @intFromEnum(Opcodes.Add) => processInstruction(instructionData, Opcodes.Add, i),
            @intFromEnum(Opcodes.Multiply) => processInstruction(instructionData, Opcodes.Multiply, i),
            @intFromEnum(Opcodes.Stop) => break,
            else => return putils.ProblemError.UnproccessableElementError,
        }
    }
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

fn increment(noun: *u64, verb: *u64) void {
    if (verb.* == 99) {
        verb.* = 0;
        noun.* += 1;
    } else {
        verb.* += 1;
    }
}
