
(defn attack [ w1 w2 ]
    (-= (w2 :hp) (w1 :dmg))
    (printf "%s attacked %s for %d damage!" 
        (w1 :name)
        (w2 :name)
        (w1 :dmg )))

(defn display [w]
    (printf "%s hp %d"
        (w :name)
        (w :hp)))

(defn main[ &args ]
    (def grog @{
        :name "Grog"
        :hp 100
        :dmg 10
    })
    (def bork @{
        :name "Bork"
        :hp 100
        :dmg 10
    })
    # seed
    (math/seedrandom (os/time))
    (while 
        (and 
            (> (grog :hp) 0) 
            (> (bork :hp) 0))
        
        (def i (math/round (math/random)))
        (def [ w1 w2 ]
            (if (= 0 i)
                [ grog bork ]
                [ bork grog ])) 

        (attack w1 w2)
        (print "")
        (display w1)
        (display w2)
        (print ""))
    
    (def [ winner loser ]
        (if (> (grog :hp) 0)
            [ grog bork]
            [ bork grog]))
    
    (printf "%s defeated %s!" (winner :name) (loser :name))
)