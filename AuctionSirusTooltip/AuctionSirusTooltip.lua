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

local goldicon		= "|TInterface\\MoneyFrame\\UI-GoldIcon:15:15:3:1.7|t"
local silvericon	= "|TInterface\\MoneyFrame\\UI-SilverIcon:15:15:3:1.7|t"
local coppericon	= "|TInterface\\MoneyFrame\\UI-CopperIcon:15:15:3:1.7|t"

AUCTION_PRICE_DATABASE = {}

local UNCOMMON	= 2
local RARE		= 3
local EPIC		= 4

local WEAPON = "Оружие"
local ARMOR  = "Доспехи"


local function addLine(self,id,VendorPrice,dePriceResult,isItem)
	local p = AUCTION_PRICE_DATABASE[id]	
	if isItem and VendorPrice ~= nil and VendorPrice ~= 0 then
	    local gold = math.floor (VendorPrice/10000)
        local useless = VendorPrice - (gold*10000)
        local silver = math.floor (useless/100)
		local copper = VendorPrice - ((gold*100+silver)*100)
			if gold == 0 and silver == 0 then
			self:AddDoubleLine("Торговец:","|cffffffff"..copper..coppericon)
			end
			if gold == 0 and silver ~= 0 and copper >= 10 and copper <= 99 then
			self:AddDoubleLine("Торговец:","|cffffffff"..silver..silvericon.." "..copper..coppericon)
			end
			if gold == 0 and silver ~= 0 and copper >= 1 and copper <= 9 then
			self:AddDoubleLine("Торговец:","|cffffffff"..silver..silvericon.." ".."0"..copper..coppericon)
			end
			if gold == 0 and silver ~= 0 and copper == 0 then
			self:AddDoubleLine("Торговец:","|cffffffff"..silver..silvericon.." ".."00"..coppericon)
			end
			if gold ~= 0 and silver == 0 and copper >= 10 and copper <= 99 then
			self:AddDoubleLine("Торговец:","|cffffffff"..gold..goldicon.." ".."00"..silvericon.." "..copper..coppericon)
			end
			if gold ~= 0 and silver == 0 and copper >= 1 and copper <= 9 then
			self:AddDoubleLine("Торговец:","|cffffffff"..gold..goldicon.." ".."00"..silvericon.." ".."0"..copper..coppericon)
			end
			if gold ~= 0 and silver == 0 and copper == 0 then
			self:AddDoubleLine("Торговец:","|cffffffff"..gold..goldicon.." ".."00"..silvericon.." ".."00"..coppericon)
			end
			if gold ~= 0 and silver >= 10 and silver <= 99 and copper == 0 then
			self:AddDoubleLine("Торговец:","|cffffffff"..gold..goldicon.." "..silver..silvericon.." ".."00"..coppericon)
			end
			if gold ~= 0 and silver >= 1 and silver <= 9 and copper == 0 then
			self:AddDoubleLine("Торговец:","|cffffffff"..gold..goldicon.." ".."0"..silver..silvericon.." ".."00"..coppericon)
			end
			if gold ~= 0 and silver >= 1 and silver <= 9 and copper >= 1 and copper <= 9 then
			self:AddDoubleLine("Торговец:","|cffffffff"..gold..goldicon.." "..silver..silvericon.." "..copper..coppericon)
			end
			if gold ~= 0 and silver >= 10 and silver <= 99 and copper >= 1 and copper <= 9 then
			self:AddDoubleLine("Торговец:","|cffffffff"..gold..goldicon.." "..silver..silvericon.." "..copper..coppericon)
			end
			if gold ~= 0 and silver >= 1 and silver <= 9 and copper >= 10 and copper <= 99 then
			self:AddDoubleLine("Торговец:","|cffffffff"..gold..goldicon.." "..silver..silvericon.." "..copper..coppericon)
			end
			if gold ~= 0 and silver >= 10 and silver <= 99 and copper >= 10 and copper <= 99 then
			self:AddDoubleLine("Торговец:","|cffffffff"..gold..goldicon.." "..silver..silvericon.." "..copper..coppericon)
			end
	end	
	if isItem and p ~= nil and p ~= 0 and id then
        local gold = math.floor (p/10000)
        local useless = p - (gold*10000)
        local silver = math.floor (useless/100)
		local copper = p - ((gold*100+silver)*100)
			if gold == 0 and silver == 0 then
			self:AddDoubleLine("Аукцион:","|cffffffff"..copper..coppericon)
			end
			if gold == 0 and silver ~= 0 and copper >= 10 and copper <= 99 then
			self:AddDoubleLine("Аукцион:","|cffffffff"..silver..silvericon.." "..copper..coppericon)
			end
			if gold == 0 and silver ~= 0 and copper >= 1 and copper <= 9 then
			self:AddDoubleLine("Аукцион:","|cffffffff"..silver..silvericon.." ".."0"..copper..coppericon)
			end
			if gold == 0 and silver ~= 0 and copper == 0 then
			self:AddDoubleLine("Аукцион:","|cffffffff"..silver..silvericon.." ".."00"..coppericon)
			end
			if gold ~= 0 and silver == 0 and copper >= 10 and copper <= 99 then
			self:AddDoubleLine("Аукцион:","|cffffffff"..gold..goldicon.." ".."00"..silvericon.." "..copper..coppericon)
			end
			if gold ~= 0 and silver == 0 and copper >= 1 and copper <= 9 then
			self:AddDoubleLine("Аукцион:","|cffffffff"..gold..goldicon.." ".."00"..silvericon.." ".."0"..copper..coppericon)
			end
			if gold ~= 0 and silver == 0 and copper == 0 then
			self:AddDoubleLine("Аукцион:","|cffffffff"..gold..goldicon.." ".."00"..silvericon.." ".."00"..coppericon)
			end
			if gold ~= 0 and silver >= 10 and silver <= 99 and copper == 0 then
			self:AddDoubleLine("Аукцион:","|cffffffff"..gold..goldicon.." "..silver..silvericon.." ".."00"..coppericon)
			end
			if gold ~= 0 and silver >= 1 and silver <= 9 and copper == 0 then
			self:AddDoubleLine("Аукцион:","|cffffffff"..gold..goldicon.." ".."0"..silver..silvericon.." ".."00"..coppericon)
			end
			if gold ~= 0 and silver >= 1 and silver <= 9 and copper >= 1 and copper <= 9 then
			self:AddDoubleLine("Аукцион:","|cffffffff"..gold..goldicon.." "..silver..silvericon.." "..copper..coppericon)
			end
			if gold ~= 0 and silver >= 10 and silver <= 99 and copper >= 1 and copper <= 9 then
			self:AddDoubleLine("Аукцион:","|cffffffff"..gold..goldicon.." "..silver..silvericon.." "..copper..coppericon)
			end
			if gold ~= 0 and silver >= 1 and silver <= 9 and copper >= 10 and copper <= 99 then
			self:AddDoubleLine("Аукцион:","|cffffffff"..gold..goldicon.." "..silver..silvericon.." "..copper..coppericon)
			end
			if gold ~= 0 and silver >= 10 and silver <= 99 and copper >= 10 and copper <= 99 then
			self:AddDoubleLine("Аукцион:","|cffffffff"..gold..goldicon.." "..silver..silvericon.." "..copper..coppericon)
			end
	end
	if isItem and dePriceResult ~= nil and dePriceResult ~= 0 then
		local gold = math.floor (dePriceResult/10000)
        local useless = dePriceResult - (gold*10000)
        local silver = math.floor (useless/100)
		local copper = dePriceResult - ((gold*100+silver)*100)
			if gold == 0 and silver == 0 then
			self:AddDoubleLine("Распыление:","|cffffffff"..copper..coppericon)
			end
			if gold == 0 and silver ~= 0 and copper >= 10 and copper <= 99 then
			self:AddDoubleLine("Распыление:","|cffffffff"..silver..silvericon.." "..copper..coppericon)
			end
			if gold == 0 and silver ~= 0 and copper >= 1 and copper <= 9 then
			self:AddDoubleLine("Распыление:","|cffffffff"..silver..silvericon.." ".."0"..copper..coppericon)
			end
			if gold == 0 and silver ~= 0 and copper == 0 then
			self:AddDoubleLine("Распыление:","|cffffffff"..silver..silvericon.." ".."00"..coppericon)
			end
			if gold ~= 0 and silver == 0 and copper >= 10 and copper <= 99 then
			self:AddDoubleLine("Распыление:","|cffffffff"..gold..goldicon.." ".."00"..silvericon.." "..copper..coppericon)
			end
			if gold ~= 0 and silver == 0 and copper >= 1 and copper <= 9 then
			self:AddDoubleLine("Распыление:","|cffffffff"..gold..goldicon.." ".."00"..silvericon.." ".."0"..copper..coppericon)
			end
			if gold ~= 0 and silver == 0 and copper == 0 then
			self:AddDoubleLine("Распыление:","|cffffffff"..gold..goldicon.." ".."00"..silvericon.." ".."00"..coppericon)
			end
			if gold ~= 0 and silver >= 10 and silver <= 99 and copper == 0 then
			self:AddDoubleLine("Распыление:","|cffffffff"..gold..goldicon.." "..silver..silvericon.." ".."00"..coppericon)
			end
			if gold ~= 0 and silver >= 1 and silver <= 9 and copper == 0 then
			self:AddDoubleLine("Распыление:","|cffffffff"..gold..goldicon.." ".."0"..silver..silvericon.." ".."00"..coppericon)
			end
			if gold ~= 0 and silver >= 1 and silver <= 9 and copper >= 1 and copper <= 9 then
			self:AddDoubleLine("Распыление:","|cffffffff"..gold..goldicon.." "..silver..silvericon.." "..copper..coppericon)
			end
			if gold ~= 0 and silver >= 10 and silver <= 99 and copper >= 1 and copper <= 9 then
			self:AddDoubleLine("Распыление:","|cffffffff"..gold..goldicon.." "..silver..silvericon.." "..copper..coppericon)
			end
			if gold ~= 0 and silver >= 1 and silver <= 9 and copper >= 10 and copper <= 99 then
			self:AddDoubleLine("Распыление:","|cffffffff"..gold..goldicon.." "..silver..silvericon.." "..copper..coppericon)
			end
			if gold ~= 0 and silver >= 10 and silver <= 99 and copper >= 10 and copper <= 99 then
			self:AddDoubleLine("Распыление:","|cffffffff"..gold..goldicon.." "..silver..silvericon.." "..copper..coppericon)
			end
	end
end

hooksecurefunc("SetItemRef", function(link, ...)
	local id = tonumber(link:match("spell:(%d+)"))
	if id then addLine(ItemRefTooltip,id) end
end)

local function attachItemTooltip(self)
	local link = select(2,self:GetItem())
	if not link then return end
	local id = select(3,strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, _, _, _, _, itemVendorPrice = GetItemInfo (link);
	--print(itemRarity, itemLevel, itemMinLevel, itemType, itemVendorPrice)
	--print(AUCTION_PRICE_DATABASE[id])
	local VendorPrice = itemVendorPrice
	--print(VendorPrice)
	if id then
	addLine(self,id,VendorPrice,dePriceResult,true) 
	end
	if itemType == ARMOR or itemType == WEAPON then
		if itemRarity == UNCOMMON or itemRarity == RARE or itemRarity == EPIC then  
		--print("Надо пылить получаеца")
		calculatordePrice(self,id,itemType, itemRarity, itemLevel)
		end
	end
end

----------------------------------------------------------------------------------
function addon:OnEnable()
  self:RegisterEvent("CHAT_MSG_ADDON")
end  

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
        local k = pricesort6
        AUCTION_PRICE_DATABASE[k] = pricesort7
		end
	end
	-- if arg1 == "ASMSG_AUCTION_LIST_ITEMS_RESULT" then 
	    -- local t = GetTime()
	-- --print(arg2)
		-- for s in string.gmatch(arg2, "[^,]+") do 
		-- --print(s)
		-- local pricesort = string.gsub(s, ":%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:[йцукенгшщзхъфывапролджэячсмитьЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ%a]+:%d+:%d+:", " = ")
		-- local pricesort2 = string.gsub(pricesort, ":%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%d+:%a+:%d+:%d+:", " = ") 
		-- --local pricesort2 = string.gsub(pricesort, "1500:", "")
		-- local pricesort3 = string.gsub(pricesort2, "%d+:%d+:%d+:%d+:%d+:%d+:%d+:[йцукенгшщзхъфывапролджэячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ%a]+:%d+:%d+:%d+", "") 
		-- local pricesort4 = string.gsub(pricesort3, "%d+:%d+:%d+:%d+:%d+:%d+:%d+::%d+:%d+:%d+", "")   
		-- local pricesort5 = string.gsub(pricesort4, "1500:", "")
		-- local price = string.gsub(pricesort5, "%d+:%d+", "")
		-- if price ~= "" then
		-- print(price)
		-- local pricesort6 = string.gsub(price, " = %d+", '') 
		-- --print(pricesort6)
		-- local pricesort7 = string.gsub(price, "%d+ = ", '') 
		-- --print(pricesort7)
		-- if GetTime() - t <= 4 then
        -- local k = pricesort6
        -- AUCTION_PRICE_DATABASE[k] = pricesort7  
		-- end
		-- end
		-- end
	-- end
end

----------------------------------------------------------------------------------
--Распыление
----------------------------------------------------------------------------------
function calculatordePrice(self,id,itemType,itemRarity,itemLevel)
	--print(itemType, itemRarity, itemLevel)
	local dePrice = 0

	local LESSER_MAGIC		= AUCTION_PRICE_DATABASE["10938"]
	local GREATER_MAGIC		= AUCTION_PRICE_DATABASE["10939"]
	local STRANGE_DUST		= AUCTION_PRICE_DATABASE["10940"]

	local SMALL_GLIMMERING	= AUCTION_PRICE_DATABASE["10978"]
	local LESSER_ASTRAL		= AUCTION_PRICE_DATABASE["10998"]

	local GREATER_ASTRAL	= AUCTION_PRICE_DATABASE["11082"]
	local SOUL_DUST			= AUCTION_PRICE_DATABASE["11083"]
	local LARGE_GLIMMERING	= AUCTION_PRICE_DATABASE["11084"]

	local LESSER_MYSTIC		= AUCTION_PRICE_DATABASE["11134"]
	local GREATER_MYSTIC	= AUCTION_PRICE_DATABASE["11135"]
	local VISION_DUST		= AUCTION_PRICE_DATABASE["11137"]
	local SMALL_GLOWING		= AUCTION_PRICE_DATABASE["11138"]
	local LARGE_GLOWING		= AUCTION_PRICE_DATABASE["11139"]

	local LESSER_NETHER		= AUCTION_PRICE_DATABASE["11174"]
	local GREATER_NETHER	= AUCTION_PRICE_DATABASE["11175"]
	local DREAM_DUST		= AUCTION_PRICE_DATABASE["11176"]
	local SMALL_RADIANT		= AUCTION_PRICE_DATABASE["11177"]
	local LARGE_RADIANT		= AUCTION_PRICE_DATABASE["11178"]

	local SMALL_BRILLIANT	= AUCTION_PRICE_DATABASE["14343"]
	local LARGE_BRILLIANT	= AUCTION_PRICE_DATABASE["14344"]

	local LESSER_ETERNAL	= AUCTION_PRICE_DATABASE["16202"]
	local GREATER_ETERNAL	= AUCTION_PRICE_DATABASE["16203"]
	local ILLUSION_DUST		= AUCTION_PRICE_DATABASE["16204"]

	local NEXUS_CRYSTAL		= AUCTION_PRICE_DATABASE["20725"]

	local ARCANE_DUST		= AUCTION_PRICE_DATABASE["22445"]
	local GREATER_PLANAR	= AUCTION_PRICE_DATABASE["22446"]
	local LESSER_PLANAR		= AUCTION_PRICE_DATABASE["22447"]
	local SMALL_PRISMATIC	= AUCTION_PRICE_DATABASE["22448"]
	local LARGE_PRISMATIC	= AUCTION_PRICE_DATABASE["22449"]
	local VOID_CRYSTAL		= AUCTION_PRICE_DATABASE["22450"]

	local DREAM_SHARD		= AUCTION_PRICE_DATABASE["34052"]
	local SMALL_DREAM		= AUCTION_PRICE_DATABASE["34053"]

	local INFINITE_DUST		= AUCTION_PRICE_DATABASE["34054"]
	local GREATER_COSMIC	= AUCTION_PRICE_DATABASE["34055"]
	local LESSER_COSMIC		= AUCTION_PRICE_DATABASE["34056"]
	local ABYSS_CRYSTAL		= AUCTION_PRICE_DATABASE["34057"]

	if itemType == ARMOR and itemRarity == UNCOMMON then
		if itemLevel >= 5 and itemLevel <= 15 then
			if STRANGE_DUST ~= nil and LESSER_MAGIC ~= nil then
			local dePrice = (STRANGE_DUST/100*40*1)+(STRANGE_DUST/100*40*2)+(LESSER_MAGIC/100*10*1)+(LESSER_MAGIC/100*10*2)	
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 16 and itemLevel <= 20 then	
			if STRANGE_DUST ~= nil and GREATER_MAGIC ~= nil and SMALL_GLIMMERING ~= nil then
			local dePrice = (STRANGE_DUST/100*37.5*2)+(STRANGE_DUST/100*37.5*3)+(GREATER_MAGIC/100*10*1)+(GREATER_MAGIC/100*10*2)+(SMALL_GLIMMERING/100*5*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 21 and itemLevel <= 25 then
			if STRANGE_DUST ~= nil and GREATER_MAGIC ~= nil and SMALL_GLIMMERING ~= nil then		
			local dePrice = (STRANGE_DUST/100*25*4)+(STRANGE_DUST/100*25*5)+(STRANGE_DUST/100*25*6)+(GREATER_MAGIC/100*7.5*1)+(GREATER_MAGIC/100*7.5*2)+(SMALL_GLIMMERING/100*10*1)	
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 26 and itemLevel <= 30 then	
			if SOUL_DUST ~= nil and GREATER_ASTRAL ~= nil and LARGE_GLIMMERING ~= nil then		
			local dePrice = (SOUL_DUST/100*37.5*1)+(SOUL_DUST/100*37.5*2)+(GREATER_ASTRAL/100*10*1)+(GREATER_ASTRAL/100*10*2)+(LARGE_GLIMMERING/100*2.5*1)
			sortdePrice(self,dePrice)
			end			
		elseif itemLevel >= 31 and itemLevel <= 35 then	
			if SOUL_DUST ~= nil and LESSER_MYSTIC ~= nil and SMALL_GLOWING ~= nil then	
			local dePrice = (SOUL_DUST/100*18.75*2)+(SOUL_DUST/100*18.75*3)+(SOUL_DUST/100*18.75*4)+(SOUL_DUST/100*18.75*5)+(LESSER_MYSTIC/100*10*1)+(LESSER_MYSTIC/100*10*2)+(SMALL_GLOWING/100*5*1)	
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 36 and itemLevel <= 40 then	
			if VISION_DUST ~= nil and GREATER_MYSTIC ~= nil and LARGE_GLOWING ~= nil then	
			local dePrice = (VISION_DUST/100*37.5*1)+(VISION_DUST/100*37.5*2)+(GREATER_MYSTIC/100*10*1)+(GREATER_MYSTIC/100*10*2)+(LARGE_GLOWING/100*5*1)	
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 41 and itemLevel <= 45 then	
			if VISION_DUST ~= nil and LESSER_NETHER ~= nil and SMALL_RADIANT ~= nil then	
			local dePrice = (VISION_DUST/100*18.75*2)+(VISION_DUST/100*18.75*3)+(VISION_DUST/100*18.75*4)+(VISION_DUST/100*18.75*5)+(LESSER_NETHER/100*10*1)+(LESSER_NETHER/100*10*2)+(SMALL_RADIANT/100*5*1)	
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 46 and itemLevel <= 50 then	
			if DREAM_DUST ~= nil and GREATER_NETHER ~= nil and LARGE_RADIANT ~= nil then
			local dePrice = (DREAM_DUST/100*37.5*1)+(DREAM_DUST/100*37.5*2)+(GREATER_NETHER/100*10*1)+(GREATER_NETHER/100*10*2)+(LARGE_RADIANT/100*5*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 51 and itemLevel <= 55 then	
			if DREAM_DUST ~= nil and LESSER_ETERNAL ~= nil and SMALL_BRILLIANT ~= nil then
			local dePrice = (DREAM_DUST/100*18.75*2)+(DREAM_DUST/100*18.75*3)+(DREAM_DUST/100*18.75*4)+(DREAM_DUST/100*18.75*5)+(LESSER_ETERNAL/100*10*1)+(LESSER_ETERNAL/100*10*2)+(SMALL_BRILLIANT/100*5*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 56 and itemLevel <= 60 then	
			if ILLUSION_DUST ~= nil and GREATER_ETERNAL ~= nil and LARGE_BRILLIANT ~= nil then
			local dePrice = (ILLUSION_DUST/100*37.5*1)+(ILLUSION_DUST/100*37.5*2)+(GREATER_ETERNAL/100*10*1)+(GREATER_ETERNAL/100*10*2)+(LARGE_BRILLIANT/100*5*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 61 and itemLevel <= 65 then	
			if ILLUSION_DUST ~= nil and GREATER_ETERNAL ~= nil and LARGE_BRILLIANT ~= nil then
			local dePrice = (ILLUSION_DUST/100*18.75*2)+(ILLUSION_DUST/100*18.75*3)+(ILLUSION_DUST/100*18.75*4)+(ILLUSION_DUST/100*18.75*5)+(GREATER_ETERNAL/100*10*2)+(GREATER_ETERNAL/100*10*3)+(LARGE_BRILLIANT/100*5*1)	
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 66 and itemLevel <= 80 then	
			if ARCANE_DUST ~= nil and LESSER_PLANAR ~= nil and SMALL_PRISMATIC ~= nil then
			local dePrice = (ARCANE_DUST/100*25*1)+(ARCANE_DUST/100*25*2)+(ARCANE_DUST/100*25*3)+(LESSER_PLANAR/100*7.33*1)+(LESSER_PLANAR/100*7.33*2)+(LESSER_PLANAR/100*7.33*3)+(SMALL_PRISMATIC/100*3*1)	
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 81 and itemLevel <= 99 then	
			if ARCANE_DUST ~= nil and LESSER_PLANAR ~= nil and SMALL_PRISMATIC ~= nil then
			local dePrice = (ARCANE_DUST/100*37.5*2)+(ARCANE_DUST/100*37.5*3)+(LESSER_PLANAR/100*11*1)+(LESSER_PLANAR/100*11*2)+(SMALL_PRISMATIC/100*3*1)	
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 100 and itemLevel <= 120 then	
			if ARCANE_DUST ~= nil and GREATER_PLANAR ~= nil and LARGE_PRISMATIC ~= nil then
			local dePrice = (ARCANE_DUST/100*18.75*2)+(ARCANE_DUST/100*18.75*3)+(ARCANE_DUST/100*18.75*4)+(ARCANE_DUST/100*18.75*5)+(GREATER_PLANAR/100*11*1)+(GREATER_PLANAR/100*11*2)+(LARGE_PRISMATIC/100*3*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 121 and itemLevel <= 151 then	
			if INFINITE_DUST ~= nil and LESSER_COSMIC ~= nil and SMALL_DREAM ~= nil then
			local dePrice = (INFINITE_DUST/100*25*1)+(INFINITE_DUST/100*25*2)+(INFINITE_DUST/100*25*3)+(LESSER_COSMIC/100*11*1)+(LESSER_COSMIC/100*11*2)+(SMALL_DREAM/100*3*1)	
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 152 and itemLevel <= 200 then	
			if INFINITE_DUST ~= nil and GREATER_COSMIC ~= nil and DREAM_SHARD ~= nil then
			local dePrice = (INFINITE_DUST/100*18.75*4)+(INFINITE_DUST/100*18.75*5)+(INFINITE_DUST/100*18.75*6)+(INFINITE_DUST/100*18.75*7)+(GREATER_COSMIC/100*11*1)+(GREATER_COSMIC/100*11*2)+(DREAM_SHARD/100*3*1)
			sortdePrice(self,dePrice)
			end
		end
	elseif itemType == WEAPON and itemRarity == UNCOMMON then
		if itemLevel >= 6 and itemLevel <= 15 then
			if STRANGE_DUST ~= nil and LESSER_MAGIC ~= nil then
			local dePrice = (STRANGE_DUST/100*10*1)+(STRANGE_DUST/100*10*2)+(LESSER_MAGIC/100*40*1)+(LESSER_MAGIC/100*40*2)	
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 16 and itemLevel <= 20 then	
			if STRANGE_DUST ~= nil and GREATER_MAGIC ~= nil and SMALL_GLIMMERING ~= nil then
			local dePrice = (STRANGE_DUST/100*10*2)+(STRANGE_DUST/100*10*3)+(GREATER_MAGIC/100*37.5*1)+(GREATER_MAGIC/100*37.5*2)+(SMALL_GLIMMERING/100*5*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 21 and itemLevel <= 25 then	
			if STRANGE_DUST ~= nil and LESSER_ASTRAL ~= nil and SMALL_GLIMMERING ~= nil then
			local dePrice = (STRANGE_DUST/100*5*4)+(STRANGE_DUST/100*5*5)+(STRANGE_DUST/100*5*6)+(LESSER_ASTRAL/100*37.5*1)+(LESSER_ASTRAL/100*37.5*2)+(SMALL_GLIMMERING/100*10*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 26 and itemLevel <= 30 then	
			if SOUL_DUST ~= nil and GREATER_ASTRAL ~= nil and LARGE_GLIMMERING ~= nil then
			local dePrice = (SOUL_DUST/100*10*1)+(SOUL_DUST/100*10*2)+(GREATER_ASTRAL/100*37.5*1)+(GREATER_ASTRAL/100*37.5*2)+(LARGE_GLIMMERING/100*5*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 31 and itemLevel <= 35 then	
			if SOUL_DUST ~= nil and LESSER_MYSTIC ~= nil and SMALL_GLOWING ~= nil then
			local dePrice = (SOUL_DUST/100*5*1)+(SOUL_DUST/100*5*2)+(SOUL_DUST/100*5*3)+(SOUL_DUST/100*5*4)+(LESSER_MYSTIC/100*37.5*1)+(LESSER_MYSTIC/100*37.5*2)+(SMALL_GLOWING/100*5*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 36 and itemLevel <= 40 then	
			if VISION_DUST ~= nil and GREATER_MYSTIC ~= nil and LARGE_GLOWING ~= nil then
			local dePrice = (VISION_DUST/100*10*1)+(VISION_DUST/100*10*2)+(GREATER_MYSTIC/100*37.5*1)+(GREATER_MYSTIC/100*37.5*2)+(LARGE_GLOWING/100*5*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 41 and itemLevel <= 45 then	
			if VISION_DUST ~= nil and LESSER_NETHER ~= nil and SMALL_RADIANT ~= nil then
			local dePrice = (VISION_DUST/100*5*2)+(VISION_DUST/100*5*3)+(VISION_DUST/100*5*4)+(VISION_DUST/100*5*5)+(LESSER_NETHER/100*37.5*1)+(LESSER_NETHER/100*37.5*2)+(SMALL_RADIANT/100*5*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 46 and itemLevel <= 50 then	
			if DREAM_DUST ~= nil and GREATER_NETHER ~= nil and LARGE_RADIANT ~= nil then
			local dePrice = (DREAM_DUST/100*10*1)+(DREAM_DUST/100*10*2)+(GREATER_NETHER/100*37.5*1)+(GREATER_NETHER/100*37.5*2)+(LARGE_RADIANT/100*5*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 51 and itemLevel <= 55 then	
			if DREAM_DUST ~= nil and LESSER_ETERNAL ~= nil and SMALL_BRILLIANT ~= nil then
			local dePrice = (DREAM_DUST/100*5.5*2)+(DREAM_DUST/100*5.5*3)+(DREAM_DUST/100*5.5*4)+(DREAM_DUST/100*5.5*5)+(LESSER_ETERNAL/100*37.5*1)+(LESSER_ETERNAL/100*37.5*2)+(SMALL_BRILLIANT/100*5*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 56 and itemLevel <= 60 then	
			if ILLUSION_DUST ~= nil and GREATER_ETERNAL ~= nil and LARGE_BRILLIANT ~= nil then
			local dePrice = (ILLUSION_DUST/100*11*1)+(ILLUSION_DUST/100*11*2)+(GREATER_ETERNAL/100*37.5*1)+(GREATER_ETERNAL/100*37.5*2)+(LARGE_BRILLIANT/100*5*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 61 and itemLevel <= 65 then	
			if ILLUSION_DUST ~= nil and GREATER_ETERNAL ~= nil and LARGE_BRILLIANT ~= nil then
			local dePrice = (ILLUSION_DUST/100*5.5*2)+(ILLUSION_DUST/100*5.5*3)+(ILLUSION_DUST/100*5.5*4)+(ILLUSION_DUST/100*5.5*5)+(GREATER_ETERNAL/100*37.5*2)+(GREATER_ETERNAL/100*37.5*3)+(LARGE_BRILLIANT/100*5*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 66 and itemLevel <= 99 then	
			if ARCANE_DUST ~= nil and LESSER_PLANAR ~= nil and SMALL_PRISMATIC ~= nil then
			local dePrice = (ARCANE_DUST/100*11*2)+(ARCANE_DUST/100*11*3)+(LESSER_PLANAR/100*37.5*2)+(LESSER_PLANAR/100*37.5*3)+(SMALL_PRISMATIC/100*3*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 100 and itemLevel <= 120 then	
			if ARCANE_DUST ~= nil and GREATER_PLANAR ~= nil and LARGE_PRISMATIC ~= nil then
			local dePrice = (ARCANE_DUST/100*5.5*2)+(ARCANE_DUST/100*5.5*3)+(ARCANE_DUST/100*5.5*4)+(ARCANE_DUST/100*5.5*5)+(GREATER_PLANAR/100*37.5*1)+(GREATER_PLANAR/100*37.5*2)+(LARGE_PRISMATIC/100*3*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 121 and itemLevel <= 151 then	
			if INFINITE_DUST ~= nil and LESSER_COSMIC ~= nil and SMALL_DREAM ~= nil then
			local dePrice = (INFINITE_DUST/100*7.33*1)+(INFINITE_DUST/100*7.33*2)+(INFINITE_DUST/100*7.33*3)+(LESSER_COSMIC/100*37.5*1)+(LESSER_COSMIC/100*37.5*2)+(SMALL_DREAM/100*3*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 152 and itemLevel <= 200 then	
			if INFINITE_DUST ~= nil and GREATER_COSMIC ~= nil and DREAM_SHARD ~= nil then
			local dePrice = (INFINITE_DUST/100*5.5*4)+(INFINITE_DUST/100*5.5*5)+(INFINITE_DUST/100*5.5*6)+(INFINITE_DUST/100*5.5*7)+(GREATER_COSMIC/100*37.5*1)+(GREATER_COSMIC/100*37.5*2)+(DREAM_SHARD/100*3*1)		
			sortdePrice(self,dePrice)
			end
		end
	elseif itemRarity == RARE and (itemType == WEAPON or itemType == ARMOR) then
		if itemLevel >= 11 and itemLevel <= 25 then
			if SMALL_GLIMMERING ~= nil then
			local dePrice = (SMALL_GLIMMERING/100*100*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 26 and itemLevel <= 30 then	
			if LARGE_GLIMMERING ~= nil then
			local dePrice = (LARGE_GLIMMERING/100*100*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 31 and itemLevel <= 35 then	
			if SMALL_GLOWING ~= nil then
			local dePrice = (SMALL_GLOWING/100*100*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 36 and itemLevel <= 40 then	
			if LARGE_GLOWING ~= nil then
			local dePrice = (LARGE_GLOWING/100*100*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 41 and itemLevel <= 45 then	
			if SMALL_RADIANT ~= nil then
			local dePrice = (SMALL_RADIANT/100*100*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 46 and itemLevel <= 50 then	
			if LARGE_RADIANT ~= nil then
			local dePrice = (LARGE_RADIANT/100*100*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 51 and itemLevel <= 55 then	
			if SMALL_BRILLIANT ~= nil then
			local dePrice = (SMALL_BRILLIANT/100*100*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 56 and itemLevel <= 65 then	
			if LARGE_BRILLIANT ~= nil and NEXUS_CRYSTAL ~= nil then
			local dePrice = (LARGE_BRILLIANT/100*99.5*1)+(NEXUS_CRYSTAL/100*0.5*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 66 and itemLevel <= 99 then	
			if SMALL_PRISMATIC ~= nil and NEXUS_CRYSTAL ~= nil then
			local dePrice = (SMALL_PRISMATIC/100*99.5*1)+(NEXUS_CRYSTAL/100*0.5*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 100 and itemLevel <= 120 then	
			if LARGE_PRISMATIC ~= nil and VOID_CRYSTAL ~= nil then
			local dePrice = (LARGE_PRISMATIC/100*99.5*1)+(VOID_CRYSTAL/100*0.5*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 121 and itemLevel <= 164 then	
			if SMALL_DREAM ~= nil and ABYSS_CRYSTAL ~= nil then
			local dePrice = (SMALL_DREAM/100*99.5*1)+(ABYSS_CRYSTAL/100*0.5*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 165 and itemLevel <= 999 then	
			if DREAM_SHARD ~= nil and ABYSS_CRYSTAL ~= nil then
			local dePrice = (DREAM_SHARD/100*99.5*1)+(ABYSS_CRYSTAL/100*0.5*1)		
			sortdePrice(self,dePrice)
			end
		end		
	elseif itemRarity == EPIC and (itemType == WEAPON or itemType == ARMOR) then
		if itemLevel >= 40 and itemLevel <= 45 then
			if SMALL_RADIANT ~= nil then
			local dePrice = (SMALL_RADIANT/100*33.33*2)+(SMALL_RADIANT/100*33.33*3)+(SMALL_RADIANT/100*33.33*4)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 46 and itemLevel <= 50 then
			if LARGE_RADIANT ~= nil then
			local dePrice = (LARGE_RADIANT/100*33.33*2)+(LARGE_RADIANT/100*33.33*3)+(LARGE_RADIANT/100*33.33*4)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 51 and itemLevel <= 55 then
			if SMALL_BRILLIANT ~= nil then
			local dePrice = (SMALL_BRILLIANT/100*33.33*2)+(SMALL_BRILLIANT/100*33.33*3)+(SMALL_BRILLIANT/100*33.33*4)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 56 and itemLevel <= 60 then
			if NEXUS_CRYSTAL ~= nil then
			local dePrice = (NEXUS_CRYSTAL/100*100*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 61 and itemLevel <= 80 and itemType == WEAPON then
			if NEXUS_CRYSTAL ~= nil then
			local dePrice = (NEXUS_CRYSTAL/100*33.33*2)+(NEXUS_CRYSTAL/100*66.66*2)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 61 and itemLevel <= 80 and itemType == ARMOR then
			if NEXUS_CRYSTAL ~= nil then
			local dePrice = (NEXUS_CRYSTAL/100*50*1)+(NEXUS_CRYSTAL/100*50*2)		
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 95 and itemLevel <= 100 then
			if VOID_CRYSTAL ~= nil then
			local dePrice = (VOID_CRYSTAL/100*50*1)+(VOID_CRYSTAL/100*50*2)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 105 and itemLevel <= 164 then
			if VOID_CRYSTAL ~= nil then
			local dePrice = (VOID_CRYSTAL/100*33.3*1)+(VOID_CRYSTAL/100*66.6*2)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 165 and itemLevel <= 200 then
			if ABYSS_CRYSTAL ~= nil then
			local dePrice = (ABYSS_CRYSTAL/100*100*1)
			sortdePrice(self,dePrice)
			end
		elseif itemLevel >= 200 and itemLevel <= 999 then
			if ABYSS_CRYSTAL ~= nil then
			local dePrice = (ABYSS_CRYSTAL/100*100*1)	
			sortdePrice(self,dePrice)
			end
		end
	end
end

function sortdePrice(self,dePrice)
	local dePriceResult = math.floor(dePrice)
	if dePriceResult then
	addLine(self,id,VendorPrice,dePriceResult,true) 
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