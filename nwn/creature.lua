nwn.SITUATIONAL_FLAG_COUP_DE_GRACE = 1
nwn.SITUATIONAL_FLAG_SNEAK_ATTACK = 2
nwn.SITUATIONAL_FLAG_DEATH_ATTACK = 4

nwn.SITUATIONAL_COUP_DE_GRACE = 0
nwn.SITUATIONAL_SNEAK_ATTACK = 1
nwn.SITUATIONAL_DEATH_ATTACK = 2
nwn.SITUATIONAL_NUM = 3

require 'nwn.ctypes.combat'
require 'nwn.ctypes.creature'
require 'nwn.dice'

local ffi = require 'ffi'


ffi.cdef[[
typedef struct Creature {
    uint32_t           type;
    uint32_t           id;
    CNWSCreature      *obj;
    CNWSCreatureStats *stats;
    CombatInformation  ci;
    uint32_t           effective_level;
    uint32_t           first_custom_eff;
} Creature;
]]

local creature_mt = { __index = Creature }
creature_t = ffi.metatype("Creature", creature_mt)

require 'nwn.creature.ability'
require 'nwn.creature.action'
require 'nwn.creature.ai'
require 'nwn.creature.alignment'
require 'nwn.creature.armor_class'
require 'nwn.creature.associate'
require 'nwn.creature.attack_bonus'
require 'nwn.creature.class'
require 'nwn.creature.combat'
require 'nwn.creature.combat_info'
require 'nwn.creature.conceal'
require 'nwn.creature.cutscene'
safe_require 'nwn.creature.damage'
require 'nwn.creature.effects'
require 'nwn.creature.faction'
require 'nwn.creature.feats'
require 'nwn.creature.hp'
require 'nwn.creature.info'
require 'nwn.creature.internal'
require 'nwn.creature.inventory'
require 'nwn.creature.level'
require 'nwn.creature.logger'
require 'nwn.creature.modes'
require 'nwn.creature.pc'
require 'nwn.creature.saves'
require 'nwn.creature.skills'
require 'nwn.creature.spells'
require 'nwn.creature.state'
require 'nwn.creature.talent'
require 'nwn.creature.xp'


--- Briefly displays a string ref as ambient text above targets head.
-- @param strref String ref (therefore text is translated)
-- @param broadcast If this is true then only creatures in the same faction
--  will see the floaty text, and only if they are within range (30 meters). Default: false
function Creature:FloatingStrRef(strref, broadcast)
   nwn.engine.StackPushInteger(broadcast)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushInteger(strref)
   nwn.engine.ExecuteCommand(525, 3)
end

--- Briefly displays ambient text above targets head.
-- @param msg Text to display
-- @param broadcast If this is true then only creatures in the same faction
--  will see the floaty text, and only if they are within range (30 meters). Default: false
function Creature:FloatingText(msg, broadcast)
   nwn.engine.StackPushBoolean(broadcast)
   nwn.engine.StackPushObject(self)
   nwn.engine.StackPushString(msg)
   nwn.engine.ExecuteCommand(526, 3)
end

--- Fully restores a creature
-- Gives this creature the benefits of a rest (restored hitpoints, spells, feats, etc..) 
function Creature:ForceRest()
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(775, 1)
end

--- Determines the door that is blocking a creature.
-- @return Last blocking door encountered by the caller and nwn.OBJECT_INVALID if none
function Creature:GetBlockingDoor()
   nwn.engine.ExecuteCommand(336, 0)
   return nwn.engine.StackPopObject()
end

--- Checks if a creature has triggered an OnEnter event
-- @param subarea Subarea to check 
function Creature:GetIsInSubArea(subarea)
   nwn.engine.StackPushObject(subarea)
   nwn.engine.StackPushObject(self)
   nwn.engine.ExecuteCommand(768, 2)

   return nwn.engine.StackPopBoolean()
end
