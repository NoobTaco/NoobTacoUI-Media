-- TextureReplacementTest.lua
-- Proof-of-concept: Replace the personal resource bar and power/mana bar textures with a custom background using LibSharedMedia

local addonName, addon = ...
local frameName = "PersonalResourceDisplayFrame"
local LSM = LibStub("LibSharedMedia-3.0")
local textureKey = "NT_test2"
local texturePath = LSM and LSM:Fetch("statusbar", textureKey) or
    "Interface\\AddOns\\NoobTacoUI-Media\\Media\\Textures\\NT_test.tga"

local function ReplaceBarTexture(bar)
  local okRegions, regions = pcall(function() return { bar:GetRegions() } end)
  if not okRegions then return end
  for _, region in ipairs(regions) do
    local okType, objType = pcall(function() return region:GetObjectType() end)
    -- Only replace main fill textures, skip overlays like overAbsorbGlow
    local okName, regionName = pcall(function() return region:GetName() end)
    if okType and objType == "Texture" and (not okName or not regionName or not tostring(regionName):find("overAbsorbGlow")) then
      pcall(function() region:SetTexture(texturePath) end)
    end
  end
end

local function ReplacePersonalResourceBarTextures()
  local prdFrame = _G[frameName]
  if not prdFrame or not prdFrame.HealthBarsContainer or not prdFrame.HealthBarsContainer.healthBar then
    return
  end
  -- Health bar
  ReplaceBarTexture(prdFrame.HealthBarsContainer.healthBar)
  -- Power/Mana bar
  if prdFrame.PowerBar then
    ReplaceBarTexture(prdFrame.PowerBar)
  end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event)
  ReplacePersonalResourceBarTextures()
end)

_G.ReplacePersonalResourceBarTextures = ReplacePersonalResourceBarTextures
