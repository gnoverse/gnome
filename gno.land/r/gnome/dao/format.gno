package dao

import (
	"math"
	"time"

	"gno.land/p/demo/ufmt"
)

func formatDuration(d time.Duration) string {
	if d == 0 {
		return ""
	}

	if sec := d.Seconds(); sec < 60 {
		return ufmt.Sprintf("%d seconds", int(sec))
	}

	if m := d.Minutes(); m < 60 {
		sec := math.Mod(d.Seconds(), 60)
		if sec < 1 {
			return ufmt.Sprintf("%d minutes", int(m))
		}
		return ufmt.Sprintf("%d minutes %d seconds", int(m), int(sec))
	}

	if hs := d.Hours(); hs < 24 {
		m := math.Mod(d.Minutes(), 60)
		if m < 1 {
			return ufmt.Sprintf("%d hours", int(hs))
		}

		sec := math.Mod(d.Seconds(), 60)
		if sec < 1 {
			return ufmt.Sprintf("%d hours %d minutes", int(hs), int(m))
		}
		return ufmt.Sprintf("%d hours %d minutes %d seconds", int(hs), int(m), int(sec))
	}

	days := d.Hours() / 24
	hs := math.Mod(d.Hours(), 24)
	if hs < 1 {
		return ufmt.Sprintf("%d days", int(days))
	}

	m := math.Mod(d.Minutes(), 60)
	if m < 0 {
		return ufmt.Sprintf("%d days %d hours", int(days), int(hs))
	}

	sec := math.Mod(d.Seconds(), 60)
	if sec < 1 {
		return ufmt.Sprintf("%d days %d hours %d minutes", int(days), int(hs), int(m))
	}
	return ufmt.Sprintf("%d days %d hours %d minutes %d seconds", int(days), int(hs), int(m), int(sec))
}
