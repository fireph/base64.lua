-- Lua 5.1+ base64 v3.0 (c) 2009 by Alex Kloss <alexthkloss@web.de>
-- http://lua-users.org/wiki/BaseSixtyFour
-- licensed under the terms of the LGPL2

local base64

do
  -- Semantic version. all lowercase.
  -- Suffix can be alpha1, alpha2, beta1, beta2, rc1, rc2, etc.
  -- NOTE: Two version numbers need to be modified.
  -- 1. On the top of base64.lua
  -- 2. _version
  -- 3. _minor

  -- version to store the official version of base64.lua
  local _version = "3.0.0"

  -- When major is changed, this value should be changed
  local _major = "base64"

  -- Update this whenever a new version, for LibStub version registration.
  local _minor = 1

  -- Register in the World of Warcraft library "LibStub" if detected.
  if LibStub then
    local lib, minor = LibStub:GetLibrary(_major, true)
    if lib and minor and minor >= _minor then -- No need to update.
      return lib
    else -- Update or first time register
      base64 = LibStub:NewLibrary(_major, _minor)
      -- NOTE: It is important that new version has implemented
      -- all exported APIs and tables in the old version,
      -- so the old library is fully garbage collected,
      -- and we 100% ensure the backward compatibility.
    end
  else -- "LibStub" is not detected.
    base64 = {}
  end

  base64._version = _version
  base64._major = _major
  base64._minor = _minor
end

-- character table string
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

function base64.encode(data)
  return ((data:gsub('.', function(x)
    local r,b='',x:byte()
    for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
    return r;
  end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
    if (#x < 6) then return '' end
    local c=0
    for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
    return b:sub(c+1,c+1)
  end)..({ '', '==', '=' })[#data%3+1])
end

function base64.decode(data)
  data = string.gsub(data, '[^'..b..'=]', '')
  return (data:gsub('.', function(x)
    if (x == '=') then return '' end
    local r,f='',(b:find(x)-1)
    for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
    return r;
  end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
    if (#x ~= 8) then return '' end
    local c=0
    for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
    return string.char(c)
  end))
end

return base64
