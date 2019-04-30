package main

import (
	"fmt"
	"github.com/notexistentuser/myproject/clock"
)

// This file is compiled into a binary, into bin/ directory.
// It uses the library which is also in this workspace: clock.

// This function exists so that we can test running go compiled binary
func main() {
	// a new clock
	clockObj := clock.New(10, 30)

	// add 30 minutes
	clockObj = clockObj.Add(30)
	clockStr := clockObj.String()
	fmt.Println("Clock is:", clockStr)
}
