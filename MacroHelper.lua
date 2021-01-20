MainFrame = CreateAceFrame("Macro Helper", "List")
MainFrame:EnableResize(false)

local defaults = {
	global = {
		harm=false, help=false, dead=false, nodead=false,
		target1=nil, target2=nil, target3=nil, stop_cast=false
	}
}

function MacroHelper:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("MacroHelperVars", defaults)
end

function MacroHelper:GetDB(key)
	return self.db.global[key]
end

function MacroHelper:SetDB(key, value)
	self.db.global[key] = value
end

function MacroHelper:OnEnable()
	MainFrame:AddChild(CreateAceLabel("Modifiers", FONT_SIZE_SECTION))
	MainFrame:AddChild(CreateAceVertSpacer(SPACER_Y_TITLE))
	local opt_stop_cast = CreateAceCheckbox("Stop Cast", self:GetDB("stop_cast"))
	MainFrame:AddChild(opt_stop_cast)
	MainFrame:AddChild(CreateAceVertSpacer(SPACER_Y))

	local group_mods = CreateAceSimpleGroup("Flow")
	group_mods:SetFullWidth(true)
	local group_harm = CreateAceSimpleGroup("List")
	group_harm:SetFullWidth(false)
	local group_dead = CreateAceSimpleGroup("List")
	group_dead:SetFullWidth(false)
	local opt_harm = CreateAceCheckbox("Harm (Enemy)", self:GetDB("harm"))
	local opt_help = CreateAceCheckbox("Help (Friendly)", self:GetDB("help"))
	-- MainFrame:AddChild(opt_harm)
	-- MainFrame:AddChild(opt_help)
	group_harm:AddChild(opt_harm)
	group_harm:AddChild(opt_help)
	group_mods:AddChild(group_harm)
	local opt_dead = CreateAceCheckbox("Dead", self:GetDB("dead"))
	local opt_nodead = CreateAceCheckbox("Not dead", self:GetDB("nodead"))
	-- MainFrame:AddChild(opt_dead)
	-- MainFrame:AddChild(opt_nodead)
	group_dead:AddChild(opt_dead)
	group_dead:AddChild(opt_nodead)
	group_mods:AddChild(group_dead)
	MainFrame:AddChild(group_mods)
	MainFrame:AddChild(CreateAceVertSpacer(SPACER_Y))

	local targets = {}
	targets["@target"] = "@Target"
	targets["@mouseover"] = "@Mouse Over"
	targets["@focus"] = "@Focus"
	targets["@cursor"] = "@Cursor"
	MainFrame:AddChild(CreateAceVertSpacer(SPACER_Y_SECTION))
	MainFrame:AddChild(CreateAceLabel("Targets", FONT_SIZE_SECTION))
	MainFrame:AddChild(CreateAceVertSpacer(SPACER_Y_TITLE))
	-- Dropdown1
	local target1 = CreateAceDropdown("1.", 200, targets, self:GetDB("target1"))
	MainFrame:AddChild(target1)
	local target2 = CreateAceDropdown("2.", 200, targets, self:GetDB("target2"))
	MainFrame:AddChild(target2)

	local target3 = CreateAceDropdown("3.", 200, targets, self:GetDB("target3"))
	MainFrame:AddChild(target3)

	-- Callbacks
	opt_stop_cast:SetCallback("OnValueChanged", function(box)
		local v = box:GetValue()
		self:SetDB("stop_cast", v)
	end)
	opt_harm:SetCallback("OnValueChanged", function(box)
		local v = box:GetValue()
		self:SetDB("harm", v)
		if v == true then
			opt_help:SetValue(false)
			self:SetDB("help", false)
		end
		UpdatePreview()
	end)
	opt_help:SetCallback("OnValueChanged", function(box)
		local v = box:GetValue()
		self:SetDB("help", v)
		if v == true then
			opt_harm:SetValue(false)
			self:SetDB("harm", false)
		end
		UpdatePreview()
	end)

	opt_dead:SetCallback("OnValueChanged", function(box)
		local v = box:GetValue()
		self:SetDB("dead", v)
		if v == true then
			opt_nodead:SetValue(false)
			self:SetDB("nodead", false)
		end
		UpdatePreview()
	end)
	opt_nodead:SetCallback("OnValueChanged", function(box)
		local v = box:GetValue()
		self:SetDB("nodead", v)
		if v == true then
			opt_dead:SetValue(false)
			self:SetDB("dead", false)
		end
		UpdatePreview()
	end)

	target1:SetCallback("OnValueChanged", function (dropdown)
		self:SetDB("target1", dropdown:GetValue())
		UpdatePreview()
	end)
	target2:SetCallback("OnValueChanged", function (dropdown)
		self:SetDB("target2", dropdown:GetValue())
		UpdatePreview()
	end)
	target3:SetCallback("OnValueChanged", function (dropdown)
		self:SetDB("target3", dropdown:GetValue())
		UpdatePreview()
	end)

	UpdatePreview()
end

function MacroHelper:TriggerUI()
	if MainFrame:IsShown() then
		MainFrame:Hide()
	else
		MainFrame:Show()
	end
end

function MacroHelper:GenModifiers()
	local str = "exists"
	str = (self:GetDB("harm") and "harm," or "") .. str
	str = (self:GetDB("help") and "help," or "") .. str
	str = (self:GetDB("dead") and "dead," or "") .. str
	str = (self:GetDB("nodead") and "nodead," or "") .. str
	return str
end

function MacroHelper:GenTarget(target, mods)
	mods = mods or self:GenModifiers()
	local tar = self:GetDB(target)
	local str = ""
	if tar ~= nil then
		str = str .. "[" .. tar .. "," .. mods .. "]"
	end
	return str
end

function MacroHelper:GenCastLine(spell)
	spell = spell or "{SPELL}"
	local str = "/cast "
	local mods = self:GenModifiers()
	str = str .. self:GenTarget("target1", mods)
	str = str .. self:GenTarget("target2", mods)
	str = str .. self:GenTarget("target3", mods)
	str = str .. " " .. spell
	return str
end

function MacroHelper:GenStopCastLine()
	return (self:GetDB("stop_cast") and "\n/stopcasting\n" or "")
end

function UpdatePreview()
	local preview = MacroHelper:GenCastLine()
	MainFrame:SetStatusText(preview)
end

function GenMacroBody(spell)
	local str = "#showtooltip " .. spell .. "\n"
	str = str .. MacroHelper:GenStopCastLine()
	str = str .. MacroHelper:GenCastLine(spell)
	return str
end

local onClickSpellBook = function (self, button)
	if not InCombatLockdown() and IsControlKeyDown() and button == "RightButton" then
		local spell = GetSpellBookItemName(
			SpellBook_GetSpellBookSlot(self), SpellBookFrame.bookType
		)
		if spell ~= nil then
			local id = CreateMacro(spell, "INV_MISC_QUESTIONMARK", GenMacroBody(spell), 1)
			MouseOver:Print("Macro created for " .. spell .. "(" .. id .. ")");
		end
	end
end

--Spellbook
for i=1,12,1 do
	local spellLoopVar = _G["SpellButton"..i]
	spellLoopVar:SetScript("OnMouseDown", onClickSpellBook)
end

-- Add the frame as a global variable under the name `MacroHelperFrame`
_G["MacroHelperFrame"] = MainFrame.frame
-- Register the global variable `MacroHelperFrame` as a "special frame"
-- so that it is closed when the escape key is pressed.
tinsert(UISpecialFrames, "MacroHelperFrame")