supportedOrientations(LANDSCAPE_ANY)
function setup()
    displayMode(FULLSCREEN)
    --displayMode(OVERLAY)
    smooth()
    set_Globals()
end 

function draw()
    background(0,0,0)
    if gState ==1  then
        startup:draw()
    elseif gState==2 then
        welcome:draw()
    elseif gState==3 then
        game:draw()
    elseif gState==4 then
        levelcomplete:draw()
    elseif gState==5 then
        levelintro:draw()
    end
    buttons:draw()
    if CLW ~=nil then
        if g_showinfo then
            local fps = 1/DeltaTime
            local l=0
            if game~=nil then
                l=game.currentlevel
            end
            pushMatrix()
            pushStyle()
            font(f[1])
            fontSize(18)
            translate(WIDTH/2,20) textAlign(CENTER) text(math.floor(fps).." "..CLW.." level "..l,0,0)
            popStyle()
            popMatrix()
        end
    end
end

function createCircle(x,y,r)
    local circle = physics.body(CIRCLE, r)
    -- enable smooth motion
    circle.interpolate = true
    circle.x = x
    circle.y = y
    circle.friction=0
    circle.sleepingAllowed = false
    return circle
end

function createGround()
    gWallLeft={} gWallTop={} gWallBottom={} gWallRight={}
    local t=HEIGHT-gTi
    local b=gBi
    local l=gLi
    local r=WIDTH - gRi
    gWallLeft.mybody = physics.body(POLYGON, vec2(0,b), vec2(0,t), vec2(l,t),vec2(l,b))
    gWallTop.mybody = physics.body(POLYGON, vec2(0,t), vec2(0,HEIGHT), vec2(WIDTH,HEIGHT), vec2(WIDTH,t))
    gWallRight.mybody = physics.body(POLYGON, vec2(r,0), vec2(r,t), vec2(WIDTH,t), vec2(WIDTH,0))
    gWallBottom.mybody = physics.body(POLYGON, vec2(l,0), vec2(l,b), vec2(r,b), vec2(r,0))
    
    gWallLeft.x=-1 gWallLeft.y=b gWallLeft.h=t gWallLeft.w=l
    gWallBottom.x=-1 gWallBottom.y=-1 gWallBottom.h=b gWallBottom.w=gChipTable.w
    gWallLeft.mybody.type=STATIC gWallTop.mybody.type=STATIC
    gWallRight.mybody.type=STATIC gWallBottom.mybody.type=STATIC
    gWallLeft.mybody.restitution=game.restitution
    gWallTop.mybody.restitution=game.restitution
    gWallRight.mybody.restitution=game.restitution
    gWallBottom.mybody.restitution=game.restitution
end

function touched(touch)
    if gState==1 then
        startup:touched(touch)
    elseif gState==2 then
        welcome:touched(touch)
    elseif gState== 3 then
        phy:touched(touch)
    end
end

function collide(contact)
    --print("normimp",contact.normalImpulse)
    if contact.state==BEGAN then 
        if theid~=contact.id then
            theid=contact.id
            local cba=contact.bodyA
            local cbb=contact.bodyB
            local a=contact.normalImpulse
            if a<10 then a=10 elseif a>60 then a=60 end
            sound("Dropbox:201806__fartheststar__poker-chips2",a/60)
            --print(contact.normalImpulse)
        end
    end
    if contact.state==MOVING then 
        if theid~=nil then
            if theid==contact.id then
                theid=nil
            end
        end
    end
    if contact.state==ENDED then
        if theid~=nil then
            if theid==contact.id then
            theid=nil
            end
        end
    end
    --print("cont state and id",contact.state,contact.id)    
end

function saveData()
    saveProjectData("dict1", saveString)
end


 function permutation(a,n,cb,t)
    if n == 0 then
        
        cb(a,t)
    else
        for i = 1, n do
            a[i], a[n] = a[n], a[i]
            permutation(a, n - 1, cb,t)
            a[i], a[n] = a[n], a[i]
        end
        
    end
    --print(#t)
end
 
--Usage
function callback(a,t)
    --print('{'..table.concat(a)..'}')
    t[#t+1]=table.concat(a)

end
    
function explode(d,p)
  local t, ll
  t={}
  ll=0
  if(#p == 1) then return {p} end
    while true do
      l=string.find(p,d,ll,true) -- find the next d in the string
      if l~=nil then -- if "not not" found then..
        table.insert(t, string.sub(p,ll,l-1)) -- Save it in our array.
        ll=l+1 -- save just after where we found it for searching next time.
      else
        table.insert(t, string.sub(p,ll)) -- Save what's left in our array.
        break -- Break at end, as it should be, according to the lua manual.
      end
    end
  return t
end