local loggingOnWeapon = {}


---There is no getter for weaponLength so we have to read from the classes
loggingOnWeapon.lengths = {}
---@param weapon HandWeapon|InventoryItem
function loggingOnWeapon.grabLengthOf(weapon)

    local moduleDotType = weapon:getFullType()
    local storedLength = loggingOnWeapon.lengths[moduleDotType]
    if storedLength then return storedLength end

    local numClassFields = getNumClassFields(weapon)
    for i = 0, numClassFields - 1 do
        ---@type Field
        local javaField = getClassField(weapon, i)
        if javaField then
            if tostring(javaField) == "public float zombie.inventory.types.HandWeapon.WeaponLength" then
                local value = getClassFieldVal(weapon, javaField)
                loggingOnWeapon.lengths[moduleDotType] = value
                return value
            end
        end
    end
end


---@param owner IsoGameCharacter|IsoPlayer|IsoMovingObject
---@param weapon HandWeapon|InventoryItem
function loggingOnWeapon.hit(owner, weapon)

    if weapon:getScriptItem():getCategories():contains("Axe") then
        owner:getXp():AddXP(Perks.Logging, 2.5)

        ---@type IsoGridSquare
        local square, tree = owner:getSquare()
        local wepLength = loggingOnWeapon.grabLengthOf(weapon) + 0.5
        local ownerForwardDir = owner:getForwardDirection()
        local ownerX, ownerY = owner:getX(), owner:getY()
        local attackX, attackY = ownerForwardDir:getX(), ownerForwardDir:getY()

        for i=1, 10, 1 do
            local iDiv = i/10

            ---@type IsoGridSquare
            local attackSquare = getSquare(ownerX+attackX*wepLength*iDiv, ownerY+attackY*wepLength*iDiv, owner:getZ())
            if attackSquare then
                square = attackSquare
                ---@type IsoTree|IsoObject
                tree = square:getTree()
                if tree then
                    local treeSquare = tree:getSquare()
                    if treeSquare then
                        square = treeSquare
                    end
                end
            end
        end

        if not tree then

            local loggingLevel = owner:getPerkLevel(Perks.Logging)
            local success = 20 + (loggingLevel*2)
            local drops = {"loggingChucked.TreeBark", "loggingChucked.JarSap"}

            for drop=1, #drops do
                if ZombRand(100) < success then
                    square:AddWorldInventoryItem(drops[drop], 0, 0, 0)
                end
            end

            --if getDebug() then print("no tree found after onTreeHit - assumed felled?") end
        end
        --add extra drops here
        --square:AddWorldInventoryItem("Base.Log", 0, 0, 0)
    end
end

return loggingOnWeapon