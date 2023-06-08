require "XpSystem/XpUpdate"

local loggingOnWeapon = require "loggingOnWeaponHitTree"

Events.OnWeaponHitTree.Add(loggingOnWeapon.hit)