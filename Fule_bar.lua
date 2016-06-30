
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

  position=-1,graphHight=0,positionIncraments=0, boarderDraw= false,
 currentColor=1,
 posAnimationRed=0, posAnimationYellow=0, posAnimationGreen=0,
 dir=true,
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
	if start<=0 then
	start =1
	end
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

 -- set position to how graph
 --0 = nothing
 --1 = red
 --2 = yellow
 --3 = green

 setPosition= function (self,pos)
	if self.positionIncraments~=0 then
		self.animation(self,pos)
	end
 end,

setGraphHight = function (self,hight)
	self.graphHight=hight
 end,

setAnimationInc= function (self,maxValue)

    self.positionIncraments=maxValue/(self.hightEnd-self.hightStart)
end,

setRedRegion= function (self,value)
  for i=0,(self.hightEnd-self.hightStart) do
    if i*self.positionIncraments >=value then
      self.posAnimationRed = i + self.hightStart
      return
    end
  end
  self.posAnimationRed=self.hightEnd
end,

setYellowRegion= function (self,value)
  for i=0,(self.hightEnd-self.hightStart) do
    if i*self.positionIncraments >=value then
      self.posAnimationYellow=  i + self.hightStart
      return
    end
  end
  self.posAnimationYellow=self.hightEnd
end,

setGreenRegion= function (self,value)
  for i=0,(self.hightEnd-self.hightStart) do
    if i*self.positionIncraments >=value then
      self.posAnimationGreen=  i + self.hightStart
      return
    end
  end
  self.posAnimationGreen=self.hightEnd
end,

--      Bottom, middle, top
--flase green, yellow, red
--true red, yellow, green
setDirection = function(self,dir)
  self.dir =dir
end,

getRedRegion = function(self)
  return self.posAnimationRed
end,

getYellowRegion = function(self)
  return self.posAnimationYellow
end,

getGreenRegion = function(self)
  return self.posAnimationGreen
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
	range= math.ceil(range)
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

		-- check if the position to go is less then current position
	elseif self.position>pos then
		posToGo = pos*self.positionIncraments
		for i= self.position*self.positionIncraments+self.hightStart ,pos*self.positionIncraments+self.hightStart,-1 do
			for j=self.widthStart,self.widthEnd do
				for k = self.lengthStart,self.lengthEnd do
					hologram.set(k,i,j,false)
				end
			end
		end

			-- redraws graph if the position is bigger than zero.
      -- Change the colors
		if pos ~=0 then
      print("pos"..pos)
      print("postogo"..posToGo)
      print("incraments "..self.positionIncraments)
			for b=self.widthStart,self.widthEnd do
				for n = self.lengthStart,self.lengthEnd do

					hologram.fill(n,b,(self.hightStart),(posToGo+self.hightStart),pos)
				end
			end
		else
      -- check if the pos is zero
      -- draw red lines
			self:drawboarders(true)
		end
		self.position=pos
	-- check to see if positon is higer the current position
	-- draw from the bottom to the top.
	elseif self.position<pos then

     -- removes boarders if they are drawn
	   if self.position==0 then
		     self:drawboarders(false)
	    end

	    for i= self.hightStart,self.positionIncraments*pos+self.hightStart-1 do
		      for j=self.widthStart,self.widthEnd do
			         for k = self.lengthStart,self.lengthEnd do
			              hologram.set(k,i,j,pos)
			          end
		      end
	    end

      self.position=pos
	end
end,

drawboarders =function(self,on)
	local lenght
	local width
	local color

	if on then
		color= 1
	else
		color =0
	end

	for i=self.lengthStart,self.lengthEnd do

		hologram.set(i,self.hightStart,self.widthStart,color)
		hologram.set(i,self.hightStart,self.widthEnd,color)
	end

	for i=self.widthStart,self.widthEnd do

		hologram.set(self.lengthStart,self.hightStart,i,color)
		hologram.set(self.lengthEnd,self.hightStart,i,color)
	end

	for i=1,4 do
		if i== 1 then
			lenght=self.lengthStart
			width= self.widthStart

		elseif i==2 then
			lenght=self.lengthStart
			width= self.widthEnd
		elseif i==3 then
			lenght=self.lengthEnd
			width= self.widthStart
		elseif i==4 then
			lenght=self.lengthEnd
			width= self.widthEnd
		end
		hologram.fill(lenght,width,self.hightStart,self.hightEnd,color)

	end
end,

animationSingle= function (self,color,data)


  -- breaks of if the position are the same.
  if self.position==data then
    return


  elseif self.position>data then

    for i= self.position , data,-1 do
      for j=self.widthStart,self.widthEnd do
        for k = self.lengthStart,self.lengthEnd do
          hologram.set(k,i,j,false)
        end
      end
    end

    if data==self.hightStart then
      self:drawboarders(true)
    end

    if self.currentColor~=color and color~=0 then
      self:changeColor(color,data)
    end

      self.position=data
      self.currentColor=color

  elseif self.position<data then

    if self.position==self.hightStart then
        self:drawboarders(false)
     end

     for i= self.hightStart,data do
         for j=self.widthStart,self.widthEnd do
              for k = self.lengthStart,self.lengthEnd do
                   hologram.set(k,i,j,color)
               end
         end
     end

     self.position=data
     self.currentColor=color
  end

end,

changeColor= function(self,color,num)
    for b=self.widthStart,self.widthEnd do
      for n = self.lengthStart,self.lengthEnd do
        hologram.fill(n,b,(self.hightStart),(num),color)
      end
    end
end,

calculteColor= function (self,data)
  local color=0
  local pos=0


  for i=0,(self.hightEnd-self.hightStart) do

    if i*self.positionIncraments >=data then
      pos = i+ self.hightStart
      break
    end
    pos=self.hightEnd
  end


  if self.dir== true then
    if pos<=self.posAnimationRed then
      color=1
    elseif pos<=self.posAnimationYellow then
      color=2
    elseif pos<=self.posAnimationGreen then
      color=3
    else
      color=0
    end
  else
    if posPos<=self.posAnimationGreen then
      color=3
    elseif posPos<=self.posAnimationYellow then
      color=2
    elseif posPos<=self.posAnimationRed then
      color=1
    else
      color = 0
    end
  end
  self:animationSingle(color,pos)
end
}

-- all example code to create your own

-- creat a new bar object for lava

local lavaBar = Holostats.new()
lavaBar:setHight(0,32)
lavaBar:setWidth(10,20)
lavaBar:setLength(10,20)
lavaBar:setPositionIncraments()
lavaBar:setPosition(3)

-- creat a new bar object for oil
local oilBar = Holostats.new()
oilBar:setHight(17,32)
oilBar:setWidth(10,20)
oilBar:setLength(30,40)
oilBar:setPositionIncraments()


-- creat a new bar object for gas
local gasBar = Holostats.new()
gasBar:setHight(17,29)
gasBar:setWidth(30,40)
gasBar:setLength(30,40)
gasBar:setPositionIncraments()
print(gasBar:getPositionIncraments())

gasBar:animation(3)
gasBar:animation(2)
gasBar:animation(1)
gasBar:animation(0)
print ("oilgoint to 3")
oilBar:animation(3)
--os.sleep(5)
print ("oilgoint to 2")
oilBar:animation(2)
--os.sleep(5)
print ("oilgoint to 1")
oilBar:animation(1)
--os.sleep(5)

oilBar:animation(0)
--os.sleep(2)


local testBar= Holostats.new()

testBar:setHight(0,15)
testBar:setWidth(30,40)
testBar:setLength(30,40)
testBar:setAnimationInc(31)
testBar:setRedRegion(5)
testBar:setYellowRegion(8)
testBar:setGreenRegion(32)
print(testBar:getRedRegion())
print(testBar:getYellowRegion())
print(testBar:getGreenRegion())
print(testBar:getPositionIncraments())
testBar:setDirection(true)
for i =0,32 do
testBar:calculteColor(i)


--os.sleep(0.5)
end
print("hello")
os.sleep(10)
for i =32,0,-1 do
testBar:calculteColor(i)

os.sleep(0.5)
end
for i =0,32 do
testBar:calculteColor(i)


os.sleep(0.5)
end

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

os.sleep(1)


end
