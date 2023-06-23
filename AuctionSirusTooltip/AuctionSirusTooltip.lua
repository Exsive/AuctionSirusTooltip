local addonName, vars = ...
local L = vars.L

AuctionSirusTooltip = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0","AceDB-2.0","AceEvent-2.0")

local addon = AuctionSirusTooltip
addon.vars = vars

local bit, math, date, string, select, table, time, tonumber, unpack, wipe, pairs, ipairs, strfind, hooksecurefunc =
      bit, math, date, string, select, table, time, tonumber, unpack, wipe, pairs, ipairs, strfind, hooksecurefunc
local IsInInstance, UnitName, UnitBuff, UnitDebuff, UnitExists, UnitGUID, GetSpellLink, GetUnitName, GetPlayerInfoByGUID, GetRealZoneText, GetNumRaidMembers, GetNumPartyMembers, IsInGuild, GetTime, UnitGroupRolesAssigned, GetPartyAssignment = 
      IsInInstance, UnitName, UnitBuff, UnitDebuff, UnitExists, UnitGUID, GetSpellLink, GetUnitName, GetPlayerInfoByGUID, GetRealZoneText, GetNumRaidMembers, GetNumPartyMembers, IsInGuild, GetTime, UnitGroupRolesAssigned, GetPartyAssignment
local COMBATLOG_OBJECT_RAIDTARGET_MASK, COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_TYPE_NPC, COMBATLOG_OBJECT_TYPE_PET, COMBATLOG_OBJECT_TYPE_GUARDIAN, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_REACTION_HOSTILE, COMBATLOG_OBJECT_AFFILIATION_OUTSIDER = 
      COMBATLOG_OBJECT_RAIDTARGET_MASK, COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_TYPE_NPC, COMBATLOG_OBJECT_TYPE_PET, COMBATLOG_OBJECT_TYPE_GUARDIAN, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_REACTION_HOSTILE, COMBATLOG_OBJECT_AFFILIATION_OUTSIDER

local AceEvent = AceLibrary("AceEvent-2.0")
local RL = AceLibrary("Roster-2.1")

local goldicon		= "|TInterface\\MoneyFrame\\UI-GoldIcon:20:20:3:1|t"
local silvericon	= "|TInterface\\MoneyFrame\\UI-SilverIcon:20:20:3:1|t"
local coppericon	= "|TInterface\\MoneyFrame\\UI-CopperIcon:20:20:3:1|t"

local function addLine(self,id,isItem)
		local p = AUCTION_PRICE_DATABASE[id]
	if isItem and p ~= nil and p ~= 0 then
        local gold = math.floor (p/10000)
        local useless = p - (gold*10000)
        local silver = math.floor (useless/100)
		if gold == 0 then
		self:AddDoubleLine("Аукцион:","|cffffffff"..silver..silvericon)
		end
		if silver == 0 then
        self:AddDoubleLine("Аукцион:","|cffffffff"..gold..goldicon)
		end
		if gold ~= 0 and silver ~= 0 then
		self:AddDoubleLine("Аукцион:","|cffffffff"..gold..goldicon.." "..silver..silvericon)
		end
	end
	self:Show()
end

hooksecurefunc("SetItemRef", function(link, ...)
	local id = tonumber(link:match("spell:(%d+)"))
	if id then addLine(ItemRefTooltip,id) end
end)

local function attachItemTooltip(self)
	local link = select(2,self:GetItem())
	if not link then return end
	local id = select(3,strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
	--print(AUCTION_PRICE_DATABASE[id])
	if id then
	addLine(self,id,true) 
	end
end

----------------------------------------------------------------------------------
function addon:OnEnable()
  self:RegisterEvent("CHAT_MSG_ADDON")
end  

AUCTION_PRICE_DATABASE = {}

function addon:CHAT_MSG_ADDON(arg1, arg2, ...)
	if arg1 == "ASMSG_AUCTION_LIST_BUCKETS_RESULT" then
	--print(arg2)
	local pricesort = string.gsub(arg2, ":%d+:%d+:%d+,", ",")
	local pricesort2 = string.gsub(pricesort, ":%d+:%d+:%d+:%d+:", ' = ')
	local price = string.gsub(pricesort2, "%d+:0:1500", "")
	--print(price)
		for s in string.gmatch(price, "[^,]+") do 
		--print(s)
		local pricesort6 = string.gsub(s, " = %d+", '')
		--print(pricesort6)
		local pricesort7 = string.gsub(s, "%d+ = ", '')
		--print(pricesort7)
        k = pricesort6
        AUCTION_PRICE_DATABASE[k] = pricesort7
		end
	end
end

----------------------------------------------------------------------------------

GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip3:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip3:HookScript("OnTooltipSetItem", attachItemTooltip)