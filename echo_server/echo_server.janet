(defn main[ & args ]
    (def server (net/listen "127.0.0.1" "8000"))
    (print "Listening on port 8000")

    (def client (net/accept server))
    (print "Client Connected!")
    (net/write client "Welcome to Janet Echo!\n")
    (while true
        (def msg (net/read client 1024))

        (if (> (length msg) 0)
            (do 
                (when (string/has-prefix? "bye" msg)
                    (print "saying goodbye!")
                    (net/write client "Good bye!\n")
                    (net/close client)
                    (break)
                )
                (prin "recieved: " msg)
                (def reply 
                    (string "echo: " msg "\n"))
                (net/write client reply)
            ) 
            # else
            (do
                (net/close client)
                (break))
        )
    )

    (print "shutting down")
    (net/close server)
)