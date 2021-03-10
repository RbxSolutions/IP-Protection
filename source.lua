getgenv().IpProtection = true
spoofedIP = "0.0.0.0"


IP_Trackers = {
    "https://v4.ident.me",
    "https://api.ipify.org",
    "https://httpbin.org/get"
}

local old
old = hookfunction(game.HttpGet, function(self, url)
        -- Checking if the protection is enabled
    if type(url) == "string" and getgenv().IpProtection then
        -- Checks if the URL is in the IP_Trackers table
        if table.find(IP_Trackers, url) then
            warn(url,"tried to log your IP. It was protected.")
            return spoofedIP -- Spoofed IP
        end
    end
    return old(self, url)
end)

local oldSyn
oldSyn = hookfunction((syn and syn.request or request),function(a,b)
    if type(a) == "table" and getgenv().IpProtection then
        for i,v in pairs(a) do
            if i == "Url" and table.find(IP_Trackers, v) then
                warn(v,"tried to log your IP. It was protected.")
                return {
                    StatusCode = 200,
                    Body = spoofedIP
                }
            end
        end
    end
    return oldSyn(a,b)
end)
