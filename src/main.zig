const std = @import("std");

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

fn digitAdd(digit_a: u8, digit_b: u8, carry: u8) struct { add: u8, carry: u8 } {
    const out = digit_a + digit_b + carry;
    const exceeds = out > 9;
    if (!exceeds) {
        return .{ .add = out, .carry = 0 };
    } else {
        return .{ .add = out - 10, .carry = 1 };
    }
}

fn stringAdd(str_a: []const u8, str_b: []const u8, allocator: std.mem.Allocator) !std.ArrayList(u8) {
    var a = try toIntArr(str_a, allocator);
    var b = try toIntArr(str_b, allocator);
    var c = std.ArrayList(u8).init(allocator); // c = a + b
    defer a.deinit();
    defer b.deinit();

    // if a is 1000 and b is 1
    // this func will convert b to 0001
    // a.items.len = b.items.len after
    try padLeading0s(&a, &b);

    // do adds for each digit and bring the carry each time
    var i: usize = a.items.len;
    var carry: u8 = 0;
    while (i > 0) {
        i -= 1;
        const out = digitAdd(a.items[i], b.items[i], carry);
        carry = out.carry;
        try c.insert(0, out.add);
    }
    // if the right leading has carry
    if (carry == 1) {
        try c.insert(0, 1);
    }

    return c;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    // read in two numbers provided
    // i.e. ./str-add 15 20
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    if (args.len < 3) {
        return error.MustProvideTwoNumbers;
    }
    const str_a = args[1];
    const str_b = args[2];

    const res = try stringAdd(str_b, str_a, allocator);
    defer res.deinit();

    // result  to stdout
    const outw = std.io.getStdOut().writer();
    for (res.items) |digit| {
        try outw.print("{}", .{digit});
    }
}
