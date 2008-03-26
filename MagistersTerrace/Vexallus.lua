﻿------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Vexallus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local pName = UnitName("player")
local fmt = string.format
local db = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Vexallus",

	adds = "Pure Energy",
	adds_desc = "Warn when Pure Energy is discharged",
	adds_message = "Pure Energy discharged!",
	adds_trigger = "discharges pure energy!",

	feedback = "Energy Feedback",
	feedback_desc = "Warn when someone gets the Energy Feedback debuff",
	feedback_you = "Energy Feedback on YOU!",
	feedback_other = "Energy Feedback on %s!",
} end )

--[[
	Magister's Terrace modules are PTR beta, as so localization is not
	supported in any way. This gives the authors the freedom to change the
	modules in way that	can potentially break localization.  Feel free to
	localize, just be aware that you may need to change it frequently.
]]--

L:RegisterTranslations("koKR", function() return {
	adds = "순수한 마력덩어리",
	adds_desc = "순수한 마력덩어리 방출에 대해 알립니다.",
	adds_message = "순수한 마력덩어리 방출!",
	adds_trigger = "순수한 마력덩어리를 방출합니다!",

	feedback = "에너지 역류",
	feedback_desc = "에너지 역류 디버프가 걸린 플레이어를 알립니다.",
	feedback_you = "당신은 에너지 역류!",
	feedback_other = "에너지 역류: %s!",
} end )

L:RegisterTranslations("frFR", function() return {
	adds = "Energie pure",
	adds_desc = "Préviens quand l'Energie pure est déchargée.",
	adds_message = "Energie pure déchargée !",
	adds_trigger = "discharges pure energy!", -- à traduire

	feedback = "Réaction énergétique",
	feedback_desc = "Préviens quand un joueur subit les effets de la Réaction énergétique.",
	feedback_you = "Réaction énergétique sur VOUS !",
	feedback_other = "Réaction énergétique sur %s !",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.partyContent = true
mod.zonename = BZ["Magisters' Terrace"]
mod.enabletrigger = boss 
mod.toggleoptions = {"adds","feedback","bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE","AddSpawned")

	self:AddCombatListener("SPELL_AURA_APPLIED", "Feedback", 44335)
	self:AddCombatListener("SPELL_AURA_REMOVED", "FeedbackRemove", 44335)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:AddSpawned(msg)
	if db.adds and msg:find(L["adds_trigger"]) then
		self:Message(L["adds_message"], "Important")
	end
end

function mod:Feedback(player, spellID)
	if db.feedback then
		local other = fmt(L["feedback_other"], player)
		if player == pName then
			self:Message(L["feedback_you"], "Personal", true, "Alert", nil, spellID)
			self:Message(other, "Attention", nil, nil, true)
		else
			self:Message(other, "Attention", nil, nil, nil, spellID)
		end
		self:Bar(other, 30, spellID)
	end
end

function mod:FeedbackRemove(player)
	if db.feedback then
		self:TriggerEvent("BigWigs_StopBar", self, fmt(L["feedback_other"], player))
	end
end
