Levels = class ()

function Levels:init(g)
    --number,maxtime,minwordlength,maxwordlength,angularvelocity,linearvelocity,restitution,friction,maxcolors
    self.levelstable={}
    local l=self.levelstable
    l[1]="1,15,6,6,3,40,20,.3,.3,.1,.1"
    l[2]="2,45,4,4,3,40,20,.3,.3,.5,.5"
    l[3]="3,45,6,6,3,60,30,.3,.3,.5,.5"
    l[4]="4,45,7,7,3,40,20,.3,.3,.5,.5"
    l[5]="5,45,8,8,3,60,30,.3,.3,.5,.5"
end
    
function Levels:setLevel(g,x)
    local l=self.levelstable[x]
    --print(x)
    local ltable=Levels:explode(",",l)
    g.level=ltable[1]
    g.maxtime=ltable[2]
    g.minwordlength=ltable[3]
    g.maxwordlength=ltable[4]
    g.minwordselect=ltable[5]
    g.angularvelocity=ltable[6]
    g.linearvelocity=ltable[7]
    g.restitution=ltable[8]
    g.friction=ltable[9]
    g.lineardamping=ltable[10]
    g.angulardamping=ltable[11]
    local temp
    local t
    CLW=dictionary:findword(g.minwordlength,g.minwordlength)
    phy.selectingstart=nil
                phy.selectingend=nil
    phy:reset()
    
end
        
function Levels:explode(div,str) 
    if (div=='') then return false end
    local pos,arr = 0,{}
    -- for each divider found
    for st,sp in function() return string.find(str,div,pos,true) end do
        table.insert(arr,tonumber(string.sub(str,pos,st-1))) -- Attach chars left of current divider
        pos = sp + 1 -- Jump past current divider
    end
    table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
    return arr
    
end