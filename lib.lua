
function SetupCheckBox(anchor, x, y, size)
	size = size or BOX_SIZE
	local box = CreateFrame("CheckButton", "player", MainFrame, "ChatConfigCheckButtonTemplate")
	box:SetPoint("TOPLEFT", anchor, "TOPLEFT", x, y)
	box:SetText("Checkbox")
	box:SetWidth(size)
	box:SetHeight(size)
	return box
end

function CreateString(anchor, text, x, y, size)
	size = size or FONT_SIZE
	local str = MainFrame:CreateFontString(text .. " string")
	str:SetFont("Fonts\\FRIZQT__.TTF", size)
	str:SetText(text)
	str:SetPoint("LEFT", anchor, "TOPLEFT", x, y)
	return str
end

function CreateCenteredString(anchor, text, x, y, size)
	size = size or FONT_SIZE
	local str = CreateString(anchor, text, x, y, size)
	str:ClearAllPoints()
	str:SetJustifyH("CENTER")
	str:SetJustifyV("CENTER")
	str:SetPoint("CENTER", anchor, "TOP", x, y)
	return str
end

function CreateCheckBox(anchor, text, x, y, size, font_size)
	size = size or BOX_SIZE
	font_size = font_size or FONT_SIZE
	local box = SetupCheckBox(anchor, x, y, size)
	local str = CreateString(
		box, text, size, -(size / 2), font_size
	)
	return box, str
end

function SetupMainFrame()
	MainFrame.background = MainFrame:CreateTexture(nil, "BACKGROUND")
	MainFrame.background:SetAllPoints()
	MainFrame.background:SetDrawLayer("ARTWORK", 1)
	MainFrame.background:SetColorTexture(0, 0, 0, 0.7)
	MainFrame:EnableMouse(true)
	MainFrame:SetMovable(true)
	MainFrame:RegisterForDrag("LeftButton")
	MainFrame:SetScript("OnMouseDown", MainFrame.StartMoving)
	MainFrame:SetScript("OnMouseUp", MainFrame.StopMovingOrSizing)
	MainFrame:ClearAllPoints()
	MainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	MainFrame:SetWidth(FRAME_WIDTH)
	MainFrame:SetHeight(FRAME_HEIGHT)
	MainFrame:Hide()
end

-- ACE

local AceGUI = LibStub("AceGUI-3.0")

function CreateAceFrame(title, layout, status)
	layout = layout or "Flow"
	status = status or ""
	local frame = AceGUI:Create("Frame")
	frame:SetTitle(title)
	frame:SetStatusText(status)
	frame:SetLayout(layout)
	frame:SetWidth(FRAME_WIDTH)
	frame:SetHeight(FRAME_HEIGHT)
	-- frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
	return frame
end

function CreateAceButton(text, width)
	local btn = AceGUI:Create("Button")
	btn:SetWidth(width)
	btn:SetText(text)
	return btn
end

function CreateAceCheckbox(label, value)
	value = value or false
	local box = AceGUI:Create("CheckBox")
	box:SetType("checkbox")
	box:SetLabel(label)
	box:SetValue(value)
	-- box:SetCallback("OnValueChanged", function(b)
	-- 	MacroHelper:Print(b:GetValue())
	-- end)
	return box
end

function CreateAceHeader(text)
	local header = AceGUI:Create("Heading")
	header:SetText(text)
	return header
end

function CreateAceLabel(text, size)
	size = size or FONT_SIZE
	local label = AceGUI:Create("Label")
	label:SetText(text)
	label:SetFont("Fonts\\FRIZQT__.TTF", size)
	return label
end

function CreateAceDropdown(label, size, values, selected)
	local box = AceGUI:Create("Dropdown")
	box:SetLabel(label)
	box:SetWidth(size)
	box:SetList(values)
	if selected ~= nil then
		box:SetValue(selected)
	end
	return box
end

function CreateAceVertSpacer(size)
	return CreateAceLabel(" ", size)
end

function CreateAceSimpleGroup(layout)
	layout = layout or "Flow"
	local group = AceGUI:Create("SimpleGroup")
	group:SetLayout(layout)
	return group
end