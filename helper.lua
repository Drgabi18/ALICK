function Initialize()


	maxdevices = 25
	

	local taby = {}
	num = 0
	index = 0

	-- get each line from DeviceList
	for i in string.gmatch(SKIN:GetMeasure("DeviceList"):GetStringValue(), "[^\n]+") do
		-- apparently the table needs to be initialized, i was
		-- surprised when taby[i][1] didn't work initally
		taby[i] = taby[i] or {}
		num = num + 1

		-- if the user has Debug ON, it prints each device in the Log, for whoever wants/needs
		SKIN:Bang("!Log", i, "Debug")

		-- for each line, separate the ID part from the name part, then get the device ID
		-- could i have done this not nested? absolutley, will i? no
		for j in string.gmatch(i, "[^:]+") do
			index = index + 1
			-- gets the list in reverse, if you do `print(index, j)` you will see it prints
			-- 2	" Headphones (Some Driver Stuff)"
			-- 1	{0.0.0.24}{blahblah}
			-- all this part dose is put 1 and 2 together in
			-- `taby = { [1] = { [1] = {"{0.0.0.24}{blahblah}"}, [2] = {"Headphones (Some Driver Stuff)"}} }`
			-- this indeed means if a device has no ID, the skin completly breaks
			if math.fmod(index, 2) ~= 0 then taby[i][1] = j else taby[i][2] = j end
		end

		-- we could string:sub(-1) to get rid of the space at the start of device names, or we can create fake list items,
		-- this is why the first bang has a space before the "-" but not after, hehe
		SKIN:Bang("!SetVariable", num..0, num.." -"..taby[i][2])
		SKIN:Bang("!SetVariable", num..1, taby[i][1])
		SKIN:Bang('!SetOption', num, 'LeftMouseUpAction', '[!SetClip "' .. taby[i][1] .. '"][!WriteKeyValue Variables '..SKIN:ReplaceVariables('ID[#Port]')..' "' .. taby[i][1] .. '"][!Refresh]')

		
	end

	-- skin supports 25 devices, i didn't wanna make the list dynamic using factory.lua
	-- to make the list larger, increase the number of meters (just copy paste the sections) to whatever number you want
	-- and do the same with the variable maxdevice in the lua file (scroll up you dummy)
	-- for now, just hide the unused meters
	for x=(num+1),maxdevices do
		SKIN:Bang("!HideMeter", x)
	end

	if num > maxdevices then
		SKIN:Bang("!Log", "Somehow reached the limit, increase the number of meters in the skin and devices in the LUA file.", "Error")
	end

end