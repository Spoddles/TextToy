Dictionary = class()

function Dictionary:init(name)
    -- you can accept and set parameters here
    self.name = name
    self.words={}
    for i=1,15 do
        local filename="Project:"..name.."_"..i
        local filetext=readText(filename)
        self.words[i]=explode(",",filetext)
        self.words[i].count=#self.words[i]
    end
    local total=0
    for i=1,#self.words do
    total = total + #self.words[i]
    end
    self.total=total
end

function Dictionary:findword(min,max)
--returns random word from all words in dictionary within min and max length provided
local susbsettotal=0
for i=min,max do
subsettotal=subsettotal+#self.words[i]
end
num=math.random(1,subsettotal)
local wordcount,tablenum,theword = 0,min,nil
repeat
    if num<wordcount+#self.words[tablenum] then
    local theindex=num-wordcount
    local thetable=self.words[tablenum]
    theword=thetable[theindex]
    else
    wordcount=wordcount+#self.words[tablenum]
    tablenum=tablenum+1
    end
until theword~=nil
return theword
end

function Dictionary:draw()
    -- Codea does not automatically call this method
end

function Dictionary:touched(touch)
    -- Codea does not automatically call this method
end
