Chips = class()

function Chips:init(word,size)
    -- you can accept and set parameters here
    --print(word,size)
    --self.chipbackground=sprite("Dropbox:marblemaster")
    self.letterchips={}
    self.tweenchips={}
    self.chipfontsize=size
    self.tweenfontsize=size*.8
    self.chipimages={}
    self.scored=nil
    self.color=color
    --print ("word",CLW)
    --tr
    pushStyle()
    font(f[1])
    fontSize(self.chipfontsize) textAlign(CENTER)
    local lw,lh=textSize("W")
    self.lettersize=math.max(lw,lh)
    popStyle()
    self.chipsize=self.lettersize*1.8
    self.tweensize=self.tweenfontsize*1.2
    self.currentchip=nil
    
    local cs=self.chipsize --***
    
    for i=1,string.len(word) do
        local chip=Chip(i,self.lettersize,self.chipfontsize,self.chipsize,word,self.color) --,self.chipbackground)
        table.insert(self.letterchips,i,chip)
        --print("creating",i,chip)
    end
    
end

function Chips:draw(ischosen)
    --print("num lettechips",#self.letterchips)
    local temp
    for i,k in pairs(self.letterchips) do
        --print("ang",k.mybody.angularVelocity)
            k:draw(ischosen)
    end
    if self.currentchip~=nil then
        self.currentchip:draw()
    end
end


function Chips:drawchiptweens(a)
    pushStyle()
    local ct=a.chiptweens
    local num=#ct
        for i=1,num do
            pushMatrix()
            translate(ct[i].position.x,ct[i].position.y)
                tint(255, 255, 255, ct[i].alpha)
            sprite(ct[i].image,0,0,ct[i].size)
            noTint()
            popMatrix()
        end
    popStyle()
end
function Chips:activechip()
    local temp=nil
    for i,k in ipairs(self.letterchips) do
        if k.selected==true and temp==nil then
            self.activechip=k
        end
    end
end

function Chips:findtouched(point)
    local touchedchips={}
    for i,k in ipairs(self.letterchips) do
        b=k.mybody
        if b:testPoint(point) then
            if k.selected==true then
                table.insert(touchedchips,1,k)
            else
                table.insert(touchedchips,k)
            end
        end
    end
    return(touchedchips)
end


function Chips:touched(touch)
    -- Codea does not automatically call this method
end
---------------------------------
Chip = class()

function Chip:init(i,j,k,l,m,o)
    -- you can accept and set parameters here
    self.chipfontsize=k
    self.lettersize=j
    self.chipsize=l
    --self.word=m
    --print(o)
    local w=WIDTH
    local h=HEIGHT
   -- print(gLi,self.chipsize,w,gRi)
    local min=math.floor((gLi+self.chipsize)+.5)
    local max=math.floor((w-gRi-self.chipsize)+.5)
    local x=math.random(min,max)
    self.chipnumber=i
    min=math.floor((gBi+self.chipsize)+.5)
    max=math.floor((h-gTi-self.chipsize)+.5)
    local y=math.random(min,max)
    self.letter=string.upper(string.sub(m,i,i))
    --print(gState)
    
    if gState==5 then
    self.mybody=createCircle(x,y,self.chipsize/2)
        --print("creating body",self.mybody)
    --self.mybody.angularDamping=.2
    --self.mybody.linearDamping=.2
    
    local a=phy:bump(game.angularvelocity)
        --print("a",a)
    self.mybody.angularVelocity=a
    self.mybody.angle=0
    local a=phy:bump(game.linearvelocity)
    self.mybody.linearVelocity=vec2(a,a)
    self.mybody.friction=game.friction
    self.mybody.angularDamping=game.angulardamping
        
    self.mybody.linearDamping=game.lineardamping
    self.mybody.restitution=game.restitution
    self.target=nil
    self.selected=false
    self.chosen=false
    --self.active=true
    --self.col=math.random(1,game.maxcolors)
    self.scored=nil
    end
    --***
    local cs=self.chipsize
        self.image=image(cs,cs)
        setContext(self.image)
        pushMatrix() pushStyle()
        spriteMode( CENTER )
        translate(cs/2,cs/2)
        local randomrotate=math.random(0,359)
        rotate(randomrotate)
        sprite(gSpr,0,0,cs)
        rotate(-randomrotate)
        font(f[4])
        textAlign(CENTER)
        fontSize(self.chipfontsize+3)
        fill(colours["gold"])
        fontSize(self.chipfontsize)
        text(self.letter,0,0)
        popMatrix() popStyle()
        setContext()
    return(self)
end

function Chip:draw(ischosen)
    local cs=self.chipsize
    font("Baskerville-Bold")
    local scalar
    if self.selected then
        scalar=g_scalar
    else scalar=1
    end
        
        pushMatrix()
        if self.chosen then
        tint(255,255,255,150)
        end
        if self.selected then
        tint(255,255,255,75)
        end
    local i=self.mybody.x local j=self.mybody.y local k=self.mybody.angle
        translate(i,j)
        rotate(k)
    --print(i.." "..j.." "..k)
        sprite(self.image,0,0,cs * scalar)
        --sprite("Dropbox:test2 copy",0,0,cs * scalar)
        noTint()
        popMatrix()
    --print("ang",self.mybody.angularVelocity)
        
        --local a=self.mybody.angularVelocity
        --local b=game.minangularvelocity
        --local c=game.maxangularvelocity
        --local direction=1
        --if a<=0 then direction=-1 a=-a end
        --if a<b then a=direction*b
        --elseif a>=b then a=direction*c
        --end
        --popMatrix()
end


function Chip:touched(touch)
    -- Codea does not automatically call this method

    
end

