package dao

import (
	"errors"
	"time"

	"gno.land/p/moul/md"
	"gno.land/p/moul/mdtable"
	commondao "gno.land/p/nt/commondao"
)

type budgetPropType struct {
	dao         *commondao.CommonDAO
	budget      string
	description string
}

func (budgetPropType) Title() string {
	return "Budget Approval"
}

func (budgetPropType) VotingPeriod() time.Duration {
	v, _ := parameters.VotingPeriods.Get(paramPropTypeBudget)
	return v.(time.Duration)
}

func (p budgetPropType) Body() string {
	table := mdtable.Table{Headers: []string{"Parameter", "Value"}}
	table.Append([]string{md.Bold("DAO"), daoLink(p.dao)})
	table.Append([]string{md.Bold("Budget"), p.budget})
	table.Append([]string{md.Bold("Description"), p.description})
	return table.String()
}

func (p budgetPropType) Validate() error {
	if p.dao.IsDeleted() {
		return errors.New("DAO has been dissolved")
	}
	return nil
}

func (budgetPropType) Tally(r commondao.ReadonlyVotingRecord, m commondao.MemberSet) (bool, error) {
	if !commondao.IsQuorumReached(commondao.QuorumThreeFourths, r, m) {
		return false, commondao.ErrNoQuorum
	}

	c, success := commondao.SelectChoiceByAbsoluteMajority(r, m.Size())
	if success {
		return c == commondao.ChoiceYes, nil
	}
	return false, nil
}

func daoLink(dao *commondao.CommonDAO) string {
	return md.Link(dao.Name(), daoURL(dao.ID()))
}
