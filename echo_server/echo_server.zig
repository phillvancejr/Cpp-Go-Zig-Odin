const std = @import("std");
const net = std.net;
const print = std.debug.print;

const port = 8000;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var server = net.StreamServer.init(.{});
    defer server.deinit();

    try server.listen(net.Address.parseIp("127.0.0.1", 8000) catch unreachable);
    print("listening on port {}\n", .{port});

    var client: net.StreamServer.Connection = try server.accept();
    defer client.stream.close();
    print("client connected!\n", .{});
    _=try client.stream.write("Welcome to Zig echo!\n");

    while (true) {
        const buf_size = 128;
        var buffer = [_]u8{0} ** buf_size;
        const len = try client.stream.read(buffer[0..]);

        if ( len > 0 ) {
        
            print("received: {s}", .{buffer});
            const prefix = "echo: ";
            var reply = try allocator.alloc(u8, prefix.len + len + 1);
            defer allocator.free(reply);
            std.mem.copy(u8, reply, prefix);
            std.mem.copy(u8, reply[prefix.len..], buffer[0..len]);
            std.mem.copy(u8, reply[prefix.len+len..], "\n");
            _= try client.stream.write(reply);
        } else {
            print("closing!\n", .{});
            break;
        }
    }

    print("shutting down\n", .{});
}