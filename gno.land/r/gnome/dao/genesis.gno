package dao

import (
	"time"

	"gno.land/r/nt/commondao"
)

// TODO: Add DAO descriptions when supported by CommonDAO
// TODO: Add proposal review deadline parameter when supported by CommonDAO
// TODO: Group members by role when supported, see gnolang/gno#4287

const Day = time.Hour * 24

const (
	paramPropTypeBudget  = "budget-approval"
	paramPropTypeLocking = "realm-locking"
	paramPropTypeParams  = "params-update"
)

func init() {
	// Configure initial realm parameter values
	initParams()

	// Initialize genesis Gno.me community DAO tree
	//
	// Gnome DAO
	// └── Ecosystem
	//     ├── Space
	//     └── Community
	//         └── Tutorials
	initDAO()
}

func initDAO() {
	gnomeDAO = commondao.New("Gnome DAO")
	gnomeDAO.Members().Add("g1hy6zry03hg5d8le9s2w4fxme6236hkgd928dun")
	gnomeDAO.Members().Add("g1778y2yphxs2wpuaflsy5y9qwcd4gttn4g5yjx5")
	options := configureDAO(gnomeDAO.ID())
	options.SetAllowListing(true)

	ecosystemDAO := commondao.NewSubDAO("Ecosystem", gnomeDAO.ID())
	ecosystemDAO.Members().Add("g1hy6zry03hg5d8le9s2w4fxme6236hkgd928dun")
	ecosystemDAO.Members().Add("g1778y2yphxs2wpuaflsy5y9qwcd4gttn4g5yjx5")
	ecosystemDAO.Members().Add("g1lavlav7zwsjqlzzl3qdl3nl242qtf638vnhdjh")
	configureDAO(ecosystemDAO.ID())

	spaceDAO := commondao.NewSubDAO("Gnome Space", ecosystemDAO.ID())
	spaceDAO.Members().Add("g1hy6zry03hg5d8le9s2w4fxme6236hkgd928dun")
	spaceDAO.Members().Add("g1778y2yphxs2wpuaflsy5y9qwcd4gttn4g5yjx5")
	spaceDAO.Members().Add("g18cwpdpsqd8mywj8skpsqsg9tn9hudkkpa6ycpe")
	spaceDAO.Members().Add("g1lavlav7zwsjqlzzl3qdl3nl242qtf638vnhdjh")
	configureDAO(spaceDAO.ID())

	communityDAO := commondao.NewSubDAO("Community", ecosystemDAO.ID())
	communityDAO.Members().Add("g1hy6zry03hg5d8le9s2w4fxme6236hkgd928dun")
	communityDAO.Members().Add("g1778y2yphxs2wpuaflsy5y9qwcd4gttn4g5yjx5")
	communityDAO.Members().Add("g1lavlav7zwsjqlzzl3qdl3nl242qtf638vnhdjh")
	communityDAO.Members().Add("g1dnllrdzwfhxv3evyk09y48mgn5phfjvtyrlzm7")
	configureDAO(communityDAO.ID())

	tutorialsDAO := commondao.NewSubDAO("Tutorials", communityDAO.ID())
	tutorialsDAO.Members().Add("g1hy6zry03hg5d8le9s2w4fxme6236hkgd928dun")
	tutorialsDAO.Members().Add("g1778y2yphxs2wpuaflsy5y9qwcd4gttn4g5yjx5")
	tutorialsDAO.Members().Add("g1lavlav7zwsjqlzzl3qdl3nl242qtf638vnhdjh")
	tutorialsDAO.Members().Add("g1dnllrdzwfhxv3evyk09y48mgn5phfjvtyrlzm7")
	configureDAO(tutorialsDAO.ID())
}

func initParams() {
	parameters.VotingPeriods.Set(paramPropTypeBudget, Day*7)
	parameters.VotingPeriods.Set(paramPropTypeLocking, Day*2)
	parameters.VotingPeriods.Set(paramPropTypeParams, Day)
}

func configureDAO(daoID uint64) *commondao.Options {
	// TODO: Allow CommonDAO proposals too
	options := commondao.GetOptions(daoID)
	options.SetAllowRender(true)
	options.SetAllowVoting(true)
	options.SetAllowChildren(true)
	options.SetAllowExecution(true)
	return options
}
