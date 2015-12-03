Welcome = class()

function Welcome:init()
    self.title="Werdz"
    self.title_length=string.len(self.title)
    self.animation_state="tween_title"
    self.tc=Chips(self.title,72,"random")
    self.tweens_title={}
    self.tweens_background={}
    self.background_words={}
    self.counter=0
    music("Dropbox:intro",true,.3)
end
function Welcome:touched(touch)
    local tb=buttons:findtouched(touch)
    if touch.state==BEGAN or touch.state == MOVING then
        if #tb>0 then
            buttons.touched=tb[1].name
            if tb[1].name=="Play" then
            end
            else
            buttons.touched=nil
        end
        else
        if touch.state==ENDED and #tb>0 then
            if tb[1].name=="Play" then
                sound("Dropbox:201804__fartheststar__poker-chips4")
                music.stop()
                buttons.touched=nil
                --print("gstate",gState)
                gState=5
                game=Game()
                game:gotonextlevel()
                
                
            end
        else
            g_pause=not g_pause
            if g_pause then
                tween.pauseAll()
            else
                tween.resumeAll()
            end
            buttons.touched=nil
        end
    end
    
end

function Welcome:draw()
    --clip(100,100,25,25)
    resetMatrix()
    sprite("Project:welcome_background",WIDTH/2,HEIGHT/2)
    local y=(HEIGHT/5)*4
    local x=WIDTH/2
    if not g_pause then
        if self.animation_state=="tween_title" then
            --print("yes")
            for i=1,self.title_length do
                local temp=(3-i)
                local ci=self.tc.letterchips[i].image
                self.tweens_title[i]={}
                
                local startx=math.random(0,WIDTH)
                local starty=-math.random(ci.width,HEIGHT/2)
                print(startx,starty)
                self.tweens_title[i].location=vec2(startx,starty)
                self.tweens_title[i].time=math.random()*1.5+2
                --local time=5
                --self.tweens_title[i].time=6
                self.tweens_title[i].complete=false
                self.tweens_title[i].timer=0
                self.tweens_title[i].alpha=0
                self.tweens_title[i].angle=math.random(1,1079)-540
                local destloc=vec2(WIDTH/2-(temp*ci.width*1.05),y)
                --print (destloc)
                self.tweens_title[i].tween=tween(self.tweens_title[i].time,self.tweens_title[i],{angle=0, alpha=255, location=destloc},tween.easing.backInOut,function() self.tweens_title[i].complete=true end)
            --print(self.tweens[i].tween)
            end
           self.animation_state="tween_waiting" 
    
        end
        if self.animation_state=="tween_waiting" then
            local done=true
            for i=1,self.title_length do
                if self.tweens_title[i].complete==false then
                    done=false
                end
            end
            --print("done",done)
            if done==true then
                self.animation_state="tween_background"
                self.counter=0
            end
        end
        local y=-50
        if self.animation_state=="tween_background" then
        self.counter=self.counter+DeltaTime
        --print("self.counter",self.counter)
        if self.counter>1 then
            self.counter=0
            local starty=HEIGHT*1.1
            local startx=math.random()*WIDTH
            local wordnum=#self.background_words+1
            --print (wordnum)
            self.background_words[wordnum]={}
            self.background_words[wordnum].word=dictionary:findword(2,#dictionary.words)
            self.background_words[wordnum].fs=math.random(20,100)
            self.background_words[wordnum].font=math.random(1,#f)
            self.background_words[wordnum].alpha= math.random(20,50)
            self.background_words[wordnum].location=vec2(startx,starty)
            self.background_words[wordnum].complete=false
            self.background_words[wordnum].tween=tween(math.random(3,6),self.background_words[wordnum].location,{y=-50},tween.easing.linear,function() self.background_words[wordnum]=nil end)
        end
    end
end
    if self.animation_state=="tween_background" then
        
        for i,j in pairs(self.background_words) do
            
            pushMatrix()
            pushStyle()
            translate(j.location.x,j.location.y)
            font(f[j.font])           
            fontSize(self.background_words[i].fs)
            
            fill(255,255, 255,j.alpha)
            text(self.background_words[i].word)
            popStyle()
            popMatrix()
        end
    end
    for i=1,self.title_length do
        local ci=self.tc.letterchips[i].image
        pushMatrix()
        
            translate(self.tweens_title[i].location.x,self.tweens_title[i].location.y)
            rotate(self.tweens_title[i].angle,0,0,1)
        tint(255,255,255,self.tweens_title[i].alpha)
            sprite(ci)
            noTint()
        popMatrix()
    end
end

Startup = class()

function Startup:init()
    self.elapsed=0
    self.onscreen=3
end

function Startup:draw()
    pushStyle()
        pushMatrix()
        background(255, 255, 255, 255)
        textMode(CENTER)
        textAlign(CENTER)
        translate(WIDTH/2,HEIGHT/2)
        fill(237, 214, 5, 255)
        fontSize(127)
        text("Tood Food")
        popMatrix()
        popStyle()
        self.elapsed = self.elapsed + DeltaTime
        if self.elapsed>=self.onscreen then
            
           gState=2
            self.elapsed=0
        end
end

function Startup:touched(touch)
    gState=2
    self.elapsed=0
end

LevelComplete=class()

function LevelComplete:init()
    self.onscreen=3
    self.elapsed=0
end

function LevelComplete:draw()
    pushStyle() pushMatrix()
    background(0, 0, 0, 255)
    textMode(CENTER)
    textAlign(CENTER)
    translate(WIDTH/2,HEIGHT/2)
    fill(237, 214, 5, 255)
    fontSize(127)
    text("Level Complete")
    popMatrix() popStyle()
    self.elapsed = self.elapsed + DeltaTime
    if self.elapsed>=self.onscreen then
        self.elapsed=0
        gState=5
        phy:Clear()
        game:gotonextlevel()
    end
end

LevelIntro=class()

function LevelIntro:init()
    self.onscreen=3
    self.elapsed=0
    --game:gotonextlevel()
end

function LevelIntro:draw()
    pushStyle() pushMatrix()
    background(0, 0, 0, 255)
    textMode(CENTER)
    textAlign(CENTER)
    translate(WIDTH/2,HEIGHT/2)
    fill(237, 214, 5, 255)
    fontSize(127)
    text("Level "..game.currentlevel)
    popMatrix() popStyle()
    self.elapsed = self.elapsed + DeltaTime
    if self.elapsed>=self.onscreen then
        self.elapsed=0
        gState=3
        
    end
end