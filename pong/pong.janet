# netrepl is the server that recieves and runs repl commands from NeoVim and Conjure
(import spork/netrepl)
# start the server
# instead of just using (netrepl/server) we set it up manually so we can pass it the current fiber environment
# this keeps the variables properly linked allowed for live updating
(netrepl/server "127.0.0.1" "9365" (fiber/getenv (fiber/current)))
# this allows vars to be updated in a simple way 
(setdyn :redef true)
# without set dyn we would define a variable first with var like (var a 10)
# and then to update we would need a separate (set a 2)
# using setdyn makes things shorter and simpler

# Awesome Janet Raylib Bindings
# installed easily with the jpm package manager
(use jaylib)
# constants
(def width 210)
(def height 160)
(def scale 4)
(def title "Pong Janet")

(def padw 10)
(def padh 50)
(var pspeed 100)
(var bspeed 100)

(var py
  ( - 
      (/ height 2.0) 
      (/ padh 2.0) ))
(var cpuy py)
(def cpux 
  (- 
    width
    (* 2 padw)))
(def bsz 10)
(var xdir 0)
(var ydir 0)
(var bx 0)
(var by 0)
(var pscore 0)
(var cpuscore 0)
(def maxscore 999)
#here
(var reset-ball (fn[]
  (set xdir 
    (if ( = 0 (math/round (math/random)))
      1 
      -1))
  (set ydir 
    (if ( = 0 (math/round (math/random)))
      1 
      -1))
  (set bx 
    (- 
      (/ width 2.0)
      (/ bsz 2.0)))
  (set by
    (- 
      (/ height 2.0)
      (/ bsz 2.0)))
))
# clamp function
(var clamp (fn [ value min-val max-val]
  (cond
    (< value min-val) min-val
    (> value max-val) max-val
    value)))
# our update function
(var update (fn[ dt ]
  (+= bx
      (* bspeed dt xdir))
  (+= by
      (* bspeed dt ydir))
  
  # player movement
  ( if ( key-down? :up)
    (-= py (* pspeed dt)))
  ( if ( key-down? :down)
    (+= py (* pspeed dt)))
  # clamp player
  (set py (clamp py 0 (- height padh)))
  (set cpuy (clamp cpuy 0 (- height padh)))
  # cpu follow ball
  (set cpuy (/ by 2.0))
  # collisions
  # ceil floor 
  (when (<= by 0)
    (*= ydir -1))
  (when (>= by (- height bsz))
    (*= ydir -1))
  # score
  (when (<= bx 0)
    (++ cpuscore)
    (reset-ball))
  (when (>= bx (- width bsz))
    (++ pscore)
    (reset-ball))
  # paddle player collision
  (when ( = xdir -1)
    (when
      (and
        (<= bx (* 2 padw))
        (>= by py)
        (<= by (+ py padh)) )

      (set xdir 1)
    )
  )
  # paddle cpu collision
  (when ( = xdir 1)
    (when
      (and
        (>= (+ bx bsz) cpux)
        (>= by cpuy)
        (<= by (+ cpuy padh)) )

      (set xdir -1)
    )
  )
))

#(reset-ball)
# draw rect helper
(var rect (fn[ x y w h]
  (draw-rectangle 
    (math/floor (* x scale)) 
    (math/floor (* y scale)) 
    (math/floor (* w scale)) 
    (math/floor (* h scale)) 
    :white)
))

(var draw-scores (fn[]
  # player score
  (draw-text 
    (string/format "%03d" pscore)
    (math/floor (* padw scale))
    (math/floor (* 5 scale))
    50
    :gray) 
  #cpu score
  (draw-text 
    (string/format "%03d" cpuscore)
    (math/floor 
      (- 
        (* width scale)
        (* 2 padw scale)
        45))
    (math/floor (* 5 scale))
    50
    :gray)
))

# draw function
(var draw (fn[]
  # clear background
  (clear-background :dark-gray)
  # scores
  (draw-scores)
  # player
  (rect padw py padw padh)
  # cpu
  (rect cpux cpuy padw padh)
  # ball
  (rect bx by bsz bsz)
))

# This function houses the others and allows us to start with a bare minimum main loop
# For raylib we have to have begin-drawing and end-drawing to show the window so frame started out as:
# (var frame (fn[]
#   (begin-drawing)
#   (end-drawing)
# ))
# TODO move last into main loop
(var frame (fn[dt]
  (update dt)
  (begin-drawing)
  (draw)
  (end-drawing)
  # TODO break if score is too high
))
# create raylib window
(init-window (* width scale) (* height scale) title)
# random seed
(math/seedrandom (os/time))
# reset ball
(reset-ball)
# last time
(var last (os/clock))
# main loop
(while (not (window-should-close))
    # we need to use the coroutine/fiber sleep to make sure netrepl isn't blocked
    (ev/sleep 0.001)
    # delta time
    (def now (os/clock))
    (def dt (- now last))
    (set last now)
    # call our frame function
    (frame dt))
    # break at score 999
    (when 
      (or 
        (>= pscore 999) 
        (>= cpuscore 999)) 
      (break))
# close the raylib window
(close-window)

# close this server and program
(os/exit)

