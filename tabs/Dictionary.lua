Dictionary = class()

function Dictionary:init(name)
    -- you can accept and set parameters here
    self.name = name
    self.words={}
    for i=1,15 do
        local filename="Project:"..name.."_"..i
        local filetext=readText(filename)
        self.words[i]=explode(",",filetext)
        
    end
    local total=0
    for i=1,#self.words do
    total = total + #self.words[i]
    end
    self.total=total
end

function Dictionary:draw()
    -- Codea does not automatically call this method
end

function Dictionary:touched(touch)
    -- Codea does not automatically call this method
end
