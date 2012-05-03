﻿--------------------------------------------------------------------------------
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

-- NOTE: Colors MUST be encoded with rgb values, string constants
-- copied from NWScript will NOT work in most cases.

--- Encode a color for RGB values
-- @param r Red
-- @param g Green
-- @param b Blue
function nwn.EncodeColor(r, g, b)
   return "<c".. string.char(r)..string.char(g)..string.char(b)..">"
end

local color = {}

-- The follow are all from the PRC
-- colours for log messages
-- Colors in String messages to PCs
color.BLUE         = nwn.EncodeColor(102, 204, 254)    -- used by saving throws.
color.DARK_BLUE    = nwn.EncodeColor(32, 102, 254)     -- used for electric damage.
color.GRAY         = nwn.EncodeColor(153, 153, 153)    -- used for negative damage.
color.GREEN        = nwn.EncodeColor(32, 254, 32)      -- used for acid damage.
color.LIGHT_BLUE   = nwn.EncodeColor(153, 254, 254)    -- used for the player's name, and cold damage.
color.LIGHT_GRAY   = nwn.EncodeColor(176, 176, 176)    -- used for system messages.
color.LIGHT_ORANGE = nwn.EncodeColor(254, 153, 32)     -- used for sonic damage.
color.LIGHT_PURPLE = nwn.EncodeColor(204, 153, 204)    -- used for a target's name.
color.ORANGE       = nwn.EncodeColor(254, 102, 32)     -- used for attack rolls and physical damage.
color.PURPLE       = nwn.EncodeColor(204, 119, 254)    -- used for spell casts, as well as magic damage.
color.RED          = nwn.EncodeColor(254, 32, 32)      -- used for fire damage.
color.WHITE        = nwn.EncodeColor(254, 254, 254)    -- used for positive damage.
color.YELLOW       = nwn.EncodeColor(254, 254, 32)     -- used for healing, and sent messages.
color.END          = "</c>"

return color