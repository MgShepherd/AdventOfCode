const std = @import("std");

const MAX_FILE_PATH_LEN = 100;

const FileReadError = error{ OpenFile, ReadFile };

pub fn readProblemFile(allocator: std.mem.Allocator, problemNumber: u8) FileReadError![]u8 {
    var filePathBuf: [MAX_FILE_PATH_LEN]u8 = undefined;
    const filePath = std.fmt.bufPrint(
        &filePathBuf,
        "./problemInputs/problem{d}.txt",
        .{problemNumber},
    ) catch return error.OpenFile;
    const file = std.fs.cwd().openFile(filePath, .{}) catch return FileReadError.OpenFile;
    defer file.close();

    return file.readToEndAlloc(allocator, std.math.maxInt(usize)) catch return error.ReadFile;
}
