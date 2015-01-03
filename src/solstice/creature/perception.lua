--- Creature module
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module creature

local M   = require 'solstice.creature.init'
local NWE = require 'solstice.nwn.engine'
local Creature = M.Creature

--- Preception
-- @section

--- Determines whether an object sees another object.
-- @param target Object to determine if it is seen.
function Creature:GetIsSeen(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommandUnsafe(289, 2)
   return NWE.StackPopBoolean()
end

--- Determines if an object can hear another object.
-- @param target The object that may be heard.
function Creature:GetIsHeard(target)
   NWE.StackPushObject(self)
   NWE.StackPushObject(target)
   NWE.ExecuteCommandUnsafe(290, 2)
   return NWE.StackPopBoolean()
end

--- Determines the last perceived creature in an OnPerception event.
function Creature:GetLastPerceived()
   if not self:GetIsValid() then return OBJECT_INVALID end
   return Game.GetObjectByID(self.obj.cre_last_perceived)
end

--- Determines if the last perceived object was heard.
function Creature:GetLastPerceptionHeard()
   if not self:GetIsValid() then return false end
   return self.obj.cre_last_perc_heard == 1
end

--- Determines whether the last perceived object is no longer heard.
function Creature:GetLastPerceptionInaudible()
   if not self:GetIsValid() then return false end
   return self.obj.cre_last_perc_inaudible == 1
end

--- Determines the last perceived creature has vanished.
function Creature:GetLastPerceptionVanished()
   if not self:GetIsValid() then return false end
   return self.obj.cre_last_perc_vanished == 1
end

--- Determines if the last perceived object was seen.
function Creature:GetLastPerceptionSeen()
   if not self:GetIsValid() then return false end
   return self.obj.cre_last_perc_seen == 1
end
