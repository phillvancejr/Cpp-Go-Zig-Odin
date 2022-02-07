const std = @import("std");
const print = std.debug.print;

const Warrior = struct {
    name: []const u8,
    hp: u32,
    dmg: u32,
};

fn attack(w1: *Warrior, w2: *Warrior) void {
    w2.hp -= w1.dmg;
    print("{s} attacked {s} for {} damage!\n", .{w1.name, w2.name, w1.dmg});
}

fn display(w: *Warrior) void {
    print("{s} hp {}\n", .{w.name, w.hp});
}

pub fn main() !void {
    var rand = std.rand.DefaultPrng.init(@bitCast(u64, std.time.milliTimestamp())).random();

    var grog = Warrior{
        .name = "Grog",
        .hp = 100,
        .dmg = 10
    };
    var bork = Warrior{
        .name = "Bork",
        .hp = 100,
        .dmg = 10
    };

    const warriors = [_]*Warrior{ &grog, &bork };

    while ( grog.hp > 0 and bork.hp > 0 ) {
        const i = rand.intRangeAtMost(u32, 0, 1);

        const w1 = warriors[i];
        const w2 = warriors[(i+1)%2];

        attack(w1, w2);
        print("\n", .{});
        display(w1);
        display(w2);
        print("\n", .{});
    }
    var winner: *Warrior = undefined;
    var loser: *Warrior = undefined;

    if (grog.hp > 0) {
        winner = &grog;
        loser = &bork;
    } else {
        winner = &bork;
        loser = &grog;
    }

    print("{s} defeated {s}!\n", .{winner.name, loser.name});

}