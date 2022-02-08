const std = @import("std");
const print = std.debug.print;
const os = std.os;
const net = std.net;
const port = 8000;

pub fn main() !void{
    const server = try os.socket(os.AF.INET, os.SOCK.STREAM, 0);
    defer os.closeSocket(server);

    const addr = try net.Address.resolveIp("127.0.0.1", port);

    try os.bind(server, &addr.any, addr.getOsSockLen());
    try os.listen(server, 1);
    print("listening on port {}\n", .{port});

    const client = try os.accept(server, null, null, 0);
    defer os.closeSocket(client);
    print("client connected!\n", .{});

    const welcome = "Welcome to Zig echo2!\n";
    _= try os.send(client, welcome[0..], 0);

    while ( true ) {
        var buf = [_]u8{0} ** 128;

        const len = try os.recv(client, buf[0..], 0);

        var reply_buf = [_]u8{0} ** 128;
        var fba = std.heap.FixedBufferAllocator.init(&reply_buf).allocator();
        var reply = std.ArrayList(u8).init(fba);

        if ( len > 0 ) {
            if (std.mem.indexOf(u8, buf[0..], "bye")) |_| {
                print("saying goodbye!", .{});
                _=try reply.writer().write("Good bye!");
                _=try os.send(client, reply.items, 0);
                break;
            }
            print("received: {s}", .{buf[0..len]});
            _=try reply.writer().write("echo: ");
            _=try reply.writer().write(buf[0..len]);
            _=try reply.writer().write("\n");
            _=try os.send(client, reply.items, 0);
        } else break;
    }
    print("shutting down\n", .{});
}