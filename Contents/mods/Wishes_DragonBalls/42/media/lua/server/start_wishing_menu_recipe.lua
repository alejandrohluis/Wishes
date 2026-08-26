local Recipe = RecipeCodeOnCreate;

local function startWishingMenu(player, wishStyle)
    local window = WishingWindows[player];
    window:initialise(wishStyle);
    window:startMenu();
end

function Recipe.SummonShenron(craftRecipeData, player)
    local effects = WishEffects;
    local options = WishOptions;
    local sandbox = SandboxVars.Wishes

    local wishes = {
        -- modify trait
        { label = "Get/Remove a Trait",                isEnabled = sandbox.DB_Wish_Trait,             effect = effects.modifyTrait,       options = options.getTraits },
        -- level up skill until
        { label = "Level up your skill up to level 5", isEnabled = sandbox.DB_Wish_SkillLevelUpUntil, effect = effects.skillLevelUpUntil, options = options.getSkills },
        -- level up skill once
        { label = "Level up your skill once",          isEnabled = sandbox.DB_Wish_SkillLevelUp,      effect = effects.skillLevelUpOnce,  options = options.getSkills },
        -- heal injuries
        { label = "Heal all injuries",                 isEnabled = sandbox.DB_Wish_HealInjury,        effect = effects.healUp },
        -- cure sickness
        { label = "Cure all sickness",                 isEnabled = sandbox.DB_Wish_HealSickness,      effect = effects.cureSickness },
        -- ideal weight
        { label = "Ideal Weight",                      isEnabled = sandbox.DB_Wish_Weight,            effect = effects.setIdealWeight },
        -- extra wishes
        { label = "Upgrade Dragon Balls",              isEnabled = sandbox.DB_Wish_MoreWishes,        effect = effects.improveDragonBalls },
        -- potential unlock
        { label = "Unlock your body's potential",      isEnabled = sandbox.DB_Wish_UnlockPotential,   effect = effects.potentialUnlock },
        -- teleportFriend
        { label = "Teleport a friend or fiend",        isEnabled = sandbox.DB_Wish_Teleport,          effect = effects.teleportFriend },
        -- inmortality
        { label = "Inmortality!",                      isEnabled = sandbox.DB_Wish_Inmortality,       effect = effects.inmortality },
    };
    local wishAmount = sandbox.DB_Setting_MaxWishes;

    local wishStyle = WishStyle:new("Shenlong", wishes, wishAmount, "media/textures/portrait/shenlong.png")
    startWishingMenu(player, wishStyle);
end

-- deseos pedidos en dbz ; (!)[deseo] posibles deseos
-- calzones                     (!)[darle calzones]
-- revivir a un ser

-- conocimiento de como obtener SSG
-- plata

-- helado                       (!)[darle helado]

-- que shen long se vaya        (!)[retirar a shenron]

-- inmortalidad                 (!)[godmode temporal]

-- teletransportacion           (!)[tpear a otro jugador a vos]

-- potencial desbloqueado       (!)[que las stats fisicas tengan mas XP]

-- reparar potara               (!)[reparar un item]