package main

import (
	"fmt"
	"net/http"
	"encoding/json"
	"io/ioutil"
)

type Person struct {
    Name string `json:"name"`
    // Height string `json:"height"`
    // Mass string	`json:"mass"`
    // Hair_color string `json:"hair_color"`
    // Skin_color string `json:"skin_color"`
    Eye_color string `json:"eye_color"`
    // Birth_year string `json:"birth_year"`
    // Gender string `json:"gender"`
    // Homeworld string `json:"homeworld"`
    // Films []string `json:"films"`
    // Species []string `json:"species"`
    // Vehicles []string `json:"vehicles"`
    // Starships []string `json:"starships"`
    // Created string `json:"created"`
    // Edited string `json:"edited"`
    // Url string `json:"url"`
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