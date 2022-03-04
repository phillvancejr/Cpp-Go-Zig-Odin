(import spork/netrepl)
(netrepl/server "127.0.0.1" "9365" (fiber/getenv (fiber/current)))
(setdyn :redef true)

(def width 20)
(def height width)
(def max-iterations 10_000)
(def iterations-per-second 3)
(def board (array/new-filled 
             (* width height)
             :white))

(def left   0)
(def up     1)
(def right  2)
(def down   3)

# start in center
(var ant-x (/ width 2))
(var ant-y (/ height 2))
(var ant-dir up)
(var current-move 0)

# drawing characters
# use unicode shapes?
(def shapes false)

(def draw @{
  :white  (if shapes 
            "\x1b[0m\u2588"
            ".")
  :black  (if shapes
            "\x1b[30m\u2588\x1b[0m"
            "#")
  :background @{
                :white "\x1b[47m"
                :black "\x1b[40m"
              }
  left    (if shapes
            "\u25c0"
            "<")
  up      (if shapes
            "\u25b2"
            "A")
  right   (if shapes
            "\u25b6"
            ">")
  down    (if shapes
            "\u25bc"
            "V")
})

(defn turn-right
  [dir]
  (if (= dir down)
    left
    # else
    (+ dir 1)
  )
)

(defn turn-left
  [dir]
  (if (= dir left)
    down
    # else
    (- dir 1)
  )
)

(defn move
  "returns modified x and y in tuple, should be destructured"
  [ ant-x ant-y ant-dir ]
  (var result-x ant-x)
  (var result-y ant-y)
  (match ant-dir
    ( @ left  ) (-- result-x)
    ( @ up    ) (-- result-y)
    ( @ right ) (++ result-x)
    ( @ down  ) (++ result-y)
  )
  [ result-x result-y ]
)

(defn wrap
  [n]
  (if (>= n width)
    0
  #else if 
  (if (<= n 0) 
    (- width 1)
  #else
    n
  ))
)

(defn red
  [set index]
  (def color 
    (if (= (board index) :white)
      :black
      :white))
  (def background
    (if shapes
      ((draw :background) color)
    #else
      ""
    )
  )
  (if set 
    (prin "\x1b[31m" background)
    #else
    (prin "\x1b[0m"))
)

(defn clear-screen
  []
  (prin "\x1b[1J")
)

(defn reset-cursor
  []
  (prin "\x1b[1;1H")
)



(defn draw-board
  []
  #(clear-screen)
  (reset-cursor)
  (printf "\nmove: %d\n" (++ current-move))
  (for y 0 height
    (for x 0 width
      (def index (+ (* y width) x))
      (if (and (= y ant-y) (= x ant-x))
        (do
          (red true index)
          (prin (draw ant-dir))
          (red false index))
      #else
        (prin (draw (board index)))
      ) # end if
    ) # end for x
    # newline
    (print "")
  ) # end for y

  # delay
  (ev/sleep (/ 1 iterations-per-second))
)


(defn update-loop
  []
  (def pos (+ (* ant-y width) ant-x))
  (if ( = (board pos) :white)
    (do
      (set ant-dir (turn-right ant-dir))
      (put board pos :black)
    )
  #else
    (do
      (set ant-dir (turn-left ant-dir))
      (put board pos :white) 
    )
  )
  (print "")
  (def [ new-x new-y ] (move ant-x ant-y ant-dir))
  (set ant-x (wrap new-x))
  (set ant-y (wrap new-y))
  (draw-board)
)

(defn main
  [ & args]
 (while true
   (ev/sleep 0.001)
   (update-loop)
 )  
)
