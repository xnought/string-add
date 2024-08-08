const std = @import("std");

const Digit = u5;
const CarryDigit = u1;
const DigitsArray = std.ArrayList(Digit);

fn parseDigit(char: u8) error{NaN}!Digit {
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

fn toDigitsArray(str: []const u8, allocator: std.mem.Allocator) !DigitsArray {
    var list = DigitsArray.init(allocator);
    errdefer list.deinit();
    for (0..str.len) |i| {
        const num = try parseDigit(str[i]);
        try list.append(num);
    }
    return list;
}

fn padLeading0s(a: *DigitsArray, b: *DigitsArray) !void {
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

fn digitAdd(digit_a: Digit, digit_b: Digit, carry: CarryDigit) struct { add: Digit, carry: CarryDigit } {
    // total expression will atleast be < 2^5
    const out: Digit = digit_a + digit_b + carry;
    const exceeds = out > 9;
    if (!exceeds) {
        return .{ .add = out, .carry = 0 };
    } else {
        return .{ .add = out, .carry = 1 };
    }
}

fn stringAdd(str_a: []const u8, str_b: []const u8, allocator: std.mem.Allocator) !DigitsArray {
    var a = try toDigitsArray(str_a, allocator);
    var b = try toDigitsArray(str_b, allocator);
    var c = DigitsArray.init(allocator); // c = a + b
    defer a.deinit();
    defer b.deinit();

    // if a is 1000 and b is 1
    // this func will convert b to 0001
    // a.items.len = b.items.len after
    try padLeading0s(&a, &b);

    // do adds for each digit and bring the carry each time
    var i: usize = a.items.len;
    var carry: CarryDigit = 0;
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
