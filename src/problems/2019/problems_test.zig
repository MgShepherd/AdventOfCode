pub const problem1_test = @import("problem1_test.zig");
pub const problem2_test = @import("problem2_test.zig");

const std = @import("std");

test {
    std.testing.refAllDecls(@This());
}
