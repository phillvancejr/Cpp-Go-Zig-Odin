# Pong
Pong with Raylb. The game is so simple that there really isn't much to say
## D
D's was pretty much exactly the same as C++. D is cool, but using it with Wasm is a pain so I probably won't be using it any further
## Odin
Super simple like the others. Odin's embedded linker/include flags is very nice, you just odin build and it works. Also Odin has language level support for mathmatical vectors though I didnt' use them here. 
## Janet
This was the second Janet example I did and Janet has a feature the others don't that basically made it the winner for me. Janet allows for live reloading of code while the program is running, similar to Lisp with Slime and Swank. I developed this pong demo as it ran using the NeoVim with the Conjure Plugin as the editor and it was super fun. The changes take place instantly:
![](janet_pong_reload.gif)


### compile times
ranked according to cached times
<table>
    <th>lang</th>
    <th>cached</th>
    <th>cold</th>
    <tr>
        <td>1. c++</td> 
        <td>0.441s</td>
        <td>0.506s</td>
    </tr>
    <tr>
        <td>2. janet</td> 
        <td>0.492s</td>
        <td>1.276s</td>
    </tr>
    <tr>
        <td>3. D</td> 
        <td>0.543s</td>
        <td>0.597s</td>
    </tr>
    <tr>
        <td>5. odin</td> 
        <td>0.995s</td>
        <td>1.303s</td>
    </tr>
</table>

### demo
![](janet_pong.gif)