--- Creature module
-- @module creature

local M = require 'solstice.objects.init'
local ffi = require 'ffi'
local C = ffi.C
local ne = require 'solstice.nwn.engine'
local Color = require 'solstice.color'
local fmt = string.format
local Creature = M.Creature

--- PC
-- @section

--- Activates a portal between servers.
-- @param ip DNS name or IP address (and optional port) of new server.
-- @param[opt=""] password Password for login to the destination server.
-- @param[opt=""] waypoint If set, arriving PCs will jump to this waypoint after appearing at
-- the start location.
-- @param[opt=false] seemless If true, the transition will be made 'seamless', and the PC will not
-- get a dialogue box on transfer.
function Creature:ActivatePortal(ip, password, waypoint, seemless)
   ip = ip or ""
   password = password or ""
   waypoint = waypoint or ""

   ne.StackPushBoolean(seemless)
   ne.StackPushString(waypoint)
   ne.StackPushString(password)
   ne.StackPushString(ip)
   ne.StackPushObject(self)
   ne.ExecuteCommand(474, 5)
end

--- Add an entry to a player's Journal. (Create the entry in the Journal Editor first).
-- @param plot The tag of the Journal category (case sensitive).
-- @param state The ID of the Journal entry.
-- @param[opt=true] entire_party If true, the entry is added to the journal of the entire party. (Default: true)
-- @param[opt=false] all_pc If true, the entry will show up in the journal of all PCs in the
-- module.
-- @param[opt=false] allow_override If true, override restriction that nState must be > current
-- Journal Entry.
function Creature:AddJournalQuestEntry(plot, state, entire_party, all_pc, allow_override)
   if entire_party == nil then entire_party = true end

   ne.StackPushBoolean(allow_override)
   ne.StackPushBoolean(all_pc)
   ne.StackPushBoolean(entire_party)
   ne.StackPushObject(self)
   ne.StackPushInteger(state)
   ne.StackPushString(plot)
   ne.ExecuteCommand(367, 6)
end

--- Abruptly kicks a player off a multi-player server.
function Creature:BootPC()
   ne.StackPushObject(self)
   ne.ExecuteCommand(565, 1)
end

--- Changes the current Day/Night cycle for this player to night
-- @param[opt=0] transition_time Time it takes to become night
function Creature:DayToNight(transition_time)
   ne.StackPushFloat(transition_time or 0)
   ne.StackPushObject(self)
   ne.ExecuteCommand(750, 2)
end

--- Reveals the entire map of an area to a player.
-- @param area
-- @param[opt=true] explored true (explored) or false (hidden). Whether the map should
-- be completely explored or hidden.
function Creature:ExploreArea(area, explored)
   if explored == nil then explored = true end

   ne.StackPushBoolean(explored)
   ne.StackPushObject(self)
   ne.StackPushObject(area)
   ne.ExecuteCommand(403, 3)
end

--- Determine if creature is a PC.
function Creature:GetIsPC()
   if not self:GetIsValid() then return false end
   return not (ffi.C.nwn_GetPlayerByID(self.id) == nil)
end

--- Get PC's bic file name.
function Creature:GetBICFileName()
   if not self:GetIsValid() then return "" end
   if not self:GetIsPC() then return "" end
   return ffi.string(C.nwn_GetPCFileName(self.obj))
end

--- Determine if creature is an AI
function Creature:GetIsAI()
   if not self:GetIsValid() then return false end
   return (not self:GetIsPC() and not self:GetIsPossessedFamiliar() and not self:GetIsDMPossessed())
      or self:GetMaster():GetIsValid()
end

--- Removes a journal quest entry from a PCs journal.
-- @param plot The tag for the quest as used in the toolset's Journal Editor.
-- @param[opt=true] entire_party If this is true, the entry will be removed from the journal
-- of everyone in the party.
-- @param[opt=false] all_pc If this is true, the entry will be removed from the journal of
-- everyone in the world.
function Creature:RemoveJournalQuestEntry(plot, entire_party, all_pc)
   if entire_party == nil then entire_party = true end

   ne.StackPushBoolean(all_pc)
   ne.StackPushBoolean(entire_party)
   ne.StackPushObject(self)
   ne.StackPushString(plot)

   ne.ExecuteCommand(368, 4)
end

--- Retrieves the public version of the PC's CD key.
-- @param[opt=false] single_player If set to true, the player's public CD key
-- will be returned when the player is playing in single player mode.
-- Otherwise returns an empty string in single player mode.
function Creature:GetPCPublicCDKey(single_player)
   ne.StackPushBoolean(single_player)
   ne.StackPushObject(self)
   ne.ExecuteCommandUnsafe(369, 2)

   return ne.StackPopString()
end

--- Retrieves the IP address of a PC.
function Creature:GetPCIPAddress()
   ne.StackPushObject(self)
   ne.ExecuteCommandUnsafe(370, 1)

   return ne.StackPopString()
end

--- Retrieves the login name of the player of a PC.
function Creature:GetPCPlayerName()
   ne.StackPushObject(self)
   ne.ExecuteCommandUnsafe(371, 1)

   return ne.StackPopString()
end

--- Changes the current Day/Night cycle for this player to daylight
-- @param transition_time Time it takes for the daylight to fade in (Default: 0)
function Creature:NightToDay(transition_time)
   transition_time = transition_time or 0
   ne.StackPushFloat(transition_time)
   ne.StackPushObject(self)
   ne.ExecuteCommand(751, 2)
end

--- Displays a customizable death panel.
-- @bool[opt=true] respawn_enabled If <em>true</em>, the "Respawn" button will be enabled
-- @bool[opt=true] wait_enabled If <em>true</em>, the "Wait For Help" button will be enabled
-- @param[opt=0] help_strref String reference to display for help.
-- @param[opt=""] help_str String to display for help which appears in the top of the panel.
function Creature:PopUpDeathGUIPanel(respawn_enabled, wait_enabled, help_strref, help_str)
   if respawn_enabled == nil then respawn_enabled = true end
   if wait_enabled == nil then wait_enabled = true end
   help_strref = help_strref or 0
   help_str = help_str or ""

   ne.StackPushString(help_str)
   ne.StackPushInteger(help_strref)
   ne.StackPushBoolean(wait_enabled)
   ne.StackPushBoolean(respawn_enabled)
   ne.StackPushObject(self)
   ne.ExecuteCommand(554, 5)
end

--- Displays a GUI panel to a player.
-- @param gui_panel solstice.gui.PANEL_*
function Creature:PopUpGUIPanel(gui_panel)
   ne.StackPushInteger(gui_panel)
   ne.StackPushObject(self)
   ne.ExecuteCommand(388, 2)
end

--- Sends a message to the PC.
-- @param message Format string, see string.format
-- @param ... Arguments to format string
function Creature:SendMessage(message, ...)
   if select("#", ...) > 0 then
      message = string.format(message, ...)
   end
   ne.StackPushString(message)
   ne.StackPushObject(self)
   ne.ExecuteCommand(374, 2)
end

--- Sends a message to the PC by StrRef.
-- @param strref StrRef of the message to send
function Creature:SendMessageByStrRef(strref)
   ne.StackPushInteger(strref)
   ne.StackPushObject(self)
   ne.ExecuteCommand(717, 2)
end

--- Causes a creature to like a PC.
-- @param target Target to alter the feelings of.
function Creature:SetPCLike(target)
   ne.StackPushObject(target)
   ne.StackPushObject(self)
   ne.ExecuteCommand(372, 2)
end

--- Sets that a player dislikes a creature (or object).
-- @param target The creature that dislikes the PC (and the PC dislike it).
function Creature:SetPCDislike(target)
   ne.StackPushObject(target)
   ne.StackPushObject(self)
   ne.ExecuteCommand(373, 2)
end

--- Make a panel button in the player's client start or stop flashing.
-- button solstice.gui.BUTTON_*
-- enable_flash true to flash, false to stop flashing
function Creature:SetPanelButtonFlash(button, enable_flash)
   ne.StackPushInteger(enable_flash);
   ne.StackPushInteger(button);
   ne.StackPushObject(self);
   ne.ExecuteCommand(521, 3);
end

--- Sends a chat message
-- @param channel Channel the message to send message on.
-- @param from Sender.
-- @param message Text to send.
function Creature:SendChatMessage(channel, from, message)
   if not from:GetIsValid() then return end
   if string.find(message, "\xAC") then return end
   if channel == 4 and not self:GetIsValid() then return end

   from:SetLocalString("NWNX!CHAT!SPEAK",
                       fmt("%x\xAC%x\xAC%d\xAC%s", from.id, self.id, channel, message))
end

--- Simple wrapper around solstice.chat.SendChatMessage
-- that sends a server message to a player.
-- @param message Format string, see string.format
-- @param ... Arguments to format string
function Creature:SendServerMessage(message)
   if not self:GetIsValid() then return end
   self:SendChatMessage(5, self, message)
end

--- Send error message on server channel.
-- @param message Format string, see string.format
-- @param ... Arguments to format string
function Creature:ErrorMessage(message, ...)
   if select("#", ...) > 0 then
      self:SendServerMessage(Color.RED .. string.format(message, ...) .. "</c>")
   else
      self:SendServerMessage(Color.RED .. message .. "</c>")
   end
end

--- Send success message on server channel.
-- @param message Format string, see string.format
-- @param ... Arguments to format string
function Creature:SuccessMessage(message, ...)
   if select("#", ...) > 0 then
      self:SendServerMessage(Color.GREEN .. string.format(message, ...) .. "</c>")
   else
      self:SendServerMessage(Color.GREEN .. message .. "</c>")
   end
end