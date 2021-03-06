--- Store
-- @license GPL v2
-- @copyright 2011-2013
-- @author jmd ( jmd2028 at gmail dot com )
-- @module store

local ffi = require 'ffi'
local NWE = require 'solstice.nwn.engine'

local M = require 'solstice.objects.init'
local Store = inheritsFrom({}, M.Object)
M.Store = Store

local Signal = require 'solstice.external.signal'
Store.signals = {
  OnOpen = Signal.signal(),
  OnClose = Signal.signal(),
}

function Store.new(id)
   return setmetatable({
         id = id,
         type = OBJECT_TRUETYPE_STORE
      },
      { __index = M.Store })
end

--- Class Store
-- @section store

--- Get store's gold
function M.Store:GetGold()
   if not self:GetIsValid() then return 0 end
   return self.obj.st_gold
end

--- Get store's identify price
function M.Store:GetIdentifyCost()
   if not self:GetIsValid() then return 0 end
   return self.obj.st_id_price
end

--- Get store's max buy price
function M.Store:GetMaxBuyPrice()
   if not self:GetIsValid() then return 0 end
   return self.obj.st_max_buy
end

--- Open store
-- @param pc PC to open the store for.
-- @param up Bonus markup
-- @param down Bonus markdown
function M.Store:Open(pc, up, down)
   NWE.StackPushInteger(down)
   NWE.StackPushInteger(up)
   NWE.StackPushObject(pc)
   NWE.StackPushObject(self)
   NWE.ExecuteCommand(378, 4)
end

--- Set amount of gold a store has.
function M.Store:SetGold(gold)
   if not self:GetIsValid() then return end
   self.obj.st_gold = gold
end

--- Set the price to identify items.
function M.Store:SetIdentifyCost(val)
   if not self:GetIsValid() then return end
   self.obj.st_id_price = val
end

--- Set the max buy price.
function M.Store:SetMaxBuyPrice(val)
   if not self:GetIsValid() then return end
   self.obj.st_max_buy = val
end
