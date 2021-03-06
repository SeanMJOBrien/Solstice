----
-- @module creature

local M = require 'solstice.objects.init'

local ffi = require 'ffi'
local C = ffi.C

local bit    = require 'bit'
local lshift = bit.lshift
local bor    = bit.bor
local band   = bit.band
local sm     = string.strip_margin
local GetObjectByID = Game.GetObjectByID
local NWE = require 'solstice.nwn.engine'

local Creature = M.Creature

--- Combat
-- @section

--- Adds parry attack.
-- @param attacker Attacker to do parry attack against.
function Creature:AddParryAttack(attacker)
  C.nwn_AddParryAttack(self.obj.cre_combat_round, attacker.id)
end

function Creature:GetArcaneSpellFailure()
  if not self:GetIsValid() then return 0 end
  local amt = self.obj.cre_stats.cs_arcane_sp_fail_2 + self.obj.cre_stats.cs_arcane_sp_fail_1 + self.obj.cre_stats.cs_arcane_sp_fail_3
  return math.clamp(amt, 0, 100)
end

function Creature:GetAttackTarget()
  if not self:GetIsValid() then return OBJECT_INVALID end
  local obj = self.obj.cre_attack_target
  return GetObjectByID(obj)
end

function Creature:GetAttemptedAttackTarget()
  if not self:GetIsValid() then return OBJECT_INVALID end

  NWE.ExecuteCommand(361, 0)
  return NWE.StackPopObject()
end

function Creature:GetAttemptedSpellTarget()
  if not self:GetIsValid() then return OBJECT_INVALID end

  NWE.ExecuteCommand(375, 0)
  return NWE.StackPopObject()
end

function Creature:GetChallengeRating()
  if not self:GetIsValid() then return 0 end
  return self.obj.cre_stats.cs_cr
end

function Creature:GetDamageFlags()
  if not self:GetIsValid() then return 0 end
  return C.nwn_GetDamageFlags(self.obj)
end

function Creature:GetGoingToBeAttackedBy()
  if not self:GetIsValid() then return OBJECT_INVALID end

  local obj = self.obj.cre_attacker
  return GetObjectByID(obj)
end

function Creature:GetIsInCombat()
  if not self:GetIsValid() then return false end
  return self.obj.cre_combat_state ~= 0
end

function Creature:GetLastAttackType()
  if not self:GetIsValid() then return 0 end
  return self.obj.obj.obj_last_attack_type
end

function Creature:GetLastAttackMode()
  if not self:GetIsValid() then return 0 end
  return self.obj.obj.obj_last_attack_mode
end

function Creature:GetLastTrapDetected()
  if not self:GetIsValid() then return OBJECT_INVALID end
  local obj = self.obj.cre_last_trap_detected
  return GetObjectByID(obj)
end

function Creature:GetLastWeaponUsed()
  if not self:GetIsValid() then return OBJECT_INVALID end
  local obj = self.obj.obj.obj_last_attack_weapon
  return GetObjectByID(obj)
end

function Creature:GetMaxAttackRange(target)
  return C.nwn_GetMaxAttackRange(self.obj, target.id)
end

function Creature:GetReflexAdjustedDamage(damage, dc, savetype, versus)
  NWE.StackPushObject(versus)
  NWE.StackPushInteger(savetype)
  NWE.StackPushInteger(dc)
  NWE.StackPushObject(self)
  NWE.StackPushInteger(damage)
  NWE.ExecuteCommand(299, 5)
  return NWE.StackPopInteger()
end

function Creature:GetTargetState(target)
  if not target:GetIsValid() or
    target.type ~= OBJECT_TRUETYPE_CREATURE
  then
    return 0
  end

  local res = 0
  if target:GetIsBlind() then
    res = bor(res, COMBAT_TARGET_STATE_BLIND)
  end

  if target:GetIsInvisible(self) then
    res = bor(res, COMBAT_TARGET_STATE_ATTACKER_INVIS)
  end

  if self:GetIsInvisible(target) then
    res = bor(res, COMBAT_TARGET_STATE_INVIS)
  end

  if not self:GetIsSeen(target) then
    res = bor(res, COMBAT_TARGET_STATE_ATTACKER_UNSEEN)
  end

  if not target:GetIsSeen(self) then
    res = bor(res, COMBAT_TARGET_STATE_UNSEEN)
  end

   if target.obj.obj.obj_anim == 4  or
     target.obj.obj.obj_anim == 87 or
     target.obj.obj.obj_anim == 86
   then
     res = bor(res, COMBAT_TARGET_STATE_MOVING)
   end

   if target.obj.obj.obj_anim == 36  or
     target.obj.obj.obj_anim == 33 or
     target.obj.obj.obj_anim == 32 or
     target.obj.obj.obj_anim == 5
   then
     res = bor(res, COMBAT_TARGET_STATE_PRONE)
   end

   if target.obj.cre_state == 6 then
     res = bor(res, COMBAT_TARGET_STATE_STUNNED)
   end

   if target.obj.cre_state == 9 or target.obj.cre_state == 8 then
     res = bor(res, COMBAT_TARGET_STATE_ASLEEP)
   end

   if self:GetIsFlanked(target) then
     res = bor(res, COMBAT_TARGET_STATE_FLANKED)
   end

   if target:GetIsFlatfooted() then
     res = bor(res, COMBAT_TARGET_STATE_FLATFOOTED)
   end

   return res
end

function Creature:GetFavoredEnemenyMask()
  local res = 0

  local function FE(feat, race)
    if self:GetHasFeat(feat) then
      res = bor(res, lshift(1, race))
    end
  end

  FE(FEAT_FAVORED_ENEMY_DWARF, RACIAL_TYPE_DWARF);
  FE(FEAT_FAVORED_ENEMY_ELF, RACIAL_TYPE_ELF);
  FE(FEAT_FAVORED_ENEMY_GNOME, RACIAL_TYPE_GNOME);
  FE(FEAT_FAVORED_ENEMY_HALFLING, RACIAL_TYPE_HALFLING);
  FE(FEAT_FAVORED_ENEMY_HALFELF, RACIAL_TYPE_HALFELF);
  FE(FEAT_FAVORED_ENEMY_HALFORC, RACIAL_TYPE_HALFORC);
  FE(FEAT_FAVORED_ENEMY_HUMAN, RACIAL_TYPE_HUMAN);
  FE(FEAT_FAVORED_ENEMY_ABERRATION, RACIAL_TYPE_ABERRATION);
  FE(FEAT_FAVORED_ENEMY_ANIMAL, RACIAL_TYPE_ANIMAL);
  FE(FEAT_FAVORED_ENEMY_BEAST, RACIAL_TYPE_BEAST);
  FE(FEAT_FAVORED_ENEMY_CONSTRUCT, RACIAL_TYPE_CONSTRUCT);
  FE(FEAT_FAVORED_ENEMY_DRAGON, RACIAL_TYPE_DRAGON);
  FE(FEAT_FAVORED_ENEMY_GOBLINOID, RACIAL_TYPE_HUMANOID_GOBLINOID);
  FE(FEAT_FAVORED_ENEMY_MONSTROUS, RACIAL_TYPE_HUMANOID_MONSTROUS);
  FE(FEAT_FAVORED_ENEMY_ORC, RACIAL_TYPE_HUMANOID_ORC);
  FE(FEAT_FAVORED_ENEMY_REPTILIAN, RACIAL_TYPE_HUMANOID_REPTILIAN);
  FE(FEAT_FAVORED_ENEMY_ELEMENTAL, RACIAL_TYPE_ELEMENTAL);
  FE(FEAT_FAVORED_ENEMY_FEY, RACIAL_TYPE_FEY);
  FE(FEAT_FAVORED_ENEMY_GIANT, RACIAL_TYPE_GIANT);
  FE(FEAT_FAVORED_ENEMY_MAGICAL_BEAST, RACIAL_TYPE_MAGICAL_BEAST);
  FE(FEAT_FAVORED_ENEMY_OUTSIDER, RACIAL_TYPE_OUTSIDER);
  FE(FEAT_FAVORED_ENEMY_SHAPECHANGER, RACIAL_TYPE_SHAPECHANGER);
  FE(FEAT_FAVORED_ENEMY_UNDEAD, RACIAL_TYPE_UNDEAD);
  FE(FEAT_FAVORED_ENEMY_VERMIN, RACIAL_TYPE_VERMIN);

  return res
end

function Creature:GetIsFavoredEnemy(vs)
  if not vs:GetIsValid()
    or vs.type ~= OBJECT_TRUETYPE_CREATURE
    or not self.sol_fe_mask
  then
    return false
  end

  return band(self.sol_fe_mask, lshift(1, vs:GetRacialType())) ~= 0
end

function Creature:GetHasTrainingVs(vs)
  if not vs:GetIsValid()
    or not self.sol_training_vs_mask
    or vs.type ~= OBJECT_TRUETYPE_CREATURE
  then
    return false
  end

  return band(self.sol_training_vs_mask, lshift(1, vs:GetRacialType())) ~= 0
end

function Creature:GetTrainingVsMask()
  local res = 0

  if self:GetHasFeat(FEAT_BATTLE_TRAINING_VERSUS_ORCS) then
    res = bor(res, lshift(1, RACIAL_TYPE_HUMANOID_ORC))
  end

  if self:GetHasFeat(FEAT_BATTLE_TRAINING_VERSUS_GOBLINS) then
    res = bor(res, lshift(1, RACIAL_TYPE_HUMANOID_GOBLINOID))
  end

  if self:GetHasFeat(FEAT_BATTLE_TRAINING_VERSUS_GIANTS) then
    res = bor(res, lshift(1, RACIAL_TYPE_GIANT))
  end

  if self:GetHasFeat(FEAT_BATTLE_TRAINING_VERSUS_REPTILIANS) then
    res = bor(res, lshift(1, RACIAL_TYPE_HUMANOID_REPTILIAN))
  end
  return res
end

function Creature:GetTurnResistanceHD()
  NWE.StackPushObject(self)
  NWE.ExecuteCommand(478, 1)
  NWE.StackPopInteger()
end

function Creature:RestoreBaseAttackBonus()
  NWE.StackPushObject(self)
  NWE.ExecuteCommand(756, 1)
end

function Creature:SetBaseAttackBonus(amount)
  NWE.StackPushObject(self)
  NWE.StackPushInteger(amount)
  NWE.ExecuteCommand(755, 2)
end

function Creature:SurrenderToEnemies()
  NWE.ExecuteCommand(476, 0);
end
