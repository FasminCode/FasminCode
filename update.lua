require 'lib.moonloader'
inicfg = require 'inicfg'
dLstatus = require('moonloader').download_status
enc = require('encoding')
enc.default = 'CP1251'

local update_state = false
local script_version = 1
local script_version_text = "0.1"

local script_url = ""
local script_path = thisScript().path

local script_update = ""

local update_path = getWorkingDirectory() .. '/script_update.ini'
local update_url = "https://raw.githubusercontent.com/FasminCode/FasminCode/main/script_update.ini"



function main()
	repeat wait(0) until isSampAvailable()
	sampAddChatMessage("{ff0000}update.lua {00ff00}completed {ffffff}loaded", -1)
	sampRegisterChatCommand('update', cmd_update)
	
	downloadUrlToFile(update_url, update_path, function(id, status)
		if status == dLstatus.STATUS_ENDDOWNLOADDATA then
			updateIni = inicfg.load(nil, update_path)
			if tonumber(updateIni.info.vers) > script_version then
				sampAddChatMessage("Есть обновление! Новая версия скрипта: " .. updateIni.info.vers_text, -1)
				update_state = true
			end
			os.remove(update_path)
		end
	end)
	while true do wait(0)
		if update_state then
			downloadUrlToFile(script_url, script_path, function(id, status)
				if status == dLstatus.STATUS_ENDDOWNLOADDATA then
					sampAddChatMessage("Обновление было успешно загружено!", -1)
					thisScript():reload()
				end
				break
			end)
		end
	end
end

function cmd_update()
	sampShowDialog(2335, "UPDATE SCRIPT", "Обновление скрипта!", "тест", "", 0)
end