

Targets = class()

function Targets:init(num)
    --self.gap=(WIDTH-li-ri-260)/num
    self.gap=(WIDTH-gLi-gRi-260)/10 --string.len(CLW)
    self.lettertargets={}
    self.feedback={}
    for i=1,num do
        local t=Target(i,num,self)
        self.lettertargets[i]=t
        --self.feedback[i]=t.feedback
    end
    -- you can accept and set parameters here
end

function Targets:draw()

end
-----------------------------

Target = class()

function Target:init(i,num,ts)
    self.targetnumber=i
    local step=ts.gap
    local g=1
    if num==1 or math.fmod(num,2)==1 then g=0 end
    local posneg=1
    if i<(1+num)/2 then posneg=-1 end
    local a=gChipTable.w/2
    local b=posneg
    local c=(num/2)+.5
    local d=math.floor(c)
    local e=math.abs(d-i)
    local f=ts.gap/2
    local y
    if g==1 then
        
        if i>num/2 then
            y=num/2-(num+1-i)
        else
            y=num/2-i
        end
    else
        y=math.abs(math.floor(num/2+.5,1)-i)
    end
    x=gLi+a+posneg*(y*ts.gap+g*f)
    self.position=vec2(x,g_displayPos)
    
end

function Target:draw()

end

function Target:touched(touch)
    -- Codea does not automatically call this method
end

