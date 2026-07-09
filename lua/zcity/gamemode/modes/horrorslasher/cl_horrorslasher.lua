local MODE = MODE
MODE.name = "Horror Slasher"

 MODE.Objectives = {
    slashervictim = {
        objective = "Good luck...",
        name = "a Victim",
        color1 = Color(0,120,190),
        color2 = Color(0,120,190)
    },

    leatherface = {
        objective = "GITT EM! GITT EM!",
        name = "Leatherface",
        color1 = Color(190,0,0),
        color2 = Color(190,0,0)
    },

    michael = {
        objective = "...",
        name = "Michael Myers",
        color1 = Color(190,0,0),
        color2 = Color(190,0,0)
    },

    ghost = {
        objective = "The faceless mask",
        name = "The Ghost",
        color1 = Color(190,0,0),
        color2 = Color(190,0,0)
    },

    jason = {
        objective = "Ki ki ki ma ma ma.",
        name = "Jason Voorhees",
        color1 = Color(190,0,0),
        color2 = Color(190,0,0)
    },

    tommyjarvis = {
        objective = "Kill that Psycho!",
        name = "Tommy Jarvis",
        color1 = Color(300,300,300),
        color2 = Color(300,300,300)
    }
}

local fade = 0

net.Receive("Slasher_start", function()
    StartTime = CurTime()
    fade = 0

    if ACSound then
        ACSound:Stop()
        ACSound = nil
    end

    sound.PlayFile("sound/1music.wav", "noplay", function(station)
        if IsValid(station) then
            station:SetVolume(6)
            station:Play()
            ACSound = station
        end
    end)
end)

function MODE:HUDPaint()
    if lply:Team() == TEAM_SPECTATOR then return end

    local hideEnd = GetGlobalFloat("SlasherHideEnd", 0)
    if hideEnd > CurTime() then
        local color = Color(255 * -math.sin(CurTime() * 3), 25, 255 * math.sin(CurTime() * 3))
        local text = "Hide! The Slasher hunts in: " .. string.FormattedTime(hideEnd - CurTime(), "%02i:%02i")

        draw.SimpleText(text, "ZB_HomicideMedium", sw * 0.5, sh * 0.95, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(text, "ZB_HomicideMedium", (sw * 0.5) - 2, (sh * 0.95) - 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if StartTime + 12 < CurTime() then return end

    fade = Lerp(FrameTime(), fade, math.Clamp(StartTime + 5 - CurTime(), -2, 2))

    draw.SimpleText(
        "Horror Slasher",
        "ZB_HomicideMediumLarge",
        sw * 0.5,
        sh * 0.1,
        Color(0,162,255,255 * fade),
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )

    local RoleData

    if lply:GetNWBool("IsTommy", false) then
    RoleData = MODE.Objectives.tommyjarvis

elseif lply:Team() == 1 then
    local stype = lply:GetNWString("SlasherType")

    if stype == "Leatherface" then
        RoleData = MODE.Objectives.leatherface

    elseif stype == "Michael" then
        RoleData = MODE.Objectives.michael

    elseif stype == "Ghost" then
        RoleData = MODE.Objectives.ghost

    elseif stype == "Jason" then
        RoleData = MODE.Objectives.jason

    else
        RoleData = MODE.Objectives.jason
    end

else
    RoleData = MODE.Objectives.slashervictim
end

    local RoleColor = table.Copy(RoleData.color1)
    RoleColor.a = 255 * fade

    draw.SimpleText(
        "You are "..RoleData.name,
        "ZB_HomicideMediumLarge",
        sw * 0.5,
        sh * 0.5,
        RoleColor,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )

    local ObjColor = table.Copy(RoleData.color2)
    ObjColor.a = 255 * fade

    draw.SimpleText(
        RoleData.objective,
        "ZB_HomicideMedium",
        sw * 0.5,
        sh * 0.9,
        ObjColor,
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )
end

net.Receive("Slasher_roundend",function()
    CreateEndMenu()
end)
 
local colGray = Color(85,85,85,255)
local colRed = Color(130,10,10)
local colRedUp = Color(160,30,30)
 
local colBlue = Color(10,10,160)
local colBlueUp = Color(40,40,160)
local col = Color(255,255,255,255)
 
local colSpect1 = Color(75,75,75,255)
local colSpect2 = Color(255,255,255)
 
local colorBG = Color(55,55,55,255)
local colorBGBlacky = Color(40,40,40,255)
 
local blurMat = Material("pp/blurscreen")
local Dynamic = 0
 
BlurBackground = BlurBackground or hg.DrawBlur
 
if IsValid(hmcdEndMenu) then
    hmcdEndMenu:Remove()
    hmcdEndMenu = nil
end
 
CreateEndMenu = function()
	if IsValid(hmcdEndMenu) then
		hmcdEndMenu:Remove()
		hmcdEndMenu = nil
	end
	Dynamic = 0
	hmcdEndMenu = vgui.Create("ZFrame")
 
    surface.PlaySound("ambient/alarms/warningbell1.wav")
 
	local sizeX,sizeY = ScrW() / 2.5 ,ScrH() / 1.2
	local posX,posY = ScrW() / 1.3 - sizeX / 2,ScrH() / 2 - sizeY / 2
 
	hmcdEndMenu:SetPos(posX,posY)
	hmcdEndMenu:SetSize(sizeX,sizeY)
	--hmcdEndMenu:SetBackgroundColor(colGray)
	hmcdEndMenu:MakePopup()
	hmcdEndMenu:SetKeyboardInputEnabled(false)
	hmcdEndMenu:ShowCloseButton(false)
 
	local closebutton = vgui.Create("DButton",hmcdEndMenu)
	closebutton:SetPos(5,5)
	closebutton:SetSize(ScrW() / 20,ScrH() / 30)
	closebutton:SetText("")
	
	closebutton.DoClick = function()
		if IsValid(hmcdEndMenu) then
			hmcdEndMenu:Close()
			hmcdEndMenu = nil
		end
	end
 
	closebutton.Paint = function(self,w,h)
		surface.SetDrawColor( 122, 122, 122, 255)
        surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
		surface.SetFont( "ZB_InterfaceMedium" )
		surface.SetTextColor(col.r,col.g,col.b,col.a)
		local lengthX, lengthY = surface.GetTextSize("Close")
		surface.SetTextPos( lengthX - lengthX/1.1, 4)
		surface.DrawText("Close")
	end
 
    hmcdEndMenu.Paint = function(self,w,h)
		BlurBackground(self)
 
		surface.SetFont( "ZB_InterfaceMediumLarge" )
		surface.SetTextColor(col.r,col.g,col.b,col.a)
		local lengthX, lengthY = surface.GetTextSize("Players:")
		surface.SetTextPos(w / 2 - lengthX/2,20)
		surface.DrawText("Players:")
 
		surface.SetDrawColor( 255, 0, 0, 128)
        surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
	end
	-- PLAYERS
	local DScrollPanel = vgui.Create("DScrollPanel", hmcdEndMenu)
	DScrollPanel:SetPos(10, 80)
	DScrollPanel:SetSize(sizeX - 20, sizeY - 90)
	function DScrollPanel:Paint( w, h )
		BlurBackground(self)
 
		surface.SetDrawColor( 255, 0, 0, 128)
        surface.DrawOutlinedRect( 0, 0, w, h, 2.5 )
	end
 
	for i,ply in player.Iterator() do
		if ply:Team() == TEAM_SPECTATOR then continue end
		local but = vgui.Create("DButton",DScrollPanel)
		but:SetSize(100,50)
		but:Dock(TOP)
		but:DockMargin( 8, 6, 8, -1 )
		but:SetText("")
		but.Paint = function(self,w,h)
            local col1 = (ply:Alive() and colRed) or colGray
            local col2 = (ply:Alive() and colRedUp) or colSpect1
			surface.SetDrawColor(col1.r,col1.g,col1.b,col1.a)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(col2.r,col2.g,col2.b,col2.a)
			surface.DrawRect(0,h/2,w,h/2)
 
            local col = ply:GetPlayerColor():ToColor()
			surface.SetFont( "ZB_InterfaceMediumLarge" )
			local lengthX, lengthY = surface.GetTextSize( ply:GetPlayerName() or "He quited..." )
			
			surface.SetTextColor(0,0,0,255)
			surface.SetTextPos(w / 2 + 1,h/2 - lengthY/2 + 1)
			surface.DrawText(ply:GetPlayerName() or "He quited...")
 
			surface.SetTextColor(col.r,col.g,col.b,col.a)
			surface.SetTextPos(w / 2,h/2 - lengthY/2)
			surface.DrawText(ply:GetPlayerName() or "He quited...")
 
            
			local col = colSpect2
			surface.SetFont( "ZB_InterfaceMediumLarge" )
			surface.SetTextColor(col.r,col.g,col.b,col.a)
			local lengthX, lengthY = surface.GetTextSize( ply:GetPlayerName() or "He quited..." )
			surface.SetTextPos(15,h/2 - lengthY/2)
			surface.DrawText((ply:Name() .. (not ply:Alive() and " - died" or "")) or "He quited...")
 
			surface.SetFont( "ZB_InterfaceMediumLarge" )
			surface.SetTextColor(col.r,col.g,col.b,col.a)
			local lengthX, lengthY = surface.GetTextSize( ply:Frags() or "He quited..." )
			surface.SetTextPos(w - lengthX -15,h/2 - lengthY/2)
			surface.DrawText(ply:Frags() or "He quited...")
		end
 
		function but:DoClick()
			if ply:IsBot() then chat.AddText(Color(255,0,0), "no, you can't") return end
			gui.OpenURL("https://steamcommunity.com/profiles/"..ply:SteamID64())
		end
 
		DScrollPanel:AddItem(but)
	end
 
	return true
end
 
function MODE:RoundStart()
    if IsValid(hmcdEndMenu) then
        hmcdEndMenu:Remove()
        hmcdEndMenu = nil
    end
end