function ToJSON(tab)
	local rets = {};
	for k,v in pairs(tab)do
		table.insert(rets, "\""..tostring(k).."\":".."\""..tostring(v).."\"");
	end
	return "{"..table.concat(rets,",").."}";
end

local pttBindings = {
	mouse = {
		[18]=true
	};
	keyboard = {
		[6]=true
	};
}

function ProcessPTT(event, key, family)
	if(family == "mouse")then
		if(not pttBindings.mouse[key])then
			return false;
		end
		if(event == "MOUSE_BUTTON_PRESSED")then
			OutputDebugMessage("TS3_PTT_ACTIVATE");
			OutputLogMessage("TS3_PTT_ACTIVATE\n");
		elseif(event == "MOUSE_BUTTON_RELEASED")then
			OutputDebugMessage("TS3_PTT_DEACTIVATE");
			OutputLogMessage("TS3_PTT_DEACTIVATE\n");
		else
			return false;
		end
	elseif(family == "kb")then
		if(not pttBindings.keyboard[key])then
			return false;
		end
		if(event == "G_PRESSED")then
			OutputDebugMessage("TS3_PTT_ACTIVATE");
			OutputLogMessage("TS3_PTT_ACTIVATE\n");
		elseif(event == "G_RELEASED")then
			OutputDebugMessage("TS3_PTT_DEACTIVATE");
			OutputLogMessage("TS3_PTT_DEACTIVATE\n");
		else
			return false;
		end
	end
	return true;
end

function OnEvent(event, key, family)
	if(ProcessPTT(event, key, family))then
		return;
	end
	local mkey = GetMKeyState()
	local apiMsg = ToJSON({
		KEY=key,
		M=mkey,
		event=event,
		family=family
	});
	OutputLogMessage(apiMsg.."\n");
	OutputDebugMessage(apiMsg);
end
