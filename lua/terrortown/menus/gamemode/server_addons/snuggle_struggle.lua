CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = "submenu_addons_snuggle_struggle_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_addons_snuggle_struggle")

    form:MakeCheckBox({
        serverConvar = "ttt2_snuggle_struggle_primary_sound",
        label = "label_snuggle_struggle_primary_sound"
    })

    form:MakeCheckBox({
        serverConvar = "ttt2_snuggle_struggle_secondary_sound",
        label = "label_snuggle_struggle_secondary_sound"
    })

    form:MakeCheckBox({
        serverConvar = "ttt2_snuggle_struggle_animation_sound",
        label = "label_snuggle_struggle_animation_sound"
    })

    form:MakeSlider({
        serverConvar = "ttt2_snuggle_struggle_length",
        label = "label_snuggle_struggle_length",
        min = 0,
        max = 30,
        decimal = 0
    })
end