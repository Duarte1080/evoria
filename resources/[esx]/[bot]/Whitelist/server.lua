----------------------------------------
--- Discord Whitelist, Made by FAXES ---
----------------------------------------

--- Config ---
notWhitelisted = "Vous devez rejoindre le discord pour jouer sur le serveur" -- Message displayed when they are not whitelist with the role
noDiscord = "Vous devez rejoindre le discord pour jouer sur le serveur" -- Message displayed when discord is not found

roles = { -- Role nickname(s) needed to pass the whitelist
    "✔️│Withelis",
}

--- Code ---

AddEventHandler("playerConnecting", function(name, setCallback, deferrals)
    local src = source
    deferrals.defer()
    deferrals.update("Vérification en cours")

    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
    end

    if identifierDiscord then
        for i = 1, #roles do
            if exports.discord_perms:IsRolePresent(src, roles[i]) then
                deferrals.done()
            elseif exports.discord_perms:IsRolePresent2(src, roles[i]) then
                deferrals.done()
            else
                deferrals.done(notWhitelisted)
            end
        end
    else
        deferrals.done(noDiscord)
    end
end)