Physics = class()

function Physics:init(i)
    self:reset()
end

function Physics:reset()
    self.touchMap={}
    self.touchMap.active=false
    self.bodies={}
    self.targets={}
    self.selecting=false
    self.selectedchips={}
    self.selections={}
    self.currentselection=1
    self.chipjoints={}
    --self.tweens={}
    self.chiptween={}
    self.chiptweens={}
    self.readytorestore=false
    self.chipstocheck={}
    self.selectionbody={}
    self.selectionbody.mybody={}
    self.selectionbody.myjoint={}
    self.selecttime=0
    self.selectedbuffer=nil
    self.lasttouch=nil
    self.currenttouchid=nil
end

function Physics:addBody(body)
    table.insert(self.bodies,body)
end
function Physics:addTarget(body)
    table.insert(self.targets,body)
end

function Physics:Clear()
    if chips~=nil then
        for i,j in pairs(chips) do
            j.mybody:destroy()
        end
    end
    gWallLeft.mybody:destroy() gWallTop.mybody:destroy()
    gWallRight.mybody:destroy() gWallBottom.mybody:destroy()
end

function Physics:draw()
    for i,j in pairs(game.levelletters) do
        if j.mybody.shapeType == CIRCLE then
            strokeWidth(3.0)
            ellipse(0,0,body.radius*2)
        end
    end
end

function Physics:bump(x)
    local z=math.random()>.5
    if z then return x else return -x end
end

function Physics:touched(touch)
    self.lasttouch=touch
    local point = vec2(touch.x, touch.y)
    local touchedchips={}
    local tb=buttons:findtouched(point)
    if #tb>0 then
        sound(SOUND_JUMP, 1000)
        --print("button touched")
        buttons:touched(touch,tb[1])
    else
        local touchedbg={}
        touchedbg["top"]=gWallTop.mybody:testPoint(point)
        touchedbg["bottom"]=gWallBottom.mybody:testPoint(point)
        touchedbg["left"]=gWallLeft.mybody:testPoint(point)
        touchedbg["right"]=gWallRight.mybody:testPoint(point)
        
        if game.chips.currentchip==nil then
            touchedchips=game.chips:findtouched(point)
        else
            touchedchips[1]=game.chips.currentchip
        end
        
        local numchips=#touchedchips
        if numchips>0  then
            --print("num>0")
            b=touchedchips[1]
            c=b.mybody
            if touch.state == BEGAN and not b.selected and self.currenttouchid==nil and not self.selecting then
                b.selected=true
                b.target=nil
                b.chosen=false
                b.pos=point
                b.touchid=touch.id
                c.type=DYNAMIC
                c.sensor=true
                b.offset=point-c.position
                c.linearVelocity=vec2(0,0)
                c.bullet=false
                c.friction=0
                game.chips.currentchip=b
                self.currenttouchid=touch.id
                self.lastPos=point
                self.speed=vec2(0,0)
            end
            if touch.state == MOVING and b.selected and not self.selecting then
                if self.currenttouchid==touch.id then
                    b.pos = b.pos + vec2( touch.deltaX, touch.deltaY )
                    -- local cr=((b.lettersize+15)/2)
                    local cr=((game.chips.chipsize*g_scalar)/2)
                    --print(cr,chips.chipsize,g_scalar,chips.chipsize*g_scalar,b.pos.x,b.pos.y)
                    if b.pos.y >(HEIGHT-gTi-cr) then
                        b.pos.y =(HEIGHT-gTi-cr)
                    end
                    if b.pos.y <(gBi + cr) then
                        b.pos.y=gBi + cr
                    end
                    if b.pos.x >(WIDTH-gRi-cr) then
                        b.pos.x =(WIDTH-gRi-cr)
                    end
                    if b.pos.x <gLi+cr then
                        b.pos.x =gLi+cr
                    end
                    c.position=b.pos-b.offset
                    local dv=(point-self.lastPos)/DeltaTime
                    self.lastPos=b.pos
                    self.speed=(self.speed*0.8 + dv*0.2)/2
                end
            elseif touch.state == MOVING and self.selecting and #self.chipstocheck==0 and
            self.currenttouchid==touch.id then --and phy:aretweensdone(self.chiptweens) then
                if not b.chosen then
                    local sc=self.selectedchips
                    local j=#self.selectedchips
                    if j==0 then self.chiptweens={} end
                    local ct=self.chiptweens
                    b.chosen=true
                    sound(DATA, "ZgJAWwA+QEBAQEBAAAAAAPRoDD7mXHU+fwBAf0BAQEBAc0BA")
                    table.insert(self.selectingpoints,j+1,b)
                    table.insert(sc,j+1,b)
                    local tp=point
                    local anchor=c:getLocalPoint(c.position)
                    self.touchMap = {tp = tp, body = c, anchor = anchor, active=true}
                    self.targets=Targets(j+1)
                    ct[j+1]={}
                    if j>0 then
                        local bodyA=sc[j].mybody
                        local bodyB=sc[j+1].mybody
                        local anchorA=(bodyA.position) local anchorB=(bodyB.position)
                        local difference=anchorA-anchorB local distance=difference:len()
                        self.chipjoints[j]=physics.joint(ROPE,bodyA,bodyB,anchorA,anchorB,game.chips.chipsize*g_scalar)
                        bodyA.sensor=false
                        bodyB.sensor=false
                    end
                    for i=1,j+1 do
                        --print("loop",i,j+1)
                        if i==j+1 then
                            ct[i].position=c.position
                            ct[i].alpha=255
                        end
                        ct[i].letter=self.selectedchips[i].letter
                        ct[i].chipnumber=self.selectedchips[i].chipnumber
                        ct[i].fontsize=game.chips.tweenfontsize
                        --********
                        if ct[i].image==nil then
                            local ts=game.chips.tweensize
                            ct[i].image=image(ts,ts)
                            ct[i].size=ts
                            --print(ct[i].chipnumber)
                            setContext(ct[i].image)
                            pushMatrix()
                            pushStyle()
                            spriteMode( CENTER )
                            translate(ts/2,ts/2)
                            --tint(255,255,255,80)
                            stroke(colours["felt_yellow"])
                            --noTint()
                            --stroke(255, 213, 0, 80)
                            strokeWidth(2)
                            --tint(255,255,255,50)
                            fill(colours["felt_yellow_lite"]) ellipse(0,0,ts)
                            --noTint()
                            fill(colours["felt_yellow"])
                            --fill(255, 213, 0, 135)
                            font(f[4])
                            fontSize(ct[i].fontsize) text(ct[i].letter,0,0)
                            popStyle()
                            popMatrix()
                            setContext()
                        end
                        ct[i].done=false
                        local destination=self.targets.lettertargets[i].position
                        ct[i].tween=tween(.25,ct[i],
                        {position=destination},tween.easing.linear,function(param) ct[param].done=true end,i)
                    end
                else
                    self.selectingend=point
                end
            end
            
            if touch.state == ENDED and not self.selecting and self.currenttouchid==touch.id then
                if b.selected then
                    local hitbg=false
                    for i,k in pairs(touchedbg) do
                        if touchedbg[i] then
                            hitbg=true
                        end
                    end
                    if not hitbg then
                        Physics:resetchip(b)
                        b.pos = b.pos + vec2( touch.deltaX, touch.deltaY )
                        c.position=b.pos-b.offset
                        c.linearVelocity=self.speed
                    else
                        Physics:resetchip(b)
                        c.linearVelocity=self.speed
                    end
                    self.currenttouchid=nil
                    game.chips.currentchip=nil
                    self.selecttime=0
                end
            elseif touch.state == ENDED and self.selecting and self.currenttouchid==touch.id then --and #self.chipstocheck==0
                self.touchMap.active=false
                self.selectingstart=nil
                self.selectingend=nil
                self.selecting=false
                self.selectingpoints={}
                self.currenttouchid=nil
                --sound(DATA, "ZgBAMQBKQERAQEBAAAAAAPMayj5DNI8+QABAf0BTQEBAQEBA")
                sound("Game Sounds One:Reload 2")
                local sc=self.selectedchips
                local l=#self.chiptweens
                --print(l,sc)
                local step=(WIDTH/l)
                local ct=self.chiptweens
                if l >0 then
                    for i=1,l do
                        table.insert(self.chipstocheck,i,sc[i])
                        sc[i].chosen=false
                    end
                    game.chips.scored=score:checkforscore(phy.chipstocheck)
                    --print(chips.scored)
                    for i=1,l do
                        tween.stop(ct[i].tween)
                        ct[i].done=false
                        
                        local destination=vec2((i-1) *step+step/2,HEIGHT/2)
                        --print(i,self.chiptween[i].destination,self.chiptween[i].alpha,self.chiptween[i].fontsize)
                        ct[i].tween=tween(.5,ct[i],
                        {position=destination,alpha=0,size=HEIGHT},tween.easing.quartInOut,
                        function(param) ct[param].done=true end,i)
                        
                    end
                    
                    if l>=2 then
                        for i,j in pairs(self.chipjoints) do
                            j:destroy()
                            self.chipjoints={}
                        end
                    end
                end
            end
        else
            
            local test=touch.state==BEGAN and self.currentouchid==nil and self.selecting==false and #phy.chiptweens==0
            if test then
                
                --print("we are here")
                self.currenttouchid=touch.id
                self.selecting=true
                self.selectedchips={}
                self.selectingpoints={}
                self.selectingstart=point
                self.selectingend=point
            elseif touch.state == MOVING and self.selecting and self.currenttouchid==touch.id then
                self.selectingend=point
                self.touchMap.tp=point
            elseif touch.state == ENDED and self.selecting and self.currenttouchid==touch.id then
                self.touchMap.active=false
                self.selectingstart=nil
                self.selectingend=nil
                self.selecting=false
                self.selectingpoints={}
                self.currenttouchid=nil
                sound("Game Sounds One:Reload 2")
                local sc=self.selectedchips
                local l=#self.chiptweens
                --print(l,sc)
                local step=(WIDTH/l)
                local ct=self.chiptweens
                if l >0 then
                    for i=1,l do
                        table.insert(self.chipstocheck,i,sc[i])
                        sc[i].chosen=false
                    end
                    game.chips.scored=score:checkforscore(phy.chipstocheck)
                    --print(chips.scored)
                    for i=1,l do
                        tween.stop(ct[i].tween)
                        ct[i].done=false
                        
                        local destination=vec2((i-1) *step+step/2,HEIGHT/2)
                        --print(i,self.chiptween[i].destination,self.chiptween[i].alpha,self.chiptween[i].fontsize)
                        ct[i].tween=tween(.5,ct[i],
                        {position=destination,alpha=0,size=HEIGHT},tween.easing.quartInOut,
                        function(param) ct[param].done=true end,i)
                    end
                    
                    if l>=2 then
                        for i,j in pairs(self.chipjoints) do
                            j:destroy()
                            self.chipjoints={}
                        end
                    end
                end
            end
        end
    end
end

function Physics:resetchip(l)
    local m=l.mybody
    m.sensor=false
    m.type=DYNAMIC
    m.bullet=true
    l.selected=false
    l.tweenid=nil
    l.chosen=false
    game.chips.currentchip=nil
    self.currenttouchid=nil
end

function Physics:cleantweens()
    self.chiptween={}
end

function Physics:aretweensdone(tweenz)
    local ready=false
    local num=#tweenz
    if num>0 then
        local check=true
        for i=1,num do
            if tweenz[i].done == false then
                check=false
            end
        end
        if check then
            ready=true
        end
    else
        ready=true
    end
    return(ready)
end