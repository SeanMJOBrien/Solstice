local TA = OPT.TA
local USE_VERSUS = OPT.USE_VERSUS

local max = math.max
local floor = math.floor

local function GetConcealment(cre, vs, is_ranged)
   local total = 0

   -- Self-Conceal Feats
   local feat = cre:GetHighestFeatInRange(FEAT_EPIC_SELF_CONCEALMENT_10,
                                          FEAT_EPIC_SELF_CONCEALMENT_50)

   if feat ~= - 1 then
      total = (feat - FEAT_EPIC_SELF_CONCEALMENT_10 + 1) * 10
      if TA then
         local rogue = cre:GetLevelByClass(CLASS_TYPE_ROGUE)
         if rogue >= 30 then
            local percent = 0
            if feat == FEAT_EPIC_SELF_CONCEALMENT_10 then
               percent = 5
            elseif feat == FEAT_EPIC_SELF_CONCEALMENT_20 then
               percent = 9
            elseif feat == FEAT_EPIC_SELF_CONCEALMENT_30 then
               percent = 12
            elseif feat == FEAT_EPIC_SELF_CONCEALMENT_40 then
               percent = 14
            else
               percent = 15
            end
            percent = max(percent, rogue - 20)
            total = total + floor((cre:GetSkillRank(SKILL_HIDE) * percent) / 100)
         end
      end
   end

   for i = cre.obj.cre_stats.cs_first_conceal_eff, cre.obj.obj.obj_effects_len - 1 do
      local eff_type = cre.obj.obj.obj_effects[i].eff_type
      if eff_type == EFFECT_TYPE_CONCEALMENT then
         local amount    = cre.obj.obj.obj_effects[i].eff_integers[0]
         local race      = cre.obj.obj.obj_effects[i].eff_integers[1]
         local lawchaos  = cre.obj.obj.obj_effects[i].eff_integers[2]
         local goodevil  = cre.obj.obj.obj_effects[i].eff_integers[3]
         local miss_type = cre.obj.obj.obj_effects[i].eff_integers[4]
         local valid     = false
         local pass      = false

         if miss_type == MISS_CHANCE_TYPE_NORMAL
            or (miss_type == MISS_CHANCE_TYPE_RANGED and is_ranged)
            or (miss_type == MISS_CHANCE_TYPE_MELEE and not is_ranged)
         then
            valid = true
         end

         if not USE_VERSUS then
            valid = valid    and
               race == 28    and
               lawchaos == 0 and
               goodevil == 0
         end

         if valid and amount > total then
            total = amount
         end
      end
   end

   return total
end

--- Get creatures miss chance
function GetMissChance(cre, is_ranged)
   local total = 0
   local eff_type, amount, miss_type

   for i = cre.obj.cre_stats.cs_first_misschance_eff, cre.obj.obj.obj_effects_len - 1 do
      local eff_type = cre.obj.obj.obj_effects[i].eff_type

      if eff_type > EFFECT_TYPE_MISS_CHANCE then
         break
      end

      local amount    = cre.obj.obj.obj_effects[i].eff_integers[0]
      local miss_type = cre.obj.obj.obj_effects[i].eff_integers[1]

      if  amount > total then
         if miss_type == MISS_CHANCE_TYPE_NORMAL
            or (miss_type == MISS_CHANCE_TYPE_DARKNESS and bit.band(cre.obj.cre_vision_type, 2) ~= 0 )
            or (miss_type == MISS_CHANCE_TYPE_RANGED and is_ranged)
            or (miss_type == MISS_CHANCE_TYPE_MELEE and not is_ranged)
         then
            total = amount
         end
      end
   end
   return total
end


local M = require 'solstice.rules.init'
M.GetConcealment = GetConcealment
M.GetMissChance  = GetMissChance