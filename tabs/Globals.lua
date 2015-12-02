function set_Globals()
    g_showinfo=true
    --gState  1 startup screen 2 welcome screen 3 game in motion 4 game complete 5 level intro
    gState=2
    g_pause=false --boolean true is system/game paused
    local update = tween.update
    local noop = function() end
    tween.pauseAll = function() tween.update = noop end
    tween.resumeAll = function() tween.update = update end
    g_scorefontsize=42
    g_vertRatio=.065
    g_horizRatio=0.0488
    g_displayRatio=0.125
    g_displayPos=HEIGHT-(HEIGHT*g_displayRatio)
    gBi=HEIGHT*g_vertRatio 
    gTi=HEIGHT*g_displayRatio+g_scorefontsize
    gFi=HEIGHT-HEIGHT*g_vertRatio
    gLi=WIDTH*g_horizRatio
    gRi=WIDTH*g_horizRatio
    --gLi=52 gRi=52 --gBi=52 -- board indents from edges of screen
    gChipTable={}
    gChipTable.w=WIDTH-gLi-gRi
    gChipTable.h=HEIGHT-gBi-gTi
    gChipTable.centre=vec2(gLi+(gChipTable.w/2),gBi+(gChipTable.h/2))
    g_scalar=1.2
    local wordtotal=0
    for i=1,#Words do
    wordtotal = wordtotal + #Words[i]
    end
    print(wordtotal)
    CWLtotal=wordtotal
    font("HelveticaNeue-CondensedBlack")
    f={} --fonts
    f[1]="AmericanTypewriter-Bold"
    f[2]="ArialRoundedMTBold"
    f[3]="HelveticaNeue-Bold"
    f[4]="HelveticaNeue-CondensedBlack"
    f[5]="Noteworthy-Bold"
    f[6]="MarkerFelt-Thin"
    f[7]="Papyrus"
    
    --font("MarkerFelt-Thin")
    physics.gravity(vec2(0,0))
    still=false
    --font(f[3])

    currenttouchid=nil
    
    colours={}
    colours["felt_yellow"]=color(212, 202, 52, 155)
    colours["felt_yellow_lite"]=color(212, 202, 52, 50)
    colours["felt_yellow_touched"]=color(255, 239, 0, 142)
    colours["bronze"]=color(91, 57, 30, 255)
    colours["gold"]=color(255, 153, 0, 255)
    colours["bronze-lite"]=color(101, 67, 40, 255)
    colours["gold-orange"]=color(153, 87, 26, 255)
    gColour_timer=colours["gold"]
    gColour_score=colours["felt_yellow_touched"]
    gSounds={}
    gSounds.success={}
    gSounds.fail={}
    --gSpr="Dropbox:chip_1"
    gSpr="Project:chip-master"
    local a=gSounds.success
    a[1]="Game Sounds One:Female Cheer 1"
    a[2]="Game Sounds One:Female Cheer 2"
    a[3]="Game Sounds One:Female Cheer 3"
    a[4]="Game Sounds One:Male Cheer 1"
    a[5]="Game Sounds One:Male Cheer 2"
    a[6]="Game Sounds One:Male Cheer 3"
    local a=gSounds.fail
    a[1]="Game Sounds One:Female Grunt 1"
    a[2]="Game Sounds One:Female Grunt 2"
    a[3]="Game Sounds One:Female Grunt 3"
    a[4]="Game Sounds One:Female Grunt 4"
    a[5]="Game Sounds One:Female Grunt 5"
    a[6]="Game Sounds One:Male Grunt 1"
    a[7]="Game Sounds One:Male Grunt 2"
    a[8]="Game Sounds One:Male Grunt 3"
    a[9]="Game Sounds One:Male Grunt 4"
    a[10]="Game Sounds One:Male Grunt 5"
    phy=Physics()
    startup=Startup()
    welcome=Welcome()
    levels=Levels(self)
    --levelcomplete=LevelComplete()
    --levelintro=LevelIntro()
    buttons=Buttons()
end