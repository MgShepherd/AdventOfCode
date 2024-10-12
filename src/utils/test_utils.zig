pub fn ProblemCase(comptime OutputType: type) type {
    return struct {
        input: []const u8,
        expectedResult: OutputType,
    };
}
