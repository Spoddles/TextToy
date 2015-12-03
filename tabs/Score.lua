Score = class()

function Score:init()
    -- you can accept and set parameters here
    self.score=0
    self.gamescore=0
    self.fs=nil
    self.goodwords={}
    self.fontsize=g_scorefontsize
    self.prevsound=0
end

function Score:checkforscore(sc)
    local scored,chosenword = false,nil
    for i,k in ipairs(sc) do
            chosenword = chosenword..k.letter
            k.chosen=false
        end
    if not phy.selecting and sc~=nil and #sc>=game.minwordselect then
        local wordstosearch=dictionary.words[string.len(chosenword)]
        local totalwords=#wordstosearch
        local foundmatch,done,i = false,false,1
        repeat
        if wordstosearch[i]==string.upper(chosenword) then
            foundmatch=true
            local alreadychosen=false
            for l,m in pairs(self.goodwords) do
                if chosenword==m then
                    alreadychosen=true
                end
            end
            if foundmatch and not alreadychosen then
                scored=true
                table.insert(self.goodwords,chosenword)
                self:addtoGameScore(math.floor(math.pow(2,string.len(chosenword)-1)*10))
            end
        end
        i=i+1
        until scored or i>totalwords
    end
    phy.chipstocheck={}
    phy.selectedchips={}
    if scored then
        local snd=0
        repeat snd=math.random(1,#gSounds.success)
        until snd~=self.prevsnd
        self.prevsnd=snd
        sound(gSounds.success[snd])
    else
        local snd=0
        repeat snd=math.random(1,#gSounds.fail)
        until snd~=self.prevsnd
        self.prevsnd=snd
        sound(gSounds.fail[snd])
    end
    return(scored)
    
end

function Score:addtoGameScore(x)
    self.newscore=self.gamescore+x
    self:flashScore(x)
end

function Score:flashScore(s)
    self.fs=FlashScore(WIDTH-gRi-70,g_displayPos,s,400)
    self.gamescore=self.newscore
end

function Score:draw()
    if self.fs~=nil then
    if self.fs.complete==false then
        self.fs:draw()
        else
            self.fs=nil
    end
    end
    pushMatrix() pushStyle()
    translate(WIDTH-gRi-70,g_displayPos)
    fill(gColour_score)
    font(f[3])
    textAlign(LEFT)
    fontSize(self.fontsize)
    text(self.gamescore)
    popStyle() popMatrix()
end

function Score:touched(touch)
end

FlashScore = class()

function FlashScore:init(x, y, score,f)
    self.x = x
    self.y = y
    self.complete=false
    self.score = score
    self.fontsize = f
    self.alpha=100
    self.tween=tween( .3, self, {x = x, y = y,fontsize = 20,alpha = 10},tween.easing.sineInOut, function() self.complete=true end)
end

function FlashScore:draw()
    --print("selfcomp",self.complete,self.alpha,self.x,self.y,self.score)
    pushMatrix()
    translate(self.x+1,self.y+1)
    --translate(1,1)
    pushStyle()
    font(f[4])
    textMode(CENTER)
    fontSize(self.fontsize)
    fill(255, 255, 255, self.alpha)
    text(self.score)
    translate(-1,-1)
    fill(168, 175, 220, 0)
    text(self.score)
    popStyle()
    popMatrix()
end

FlashScore2=class()

function FlashScore2:init(x, y, score,f)
    self.x = x
    self.y = y
    self.complete=false
    self.score = score
    self.fontsize = f
    self.alpha=100
    self.tween=tween( .3, self, {x = x + 30, y = phy.lasttouch.y+60,fontsize = 20,alpha = 20},tween.easing.sineInOut, function() self.complete=true end)
end

function FlashScore2:draw()
    pushMatrix()
    translate(self.x+1,self.y+1)
    pushStyle()
    font(f[4])
    textMode(CENTER)
    fontSize(self.fontsize)
    fill(255, 255, 255, self.alpha)
    text(self.score)
    translate(-1,-1)
    fill(0, 33, 255, self.alpha)
    text(self.score)
    popStyle()
    popMatrix()
end

FlashWord = class()

function FlashWord:init(x, y, score,fs)
    self.x = x
    self.y = y
    self.score = score
    self.fs = fs
    self.alpha=255
end

function FlashWord:draw()
    pushMatrix()
    translate(self.x,self.y)
    pushStyle()
    font(f[3])
    textMode(CENTER)
    fontSize(self.fs)
    fill(197, 168, 36, self.alpha)
    text(self.score)
    popStyle()
    popMatrix()
end

Timer = class()

function Timer:init(t,x,y,z)
    self.type=z
    self.clock=os.clock()
    self.time = t
    self.x = x self.y = y
    self.seconds=0 self.et=0
    self.done=false
    self.active=false
    self.fontsize=36
    --print("help")
end

function Timer:draw()
    self.active=true
    self.et=self.et+DeltaTime
    if self.et>=1 then
        self.seconds=self.seconds + 1
        self.et=self.et-1
    end
    if self.seconds>self.time then
        self.done=true
        self.active=false
        self.elapsed=0
    else
        if self.type=="numeric" then
            pushMatrix() pushStyle()
            font(f[3])
            fontSize(self.fontsize)
            fill(gColour_timer)
            local mins=math.floor((self.time-self.seconds)/60)
            if mins<10 and mins>=0 then
                mins="0"..mins
            end
            local displaysecs=math.floor(self.time-(mins*60)-self.seconds)
            if displaysecs<10 then
                displaysecs="0"..displaysecs
            end
            text(mins..":"..displaysecs,gLi+70,g_displayPos)
            popStyle() popMatrix()
            elseif self.type=="simple" then
        end
    end
end

function Timer:restart()
    self.active=true
    self.seconds=0
    self.done=false
end

function Timer:touched(touch)
    -- Codea does not automatically call this method
end

LED = class()

function LED:init(w,h)
    self.width=w
    self.height=h
    self.colors={}
    local temp=nil
    self.colors.green={}
    self.colors.blue={}
    self.colors.red={}
    self.colors.orange={}
    self.colors.yellow={}
    self.colors.white={}
    temp=self.colors.green
        temp.r=127
        temp.g=255
        temp.b=0
        temp.a=0
    temp=self.colors.red
        temp.r=255
        temp.g=0
        temp.b=0
        temp.a=255
    temp=self.colors.blue
        temp.r=0
        temp.g=0
        temp.b=255
        temp.a=255
    temp=self.colors.orange
        temp.r=255
        temp.g=127
        temp.b=0
        temp.a=255
    temp=self.colors.yellow
        temp.r=255
        temp.g=255
        temp.b=0
        temp.a=255
    temp=self.colors.white
        temp.r=255
        temp.g=255
        temp.b=255
        temp.a=15
end

function LED:draw(col,a)
    noTint()
    tint(self.colors[col].r,self.colors[col].g,self.colors[col].b,a)
    sprite("Dropbox:timerlight",0,0,self.width,self.height)
    noTint()
end
    
    

Timer2 = class()

function Timer2:init(t)
    -- you can accept and set parameters here
    self.clock=os.clock()
    self.time = t
    self.startx = li+10
    self.endx = ri-10
    self.starty = bi+20
    self.endy = self.starty
    self.qtylights = t
    self.lightratio = .70
    self.length = WIDTH - li-ri
    self.segment = self.length/self.qtylights
    self.tailcount = 5
    self.seconds=0
    self.et=0
    self.leds={}
    self.done=false
    self.active=false
    local lightw = self.segment * self.lightratio
    local lighth = 15
    for i=1,self.qtylights do
        self.leds[i]={}
        self.leds[i].led=LED(lightw,lighth)
        self.leds[i].xdiff=(i-1)*self.segment
        self.leds[i].ydiff=0
    end
    --self.60
end

function Timer2:draw()
    --print(self.elapsed(self),self.clock)
    self.et=self.et+DeltaTime
    if self.et>=1 then
        
        self.seconds=self.seconds + 1
        self.et=self.et-1
        if self.seconds>self.time then
            self.done=true
            self.active=false
            game:setstate(4)
            self.elapsed=0
        end
    end
    local ratio=self.seconds/self.time
        local col=""
        if ratio<.4 then
            col="green"
        elseif ratio<.65 then
            col="yellow"
        elseif ratio<.8 then
            col="orange"
        else col="red"
        end
    local alphastep=240/(self.tailcount)
    for i=1,self.qtylights do
        
        local difference=self.seconds-i
        local alpha=255-difference*alphastep
        pushMatrix()
        pushStyle()
        translate(self.startx + self.leds[i].xdiff,self.starty + self.leds[i].ydiff)
        if difference<self.tailcount and difference>0 then
            self.leds[i].led:draw(col,alpha)
        --else
            --self.leds[i].led:draw("white",15)
        end
        popStyle()
        popMatrix()
        noTint() 
     end
end

function Timer2:restart()
    self.active=true
    self.seconds=0
    self.done=false
end

function Timer2:touched(touch)
    -- Codea does not automatically call this method
end