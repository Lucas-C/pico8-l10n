pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--rETURN OF THE slimepires!
--a sOPHIE hOULDEN GAME

--sophieh.itch.io
--patreon.com/sophiehoulden


--todo:
--block way to lab x if 
--  generators are still on?


cartdata("slimepires_1_0")
--0 to 3 = endings unlocked
--4 = continue data exists
--5,6 = checkpoint x, y
--7 = carnage
--8 = gifted
--9,10,11 = generators off/on
--12+ = switches/levers

--uncomment to reset ending data
--dset(0,0)
--dset(1,0)
--dset(2,0)
--dset(3,0)


function savedata()
 dset(4,1)
 dset(5,savex)
 dset(6,savey)
 dset(7,carnage)
 
 bset(8,gifted)
 
 bset(9,gen1on)
 bset(10,gen2on)
 bset(11,gen3on)
 
 for a in all(actors) do
  if (a.saveid) bset(a.saveid,a.on)
 end
end

function bget(i)
 return dget(i)==1
end
function bset(i,v)
 dset(i,0)
 if (v) dset(i,1)
end

title=true

p_idle,p_aim,p_aim⬆️,p_aim⬆️➡️,p_run,
p_duck,p_slide,p_rise,p_fall,p_hang,p_laddera,
p_ladder
=
{1},{2},{3},{29},split("4,5,6,7"),
{8},{9},{10},{11},{12},{13},
split("13,13,14,15,15,14")

s_idle={24}
s_run=split("24,24,25,26,25")
s_duck={26}
s_slide={27}
s_air=split("16,17,18,19")
s_fall={16}

fuseoff={68}


rooms={}
actors={}
parts={}
savex=-1
savey=-1
carnage=0
tdelta=1/60

menu={"cONTINUE","nEW gAME"}
flashframe=0

lastframe=-1
prompt = ""
coyote=0
shootwait=0

menuindex=2
if (bget(4)) menuindex=1


patrons="tHIS GAME MADE POSSIBLE THANKS TO pico-8 BY lEXALOFFLE, AND MY amazing PATRONS: ♥ aBE gELLIS ♥ aLAN hAZELDEN ♥ aLEX mOLE ♥ aMAZING sTACE ♥ aNDREW lIM ♥ aNDREW sHOULDICE ♥ aNDREW wILLIAMS ♥ aNDY bUSCH ♥ aNDY nOELKER ♥ aNNETTE ♥ aRCADELY ♥ bERIA sANDERS ♥ bOB bUECHLER AND mANDY rOSE nICHOLS ♥ bRIAN vACEK ♥ c ♥ cAT aZAZEL ♥ cb dROEGE ♥ cHARLES mACmULLEN ♥ cHRIS ♥ cHRIS fORBES ♥ cIAN bOOTH ♥ cLAIRE ♥ cLARITY ♥ cOLIN sTRONG ♥ cONNOR sHERLOCK ♥ cOOL gHOSTS ♥ CUBEGHOST ♥ CURIOUSdna ♥ d p ♥ dAN fRIES ♥ dANIEL cASSIDY ♥ dARKFLUX ♥ dAVID hAYWARD ♥ dAVID rYSKALCZYK ♥ dAVIO cIANCI ♥ dEREK cARROLL ♥ dORIAN bEAUGENDRE ♥ dREW mESSINGER-mICHAELS & lAUREN vILLEGAS ♥ DUCK ♥ dREWBOT ♥ eD kEY ♥ EDDERIOFER ♥ eDMUND lEWRY ♥ eDWARD pROSSER ♥ eLLIOTT dAVIS ♥ eRIC sCHWARZOTT ♥ eRIN cONGDEN ♥ eRIN eLDRIDGE ♥ FERNLAGER ♥ fRAGGLEROCK ♥ fRANCIS fERNANDEZ ♥ fREYJA dOMVILLE ♥ fROYOK ♥ gEORGE hARNISH ♥ GKR ♥ gREG v. ♥ gREGORY aVERY-wEIR ♥ hANNAH cAIRNS ♥ hAYDEN sCOTT-bARON ♥ hODGE ♥ iAN dANSKIN ♥ J ♥ jACK mILTON ♥ jAKE hADLEY ♥ jAMIE ♥ jAN kALUZA ♥ JCTWIZARD ♥ jED jOHNSON ♥ JIB ♥ jOAKIM aLMGREN ♥ jOERG fRIEDRICH ♥ jONATHAN sTOLER ♥ jONATHAN wRIGHT ♥ jONES rOSS ♥ jORDI DE pACO ♥ jOSEPH ♥ jOSEPH cHESSUM ♥ jOSH gIESBRECHT ♥ kATHRYN lONG ♥ kEVIN ♥ KLERIL ♥ KNOWN_BLOB ♥ kSHITIJ sOBTI ♥ lANE ♥ lE-rOY kARUNARATNE ♥ lEE ♥ lEMMO pEW ♥ lENNY mORAYNISS ♥ lEONARD wITTE ♥ lIAsAE ♥ lILITH wHITE ♥ lILY v ♥ lOTTIE ♥ lTREON ♥ lUCAS aUGUSTO ♥ lUCY dAVINHART ♥ lUKE ♥ mARTIN hELLQVIST ♥ mATHEW vARKKI ♥ mATTHEW sEELEY ♥ mCrEALZ ♥ mICHAEL ♥ mICHAEL aDAMS ♥ mICHAEL cOOK ♥ mIKE wATSON ♥ mISTODON ♥ MONO ♥ MXKNITS ♥ nEIL ♥ nICA fEE ♥ nICK vER vOORT ♥ nORGG ♥ oWEN rACCUGLIA ♥ pARACHUTING tURTLE ♥ pAT wINCHELL ♥ pERIWINKLE ♥ pERPLAMPS ♥ pETE aLEX hARRIS ♥ pHOEBE sMITH ♥ pIPER gORDON ♥ pYROKA ♥ rAV ♥ rGN ♥ rICHARD fABIAN ♥ rOB cOLVIN ♥ rOB hAINES ♥ rOG dOLOS ♥ rOYCE rOGERS ♥ sARAH mCcORMACK ♥ sEAN dICK ♥ sEAN sONG ♥ sETZEROMUS ♥ sHAUN aDARKAR ♥ sIGNE rHEA gRAU kRISTENSEN ♥ sOREN ♥ sTACY rEAD ♥ sTEPHEN mAXWELL ♥ sTINGINGnETTLE ♥ tAD pATTERSON ♥ tERRY ♥ tHORNAE ♥ tIM mONKS ♥ tOM mClEAN ♥ tOM vINE ♥ tRACE bULLET ♥ vINCE mCKELVIE ♥ vIOLET l ♥ WARBLE WARBLE ♥ wILL tEMPLETON ♥ ZEP ♥ zOEaGXN ♥ zOYA ♥"


emprexlocs={{872,328},
{976,352},
{968,264},
{795,240},
{872,360}}

function addroom(n,xmin,xmax,ymin,ymax,bg)
 r={}
 r.name,
 r.solids,
 r.shootables,
 r.interactors
 =n,{},{},{}
 
 r.xmin,r.xmax,r.ymin,r.ymax
 =xmin,xmax,ymin,ymax
 
 if (not bg) bg=-1
 r.bg,r.w,r.h
 =bg,(xmax-xmin)*8+8,(ymax-ymin)*8+8
 
 add(rooms,r)
end
function getroom(x,y,default)
 for r in all(rooms) do
  if x>=r.xmin*8 and x<r.xmax*8+8 then
  if y>=r.ymin*8 and y<r.ymax*8+8 then
   return r
  end
  end
 end
 
 return default
end
addroom("escape",0,15,0,15)
addroom("entrance",0,15,16,31)
addroom("start",0,15,32,47)
addroom("spikeintro",16,39,32,47)
addroom("tall1",40,47,40,63)
addroom("center",40,71,16,39)
addroom("genny1a",16,39,16,31)
addroom("genny1b",16,39,0,15)
addroom("genny1c",40,55,0,15)
addroom("genny1",56,71,0,15)
addroom("doors",72,87,26,36)
addroom("mgs3",88,91,30,63)
addroom("mgs3b",92,95,33,52)
addroom("genny2",72,87,0,15)
addroom("genny2a",72,99,16,25)
addroom("genny2ab",100,115,16,25)
addroom("genny2b",116,127,0,25)
addroom("genny2c",88,115,0,15)
addroom("genny3",72,87,37,52)
addroom("genny3a",48,71,40,52)
addroom("genny3b",48,87,53,63)
addroom("saferoom",92,105,57,63)
addroom("shrine",88,95,26,29)
addroom("sanctpath",92,105,53,56)
addroom("sanctuary",106,127,53,63)
addroom("boss1",96,127,26,52)
addroom("boss1exit",112,127,0,25)
addroom("labx",32,39,48,55)
addroom("laby",32,39,56,63)
addroom("labz",0,31,48,63,0)



function addactor(typ,x,y,keeptile)
 a={}

 a.typ,a.startx,a.starty
 =typ,x*8,y*8
 
 --print(x)

 a.room = getroom(a.startx,a.starty)
 
 if (not keeptile) mset(x,y,0)
 
 if (typ=="turbine") mset(x,y,mget(x,y+1))
 if (typ=="fuse") mset(x,y,49)
 
 if typ=="egg" 
 or typ=="switch"
 or typ=="door"
 or typ=="emprexwall" then
  add(a.room.solids,a)
 end
 
 
 if typ=="barrel" 
 or typ=="bat"
 or typ=="mob"
 or typ=="emprex"
 or typ=="oblivion" then
  add(a.room.shootables,a)
 end
 
 if typ=="lever" 
 or typ=="checkpoint" then
  add(a.room.interactors,a)
 end
 
 add(actors,a)
 
 return a
end



function makeactors()
 for layer=0,3 do
 for x=0,127 do
 for y=0,63 do
 
  
 
  --bottom layer
  if layer==1 then
   
   if mget(x,y)==31 then
    addactor("checkpoint",x,y,true)
   end
   
   if mget(x,y)==46 then
    addactor("emprexwall",x,y)
   end
   
   if mget(x,y)==125 then
    addactor("oblivion",x,y)
   end
   
   if mget(x,y)==127 then
    addactor("emprex",x,y)
   end
   
   if mget(x,y)==20 then
    addactor("egg",x,y)
   end
   
   if mget(x,y)==72 then
    addactor("fuse",x,y).fuseid=1
   end
   if mget(x,y)==65 then
    addactor("turbine",x,y).fuseid=1
   end
   if mget(x,y)==73 then
    addactor("fuse",x,y).fuseid=2
   end
   if mget(x,y)==66 then
    addactor("turbine",x,y).fuseid=2
   end
   if mget(x,y)==88 then
    addactor("fuse",x,y).fuseid=3
   end
   if mget(x,y)==81 then
    addactor("turbine",x,y).fuseid=3
   end
   
   
   if mget(x,y)==44 then
    addactor("barrel",x,y)
   end
  end
  
  --middle layer
  if layer==2 then
   if mget(x,y)==1 then
    p=addactor("player",x,y)
   end
   
   if mget(x,y)==24 then
    addactor("mob",x,y)
   end
   
   if mget(x,y)==16 then
    addactor("bat",x,y)
   end
  end
  
  --top layer
  if layer==3 then
   --if mget(x,y)==59 then
   -- addactor("bucket",x,y)
   --end
   
   if mget(x,y)==45 then
    addactor("switch",x,y)
   end
   if mget(x,y)==84 then
    addactor("lever",x,y)
   end
   
   if mget(x,y)==47 then
    door=addactor("door",x,y)
    door.doorheight=1
    mset(x,y,35)
    for i=1,2 do
     if mget(x,y+i)==47 then
      mset(x,y+i,35)
      door.doorheight+=1
     else
      goto doorstop
     end
    end
    ::doorstop::
   end
   
  end
  
  
 end
 end
 end
 
end


function initactors(newgame)

 if newgame then
  gen1on,gen2on,gen3on
		=bget(9),bget(10),bget(11)
 end
 
 if newgame then
  gifted=bget(8)
 end
 
 
 saveid=12
 for a in all(actors) do
  a.x,a.y,a.fx,a.fy,a.frame,a.anim
  =a.startx,a.starty,0,0,1,p_idle
  
  if a.typ=="player" then
   if savex!=-1 then
    a.x,a.y=savex*8,savey*8
   end

   
   slimed,
   infected,
   unslime,
   grounded,
   hanging,
   ladder,
   slide,
   px,
   py
   =
   false,
   -1,
   -1,
   true,
   false,
   false,
   0,
   a.x,
   a.y
  
  end
  
  if a.typ=="emprexwall" then
   a.solid=true
  end
  
  if a.typ=="emprex" then
   a.emprex=true
   a.boss=true
   a.invulnerable=true
   a.dialogued=gifted
   a.sin=0
   a.wait=1
   a.dir=0
   
   a.hp=60
   a.flash=0
   a.shootable=true
   a.radius=18
   
   a.gone=false
  end
  
  if a.typ=="oblivion" then
   a.oblivion=true
   a.boss=true
   a.invulnerable=true
   a.dialogued=false
   a.sin=0
   a.sinb=0
   
   a.hp=80
   a.flash=0
   a.shootable=true
   a.radius=15
   
   a.xmin=24
   a.xmax=222
   
   a.gone=false
  end
  
  if a.typ=="barrel" then
   a.anim={44}
   a.hp=3
   a.flash=0
   a.shootable=true
   a.radius=4
   a.flashcol=7
   a.sploded=false
  end
  
  if a.typ=="egg" then
   a.anim=split("20,20,21,22,22,22,21,21")
   a.solid=true
   a.hp=4
   a.flash=0
   a.slimer=true
  end
  
  if a.typ=="fuse" then
   a.anim=fuseoff
  end
  
  if a.typ=="turbine" then
   a.anim=split("1,67,83,-67")
  end
  
  if a.typ=="bat" then
   a.anim=s_air
   a.hp=4
   a.flash=0
   a.shootable=true
   a.radius=5
   a.circ=rnd()
   a.slimer=true
  end
  
  
  if a.typ=="mob" then
   a.anim=split("24,24,25,26,27,26,25")
   a.hp=6
   a.flash=0
   a.shootable=true
   a.radius=5
   a.slimer=true
   
   a.hflip=rnd()<0.5
   if newgame then
    findbounds(a)
   end
  end
  
  if a.typ=="switch" then
   a.saveid=saveid
   if (newgame) a.on=bget(saveid)
   saveid+=1
   
   a.anim={45}
   if (a.on) a.anim={46}
   
   a.hp=1
   a.solid=true
  end
  
  if a.typ=="lever" then
   a.saveid=saveid
   if (newgame) a.on=bget(saveid)
   saveid+=1
   
   a.anim={84}
   a.hflip=a.on
   a.interact=true
  end
  
  if a.solid then
   a.swidth=8
   a.sheight=8
  end
  
  if a.typ=="door" then
   a.anim={47}
   a.solid=true
   a.swidth=8
   a.sheight=8
   if (a.doorheight>1) a.sheight=16
   if (a.doorheight>2) a.sheight=24
  end
  
  if a.typ=="checkpoint" then
   a.anim={31}
   a.interact=true
  end
  
  if (a.anim) a.frame=rnd()*#a.anim+1
  
 end
 
 
 
 --link switches to doors
 for a in all(actors) do
  if a.typ=="door" then
   --a.switchindex=1
   for ab in all(actors) do
    if (ab.typ=="switch" or ab.typ=="lever") and ab.room==a.room then
     a.switchindex=ab
     if ab.on then
      a.y-=8*a.doorheight
     end
    end
   end
  end
 end
end




function addbullet(typ,x,y,fx,fy)
 b={}
 b.typ,b.x,b.y=typ,flr(x),flr(y)
 b.lx,b.ly,b.fx,b.fy,b.life=b.x,b.y,fx,fy,5
 
 add(blts,b)
end


function addpart(typ,x,y,fx,fy)
 part={}
 part.typ=typ
 part.x=x
 part.y=y
 part.fx=fx
 part.fy=fy
 part.life=5
 part.draw=0--circ by default
 part.room=theroom
 
 part.col=7
 part.rad=25
 
 if typ=="goo" or typ=="blood" then
  
  --part.col=rnd{2,2,2,8}
  part.col=rnd(split("2,2,2,8"))
  if typ=="goo" then
   --part.col=rnd{3,3,3,3,3,11,11,11,8}
   part.col=rnd(split("3,3,3,3,3,11,11,11,8"))
  end
  
  part.rad=rnd()*2
  part.life=rnd()*0.5+0.2
 end
 
 if typ=="spark" then
  part.draw=1
  --part.anim={39,40,41,42,42}
  part.anim=split("39,40,41,42,42")
  part.wait=rnd()*0.1
  part.hflip=rnd()>0.5
  part.vflip=rnd()>0.5
  part.frame=0
  part.framewait=1
 end
 
 add(parts,part)
 
 if typ=="flash" then
  xx,yy=part.x,part.y
  for i=1,30 do
   x=xx+(rnd()*part.rad-part.rad*0.5)--*1.5
   y=yy+(rnd()*part.rad-part.rad*0.5)--*1.5
   fx=(rnd()-0.5)*500
   fy=(rnd()-0.5)*500
   addpart("spark",x,y,fx,fy)
  end
 end
 
end


function checkpointnow(cx,cy,mksound)
 
 if mksound!=false then
 if savex!=cx or savey!=cy then
  if (infected<0) sfx(5)
 end
 end
 
 savex=cx
 savey=cy
 
 savedata()
 
end


function dienow()
 sfx(0)
 dead=true
 
 if slimed then
  addsplats("goo",px,py)
 else
  addsplats("blood",px,py)
 end
end

function addsplats(typ,x,y)
 for i=0,30 do
  addpart(typ,x+rnd()*8,y+rnd()*8,(rnd()-0.5)*300,rnd()*-100-50)
 end
end

function spawnnow(newgame)
 blts={}
 dead=false
 deadtime=0
 initactors(newgame)
 setroomatplayer()
 
 spireskilled=0
end

function setroomatplayer()
 p.room = getroom(px+4,py+4,theroom)
 theroom = p.room
 solidactors=theroom.solids
 shootyactors=theroom.shootables
 interactors=theroom.interactors
end

function findbounds(a)
 a.xmin=a.startx-1
 a.xmax=a.startx+1
    
 while not (tilecheck(a.xmin,a.y,0) or tilecheck(a.xmin,a.y,1))
 and tilecheck(a.xmin,a.y+8,0) do
  a.xmin-=8
 end
 
 a.xmin=max(a.xmin,a.room.xmin*8)
 
 while not (tilecheck(a.xmax,a.y,0) or tilecheck(a.xmax,a.y,1))
 and tilecheck(a.xmax,a.y+9,0) do
  a.xmax+=8
 end
 a.xmax-=8
end

function explode(x,y,rad,dmg)
 sfx(18)
 for a in all(actors) do
  if a.room==theroom and a.hp and a.hp>0 then
		 if touches(x,y,a.x+4,a.y+4,rad) then
	   hurtit(a,dmg)
	  end
	 end
	end 
	
	if touches(x,y,px+4,py+4,rad*0.65) then
	 dienow()
	end 
end


function hurtit(a,dmg)
 if a.typ=="switch" then
  deny=false
  if (a.room.name=="doors" and not (gen1on and gen2on and gen3on)) deny=true
  
  if a.on then
   sfx(8)
  else
   if deny then
    sfx(12)
   else
    sfx(7)
    a.on=true
    a.anim={46}
   end
  end
  
  return
 end
 
 if (not a.hp) return
 
 a.hp-=dmg
 a.flash=1
 
 splat=false
 if a.hp<1 and a.typ!="barrel" then
  a.anim={0} 
  splat=true
  if a.typ=="egg" then
   a.solid=false
  	a.anim={23}
  else
   spireskilled+=1
  	carnage=max(spireskilled,carnage)
  end
 else
  sfx(10)
 end
 
 
 if splat then
  sfx(0)
  addsplats("goo",a.x,a.y)
 end
end
-->8


--tdelta=1/30
--function _update()
function _update60()

 if (ending>0) return

 btn🅾️,btn❎,btn⬇️,
 btn⬆️,btn⬅️,btn➡️=
 btn(🅾️),btn(❎),btn(⬇️),
 btn(⬆️),btn(⬅️),btn(➡️)

 if title then
	 if bget(4) then
	  if btnp(⬆️) or btnp(⬇️) then
	   menuindex+=1
	   if (menuindex>2) menuindex=1
	   sfx(17)
	  end
  end
  
  if btnp(❎) or btnp(🅾️) then
   if menu[menuindex]=="nEW gAME" then
    for i=4,63 do
     dset(i,0)
    end
   else
    savex,savey,carnage=dget(5),dget(6),dget(7)
    
   end
   sfx(14)
   makeactors()
   spawnnow(true)
   title=false
  end
 
  return
 end

 playerupdate()
 bulletupdate()
 
 for a in all(actors) do
  if not dead and a.room == theroom then
  
   if a.typ=="checkpoint" then
    a.anim={31}
    if flr8(a.x)==savex
    and flr8(a.y)==savey then
     a.anim={30}
    end
   end
   
   if a.typ=="emprexwall" then
    a.solid=true
    a.anim={85}
    if carnage==0 then
     a.solid=false
     a.anim={0}
    end
   end
   
   if a.typ=="emprex" and not dialogue then
    if a.dialogued then
     if theroom.name!="sanctuary" and a.hp>0 then
	    
		    bosslocation=1
		    --aimspin=0.5
		    if (a.hp<40) bosslocation=2
		    if (a.hp<30) bosslocation=3
		    if (a.hp<20) bosslocation=5
		    if (a.hp<10) bosslocation=4
		    
		    tgtx,tgty=emprexlocs[bosslocation][1],emprexlocs[bosslocation][2]
		    a.x=lerp(a.x,tgtx,tdelta*3)
		    a.y=lerp(a.y,tgty,tdelta*3)
		    if touches(tgtx,tgty,a.x,a.y,10) then
		     a.wait-=tdelta
		     if a.wait<0 then
		      a.invulnerable=false
		      a.wait+=0.15
		      a.dir+=1.3*tdelta
		      a.dir+=0.12
			     for i=0,4 do
			      dir=a.dir+i/4
			      addbullet("e",a.x+4,a.y,sin(dir)*50,cos(dir)*50)
		      end
		     end
		    end
		   end
	   
    else
    
	    if px>a.x-6 then
	     a.dialogued=true
	     bosstalk="foul shell from a foul soul,\nyour vileness knows no bounds!\n\nwe rejected your predecessor,\n\nwe reject you as well!"
	     if theroom.name=="sanctuary" then
	      bosstalk="welcome, pure one.\n\nyou have treasured my kind,\nand preserved your humanity.\n\naccept this gift, become both."
	     end
	     inspectnow()
	     
	    end
    end
   
	   
	   
   end
   
   if a.boss and a.hp<=0 then
    a.hp-=tdelta
    if not a.gone then
     
     a.y+=tdelta*5
     if rnd()>.8 then
      splatty="blood"
      if a.typ=="emprex" then
       splatty = "goo"
      end
      addsplats(splatty,a.x-8+rnd()*16,a.y)
      
     end
     if a.hp<-5 then
      addpart("flash",a.x+4,a.y+4,0,0)
      a.gone=true
      sfx(18)
      sfx(20)
     end
    else
     
     if a.hp<-7 then
      if a.typ=="emprex" then
       setending(1)
      else
       setending(4)
      end
     end
     
    end
   end
   
   if a.typ=="fuse" then
    
    if (a.fuseid==1 and gen1on) or
    (a.fuseid==2 and gen2on) or
    (a.fuseid==3 and gen3on) then
     if a.anim==fuseoff then
      a.anim=split("72,72,73,73,88,88,89,89")
      --a.frame=ceil(rnd()*#a.anim)
      a.frame=rnd()*8+1
     end  
    else
     a.anim=fuseoff
    end
   end
   
   if a.typ=="turbine" then
    
    a.on=(a.fuseid==1 and gen1on)
    or (a.fuseid==2 and gen2on)
    or (a.fuseid==3 and gen3on)
    
   end
   
   if a.typ=="lever" then
    a.hflip = a.on
   end
   
   if a.typ=="door" then
    onisopen = true
    if a.room.name=="saferoom" then
     onisopen=false
    end
    if a.switchindex.on==onisopen then
     a.y=max(a.y-tdelta*8,a.starty-8*a.doorheight)
     if a.y>a.starty-8*a.doorheight then
      sfx(11)
     end
    else
     a.y=min(a.y+tdelta*25,a.starty)
     if a.y<a.starty then
      sfx(9)
     else
      if (not onisopen) setending(2,34)
     end
    end
    
   end
   
   if a.typ=="oblivion" then
    if not a.dialogued then
     if px<a.x then
      a.dialogued=true
	     bosstalk="you were meant to rot. humanity\nand all else are meant to end.\n\n   ...perish!"
	     inspectnow()
     end
    else
     if not dialogue and a.invulnerable then
      a.invulnerable=false
      a.sinb=0.25
     end
    end
   end
   
   if a.typ=="mob" or a.typ=="oblivion" then
    move=10
    if (a.hflip) move=-10
    if (a.typ=="oblivion" and a.invulnerable) move=0
    
    a.x+=move*tdelta
    
    
    for sa in all(solidactors) do
		   if sa.solid and sa.room==theroom and solidactoroverlap(a.x+4,a.y+2,1,1,sa) then
		    a.x-=move*tdelta
		    a.hflip=not a.hflip
		   end
		  end
    
    if (a.x<a.xmin) a.hflip=false
    if (a.x>a.xmax) a.hflip=true
   end
   
   if a.typ=="bat" then
    a.hflip=false
    if (a.circ<0.5) a.hflip=true
    a.y=a.starty+sin(a.circ)*10
    a.x=a.startx+cos(a.circ)*8
    a.circ+=tdelta*0.4
    if (a.circ>1) a.circ-=1
   end
   
   
   if a.flash then
    if (a.flash>0) a.flash-=tdelta*1.5
   end
   
   if a.typ=="barrel" and not a.sploded then
    if a.hp<=0 and a.flash<=0.7 then
     a.sploded=true
     a.hp=-99
     a.anim={0}
     addpart("flash",a.x+4,a.y+4,0,0)

     explode(a.x+4,a.y+4,30,10)
     
    end
   end
   
  end
 end
 
 
 for part in all(parts) do
 	
 	if part then
	 	if part.life<0 then
	   --remove particle
	   del(parts,part)
	  else
	  
	   part.x+=part.fx*tdelta
		 	part.y+=part.fy*tdelta
		 	
		 	part.life-=tdelta
	  
		 	if part.typ=="flash" then
		 	 part.rad-=tdelta*200
		 	 if part.rad<0 then
		 	  part.life=-1
		 	 end
		 	end
		 	
		 	if part.typ=="goo" or part.typ=="blood" then
		 	 part.fx*=0.92
		 	 part.fy+=tdelta*350
		 	end
		 	
		 	if part.typ=="spark" then
		 	 part.wait-=tdelta
		 	 if part.wait<0 then
		 	  part.framewait-=tdelta*10
		 	  if part.framewait<0 then
		 	   part.frame+=1
		 	   part.framewait+=1
		 	  end
		 	  
		 	  part.fx*=0.8
		 	  part.fy*=0.8
		 	  if part.frame>=#part.anim then
		 	   part.life=-1
		 	  end
		 	 end
		 	end
	 	
 	end
 	end
 end
 
end

function bulletupdate()
 if (dead) return
 for b in all(blts) do
  --b=blts[i]
  
  if b then
   if b.life<0 then
    --remove bullet
    del(blts,b)
   else
    --update bullet
    --b.life-=tdelta
    
    
    b.lx=b.x
    b.ly=b.y
    
    b.x+=b.fx*tdelta
    b.y+=b.fy*tdelta
    bx,by=b.x,b.y
    
    hit=false
    if tilecheck(bx,by,0) then
     hit=true
     if tilecheck(bx,by,7) then
	     --hit low wall
	     if by - (flr8(by)*8)>2 then
	      hit=false
	     end
	    end
    end
    
    for a in all(solidactors) do
		   if a.solid and a.room==theroom and solidactoroverlap(bx,by,1,1,a) then
		    hit=true
		    hurtit(a,1)
		   end
			 end
			 
			 for a in all(shootyactors) do
			  
			  if a.room==theroom and a.hp>0 then
			   if touches(bx,by,a.x+4,a.y+4,a.radius) then
			    
			    
			    if not a.invulnerable and a.slimer != gifted and b.typ!="e" then
			     hit=true
			     hurtit(a,1)
			    end
			    
			    if a.typ=="barrel" then
						  sfx(19)
						 end
			    
			   end
			   
		   end
			 end
			 
			 if b.typ=="e" and touches(bx,by,px+4,py+4,2) then
     dienow()
			 end
    
    if hit then
     del(blts,b)
    end
    
   end
  end
  
 end
end
-->8
--drawing



function _draw()
-- if true then
-- cls()
-- spr(0,0,0,16,16)
-- return
-- end
 if ending>0 then
	 if endingbar<64 then
	  endingbar+=tdelta*10
	  rectfill(0,0,127,endingbar,0)
	  rectfill(0,128-endingbar,127,127,0)
  else
   drawprompt()
  end
  return
 end


 cls(0)

 if title then
  print(patrons,160-time()*25,122,1)
  
  print("sOPHIE hOULDEN'S",32,10,1)
  print("rETURN OF THE",38,28,2)
  --print("slimepires",44,35,11)
  otext("slimepires",44,35,10,3)
  
  spr(1,61,60)
  if (dget(0)==1) spr(23,29,60)
  if (dget(1)==1) spr(8,45,60)
  if (dget(2)==1) spr(16,77,60)
  if (dget(3)==1) spr(24,93,60)
  
  menuy=84
  menustart=1
  if (not bget(4)) menustart=2
  for i=menustart,2 do
   menustr=menu[i]
   menucol=6
   if menuindex==i then
    menustr="◆ "..menustr
    menucol=7
   end
   print(menustr,1,98+i*7,menucol)
  end

  print("v1.1",112,112,1)
  
  return
 end


 flashframe-=tdelta*10
 if (flashframe<0) flashframe+=1

 
 xmin=theroom.xmin*8
 xmax=(theroom.xmax-15)*8
 ymin=theroom.ymin*8
 ymax=(theroom.ymax-15)*8
 
 camx=mid(xmin,px-60,xmax)
 camy=mid(ymin,py-60,ymax)
 
 --put the room center screen
 if theroom.w<128 then
  camx=xmin+theroom.w*0.5-64
 end
 if theroom.h<128 then
  camy=ymin+theroom.h*0.5-64
 end
 
 camera(camx,camy)
 
 camclip()
-- if theroom.bg!=-1 then
--  rectfill(camx,camy,camx+128,camy+128,theroom.bg)
-- end
 
 if (theroom.bg!=-1) pal(1,0)
 map(theroom.xmin,theroom.ymin,theroom.xmin*8,theroom.ymin*8,theroom.xmax+1-theroom.xmin,theroom.ymax+1-theroom.ymin)
 
 
 drawactors()
 
 drawbullets()
 
 drawparticles()
 
 if prompt!="" then
  --prx=px-promptoff
		otext(prompt,px-promptoff,py-8,7,0)
 end
 
 if theroom.name=="saferoom" or theroom.name=="doors" then
  otext("safe room >",748,473,13,1)
  otext("safe room >",656,280,13,1)
 end
 
 camera()
 clip()
 
 if dialogue then
  drawprompt()
 end
 
   
 --print(spireskilled,0,0)
 --print(carnage,0,8)
 --print(1+2*flr(bosslocation%2),0,16,7)
end

function camclip()
 clip(theroom.xmin*8-camx,theroom.ymin*8-camy,theroom.w,theroom.h)
end

function drawactors()

 for a in all(actors) do
 	
 	if a.room==theroom then
	 	if (not dead) a.frame+=tdelta*13--90/7
	 	if (a.frame>#a.anim+1) a.frame=1
	 	
	 	s=a.anim[flr(a.frame)]
	 	ax,ay=a.x,a.y
	 	if a.typ=="door" then
	 	 clip(ceil(ax-camx),ceil(a.starty-camy),8,a.doorheight*8)
    spr(47,ax,ay)
    if (a.doorheight>1) spr(47,ax,ay+8)
    if (a.doorheight>2) spr(47,ax,ay+16)
    camclip()
	 	else
	 	 if a.typ=="turbine" then
	 	  if a.on then
	      turbinepal(a.fuseid)
	     else
	      turbinepal(0)
	     end
	     spr(65,ax,ay,2,2)
		    if a.on and s!=1 then
		     --a.hflip=s<0
		     spr(abs(s),ax+4,ay+4,1,1,s<0)
		    end
	 	 else
	 	  if a.emprex and not a.gone then
	 	   if (a.flash>0.9) palall(8)
	 	   
	 	   if (a.hp<=0) ax+=flr(flashframe*2)
	 	   
	 	   --circ(ax+4,ay+4,a.radius,7)
	 	   ax+=1
	 	   ay-=8
	 	   a.sin+=tdelta*0.8
	 	   asin=sin(a.sin)
	 	   asina=sin(a.sin-0.1)*3
	 	   asinb=sin(a.sin-0.2)*4
	 	   spr(112,ax-8,ay+asina)
	 	   spr(112,ax-16,ay+8+asina)
	 	   spr(113,ax+8,ay+asina)
	 	   spr(113,ax+16,ay+8+asina)
	 	   
	 	   spr(108,ax-8,ay+8+asina)
	 	   spr(108,ax,ay+8+asina)
	 	   spr(108,ax+8,ay+8+asina)
	 	   
	 	   spr(124,ax-8,ay+16+asina)
	 	   spr(108,ax,ay+asina)
	 	   
	 	   spr(108,ax,ay+16+asina)
	 	   spr(124,ax+8,ay+16+asina)
	 	   spr(124,ax,ay+24+asina)
	 	   
	 	   spr(111,ax,ay-14+asin*4,1,2)
	 	   spr(0,ax+16+asin*-3,ay+16+asinb,1,1)
	 	   spr(0,ax-16-asin*-3,ay+16+asinb,1,1,true)
	 	   
	 	   
	 	  else
	 	   if a.oblivion and not a.gone then
	 	    --circ(ax+4,ay+4,a.radius,7)
	 	    zapfill(a)
	 	    
	 	    
	 	    if (a.flash>0.9) palall(11)
	 	   
	 	    if a.hp<=0 then
	 	     ax+=flr(flashframe*2)
	 	     --a.sinb=0
	 	     --if (rnd()>0.985) sfx(21)
	 	    
	 	    else
	 	     if (rnd()>0.92 and a.dialogued) sfx(21)
	 	    end
	 	    
	 	    pal (11,0)
	 	    
	 	    ax+=1
	 	    ay+=1
	 	    spr(125,ax,ay)
	 	    
	 	    a.sin+=tdelta*0.5
	 	    if (not dead) a.sinb+=tdelta*0.1
	 	    if (a.sinb>0.5) a.sinb-=0.5
	 	    for i=1,8 do
	 	     spr(125,ax+16*sin(a.sin+i/8)*cos(a.sinb),ay+16*cos(a.sin+i/8)*sin(a.sinb))
	 	    end
	 	    
	 	    
	 	    
	 	   else
	 	    if (s!=0) ospr(s,ax,ay,1,1,a.hflip,a)
	 	   end
	 	  end
	 	 end
	 	end
	 	
	  
	  pal()
  end
	end
	
end

function zapfill(a)
 if a.invulnerable then
  --a.sinb=0
  return
 end
 if (a.hp<1) return
 
 bx,by,horiz=a.x+4,a.y+4,false
 
 if (a.sinb*2>0.25 and a.sinb*2<0.75) horiz=true
 power=abs(0.5-a.sinb*2)*2
 if (horiz) power=1-power
 power^=5
 power*=20
 for w=-power,power do

  col=rnd{2,2,2,8,8,14}
  
  if horiz then
   line(0,by+w,512,by+w,col)
  else
   line(bx+w,0,bx+w,512,col)
  end
 end
 
 if not dead then
  by-=4
  bx-=4
	 if horiz then
	  if py>by-power and py<by+power then
	   dienow()
	  end
	 else
	  if px>bx-power and px<bx+power then
	   dienow()
	  end
	 end
 end
 
end


tpals={split("15,9,4,10,7"),
split("0,1,5,5,13"),
{},
split("14,8,2,15"),
split("11,3,1,12")}
function turbinepal(t)
 t+=2
 for i=1,#tpals[t] do
  pal(tpals[1][i],tpals[t][i])
 end
end

function drawparticles()

 for part in all(parts) do
 	
 	if part then
	 	if part.room==theroom then
		 	
		 	if part.draw==0 then
		 	 --circ
		 	 circfill(part.x,part.y,part.rad,part.col)
		 	else
		 	 --spr
		 	 if part.frame>0 then
		 	  spr(part.anim[part.frame],part.x-4,part.y-4,1,1,part.hflip,part.vflip)
		 	 end
		 	end
		  
		  pal()
		 else
		  --part not in this room
		  del(parts,part)
	  end
  end
	end
	
end

function drawbullets()
 for b in all(blts) do
  if b.typ=="e" then
  	circfill(b.x,b.y,1,11)
  else
	  col=7
	  if gifted then
	   col=11
	  end
	  line(b.x,b.y,b.lx,b.ly,col)
  end
 end
end
-->8
--helper funcs

function lerp(a,b,t)
 return (1-t)*a+t*b;
end



function movevert(my)
 --move player by my units
 if (my==0) return
 
 py+=my
 
 --resolve vert collisions
 while overlapssolid(px+2,py,3,7)
 or overlapsslope(px+2,py,3,7) do
  py+=-my*0.1
  p.fy=0
  if my>0 then
   --land
   if (not grounded) sfx(4)
   grounded=true
   ladder=false
   --p.fy=0
  else
   --bump head
  end
 end
 
 if cangrab(my) and not slimed then
  sfx(1)
  hanging = true
  px=flr8(px)*8+2
  if (p.hflip) px+=4
 end
 
end

function cangrab(my)
 --returns true if can grab onto
 --ledge when moving at my speed
 
 if (my<0) return false
 
 
 local xoff=7
 if (p.hflip) xoff=0
 
 
 if (tilecheck(px+xoff,py,0)) return false
 if (not tilecheck(px+xoff,py+1+my,0)) return false
 if (tilecheck(px+xoff,py-my,0)) return false
 
 py=flr8(py)*8+7
 
 return true
end

function movehoriz(mx)
 --move player p by mx units
 
 --return if motion is too small
 if (abs(mx)<0.01) return
 
 safex=px
 safey=py
 targetx=px+mx
 
 while px!=targetx do
  px+=mx*0.1
  --moved far enough
  if (mx>0 and px>targetx) or
     (mx<0 and px<targetx) then
   px=targetx
  end
  
  --check if we can be where we moved to
  bump = false
  
  if overlapssolid(px+2,py,3,7,slide!=0) then
   bump = true
  end
  
  --move up any slopes we travelled
  while overlapsslope(px+2,py,3,7) 
  and not bump do
   py-=0.1
   grounded=true
   p.fy=0
   --if we can't move up more
   --we should just bump back
   if overlapssolid(px+2,py,3,7) then
    bump = true
   end
  end
  
  --move down any slopes we travelled
  if grounded then
   oldy=py
   while not overlapsslope(px+2,py+1,3,7)
   and not overlapssolid(px+2,py+1,3,7)
   and py-oldy<1 do
    py+=0.5
    p.fy=0
   end
   if py-oldy>=1 then
    --we are walking off a ledge?
    py=oldy
   end
  end
  
  if bump then
   p.fx=0
   px=targetx
  else
   --can move to here
   safex=px
   safey=py
  end
 end
 
 px=safex
 py=safey
 
end

function overlapssolid(x,y,w,h,allowlow)
 --returns true if an object
 --at x,y with w,h(width,height)
 --overlaps a solid tile
 
 if (x<0 or x+w>1024) return true
 
 
-- for thex=x,x+w do
--  for they=y,y+h do
--   if (solidmappixel(thex,they,allowlow)) return true
--  end
-- end
 
  for they=y,y+h,h*0.25 do
   if (solidmappixel(x,they,allowlow)) return true
   if (solidmappixel(x+w,they,allowlow)) return true
  end
 
 
-- if (solidmappixel(x,y,allowlow)) return true
-- if (solidmappixel(x+w,y,allowlow)) return true
-- if (solidmappixel(x,y+h,allowlow)) return true
-- if (solidmappixel(x+w,y+h,allowlow)) return true 	
-- if (solidmappixel(x,y+h*0.33,allowlow)) return true
-- if (solidmappixel(x+w,y+h*0.33,allowlow)) return true 	

 
-- if allowlow then
--  if (tilecheck(x,y,0) and not tilecheck(x,y,7)) return true
--	 if (tilecheck(x+w,y,0) and not tilecheck(x+w,y,7)) return true
--	 if (tilecheck(x,y+h,0) and not tilecheck(x,y+h,7)) return true
--	 if (tilecheck(x+w,y+h,0) and not tilecheck(x+w,y+h,7)) return true
-- else
--	 if (tilecheck(x,y,0)) return true
--	 if (tilecheck(x+w,y,0)) return true
--	 if (tilecheck(x,y+h,0)) return true
--	 if (tilecheck(x+w,y+h,0)) return true 	
-- end
 
 --now check solid actors
 for a in all(solidactors) do
  
  if a.room==theroom and solidactoroverlap(x,y,w,h,a) then
   if (a.slimer) infect()
   return true
  end
 end
 
 return false
end

function solidmappixel(x,y,allowlow)
 if tilecheck(x,y,0) and
 tilecheck(x,y,7) then
  if (allowlow) return false
  return y-flr8(y)*8<3
 else
  return tilecheck(x,y,0)
 end
end

function lowtilecheck(x,y,w,h)
	if (tilecheck(x,y,0) and tilecheck(x,y,7)) return true
 if (tilecheck(x+w,y,0) and tilecheck(x+w,y,7)) return true
 if (tilecheck(x,y+h,0) and tilecheck(x,y+h,7)) return true
 if (tilecheck(x+w,y+h,0) and tilecheck(x+w,y+h,7)) return true
 return false
end



function solidactoroverlap(x,y,w,h,a)
 if (not a.solid) return
-- if x+w>a.x and x<a.x+a.swidth
-- and y+h>a.y and y<a.y+a.sheight then
--  return true   
-- end
-- 
-- return false
 return x+w>a.x and x<a.x+a.swidth and y+h>a.y and y<a.y+a.sheight
end

function tilecheck(x,y,layer)
 if (y<0) y=0
 return fget(mget(flr8(x),flr8(y)),layer)
end

function overlapsslope(x,y,w,h)
 if (pointonslope(x,y)) return true
 if (pointonslope(x+w,y)) return true
 if (pointonslope(x,y+h)) return true
 if (pointonslope(x+w,y+h)) return true
 return false
end

function pointonslope(x,y)
 --returns true if x,y overlaps
 --some slope
 if not tilecheck(x,y,1) then
  --tile isn't a slope
  return false
 end
 
 --define slope of tile
 px1=flr8(x)*8
 px2=px1+8
 py1=flr8(y)*8+8
 py2=py1-8
 
 if tilecheck(x,y,2) then
  --halfstep up
  py2=py1-4
 end
 if tilecheck(x,y,3) then
  --halfstep up 2
  py1-=4
  py2-=1
 end
 if tilecheck(x,y,4) then
  --fullstep up
  --this is default so eh
  py2-=1
 end
 if tilecheck(x,y,5) then
  --fullstep down
  py1=py2
  py2+=8
  py1-=1
 end
 if tilecheck(x,y,6) then
  --halfstep down 2
  py1=py2
  py2+=4
  py1-=1
 end
 if tilecheck(x,y,7) then
  --halfstep down
  py2=py1
  py1-=4
 end
 
 --now check if x,y is below
 --the line between p1 and p2
 ly=lerp(py1,py2,1-(px2-x)/8)
 return ly<=y
end


function flr8(v)
 --converts a position from
 --game space to map space
 return flr(v/8)
end
-->8
--player update


function playerupdate()

 if (py<0) setending(3)

 prompt = ""
 
 if dialogue then
  if btnp(⬇️) then
   dialogue=false
   bosstalk=nil
  end
  return
 end
 
 promptid={}
 
 if dead then
  deadtime+=tdelta
  if (deadtime>1) spawnnow()
  return
 end
 
 if carnage>58
 and theroom.name=="mgs3"
 and py>44*8 then
  px+=4*8
  setroomatplayer()
  sfx(18)
  for i=1,3 do
   addpart("flash",px-8+rnd()*16,py-64+rnd()*128,0,0)
  end
  checkpointnow(94,49,false)
 end

 
 if gifted then
  infected=-1
  if (btn🅾️) slimed=true
  if (btn❎) slimed=false
 end
 
 if infected>0 then--and not p.slimed then
  beepwait-=beeprate*tdelta
  if beepwait<0 then
   beeprate+=0.2
   sfx(12)
   beepwait+=1
  end
 
  infected+=tdelta
  if infected>8.4 then
   sfx(13)
   slimed=true
   infected=-1
  end
 else
  beeprate=1
  beepwait=1
 end
 
 inlowtile=lowtilecheck(px+2,py,3,7)

 --horizontal input/forces
 if slide==0 then
	 if not hanging then
	  if btn⬅️ then
	   p.fx-=tdelta*260
	   p.hflip=true
	  end
	  if btn➡️ then
	   p.fx+=tdelta*260
	   p.hflip=false
	  end
	 end
	 
	 if not btn⬅️ and not btn➡️ then
	  p.fx = lerp(p.fx,0,tdelta*20)
	 end
	 
	 p.fx=mid(-38,p.fx,38)
	 
	 if (p.shooting) p.fx=0
	else
	 --sliding
	 if (btn⬅️) p.hflip=true
	 if (btn➡️) p.hflip=false
	 
	 if not inlowtile or abs(slide)>50 then
   slide = sgn(slide) * (abs(slide)-tdelta*200)
		
		 if (abs(slide)<20) slide=0
  end
  p.fx=slide
 end
 
 --grounded/falling
 if not grounded then
  p.fy=min(p.fy+230*tdelta,90)
 end
 
 if hanging or ladder then
  p.fy=0
  p.fx=0
 end
 
 if ladder then
  if btn⬆️ and tilecheck(px,py,2) then
   p.fy=-25
  end
  if btn⬇️ and tilecheck(px,py+7,2) then
   p.fy=25
  end
 end
 
 --move vertically
 movevert(p.fy*tdelta)
 if slimed then
  hanging=false
  ladder=false
 end
 
 --grab onto ladders
 if not hanging and not btn🅾️
 and not btn❎ and not slimed
 and tilecheck(px+4,py,2)
 and not tilecheck(px+4,py,1)
 then
  if btn⬆️
  or (btn⬇️ and not grounded)
  then
   ladder=true
   crouch=false
   px=flr8(px+4)*8
  end
 end
 
 
 
 --check if not grounded
 if not overlapssolid(px+2,py+1,3,7) and not overlapsslope(px+2,py+1,3,7) then
  grounded=false
 end
 
 
 movehoriz(p.fx*tdelta)
 
 coyote+=tdelta
 if (grounded) coyote=0
 
 --jumping
 if btn🅾️ and (not inlowtile or slide==0) then
	 if slimed then
	  p.fy=-35
	  grounded=false
	 else
		 if coyote<0.12 then
		  sfx(3)
		  p.fy=-70
		  grounded=false
		  coyote=10
		 end
	 end
 end
 
 --climbing from hanging/ladders
 if hanging and (btn⬇️ or btn❎) then
  grounded=false
  hanging = false
  movevert(2)
 end
 if btn🅾️ and (hanging or ladder) then
  sfx(3)
  p.fy=-70
  grounded=false
  hanging = false
  ladder = false
 end
 if btn❎ and ladder then
  ladder=false
 end
 
 
 --crouching/sliding
 crouch=false
 if btn⬇️ and grounded and
 not btn❎ and not ladder
 then
  crouch=true
  if slide==0 then
   if (btn➡️) slide=100
   if (btn⬅️) slide=-100
  end
 end
 
 prect={}
 prect.x=px+2
 prect.x2=px+5
 prect.y=py
 prect.y2=py+7
 prect.y3=py
 
 if not slimed then
  overlaps,o=rectoverlap(prect,31)
  if overlaps then
	  --checkpoint collision
	  if (infected>0) sfx(14)
	  checkpointnow(o.x,o.y)
	  infected=-1
  end
 end
 
 
 if grounded and not btn❎ and slide==0 then
  --readable (tile)
  overlaps,o = rectoverlap(prect,43)
  if not overlaps then
  	overlaps,o = rectoverlap(prect,107)
  end
  if not overlaps then
  	overlaps,o = rectoverlap(prect,126)
  end
  if overlaps then
	  prompt="⬇️ inspect"
	  promptoff=20
	  promptid = o
	  promptid.a=nil
  end
  
  --interactible (actor)
  interactor=getinteractible()
  if interactor!=-1 then
   if interactor.typ!="checkpoint" or slimed then
	  	--actable
		  prompt="⬇️ use"
		  promptoff=8
		  ignore,promptid = rectoverlap(prect,43)
	   promptid.a=interactor
    promptid.x=nil
   end
  end
 end
 
 if prompt!="" and slimed then
  prompt=slimeprompt--"⬇️ glub"
  promptoff=12
 end
 
 if prompt=="" then
  slimeprompt=rnd{"⬇️ glub","⬇️ ooze","⬇️ blub"}
 end
 
 prect.y2=py+1
 if p.fy>0 and not slimed and rectoverlap(prect,32) then
  --spike collision
  dienow()
 end
 
 --becoming infected
 if not gifted and infected<=0 and not slimed then
	 for a in all(shootyactors) do
	  if a.room==theroom and a.slimer and a.hp>0 then
		  if touches(px+4,py+4,a.x+4,a.y+4,a.radius) then
--		   p.infected=1
--		   sfx(12)
     infect()
		  end
	  end
	 end
 end
 
 
 if py>530 then
  --oob
  dienow()
 end
 
 

 --animations
 if grounded then
  if btn⬅️ or  btn➡️ then
   p.anim=p_run
  else
   if crouch then
    p.anim=p_duck
   else
    p.anim=p_idle
   end
  end
 else
  if p.fy<0 then
   p.anim=p_rise
  else
   p.anim=p_fall
  end
 end
 if slide!=0 then
  p.anim=p_slide
 end
 if hanging then
  p.anim=p_hang
 end
 if ladder then
 	if p.fy!=0 then
  	p.anim=p_ladder
  else
   p.anim=p_laddera
  end
 end
 
 
 
 if p.anim==p_run and flr(p.frame)==4 and lastframe!=4 and p.frame!=lastframe then
  if slimed then
   sfx(16)
  else
   sfx(1)
  end
 end
 
 if p.anim==p_slide and grounded then
  if slimed then
   sfx(17)
  else
   sfx(2)
  end
 end
 
 if slimed then
  if (p.anim==p_idle) p.anim=s_idle
  if (p.anim==p_run) p.anim=s_run
  if (p.anim==p_duck) p.anim=s_duck
  if (p.anim==p_slide) p.anim=s_slide
  if (p.anim==p_rise) p.anim=s_air
  if (p.anim==p_fall) p.anim=s_fall
 end
 if p.anim==s_air and flr(p.frame)==3 and 3!=lastframe then
  sfx(15)
 end
 
 
 if btn❎ and grounded then
  p.shooting = true
 else
  p.shooting = false
  shootwait=0
 end
 
 if slimed then
  p.shooting=false
  if btn❎ then
   sfx(10)
   unslime+=tdelta
   if unslime>0.8 then
    p.anim={28}
    dienow()
   end
  else
   unslime=0
  end
 end

 if p.shooting then
  
  if slide==0 then
	  p.anim=p_aim
	  if btn⬆️ then
	   p.anim=p_aim⬆️
	   if btn➡️ or btn⬅️ then
	    p.anim=p_aim⬆️➡️
	   end
	  end
	  if (btn⬇️) p.anim=p_duck
  end
  
  shootwait-=tdelta
  if shootwait<0 then
   shootwait=0.13
	  
	  shootx = 100
	  shooty = 0
	  fromx=px+8
	  fromy=py+1
	  
	  if p.hflip then
	   fromx=px-1
	   shootx = -100
	  end
	  
	  if btn⬆️ then
	   fromx=px+4
	   if (p.hflip) fromx-=1
	   fromy=py-1
	   shootx=0
	   shooty=-100
	   
	   if btn⬅️ then
	    shooty=-75
	    shootx=-75
	    fromx=px+1
	    fromy=py--+1
	   end
	   if btn➡️ then
	    shooty=-75
	    shootx=75
	    fromx=px+6
	    fromy=py--+1
	   end
	   
	  end
	  
	  if btn⬇️ then
	   fromy=py+3
	   if btn⬅️ then
	    shooty=75
	    shootx=-75
	   end
	   if btn➡️ then
	    shooty=75
	    shootx=75
	   end
	  end
	  if slide!=0 then
	  	fromy=py+4
	  end
	  sfx(6)
	 	addbullet("lzr",fromx,fromy,shootx,shooty)
	 end
 end
 
 
 
 if prompt!="" and btnp(⬇️) then
  
  inspectnow()
 end
 
 lastframe=flr(p.frame)
 
 p.x,p.y=px,py
 
 setroomatplayer()
end



function rectoverlap(r,tileid,o)

 o={}
 o.x=flr8(r.x)
 o.y=flr8(r.y)
 if (mget(o.x,o.y)==tileid) return true,o
 o.x=flr8(r.x2)
 if (mget(o.x,o.y)==tileid) return true,o
 o.y=flr8(r.y2)
 if (mget(o.x,o.y)==tileid) return true,o
 o.x=flr8(r.x)
 if (mget(o.x,o.y)==tileid) return true,o
 
 o.y=flr8(r.y3)
 if (mget(o.x,o.y)==tileid) return true,o
 o.x=flr8(r.x2)
 if (mget(o.x,o.y)==tileid) return true,o
 
 return false,o
end


--do actors a and b overlap
--function overlaps(a,b)
--
-- if a.x<b.x-8
-- or a.x>b.x+8
-- or a.y<b.y-8 
-- or a.y>b.y+8 then
--  return false
-- end
-- return true
--end
-->8

function touches(x1,y1,x2,y2,rad)
 if abs(x1-x2)>=rad
 or abs(y1-y2)>=rad then
  return false
 end
 xa,ya=(x1-x2)*0.01,(y1-y2)*0.01
 dist=sqrt(xa*xa+ya*ya)*100
 --if(dist<0) dist=32767 --clamp big numbers
 return abs(dist)<rad
end

function inspectnow()
 p.anim=p_idle
 if (slimed) p.anim=s_idle
 
 if slimed then
  dialogue=true
  return
 end
 if promptid.a!=nil then
  a=promptid.a
  a.on = not a.on
  if a.room.name=="genny1" then
   gen1on=a.on
  end
  if a.room.name=="genny2" then
   gen2on=a.on
  end
  if a.room.name=="genny3" then
   gen3on=a.on
  end
  return
 end
 dialogue=true
end

function getinteractible()
 for a in all(interactors) do
  if touches(a.x,a.y,px-0.4,py,5) then
   return a
  end
 end
 
 return -1
end
-->8
--drawing functions
function otext(s,x,y,c1,c2)
 print(s,x+1,y,c2)
 print(s,x-1,y,c2)
 print(s,x,y-1,c2)
 print(s,x,y+1,c2)
 print(s,x,y,c1)
end

function ospr(s,x,y,w,h,fx,act,o)
 --pal()
 
 if act.flash and act.flash>0.9 then
  palall(8)
  if act.flashcol then
   palall(act.flashcol)
  end
 end
 
 
 if act==p then
  --player sprite
	 if slimed and not dead and unslime>0 then
	  x+=flr(flashframe*2)
	 end
	 
	 if dead and flashframe>0.8 then
	  palall(8)
	 end
	 
	 if carnage>58 then
	  pal(4,8)
	 end
	 if gifted then
	  pal(4,11)
	 end
	 
	 if infected>0 then
	  spr(s,x,y,w,h,fx,false)
	  
	  pal(4,11)
	  pal(5,3)
	  pal(2,3)
	  pal(1,5)
	  cliph=infected
	  if p.grounded and btn(⬇️) or slide!=0 then
	   cliph=4+infected*0.5
	  end
	  
	  clip(ceil(px-camx),flr(py-camy),8,cliph,true)
	  spr(s,x,y,w,h,fx,false)
	  camclip()
	  return
	 end
 end
 
 if (act.typ=="fuse") turbinepal(act.fuseid)

 spr(s,x,y,w,h,fx,false)
end

function palall(v)
 for i=0,15 do pal(i,v) end
end

--{64,"objective:\n\nrestore power and\nreach the safe room!"},

msgs={
{64,"as ordered, i've changed the\nprotocols for the safe room\ncorridor's doors.\n\nthey will remain sealed even\nin case of power loss.\n\nwe can stay secure in there\neven if the horde break in and\ndamage the generators.\n\n~\n\ngood work, hopefully it won't\nbe necessary...\nbut better safe than sorry."},
{97,"maintenance report 2/7/2097:\n\nall systems fine.\nwalls are looking a bit green\nbut it's probably just moss."},
{33,"we've been hiding down here\nfor so long, maybe the horde\nisn't on the surface anymore?\n\n~\n\ndon't be a fool,\nwhere would they have gone!?\n\n~\n\ni don't know, space? where did\nthey even come from anyway?"},
{75,"if the safe room is the only\nplace that is completely\nslimeproof, why don't we\njust all move there?\n\n~\n\nyou want to live even more\ncramped than we do now?\n\n~\n\n...good point."},

{89,"i beckoned the horde,\n\nbut its emprex rejected me.\n\ni shall end it as well.",0},
{90,"the constant chattering.\n\nthe talk, the smiles,\neven in this dark place\nlife continues...\n\n\ni hate it.",0},
{91,"is there anything more\ndetestable than humanity?\n\nit is so close to its end,\nbut still it persists.\n\nit just needs a push...",0},
{92,"the horde is proof that other\nstates of being are possible.\n\nwhat could i become without\nthe bounds of my human shell?",0},

{35,"the others have no clue what\ni am doing, they don't even\nknow the horde is here.\n\ni'll erase all that survive.\n\nand then the horde.\n\nmy research will be my weapon.",0},
{37,"i had thought the horde to be\noblivion for humanity, but they\nare its worst aspects:\n\njoining, connection, 'love'...\n\ni reject it all now.\n\nseverance is the only true way\nforward, the true philosophy.",0},
{36,"my studies are complete, i\nhave acquired the hidden\nknowledge.\n\ni can become\n\n\n\nperfect destruction.",0},
{34,"i shall travel to the area\nabove my lab, and leave the\nlast of my humanity there.\n\nmy new, true, self will sink\n\n...and then grow!",0},

{122,"you are free of the terrible\npsyche that birthed you...\n\nbut it remains a threat.\n\nif it is not stopped, all\nthat is will cease to be.",2}
}

function drawprompt()

 str,strstyl = "",1

 
 if bosstalk then
  str,strstyl=bosstalk,2
  if theroom.name=="labz" then
   strstyl=0
  end
 end
 
 if ending>0 then
  str=endmsg[ending]
  strstyl=4
 else
 
  promptx=promptid.x
--  if promptid.x!=nil then
--   promptx=promptid.x
--  end
 
	 if slimed and not bosstalk and promptx!=122 then
	  if promptx then
	   --console
	   str="the device doesn't respond\nto your slimy inputs."
	  else
	   --interactor
	   if promptid.a.typ=="lever" then
	    str="the lever senses your gooey\nnature and refuses to move."
	   else
	    str="it's a restore point.\n\nit can heal partial infection\nand record a human to ensure\ntheir survival.\n\nit doesn't work for slimepires"
	   end
	  
	  end
	  strstyl=2
	 else
	 
		 for m in all(msgs) do
		  if m[1]==promptx then
		   str=m[2]
		   if (m[3]) strstyl=m[3]
		  end
		 end
		 
		 if (theroom.name=="sanctuary") gifted=true
		 
		 if promptx==78 then
		  if gen1on and gen2on and gen3on then
		   str="safe room access granted\n\nstatus:"
		  else
		   str="safe room access denied\n\ninsufficient power\n\nstatus:"
		  end
		  if gen1on then
		   str..="\ngenerator 1: online"
		  else
		   str..="\ngenerator 1: offline"
		  end
		  if gen2on then
		   str..="\ngenerator 2: online"
		  else
		   str..="\ngenerator 2: offline"
		  end
		  if gen3on then
		   str..="\ngenerator 3: online"
		  else
		   str..="\ngenerator 3: offline"
		  end
		 end
	 end
 
 
 end
 
 msgw,msgh=strsize(str)
 --msgw=msgsize.w*4
 --msgh=msgsize.h*6
 
 msgx=64-msgw/2
 msgy=10
 if ending>0 or bosstalk then
  msgy=64-msgh/2
 end

 --dark
 linecola,
 linecolb,
 fillcol,
 textcol
 = 5,0,0,6
 
 if strstyl==1 then
  --screen
  linecola,
  linecolb,
  fillcol,
  textcol
  =2,4,9,2
 end
 
 if strstyl==2 then
  --slime
	 linecola,
	 linecolb,
	 fillcol,
	 textcol
	 =11,3,1,11
 end

 line(msgx,msgy-2,msgx+msgw,msgy-2,linecola)
 line(msgx,msgy+msgh+2,msgx+msgw,msgy+msgh+2,linecola)
 rect(msgx-1,msgy-1,msgx+msgw+1,msgy+msgh+1,linecolb)
 rectfill(msgx,msgy,msgx+msgw,msgy+msgh,fillcol)
 print(str,msgx+1,msgy+1,textcol)

 if ending==0 then
  print("⬇️",61,msgy+msgh+4,textcol)
 end
end


function strsize(s)
 local w,linew,lines,substr=0,0,1,""
 for i=1,#s do
  substr=sub(s,i,i)
  if substr=="\n" then
   linew=0
   lines+=1
  else
   linew+=1
  end
  if (linew>w) w=linew
 end

 return w*4,lines*6
end
-->8

endingbar=0
ending=0
endmsg={
"           ending a:\n\nwith the slimepire emprex\ndefeated, all other slimepires\nwither away and die off.\n\nyou walk the earth, in solitude.",
"          ending b:\n\nyou live out the remainder of\nyour life here in isolation.\n\nsafe... but alone.",
"           ending c:\n\nyou fly to the surface and live\nhappily among the slimepires\nfor as long as life on earth\ncan continue...",
"          ending d:\n\nthe will of oblivion defeated,\nlife in the universe has been\nassured forever.\n\nyou join with the slimepires\nand begin a life full of love."
}


function setending(v,y)
 ending=v
 if (y) endingbar=y
 dset(v-1,1)
end

function infect()
 if infected<=0 and not slimed and not gifted then
  if (infected<=0) sfx(12)
  infected=1
 end
end
__gfx__
03bbb300000151000001510001105000000151000001510000015100000151000000000000000000000151000001510000000400041510000001100000015140
335bd330001440000014405515405400001440550014405500144055001440550000000000000000001440000414405500052200021110000411114000011120
35555100025d200000dd22400112200000dd224000dd224000dd224000dd2240000151000000000001d2d25501d2d24000d24100025110400221122004021120
33b5350001225200005255000d52500000525500005255000052550000525500001440550015100002225140000251000051200001d2d22001d2d200022d2d10
0553b5000011245000111000011100000011100000111000001110000011100000dd22400144055004111000001110000022100000112d0000112d0000d21100
005b53000015105000151000001510000015d0000051500000155d000115d0000052550025d2140000155d000115d00000012d00001111000011110000111100
0005333000d1d00000d1d00000d1d000002d00000015d00000d0120002d0100000111d0012210d0200d0120002d010000000520000d002000020020000200d00
0000000001201200012012000120120000012000001200000120000000001200015d1200411d5211012000000000120000021000002000000000000000000200
b330000b00000000000000000b0000b000bb310000bb1000000000000000000000003300000000000000000000000000000a300b005100500000b00000000000
03300b330b0000b0003b3300b33b3b330311331003133100000bb3100000000000038b00000033000000000000000000b3033030014405400000d00000000000
003b3330b33b333303b83830b3b83833b110b311b11b3310003113110000000000b5d00000038b000000000000000000003000000112220000666d0000666d00
00b8380033b83833b35330d3035d30003103b31133b313110b10b311200000200033b00000b5d00000003300000000000000003b0d525000006b2d0000638d00
035d3000035d3000b1d000333dd0000013bb313113313131131b31318200000003033b000033b30000038b0000000000003000030011100000ddd50000ddd500
333000003dd00000b30003b35000000013131311011313111333131100100002000b530003033b0000b5d0000000000003003000001510000015510000155100
500000005000000053300333000000001131311101313111113131111000028100335300003d53000033b30000b3b30000b3b30000d1d0000051150000511500
00000000000000000000000000000000011111100011111001111110020000200333333003333330d3333335d3333335d3333335012012000011110000111100
00000000001111001111111100000000d5d5d5d51111111128228825007000070000000000006600050550500d666d5001d76d1001222210013333107622296f
000000000050050011111111010000101511155511111111121282110000007000007700006000605000000564999945049fa9401288882113bbbb317d2299d6
0000000000111100111111110000000011111115111111111112211100077700007007000600006050000005d9ffff9d028ee820288228823bb33bb36d2999d6
00000000005005000110111001000010111d5111111d51111111211177777000007000000600000000000000d9ffff95049fa940282888823b3bbbb311444411
0060000000111100000000000000000011155111111551111111111100777700007007000600000000000500d4999945028ee82028288e823b3bbab37699926f
006000600050050000000000010000101111111111111111111121110000770000000700006000605000000505ddd550049fa9402888e8823bbbabb37d9922d6
605600600011110000000000000000001111111111111111111111110000007000007000000006005000005000100100028ee8201288882113bbbb316d9222d6
10150050005005000000000001000010111111111111111111111111000700000000000000006000050055000050050001dd6d10012222100133331011211211
011111111111111111111110d5d5d5d5d5d5d5d5d5d5d5d5d5d5d5d5d5d5d5d5111111110000000500000000000000d55d00000000000000d000000000000000
001111111111111111111100115115511551151111551151555111511151551111010101000000d5000000000000d511555d0000000000005500000000000000
051111111111111111111150111111511151111111111111155111110111511010010001000005510000000000d5551115155d000000000015d0000000000000
5111111111111111111111150111111111111111111111111511111100111110100000000000d55100000000d55551111111555d000000001555000000000000
11111111111111111111111101111111111111111111111111111110001011001000000000055511000000d551515111111115155d0000001155d00000000000
11111111111111111111111100111111111111111111111111110100000010000000000000d515110000d5111151111111111111155d00001151550000000000
1111111111111111111111110010111111111111111111111101000000001000000000000551111100d55111111111111111111115155d00111115d000001000
011111111111111111111110000001011111111111111111100000000000000000000000d1111111d511511111111111111111111111115d1111111510105010
0000000010777776666666011afffff11dddddd16d6d6d6d6d6d6d6d6d6d6d6d1dddddd11dddddd10111ddd55ddd111000000000000000dddd00000000000000
000000000766666666666d10a7a999ff515555151d1d1d1d1d1d1d1d1d1d1d1d5ffffff55ffffff511dd666dd66dd111000000000000dd6666dd000000000000
00000000666dddddddddddd1fa7a499fd677776d233133313331333133313332d9a99a9dd999999d1dd677766766dd110000000000dd66777766dd0000000000
0000100076dd50011115dd51f9a7a49f615555160110101010101010101010106a47a4a66444a4a61d67777667766d1100000000dd667777777766dd00000000
0001100076d51ffffff15d51f94a7a9fd111111d2d33313331333133313331d2d447447dd7a47a4dd677766dd7776dd1000000dd6677776666777766dd000000
0000000076d0ff9999ff6d51f994a7af51111115011010101010101010101010599a999559a79995d67766d5d6776dd10000dd66777766dddd66777766dd0000
0000000076d0f994499f6d51ff999a7a155555512d31333133313331333133d21ffffff11ffafff1d6776dd556776dd100dd66777766dddddddd66777766dd00
0000000066d1a7a7a7a76d516fffffa60111111001101010101010101010101001111110011111105d66d5515d66d551dd66777766dddd1111dddd66777766dd
0101011066d17a7a7a7a6d511ff7aff1070000002d33313331333133313331d21dddddd11dddddd15d66dd55dd66d55116666dd1ddd65dddd6776dd166766675
0011111066d1f994499f7d51ff9a79ff060000000110101010101010101010105ffffff55ffffff5d667766dd7776dd11d66ddd16667d666d6776dd1676dd6d1
0101011066d1ff9999ff7d51f997a99f006000002d3133313331d331333133d2d99a999dd9999a9ddd66777667766d1111dddd1177776777d6776dd176d77dd1
0011111066d56ffffff66d51f94a749f00d000000110101010101010101010106a4a4446644474a61dd666766766dd110111111077776777d6776dd16d76d5d1
0101011066dd56666776dd51f947a49f007777002d33313331333133313331d2d474747dd744744d11ddd66dd66ddd11010101106667d6666777766d6d7dd5d1
001111106dddddddddddd551f99a799f0766667001101010101010101010101059a9aa9559a9a99511ddddd55dddd11100111110ddd65ddd5d66d55166d55d51
0101010001d5555555555511ff97a9ff0dd66dd02d31333133d13331333133d21ffffff11ffafff11111ddd55d11111101010100ddd65dddd6776dd17dddd5d1
0011111010111111111111106ffa7ff6055555500110101010101010101010100111111001111110011111111111111000111110111d1111d6776dd151111111
6dd16dd1bbbbbbbb767d767d767d767d767d7d7df7f6fffdf7f6fffdf7f6ff7f8888888888888888888888880000000001010101bbbbbbbb3bb33bb300000000
d551d551b3bb33b36dd26dd26dd26dd25d625d65fd6f6dd1fd6f6dd1fd6f6f6f88822822228228822282888800666d5010101010bb33b3b33b31133100600600
d552d55113b313b36d51dd51d551d55155d15d61d5d5d551d5d5d551d5d5d5dd888822811221282128288828061010d101010101b313b313d311d55100300300
11101110113b13315110111011101110111011500110111001101110011101108822222211112211228882280d0101d1101010103b1331111110111030733703
6dd16dd1513b313176d166d16dd16dd1d661d6716f51fdd1f631f6d153df15f682821112111112111282228800d55511010101013b3131116dd16dd173b13b37
d551d551d51331116d516d51d551d5515d615d61f6516d516d516d515d56156f8228111111111111122118886dddddd51010101013311111d551d511bdb11b1b
d551d552d51315516d51dd51d551d5515dd15d61fd21d521d511d51115d112df821221111111121111112828011111100101010113111111d121d1520bd3b3b0
1110111011111110511011101110111011101150d5101110111011101111015d8821111111111111111121280500005010101010111111111110111000111100
0000000bb000000076d166d16dd16dd1d661d671ffd1f6316dd123d16d661dff6dd156d18221111111111228011111100101010100000000000000000b37bbb1
000000b3bb0000006d516d51d551d5515d615d61f6d16d51d511d5115d561d6fd211d2318882211112288888010001101010101000e88200000000007d1b33bb
00000bb33bb000006d51dd51d551d5515dd15d616f51d5d1d151d15115d115f6d521d521822211111112288801250110010101000e722820000000007531113b
000bbb333b3b0000511011101110111011101150fd60011011101110111106df1110111088822111111111280125211000101010272bbe2100000000b13bb31b
00bbb3313313b00076d166d16dd16dd1d661d6716f51f6d153316dd133df15f60000000088888212111122880111111000010100282b782100000000b5e53e51
00b3b1313113bbb06d516d51d551d5515d615d61f6516d51d511d5115d56156f0000000082221111128288880150011000001000028e821000000000015b3510
0b313111311131bb6d51dd51d551d5515dd15d61fd21d511d111d11115d112df0000000088211111111228880152511000010000002211000000000000133100
b3111121121111b3511011101110111011101150d5101110111011101111015d0000000082111111111112280111111000001000000000003b0030b300011000
130000000000000000000000000000031313131313131313131313131313131313131313131313132300008100f3f30073000000000000135213138383020203
131313c3d300000000001200000000000500f200f200f2000000005500000000160000000000000000001600000000000007e616000000000000000000000016
23000000000000000000000000000013131322831313832283002283838303131313131313228313230000334353230000000000000000031352131253435313
1313131313e3000000f31200f300b2000500f200f2f3f200000000550000005516000007161616121616e6000000000716e6e6000000000000000000000000e6
13c3d3f31000000000f3a3d3f3000003131300008300000000000000f1000083131313238300000313001200031313630000000000f341031352131213131313
1313a4b4671353646464646464646464e5646464646464646474125564741255161616e6e600001200000000000016e6e6160000000000000000000000000016
1313134362630000335313136300000313830000000000000000009343f381f38383f30000f3a313230012008300000000000000935343131352131283830313
1367e5a5d5b467676565656565a4d5d5b565656565656565657512556575125516000000000000120000120000000000e6000000000000000000000000000016
1313131323020202021313230000a31323000000f3a3d3f30000a3131343435353435300004313131381120000000000f300a3b3131313131352830000000083
8383c56767a585d5d5d5d5d5d5b5656565656565656565657500125575001255e6000000000000000000120016e60000160000000000000000000000000000e6
138322131313131313131323000013131300120043131353c3b31313131313131323830000830313135343e300000000334313131383008300f2000000f10000
00000500830083676767676767676767676767676767676775125465751254651600000000160000000012000000000016000000000000001616e61600000016
230000830000838300008383000083132300120083832213131313131383838300f1f300a3d3830313131313c3d312f3f32222838100f3f3f3f200936743c3d3
00f305f31200f30000f2000083156766156741874183416775128355751283551600000000000000000016000000000016161700000000000000000000000016
1300a3b34300120000535300000000032300120000000083228322838300f3000043534313134313131313131313125343534353435353535353531313671367
6666e57612566666666676001267676667670000000041676574125565746755e6e616000000000000000000000000000016e6160000000000000000000000e6
2300031323001200000313f300f3a31313d312f3000000000000000000004300002283000083d213131313131323120367676767676767676767676767676767
6713e577125767676767770012e5000083e50000000000577500125575671255160000000016001200000000000000000000000000000000000000000016e6e6
1300031323f312a3b31313534343131313134343001200000000000000f323000000f3a3b3425222832283031313120367677787835767778757677787830057
1367e58312f183676767830000c5000000e50000000000577512546575126765e6000000000000120000000000000000000000001616e6161700000000000016
23001313135343531313d2525213131313131313001200000000000000431300005343525223830000000000832312136777c200010000000000000000005667
6767e56666760057676700b20005004500c500f100000057751200557512005516000000000000120000000000f70000000000000000000016e6161600000067
23000313131313228383002252131313131313230012000000000000000383f3000083f2f383f3f300f1f30000f212036777c200000000000000000100008357
a485b567677712576767666666a5d5f5d5b566667600125765741255656712551600000000000016000000000000000000000000000000000000000000000016
230083131313230000f3000003522283830313134363000000730000000300435353431353434353534363003352431367677600c2a485e4f400000000000087
c58700008377125777838300000000c5000000000000125775831255750012551600001600000000000000000000000000000000000000000000000000001616
23000083031383003342424252830000008313138300000000000000432300830283228383028313138300f300f283136767770056e56666e576000000005666
e566760000570057770041a485c6f5f5f58585b4000012577512546575125465e600000000000000000000000000000000000000000000000000000000000067
13d3f3f32222f300f3f28300f100f30000f300020202020202f300f303130202230202020003021323004353435212037783f20057e56767e57700a4e4f45767
a5f5008100870057774115670000e500e5000015670100577512005575120067e616000000000000000000000000000000000000000000000000000016000016
1313535343435353431353435353435343534353435353434353434313134313131313530013431313008313d25212137700f2c283c58783c58300c567a585d5
b4e50056566666677700676700156700156700676712005765741255657412161600000000000000000000000000000000000016161616120000000000000016
13139696629696966262969696629696626296969662969662966262969613131313132300031313230000030023120377125676040504040504040504040057
a5b5125767676767770000c5006767f567670000e5120157758312557583120000000000e61616000000000000000000000000000000001200000000000016e6
13a70000000000000000000000000000000000000000000000000000000097131300f2000083d21323000003000312037712577700050000050100a585b40483
83041257676767677712156741e500c500e5001567124157751254656712000000000000000000000007161700f3000000000000000000000000f30000001667
a7000000000000000000000000000000000000000000000000000000000000972312335353535313130200130083121377005777c20500010500000000c50000
000012838787d25777006767d5b5000500a5d567674141577512005575671617000000000000f30007e6671616161700000000000000000000e6161617000016
a70000000000000000000000d7000000000000000000000000000000000000971312008322838313136300230000120377000057760502020502020202050202
020202025666666777000000000000050000000000000057657412556574121616170000f30716e616676767166716161700f30000f300071667671616170767
a7000000000000000000000000000000000000000000000000000000000000972300000000003313230000136300121367760057a4b56666a5d585d5d5b56666
66666666a4d5b46767667612566666e566666666666666677500125575676755e616e616161616e616166716676767e616161616e61616e667e6166767166767
a7000000000000000000000000000000000000020200000000000000000000972300000000000013130000230000120367770057e56767676767a4d585d5d585
d5b467a4b567c56767677712576767a5d585d5b467676767751254651616e667e616671616e6161616e61616e6676716e61667e61616e667e616e667166716e6
a700000000000000000000000000000000008696a6000000000000000000009713d3b7b6b7b60003230000030001121367770087e58783000083e58300005767
67e583c512000500835777120000f283000000c500838357751283e2008300008300000083830000008300008300000000830083838300008383000083008316
a700000202000200000000000000000000009796a700000000000000000000971313535353531213230000131200120367770000e50000000000c500010083c2
77c5000512000500000057667600f200f100000500000057657412e20000f30000000000f3000000000000000000000000000000000000000000000000000016
a70000869696a600000000000000000000000000a700000000000000000000971313131313830013230000031200120377830000a5f50012f585b50000000057
770500051200a5d5b400835767666666666666e57600005775831255e6166716e616166767e61667161616000000000000000000000000000000000000000067
a7000097a797a700000000000000000000000000000000000000000000000000008300228300121323000223120033137700000000c50012c500000000000057
7705000500005666e5760083a4d585d5b457d2e57712005775125465651465652465651565656565656567000000000000000000000000000000f70000000016
a7000097a797a700000000020202000000000000000000000000000000869662a612000000000003230043231200000377000000000500000500000000000083
57a5b40500000083e5830000c5008383c50000c5831200577512835565656565656565656575d255656516000000000000000000000000000000000000000016
a700009797a7a7000000008696a6000000000000000000000002020000000097a71200b7b7001213130083134363001377000000000581000500000000000000
8767a5b512000100e500010005000000050000050012005765741255656565656565656565750455656516000000000000000000000000000000000000000067
a7020000000000000000009796a7000000000000000000008696a600000000971353965363000003230000038300000377000000000556760500010000000000
0012000012000000e5000000050001000501000501120057750012557583008300838365040404000055671700f3000000000000000000000000e70000000067
13a60200000000000000009702a7000000000000000000009796a70000000097a78322830000000313000023000033137700f100000500830500000000000000
0012000012000000e500000005000000050000050012c2577512546575000000000000f2000000000055e616161617f100000000000000000016161617000016
a797a600000000000002029796a7000000000000000000009702a7020000029723b7b6b7b6b71213230200f30202020367666676000500000500000000567600
0012000012000000c50000660566006605006605005666677512830000000000000000f200000000005567e61667e6161700f30000f300071667671616170767
1396a700000000000086961302a700000000000000000000979613a6000086131353536253535313135343435353431377878300000500000500000000577700
000000001200000005000083058700830500870500835767656464646464646464646464646464646465671667676767e6161616e61616166716166767166767
__label__
00000000000000000000200020000000200000000000200000202020202020202220202020202220202020000000000000000020200020200000000000000000
00000000000000000200000002000000000002020000020222020202022222000000002220022222020202020200000000020000000200000000000000000000
00000000002000200020202000000020000020202000202202202022222000103331100220002202202020202000202020000020000000202000000000000000
00000000000200000000000000020000000002020200022002222222000113333333330000100200220202020202020200020200020000020000020000000200
00000000000000000000200000002020002000000000202010202220103333330333333301100200022020202020202020200000002020000000000000200000
00000000020002020000000000000200020202000202022010002201003333110113333300110200022202020202020202020000000202000000000000000002
00002020200000200020202000000000000020200020202010300011003111110111133001010203022020200020202020200000000000000000000000000000
00000200000200000002020000000200000202020202022010b3001030111110001111100101020b020202000202000202020202000002000200000002000000
00002020200000200000002000202000202020202020222010b30110b3011110b011110b0110000b022020202020000020202020000000002020000000200020
00000002000200000002000002020202000202020202220010b30110b3011110b011100b1010003b020202020202000202020202020002020002020002000000
00002000002020000000202000200000202020000000200000b300110b001110b00100b33011003b002022202020202000002020000020200000202000002000
02000000020202000002020200020000020202003bb0000000b310010b001100b00103b3301003b0000000020202020200020000000000000000020000020000
000000202020200000002020202020202022202003bbbb00103b30010b300100b0000b3310103b3003bb33022220202020200020200000000000202020200020
00020002020200000000000002020202020202020333b331100b33000b33010bb0003b330113bb30133330022202020202020200000002000000000202000000
000000200000000000002000002020202020202220003000000b331000b3000bb301b3300133b330111130222020202020202000200000202020002020002000
0002020000000000000002000002020002020222222000033303b33110b3310bb30bb330113b3300000100202222020202020002000002020200020200000200
000000000000000020200020000020000020202220203bb3b3303b3310bb330bb30b33011bb33003bb3000002022202020200020200000200000202020200000
00020200000000020002000000020202020202022200bbbbb3300b13303b3303bb03330333331013bbbb33000202220222200202020202000002000000000002
20002000200000200020202020202020202022222003bbbb3331001033333300bb333333301100333bbbbb300022222020202020202000000000000020000020
0202000200000002000200020202020202220202003bbbbb33111000011333333333331000001133bbbbbbb33002020200220202020200000002000200000200
202000200000200020002020002020222020202003bbbb33311110300011111111111000000b113333bbbbbb3300202022202020200020000000000000002000
020200000000020002000202000202022222020003bb333311100330100000000000000010b001333333bb3bb300020222020202020202000000000000020002
00202000002000000020002020002020222220203b33333111103b30010111111111111010bb011113333333bb30222220022022222022000000002000002020
0202000000000000000200020200020202020203333331110000bb330001333bbbb33310003b0111111333333330022202222222020220000000020202020202
0020202000200000200020202020202020202003310000000110b3330010013333331000003bb000011111111333022020222200202020000020200020200020
00000200000202020202020202020202020202001002000bb300bb3300100001111000000113b011100000000013020202020202020202000002000202000000
0020000000002020202020200022222020202020002020bb3310bb3100110800310080110013b00111b000222200002020200020202020002000002000000000
0000000000020202020202020202222202020202020200bb3310b33100031111311111300011bb011bbb02222202220202000202020200020000000000000200
0000000020200020202220002020222220202222202000b33110b331030333333113333000013b013bbb02222022202020202020202000000020002000002000
000000000202000002022202020202020202022222020b333100b310000033313303330010013b013bbb00222202020222220202020200220200020000020000
2000000020202020002020200020202020202022222003330000b31000100333003330001101b0033333b0022022222220202020222002202020002000200020
0000000002020202000202020202020202222202020033000220031001000131111310001101b003333333022202022202220202020222020002020002020002
00000000200020002000222222202020202222202020300022220b31010000133331000010033000000003002220202022202020202222202020000020200000
00020000000202020202022222020202020222020200002222200033010000011110000010330002002200002222220202020202022222020200000202000000
00000000202020202020202020202220202220202220202022000003010000000000000010300000222220002220202020202020222220200000000000002000
00000002020202020002022222020202222202020222022200031100010000000000000010001100022222222202220202022202022202000200000002000002
00000000002020202020202022202220222220202222202000333311010011000000110010111333002222222020222020222020202020002020002000000000
02000002020200020202020202220222020222222202220033333311110000110011000001113333300222222222020222022222020200020200000200000002
00000000202000000020202020222020202022222222200333333331110000000000000001133333333000022222202220202220202020202000002000000020
00000000020202000202020202220202222202222222003333333331110006665000000001133333000baaa00222222202020202020202020200020200000000
200000002020002000202222202220202222202202000333333313111005557775100000011333300baaaabba002222022202020202020202020202020000000
0200000202020202020222220202220222222220003333333333111100555567755100000113310baaab3333bba0022222222222020202220202020200020000
002020002000202022202222202020222220220033333333333311105555556665510000001130baaab333333bbbb02222222020202022202000002000000020
020202020202020222000000020202022202000333333333333111055555516665511000001100baab3331233333bb0222222202022222220202020202020002
0000002020202020200bbbbb00022222222200133333333313111005555516666551120000100baab333128882233b0000002222222222222020200020200000
000202020202020200bbaaabb0022222020001333133333311111055551115551111180000100baab33122000002113bbab00022220000000222020202000000
20202020200020220baaaaaabb00222000031333111333331111055511100000011118000010bbabb3328033330001bbaaaab000000baabb0000222020000000
00000202000002020baaaaaaaab0222003331333111331111111055111002220000180000010bbbb333220333333013bbaabb300bbaaaaaaaa30022200000000
0000202020202020bbaaaaaaaab0000033331333111331111110551100022222220200000010bbbb331803333333033b01bbbb303bbbbbbbbbab302020202000
0000020202020220baabbbbbbab00033333133311133111111005510022224444420000000103bb3312803333330113b18bb10301333333333ba302202000202
2000002020202020bbbbbbbbbbbb033333313331111111111105511002244442000800000010133312280133333011333bbb81102222222233bbb30220202020
0000000222222220bbbbbbbbbbbb033113313331111111211105511024400022100800000010211122820131333011103333332000000221213bb20202220202
0020202000222220bbbb10001bbb0331113113111111112111255110420100242112800000110222282011113330021123133020333300111133320022222020
0202020202222200b0bb00001bb30031133113111111112111251000244211244222800000011028800111111333002100100803333001111113312022020202
0020202020222220210b00811bbb0001130000000011122211021020044422442122800000001100001111111333300222288033330011333113332020202020
0002000002022220018b3113bbbbb0000000bbbbb0000022110210828444444244422000000021111111111113333300000003333301113b3333318022000000
2020202020222220010b3133bbb3bbbaaaaaaaaaabbb00021110208224444444422120000000021111121111133333333333333333031113bbb3328022202000
0202020202022200020b3333bbb33bbbbbbbaaaaaaaab30021102008824224442442200220000021122021111311133333311333330311133b33280022020000
0000202022220003302b3133bb313333bbbbbbaaaaaaabb000110200028224444220006680000002200021111111113133311133330211113312880220202020
020002222220013330023103bb0113333bbbbbaaaaaaaabbb001102201282242200066d680000002000021111111111133311133330821111228800222020202
202022222000331333023003bb01113bbbbbbbbbaabbbaaab3000000200112000006dd51000d0000000002111111111133111133133088222882000222202020
02020202003333133330233bb00113b33bbbbbbbbbbbbbbaaa3000000001000006d5511110155600000000211111111131111131133300888820330022020202
20202020033333133330023b00111b33bbbbb23bbbbbbbbbbbbb000000000006dd51111005566666000000211112211131111131113333000003333002222020
0202020033333313333002bb0011333bbbb33023bbb333bbbbbbb000000066dd5511101155666666600000211120011111111111111333333333333300020202
2020200033333313313008b201133bbbbbb331233b3313333bbbb3266000dd55511000015666665dd20000211200211111111111111113133333333330202020
0202003333333133111108b2010bbbbbbab331023331233333bbbb26dd00d5511000100056d556d5d20000212000211111111111111111133333333330000002
20200033133331331111088010bbbbbbbab333102332002313bbbb182d00d1111111100011555555d20000220000211111111111111111133333333330033000
000003331113111311110800aabbb33bbab333102310110013bbb1108dd0011d551111000011555d280000020000211111111111111111133333333338033330
003003331111111331111003aab3323bbbb333108200111013bbb11081100dd55511100dd0011155800000020000211111111000000111133333333338033333
03330833311111133111100aabb33023bbb3331008011110133bb1061110d555511100dd510011118000000000002111111000bbbb0001133133333338033333
33330833311111133111110aabbb3083bb333310000111101333100666d05555110000005100011880000000000021111100bbbbbbbb00133113133338033333
33330833311111133111110aabbb33023b333111333b11100333006dddd055510066ddd001110018000010000000021110bbbaaaaabbb0013111133338033333
33330033311111113111110babbb330813333111b3333110033000dddd515510566ddddd00118000000100000000021100bbaaaaa00bbb011111133388023333
33332083331111113111110ba3bb331081131013bb33311033066d50dd51500666dd5552d002000080101000000002200bbaaaaaa110bb003111133380022233
33328083331111113311110b33bb33110820011bbbb333103006d5005d511066dd555522dd0001d88101000000000200bb00aaabb18133b03111133380000823
33380083331111111111220b333333310000111babb33310306651005551066dd5555555528011d80010100010000200bb0bbbbbbb100bb01111333380020022
3328000833311111121120bb333133331111113babb33310006d5100511000dd55222225282015d8010101010000000bb00bbbbbbb33b3001111333300200082
32800108333111111212208b333003333311333bbb333331006511001000666d5551222282001558001010101000000bb30bbbbb3333b8001111333802020082
22801020831111111222808b333101333333333bbb33333106d51210056666dd551122882001555801010101010000aab300bb33333bb2011111333800202008
2801022008311111122800083331003bb33333333b33333106d51000005556dd51128800000111580010101010000bbb331000b3313320111133338002020000
8000222208311111122800008333102bb33311023b3333306d550666660055555128100000011100800101010000bab333110002331120111133388020202020
0002020200831111228000000833102bb3333110333303006500666666666d5512810000000100008010101000babb3331120000211200111111380022020202
0020202220882112228000000833308bbb3333102220310050666ddddddd551128100000000000dd800101000bbb333111128000021801111111880022202020
02000202200822222280001000833082bb33333022031000066666655d555112810000155dddddd800101003aa33331111228010008801111112800222020000
00002020220082222800010100833008823333330033000666ddddd65111111810000115555ddd580000003bb333331112280111100001111122800020202000
000202020220082228000010102b31100882133331100666ddddddd5d510001100001111111555580000bbb33300111122280111110011111228802222020200
202020222220088228000101002bb311000000011106666ddddd5551155110000001122222221118000bbbabbbb0012222280001111111112288002222202020
00020222220200882802001000bbbb1111111011100066ddddd55111111110000011088888822225800aaaabbbbb000120000120011111122280220202020202
2000222222222008880220010baabb31111310000006ddddd5551112821221000008000000008228800aaabbaabbbb0110033338000012222880222020202020
000202022202220080022200aaabbb1111333111006dddd555511001828210000000000000000888000aabaaaaaabb333bbbbbbb280012222802220202020202
000020202220202000202000aabbb1111333333005dd55211112110028110000000001122200008000aabbbbbaaaabb333bbaaabbb8002228002222020202000
02000202020202020002044000b000111333300000111288212811001100000000000000022200000bbbbbbbbaaaaabbbbbaaaabbb3800220022220202020000
00202020202022202020024440000001133000dd0002211182810000000000000000000000882800bbb13333bbbaabbbbbbaaabbb33280000022222020200000
000000020002020222220028444444000000dd1100111222281000000000000000000000000080333bb311333bbabb3333bbaabb333280002222222202020002
0000000000000022222000008444444000ddd1110001282111000000000000000011111110000033bbb301333bbabb33333bbbbb312220002220222220202020
02000200000002220200711000244444200111111001000000000000000000110000000110128803bab310333bbbb3333333b333121120022222022202020200
00002000002022202007661100444444400111182000000000000000010001110000000010112803baab10133bbbb33133333331811338022220202020200000
00000002022202000077611004444444420128800000000000020000010011110011211010112803baab101133bbb331133333128113b8002202020200000000
00002020202020007766110044444444420000000000000222880000210111110000001010112803bbab10021333b311111112280113aa202220202020000000
000000020202000776611002422444442200000000002280000000002201011100122220101120000ba000000033332222221880013baa800222020202000000
20000020002000776111002422444442202222222028880222000000820202110012221010110222200222022203180008888000333baa802222202020200020
00000000000007761210022282424422802bbbbb20000002b20000000000020000022210000022bb2002b202b2000000000000113333ba800222020202020000
00002000200077612100022802244228022b222b22222022b2222022022220222000110222222b222022b22232220222201112133333bba80220202020002000
0000000200076618100000800082228002b2222b22bb222bbb2b22b22b2b322b2200002bbb22bbb2002bbb2b2b2222bb2201223333133ba80222020200000000
0000002000766121000000003008880202bbbbb22b22b222b22b22b22bb22bb2b200022b22b22b220022b22b32b22b22b201233bb31333a80220202020000000
0000000007661811111112003300000022b22322bbbbb22b223322b22b222b22b20002b222b2b220002b222b22b2bbbbb20223bb332133b20222020202000000
0000000076618115555511200333310022b22b22b222202b22b222b2b2222b22b20002b222b2b200002b222b22b2b222220233bb312133bb8222202020202000
000000076618116d6ddd51800b3331302b2222b2b22b202b22b23b22b222b22b220002b22b22b200002b22b22b22b22b200333bb3122133b8222020202000200
00000076618116d6ddd51880ab3311022b2002b22bb2202bb22b2b22b222b22b2000022bbb22b200002bb2b22b222bb2200333ab8122133b8020202020200020
0000076618116d6ddd55800aab3110022220022222220022220222022202202220000022220222000022222022202222000033aa811211332002020002000000
000086618116d6dd555800aabb12000000000000000000000000000000000000000000000000000000000000000000000000000000122133b800200000000000
000008180000000000000000b3200000000000000000000000000000000000002222000002222200000000000000000000000022200000000000000222222000
00000000222222220222222000000222222222220000022222022222222222222332222002333220000000000000222222222222220002222222222233332200
00000022233333320233332000000233332233320000023332233333333333333333332222333322222222222222233333333333320222333333322333333200
0000022333aaaa32223aa3220000023aa3233a322000223a33333aaaaaaaaa3aaaaaa333333aa333333333333332233aaaaaaaaa32223333aaaa33233aa33200
0000223aaaaaaaa3223aa3220000023aa323aa332202233aa333aaaa3333333aa33aaaaa333aa33aaaaaaaaaaa3323aaaa33333322233aaaaaaaa3233aa33200
000023aa33333333223aa3220000023aa323aaa3322233aaa3233aa3322223333aa3333aaa3aa3333aa33333aaa3233aa33322222233aa33333333233aa32200
000023a333332222223a33200000023a3323aaaa33233aaaa3223aa3333333333aa33333aa3a32233aa3223333a3223aa33333333233a333222222233a332000
000023aaaa333333223a32200000023a3223a33aa333aa3aa3223aaaaaaaaa323aa3333aa33a32233aa3333aaaa3223aaaaaaaaa3233aaaa333332233a332000
022222333aaaaa33323a32000000023a3233a333a33aa33aa3223a33333333333aa3aaaa323a32233a3aaaaa3332223a333332333223333aaaaa33223aa32000
0233332233333aaa323a32222222223a323aa333aaaa323aa3223aa322233a33aaaaa332223a32223a33aa333222333aa322233a33332233333aaa323aa32000
023aa3332223333a323a32333333333a333aa3333aa3323aa3223aa32333a3333aa32222023a32223a333aaa3323333aa32333a33aa3332223333a3233332000
023aaa333333aaaa323aa333aaaaaa3a333a32233a332223a3323aa333aa33223aa32000023a33223a3233aaa3333a3aa333aa333aaa333333aaaa3233a32000
0233aaaaaaaaaa332233aaaaa333333aa33a322233322023aa3233aaaaa322223aa32000023aa3223a322333aaaaaa33aaaaa32233aaaaaaaaaa33223aa32000
02233333333333322223333333332233333332023322002333222333333220023333200002333222333222233333333333332222233333333333322233332000
00222222222222220022222222222222223322022220002222202222222200023322200002222202333200222222332222222000222222222222220222222000
00000000000000000000000000000000022220000000000000000002200000022220000000000002222200000002222000000000000002222000000002200000
00000000000000000000000000000000000000000000000000000000000000000000000000000000220000000000000000000000000000000000000000000000

__gff__
00000000000000000000000000000000000000000000000000000000000000000004810001010100000000000000000001010101010101810012060a42822200000101010101010101011222060a4282000101010001010101010101810101010001010101010101010101000001010012220101010101018101010000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
710000000000000000000000000000005656565656565656565656564a5b5656565656565656565656565656565656565656565656565656565656565656565656565656565656567676767673617673766e6176616e61616e6e61616161616161616e6e616161616e6161616e6161616e6e6e61616e616161616e7673766e61
320000000000000000000000000000705657380000382f00002f38005c00003855564a4b4a5d485d4b4a5d485d4b565656564a5d485d4b4a5d5d485d485d485d4b564a5d41565656767673737373736173767373737661616e616e141414146e6114140014146e61141414146e1414616114616e761414001400000000211476
6d0000183f18000000000000001000305657000000002f00002f002c5000000000555e5e5e5656565a5f5656565f5d48485d5f5656565f5b56565656565656565e565e5656564b56764a495d495d5d49495d5d495d494b61616e6114144a495d494b144a5d4b1414140000000000141414001461741400000000000000210061
320000336d36000000000000000000305657000000002f18002f2c2c5000000000385e5e5e565656565a5d485d5b565656565a5d485d5b56564a5d485d485d485b565f5d41565e56735e76767673767673737376616e5e766e611414005e0014145e005e145a5d495d4b00004a5d5d4b00000061740000000000000000210072
31000000380000000010000000003f305657000000454646464646465e46470000005e5e5e38555656565656565656565656565656565656565e56565656565656565e5656565f56735a5d495d494b73734a495d495d5b766e141400005000004a5b005c14141400005c00005e14145c0000000000000000001f000000210072
32000000000000000000000000006d614a5d4b0000000038384038555e56564700005e5e5e003800385547564756475656562d5656565656565a485d485d485d485d5f5d41565e567373737376735e73735e76737373737361141400105000005000005000000000005000005c0014500000000000001800006e610000210072
6d7100100000000000000000000030315b565e0000000000000040385e573800004a5f5e5e0000000055564556455656565640565656565656565656565656565656565656565e56734a495d495d5b73765a5d495d494b73614a494b00500000501000500000001000500000500000500000616e616e6364001400000021006e
316d0000000000003f183f0000006d3156565a4e4f180000000000405a4b0000005e5e5e5e000000005547564756475656384000565656565738554156464156565700385a4b5e55735e73736e6176737373737373615e736e5e145e005000005000005000000000005000005000005000000061761414000000000000210076
3138000000000000336d6d3600003031565656565a5d5d4e4f000040555e0000455a5f5e5e00000000380000002f40404040400000003838000038565646565638550000005f5b55735a5d495d4b76744273634273725a5d5d5b145e005e00005e000050000000005f5b00005010005000000061741400000000000000210072
3200000000000000003838000000313156565656565656465e472140555e000000005c5c5c001f0000000000002f000000000000000000000000005e0000005c00570000005a4b5573766176735e737473736373737261616114145a5d5b00005f000050000000005e1400005000005e00000061740000000000001800211476
31183f00000000000000000000003031564a5d5d485d5d4b5e572140555e464646465e5e5e464646464647214546464747470045454546464700005e00000050002f0000004a5f7673737676735c73745c0000005c7273616e000000000010005e00005e000010005e0000005e00005f0000146e7400000000626e6164211472
616d360000000010000000183f1831314b5e56565656565f5b572140555e4a5d485d5b5a5b562d56565738210038555756470045565556565700005c00540050002f0000005e5e767478002f00500000500000005000000000000000000000005000005e000000005e0018145e00005e14001461760000000000147800001472
3138000000000000000000336d616d315a5f56565656565e56572140555a5f565656565656574055565700210000555646470045465656565646465a5d5f5d5b46470000005c5c000000002f005000005000540050000000000000001f0000005000185e001400005a5d495d5b00005e14141461616e64000000000000000072
32000018000000000000000000383031565e38003800005e3800214040385e3840404040403840553157002100005531315700555656315657380000005c00000000004a5d5f5b4646766363635e63615a5d5f5d5b636e6161001414616e14005a5d495b14141414000000001400145f14141461767800000000000000000061
323f186d3f001800003f183f187031314a5b00000000005c002c001800005c000000182c000000555632002118000000385600005556563157004546465e46464646465e5656567676767673765e737673735e61737376766114146161611414141800141461146e611414146114145e1414616e74001000616e640000210076
6d616d31616d6d006d6d616d6d6d6d315e5721454646465a5d5d5d5d5d5d5b4646464646464646565656354634353534213035215531565657000055565a5d485d485d5b5656767356767673735a5d49495d5b7676737376616161616161616e6e61616e6e616e6161616e61616e615e616e6161740000000078140000210072
313131313131310031313131313131315e57215556565656565656565656565656565656565656565625252525252531213132213031315657000055313131313131313131313131737376317676736e6173767373734a5d494b73766173764a5d5d5d5d5d4b7373737676737373765e76737373741400001000000000210072
313131313131380031313131313131315e5721380055005514553855381414143838000038003856315700382231312521383821380038000000003830312238383131313131313176141438000000000000000000005000005e782f782f785e78787873765e7676734a494b7376735e73737661761414000000000000211472
313131313138000038313131313131315e572100002f002f002f002f000000000000000000000038382f000000383131243c3d213f0000000000000000380000003822383830313132141800180010000000180018005000005c002f002f005c002b0073765e7673765e735e7373735e76767661741400000000001000211476
313131313800000070313131313131315e572100002f002f002f002f000000000000000000001f00002f0000000031313125313435360000000000000000000000000000003830316361636e640000004a495d495d495b63615e63616363635e6364000000500000005000500000005000000000000000000000000000210061
313131310000003b31313131313131315e572100002f002f002f002f00182c1800000000004546464635000000002c31313125253800000000000000004040404040404040402531321400001463000050000000000000000050004040401450147400000050000000500050001f005000000000000000000000180000000076
3131223100003a3131313831313131315e564700454646464646464646464646464647002155563031313e3f00000014313114384040000000000000400000000000000000002f3800000000007863005000180018000018005000000000405014726361635e636e615e615e6363615e636e61616163640000626e6100140076
313800380000313138220031313131315a4b570000383800001414004000001400380000215556303131313521000014141414000000403a3d000040000000000000000000002f00001f0000000078635a5d495d494b4a495d5b004a494b005040402d72765a5d494b5e735a4b764a5b73767361767414210000780000141472
313d0000000031313c3d003831313131565e57000000000000000010004040404040400021145556313131322100001414140000003a3b25313e400000000000000000003a3b3534346164000010000000000000005c5c000000005c005c185014181872606060735a5b76765a495b6060606073741414140000140014141476
313171000000383131313e0031313131565a5d4b000000000000000000000014002b0040001455563131383821000000141400002c30312531253c3d003a3d3f00003f39313131317373741400000000184a5d495d5b5a5d495d5d5b635a495b63616373607660607660606076766060767660766c14141414142c1414141472
3131313c3d0000382231317031312231572c385c0000000000004a5d4b18004546464700400038553138000021003a3b3536000033313125312531313431313621333431313131317673736363616363635e7673616e7373737676617376606060606060607676606060766060606076737660606061616e6361636e61636176
313131313100000000383131313800315646465a4e4f144c4d5d5b565a5d5d5d485d4b1840001455320000102133313138000000003031312d2222382238380021003822223f3856565656565f5d5d5f5f5b565656565656313131313132003161616e61616161616e61616e6e6e6161616e616e61616e61616e6e616161616e
31312238310000000000223131003a3156565656565a5d5b565656565656565656565e464646465632003f0021000038000000000038383125320000000000002100003035350038383838555e56565e5e565656565656567b2238003838217b610000000000616e616100000000000000000000000000006e61616e6e6e6161
31380000380000000000003138003131572c5556565656565656565656565656564a5b565656565631003335210000000000001000000038253200000000000000003f303132003f000000555e4a5d5f5a5d5d495d5d4b567b6b6b6b6b00217b61000000000000616e000000000000000000000000000000000000000061616e
310000000000000000000038000038315646565656572c555656572c555656572c5e5656572d555632210031360000000000000000001f3f22220000000000000000333131313446464721555e5e565a5d5d485d4b565e5631313131313169316100000000000061000000000070612100000000000000000000000000006161
310000000000000000000000000000315656572c55564656572c5546572c55564a5f572c55465656322100380000000000000000000033352434353e3f0000002b3f003838313131565721555a2d5d5d5f584b565e565e5656565656000000006100000000000061000000706e616e2100000000000000000000000000000061
310000000000000000000000000000315656564656565656564656565646564a5b5a5d5d5d485d5d31360000000000000000003336000030253131313500003435353e000038003838382138000000005c002f382f002f38003838550000000061000000000000610000616e0000000000000000000000000000000000000061
__sfx__
00020000076500e6503a02027140241301f1301b130131400c1400715003150001500315000140031400013003130001300312000120031200012003110001100311000110001100010000100001000010000100
000100000e610086200c620046200361003610016100000000000000000000000000000000000000000000000000000000000000000000000000000e60006600076000960009600096000a600046000000000000
000100000261002610036100361003610006100061000610006100260002600026000160001600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000077100c12005740057200c7100f7100070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
000200000502007130050200501003010030000100001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a0000115501355016550075101f5501d550225500f5000f50016500165001850018500185001f5001f5001f500005000050000500005000050000500005000050000500005000050000500005000050000500
00020000065301d230245200a510075101c700187000a700097000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000016550165503555035550220002700029050290502b0502b0502b050220002e0502e0502e0502e0002e0002e0002b000350003f0003f0003a0003f0003f0000c000000000000000000000000000000000
0004000016520165203551035510220002700029000290002b0002b0002b000220002e0002e0002e0002e0002e0002e0002b000350003f0003f0003a0003f0003f0000c000000000000000000000000000000000
000200001361011010136101101013610116100c6100f610086100563007650036200860007600066000660006600056000460004600046000460004600036000360003600036000360003600086000b6000e600
000200000f11005130071500315000160001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
000200000a610053100a310053100a310116100c6100f610086100563007650036200860007600066000660006600056000460004600046000460004600036000360003600036000360003600086000b6000e600
001000002e0502b210160001600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000221101b1301d1501815013160001000010000100161200f130131400c140071500010000100001001f1501815007150111301f1202413000100001000010000100001000010000100001000010000100
00080000270502b040290402403022030240202202024020220102401022010240102201024000220000a0000c000000000000000000010000100000000000000000000000000000000000000000000000000000
00010000077100c12005720057200c7100f7100070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
0002000013710117200a720037200c7000a700007000a7100f7200c7100a7100c7100f7100c710077100071000700007000070000700007000070000700007000070000700007000070000700007000070000700
00020000000100371003010037100301000710037000a7000c7000270002700027000170001700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
00020000135500a050226500c65029650226502965016650225401f6401b64018640166301663016630136301363011630116300f6300f6300c6300a6300a6300762005620056200362003610036100361000610
0003000035060177502704016730070101c700187000a700097000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
000600000a7500c7500a7500c75007750117500575018750037501d75003740187400574011730077300a730057200a72003720077200071005710007100371007700007100570000710037000f700037000a700
00050000006100061001610016100461006610096100c610156100d6101f62008620116202562014620226201c6202f6200d6202262012620186200f61021610176100d61018610076100d610036100861001610
