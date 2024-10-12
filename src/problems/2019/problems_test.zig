pub const problem1_test = @import("problem1_test.zig");

const std = @import("std");

test {
    std.testing.refAllDecls(@This());
}
