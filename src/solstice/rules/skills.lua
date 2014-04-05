--- Rules module
-- @module rules

--- Skills
-- @section

local ffi = require 'ffi'
local C = ffi.C

local M = require 'solstice.rules.init'

--- Get skill's associated ability.
-- @param skill SKILL\_*
-- @return ABILIIY\_*
function M.GetSkillAbility(skill)
   local sk = C.nwn_GetSkill(skill)
   if sk == nil then return -1 end

   return sk.sk_ability
end

--- Check if skill requires training.
-- @param skill SKILL\_*
function M.GetSkillAllCanUse(skill)
   local sk = C.nwn_GetSkill(skill)
   if sk == nil then return false end
   return sk_all_can_use ~= 0
end

--- Check if skill has armor check penalty.
-- @param skill SKILL\_*
function M.GetSkillHasArmorCheckPenalty(skill)
   local sk = C.nwn_GetSkill(skill)
   if sk == nil then return false end

   return sk.sk_armor_check ~= 0
end

--- Check if skill requires training.
-- @param skill SKILL\_*
function M.GetSkillIsUntrained(skill)
   local sk = C.nwn_GetSkill(skill)
   if sk == nil then return false end
   return sk.sk_untrained ~= 0
end

--- Get Skill name.
-- @param skill SKILL\_*
function M.GetSkillName(skill)
   local sk = C.nwn_GetSkill(skill)
   if sk == nil then return "" end

   return TLK.GetString(sk.sk_name_strref)
end

local epic_bonus = 13
local bonus = 3
local function get_skill_focus_bonus(cre, focus, epic)
   if cre:GetHasFeat(epic) then return epic_bonus
   elseif cre:GetHasFeat(focus) then return bonus
   else return 0 end
end

local GetSkillFeatBonusOverride

--- Get Skill Bonuses from feats.
function M.GetSkillFeatBonus(cre, skill)
   local res = 0
   if GetSkillFeatBonusOverride then
      return GetSkillFeatBonusOverride(cre, skill)
   end

   if skill == SKILL_ANIMAL_EMPATHY then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_ANIMAL_EMPATHY,
                                        FEAT_EPIC_SKILL_FOCUS_ANIMAL_EMPATHY)
   elseif skill == SKILL_CONCENTRATION then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_CONCENTRATION,
                                        FEAT_EPIC_SKILL_FOCUS_CONCENTRATION)
   elseif skill == SKILL_DISABLE_TRAP then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_DISABLE_TRAP,
                                        FEAT_EPIC_SKILL_FOCUS_DISABLETRAP)
   elseif skill == SKILL_DISCIPLINE then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_DISCIPLINE,
                                        FEAT_EPIC_SKILL_FOCUS_DISCIPLINE)
   elseif skill == SKILL_HEAL then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_HEAL,
                                        FEAT_EPIC_SKILL_FOCUS_HEAL)
   elseif skill == SKILL_HIDE then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_HIDE,
                                        FEAT_EPIC_SKILL_FOCUS_HIDE)
   elseif skill == SKILL_LISTEN then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_LISTEN,
                                        FEAT_EPIC_SKILL_FOCUS_LISTEN)
   elseif skill == SKILL_LORE then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_LORE,
                                        FEAT_EPIC_SKILL_FOCUS_LORE)
   elseif skill == SKILL_MOVE_SILENTLY then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_MOVE_SILENTLY,
                                        FEAT_EPIC_SKILL_FOCUS_MOVESILENTLY)
   elseif skill == SKILL_OPEN_LOCK then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_OPEN_LOCK,
                                        FEAT_EPIC_SKILL_FOCUS_OPENLOCK)
   elseif skill == SKILL_PARRY then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_PARRY,
                                        FEAT_EPIC_SKILL_FOCUS_PARRY)
   elseif skill == SKILL_PERFORM then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_PERFORM,
                                        FEAT_EPIC_SKILL_FOCUS_PERFORM)
   elseif skill == SKILL_PERSUADE then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_PERSUADE,
                                        FEAT_EPIC_SKILL_FOCUS_PERSUADE)
   elseif skill == SKILL_PICK_POCKET then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_PICK_POCKET,
                                        FEAT_EPIC_SKILL_FOCUS_PICKPOCKET)
   elseif skill == SKILL_SEARCH then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_SEARCH,
                                        FEAT_EPIC_SKILL_FOCUS_SEARCH)
   elseif skill == SKILL_SET_TRAP then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_SET_TRAP,
                                        FEAT_EPIC_SKILL_FOCUS_SETTRAP)
   elseif skill == SKILL_SPELLCRAFT then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_SPELLCRAFT,
                                        FEAT_EPIC_SKILL_FOCUS_SPELLCRAFT)
   elseif skill == SKILL_SPOT then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_SPOT,
                                        FEAT_EPIC_SKILL_FOCUS_SPOT)
   elseif skill == SKILL_TAUNT then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_TAUNT,
                                        FEAT_EPIC_SKILL_FOCUS_TAUNT)
   elseif skill == SKILL_USE_MAGIC_DEVICE then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_USE_MAGIC_DEVICE,
                                        FEAT_EPIC_SKILL_FOCUS_USEMAGICDEVICE)
   elseif skill == SKILL_APPRAISE then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_APPRAISE,
                                        FEAT_EPIC_SKILL_FOCUS_APPRAISE)
   elseif skill == SKILL_TUMBLE then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_TUMBLE,
                                        FEAT_EPIC_SKILL_FOCUS_TUMBLE)
   elseif skill == SKILL_CRAFT_TRAP then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_CRAFT_TRAP,
                                        FEAT_EPIC_SKILL_FOCUS_CRAFT_TRAP)
   elseif skill == SKILL_BLUFF then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_BLUFF,
                                        FEAT_EPIC_SKILL_FOCUS_BLUFF)
   elseif skill == SKILL_INTIMIDATE then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_INTIMIDATE,
                                        FEAT_EPIC_SKILL_FOCUS_INTIMIDATE)
   elseif skill == SKILL_CRAFT_ARMOR then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_CRAFT_ARMOR,
                                        FEAT_EPIC_SKILL_FOCUS_CRAFT_ARMOR)
   elseif skill == SKILL_CRAFT_WEAPON then
      res = res + get_skill_focus_bonus(cre, FEAT_SKILL_FOCUS_CRAFT_WEAPON,
                                        FEAT_EPIC_SKILL_FOCUS_CRAFT_WEAPON)
   end

   return res
end

--- Set GetSkillFeatBonus override function
-- @func func (cre, skill) -> int
function M.SetSkillFeatBonusOverride(func)
   GetSkillFeatBonusOverride = func
end