 
local component = require("component")
local hologram = component.hologram -- to use the hologram
local sides = require("sides")	-- to use sides
local redStone = component.redstone	-- use redstone I/O
local keyboard = require("keyboard")-- use keyboard
local shell = require("shell")

local yellow=0xffff00
local green =0x00ff00
local red =0xff0000
local CUTS=3
-- set up the hologram
hologram.setPaletteColor(1,red)
hologram.setPaletteColor(2,yellow)
hologram.setPaletteColor(3,green)

hologram.setScale(1)
hologram.clear() 
-- end setup for hologram

-- tamplate to creat other table
 Holostats={
 position=0,graphHight=0,positionIncraments=0,
 widthStart=0,widthEnd=0,lengthStart=0,lengthEnd=0,
 hightStart=0,hightEnd=0,

 --creates a new table by coping everthing in Holostats to p
 -- then it returns p
new = function()
	local p={}
		for i,v in pairs(Holostats) do
		p[i]=v
		end
		
	return p
 
 end,
 
setHight = function(self,start,ending)
	self.hightStart=start or 0
	self.hightEnd=ending or 32
 end,
 
setWidth = function(self,start,ending)
	self.widthStart=start or 0
	self.widthEnd=ending or 48
 end,
 
setLength = function(self,start,ending)
	self.lengthStart=start or 0
	self.lengthEnd=ending or 48
 end,
 
 -- set postion to how graph
 --0 = nothing
 --1 = red
 --2 = yellow
 --3 = green
setPosition= function (self,pos)
	self.position= pos
 end,
 
setGraphHight = function (self,hight)
	self.graphHight=hight
 end,
 
returnMinMaxWidth = function(self,first)
	if first then
	return self.widthStart
	else
	return self.widthEnd
	end
 end,
 
returnMinMaxHight = function(self,first)
	if first then
		return self.hightStart
	else
		return self.hightEnd
	end
end,
 
returnMinMaxLength = function(self, first)
	if self then 
		return self.lengthStart
	else
		return self.lengthEnd
	end
end,
 
getGraphHight= function(self)
	return self.graphHight
 end,
 
setPositionIncraments= function(self)
	local range = 0
	range = self.hightEnd-self.hightStart
	range = range/CUTS
	range= math.floor(range)
	self.positionIncraments=range
 
end,

getPositionIncraments = function(self)
return self.positionIncraments
end,
 
 -- input table
 -- return position which can be 0,1,2,3
getPosition= function (self)
	return self.position
 end,
 
 -- moves the bar by adding or deleting
 -- input table, position to go
animation= function(self,pos)
	local posToGo=0
	
	-- no need to change anything in the graph
	if	self.position== pos then
		return
		
		-- check if the postion to go is less then current postion 
	elseif self.position>pos then
		posToGo = pos*self.positionIncraments
		for i= self.position*self.positionIncraments , pos*self.positionIncraments,-1 do
			for j=self.widthStart,self.widthEnd do
				for k = self.lengthStart,self.lengthEnd do
					hologram.set(k,i,j,false)
				end
			end	
		end
		
			-- redraws graph if the postion is bigger than zero.
		if pos ~=0 then
			for b=self.widthStart,self.widthEnd do
				for n = self.lengthStart,self.lengthEnd do
					hologram.fill(n,b,(self.hightStart),(self.positionIncraments*pos),pos)
				end
			end	
		end
		self.position=pos
	-- check to see if positon is higer the current position 
	-- draw from the bottom to the top.
	elseif self.position<pos then
	for i= self.hightStart,self.positionIncraments*pos do
		for j=self.widthStart,self.widthEnd do
			for k = self.lengthStart,self.lengthEnd do
			hologram.set(k,i,j,pos)
			end
		end	
	end
	self.position=pos
	end
	

end

}

-- creat a new bar object for lava

local lavaBar = Holostats.new()
lavaBar:setHight(0,32)
lavaBar:setWidth(10,20)
lavaBar:setLength(10,20)
lavaBar:setPosition(0)
lavaBar:setPositionIncraments()

-- creat a new bar object for oil
local oilBar = Holostats.new()
oilBar:setHight(0,32)
oilBar:setWidth(30,40)
oilBar:setLength(10,20)
oilBar:setPosition(0)
oilBar:setPositionIncraments()

-- creat a new bar object for gas
local gasBar = Holostats.new()
gasBar:setHight(0,32)
gasBar:setWidth(10,20)
gasBar:setLength(30,40)
gasBar:setPosition(0)
gasBar:setPositionIncraments()



 



while true do

-- check 
if (redStone.getInput(sides.back)==0) then
lavaBar:animation(3)
elseif(redStone.getInput(sides.back)==10)then
lavaBar:animation(2)
elseif(redStone.getInput(sides.back)==11)then
lavaBar:animation(1)
elseif(redStone.getInput(sides.back)==13) then
lavaBar:animation(0)
end

if (redStone.getInput(sides.left)==0) then
oilBar:animation(3)
elseif(redStone.getInput(sides.left)==10)then
oilBar:animation(2)
elseif(redStone.getInput(sides.left)==11)then
oilBar:animation(1)
elseif(redStone.getInput(sides.left)==13) then
oilBar:animation(0)
end

if (redStone.getInput(sides.front)==0) then
gasBar:animation(3)
elseif(redStone.getInput(sides.front)==10)then
gasBar:animation(2)
elseif(redStone.getInput(sides.front)==11)then
gasBar:animation(1)
elseif(redStone.getInput(sides.front)==13) then
gasBar:animation(0)
end
if keyboard.isKeyDown(keyboard.keys.w) and keyboard.isControlDown() then
        hologram.clear()
        os.exit()
end

os.sleep(70)


end