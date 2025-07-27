package dao

import (
	"std"
	"strconv"
	"strings"
	"time"

	"gno.land/p/moul/md"
	pcommondao "gno.land/p/nt/commondao"

	"gno.land/r/nt/commondao"
)

const (
	maxBudgetLen      = 20
	maxDescriptionLen = 15_000
)

// Render returns Markdown to render the Gno.me Community DAO.
func Render(string) string {
	var output string
	if notice != "" {
		output += md.Blockquote(notice)
	}

	if !locked {
		rawID := strconv.FormatUint(gnomeDAO.ID(), 10)
		output += commondao.Render(rawID)

		// TODO: Render custom proposals section when rendering a DAO view?
	}

	return output
}

func CreateBudgetProposal(_ realm, daoID uint64, budget, description string) (proposalID uint64) {
	// TODO: Validate budget format (ex. AMOUNTSYMBOL: 10_000_000USD)
	budget = strings.TrimSpace(budget)
	if budget == "" {
		panic("budget is required")
	}

	if len(budget) > maxBudgetLen {
		panic("budget value is too long, max length is " + strconv.Itoa(maxBudgetLen))
	}

	description = strings.TrimSpace(description)
	if description == "" {
		panic("description is required")
	}

	if len(description) > maxDescriptionLen {
		panic("description is too long, max length is " + strconv.Itoa(maxDescriptionLen))
	}

	dao := mustGetDAO(daoID)
	caller := std.PreviousRealm().Address()
	assertIsMember(caller, dao)

	// Proposal is always created in the Council DAO whos members must approve budgets
	p, err := gnomeDAO.Propose(caller, budgetPropType{dao, budget, description})
	if err != nil {
		panic(err.Error())
	}

	return p.ID()
}

func CreateParamsUpdateProposal(
	_ realm,
	daoID uint64,
	votingPeriodBudget,
	votingPeriodLocking,
	votingPeriodParamsUpdate int,
) (proposalID uint64) {
	dao := mustGetDAO(daoID)
	caller := std.PreviousRealm().Address()
	assertIsMember(caller, dao)

	var propType paramsPropType
	if votingPeriodBudget > 0 {
		propType.votingPeriods.Set(paramPropTypeBudget, time.Duration(votingPeriodBudget)*Day)
	}
	if votingPeriodLocking > 0 {
		propType.votingPeriods.Set(paramPropTypeLocking, time.Duration(votingPeriodLocking)*Day)
	}
	if votingPeriodParamsUpdate > 0 {
		propType.votingPeriods.Set(paramPropTypeParams, time.Duration(votingPeriodParamsUpdate)*Day)
	}

	if propType.votingPeriods.Size() == 0 {
		panic("at least one parameter value must be specified")
	}

	// Proposal is always created in the Council DAO whos members must approve parameter updates
	p, err := gnomeDAO.Propose(caller, propType)
	if err != nil {
		panic(err.Error())
	}

	return p.ID()
}

func mustGetDAO(daoID uint64) *pcommondao.CommonDAO {
	dao := commondao.Get(daoID)
	if dao == nil {
		panic("DAO not found")
	}
	return dao
}

func assertIsMember(user std.Address, dao *pcommondao.CommonDAO) {
	if !dao.Members().Has(user) {
		panic("caller must be a DAO member")
	}
}
