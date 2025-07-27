package dao

import (
	"time"

	"gno.land/p/demo/avl"
	"gno.land/p/moul/md"
	"gno.land/p/moul/mdtable"
	"gno.land/p/nt/commondao"
)

type paramsPropType struct {
	votingPeriods avl.Tree
}

func (paramsPropType) Title() string {
	return "Parameters Update"
}

func (paramsPropType) VotingPeriod() time.Duration {
	v, _ := parameters.VotingPeriods.Get(paramPropTypeParams)
	return v.(time.Duration)
}

func (p paramsPropType) Body() string {
	table := mdtable.Table{Headers: []string{"Parameter", "Value"}}
	p.votingPeriods.Iterate("", "", func(name string, v any) bool {
		table.Append([]string{
			md.Bold("Voting period for: " + name),
			formatDuration(v.(time.Duration)), // TODO: Use gno.land/p/jeronimoalbi/str when available
		})
		return false
	})

	return table.String()
}

func (paramsPropType) Tally(r commondao.ReadonlyVotingRecord, m commondao.MemberSet) (bool, error) {
	if !commondao.IsQuorumReached(commondao.QuorumHalf, r, m) {
		return false, commondao.ErrNoQuorum
	}

	c, success := commondao.SelectChoiceByPlurality(r)
	if success {
		return c == commondao.ChoiceYes, nil
	}
	return false, nil
}

func (p paramsPropType) Execute() error {
	p.votingPeriods.Iterate("", "", func(name string, v any) bool {
		parameters.VotingPeriods.Set(name, v)
		return false
	})
	return nil
}
