--- Effects module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module effect

local ffi = require 'ffi'
local C   = ffi.C
local NWE = require 'solstice.nwn.engine'

local M = require 'solstice.effect.init'
M.const = require 'solstice.effect.constant'
setmetatable(M, { __index = M.const })

require 'solstice.effect.creation'

M.Effect = inheritsFrom(nil, 'solstice.effect.Effect')

local effect_mt = { __index = M.Effect,
                    __gc = function(eff) 
                       if not eff.direct and eff.eff ~= nil then
                          C.free(eff.eff)
                       end
                    end
}

--- Internal ctype.
M.effect_t = ffi.metatype("Effect", effect_mt)

--- Effect class
-- @section solstice.effect.Effect

--- Class Effect
-- @section sol_effect_Effect

--- Converts an effect to a formatted string.
function M.Effect:ToString()
   local t = {}
   local fmt = "Id: %d, Type: %d, Subtype: %d, Duration Type: %d, Duration %.2f Integers: "

   table.insert(t, string.format("Id: %d", self:GetId()))
   local cre = self:GetCreator()
   table.insert(t, string.format("Creator: %X", cre.id))
   table.insert(t, string.format("Spell Id: %d", self:GetSpellId()))
   table.insert(t, string.format("Type: %d", self:GetType()))
   table.insert(t, string.format("Subtype: %d", self:GetSubType()))
   table.insert(t, string.format("Duration Type: %d", self:GetDurationType()))
   table.insert(t, string.format("Duration: %.2f", self:GetDuration()))

   ints = {}
   for i = 0, self.eff.eff_num_integers - 1 do
      table.insert(ints, string.format("%d: %d", i, self:GetInt(i)))
   end

   table.insert(t, string.format("Integers: %s", table.concat(ints, ", ")))

   return table.concat(t, "\n")
end

--- Returns effect's creator.
function M.Effect:GetCreator()
    return _SOL_GET_CACHED_OBJECT(self.eff.eff_creator)
end

--- Gets the duration of an effect.
-- Returns the duration specified when applied for
-- the effect. The value of this is undefined for effects which are
-- not of solstice.effect.DURATION_TYPE_TEMPORARY. 
-- Source: nwnx_structs by Acaos
function M.Effect:GetDuration ()
   return self.eff.eff_duration
end

--- Gets the remaing duration of an effect
-- Returns the remaining duration of the specified effect. The value
-- of this is undefined for effects which are not of
-- solstice.effect.DURATION_TYPE_TEMPORARY. Source: nwnx_structs by Acaos
function M.Effect:GetDurationRemaining ()
   local current = C.nwn_GetWorldTime(nil, nil)
   local expire = self.eff.eff_expire_time
   expire = (expire * 2880000LL) + self.eff.eff_expire_time
   return expire - current / 1000.0
end 

--- Get duration type
-- @return solstice.effect.DURATION_TYPE_*
function M.Effect:GetDurationType()
   return bit.band(self.eff.eff_dursubtype, 0x7)
end

--- Gets the specifed effects Id
function M.Effect:GetId()
   return self.eff.eff_id
end

--- Determines whether an effect is valid.
function M.Effect:GetIsValid()
    NWE.StackPushEngineStructure(NWE.STRUCTURE_EFFECT, self)
    NWE.ExecuteCommand(88, 1)
    return NWE.StackPopBoolean()
end

--- Returns the internal effect integer at the index specified.
-- @param index The index.
function M.Effect:GetInt(index)
   if index < 0 or index >= self.eff.eff_num_integers then
      print(debug.traceback())
      error "Effect integer index is out of bounds."
      return -1
   end
   return self.eff.eff_integers[index]
end

--- Gets Spell Id associated with effect
function M.Effect:GetSpellId()
   return self.eff.eff_spellid
end

--- Get the subtype of the effect.
-- @return solstice.effect.SUBTYPE_*
function M.Effect:GetSubType()
   return bit.band(self.eff.eff_dursubtype, 0x18)
end

--- Gets effects internal 'true' type.
-- Source: nwnx_structs by Acaos
function M.Effect:GetType()
   return self.eff.eff_type
end

--- Set all integers to a specified value
function M.Effect:SetAllInts(val)
   for i = 0, self.eff.eff_num_integers - 1 do
      self:SetInt(i, val)
   end
end

--- Sets the effects creator
-- @param object 
function M.Effect:SetCreator(object)
   if type(object) == "number" then
      self.eff.eff_creator = object
   else
      self.eff.eff_creator = object.id
   end
end

function M.Effect:SetDuration(dur)
   self.eff.eff_duration = dur
   return self.eff.eff_duration
end

function M.Effect:SetDurationType(dur)
   self.eff.eff_dursubtype = bit.bor(dur, self:GetSubType())
   return self.eff.eff_dursubtype
end

--- Sets the internal effect integer at the specified index to the
-- value specified. Source: nwnx_structs by Acaos
function M.Effect:SetInt(index, value)
   if index < 0 or index > self.eff.eff_num_integers then
      return -1
   end
   self.eff.eff_integers[index] = value
   return self.eff.eff_integers[index]
end

--- Set number of integers stored on an effect.
-- Calling this on an effect will erase any integers already stored on the effect.
-- @param num Number of integers.
function M.Effect:SetNumIntegers(num)
   C.nwn_EffectSetNumIntegers(self.eff, num)
end

--- Sets the effect's spell id as specified, which will later be returned
-- with Effect:GetSpellId(). Source: nwnx_structs by Acaos
function M.Effect:SetSpellId (spellid)
   self.eff.eff_spellid = spellid
end

--- Sets a string on an effect.
-- @param index Index to store the string.  [0, 5]
-- @param str String to store.
function M.Effect:SetString(index, str)
   if index < 0 or index > 5 then
      error "Effect:SetString must be between 0 and 5"
      return
   end
   self.eff.eff_strings[index].text = C.strdup(str)
   self.eff.eff_strings[index].len = #str
end

--- Set the subtype of the effect.
-- @param value solstice.SUBTYPE_*
function M.Effect:SetSubType(value)
   self.eff.eff_dursubtype = bit.bor(value, self:GetDurationType())
   return self.eff.eff_dursubtype
end

--- Gets effects internal 'true' type.
-- Source: nwnx_structs by Acaos
function M.Effect:SetType(value)
   self.eff.eff_type = value
   return self.eff.eff_type
end

--- Sets an effect versus a specified alignment
-- @param[opt=solstice.ALIGNMENT_ALL] lawchaos Law / Chaos
-- @param[opt=solstice.ALIGNMENT_ALL] goodevil Good / Evil
function M.Effect:SetVersusAlignment(lawchaos, goodevil)
   local lcidx
   local geidx
   local type = self.eff.eff_type
   lawchaos = lawchaos or solstice.ALIGNMENT_ALL
   goodevil = goodevil or solstice.ALIGNMENT_ALL

   if type == Eff.ATTACK_INCREASE
      or type == Eff.ATTACK_DECREASE
      or type == Eff.DAMAGE_INCREASE 
      or type == Eff.DAMAGE_DECREASE
      or type == Eff.AC_INCREASE
      or type == Eff.AC_DECREASE
      or type == Eff.SKILL_INCREASE
      or type == Eff.SKILL_DECREASE 
   then
      lcidx, geidx = 3, 4
   elseif type == Eff.CONCEALMENT 
      or type == Eff.IMMUNITY 
      or type == Eff.INVISIBILITY
      or type == Eff.SANCTUARY
   then
      lcidx, geidx = 2, 3
   else
      error(string.format("Effect Type (%d) does not support versus alignment", type))
      return
   end

   self:SetInt(lcidx, lawchaos)
   self:SetInt(geidx, goodevil)
end

--- Set an effect versus a specified deity.
-- see Creature:GetDeityId()
-- @param deity An integer value indicating a deity id.
-- This value is server dependent.
function M.Effect:SetVersusDeity(deity)
   local idx
   local type = self.eff.eff_type

   if type == Eff.ATTACK_INCREASE 
      or type == Eff.ATTACK_DECREASE 
      or type == Eff.SKILL_INCREASE 
      or type == Eff.SKILL_DECREASE 
   then
      idx = 6
   elseif type == Eff.DAMAGE_INCREASE
      or type == Eff.DAMAGE_DECREASE 
      or type == Eff.AC_INCREASE
      or type == Eff.AC_DECREASE
   then
      idx = 7
   elseif type == Eff.IMMUNITY then
      
   else
      error(string.format("Effect Type (%d) does not support versus deity", type))
      return
   end

   self:SetInt(idx, deity)
end

--- Sets an effect 'versus' a percentage.
-- That is the effect has a specified % of being applicable.
-- A value of 60% would mean that the creature must roll a 1d100 <= 60.
-- @param perc Percent: [0, 100).  Value 0 is always applicable.
function M.Effect:SetVersusPercentage(perc)
   if perc < 0 or perc >= 100 then
      error "Versus percentage takes a value [0, 100)"
   end

   local idx
   local type = self:GetType()

   if type == Eff.IMMUNITY then
      idx = 1
   else
      error(string.format("Effect Type (%d) does not support versus subrace", type))
      return
   end

   self:SetInt(idx, subrace)
end

--- Sets an effect versus a race
-- @param race solstice.RACIAL_TYPE_*
function M.Effect:SetVersusRace(race)
   local idx
   local type = self:GetType()

  if type == Eff.ATTACK_INCREASE
      or type == Eff.ATTACK_DECREASE
      or type == Eff.DAMAGE_INCREASE 
      or type == Eff.DAMAGE_DECREASE
      or type == Eff.AC_INCREASE
      or type == Eff.AC_DECREASE
      or type == Eff.SKILL_INCREASE
      or type == Eff.SKILL_DECREASE 
   then
      idx = 2
   elseif type == Eff.CONCEALMENT 
      or type == Eff.IMMUNITY 
      or type == Eff.INVISIBILITY
      or type == Eff.SANCTUARY
   then
      idx = 1
      error(string.format("Effect Type (%d) does not support versus race", type))
      return
   end

   self:SetInt(idx, race)
end

--- Set an effect versus a specified subrace.
-- see Creature:GetSubraceId()
-- @param subrace An integer value indicating a subrace id.
--    This value is server dependent.
function M.Effect:SetVersusSubrace(subrace)
   local idx
   local type = self:GetType()

   if type == Eff.ATTACK_INCREASE 
      or type == Eff.ATTACK_DECREASE 
      or type == Eff.SKILL_INCREASE 
      or type == Eff.SKILL_DECREASE 
   then
      idx = 5
   elseif type == Eff.DAMAGE_INCREASE
      or type == Eff.DAMAGE_DECREASE 
      or type == Eff.AC_INCREASE
      or type == Eff.AC_DECREASE
   then
      idx = 6
   elseif type == Eff.CONCEALMENT then
   elseif type == Eff.IMMUNITY then
   else
      error(string.format("Effect Type (%d) does not support versus subrace", type))
      return
   end

   self:SetInt(idx, subrace)
end

--- Sets an effect versus a particular target.
-- @param target Target creature.
function M.Effect:SetVersusTarget(target)
   if not target:GetIsValid() then return end

   local idx
   local type = self.eff.eff_type

   if type == Eff.ATTACK_INCREASE 
      or type == Eff.ATTACK_DECREASE 
      or type == Eff.SKILL_INCREASE 
      or type == Eff.SKILL_DECREASE 
   then
      idx = 7
   elseif type == Eff.DAMAGE_INCREASE
      or type == Eff.DAMAGE_DECREASE 
      or type == Eff.AC_INCREASE
      or type == Eff.AC_DECREASE
   then
      idx = 8
   elseif type == Eff.IMMUNITY then
   else
      error(string.format("Effect Type (%d) does not support versus target", type))
      return
   end

   self:SetInt(idx, target.id)
end

return M