local PickerIsOpen = false
local InteractionMarker
local StartingCoords
local CurrentInteraction
local CurrentAnimation
local CanStartInteraction = true
local MaxRadius = 0.0

local InteractPrompt = Uiprompt:new(Config.InteractControl, "Select Interaction", nil, false)
local PropTable = {}

function DrawMarker(type, posX, posY, posZ, dirX, dirY, dirZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ, red, green, blue, alpha, bobUpAndDown, faceCamera, p19, rotate, textureDict, textureName, drawOnEnts)
	Citizen.InvokeNative(0x2A32FAA57B937173, type, posX, posY, posZ, dirX, dirY, dirZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ, red, green, blue, alpha, bobUpAndDown, faceCamera, p19, rotate, textureDict, textureName, drawOnEnts)
end

function IsPedUsingScenarioHash(ped, scenarioHash)
	return Citizen.InvokeNative(0x34D6AC1157C8226C, ped, scenarioHash)
end

function GetNearbyObjects(coords)
	local itemset = CreateItemset(true)
	local size = Citizen.InvokeNative(0x59B57C4B06531E1E, coords, MaxRadius, itemset, 3, Citizen.ResultAsInteger())

	local objects = {}

	if size > 0 then
		for i = 0, size - 1 do
			table.insert(objects, GetIndexedItemInItemset(i, itemset))
		end
	end

	if IsItemsetValid(itemset) then
		DestroyItemset(itemset)
	end

	return objects
end

function HasCompatibleModel(entity, models)
	local entityModel = GetEntityModel(entity)

	for _, model in ipairs(models) do
		if entityModel == GetHashKey(model) then
			return model
		end
	end

	return nil
end

function CanStartInteractionAtObject(interaction, object, playerCoords, objectCoords)
	if #(playerCoords - objectCoords) > interaction.radius then
		return nil
	end

	return HasCompatibleModel(object, interaction.objects)
end

function PlayAnimation(ped, anim)
	print("Play animation "..anim.label)
	if not CurrentAnimation then
		print("Not currenting in an animation")
		CurrentAnimation = anim
		--Citizen.CreateThread(function()
			-- Loop through the list of dictionaries and play the animations
			for di = 1, #anim.dicts do
				dict = anim.dicts[di]
				print("Animation dictionary = "..dict.name)
				if not DoesAnimDictExist(dict.name) then
					print("Invalid animation dictionary: " .. dict.name)
					return
				end

				-- Request the dictionary
				RequestAnimDict(dict.name)
				while not HasAnimDictLoaded(dict.name) do
					Citizen.Wait(10)
				end
				
				-- Play each of the animations in turn
				for findex,frame in ipairs (dict.frames) do
					print ("Playing animation "..dict.name.." - "..frame.name)
					time = tonumber(frame.time)
					flag = tonumber(frame.flag)
					TaskPlayAnim(ped, dict.name, frame.name, 1.0, 1.0, time, flag, 0.0, false, false, false)
					Citizen.Wait(100) -- Short delay to allow the animation to trigger, otherwise it skips over the while condition
					while IsEntityPlayingAnim(ped, dict.name, frame.name, 1) do
						Citizen.Wait(1000)
					end
				end
				RemoveAnimDict(dict)
			end
			-- Animations have finished
			CurrentAnimation = nil
		--end)
	else
		print("Animation is currently in progress, don't do anything")
	end
end

function StartInteractionAtCoords(interaction)
	if not interaction then
		return
	end
	local x = interaction.x
	local y = interaction.y
	local z = interaction.z
	local h = interaction.heading
	local props = json.decode(interaction.props)
	local ped = PlayerPedId()
	if IsPedUsingInteraction(ped, interaction) then
		return
	end

	if not StartingCoords then
		StartingCoords = GetEntityCoords(ped)
	end

	-- If the prop table is currently empty, and the current interaction requires props, create them
	-- If the prop table is not empty, we're probably restarting an existing animation, so don't re-create props!
	if #PropTable == 0 and props then
		for propindex, propdata in ipairs(props) do
			CreateProp(ped, propdata, propindex)
		end
	end

	ClearPedTasksImmediately(ped)

	FreezeEntityPosition(ped, true)

	if interaction.scenario then
		TaskStartScenarioAtPosition(ped, GetHashKey(interaction.scenario), x, y, z, h, -1, false, true)
	elseif interaction.animation then
		SetEntityCoordsNoOffset(ped, x, y, z)
		SetEntityHeading(ped, h)
		PlayAnimation(ped, interaction.animation)
	end

	if interaction.effect then
		Config.Effects[interaction.effect]()
	end
	-- Wait so that current interaction registers
	Wait(100)
	
	CurrentInteraction = interaction
end

function StartInteractionAtObject(interaction)
	local objectHeading = GetEntityHeading(interaction.object)
	local objectCoords = GetEntityCoords(interaction.object)

	local r = math.rad(objectHeading)
	local cosr = math.cos(r)
	local sinr = math.sin(r)

	local x = interaction.x * cosr - interaction.y * sinr + objectCoords.x
	local y = interaction.y * cosr + interaction.x * sinr + objectCoords.y
	local z = interaction.z + objectCoords.z
	local h = interaction.heading + objectHeading

	interaction.x = x
	interaction.y = y
	interaction.z = z
	interaction.heading = h

	StartInteractionAtCoords(interaction)
end

function IsCompatible(t, ped)
	return not t.isCompatible or t.isCompatible(ped)
end

function SortInteractions(a, b)
	if a.distance == b.distance then
		if a.object == b.object then
			local aLabel = a.scenario or a.animation.label
			local bLabel = b.scenario or b.animation.label
			return aLabel < bLabel
		else
			return a.object < b.object
		end
	else
		return a.distance < b.distance
	end
end

function AddInteractions(availableInteractions, interaction, playerPed, playerCoords, targetCoords, modelName, object)
	local distance = #(playerCoords - targetCoords)

	if interaction.scenarios then
		for _, scenario in ipairs(interaction.scenarios) do
			if IsCompatible(scenario, playerPed) then
				table.insert(availableInteractions, {
					x = interaction.x,
					y = interaction.y,
					z = interaction.z,
					heading = interaction.heading,
					scenario = scenario.name,
					object = object,
					modelName = modelName,
					distance = distance,
					label = interaction.label,
					effect = interaction.effect,
					props = scenario.props
				})
			end
		end
	end

	if interaction.animations then
		for _, animation in ipairs(interaction.animations) do
			if IsCompatible(animation, playerPed) then
				table.insert(availableInteractions, {
					x = interaction.x,
					y = interaction.y,
					z = interaction.z,
					heading = interaction.heading,
					animation = animation,
					object = object,
					modelName = modelName,
					distance = distance,
					label = interaction.label,
					effect = interaction.effect,
					props = animation.props
				})
			end
		end
	end
end

function GetAvailableInteractions()
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local availableInteractions = {}

	for _, interaction in ipairs(Config.Interactions) do
		if IsCompatible(interaction, playerPed) then
			if interaction.objects then
				for _, object in ipairs(GetNearbyObjects(playerCoords)) do
					local objectCoords = GetEntityCoords(object)

					local modelName = CanStartInteractionAtObject(interaction, object, playerCoords, objectCoords)

					if modelName then
						AddInteractions(availableInteractions, interaction, playerPed, playerCoords, objectCoords, modelName, object)
					end
				end
			else
				local targetCoords = vector3(interaction.x, interaction.y, interaction.z)

				if #(playerCoords - targetCoords) <= interaction.radius then
					AddInteractions(availableInteractions, interaction, playerPed, playerCoords, targetCoords)
				end
			end
		end
	end

	table.sort(availableInteractions, SortInteractions)

	return availableInteractions
end

function StartInteraction()
	local availableInteractions = GetAvailableInteractions()

	if #availableInteractions > 0 then
		SendNUIMessage({
			type = "showInteractionPicker",
			interactions = json.encode(availableInteractions)
		})
		PickerIsOpen = true
	else
		SendNUIMessage({
			type = "hideInteractionPicker"
		})
		SetInteractionMarker()
		PickerIsOpen = false

		if CurrentInteraction then
			StopInteraction()
		end
	end
end

function StopInteraction()
	CurrentInteraction = nil

	local ped = PlayerPedId()

	ClearPedTasksImmediately(ped)
	FreezeEntityPosition(ped, false)

	-- Stop animation
	if CurrentAnimation then
		for di = 1, #(CurrentAnimation.dicts) do
			RemoveAnimDict(CurrentAnimation.dicts[di].name)
		end
		CurrentAnimation = nil
	end 

	-- Delete props
	for i in pairs (PropTable) do
		DetachEntity(PropTable[i].handle)
		local coords = GetEntityCoords(ped)
		SetEntityCoords(PropTable[i].handle, coords.x, coords.y, coords.z, false, false, false)
		DeleteObject(PropTable[i].handle)
		SetEntityAsNoLongerNeeded(PropTable[i].handle)
		PropTable[i] = nil
	end
	PropTable = {}

	Citizen.Wait(100)

	if StartingCoords then
		SetEntityCoordsNoOffset(ped, StartingCoords.x, StartingCoords.y, StartingCoords.z)
		StartingCoords = nil
	end
end

function SetInteractionMarker(target)
	InteractionMarker = target
end

function DrawInteractionMarker()
	local x, y, z

	if type(InteractionMarker) == "number" then
		x, y, z = table.unpack(GetEntityCoords(InteractionMarker))
	else
		x, y, z = table.unpack(InteractionMarker)
	end

	DrawMarker(Config.MarkerType, x, y, z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, Config.MarkerColor[1], Config.MarkerColor[2], Config.MarkerColor[3], Config.MarkerColor[4], 0, 0, 2, 0, 0, 0, 0)
end

function IsPedUsingInteraction(ped, interaction)
	if interaction.scenario then
		return IsPedUsingScenarioHash(ped, GetHashKey(interaction.scenario))
	elseif interaction.animation then
		Citizen.Wait(500)
		print("IsPedUsingInteraction: Checking animation frames")
		dicts = interaction.animation.dicts
		numdicts = #dicts
		inframe = false

		for di = 1, numdicts do
			print ("Checking dictionary "..dicts[di].name)
			frames = dicts[di].frames
			numframes = #frames
			for fi = 1, numframes do
				print ("  Checking frame "..frames[fi].name)
				if IsEntityPlayingAnim(ped, interaction.animation.dict, frames[fi].name, 1) then
					print ("  Frame "..frames[fi].name.." is playing")
					inframe = true
				end
			end
		end
		
		--return IsEntityPlayingAnim(ped, interaction.animation.dict, interaction.animation.name, 1)
		return inframe
	else
		return false
	end
end

function IsInteractionNearby(playerPed)
	local playerCoords = GetEntityCoords(playerPed)

	for _, interaction in ipairs(Config.Interactions) do
		if IsCompatible(interaction, playerPed) then
			if interaction.objects then
				for _, object in ipairs(GetNearbyObjects(playerCoords)) do
					local objectCoords = GetEntityCoords(object)

					local modelName = CanStartInteractionAtObject(interaction, object, playerCoords, objectCoords)

					if modelName then
						return true
					end
				end
			else
				local targetCoords = vector3(interaction.x, interaction.y, interaction.z)

				if #(playerCoords - targetCoords) <= interaction.radius then
					return true
				end
			end
		end
	end

	return false
end

-- Imported from redm-emotes-master
function CreateProp(ped, data, propindex)
	local hash = GetHashKey(data.model)
	local pModel = data.model
	local pPosition = data.position
	local pRotation = data.rotation
	local initPosition = GetEntityCoords(ped)
	local bone
	
	if type(data.bone) == "string" then
		pBone = GetEntityBoneIndexByName(ped, data.bone)
	else
		pBone = data.bone
	end
	
	RequestModel(hash)
    while not HasModelLoaded(hash) do
		Wait(10)
	end
	--local pHandle = CreateObjectNoOffset(hash, initPosition.x, initPosition.y, initPosition.z, false, false, false, false)
	local pHandle = CreateObject(hash, initPosition.x, initPosition.y, initPosition.z, true, true, false, false, true)
	table.insert(PropTable, {model = pModel, handle = pHandle, bone = pBone, position = pPosition, rotation = pRotation})
	--print("CreateProp:: Incoming data - "..json.encode(PropTable[propindex]))
	
	--print("CreateProp:: Created Model: "..pModel..", Handle: "..pHandle..", location: "..json.encode(GetEntityCoords(pHandle)))
	if data.attach then
		--print("Attaching "..pModel.." ("..pHandle..") to entity "..ped)
   		--AttachEntityToEntity(int /* Entity */ entity1, int /* Entity */ entity2, int boneIndex, float xPos, float yPos, float zPos, float xRot, float yRot, float zRot, bool p9, bool useSoftPinning, bool collision, bool isPed, int vertexIndex, bool fixedRot);
		AttachEntityToEntity(pHandle, ped, pBone, pPosition.x, pPosition.y, pPosition.z, pRotation.x, pRotation.y, pRotation.z, true, true, false, false, 1, true)
	end

	--print("CreateProp:: Finished with Model: "..pModel..", Handle: "..pHandle..", location: "..json.encode(GetEntityCoords(pHandle)))
	SetModelAsNoLongerNeeded(hash)
end

function rt_print(message)
    TriggerEvent('chat:addMessage', {
        color = {255, 85, 85},
        multiline = false,
        args = {'Interactions', message}
    })
end
-- End of imported bits

RegisterNUICallback("startInteraction", function(data, cb)
	if data.object then
		StartInteractionAtObject(data)
	else
		StartInteractionAtCoords(data)
	end
	cb({})
end)

RegisterNUICallback("stopInteraction", function(data, cb)
	StopInteraction()
	cb({})
end)

RegisterNUICallback("setInteractionMarker", function(data, cb)
	if data.entity then
		SetInteractionMarker(data.entity)
	elseif data.x and data.y and data.z then
		SetInteractionMarker(vector3(data.x, data.y, data.z))
	else
		SetInteractionMarker()
	end
	cb({})
end)

RegisterCommand("interact", function(source, args, raw)
	StartInteraction()
end, false)

Citizen.CreateThread(function()
	for _, interaction in ipairs(Config.Interactions) do
		MaxRadius = math.max(MaxRadius, interaction.radius)
	end

	while true do
		local ped = PlayerPedId()

		CanStartInteraction = not IsPedDeadOrDying(ped) and not IsPedInCombat(ped)

		if CanStartInteraction and IsInteractionNearby(ped) then
			if not InteractPrompt:isEnabled() then
				InteractPrompt:setEnabledAndVisible(true)
			end
		else
			if InteractPrompt:isEnabled() then
				InteractPrompt:setEnabledAndVisible(false)
			end
		end

		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()

		if IsControlJustPressed(0, Config.InteractControl) and CanStartInteraction then
			StartInteraction()
		end

		if PickerIsOpen then
			DisableAllControlActions(0)

			if IsDisabledControlJustPressed(0, Config.MenuUpControl) then
				SendNUIMessage({
					type = "moveSelectionUp"
				})
			end

			if IsDisabledControlJustPressed(0, Config.MenuDownControl) then
				SendNUIMessage({
					type = "moveSelectionDown"
				})
			end

			if IsDisabledControlJustPressed(0, Config.MenuAcceptControl) then
				SendNUIMessage({
					type = "startInteraction"
				})
				SetInteractionMarker()
				PickerIsOpen = false
			end

			if IsDisabledControlJustPressed(0, Config.MenuCancelControl) or not CanStartInteraction then
				SendNUIMessage({
					type = "hideInteractionPicker"
				})
				SetInteractionMarker()
				PickerIsOpen = false
			end

			if InteractionMarker then
				DrawInteractionMarker()
			end
		elseif CurrentInteraction and not IsPedUsingInteraction(playerPed, CurrentInteraction) then
			StartInteractionAtCoords(CurrentInteraction)
		end

		Citizen.Wait(0)
	end
end)
