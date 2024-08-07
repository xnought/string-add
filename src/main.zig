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

fn padLeading0s(a: *std.ArrayList(u8), b: *std.ArrayList(u8)) !void {
    // find which ones is longer
    if (a.*.items.len == b.*.items.len) {
        return;
    } else if (a.*.items.len > b.*.items.len) {
        // a is longer, so pad 0s to b
        for (b.*.items.len..a.*.items.len) |_| {
            try b.*.insert(0, 0);
        }
    } else {
        // b is longer, so pad 0s to a
        for (a.*.items.len..b.*.items.len) |_| {
            try a.*.insert(0, 0);
        }
    }
}

fn stringAdd(str_a: []const u8, str_b: []const u8, allocator: std.mem.Allocator) ![]const u8 {
    var a = try toIntArr(str_a, allocator);
    var b = try toIntArr(str_b, allocator);
    defer a.deinit();
    defer b.deinit();

    // if a is 1000 and b is 1
    // this func will convert b to 0001
    try padLeading0s(&a, &b);

    print("{any} {any}", .{ a, b });

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
    const str_b = "19";
    const res = try stringAdd(str_a, str_b, allocator);
    print("{s}", .{res});
}
