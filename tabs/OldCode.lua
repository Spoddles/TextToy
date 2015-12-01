

LevelComplete2=class()

function LevelComplete2:init()
    self.onscreen=3
    self.elapsed=0
    end
    
function LevelComplete2:draw()
    pushStyle()
        pushMatrix()
        background(0, 0, 0, 255)
        textMode(CENTER)
        textAlign(CENTER)
        translate(WIDTH/2,HEIGHT/2)
        fill(237, 214, 5, 255)
        fontSize(127)
        text("Level Complete")
        popMatrix()
        popStyle()
        self.elapsed = self.elapsed + DeltaTime
        if self.elapsed>=self.onscreen then
            self.elapsed=0
            gState=2
        end
end
World = class()

function World:init()
    -- you can accept and set parameters here
    
    self.gameborder={}
    gb=self.gameborder
    gWallBottom.bl=vec2(0,0)
    gWallBottom.br=vec2(WIDTH,0)
    gWallBottom.tr=vec2(WIDTH,HEIGHT)
    gWallBottom.tl=vec2(0,HEIGHT)
    --print(self.gameborder.tl)
end

function World:draw()
    --print ("test")
    -- Codea does not automatically call this method
end

function World:touched(touch)
    
    for j=1,-self.tailcount,-1 do
            noTint()
            pushMatrix()
            pushStyle()
            --local step=self.tailcount-j+1
            translate(self.startx + self.leds[i].xdiff+(self.segment/2),self.starty + self.leds[i].ydiff)
            if self.seconds==(i-(j-1)) then --self.et/self.time*self.qtylights
            self.leds[i].led:draw("blue",255+((j-1)*30))    
            --print(self.seconds,i-(j-1),math.random())
            else
            self.leds[i].led:draw("green",15)
            end
            popStyle()
            popMatrix()
            
        end
    -- Codea does not automatically call this method
end
