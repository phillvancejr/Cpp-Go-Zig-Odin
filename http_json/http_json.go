package main

import (
	"fmt"
	"net/http"
	"encoding/json"
	"io/ioutil"
)

type Person struct {
    Name string `json:"name"`
    Eye_color string `json:"eye_color"`
}

func main() {
	resp, e := http.Get("https://swapi.dev/api/people/1")
	if e != nil {
		fmt.Println("Get error!", e)
		return
	}

	defer resp.Body.Close()

	body, e := ioutil.ReadAll(resp.Body)

	if e != nil {
		fmt.Println("Body read error!", e)
		return
	}

	luke := Person{}

	json.Unmarshal(body, &luke)
	fmt.Printf("%s has %s eyes\n", luke.Name, luke.Eye_color)
}