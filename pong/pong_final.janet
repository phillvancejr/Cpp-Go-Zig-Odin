(use jaylib)

# constants
(def width 210)
(def height 160)
(def scale 4)
(def title "Pong Janet")

(def padw 10)
(def padh 50)
(def pspeed 100)
(def bspeed 100)

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

(defn reset-ball []
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
)
# clamp function
(defn clamp [ value min-val max-val]
  (cond
    (< value min-val) min-val
    (> value max-val) max-val
    value))

# our update function
(defn update[ dt ]
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
  # in C++
  # if (xdir == -1 and (bx <= padw * 2 and by >= py and by <= py + padh))
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
  # in C++
  # if (xdir == 1 and (bx + bsz >= cpux and by >= cpuy and by <= cpuy + padh))
  (when ( = xdir 1)
    (when
      (and
        (>= (+ bx bsz) cpux)
        (>= by cpuy)
        (<= by (+ cpuy padh)) )

      (set xdir -1)
    )
  )
)

# draw rect helper
(defn rect [ x y w h]
  (draw-rectangle 
    (math/floor (* x scale)) 
    (math/floor (* y scale)) 
    (math/floor (* w scale)) 
    (math/floor (* h scale)) 
    :white)
)

(defn draw-scores []
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
        45)
    )
    (math/floor (* 5 scale))
    50
    :gray)
)

# draw function
(defn draw[]
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
)

(defn main [&args]
  # disable raylib logging
  (set-trace-log-level :none)
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
      # delta time
      (def now (os/clock))
      (def dt (- now last))
      (set last now)

      # update
      (update dt)

      # draw
      (begin-drawing)
      (draw)
      (end-drawing)

      # break at score 999
      (when 
        (or 
          (>= pscore 999) 
          (>= cpuscore 999)) 
        (break)
      )
  )
  # close the raylib window
  (close-window)
) # end main


