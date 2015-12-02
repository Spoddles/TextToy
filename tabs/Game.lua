Game = class()

function Game:init()
    
    --CWL3=Words3 --words 11-15 letters
    self.currentlevel=0
    self.CurrentWordList={}
    CurrentLevelLetters={}
    CLL=CurrentLevelLetters
    CurrentLevelDropZones={}
    CLDZ=CurrentLevelDropZones
--    self.DictCountTotal=#Words1+#Words2+#Words3
--    self.DictCountPart1=#Words1
--    self.DictCountPart2=#Words2
--    self.DictCountPart3=#Words3
    self.fontsize=60
    levelintro=LevelIntro()
    levelcomplete=LevelComplete()
end

function Game:gotonextlevel()
    self.currentlevel = self.currentlevel + 1
    phy.selecting=false
    local rs=os.clock()
    print(rs*1000)
    math.randomseed(rs*1000)
    levels:setLevel(self,self.currentlevel)
    score=Score()
    self.chips=Chips(CLW,self.fontsize)
    createGround()
    self.timer=Timer(self.maxtime,gLi+80,HEIGHT-gTi+44,"numeric")
    self.timer:restart()
end

function Game:draw()
    
    pushMatrix() pushStyle()
    spriteMode(CORNER)
    translate(0,0)
    sprite("Dropbox:frame-8bit-rev2",0,0,WIDTH)
    spriteMode(CENTER)
    rectMode(CORNER)
    pushStyle()
    fill(255,255,255,30)
    rect(gLi,HEIGHT-gTi,WIDTH-gLi-gRi,100)
    rectMode(CENTER)
    popStyle()
    if phy.selecting then
        if phy.touchMap.active==true then
            local v=phy.touchMap
            local w=phy.touchMap.tp
            local gain = 1
            local damp = 0.1
            local worldAnchor = v.body:getWorldPoint(v.anchor)
            local touchPoint = v.tp
            --print("ok")
            local diff = touchPoint - worldAnchor
            local vel = v.body:getLinearVelocityFromWorldPoint(worldAnchor)
            v.body:applyForce( (1/1) * diff * gain - vel * damp, worldAnchor)
        end
        pushStyle()
        local pointcount=#phy.selectingpoints
        strokeWidth(8) stroke(255, 255, 255, 255) lineCapMode(ROUND)
        local a={} local b={}
        if pointcount==0 then
            a=phy.selectingstart b=phy.selectingend
            line(a.x,a.y,b.x,b.y)
            
            --local a={} local b={}
            --if pointcount==0 then
            --a.x=phy.selectingstart.x  a.y=phy.selectingstart.y
            --b.x=phy.selectingend.x
            --b.y=phy.selectingend.y
            --line(a.x,a.y,b.x,b.y)
            
        end
        if pointcount ==1 then
            a=phy.selectingstart  b=phy.selectingend
            a.x=phy.selectingpoints[1].mybody.x a.y=phy.selectingpoints[1].mybody.y
            line(a.x,a.y,b.x,b.y)
        end
        if pointcount>1 then
            --print(pointcount,"pc")
            for i=2,pointcount do
                local l=phy.selectingpoints[i].mybody
                local m=phy.selectingpoints[i-1].mybody
                a.x=m.position.x a.y=m.position.y
                b.x=l.position.x b.y=l.position.y
                line(a.x,a.y,b.x,b.y)
            end
            local l=phy.selectingpoints[pointcount].mybody
            a.x=l.position.x a.y=l.position.y
            b.x=phy.selectingend.x b.y=phy.selectingend.y
            line(a.x,a.y,b.x,b.y)
        end
        popStyle()
    end
    --print(#self.chips)
    self.chips:draw(false)
    if #phy.chiptweens>0 then
        if not phy:aretweensdone(phy.chiptweens) or phy.selecting then
            self.chips:drawchiptweens(phy)
        else
            phy.chiptweens={}
            self.chips.scored=nil
        end
    end
    -- print(#self.chips,"trip two")
    score:draw()
    if game.timer.active then
        game.timer:draw()
    else
        gState=4
        --print(#chips.letterchips)
        if #phy.chipjoints>=1 then
            for i,j in pairs(phy.chipjoints) do
                j:destroy()
                phy.chipjoints={}
            end
        end
        if #self.chips.letterchips>=1 then
            --print("yes")
            for i,j in pairs(self.chips.letterchips) do
                j.mybody:destroy()
                self.chips={}
            end
        end
        phy.selecting=false
        --phy.selectingpoints={}
    end
end

function Game:touched(touch)
    -- Codea does not automatically call this method
end

function Game:welcome()
    self.elapsed=0
    self.onscreen=3
    --print(welcome,starttime,onscreen)
end

function Game:setstate(x)
    -- you can accept and set parameters here
    self.state = x
end