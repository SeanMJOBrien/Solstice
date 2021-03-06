--- Creature module
-- @module creature

--- Skills
-- @section skills

local M = require 'solstice.objects.init'
local Creature = M.Creature
local ffi   = require 'ffi'
local NWE   = require 'solstice.nwn.engine'
local color = require 'solstice.color'
local D     = require 'solstice.dice'
local Log   = System.GetLogger()

function Creature:GetHasSkill(skill)
   NWE.StackPushObject(self)
   NWE.StackPushInteger(skill)
   NWE.ExecuteCommand(286, 2)
   return NWE.StackPopBoolean()
end

function Creature:GetIsSkillSuccessful(skill, dc, vs, feedback, auto, delay, take, bonus)
   return self:GetSkillCheckResult(skill, dc, vs, feedback, auto, delay, take, bonus) > 0
end

function Creature:GetSkillCheckResult(skill, dc, vs, feedback, auto, delay, take, bonus)
   vs = vs or OBJECT_INVALID
   if feedback == nil then feedback = true end
   auto = auto or 0
   delay = delay or 0
   take = take or 0
   bonus = bonus or 0

   local ret
   local rank = self:GetSkillRank(skill, vs) + bonus
   local roll = take > 0 and take or D.d20()
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
      local msg = string.format("%s%s%s : %s : %s : (%d %s %d = %d vs. DC: %d)</c>", color.LIGHT_BLUE,
				self:GetName(), color.BLUE, Rules.GetSkillName(skill), success, roll,
				sign, math.abs(rank), roll + rank, dc)

      if vs:GetIsValid() and self.id ~= vs.id then
         vs:DelayCommand(delay, function () vs:SendMessage(msg) end)
      end
      self:DelayCommand(delay, function () self:SendMessage(msg) end)
   end

   local dbg = "Skill Check: User: %s, Versus: %s, Skill: %s, Rank: %d, Roll: %d, DC: %d, Auto: %d"
   Log:debug(dbg, self:GetName(), vs:GetName(), Rules.GetSkillName(skill),
             rank, roll, dc, auto)

   return ret
end

function Creature:GetSkillIncreaseByLevel(level, skill)
   if not self:GetIsValid()
      or skill < 0 or skill > SKILL_LAST
   then
      return -1
   end

   local ls = self:GetLevelStats(level)
   if ls == nil then return -1 end

   return ls.ls_skilllist[skill]
end

function Creature:GetSkillPoints()
   if not self:GetIsValid() then return 0 end

   return self.obj.cre_stats.cs_skill_points
end

function Creature:GetSkillRank(skill, vs, base)
   if not self:GetIsValid() or skill < 0 or skill > SKILL_LAST then
      return 0
   elseif self:GetIsDM() then
      return 127
   end
   local result = self.obj.cre_stats.cs_skills[skill];

   if result == 0 and not Rules.GetSkillIsUntrained(skill) then
      return 0
   end

   if base then return result end

   local eff = Rules.GetSkillEffectModifier(self, skill)
   local min, max = Rules.GetSkillEffectLimits(self, skill)
   result = result + math.clamp(eff, min, max)
   result = result + Rules.GetSkillArmorCheckPenalty(self, skill)
   result = result + self:GetAbilityModifier(Rules.GetSkillAbility(skill))
   result = result + Rules.GetSkillFeatBonus(self, skill)
   result = result - self:GetTotalNegativeLevels()

   return math.clamp(result, -127, 127)
end

function Creature:ModifySkillRank(skill, amount, level)
   if not self:GetIsValid() or
      skill < 0 or skill > SKILL_LAST
   then
      return -1
   end

   amount = self.obj.cre_stats.cs_skills[skill] + amount

   if amount < 0 then amount = 0
   elseif amount > 127 then amount = 127
   end

   if level then
      local ls = self:GetLevelStats(level)
      if ls == nil then return -1 end
      local cur = ls.ls_skilllist[skill]
      ls.ls_skilllist[skill] = cur + amount
   end

   self.obj.cre_stats.cs_skills[skill] = amount

   return self.obj.cre_stats.cs_skills[skill]
end

function Creature:SetSkillPoints(amount)
   if not self:GetIsValid() then return 0 end

   self.obj.cre_stats.cs_skill_points = amount
   return self.obj.cre_stats.cs_skill_points
end

function Creature:SetSkillRank(skill, amount)
   if not self:GetIsValid() or
      skill < 0 or skill > SKILL_LAST
   then
      return -1
   end

   if amount < 0 then amount = 0
   elseif amount > 127 then amount = 127
   end

   self.obj.cre_stats.cs_skills[skill] = amount
   return self.obj.cre_stats.cs_skills[skill]
end

--- Creates debug string for creature's skills.
function Creature:DebugSkills()
   local t = {}
   table.insert(t, "Skills: ")
   for i = 0, SKILL_NUM - 1 do
      local min, max = Rules.GetSkillEffectLimits(self, i)
      local eff = Rules.GetSkillEffectModifier(self, i)
      table.insert(t, string.format("  %s: Base: %d, Effects: %d, Clamp: (%d, %d, %d), Ability: %d, Feats: %d, " ..
                                    "Armor Check: %d, Negative Levels: -%d,  Total: %d",
                                    Rules.GetSkillName(i),
                                    self:GetSkillRank(i, OBJECT_INVALID, true),
                                    math.clamp(eff, min, max),
                                    eff,
                                    min,
                                    max,
                                    self:GetAbilityModifier(Rules.GetSkillAbility(i)),
                                    Rules.GetSkillFeatBonus(self, i),
                                    Rules.GetSkillArmorCheckPenalty(self, i),
                                    self:GetTotalNegativeLevels(),
                                    self:GetSkillRank(i, OBJECT_INVALID, false)))

   end
   return table.concat(t, "\n")
end
