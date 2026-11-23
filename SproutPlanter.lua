local G=getgenv and getgenv()
if G then for _,k in ipairs({"SPL","SproutPlanterLoaded"})do if G[k]then pcall(G[k])G[k]=nil end end end
local P,RS,UIS,TS,L=game:GetService("Players"),game:GetService("ReplicatedStorage"),game:GetService("UserInputService"),game:GetService("TweenService"),game:GetService("Lighting")
local lp=P.LocalPlayer
local run,cons=true,{}
local function tr(c)cons[#cons+1]=c return c end
local S={plant=false,day=false,night=false,target=50,left=50}
local function beans()local ok,s=pcall(function()return require(RS.ClientStatCache):Get()end)return ok and type(s)=="table"and s.Eggs and tonumber(s.Eggs.MagicBean)or 0 end
local function night()local t=L.ClockTime return t<6 or t>=18 end
local function zone()return lp:GetAttribute("CurrentZone")end
local function fsprout()local n,zs,f=zone(),workspace:FindFirstChild("FlowerZones"),workspace:FindFirstChild("Sprouts")local z=n and zs and zs:FindFirstChild(n)if not(z and f)then return end for _,s in ipairs(f:GetChildren())do if s.Name=="Sprout"and s:IsA("BasePart")then local r=z.CFrame:PointToObjectSpace(s.Position)if math.abs(r.X)<=z.Size.X/2+2 and math.abs(r.Z)<=z.Size.Z/2+2 then return s end end end end
local function stype(p)if p:FindFirstChild("RainbowTag")then return"Supreme"end local h,s=p.Color:ToHSV()local m=p.Material if m==Enum.Material.Plastic and s<.2 then return"Basic"end if s<.15 then return"Rare"end if m==Enum.Material.Neon then if h>=.2 and h<.45 then return"Supreme"end if h>=.45 and h<.75 then return"Moon"end end if h>=.07 and h<.2 then return"Epic"end if h>=.4 and h<.6 then return"Legendary"end if h>=.6 and h<.72 then return"Moon"end if h>=.72 or h<.03 then return"Gummy"end return"Sprout"end
local function pollen(p)local g=p:FindFirstChild("GuiPos")local l=g and g:FindFirstChildWhichIsA("TextLabel",true)return l and l.Text or""end
tr(lp.Idled:Connect(function()pcall(function()local v=game:GetService("VirtualUser")v:CaptureController()v:ClickButton2(Vector2.new())end)end))
local C={card=Color3.fromRGB(24,26,33),hov=Color3.fromRGB(30,33,42),inset=Color3.fromRGB(18,19,25),stroke=Color3.fromRGB(40,43,54),acc=Color3.fromRGB(104,132,255),tab=Color3.fromRGB(28,31,40),text=Color3.fromRGB(236,238,245),dim=Color3.fromRGB(128,133,150),lab=Color3.fromRGB(214,217,228),stat=Color3.fromRGB(150,155,172),track=Color3.fromRGB(46,49,62),knob=Color3.fromRGB(244,245,250),blk=Color3.new(0,0,0)}
local PAD,RAD=9,UDim.new(0,6)
local function N(c,p,par)local i=Instance.new(c)for k,v in pairs(p)do i[k]=v end i.Parent=par return i end
local function rd(i,r)N("UICorner",{CornerRadius=r or UDim.new(1,0)},i)end
local function sk(i)N("UIStroke",{Color=C.stroke,Thickness=1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},i)end
local function list(i,p)N("UIListLayout",{Padding=UDim.new(0,p),SortOrder=Enum.SortOrder.LayoutOrder},i)end
local function grp(par,o)local g=N("Frame",{BackgroundColor3=C.card,BorderSizePixel=0,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,LayoutOrder=o},par)rd(g,RAD)list(g,0)N("UIPadding",{PaddingTop=UDim.new(0,2),PaddingBottom=UDim.new(0,2)},g)g:SetAttribute("G",true)return g end
local function card(p,par)if par:GetAttribute("G")then p.BackgroundTransparency=1 p.BorderSizePixel=0 local f=N("Frame",p,par)local n=par:GetAttribute("R")or 0 if n>0 then N("Frame",{Size=UDim2.new(1,-2*PAD,0,1),Position=UDim2.fromOffset(PAD,0),BackgroundColor3=C.stroke,BorderSizePixel=0,ZIndex=2},f)end par:SetAttribute("R",n+1)return f end p.BackgroundColor3=C.card p.BorderSizePixel=0 local f=N("Frame",p,par)rd(f,RAD)f.MouseEnter:Connect(function()f.BackgroundColor3=C.hov end)f.MouseLeave:Connect(function()f.BackgroundColor3=C.card end)return f end
local function lbl(par,p)p.BackgroundTransparency=1 p.TextXAlignment=p.TextXAlignment or Enum.TextXAlignment.Left return N("TextLabel",p,par)end
local function toggle(par,name,sub,cb,o)local row=card({Size=UDim2.new(1,0,0,28),LayoutOrder=o},par)local x=PAD if sub then lbl(row,{Size=UDim2.fromOffset(16,28),Position=UDim2.fromOffset(PAD+4,0),Font=Enum.Font.Garamond,Text="\u{21B3}",TextColor3=C.dim,TextSize=18,TextXAlignment=Enum.TextXAlignment.Center})x=PAD+24 end lbl(row,{Size=UDim2.new(1,-(x+56),1,0),Position=UDim2.fromOffset(x,0),Font=Enum.Font.GothamMedium,Text=name,TextColor3=C.lab,TextSize=13})local sw=N("TextButton",{Size=UDim2.fromOffset(36,20),Position=UDim2.new(1,-(36+PAD),.5,-10),AutoButtonColor=false,Text="",BackgroundColor3=C.track},row)rd(sw)local kb=N("Frame",{Size=UDim2.fromOffset(16,16),Position=UDim2.fromOffset(2,2),BackgroundColor3=C.knob},sw)rd(kb)local on=false local ti=TweenInfo.new(.15,Enum.EasingStyle.Quad)local function set(v,fire)if v==on then return end on=v TS:Create(sw,ti,{BackgroundColor3=on and C.acc or C.track}):Play()TS:Create(kb,ti,{Position=UDim2.fromOffset(on and 18 or 2,2)}):Play()if fire~=false then cb(on)end end sw.MouseButton1Click:Connect(function()set(not on)end)return set end
local function stat(par,name,v,o)local row=card({Size=UDim2.new(1,0,0,22),LayoutOrder=o},par)lbl(row,{Size=UDim2.new(.45,-PAD,1,0),Position=UDim2.fromOffset(PAD,0),Font=Enum.Font.Gotham,Text=name,TextColor3=C.stat,TextSize=12})local val=lbl(row,{Size=UDim2.new(.55,-PAD,1,0),Position=UDim2.fromScale(.45,0),Font=Enum.Font.GothamBold,Text=tostring(v),TextColor3=C.text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Right,TextTruncate=Enum.TextTruncate.AtEnd})return function(t)val.Text=tostring(t)end end
local par=(gethui and gethui())or game:GetService("CoreGui")
local o=par:FindFirstChild("SproutPlanterGui")if o then o:Destroy()end
local gui=N("ScreenGui",{Name="SproutPlanterGui",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},par)
local panel=N("Frame",{Size=UDim2.fromOffset(285,0),AutomaticSize=Enum.AutomaticSize.Y,Position=UDim2.fromOffset(330,120),BackgroundColor3=C.blk,BorderSizePixel=0,ClipsDescendants=true},gui)rd(panel,UDim.new(0,10))sk(panel)list(panel,0)
local bar=N("Frame",{Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,BorderSizePixel=0,LayoutOrder=0},panel)
N("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=C.stroke,BorderSizePixel=0},bar)
rd(N("Frame",{Size=UDim2.fromOffset(8,8),Position=UDim2.new(0,12,.5,-4),BackgroundColor3=C.acc,BorderSizePixel=0},bar))
lbl(bar,{Size=UDim2.new(1,-90,1,0),Position=UDim2.fromOffset(28,0),Font=Enum.Font.GothamBold,Text="Xoticz Sprout Planter",TextColor3=C.text,TextSize=14})
local function tb(t,x,h)local b=N("TextButton",{Size=UDim2.fromOffset(24,22),Position=UDim2.new(1,x,.5,-11),BackgroundColor3=C.blk,AutoButtonColor=false,Font=Enum.Font.GothamBold,Text=t,TextColor3=C.dim,TextSize=15,ZIndex=3},bar)rd(b,RAD)b.MouseEnter:Connect(function()b.BackgroundColor3=h b.TextColor3=C.text end)b.MouseLeave:Connect(function()b.BackgroundColor3=C.blk b.TextColor3=C.dim end)return b end
local close,mini=tb("×",-30,Color3.fromRGB(200,64,72)),tb("–",-58,C.tab)
do local d,ds,sp tr(bar.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d,ds,sp=true,i.Position,panel.Position end end))tr(UIS.InputChanged:Connect(function(i)if d and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then local v=i.Position-ds panel.Position=UDim2.fromOffset(sp.X.Offset+v.X,sp.Y.Offset+v.Y)end end))tr(UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=false end end))end
local body=N("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,LayoutOrder=1},panel)
N("UIPadding",{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,8)},body)list(body,4)
local g1=grp(body,0)
local sd,sn
toggle(g1,"Auto Plant Sprouts",false,function(v)S.plant=v end,0)
sd=toggle(g1,"Day Only",true,function(v)S.day=v if v and S.night then S.night=false sn(false,false)end end,1)
sn=toggle(g1,"Night Only",true,function(v)S.night=v if v and S.day then S.day=false sd(false,false)end end,2)
local setLeft
do local row=card({Size=UDim2.new(1,0,0,48),LayoutOrder=1},body)lbl(row,{Size=UDim2.new(1,-2*PAD,0,16),Position=UDim2.fromOffset(PAD,6),Font=Enum.Font.GothamMedium,Text="Amount To Plant",TextColor3=C.lab,TextSize=13})local bg=N("Frame",{Size=UDim2.new(1,-2*PAD,0,20),Position=UDim2.fromOffset(PAD,23),BackgroundColor3=C.inset},row)rd(bg,UDim.new(0,5))sk(bg)local st=bg:FindFirstChildOfClass("UIStroke")local box=N("TextBox",{Size=UDim2.new(1,-14,1,0),Position=UDim2.fromOffset(7,0),BackgroundTransparency=1,Font=Enum.Font.Gotham,Text=tostring(S.target),PlaceholderText="How many sprouts",PlaceholderColor3=C.dim,TextColor3=C.text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false},bg)box.Focused:Connect(function()st.Color=C.acc end)box.FocusLost:Connect(function()st.Color=C.stroke local n=tonumber((box.Text:gsub("%D","")))if n then S.target,S.left=n,n end box.Text=tostring(S.target)setLeft(S.left)end)end
local g2=grp(body,2)
setLeft=stat(g2,"Amount Left",S.left,0)
local setBeans,setSprout,setStatus=stat(g2,"Magic Beans",beans(),1),stat(g2,"Current Sprout","None",2),stat(g2,"Status","Off",3)
mini.MouseButton1Click:Connect(function()body.Visible=not body.Visible end)
local function waitt(s)local e=os.clock()+s while run and os.clock()<e do task.wait(.2)end end
local function waitBreak(s)local k,t=stype(s),0 while run and S.plant and s.Parent do if os.clock()-t>.5 then t=os.clock()local p=pollen(s)setSprout(k..(p~=""and(" · "..p)or""))end task.wait(.05)end setSprout("None")end
local lastUse=-10
task.spawn(function()while run do setBeans(beans())local s=S.plant and zone()and fsprout()
if not S.plant then setStatus("Off")setSprout("None")task.wait(.3)
elseif s then setStatus("Waiting for the sprout to break")waitBreak(s)
elseif S.left<=0 then setStatus("Done")task.wait(.5)
elseif S.day and night()then setStatus("Waiting for day")waitt(1)
elseif S.night and not night()then setStatus("Waiting for night")waitt(1)
elseif not zone()then setStatus("Stand in a field")task.wait(1)
elseif beans()<=0 then setStatus("Out of Magic Beans")task.wait(2)
else while run and os.clock()-lastUse<5.1 do task.wait(.05)end local b=beans()setStatus("Planting...")lastUse=os.clock()pcall(function()RS.Events.PlayerActivesCommand:FireServer({Name="Magic Bean"})end)local t0,ok=os.clock(),false while run and os.clock()-t0<3 do if beans()<b then ok=true break end task.wait(.05)end
if ok then S.left-=1 setLeft(S.left)setBeans(beans())setStatus("Planted")local t1=os.clock()while run and os.clock()-t1<3 and not fsprout()do task.wait(.05)end else setStatus("Can't plant yet, retrying")waitt(1)end end end end)
local function unload()run=false for _,c in ipairs(cons)do pcall(function()c:Disconnect()end)end pcall(function()gui:Destroy()end)end
close.MouseButton1Click:Connect(unload)
if G then G.SPL=unload end
