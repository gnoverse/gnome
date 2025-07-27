package dao

import (
	"gno.land/p/demo/avl"
	"gno.land/p/nt/commondao"
)

var (
	gnomeDAO   *commondao.CommonDAO
	locked     bool
	notice     string
	parameters struct {
		// VotingPeriods contains the voting period for different proposal types.
		VotingPeriods avl.Tree // string(param name) -> time.Duration
	}
)
