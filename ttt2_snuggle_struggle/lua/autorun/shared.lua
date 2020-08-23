if CLIENT then
    // Use string or string.format("%.f",<steamid64>) 
    // addon dev emblem in scoreboard
    hook.Add( "TTT2FinishedLoading" , "TTT2RegistermexikoediAddonDev" , function( )
        AddTTT2AddonDev( "76561198279816989" )
    end )
end
