package main

import (
	"fmt"
	"net/http"
	"os"
)

func hello(w http.ResponseWriter, r *http.Request) {
	message := os.Getenv("RESPONSE_MESSAGE")

	if message == "" {
		message = "Default Response from Go App"
	}

	fmt.Fprintf(w, message)
}

func main() {
	http.HandleFunc("/hello", hello)
	fmt.Println("Server started at :8080")
	http.ListenAndServe(":8080", nil)
}