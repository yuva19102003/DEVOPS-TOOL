package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
)

func home(w http.ResponseWriter, r *http.Request) {

	backendURL := os.Getenv("BACKEND_URL")
	if backendURL == "" {
		backendURL = "http://localhost:8080/hello"
	}

	resp, err := http.Get(backendURL)
	if err != nil {
		http.Error(w, "Backend not reachable", 500)
		return
	}
	defer resp.Body.Close()

	body, _ := io.ReadAll(resp.Body)

	fmt.Fprintf(w, "Frontend received: %s", string(body))
}

func main() {
	http.HandleFunc("/", home)
	fmt.Println("Frontend running on :8081")
	http.ListenAndServe(":8081", nil)
}