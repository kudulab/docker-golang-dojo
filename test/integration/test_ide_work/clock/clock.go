package clock

import (
	"fmt"
)

const testVersion = 4

// let's keep timestamp here, number of seconds since Unix Epoch
type Clock int

func New(hour, minute int) Clock {
	time := (hour*60 + minute) % (60 * 24)
	if time < 0 {
		time += 60 * 24
	}
	return Clock(time)
}

func (c Clock) String() string {
	// ensure 2 digits are returned for hours and for minutes
	return fmt.Sprintf("%02d:%02d", c/60, c%60)
}

func (c Clock) Add(minutes int) Clock {
	return New(0, int(c) + minutes)
}
