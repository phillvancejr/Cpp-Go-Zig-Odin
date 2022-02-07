const std = @import("std");
const print = std.debug.print;
const json = std.json;

const c = @cImport(@cInclude("curl/curl.h"));

const Person = struct {
    name: []u8,
    height: []u8,
    mass: []u8,
    hair_color: []u8,
    skin_color: []u8,
    eye_color: []u8,
    birth_year: []u8,
    gender: []u8,
    homeworld: []u8,
    films:[][]u8,
    species:[][]u8,
    vehicles:[][]u8,
    starships:[][]u8,
    created:[]u8,
    edited:[]u8,
    url:[]u8,
};

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var data = std.ArrayList(u8).init(gpa.allocator());
var string_writer = data.writer();


pub fn main() !void {
    var allocator = gpa.allocator();
    defer _=gpa.deinit();
    defer data.deinit();

    const curl = c.curl_easy_init() orelse return;
    defer c.curl_easy_cleanup(curl);

    _=c.curl_easy_setopt(curl, c.CURLOPT_URL, "https://swapi.dev/api/people/1");
    // print("CURL OPT URL {}\nCURL OPT WRITE FNCTION {}\nCURL OK {}\n", .{c.CURLOPT_URL, c.CURLOPT_WRITEFUNCTION, c.CURLE_OK});
    // Curl prints the response to std out by default
    // to disable this and do something myself I need to set the curlopt_writefunction and provide a function
    _=c.curl_easy_setopt(curl, c.CURLOPT_WRITEFUNCTION, struct{
        fn call(buffer: [*]u8, item_size: usize, n_items: usize, ignore: *anyopaque) usize {
            if(false)_=.{buffer,ignore};
            var size = item_size * n_items;

            _=string_writer.write(buffer[0..n_items]) catch unreachable;

            return size;
        }
    }.call);

    const code = c.curl_easy_perform(curl);

    if ( code != c.CURLE_OK ) print("download problem! {s}\n", .{c.curl_easy_strerror(code)});
    var stream = std.json.TokenStream.init(data.items);

    @setEvalBranchQuota(1000_000); // needed to prevent parse from throwing some error
    const luke = try std.json.parse(Person, &stream, .{.allocator=allocator});
    defer std.json.parseFree(Person, luke, .{.allocator=allocator}) ;
    _=luke;

    print("{s} has {s} eyes\n", .{luke.name, luke.eye_color});

}