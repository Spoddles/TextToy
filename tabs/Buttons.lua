Buttons = class()

function Buttons:init()
    self.gamebuttons={}
    local gb=self.gamebuttons
    self.scalar=1.33
    self.istouched=false
    local pic=sprite("Dropbox:Marble-Button")
    --print("thepic",pic)
    table.insert(gb,Button("Play",2,vec2(WIDTH/2,HEIGHT/2), true,"Dropbox:Marble-Button","PLAY",200,50,true,true,false))
    table.insert(gb,Button("About",2,vec2(WIDTH/2,HEIGHT/2-100),true,"Dropbox:Marble-Button","ABOUT",200,50,true,true,false))
    end
function Buttons:draw()
     local gb=self.gamebuttons
        if #gb > 0 then
            for i=#gb,1,-1 do
                 if gb[i].state==gState then
                if gb[i].isVisible then
                self:drawbutton(gb[i])
                end
            end
        end
    end
end

function Buttons:drawbutton(j)
    
    resetMatrix()
    rectMode(CENTER)
    textMode(CENTER)
    spriteMode(CENTER)
    pushMatrix()
        if  j.isImage then
            translate(j.location)
            sprite(j.img,j.location.x,j.location.y,j.w*self.scalar,j.h*self.scalar)
            if j.labelText~=nil then
                pushStyle()
                font(f[6])
                if buttons.touched ~= j.name then
                    fill(colours["bronze"])
                else
                    fill(colours["felt_yellow_touched"])
                end
                fontSize(j.h)
                text(j.labelText,j.location.x,j.location.y)
                popStyle()
            end
        else
            --print(j.img)
            if j.hasBackground then
                --print(j.hasBackground)
                pushStyle()
                noStroke()
                fill(255, 255, 255, 92)
                rect(j.location.x,j.location.y,j.w*self.scalar,j.h*self.scalar)--,j.w,j.h)
                noFill()
                strokeWidth(2) 
                stroke(255, 255, 255, 255)
                rect(j.location.x,j.location.y,j.w*self.scalar,j.h*self.scalar)--j.x,j.y,j.w,j.h)
                
                popStyle()
            end
            pushStyle()
            font(f[6])
            if buttons.touched ~= j.name then
                fill(colours["felt_yellow"])
            else
                fill(colours["felt_yellow_touched"])
            end
            fontSize(j.h)
            text(j.img,j.location.x,j.location.y)
            popStyle()
        end
    popMatrix()
   
end

function Buttons:findtouched(point)
    local tb={}
    local gb=self.gamebuttons
        for i,k in pairs(gb) do
            local loc=k.location
            local t=loc.y+k.h/2
            local b=loc.y-k.h/2
            local l=loc.x-k.w/2
            local r=loc.x+k.w/2
            if (point.x>l and point.x<r) and (point.y>b and point.y<t) and k.state==gState then
                    table.insert(tb,k)
            end
        end
    return(tb)
end

function Buttons:touched(touch,tb)
    if touch.state=="BEGAN" or touch.state == "MOVING" then
        --print("play")
        if gState==tb.state then 
            if tb.name=="Play" then
                --sound(SOUND_BLIT, 8738)
                
                self.istouched=true
            end
        end
    end
        if touch.state=="ENDED" then
        if gState==tb.state then 
            if tb.name=="Play" then
                sound(SOUND_BLIT, 8738)
                gState=5
                game=Game()
                
            end
        end
    end
end

----------------

Button = class()

function Button:init(name,state,location,isImage,img,labelText,w,h,isActive,isVisible,hasBackground)
    self.name=name
    self.state=state
    self.location=location
    self.img=img
    self.scalar=1.3
    self.w=w
    self.h=h
    self.isImage=isImage
    self.isActive=isActive
    self.isVisible=isVisible
    self.hasBackground=hasBackground
    self.labelText=labelText
end

function Button:draw()
    pushMatrix()
    pushStyle()
    --print(self.name,self.location.self.hasBackground)
    if self.hasBackground then
        --print(hasbackground)
        pushStyle()
        pushMatrix()
        translate(self.x,self.y)
        noStroke()
        fill(255, 255, 255, 127)
        rect(self.x,self.y,self.w*self.scalar,self.h*self.scalar)
        noFill()
        strokeWidth(2) 
        stroke(255, 255, 255, 255)
        rect(self.x,self.y,self.w,self.h)
        popMatrix()
        popStyle()
    end
    font(f[3])
    fontSize(self.buttontextsize)
    fill(13,23,210,255)
    ellipse(self.x,self.y,self.mybody.radius*2)
    
    translate(self.x,self.y)
    fill(255,255,255,255)
    textAlign(CENTER)
    text(self.t,0,0)    
    popMatrix()
    popStyle()
end

function Button:touched()
    score:checkforscore()
end