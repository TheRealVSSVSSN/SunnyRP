-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

function stringsplit(input, sep)
  local t = {}
  if sep == nil or sep == '' then sep = '%s' end
  for str in string.gmatch(input, '([^' .. sep .. ']+)') do
    t[#t + 1] = str
  end
  return t
end

function startswith(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function returnIndexesInTable(t)
	local i = 0;
	for _,v in pairs(t)do
 		i = i + 1
	end
	return i;
end

function debugMsg(msg)
  if(settings.defaultSettings.debugInformation and msg)then
    print("ES_DEBUG: " .. msg)
  end
end

AddEventHandler("es:debugMsg", debugMsg)
