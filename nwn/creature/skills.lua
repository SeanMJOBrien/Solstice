--------------------------------------------------------------------------------
--  Copyright (C) 2011-2012 jmd ( jmd2028 at gmail dot com )
-- 
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--------------------------------------------------------------------------------

local ne = nwn.engine

--- Determines if a creature has a skill
-- @param skill nwn.SKILL_*
function Creature:GetHasSkill(skill)
   ne.StackPushObject(self)
   ne.StackPushInteger(skill)
   ne.ExecuteCommand(286, 2)
   return ne.StackPopBoolean()
end

--- Determines if skill check is successful
-- @param skill nwn.SKILL_*
-- @param dc Difficult Class
function Creature:GetIsSkillSuccessful(skill, dc)
   return self:GetSkillCheckResult(skill, dc) > 0
end

--- Determine's a skill check.
-- Source: FunkySwerve on NWN bioboards
-- @param skill nwn.SKILL_*
-- @param dc Difficult Class
-- @param vs Versus a target
-- @param feedback If true sends feedback to participants.
-- @param auto If true a roll of 20 is automatic success, 1 an automatic failure
-- @param delay Delay in seconds.
-- @param take Replaces dice roll.
-- @param bonus And bonus.
function Creature:GetSkillCheckResult(skill, dc, vs, feedback, auto, delay, take, bonus)
   vs = vs or nwn.OBJECT_INVALID
   if feedback == nil then feedback = true end
   auto = auto or 0
   delay = delay or 0
   take = take or 0
   bonus = bonus or 0

   local ret
   local rank = self:GetSkillRank(skill) + bonus
   local roll = take > 0 and take or nwn.d20()
   local sign = rank >= 0 and " + " or " - "

   local success
   if rank + 20 < dc and auto <= 0 then
      success = "*success not possible*"
      ret = 0
   elseif auto == 1 and roll == 20 then
      success = "*automatic success*"
      ret = 2
   elseif auto == 2 and roll == 1 and rank - bonus < dc - 1 then
      success = "*automatic failure"
      ret = 0
   elseif auto == 1 and roll == 1 then
      success = "*critical failure*"
      ret = -1
   elseif rank + roll < dc then
     success = "*failure*"
     ret = 0
   else
      success = "*success*";
      ret = 1
   end

   if auto < 0 and ret > 0 then
      ret = 1 + ((rank + roll) - dc)
   end

   if feedback and (self:GetIsPC() or vs:GetIsPC()) then
      local msg = string.format("<> %s <> : %s : %s : (%d %s %d = %d vs. DC: %d)</c>", self:GetName(),
                                nwn.GetSkillName(skill), success, roll, sign, math.abs(rank), roll + rank, dc)
      
      if vs:GetIsValid() and self.id ~= vs.id then
         vs:DelayCommand(delay, function () vs:SendMessage(msg) end)
      end
      self:DelayCommand(delay, function () self:SendMessage(msg) end)
   end

   local dbg = "Skill Check: User: %s, Versus: %s, Skill: %s, Rank: %d, Roll: %d, DC: %d, Auto: %d"
   self:Log("DebugChecks", nwn.LOGLEVEL_DEBUG, dbg, self:GetName(), vs:GetName(), nwn.GetSkillName(skill),
            rank, roll, dc, auto)
   vs:Log("DebugChecks", nwn.LOGLEVEL_DEBUG, dbg, self:GetName(), vs:GetName(), nwn.GetSkillName(skill),
          rank, roll, dc, auto)
   
   return ret
end

--- Determines maximum skill bonus from effects/gear.
-- @param skill nwn.SKILL_*
function Creature:GetMaxSkillBonus(skill)
   return 20
end

--- Gets the amount a skill was increased at a level.
-- @param level Level to check
-- @param skill nwn.SKILL_*
-- @return -1 on error.
function Creature:GetSkillIncreaseByLevel(level, skill)
   if not self:GetIsValid()
      or skill < 0 or skill > nwn.SKILL_LAST
   then
      return -1
   end
   
   local ls = ffi.C.nl_GetLevelStats(self.stats, level)
   if ls == nil then return -1 end

   return ls.ls_skilllist[skill]
end

--- Returns a creatures unused skillpoints.
function Creature:GetSkillPoints()
   if not self:GetIsValid() then return 0 end

   return self.stats.cs_skill_points
end

--- Gets creature's skill rank.
-- @param skill nwn.SKILL_*
function Creature:GetSkillRank(skill, base)
   ne.StackPushBoolean(base)
   ne.StackPushObject(self)
   ne.StackPushInteger(skill)
   ne.ExecuteCommand(315, 3)
   return ne.StackPopInteger()
end

--- Determines total skill bonus from effects/gear.
-- @param vs Versus a target
-- @param skill nwn.SKILL_*
function Creature:GetTotalEffectSkillBonus(vs, skill)
   local function valid(eff, vs_info)
      local eskill    = eff.eff_integers[0]
      local race      = eff.eff_integers[2]
      local lawchaos  = eff.eff_integers[3]
      local goodevil  = eff.eff_integers[4]
      local subrace   = eff.eff_integers[5]
      local deity     = eff.eff_integers[6]
      local target    = eff.eff_integers[7]

      if eskill == skill 
         and (race == nwn.RACIAL_TYPE_INVALID or race == vs_info.race)
         and (lawchaos == 0 or lawchaos == vs_info.lawchaos)
         and (goodevil == 0 or goodevil == vs_info.goodevil)
         and (subrace == 0 or subrace == vs_info.subrace_id)
         and (deity == 0 or deity == vs_info.deity_id)
         and (target == 0 or target == vs_info.target)
      then
         return true
      end
      return false
   end

   local function range(type)
      if type > nwn.EFFECT_TRUETYPE_SKILL_DECREASE
         or type < nwn.EFFECT_TRUETYPE_SKILL_INCREASE
      then
         return false
      end
      return true
   end

   local function get_amount(eff)
      return eff.eff_integers[1]
   end

   local info = effect_info_t(self.stats.cs_first_skill_eff, 
                              nwn.EFFECT_TRUETYPE_SKILL_DECREASE,
                              nwn.EFFECT_TRUETYPE_SKILL_INCREASE,
                              NS_OPT_EFFECT_SKILL_STACK,
                              NS_OPT_EFFECT_SKILL_STACK_GEAR,
                              NS_OPT_EFFECT_SKILL_STACK_SPELL)

   return math.clamp(self:GetTotalEffectBonus(vs, info, range, valid, get_amount),
                     0, self:GetMaxSkillBonus(skill))
end

--- Modifies skill rank.
-- @param skill nwn.SKILL_*
-- @param amount Amount to modify skill rank.
-- @param level If a level is specified the modification will occur at that level.
function Creature:ModifySkillRank(skill, amount, level)
   if not self:GetIsValid() or
      skill < 0 or skill > nwn.SKILL_LAST
   then
      return -1
   end

   amount = self.stats.cs_skills[skill] + amount

   if amount < 0 then amount = 0
   elseif amount > 127 then amount = 127
   end

   if level then
      local ls = ffi.C.nl_GetLevelStats(level)
      if ls == nil then return -1 end
      local cur = ls.ls_skilllist[skill]
      ls.ls_skilllist[skill] = cur + amount
   end

   self.stats.cs_skills[skill] = amount

   return self.stats.cs_skills[skill]
end

--- Sets a creatures skillpoints available.
-- @param amount New amount
function Creature:SetSkillPoints(amount)
   if not self:GetIsValid() then return 0 end

   self.stats.cs_skill_points = amount
   return self.stats.cs_skill_points
end

--- Sets a creatures skill rank
-- @param skill nwn.SKILL_*
-- @param amount New skill rank
function Creature:SetSkillRank(skill, amount)
   if not self:GetIsValid() or
      skill < 0 or skill > nwn.SKILL_LAST
   then
      return -1
   end

   if amount < 0 then amount = 0
   elseif amount > 127 then amount = 127
   end

   self.stats.cs_skills[skill] = amount
   return self.stats.cs_skills[skill]
end




function NSGetTotalSkillBonus(cre, vs, skill)
   cre = _NL_GET_CACHED_OBJECT(cre)
   vs = _NL_GET_CACHED_OBJECT(vs)
   return cre:GetTotalEffectSkillBonus(vs, skill)
end