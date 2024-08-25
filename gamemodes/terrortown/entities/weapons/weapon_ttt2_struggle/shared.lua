if SERVER then
    AddCSLuaFile()
    resource.AddFile("materials/vgui/ttt/weapon_struggle.vmt")
end

SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_EQUIP1
SWEP.InLoadoutFor = nil
SWEP.CanBuy = {ROLE_TRAITOR}
SWEP.LimitedStock = true
SWEP.Icon = "vgui/ttt/weapon_struggle"
SWEP.EquipMenuData = {
    type = "item_weapon",
    name = "ttt2_struggle_name",
    desc = "ttt2_struggle_desc"
}

SWEP.Author = "mexikoedi"
SWEP.PrintName = "Struggle"
SWEP.Contact = "Steam"
SWEP.Instructions = "Left click to arrest and kill the enemy and secondary attack to play random sounds."
SWEP.Purpose = "Taunt and arrest and kill your enemies."
SWEP.ViewModelFOV = 82
SWEP.ViewModelFlip = true
SWEP.NoSights = false
SWEP.AllowDrop = false
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.AdminSpawnable = false
SWEP.AutoSpawnable = false
SWEP.Primary.Sound = Sound("vo/novaprospekt/al_holdon.wav")
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = -1
SWEP.Primary.Delay = 3
SWEP.Primary.Distance = 100
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 3
SWEP.ViewModel = Model("models/weapons/v_hands.mdl")
SWEP.StruggleLength = GetConVar("ttt2_struggle_length"):GetInt()
SWEP.SoundDelay = 1.5
local animation = {
    ["struggle"] = {
        ["ValveBiped.Bip01_Pelvis"] = {
            pos = Vector(0, 0, -23)
        },
        ["ValveBiped.Bip01_R_Calf"] = {
            ang = Angle(0, 120, 0)
        },
        ["ValveBiped.Bip01_L_Calf"] = {
            ang = Angle(0, 120, 0)
        },
        ["ValveBiped.Bip01_R_Thigh"] = {
            ang = Angle(0, -30, 0)
        },
        ["ValveBiped.Bip01_L_Thigh"] = {
            ang = Angle(0, -30, 0)
        },
        ["ValveBiped.Bip01_R_Foot"] = {
            ang = Angle(0, 30, 0)
        },
        ["ValveBiped.Bip01_L_Foot"] = {
            ang = Angle(0, 30, 0)
        },
        ["ValveBiped.Bip01_R_UpperArm"] = {
            ang = Angle(30, 0, 90)
        },
        ["ValveBiped.Bip01_L_UpperArm"] = {
            ang = Angle(-30, 0, -90)
        },
        ["ValveBiped.Bip01_R_ForeArm"] = {
            ang = Angle(0, -130, 0)
        },
        ["ValveBiped.Bip01_L_ForeArm"] = {
            ang = Angle(0, -120, 20)
        }
    }
}

local sounds = {"bot/im_pinned_down.wav", "bot/oh_man.wav", "bot/pain4", "bot/pain5", "bot/pain8", "bot/pain9", "bot/pain10", "bot/stop_it.wav", "bot/help.wav", "bot/i_could_use_some_help.wav", "bot/i_could_use_some_help_over_here.wav", "bot/they_got_me_pinned_down_here.wav", "bot/need_help.wav", "bot/yikes.wav", "bot/noo.wav", "hostage/hpain/hpain1.wav", "hostage/hpain/hpain2.wav", "hostage/hpain/hpain3.wav", "hostage/hpain/hpain4.wav", "hostage/hpain/hpain5.wav", "hostage/hpain/hpain6.wav", "vo/k_lab/kl_ahhhh.wav",}
local sounds2 = {"bot/where_are_you_hiding.wav", "vo/NovaProspekt/al_whereareyou03.wav", "vo/Citadel/al_wonderwhere.wav",}
local sounds3 = {"physics/body/body_medium_break2.wav", "physics/body/body_medium_break3.wav", "physics/body/body_medium_break4.wav", "physics/body/body_medium_impact_hard1.wav", "physics/body/body_medium_impact_hard2.wav", "physics/body/body_medium_impact_hard3.wav", "physics/body/body_medium_impact_hard4.wav", "physics/body/body_medium_impact_hard5.wav", "physics/body/body_medium_impact_hard6.wav",}
function SWEP:Initialize()
    if CLIENT then self:AddTTT2HUDHelp("ttt2_struggle_help1", "ttt2_struggle_help2") end
end

if SERVER then
    -- damage/inflictor code
    local function InstantDamage(ply, damage, attacker, inflictor)
        local dmg = DamageInfo()
        dmg:SetDamage(damage or 500)
        dmg:SetAttacker(attacker or ply)
        dmg:SetDamageForce(ply:GetAimVector())
        dmg:SetDamagePosition(ply:GetPos())
        dmg:SetDamageType(DMG_GENERIC)
        if inflictor then dmg:SetInflictor(inflictor) end
        ply:TakeDamageInfo(dmg)
    end

    local function success(victim, owner, animationTimerString, soundTimerString)
        if IsValid(owner) then
            if owner:Health() < 100 then owner:SetHealth(100) end
            owner:RemoveItem("item_ttt_disguiser")
            owner:SetJumpPower(160)
            owner:SetCrouchedWalkSpeed(0.3)
            owner:SetRunSpeed(220)
            owner:SetWalkSpeed(220)
            owner:SetMaxSpeed(220)
            owner:GodDisable()
            -- give loadout of owner
            owner:RestoreCachedWeapons()
            -- remove weapon and select last weapon
            owner:StripWeapon("weapon_ttt2_struggle")
        end

        if IsValid(victim) then
            victim:Freeze(false)
            local bonecount = victim:GetBoneCount()
            for i = 0, bonecount do
                victim:ManipulateBonePosition(i, Vector(0, 0, 0))
                victim:ManipulateBoneAngles(i, Angle(0, 0, 0))
            end

            -- give loadout of victim
            victim:RestoreCachedWeapons()
            -- create damage
            InstantDamage(victim, 500, owner, ents.Create("weapon_ttt2_struggle"))
        end

        -- removing timers
        timer.Remove(animationTimerString)
        timer.Remove(soundTimerString)
        timer.Remove("itemremoval")
    end

    function SWEP:PrimaryAttack()
        -- set up positioning stuff and owner/victim checks
        local owner = self:GetOwner()
        if GetRoundState() ~= ROUND_ACTIVE then
            owner:ChatPrint("Round is not active, you can't use this weapon!")
            return
        end

        -- disable usage if disguiser is already bought
        local victim = owner:GetEyeTrace().Entity
        if not IsValid(victim) or victim:IsNPC() or not victim:IsPlayer() or not victim:IsActive() then return end
        if owner:HasEquipmentItem("item_ttt_disguiser") then
            owner:ChatPrint("You can't use this weapon with a disguiser!")
            return
        end

        local positionOwner = owner:GetPos()
        local positionVictim = victim:GetPos()
        if positionVictim:Distance(positionOwner) > self.Primary.Distance then return end
        if GetConVar("ttt2_struggle_primary_sound"):GetBool() then owner:EmitSound(self.Primary.Sound) end
        -- set owner to godmode with no movement + hide his name/give item
        owner:GodEnable()
        owner:SetJumpPower(1)
        owner:SetCrouchedWalkSpeed(0.1)
        owner:SetRunSpeed(1)
        owner:SetWalkSpeed(1)
        owner:SetMaxSpeed(1)
        owner:GiveEquipmentItem("item_ttt_disguiser")
        owner:ConCommand("ttt_toggle_disguise")
        -- remove loadout from both players
        owner:CacheAndStripWeapons()
        victim:CacheAndStripWeapons()
        -- disable victim movement
        victim:Freeze(true)
        -- animation, sound and multiple checks to ensure proper functionality
        local animationTimerString = "StruggleAnimation_" .. (owner:SteamID64() or "SINGLEPLAYER")
        timer.Create(animationTimerString, 0.1, 0, function()
            if not victim:IsValid() then return end
            if GetConVar("ttt2_struggle_animation_sound"):GetBool() and math.random(5) == 3 then victim:EmitSound(sounds3[math.random(#sounds3)]) end
            for bone, params in pairs(animation["struggle"]) do
                local boneid = victim:LookupBone(bone)
                if boneid then
                    victim:ManipulateBonePosition(boneid, params.pos or Vector(0, 0, 0))
                    victim:ManipulateBoneAngles(boneid, params.ang or Angle(0, 0, 0))
                end
            end
        end)

        local soundTimerString = "StruggleSound_" .. (owner:SteamID64() or "SINGLEPLAYER")
        if GetConVar("ttt2_struggle_animation_sound"):GetBool() then
            timer.Create(soundTimerString, self.SoundDelay, 0, function()
                if not victim:IsValid() then return end
                victim:EmitSound(sounds[math.random(#sounds)])
            end)
        end

        -- check health/give health + letting the owner move again with no godmode + give loadout to both players + deal damage + remove timers
        timer.Simple(self.StruggleLength, function() success(victim, owner, animationTimerString, soundTimerString) end)
        -- deactivate disguiser
        timer.Create("itemremoval", self.StruggleLength - 0.5, 0, function() owner:ConCommand("ttt_toggle_disguise") end)
    end

    SWEP.NextSecondaryAttack = 0
    function SWEP:SecondaryAttack()
        if self.NextSecondaryAttack > CurTime() then return end
        self.NextSecondaryAttack = CurTime() + self.Secondary.Delay
        local owner = self:GetOwner()
        -- set up random sounds
        if GetConVar("ttt2_struggle_secondary_sound"):GetBool() then owner:EmitSound(sounds2[math.random(#sounds2)]) end
    end
end

if CLIENT then
    function SWEP:AddToSettingsMenu(parent)
        local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")
        form:MakeCheckBox({
            serverConvar = "ttt2_struggle_primary_sound",
            label = "label_struggle_primary_sound"
        })

        form:MakeCheckBox({
            serverConvar = "ttt2_struggle_secondary_sound",
            label = "label_struggle_secondary_sound"
        })

        form:MakeCheckBox({
            serverConvar = "ttt2_struggle_animation_sound",
            label = "label_struggle_animation_sound"
        })

        form:MakeSlider({
            serverConvar = "ttt2_struggle_length",
            label = "label_struggle_length",
            min = 0,
            max = 30,
            decimal = 0
        })
    end
end