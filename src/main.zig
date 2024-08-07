const std = @import("std");

fn isDigit(char: u8) bool {
    return (char == '0') or (char == '1') or (char == '2') or (char == '3') or
        (char == '4') or (char == '5') or (char == '6') or (char == '7') or (char == '8') or (char == '9');
}
fn isIntegerStr(str: []const u8) !void {
    for (str) |char| {
        if (!isDigit(char)) {
            return error.NaN;
        }
    }
}

fn stringAdd(str_a: []const u8, str_b: []const u8) ![]const u8 {
    // error out if the strings aren't valid integers to add together
    try isIntegerStr(str_a);
    try isIntegerStr(str_b);

    // now do the string addition

    return "Hello!";
}

pub fn main() !void {
    const str_a = "12341";
    const res = try stringAdd(str_a, str_a);
    std.debug.print("{s}", .{res});
}
