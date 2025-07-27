package dao

import (
	"std"
	"strings"

	"gno.land/p/demo/ufmt"
	"gno.land/p/moul/txlink"
)

var realmLink txlink.Realm

func init() {
	realmLink = txlink.Realm(std.CurrentRealm().PkgPath())
}

func currentRealmPath() string {
	return strings.TrimPrefix(string(realmLink), std.ChainDomain())
}

func daoURL(daoID uint64) string {
	path := currentRealmPath()
	return ufmt.Sprintf("%s:%d", path, daoID)
}
