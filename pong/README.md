# Pong
Pong with Raylb. The game is so simple that there really isn't much to say
## D
D's was pretty much exactly the same as C++. D is cool, but using it with Wasm is a pain so I probably won't be using it any further
## Odin
Super simple like the others. Odin's embedded linker/include flags is very nice, you just odin build and it works. Also Odin has language level support for mathmatical vectors though I didnt' use them here. 
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
        <td>2. D</td> 
        <td>0.543s</td>
        <td>0.597s</td>
    </tr>
    <tr>
        <td>3. odin</td> 
        <td>0.995s</td>
        <td>1.303s</td>
    </tr>
</table>