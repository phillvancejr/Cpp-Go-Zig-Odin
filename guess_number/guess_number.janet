(def num 
    (let [rng (math/rng (os/time))]
        (+ 1 (math/rng-int rng 5))))
(var guesses 1)
(var guess 
    (scan-number (string/trimr (getline "guess 1 - 5: "))))
(while (not= guess num)
    (if (< guess num)
        (print "guess higher!")
        (print "guess lower!"))
    (set guess 
        (scan-number (string/trimr (getline "" ))))
    (++ guesses))

(printf "you got it in %d tries" guesses)

