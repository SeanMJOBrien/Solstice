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

--- Add PC to party
-- @param leader Faction leader
function Creature:AddToParty(leader)
   nwn.engine.StackPushObject(leader)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(572, 2)
end

--- Adjust reputation
-- @param target Target
-- @param amount Amount to adjust
function Creature:AdjustReputation(target, amount)
   nwn.engine.StackPushInteger(amount)
   nwn.engine.StackPushObject(target)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(209, 3)
end

--- Changes creature to standard faction
function Creature:ChangeToStandardFaction()
   nwn.engine.StackPushInteger(faction)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(412, 2)
end

--- Clears personal repuation
-- @param target Target
function Creature:ClearPersonalReputation(target)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(389, 2)
end

--- Get if factions are equal.
-- @param target Target
function Creature:GetFactionEqual(target)
   nwn.engine.StackPushObject(target)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(172, 2)
   return nwn.engine.StackPopBoolean()
end

--- Determine if target is an enemy
-- @param target Target
function Creature:GetIsEnemy(target)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(235, 2)
   return nwn.engine.StackPopBoolean()
end

--- Determine if target is a friend
-- @param target Target
function Creature:GetIsFriend(target)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(236, 2)
   return nwn.engine.StackPopBoolean()
end

--- Determine if target is a neutral
-- @param target Target
function Creature:GetIsNeutral(target)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(237, 2)
   return nwn.engine.StackPopBoolean()
end

--- Determine reaction type if friendly
-- @param target Target
function Creature:GetIsReactionTypeFriendly(target)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(469, 2)
   return nwn.engine.StackPopBoolean()
end

--- Determine reaction type if hostile
-- @param target Target
function Creature:GetIsReactionTypeHostile(target)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(471, 2)
   return nwn.engine.StackPopBoolean()
end

--- Determine reaction type if neutral
-- @param target Target
function Creature:GetIsReactionTypeNeutral(target)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(470, 2)
   return nwn.engine.StackPopBoolean()
end

--- Gets reputation of creature.
-- @param target Target
function Creature:GetReputation(target)
   nwn.engine.StackPushObject(target)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(208, 2);
   return nwn.engine.StackPopInteger()
end

--- Get standard faction reputation
-- @param faction Faction to check
function Creature:GetStandardFactionReputation(faction)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(nStandardFaction)
   nwn.engine.ExecuteCommand(524, 2)
   return nwn.engine.StackPopInteger()
end

--- Remove PC from party.
function Creature:RemoveFromParty()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(573, 1)
end

--- Set creature as a temporary enemy
-- @param target Target
-- @param decays If true reactions will retrun after duration. (Default: false)
-- @param duration Time in seconds (Default: 180.0)
function Creature:SetIsTemporaryEnemy(target, decays, duration)
   duration = duration or 180.0

   nwn.engine.StackPushFloat(duration)
   nwn.engine.StackPushBoolean(decays)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(391, 4)
end

--- Set creature as a temporary friend
-- @param target Target
-- @param decays If true reactions will retrun after duration. (Default: false)
-- @param duration Time in seconds (Default: 180.0)
function Creature:SetIsTemporaryFriend(target, decays, duration)
   duration = duration or 180.0

   nwn.engine.StackPushFloat(duration)
   nwn.engine.StackPushBoolean(decays)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(390, 4)
end

--- Set creature as a temporary neutral
-- @param target Target
-- @param decays If true reactions will retrun after duration. (Default: false)
-- @param duration Time in seconds (Default: 180.0)
function Creature:SetIsTemporaryNeutral(target, decays, duration)
   duration = duration or 180.0

   nwn.engine.StackPushFloat(duration)
   nwn.engine.StackPushInteger(decays)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushObject(target)
   nwn.engine.ExecuteCommand(392, 4)
end

--- Set standard faction reputation
-- @param faction Faction
-- @param rep Reputaion
function Creature:SetStandardFactionReputation(faction, rep)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(rep)
   nwn.engine.StackPushInteger(faction)
   nwn.engine.ExecuteCommand(523, 3)
end
