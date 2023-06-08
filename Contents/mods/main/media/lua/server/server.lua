require "XpSystem/XpUpdate"

--LuaEventManager.triggerEvent("OnWeaponHitTree", var1, var2)

-- when you or a npc try to hit a tree
function xpUpdate.OnWeaponHitTree(owner, weapon)
    if weapon and weapon:getType() ~= "BareHands" then
        owner:getXp():AddXP(Perks.Strength, 2)
    end
end
Events.OnWeaponHitTree.Add(xpUpdate.OnWeaponHitTree)


-- when you or a npc try to hit something
function xpUpdate.onWeaponHitXp(owner, weapon, hitObject, damage)

    print("hitObject: "..tostring(hitObject))
    
    local isShove = false
    if hitObject:isOnFloor() == false and weapon:getType() == "BareHands" then
        isShove = true
    end
    local exp = 1 * damage * 0.9
    if exp > 3 then
        exp = 3
    end
    -- add info of favourite weapon
    local modData = owner:getModData()
    if isShove == false then
        if modData["Fav:"..weapon:getName()] == nil then
            modData["Fav:"..weapon:getName()] = 1
        else
            modData["Fav:"..weapon:getName()] = modData["Fav:"..weapon:getName()] + 1
        end
    end
    -- if you sucessful swing your non ranged weapon
    if owner:getStats():getEndurance() > owner:getStats():getEndurancewarn() and not weapon:isRanged() then
        owner:getXp():AddXP(Perks.Fitness, 1)
    end
    -- we add xp depending on how many target you hit
    if not weapon:isRanged() and owner:getLastHitCount() > 0 then
        owner:getXp():AddXP(Perks.Strength, owner:getLastHitCount())
    end
    -- add xp for ranged weapon
    if weapon:isRanged() then
        local xp = owner:getLastHitCount()
        if owner:getPerkLevel(Perks.Aiming) < 5 then
            xp = xp * 2.7
        end
        owner:getXp():AddXP(Perks.Aiming, xp)
    end
    -- add either blunt or blade xp (blade xp's perk name is Axe)
    if owner:getLastHitCount() > 0 and not weapon:isRanged() then
        if weapon:getScriptItem():getCategories():contains("Axe") then
            owner:getXp():AddXP(Perks.Axe, exp)
        end
        if weapon:getScriptItem():getCategories():contains("Blunt") then
            owner:getXp():AddXP(Perks.Blunt, exp)
        end
        if weapon:getScriptItem():getCategories():contains("Spear") then
            owner:getXp():AddXP(Perks.Spear, exp)
        end
        if weapon:getScriptItem():getCategories():contains("LongBlade") then
            owner:getXp():AddXP(Perks.LongBlade, exp)
        end
        if weapon:getScriptItem():getCategories():contains("SmallBlade") then
            owner:getXp():AddXP(Perks.SmallBlade, exp)
        end
        if weapon:getScriptItem():getCategories():contains("SmallBlunt") then
            owner:getXp():AddXP(Perks.SmallBlunt, exp)
        end
    end
end

Events.OnWeaponHitXp.Add(xpUpdate.onWeaponHitXp)