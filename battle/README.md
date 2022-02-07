# Text Battle Simulation
A simple test I like to do when learning languages involving 2 warriors who attack each other until one dies. It shows random number generation, structs and where applicable structured bindings/destructing

This is a very simple program and all languages allowed for nice implementations without fuss
## C++
C++ was suprising in the compilation speed comparison. Without using a precompiled header C++ was actually #3 due I'm assuming to `<string>`. If a precompiled header is used then C++ moves to #2 with 0.223s
## Go
Go's compilation speed surprised me in this project
## Odin
Odin is the only version in which I didn't use a pointer array to hold and retrieve warriors. The reason I didnt' use it here is because Odin, like Go supports multiple assignment of tuples at the language level, however unlike Go it supports single line if statements. In go the non array version is twice as many lines because if the required curlys for if and else

C++ can do something simlar but it requires either defining a struct to hold the Warrior pointers or using std::tuple
```go
w1, w2 : ^Warrior
if i == 0 do w1, w2 = &grog, &bork
else do w1, w2 = &bork, &grog
```
```c++
auto [ w1, w2 ] = i == 0 ? std::tuple{ &grog, & bork } : std::tuple{ &bork, &grog };
```
The c++ version isn't bad but it does incur the cost of including `<tuple>`

Again Go's is longer than the array indexing version
```go
var w1, w2 *Warrior
if i == 0 {
    w1, w2 = &grog, &bork
} else {
    w1, w2 = &bork, &grog
}
```

Odin surprisingly was also the slowest to comile

### compile times
ranked according to cached times
<table>
    <th>lang</th>
    <th>cached</th>
    <th>cold</th>
    <tr>
        <td>1. go</td> 
        <td>0.111s</td>
        <td>2.890s</td>
    </tr>
    <tr>
        <td>2. zig</td> 
        <td>0.323s</td>
        <td style="color:red">3.855s</td>
    </tr>
    <tr>
        <td>3. c++</td> 
        <td>0.353s</td>
        <td>1.059s</td>
    </tr>
    <tr>
        <td>4. odin</td> 
        <td>0.828s</td>
        <td>1.733s</td>
    </tr>
</table>

### demo
```
Grog attacked Bork for 10 damage!

Grog hp 100
Bork hp 90

Grog attacked Bork for 10 damage!

Grog hp 100
Bork hp 80

Grog attacked Bork for 10 damage!

Grog hp 100
Bork hp 70

Grog attacked Bork for 10 damage!

Grog hp 100
Bork hp 60

Bork attacked Grog for 10 damage!

Bork hp 60
Grog hp 90

Grog attacked Bork for 10 damage!

Grog hp 90
Bork hp 50

Grog attacked Bork for 10 damage!

Grog hp 90
Bork hp 40

Grog attacked Bork for 10 damage!

Grog hp 90
Bork hp 30

Grog attacked Bork for 10 damage!

Grog hp 90
Bork hp 20

Bork attacked Grog for 10 damage!

Bork hp 20
Grog hp 80

Bork attacked Grog for 10 damage!

Bork hp 20
Grog hp 70

Bork attacked Grog for 10 damage!

Bork hp 20
Grog hp 60

Grog attacked Bork for 10 damage!

Grog hp 60
Bork hp 10

Bork attacked Grog for 10 damage!

Bork hp 10
Grog hp 50

Grog attacked Bork for 10 damage!

Grog hp 50
Bork hp 0

Grog defeated Bork!
```