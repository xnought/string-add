const std = @import("std");
const print = std.debug.print;

fn isDigit(char: u8) bool {
    return (char == '0') or (char == '1') or (char == '2') or (char == '3') or
        (char == '4') or (char == '5') or (char == '6') or (char == '7') or (char == '8') or (char == '9');
}

fn parseDigit(char: u8) error{NaN}!u8 {
    return switch (char) {
        '0' => 0,
        '1' => 1,
        '2' => 2,
        '3' => 3,
        '4' => 4,
        '5' => 5,
        '6' => 6,
        '7' => 7,
        '8' => 8,
        '9' => 9,
        else => error.NaN,
    };
}

fn toIntArr(str: []const u8, allocator: std.mem.Allocator) !std.ArrayList(u8) {
    var list = std.ArrayList(u8).init(allocator);
    errdefer list.deinit();
    for (0..str.len) |i| {
        const num = try parseDigit(str[i]);
        try list.append(num);
    }
    return list;
}

fn stringAdd(str_a: []const u8, str_b: []const u8, allocator: std.mem.Allocator) ![]const u8 {
    const a = try toIntArr(str_a, allocator);
    const b = try toIntArr(str_b, allocator);
    defer a.deinit();
    defer b.deinit();

    print("{any} {any}", .{ a.items, b.items });

    // now do the string addition
    // TODO: do with carries
    // var a_i: usize = str_a.len;
    // while (a_i > 0) {
    //     a_i -= 1;

    //     print("{}\n", .{a_i});
    // }

    return "Hello!";
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const str_a = "12341";
    const str_b = "00019";
    const res = try stringAdd(str_a, str_b, allocator);
    print("{s}", .{res});
}
