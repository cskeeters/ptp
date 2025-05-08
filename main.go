package main

import (
	"fmt"
	"runtime/debug"
)

func main() {
	defer func() {
		if err := recover(); err != nil {
			fmt.Println("panic occurred:", err)
			// This will include the trace of the original panic
			fmt.Println(string(debug.Stack()))
		}
	}()
	fmt.Println("hello world")
}
