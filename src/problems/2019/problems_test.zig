pub const problem1_test = @import("problem1_test.zig");
pub const problem2_test = @import("problem2_test.zig");
pub const problem3_test = @import("problem3_test.zig");
pub const problem4_test = @import("problem4_test.zig");

const std = @import("std");

test {
    std.testing.refAllDecls(@This());
}
