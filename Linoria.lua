local a = game:GetService('UserInputService')
local b = game:GetService('TextService')
local c = game:GetService('CoreGui')
local d = game:GetService('Teams')
local e = game:GetService('Players')
local f = game:GetService('RunService')
local g = game:GetService('TweenService')
local h = f.RenderStepped;
local i = e.LocalPlayer;
local j = i:GetMouse()
local k = protectgui or syn and syn.protect_gui or function()
end;
local l = Instance.new('ScreenGui')
k(l)
l.ZIndexBehavior = Enum.ZIndexBehavior.Global;
l.Parent = c;
local m = {}
local n = {}
getgenv().Toggles = m;
getgenv().Options = n;
local o = nil;
local p = {
    Registry = {},
    RegistryMap = {},
    HudRegistry = {},
    FontColor = Color3.fromRGB(255, 255, 255),
    MainColor = Color3.fromRGB(28, 28, 28),
    BackgroundColor = Color3.fromRGB(20, 20, 20),
    AccentColor = Color3.fromRGB(0, 85, 255),
    OutlineColor = Color3.fromRGB(50, 50, 50),
    RiskColor = Color3.fromRGB(255, 50, 50),
    Black = Color3.new(0, 0, 0),
    Font = Enum.Font.Code,
    OpenedFrames = {},
    DependencyBoxes = {},
    Signals = {},
    ScreenGui = l,
    ActiveTab = nil,
    Toggled = false,
    MinSize = Vector2.new(550, 300),
    IsMobile = false,
    DevicePlatform = Enum.Platform.None,
    CanDrag = true,
    CantDragForced = false,
    ShowCustomCursor = false,
    VideoLink = "",
    TotalTabs = 0
}
pcall(function()
    p.DevicePlatform = a:GetPlatform()
end)
p.IsMobile = p.DevicePlatform == Enum.Platform.Android or p.DevicePlatform == Enum.Platform.IOS;
if p.IsMobile then
    p.MinSize = Vector2.new(550, 200)
end
local q = 0;
local r = 0;
table.insert(p.Signals, h:Connect(function(s)
    q = q + s;
    if q >= 1 / 60 then
        q = 0;
        r = r + 1 / 400;
        if r > 1 then
            r = 0
        end
        p.CurrentRainbowHue = r;
        p.CurrentRainbowColor = Color3.fromHSV(r, 0.8, 1)
    end
end))
local function t()
    local u = e:GetPlayers()
    for v = 1, #u do
        u[v] = u[v].Name
    end
    table.sort(u, function(w, x)
        return w < x
    end)
    return u
end
local function y()
    local z = d:GetTeams()
    for v = 1, #z do
        z[v] = z[v].Name
    end
    table.sort(z, function(w, x)
        return w < x
    end)
    return z
end
function p:SafeCallback(A, ...)
    if not A then
        return
    end
    if not p.NotifyOnError then
        return A(...)
    end
    local B, C = pcall(A, ...)
    if not B then
        local D, v = C:find(":%d+: ")
        if not v then
            return p:Notify(C)
        end
        return p:Notify(C:sub(v + 1), 3)
    end
end
function p:AttemptSave()
    if p.SaveManager then
        p.SaveManager:Save()
    end
end
function p:Create(E, F)
    local G = E;
    if type(E) == 'string' then
        G = Instance.new(E)
    end
    for H, I in next, F do
        G[H] = I
    end
    return G
end
function p:ApplyTextStroke(J)
    J.TextStrokeTransparency = 1;
    p:Create('UIStroke', {
        Color = Color3.new(0, 0, 0),
        Thickness = 1,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Parent = J
    })
end
function p:CreateLabel(F, K)
    local G = p:Create('TextLabel', {
        BackgroundTransparency = 1,
        Font = p.Font,
        TextColor3 = p.FontColor,
        TextSize = 16,
        TextStrokeTransparency = 0
    })
    p:ApplyTextStroke(G)
    p:AddToRegistry(G, {
        TextColor3 = 'FontColor'
    }, K)
    return p:Create(G, F)
end
function p:MakeDraggable(Instance, L)
    Instance.Active = true;
    Instance.InputBegan:Connect(function(M)
        if M.UserInputType == Enum.UserInputType.MouseButton1 then
            local N = Vector2.new(j.X - Instance.AbsolutePosition.X, j.Y - Instance.AbsolutePosition.Y)
            if N.Y > (L or 40) then
                return
            end
            while a:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                Instance.Position = UDim2.new(0, j.X - N.X + Instance.Size.X.Offset * Instance.AnchorPoint.X, 0,
                    j.Y - N.Y + Instance.Size.Y.Offset * Instance.AnchorPoint.Y)
                h:Wait()
            end
        end
    end)
    if p.IsMobile then
        local O, P, Q, R;
        a.TouchStarted:Connect(function(M)
            if p.CantDragForced == true then
                O = false;
                return
            end
            if not O and p:IsMouseOverFrame(Instance, M) and p.Window.Holder.Visible == true then
                P = M;
                Q = M.Position;
                R = Instance.Position;
                local S = M.Position - Q;
                if S.Y > (L or 40) then
                    O = false;
                    return
                end
                O = true
            end
        end)
        a.TouchMoved:Connect(function(M)
            if p.CantDragForced == true then
                O = false;
                return
            end
            if M == P and O and p.CanDrag == true and p.Window.Holder.Visible == true then
                local S = M.Position - Q;
                Instance.Position = UDim2.new(R.X.Scale, R.X.Offset + S.X, R.Y.Scale, R.Y.Offset + S.Y)
            end
        end)
        a.TouchEnded:Connect(function(M)
            if M == P then
                O = false
            end
        end)
    end
end
function p:MakeResizable(Instance, T)
    if p.IsMobile then
        return
    end
    Instance.Active = true;
    local U = 25;
    local V = 0.5;
    local W = p:Create('Frame', {
        SizeConstraint = Enum.SizeConstraint.RelativeXX,
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -30, 1, -30),
        Visible = true,
        ClipsDescendants = true,
        ZIndex = 1,
        Parent = Instance
    })
    local X = p:Create('ImageButton', {
        BackgroundColor3 = p.AccentColor,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(2, 0, 2, 0),
        Position = UDim2.new(1, -30, 1, -30),
        ZIndex = 2,
        Parent = W
    })
    local Y = p:Create('UICorner', {
        CornerRadius = UDim.new(0.5, 0),
        Parent = X
    })
    p:AddToRegistry(X, {
        BackgroundColor3 = 'AccentColor'
    })
    W.Size = UDim2.fromOffset(U, U)
    W.Position = UDim2.new(1, -U, 1, -U)
    T = T or p.MinSize;
    local S;
    W.Parent = Instance;
    local function Z(_)
        X.Position = UDim2.new()
        X.Size = UDim2.new(2, 0, 2, 0)
        X.Parent = W;
        X.BackgroundTransparency = _;
        Y.Parent = X;
        S = nil
    end
    X.MouseButton1Down:Connect(function()
        if not S then
            S = Vector2.new(j.X - (Instance.AbsolutePosition.X + Instance.AbsoluteSize.X),
                j.Y - (Instance.AbsolutePosition.Y + Instance.AbsoluteSize.Y))
            X.BackgroundTransparency = 1;
            X.Size = UDim2.fromOffset(p.ScreenGui.AbsoluteSize.X, p.ScreenGui.AbsoluteSize.Y)
            X.Position = UDim2.new()
            Y.Parent = nil;
            X.Parent = p.ScreenGui
        end
    end)
    X.MouseMoved:Connect(function()
        if S then
            local a0 = Vector2.new(j.X - S.X, j.Y - S.Y)
            local a1 = Vector2.new(math.clamp(a0.X - Instance.AbsolutePosition.X, T.X, math.huge),
                math.clamp(a0.Y - Instance.AbsolutePosition.Y, T.Y, math.huge))
            Instance.Size = UDim2.fromOffset(a1.X, a1.Y)
        end
    end)
    X.MouseEnter:Connect(function()
        Z(V)
    end)
    X.MouseLeave:Connect(function()
        Z(1)
    end)
    X.MouseButton1Up:Connect(function()
        Z(V)
    end)
end
function p:AddToolTip(a2, a3)
    local a4, a5 = p:GetTextBounds(a2, p.Font, 14)
    local a6 = p:Create('Frame', {
        BackgroundColor3 = p.MainColor,
        BorderColor3 = p.OutlineColor,
        Size = UDim2.fromOffset(a4 + 5, a5 + 4),
        ZIndex = 100,
        Parent = p.ScreenGui,
        Visible = false
    })
    local a7 = p:CreateLabel({
        Position = UDim2.fromOffset(3, 1),
        Size = UDim2.fromOffset(a4, a5),
        TextSize = 14,
        Text = a2,
        TextColor3 = p.FontColor,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = a6.ZIndex + 1,
        Parent = a6
    })
    p:AddToRegistry(a6, {
        BackgroundColor3 = 'MainColor',
        BorderColor3 = 'OutlineColor'
    })
    p:AddToRegistry(a7, {
        TextColor3 = 'FontColor'
    })
    local a8 = false;
    a3.MouseEnter:Connect(function()
        if p:MouseIsOverOpenedFrame() then
            return
        end
        a8 = true;
        a6.Position = UDim2.fromOffset(j.X + 15, j.Y + 12)
        a6.Visible = true;
        while a8 do
            f.Heartbeat:Wait()
            a6.Position = UDim2.fromOffset(j.X + 15, j.Y + 12)
        end
    end)
    a3.MouseLeave:Connect(function()
        a8 = false;
        a6.Visible = false
    end)
    if o then
        o:GetPropertyChangedSignal("Visible"):Connect(function()
            if o.Visible == false then
                a8 = false;
                a6.Visible = false
            end
        end)
    end
end
function p:OnHighlight(a9, Instance, F, aa)
    a9.MouseEnter:Connect(function()
        local ab = p.RegistryMap[Instance]
        for H, ac in next, F do
            Instance[H] = p[ac] or ac;
            if ab and ab.Properties[H] then
                ab.Properties[H] = ac
            end
        end
    end)
    a9.MouseLeave:Connect(function()
        local ab = p.RegistryMap[Instance]
        for H, ac in next, aa do
            Instance[H] = p[ac] or ac;
            if ab and ab.Properties[H] then
                ab.Properties[H] = ac
            end
        end
    end)
end
function p:MouseIsOverOpenedFrame(M)
    local ad = j;
    if p.IsMobile and M then
        ad = M.Position
    end
    for ae, D in next, p.OpenedFrames do
        local af, ag = ae.AbsolutePosition, ae.AbsoluteSize;
        if ad.X >= af.X and ad.X <= af.X + ag.X and ad.Y >= af.Y and ad.Y <= af.Y + ag.Y then
            return true
        end
    end
end
function p:IsMouseOverFrame(ae, M)
    local ad = j;
    if p.IsMobile and M then
        ad = M.Position
    end
    local af, ag = ae.AbsolutePosition, ae.AbsoluteSize;
    if ad.X >= af.X and ad.X <= af.X + ag.X and ad.Y >= af.Y and ad.Y <= af.Y + ag.Y then
        return true
    end
end
function p:UpdateDependencyBoxes()
    for D, ah in next, p.DependencyBoxes do
        ah:Update()
    end
end
function p:MapValue(I, ai, aj, ak, al)
    return (1 - (I - ai) / (aj - ai)) * ak + (I - ai) / (aj - ai) * al
end
function p:GetTextBounds(am, an, ao, ap)
    local aq = b:GetTextSize(am, ao, an, ap or Vector2.new(1920, 1080))
    return aq.X, aq.Y
end
function p:GetDarkerColor(ar)
    local as, at, au = Color3.toHSV(ar)
    return Color3.fromHSV(as, at, au / 1.5)
end
p.AccentColorDark = p:GetDarkerColor(p.AccentColor)
function p:AddToRegistry(Instance, F, K)
    local av = #p.Registry + 1;
    local aw = {
        Instance = Instance,
        Properties = F,
        Idx = av
    }
    table.insert(p.Registry, aw)
    p.RegistryMap[Instance] = aw;
    if K then
        table.insert(p.HudRegistry, aw)
    end
end
function p:RemoveFromRegistry(Instance)
    local aw = p.RegistryMap[Instance]
    if aw then
        for av = #p.Registry, 1, -1 do
            if p.Registry[av] == aw then
                table.remove(p.Registry, av)
            end
        end
        for av = #p.HudRegistry, 1, -1 do
            if p.HudRegistry[av] == aw then
                table.remove(p.HudRegistry, av)
            end
        end
        p.RegistryMap[Instance] = nil
    end
end
function p:UpdateColorsUsingRegistry()
    for av, ax in next, p.Registry do
        for H, ac in next, ax.Properties do
            if type(ac) == 'string' then
                ax.Instance[H] = p[ac]
            elseif type(ac) == 'function' then
                ax.Instance[H] = ac()
            end
        end
    end
end
function p:GiveSignal(ay)
    table.insert(p.Signals, ay)
end
function p:Unload()
    for av = #p.Signals, 1, -1 do
        local az = table.remove(p.Signals, av)
        az:Disconnect()
    end
    if p.OnUnload then
        p.OnUnload()
    end
    l:Destroy()
end
function p:OnUnload(aA)
    p.OnUnload = aA
end
p:GiveSignal(l.DescendantRemoving:Connect(function(Instance)
    if p.RegistryMap[Instance] then
        p:RemoveFromRegistry(Instance)
    end
end))
local aB = {}
do
    local aC = {}
    function aC:AddColorPicker(av, aD)
        local aE = self.TextLabel;
        assert(aD.Default, 'AddColorPicker: Missing default value.')
        local aF = {
            Value = aD.Default,
            Transparency = aD.Transparency or 0,
            Type = 'ColorPicker',
            Title = type(aD.Title) == 'string' and aD.Title or 'Color picker',
            Callback = aD.Callback or function(ar)
            end
        }
        function aF:SetHSVFromRGB(ar)
            local as, at, au = Color3.toHSV(ar)
            aF.Hue = as;
            aF.Sat = at;
            aF.Vib = au
        end
        aF:SetHSVFromRGB(aF.Value)
        local aG = p:Create('Frame', {
            BackgroundColor3 = aF.Value,
            BorderColor3 = p:GetDarkerColor(aF.Value),
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.new(0, 28, 0, 14),
            ZIndex = 6,
            Parent = aE
        })
        local aH = p:Create('ImageLabel', {
            BorderSizePixel = 0,
            Size = UDim2.new(0, 27, 0, 13),
            ZIndex = 5,
            Image = 'http://www.roblox.com/asset/?id=18580629231',
            Visible = not not aD.Transparency,
            Parent = aG
        })
        local aI = p:Create('Frame', {
            Name = 'Color',
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            Position = UDim2.fromOffset(aG.AbsolutePosition.X, aG.AbsolutePosition.Y + 18),
            Size = UDim2.fromOffset(230, aD.Transparency and 271 or 253),
            Visible = false,
            ZIndex = 15,
            Parent = l
        })
        aG:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
            aI.Position = UDim2.fromOffset(aG.AbsolutePosition.X, aG.AbsolutePosition.Y + 18)
        end)
        local aJ = p:Create('Frame', {
            BackgroundColor3 = p.BackgroundColor,
            BorderColor3 = p.OutlineColor,
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 16,
            Parent = aI
        })
        local aK = p:Create('Frame', {
            BackgroundColor3 = p.AccentColor,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 2),
            ZIndex = 17,
            Parent = aJ
        })
        local aL = p:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0),
            Position = UDim2.new(0, 4, 0, 25),
            Size = UDim2.new(0, 200, 0, 200),
            ZIndex = 17,
            Parent = aJ
        })
        local aM = p:Create('Frame', {
            BackgroundColor3 = p.BackgroundColor,
            BorderColor3 = p.OutlineColor,
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 18,
            Parent = aL
        })
        local aN = p:Create('ImageLabel', {
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 18,
            Image = 'http://www.roblox.com/asset/?id=18580632112',
            Parent = aM
        })
        local aO = p:Create('ImageLabel', {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0, 6, 0, 6),
            BackgroundTransparency = 1,
            Image = 'http://www.roblox.com/asset/?id=18580629971',
            ImageColor3 = Color3.new(0, 0, 0),
            ZIndex = 19,
            Parent = aN
        })
        local aP = p:Create('ImageLabel', {
            Size = UDim2.new(0, aO.Size.X.Offset - 2, 0, aO.Size.Y.Offset - 2),
            Position = UDim2.new(0, 1, 0, 1),
            BackgroundTransparency = 1,
            Image = 'http://www.roblox.com/asset/?id=18580629971',
            ZIndex = 20,
            Parent = aO
        })
        local aQ = p:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0),
            Position = UDim2.new(0, 208, 0, 25),
            Size = UDim2.new(0, 15, 0, 200),
            ZIndex = 17,
            Parent = aJ
        })
        local aR = p:Create('Frame', {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 18,
            Parent = aQ
        })
        local aS = p:Create('Frame', {
            BackgroundColor3 = Color3.new(1, 1, 1),
            AnchorPoint = Vector2.new(0, 0.5),
            BorderColor3 = Color3.new(0, 0, 0),
            Size = UDim2.new(1, 0, 0, 1),
            ZIndex = 18,
            Parent = aR
        })
        local aT = p:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0),
            Position = UDim2.fromOffset(4, 228),
            Size = UDim2.new(0.5, -6, 0, 20),
            ZIndex = 18,
            Parent = aJ
        })
        local aU = p:Create('Frame', {
            BackgroundColor3 = p.MainColor,
            BorderColor3 = p.OutlineColor,
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 18,
            Parent = aT
        })
        p:Create('UIGradient', {
            Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                                       ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))}),
            Rotation = 90,
            Parent = aU
        })
        local aV = p:Create('TextBox', {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 5, 0, 0),
            Size = UDim2.new(1, -5, 1, 0),
            Font = p.Font,
            PlaceholderColor3 = Color3.fromRGB(190, 190, 190),
            PlaceholderText = 'Hex color',
            Text = '#FFFFFF',
            TextColor3 = p.FontColor,
            TextSize = 14,
            TextStrokeTransparency = 0,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 20,
            Parent = aU
        })
        p:ApplyTextStroke(aV)
        local aW = p:Create(aT:Clone(), {
            Position = UDim2.new(0.5, 2, 0, 228),
            Size = UDim2.new(0.5, -6, 0, 20),
            Parent = aJ
        })
        local aX = p:Create(aW.Frame:FindFirstChild('TextBox'), {
            Text = '255, 255, 255',
            PlaceholderText = 'RGB color',
            TextColor3 = p.FontColor
        })
        local aY, aZ, a_;
        if aD.Transparency then
            aY = p:Create('Frame', {
                BorderColor3 = Color3.new(0, 0, 0),
                Position = UDim2.fromOffset(4, 251),
                Size = UDim2.new(1, -8, 0, 15),
                ZIndex = 19,
                Parent = aJ
            })
            aZ = p:Create('Frame', {
                BackgroundColor3 = aF.Value,
                BorderColor3 = p.OutlineColor,
                BorderMode = Enum.BorderMode.Inset,
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 19,
                Parent = aY
            })
            p:AddToRegistry(aZ, {
                BorderColor3 = 'OutlineColor'
            })
            local b0 = p:Create('ImageLabel', {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Image = 'http://www.roblox.com/asset/?id=18580630715',
                ZIndex = 20,
                Parent = aZ
            })
            a_ = p:Create('Frame', {
                BackgroundColor3 = Color3.new(1, 1, 1),
                AnchorPoint = Vector2.new(0.5, 0),
                BorderColor3 = Color3.new(0, 0, 0),
                Size = UDim2.new(0, 1, 1, 0),
                ZIndex = 21,
                Parent = aZ
            })
        end
        local b1 = p:CreateLabel({
            Size = UDim2.new(1, 0, 0, 14),
            Position = UDim2.fromOffset(5, 5),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 14,
            Text = aF.Title,
            TextWrapped = false,
            ZIndex = 16,
            Parent = aJ
        })
        local b2 = {}
        do
            b2.Options = {}
            b2.Container = p:Create('Frame', {
                BorderColor3 = Color3.new(),
                ZIndex = 14,
                Visible = false,
                Parent = l
            })
            b2.Inner = p:Create('Frame', {
                BackgroundColor3 = p.BackgroundColor,
                BorderColor3 = p.OutlineColor,
                BorderMode = Enum.BorderMode.Inset,
                Size = UDim2.fromScale(1, 1),
                ZIndex = 15,
                Parent = b2.Container
            })
            p:Create('UIListLayout', {
                Name = 'Layout',
                FillDirection = Enum.FillDirection.Vertical,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = b2.Inner
            })
            p:Create('UIPadding', {
                Name = 'Padding',
                PaddingLeft = UDim.new(0, 4),
                Parent = b2.Inner
            })
            local function b3()
                b2.Container.Position = UDim2.fromOffset(aG.AbsolutePosition.X + aG.AbsoluteSize.X + 4,
                    aG.AbsolutePosition.Y + 1)
            end
            local function b4()
                local b5 = 60;
                for v, b6 in next, b2.Inner:GetChildren() do
                    if b6:IsA('TextLabel') then
                        b5 = math.max(b5, b6.TextBounds.X)
                    end
                end
                b2.Container.Size = UDim2.fromOffset(b5 + 8, b2.Inner.Layout.AbsoluteContentSize.Y + 4)
            end
            aG:GetPropertyChangedSignal('AbsolutePosition'):Connect(b3)
            b2.Inner.Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(b4)
            task.spawn(b3)
            task.spawn(b4)
            p:AddToRegistry(b2.Inner, {
                BackgroundColor3 = 'BackgroundColor',
                BorderColor3 = 'OutlineColor'
            })
            function b2:Show()
                if p.IsMobile then
                    p.CanDrag = false
                end
                self.Container.Visible = true
            end
            function b2:Hide()
                if p.IsMobile then
                    p.CanDrag = true
                end
                self.Container.Visible = false
            end
            function b2:AddOption(b7, aA)
                if type(aA) ~= 'function' then
                    aA = function()
                    end
                end
                local b8 = p:CreateLabel({
                    Active = false,
                    Size = UDim2.new(1, 0, 0, 15),
                    TextSize = 13,
                    Text = b7,
                    ZIndex = 16,
                    Parent = self.Inner,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                p:OnHighlight(b8, b8, {
                    TextColor3 = 'AccentColor'
                }, {
                    TextColor3 = 'FontColor'
                })
                b8.InputBegan:Connect(function(M)
                    if M.UserInputType ~= Enum.UserInputType.MouseButton1 or M.UserInputType ~= Enum.UserInputType.Touch then
                        return
                    end
                    aA()
                end)
            end
            b2:AddOption('Copy color', function()
                p.ColorClipboard = aF.Value;
                p:Notify('Copied color!', 2)
            end)
            b2:AddOption('Paste color', function()
                if not p.ColorClipboard then
                    return p:Notify('You have not copied a color!', 2)
                end
                aF:SetValueRGB(p.ColorClipboard)
            end)
            b2:AddOption('Copy HEX', function()
                pcall(setclipboard, aF.Value:ToHex())
                p:Notify('Copied hex code to clipboard!', 2)
            end)
            b2:AddOption('Copy RGB', function()
                pcall(setclipboard, table.concat(
                    {math.floor(aF.Value.R * 255), math.floor(aF.Value.G * 255), math.floor(aF.Value.B * 255)}, ', '))
                p:Notify('Copied RGB values to clipboard!', 2)
            end)
        end
        p:AddToRegistry(aJ, {
            BackgroundColor3 = 'BackgroundColor',
            BorderColor3 = 'OutlineColor'
        })
        p:AddToRegistry(aK, {
            BackgroundColor3 = 'AccentColor'
        })
        p:AddToRegistry(aM, {
            BackgroundColor3 = 'BackgroundColor',
            BorderColor3 = 'OutlineColor'
        })
        p:AddToRegistry(aU, {
            BackgroundColor3 = 'MainColor',
            BorderColor3 = 'OutlineColor'
        })
        p:AddToRegistry(aW.Frame, {
            BackgroundColor3 = 'MainColor',
            BorderColor3 = 'OutlineColor'
        })
        p:AddToRegistry(aX, {
            TextColor3 = 'FontColor'
        })
        p:AddToRegistry(aV, {
            TextColor3 = 'FontColor'
        })
        local b9 = {}
        for r = 0, 1, 0.1 do
            table.insert(b9, ColorSequenceKeypoint.new(r, Color3.fromHSV(r, 1, 1)))
        end
        local ba = p:Create('UIGradient', {
            Color = ColorSequence.new(b9),
            Rotation = 90,
            Parent = aR
        })
        aV.FocusLost:Connect(function(bb)
            if bb then
                local B, bc = pcall(Color3.fromHex, aV.Text)
                if B and typeof(bc) == 'Color3' then
                    aF.Hue, aF.Sat, aF.Vib = Color3.toHSV(bc)
                end
            end
            aF:Display()
        end)
        aX.FocusLost:Connect(function(bb)
            if bb then
                local bd, be, bf = aX.Text:match('(%d+),%s*(%d+),%s*(%d+)')
                if bd and be and bf then
                    aF.Hue, aF.Sat, aF.Vib = Color3.toHSV(Color3.fromRGB(bd, be, bf))
                end
            end
            aF:Display()
        end)
        function aF:Display()
            aF.Value = Color3.fromHSV(aF.Hue, aF.Sat, aF.Vib)
            aN.BackgroundColor3 = Color3.fromHSV(aF.Hue, 1, 1)
            p:Create(aG, {
                BackgroundColor3 = aF.Value,
                BackgroundTransparency = aF.Transparency,
                BorderColor3 = p:GetDarkerColor(aF.Value)
            })
            if aZ then
                aZ.BackgroundColor3 = aF.Value;
                a_.Position = UDim2.new(1 - aF.Transparency, 0, 0, 0)
            end
            aO.Position = UDim2.new(aF.Sat, 0, 1 - aF.Vib, 0)
            aS.Position = UDim2.new(0, 0, aF.Hue, 0)
            aV.Text = '#' .. aF.Value:ToHex()
            aX.Text = table.concat({math.floor(aF.Value.R * 255), math.floor(aF.Value.G * 255),
                                    math.floor(aF.Value.B * 255)}, ', ')
            p:SafeCallback(aF.Callback, aF.Value)
            p:SafeCallback(aF.Changed, aF.Value)
        end
        function aF:OnChanged(bg)
            aF.Changed = bg;
            bg(aF.Value)
        end
        function aF:Show()
            for ae, bh in next, p.OpenedFrames do
                if ae.Name == 'Color' then
                    ae.Visible = false;
                    p.OpenedFrames[ae] = nil
                end
            end
            aI.Visible = true;
            p.OpenedFrames[aI] = true
        end
        function aF:Hide()
            aI.Visible = false;
            p.OpenedFrames[aI] = nil
        end
        function aF:SetValue(bi, _)
            local ar = Color3.fromHSV(bi[1], bi[2], bi[3])
            aF.Transparency = _ or 0;
            aF:SetHSVFromRGB(ar)
            aF:Display()
        end
        function aF:SetValueRGB(ar, _)
            aF.Transparency = _ or 0;
            aF:SetHSVFromRGB(ar)
            aF:Display()
        end
        aN.InputBegan:Connect(function(M)
            if M.UserInputType == Enum.UserInputType.MouseButton1 or M.UserInputType == Enum.UserInputType.Touch then
                while a:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
                    local bj = aN.AbsolutePosition.X;
                    local bk = bj + aN.AbsoluteSize.X;
                    local bl = math.clamp(j.X, bj, bk)
                    local bm = aN.AbsolutePosition.Y;
                    local bn = bm + aN.AbsoluteSize.Y;
                    local bo = math.clamp(j.Y, bm, bn)
                    aF.Sat = (bl - bj) / (bk - bj)
                    aF.Vib = 1 - (bo - bm) / (bn - bm)
                    aF:Display()
                    h:Wait()
                end
                p:AttemptSave()
            end
        end)
        aR.InputBegan:Connect(function(M)
            if M.UserInputType == Enum.UserInputType.MouseButton1 or M.UserInputType == Enum.UserInputType.Touch then
                while a:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
                    local bm = aR.AbsolutePosition.Y;
                    local bn = bm + aR.AbsoluteSize.Y;
                    local bo = math.clamp(j.Y, bm, bn)
                    aF.Hue = (bo - bm) / (bn - bm)
                    aF:Display()
                    h:Wait()
                end
                p:AttemptSave()
            end
        end)
        aG.InputBegan:Connect(function(M)
            if p:MouseIsOverOpenedFrame() then
                return
            end
            if M.UserInputType == Enum.UserInputType.MouseButton1 or M.UserInputType == Enum.UserInputType.Touch then
                if aI.Visible then
                    aF:Hide()
                else
                    b2:Hide()
                    aF:Show()
                end
            elseif M.UserInputType == Enum.UserInputType.MouseButton2 then
                b2:Show()
                aF:Hide()
            end
        end)
        if aZ then
            aZ.InputBegan:Connect(function(M)
                if M.UserInputType == Enum.UserInputType.MouseButton1 or M.UserInputType == Enum.UserInputType.Touch then
                    while a:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
                        local bj = aZ.AbsolutePosition.X;
                        local bk = bj + aZ.AbsoluteSize.X;
                        local bl = math.clamp(j.X, bj, bk)
                        aF.Transparency = 1 - (bl - bj) / (bk - bj)
                        aF:Display()
                        h:Wait()
                    end
                    p:AttemptSave()
                end
            end)
        end
        p:GiveSignal(a.InputBegan:Connect(function(M)
            if M.UserInputType == Enum.UserInputType.MouseButton1 or M.UserInputType == Enum.UserInputType.Touch then
                local af, ag = aI.AbsolutePosition, aI.AbsoluteSize;
                if j.X < af.X or j.X > af.X + ag.X or j.Y < af.Y - 20 - 1 or j.Y > af.Y + ag.Y then
                    aF:Hide()
                end
                if not p:IsMouseOverFrame(b2.Container) then
                    b2:Hide()
                end
            end
            if M.UserInputType == Enum.UserInputType.MouseButton2 and b2.Container.Visible then
                if not p:IsMouseOverFrame(b2.Container) and not p:IsMouseOverFrame(aG) then
                    b2:Hide()
                end
            end
        end))
        aF:Display()
        aF.DisplayFrame = aG;
        n[av] = aF;
        return self
    end
    function aC:AddKeyPicker(av, aD)
        local bp = self;
        local aE = self.TextLabel;
        local bq = self.Container;
        assert(aD.Default, 'AddKeyPicker: Missing default value.')
        local br = {
            Value = aD.Default,
            Toggled = false,
            Mode = aD.Mode or 'Toggle',
            Type = 'KeyPicker',
            Callback = aD.Callback or function(I)
            end,
            ChangedCallback = aD.ChangedCallback or function(bs)
            end,
            SyncToggleState = aD.SyncToggleState or false
        }
        if br.SyncToggleState then
            aD.Modes = {'Toggle'}
            aD.Mode = 'Toggle'
        end
        local bt = p:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0),
            BorderColor3 = Color3.new(0, 0, 0),
            Size = UDim2.new(0, 28, 0, 15),
            ZIndex = 6,
            Parent = aE
        })
        local bu = p:Create('Frame', {
            BackgroundColor3 = p.BackgroundColor,
            BorderColor3 = p.OutlineColor,
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 7,
            Parent = bt
        })
        p:AddToRegistry(bu, {
            BackgroundColor3 = 'BackgroundColor',
            BorderColor3 = 'OutlineColor'
        })
        local b1 = p:CreateLabel({
            Size = UDim2.new(1, 0, 1, 0),
            TextSize = 13,
            Text = aD.Default,
            TextWrapped = true,
            ZIndex = 8,
            Parent = bu
        })
        local bv = p:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0),
            Position = UDim2.fromOffset(aE.AbsolutePosition.X + aE.AbsoluteSize.X + 4, aE.AbsolutePosition.Y + 1),
            Size = UDim2.new(0, 60, 0, 45 + 2),
            Visible = false,
            ZIndex = 14,
            Parent = l
        })
        aE:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
            bv.Position = UDim2.fromOffset(aE.AbsolutePosition.X + aE.AbsoluteSize.X + 4, aE.AbsolutePosition.Y + 1)
        end)
        local bw = p:Create('Frame', {
            BackgroundColor3 = p.BackgroundColor,
            BorderColor3 = p.OutlineColor,
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 15,
            Parent = bv
        })
        p:AddToRegistry(bw, {
            BackgroundColor3 = 'BackgroundColor',
            BorderColor3 = 'OutlineColor'
        })
        p:Create('UIListLayout', {
            FillDirection = Enum.FillDirection.Vertical,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = bw
        })
        local bx = p:CreateLabel({
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 0, 18),
            TextSize = 13,
            Visible = false,
            ZIndex = 110,
            Parent = p.KeybindContainer
        }, true)
        local by = aD.Modes or {'Always', 'Toggle', 'Hold'}
        local bz = {}
        for av, bA in next, by do
            local bB = {}
            local a7 = p:CreateLabel({
                Active = false,
                Size = UDim2.new(1, 0, 0, 15),
                TextSize = 13,
                Text = bA,
                ZIndex = 16,
                Parent = bw
            })
            function bB:Select()
                for D, b8 in next, bz do
                    b8:Deselect()
                end
                br.Mode = bA;
                a7.TextColor3 = p.AccentColor;
                p.RegistryMap[a7].Properties.TextColor3 = 'AccentColor'
                bv.Visible = false
            end
            function bB:Deselect()
                br.Mode = nil;
                a7.TextColor3 = p.FontColor;
                p.RegistryMap[a7].Properties.TextColor3 = 'FontColor'
            end
            a7.InputBegan:Connect(function(M)
                if M.UserInputType == Enum.UserInputType.MouseButton1 then
                    bB:Select()
                    p:AttemptSave()
                end
            end)
            if bA == br.Mode then
                bB:Select()
            end
            bz[bA] = bB
        end
        function br:Update()
            if aD.NoUI then
                return
            end
            local bC = br:GetState()
            bx.Text = string.format('[%s] %s (%s)', br.Value, aD.Text, br.Mode)
            bx.Visible = true;
            bx.TextColor3 = bC and p.AccentColor or p.FontColor;
            p.RegistryMap[bx].Properties.TextColor3 = bC and 'AccentColor' or 'FontColor'
            local bD = 0;
            local bE = 0;
            for D, a7 in next, p.KeybindContainer:GetChildren() do
                if a7:IsA('TextLabel') and a7.Visible then
                    bD = bD + 18;
                    if a7.TextBounds.X > bE then
                        bE = a7.TextBounds.X
                    end
                end
            end
            p.KeybindFrame.Size = UDim2.new(0, math.max(bE + 10, 210), 0, bD + 23)
        end
        function br:GetState()
            if br.Mode == 'Always' then
                return true
            elseif br.Mode == 'Hold' then
                if br.Value == 'None' then
                    return false
                end
                local bF = br.Value;
                if bF == 'MB1' or bF == 'MB2' then
                    return bF == 'MB1' and a:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or bF == 'MB2' and
                               a:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
                else
                    return a:IsKeyDown(Enum.KeyCode[br.Value])
                end
            else
                return br.Toggled
            end
        end
        function br:SetValue(aw)
            local bF, bA = aw[1], aw[2]
            b1.Text = bF;
            br.Value = bF;
            bz[bA]:Select()
            br:Update()
        end
        function br:OnClick(aA)
            br.Clicked = aA
        end
        function br:OnChanged(aA)
            br.Changed = aA;
            aA(br.Value)
        end
        if bp.Addons then
            table.insert(bp.Addons, br)
        end
        function br:DoClick()
            if bp.Type == 'Toggle' and br.SyncToggleState then
                bp:SetValue(not bp.Value)
            end
            p:SafeCallback(br.Callback, br.Toggled)
            p:SafeCallback(br.Clicked, br.Toggled)
        end
        local bG = false;
        bt.InputBegan:Connect(function(M)
            if M.UserInputType == Enum.UserInputType.MouseButton1 and not p:MouseIsOverOpenedFrame() then
                bG = true;
                b1.Text = ''
                local bH;
                local am = ''
                task.spawn(function()
                    while not bH do
                        if am == '...' then
                            am = ''
                        end
                        am = am .. '.'
                        b1.Text = am;
                        task.wait(0.4)
                    end
                end)
                task.wait(0.2)
                local bI;
                bI = a.InputBegan:Connect(function(M)
                    local bF;
                    if M.UserInputType == Enum.UserInputType.Keyboard then
                        bF = M.KeyCode.Name
                    elseif M.UserInputType == Enum.UserInputType.MouseButton1 then
                        bF = 'MB1'
                    elseif M.UserInputType == Enum.UserInputType.MouseButton2 then
                        bF = 'MB2'
                    end
                    bH = true;
                    bG = false;
                    b1.Text = bF;
                    br.Value = bF;
                    p:SafeCallback(br.ChangedCallback, M.KeyCode or M.UserInputType)
                    p:SafeCallback(br.Changed, M.KeyCode or M.UserInputType)
                    p:AttemptSave()
                    bI:Disconnect()
                end)
            elseif M.UserInputType == Enum.UserInputType.MouseButton2 and not p:MouseIsOverOpenedFrame() then
                bv.Visible = true
            end
        end)
        p:GiveSignal(a.InputBegan:Connect(function(M)
            if br.Value == "Unknown" then
                return
            end
            if not bG and not a:GetFocusedTextBox() then
                if br.Mode == 'Toggle' then
                    local bF = br.Value;
                    if bF == 'MB1' or bF == 'MB2' then
                        if bF == 'MB1' and M.UserInputType == Enum.UserInputType.MouseButton1 or bF == 'MB2' and
                            M.UserInputType == Enum.UserInputType.MouseButton2 then
                            br.Toggled = not br.Toggled;
                            br:DoClick()
                        end
                    elseif M.UserInputType == Enum.UserInputType.Keyboard then
                        if M.KeyCode.Name == bF then
                            br.Toggled = not br.Toggled;
                            br:DoClick()
                        end
                    end
                end
                br:Update()
            end
            if M.UserInputType == Enum.UserInputType.MouseButton1 then
                local af, ag = bv.AbsolutePosition, bv.AbsoluteSize;
                if j.X < af.X or j.X > af.X + ag.X or j.Y < af.Y - 20 - 1 or j.Y > af.Y + ag.Y then
                    bv.Visible = false
                end
            end
        end))
        p:GiveSignal(a.InputEnded:Connect(function(M)
            if not bG then
                br:Update()
            end
        end))
        br:Update()
        n[av] = br;
        return self
    end
    aB.__index = aC;
    aB.__namecall = function(bJ, bF, ...)
        return aC[bF](...)
    end
end
local bK = {}
do
    local aC = {}
    function aC:AddBlank(ao)
        local bL = self;
        local bq = bL.Container;
        p:Create('Frame', {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, ao),
            ZIndex = 1,
            Parent = bq
        })
    end
    function aC:AddLabel(am, bM)
        local a7 = {}
        local bL = self;
        local bq = bL.Container;
        local bN = p:CreateLabel({
            Size = UDim2.new(1, -4, 0, 15),
            TextSize = 14,
            Text = am,
            TextWrapped = bM or false,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 5,
            Parent = bq
        })
        if bM then
            local a5 = select(2, p:GetTextBounds(am, p.Font, 14, Vector2.new(bN.AbsoluteSize.X, math.huge)))
            bN.Size = UDim2.new(1, -4, 0, a5)
        else
            p:Create('UIListLayout', {
                Padding = UDim.new(0, 4),
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = bN
            })
        end
        a7.TextLabel = bN;
        a7.Container = bq;
        function a7:SetText(am)
            bN.Text = am;
            if bM then
                local a5 = select(2, p:GetTextBounds(am, p.Font, 14, Vector2.new(bN.AbsoluteSize.X, math.huge)))
                bN.Size = UDim2.new(1, -4, 0, a5)
            end
            bL:Resize()
        end
        if not bM then
            setmetatable(a7, aB)
        end
        bL:AddBlank(5)
        bL:Resize()
        return a7
    end
    function aC:AddButton(...)
        local b8 = {}
        local function bO(E, bP, ...)
            local bQ = select(1, ...)
            if type(bQ) == 'table' then
                bP.Text = bQ.Text;
                bP.Func = bQ.Func;
                bP.DoubleClick = bQ.DoubleClick;
                bP.Tooltip = bQ.Tooltip
            else
                bP.Text = select(1, ...)
                bP.Func = select(2, ...)
            end
            assert(type(bP.Func) == 'function', 'AddButton: `Func` callback is missing.')
        end
        bO('Button', b8, ...)
        local bL = self;
        local bq = bL.Container;
        local function bR(b8)
            local bS = p:Create('Frame', {
                BackgroundColor3 = Color3.new(0, 0, 0),
                BorderColor3 = Color3.new(0, 0, 0),
                Size = UDim2.new(1, -4, 0, 20),
                ZIndex = 5
            })
            local bT = p:Create('Frame', {
                BackgroundColor3 = p.MainColor,
                BorderColor3 = p.OutlineColor,
                BorderMode = Enum.BorderMode.Inset,
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 6,
                Parent = bS
            })
            local a7 = p:CreateLabel({
                Size = UDim2.new(1, 0, 1, 0),
                TextSize = 14,
                Text = b8.Text,
                ZIndex = 6,
                Parent = bT
            })
            p:Create('UIGradient', {
                Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                                           ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))}),
                Rotation = 90,
                Parent = bT
            })
            p:AddToRegistry(bS, {
                BorderColor3 = 'Black'
            })
            p:AddToRegistry(bT, {
                BackgroundColor3 = 'MainColor',
                BorderColor3 = 'OutlineColor'
            })
            p:OnHighlight(bS, bS, {
                BorderColor3 = 'AccentColor'
            }, {
                BorderColor3 = 'Black'
            })
            return bS, bT, a7
        end
        local function bU(b8)
            local function bV(C, bW, bX)
                local bY = Instance.new('BindableEvent')
                local bZ = C:Once(function(...)
                    if type(bX) == 'function' and bX(...) then
                        bY:Fire(true)
                    else
                        bY:Fire(false)
                    end
                end)
                task.delay(bW, function()
                    bZ:disconnect()
                    bY:Fire(false)
                end)
                return bY.Event:Wait()
            end
            local function b_(M)
                if p:MouseIsOverOpenedFrame(M) then
                    return false
                end
                if M.UserInputType == Enum.UserInputType.MouseButton1 then
                    return true
                elseif M.UserInputType == Enum.UserInputType.Touch then
                    return true
                else
                    return false
                end
            end
            b8.Outer.InputBegan:Connect(function(M)
                if not b_(M) then
                    return
                end
                if b8.Locked then
                    return
                end
                if b8.DoubleClick then
                    p:RemoveFromRegistry(b8.Label)
                    p:AddToRegistry(b8.Label, {
                        TextColor3 = 'AccentColor'
                    })
                    b8.Label.TextColor3 = p.AccentColor;
                    b8.Label.Text = 'Are you sure?'
                    b8.Locked = true;
                    local c0 = bV(b8.Outer.InputBegan, 0.5, b_)
                    p:RemoveFromRegistry(b8.Label)
                    p:AddToRegistry(b8.Label, {
                        TextColor3 = 'FontColor'
                    })
                    b8.Label.TextColor3 = p.FontColor;
                    b8.Label.Text = b8.Text;
                    task.defer(rawset, b8, 'Locked', false)
                    if c0 then
                        p:SafeCallback(b8.Func)
                    end
                    return
                end
                p:SafeCallback(b8.Func)
            end)
        end
        b8.Outer, b8.Inner, b8.Label = bR(b8)
        b8.Outer.Parent = bq;
        bU(b8)
        function b8:AddTooltip(c1)
            if type(c1) == 'string' then
                p:AddToolTip(c1, self.Outer)
            end
            return self
        end
        function b8:AddButton(...)
            local c2 = {}
            bO('SubButton', c2, ...)
            self.Outer.Size = UDim2.new(0.5, -2, 0, 20)
            c2.Outer, c2.Inner, c2.Label = bR(c2)
            c2.Outer.Position = UDim2.new(1, 3, 0, 0)
            c2.Outer.Size = UDim2.new(1, -3, 1, 0)
            c2.Outer.Parent = self.Outer;
            function c2:AddTooltip(c1)
                if type(c1) == 'string' then
                    p:AddToolTip(c1, self.Outer)
                end
                return c2
            end
            if type(c2.Tooltip) == 'string' then
                c2:AddTooltip(c2.Tooltip)
            end
            bU(c2)
            return c2
        end
        if type(b8.Tooltip) == 'string' then
            b8:AddTooltip(b8.Tooltip)
        end
        bL:AddBlank(5)
        bL:Resize()
        return b8
    end
    function aC:AddDivider()
        local bL = self;
        local bq = self.Container;
        local c3 = {
            Type = 'Divider'
        }
        bL:AddBlank(2)
        local c4 = p:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0),
            BorderColor3 = Color3.new(0, 0, 0),
            Size = UDim2.new(1, -4, 0, 5),
            ZIndex = 5,
            Parent = bq
        })
        local c5 = p:Create('Frame', {
            BackgroundColor3 = p.MainColor,
            BorderColor3 = p.OutlineColor,
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 6,
            Parent = c4
        })
        p:AddToRegistry(c4, {
            BorderColor3 = 'Black'
        })
        p:AddToRegistry(c5, {
            BackgroundColor3 = 'MainColor',
            BorderColor3 = 'OutlineColor'
        })
        bL:AddBlank(9)
        bL:Resize()
    end
    function aC:AddInput(av, aD)
        assert(aD.Text, 'AddInput: Missing `Text` string.')
        local c6 = {
            Value = aD.Default or '',
            Numeric = aD.Numeric or false,
            Finished = aD.Finished or false,
            Type = 'Input',
            Callback = aD.Callback or function(I)
            end
        }
        local bL = self;
        local bq = bL.Container;
        local c7 = p:CreateLabel({
            Size = UDim2.new(1, 0, 0, 15),
            TextSize = 14,
            Text = aD.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 5,
            Parent = bq
        })
        bL:AddBlank(1)
        local c8 = p:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0),
            BorderColor3 = Color3.new(0, 0, 0),
            Size = UDim2.new(1, -4, 0, 20),
            ZIndex = 5,
            Parent = bq
        })
        local c9 = p:Create('Frame', {
            BackgroundColor3 = p.MainColor,
            BorderColor3 = p.OutlineColor,
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 6,
            Parent = c8
        })
        p:AddToRegistry(c9, {
            BackgroundColor3 = 'MainColor',
            BorderColor3 = 'OutlineColor'
        })
        p:OnHighlight(c8, c8, {
            BorderColor3 = 'AccentColor'
        }, {
            BorderColor3 = 'Black'
        })
        if type(aD.Tooltip) == 'string' then
            p:AddToolTip(aD.Tooltip, c8)
        end
        p:Create('UIGradient', {
            Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                                       ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))}),
            Rotation = 90,
            Parent = c9
        })
        local bq = p:Create('Frame', {
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Position = UDim2.new(0, 5, 0, 0),
            Size = UDim2.new(1, -5, 1, 0),
            ZIndex = 7,
            Parent = c9
        })
        local ca = p:Create('TextBox', {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.fromScale(5, 1),
            Font = p.Font,
            PlaceholderColor3 = Color3.fromRGB(190, 190, 190),
            PlaceholderText = aD.Placeholder or '',
            Text = aD.Default or '',
            TextColor3 = p.FontColor,
            TextSize = 14,
            TextStrokeTransparency = 0,
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = typeof(aD.ClearTextOnFocus) ~= "boolean" and true or aD.ClearTextOnFocus,
            ZIndex = 7,
            Parent = bq
        })
        p:ApplyTextStroke(ca)
        function c6:SetValue(am)
            if aD.MaxLength and #am > aD.MaxLength then
                am = am:sub(1, aD.MaxLength)
            end
            if c6.Numeric then
                if not tonumber(am) and am:len() > 0 then
                    am = c6.Value
                end
            end
            c6.Value = am;
            ca.Text = am;
            p:SafeCallback(c6.Callback, c6.Value)
            p:SafeCallback(c6.Changed, c6.Value)
        end
        if c6.Finished then
            ca.FocusLost:Connect(function(bb)
                if not bb then
                    return
                end
                c6:SetValue(ca.Text)
                p:AttemptSave()
            end)
        else
            ca:GetPropertyChangedSignal('Text'):Connect(function()
                c6:SetValue(ca.Text)
                p:AttemptSave()
            end)
        end
        local function cb()
            local cc = 2;
            local cd = bq.AbsoluteSize.X;
            if not ca:IsFocused() or ca.TextBounds.X <= cd - 2 * cc then
                ca.Position = UDim2.new(0, cc, 0, 0)
            else
                local ce = ca.CursorPosition;
                if ce ~= -1 then
                    local cf = string.sub(ca.Text, 1, ce - 1)
                    local cg = b:GetTextSize(cf, ca.TextSize, ca.Font, Vector2.new(math.huge, math.huge)).X;
                    local ch = ca.Position.X.Offset + cg;
                    if ch < cc then
                        ca.Position = UDim2.fromOffset(cc - cg, 0)
                    elseif ch > cd - cc - 1 then
                        ca.Position = UDim2.fromOffset(cd - cg - cc - 1, 0)
                    end
                end
            end
        end
        task.spawn(cb)
        ca:GetPropertyChangedSignal('Text'):Connect(cb)
        ca:GetPropertyChangedSignal('CursorPosition'):Connect(cb)
        ca.FocusLost:Connect(cb)
        ca.Focused:Connect(cb)
        p:AddToRegistry(ca, {
            TextColor3 = 'FontColor'
        })
        function c6:OnChanged(bg)
            c6.Changed = bg;
            bg(c6.Value)
        end
        bL:AddBlank(5)
        bL:Resize()
        n[av] = c6;
        return c6
    end
    function aC:AddToggle(av, aD)
        assert(aD.Text, 'AddInput: Missing `Text` string.')
        local ci = {
            Value = aD.Default or false,
            Type = 'Toggle',
            Callback = aD.Callback or function(I)
            end,
            Addons = {},
            Risky = aD.Risky
        }
        local bL = self;
        local bq = bL.Container;
        local cj = p:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0),
            BorderColor3 = Color3.new(0, 0, 0),
            Size = UDim2.new(0, 13, 0, 13),
            ZIndex = 5,
            Parent = bq
        })
        p:AddToRegistry(cj, {
            BorderColor3 = 'Black'
        })
        local ck = p:Create('Frame', {
            BackgroundColor3 = p.MainColor,
            BorderColor3 = p.OutlineColor,
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 6,
            Parent = cj
        })
        p:AddToRegistry(ck, {
            BackgroundColor3 = 'MainColor',
            BorderColor3 = 'OutlineColor'
        })
        local aE = p:CreateLabel({
            Size = UDim2.new(0, 216, 1, 0),
            Position = UDim2.new(1, 6, 0, 0),
            TextSize = 14,
            Text = aD.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 6,
            Parent = ck
        })
        p:Create('UIListLayout', {
            Padding = UDim.new(0, 4),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = aE
        })
        local cl = p:Create('Frame', {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 170, 1, 0),
            ZIndex = 8,
            Parent = cj
        })
        p:OnHighlight(cl, cj, {
            BorderColor3 = 'AccentColor'
        }, {
            BorderColor3 = 'Black'
        })
        function ci:UpdateColors()
            ci:Display()
        end
        if type(aD.Tooltip) == 'string' then
            p:AddToolTip(aD.Tooltip, cl)
        end
        function ci:Display()
            ck.BackgroundColor3 = ci.Value and p.AccentColor or p.MainColor;
            ck.BorderColor3 = ci.Value and p.AccentColorDark or p.OutlineColor;
            p.RegistryMap[ck].Properties.BackgroundColor3 = ci.Value and 'AccentColor' or 'MainColor'
            p.RegistryMap[ck].Properties.BorderColor3 = ci.Value and 'AccentColorDark' or 'OutlineColor'
        end
        function ci:OnChanged(bg)
            ci.Changed = bg;
            bg(ci.Value)
        end
        function ci:SetValue(cm)
            cm = not not cm;
            if ci.Value == cm then
                return
            end
            ci.Value = cm;
            ci:Display()
            for D, cn in next, ci.Addons do
                if cn.Type == 'KeyPicker' and cn.SyncToggleState then
                    cn.Toggled = cm;
                    cn:Update()
                end
            end
            p:SafeCallback(ci.Callback, ci.Value)
            p:SafeCallback(ci.Changed, ci.Value)
            p:UpdateDependencyBoxes()
        end
        cl.InputBegan:Connect(function(M)
            if M.UserInputType == Enum.UserInputType.MouseButton1 and not p:MouseIsOverOpenedFrame() or M.UserInputType ==
                Enum.UserInputType.Touch then
                ci:SetValue(not ci.Value)
                p:AttemptSave()
            end
        end)
        if ci.Risky then
            p:RemoveFromRegistry(aE)
            aE.TextColor3 = p.RiskColor;
            p:AddToRegistry(aE, {
                TextColor3 = 'RiskColor'
            })
        end
        ci:Display()
        bL:AddBlank(aD.BlankSize or 5 + 2)
        bL:Resize()
        ci.TextLabel = aE;
        ci.Container = bq;
        setmetatable(ci, aB)
        m[av] = ci;
        p:UpdateDependencyBoxes()
        return ci
    end
    function aC:AddSlider(av, aD)
        assert(aD.Default, 'AddSlider: Missing default value.')
        assert(aD.Text, 'AddSlider: Missing slider text.')
        assert(aD.Min, 'AddSlider: Missing minimum value.')
        assert(aD.Max, 'AddSlider: Missing maximum value.')
        assert(aD.Rounding, 'AddSlider: Missing rounding value.')
        local co = {
            Value = aD.Default,
            Min = aD.Min,
            Max = aD.Max,
            Rounding = aD.Rounding,
            MaxSize = 232,
            Type = 'Slider',
            Callback = aD.Callback or function(I)
            end
        }
        local bL = self;
        local bq = bL.Container;
        if not aD.Compact then
            p:CreateLabel({
                Size = UDim2.new(1, 0, 0, 10),
                TextSize = 14,
                Text = aD.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Bottom,
                ZIndex = 5,
                Parent = bq
            })
            bL:AddBlank(3)
        end
        local cp = p:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0),
            BorderColor3 = Color3.new(0, 0, 0),
            Size = UDim2.new(1, -4, 0, 13),
            ZIndex = 5,
            Parent = bq
        })
        cp:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
            co.MaxSize = cp.AbsoluteSize.X - 2
        end)
        p:AddToRegistry(cp, {
            BorderColor3 = 'Black'
        })
        local cq = p:Create('Frame', {
            BackgroundColor3 = p.MainColor,
            BorderColor3 = p.OutlineColor,
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 6,
            Parent = cp
        })
        p:AddToRegistry(cq, {
            BackgroundColor3 = 'MainColor',
            BorderColor3 = 'OutlineColor'
        })
        local cr = p:Create('Frame', {
            BackgroundColor3 = p.AccentColor,
            BorderColor3 = p.AccentColorDark,
            Size = UDim2.new(0, 0, 1, 0),
            ZIndex = 7,
            Parent = cq
        })
        p:AddToRegistry(cr, {
            BackgroundColor3 = 'AccentColor',
            BorderColor3 = 'AccentColorDark'
        })
        local cs = p:Create('Frame', {
            BackgroundColor3 = p.AccentColor,
            BorderSizePixel = 0,
            Position = UDim2.new(1, 0, 0, 0),
            Size = UDim2.new(0, 1, 1, 0),
            ZIndex = 8,
            Parent = cr
        })
        p:AddToRegistry(cs, {
            BackgroundColor3 = 'AccentColor'
        })
        local b1 = p:CreateLabel({
            Size = UDim2.new(1, 0, 1, 0),
            TextSize = 14,
            Text = 'Infinite',
            ZIndex = 9,
            Parent = cq
        })
        p:OnHighlight(cp, cp, {
            BorderColor3 = 'AccentColor'
        }, {
            BorderColor3 = 'Black'
        })
        if type(aD.Tooltip) == 'string' then
            p:AddToolTip(aD.Tooltip, cp)
        end
        function co:UpdateColors()
            cr.BackgroundColor3 = p.AccentColor;
            cr.BorderColor3 = p.AccentColorDark
        end
        function co:Display()
            local ct = aD.Suffix or ''
            if aD.Compact then
                b1.Text = aD.Text .. ': ' .. co.Value .. ct
            elseif aD.HideMax then
                b1.Text = string.format('%s', co.Value .. ct)
            else
                b1.Text = string.format('%s/%s', co.Value .. ct, co.Max .. ct)
            end
            local a4 = p:MapValue(co.Value, co.Min, co.Max, 0, 1)
            cr.Size = UDim2.new(a4, 0, 1, 0)
            cs.Visible = not (a4 == 1 or a4 == 0)
        end
        function co:OnChanged(bg)
            co.Changed = bg;
            bg(co.Value)
        end
        local function cu(I)
            if co.Rounding == 0 then
                return math.floor(I)
            end
            return tonumber(string.format('%.' .. co.Rounding .. 'f', I))
        end
        function co:GetValueFromXScale(a4)
            return cu(p:MapValue(a4, 0, 1, co.Min, co.Max))
        end
        function co:SetMax(I)
            assert(I > co.Min, 'Max value cannot be less than the current min value.')
            co.Value = math.clamp(co.Value, co.Min, I)
            co.Max = I;
            co:Display()
        end
        function co:SetMin(I)
            assert(I < co.Max, 'Min value cannot be greater than the current max value.')
            co.Value = math.clamp(co.Value, I, co.Max)
            co.Min = I;
            co:Display()
        end
        function co:SetValue(b7)
            local cv = tonumber(b7)
            if not cv then
                return
            end
            cv = math.clamp(cv, co.Min, co.Max)
            co.Value = cv;
            co:Display()
            p:SafeCallback(co.Callback, co.Value)
            p:SafeCallback(co.Changed, co.Value)
        end
        cq.InputBegan:Connect(function(M)
            if M.UserInputType == Enum.UserInputType.MouseButton1 and not p:MouseIsOverOpenedFrame() or M.UserInputType ==
                Enum.UserInputType.Touch then
                if p.IsMobile then
                    p.CanDrag = false
                end
                local cw = {}
                if p.Window then
                    cw = p.Window.Tabs[p.ActiveTab]:GetSides()
                end
                for D, cx in pairs(cw) do
                    if typeof(cx) == "Instance" then
                        if cx:IsA("ScrollingFrame") then
                            cx.ScrollingEnabled = false
                        end
                    end
                end
                local cy = j.X;
                local cz = cr.AbsoluteSize.X;
                local cA = cy - (cr.AbsolutePosition.X + cz)
                while a:IsMouseButtonPressed(Enum.UserInputType.MouseButton1 or Enum.UserInputType.Touch) do
                    local cB = j.X;
                    local cC = math.clamp(cz + cB - cy + cA, 0, co.MaxSize)
                    local cD = p:MapValue(cC, 0, co.MaxSize, 0, 1)
                    local cE = co:GetValueFromXScale(cD)
                    local cF = co.Value;
                    co.Value = cE;
                    co:Display()
                    if cE ~= cF then
                        p:SafeCallback(co.Callback, co.Value)
                        p:SafeCallback(co.Changed, co.Value)
                    end
                    h:Wait()
                end
                if p.IsMobile then
                    p.CanDrag = true
                end
                for D, cx in pairs(cw) do
                    if typeof(cx) == "Instance" then
                        if cx:IsA("ScrollingFrame") then
                            cx.ScrollingEnabled = true
                        end
                    end
                end
                p:AttemptSave()
            end
        end)
        co:Display()
        bL:AddBlank(aD.BlankSize or 6)
        bL:Resize()
        n[av] = co;
        return co
    end
    function aC:AddDropdown(av, aD)
        if aD.SpecialType == 'Player' then
            aD.Values = t()
            aD.AllowNull = true
        elseif aD.SpecialType == 'Team' then
            aD.Values = y()
            aD.AllowNull = true
        end
        assert(aD.Values, 'AddDropdown: Missing dropdown value list.')
        assert(aD.AllowNull or aD.Default,
            'AddDropdown: Missing default value. Pass `AllowNull` as true if this was intentional.')
        if not aD.Text then
            aD.Compact = true
        end
        local cG = {
            Values = aD.Values,
            Value = aD.Multi and {},
            Multi = aD.Multi,
            Type = 'Dropdown',
            SpecialType = aD.SpecialType,
            Callback = aD.Callback or function(I)
            end
        }
        local bL = self;
        local bq = bL.Container;
        local cH = 0;
        if not aD.Compact then
            local cI = p:CreateLabel({
                Size = UDim2.new(1, 0, 0, 10),
                TextSize = 14,
                Text = aD.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Bottom,
                ZIndex = 5,
                Parent = bq
            })
            bL:AddBlank(3)
        end
        for D, cJ in next, bq:GetChildren() do
            if not cJ:IsA('UIListLayout') then
                cH = cH + cJ.Size.Y.Offset
            end
        end
        local cK = p:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0),
            BorderColor3 = Color3.new(0, 0, 0),
            Size = UDim2.new(1, -4, 0, 20),
            ZIndex = 5,
            Parent = bq
        })
        p:AddToRegistry(cK, {
            BorderColor3 = 'Black'
        })
        local cL = p:Create('Frame', {
            BackgroundColor3 = p.MainColor,
            BorderColor3 = p.OutlineColor,
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 6,
            Parent = cK
        })
        p:AddToRegistry(cL, {
            BackgroundColor3 = 'MainColor',
            BorderColor3 = 'OutlineColor'
        })
        p:Create('UIGradient', {
            Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                                       ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))}),
            Rotation = 90,
            Parent = cL
        })
        local cM = p:Create('ImageLabel', {
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -16, 0.5, 0),
            Size = UDim2.new(0, 12, 0, 12),
            Image = 'http://www.roblox.com/asset/?id=18580628464',
            ZIndex = 8,
            Parent = cL
        })
        local cN = p:CreateLabel({
            Position = UDim2.new(0, 5, 0, 0),
            Size = UDim2.new(1, -5, 1, 0),
            TextSize = 14,
            Text = '--',
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            ZIndex = 7,
            Parent = cL
        })
        p:OnHighlight(cK, cK, {
            BorderColor3 = 'AccentColor'
        }, {
            BorderColor3 = 'Black'
        })
        if type(aD.Tooltip) == 'string' then
            p:AddToolTip(aD.Tooltip, cK)
        end
        local cO = 8;
        local cP = p:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0),
            BorderColor3 = Color3.new(0, 0, 0),
            ZIndex = 20,
            Visible = false,
            Parent = l
        })
        local function cQ()
            cP.Position = UDim2.fromOffset(cK.AbsolutePosition.X, cK.AbsolutePosition.Y + cK.Size.Y.Offset + 1)
        end
        local function cR(bD)
            local a5 = bD or math.clamp(#cG.Values * 20, 0, cO * 20) + 1;
            cP.Size = UDim2.fromOffset(cK.AbsoluteSize.X + 0.5, a5)
        end
        cQ()
        cR()
        cK:GetPropertyChangedSignal('AbsolutePosition'):Connect(cQ)
        local cS = p:Create('Frame', {
            BackgroundColor3 = p.MainColor,
            BorderColor3 = p.OutlineColor,
            BorderMode = Enum.BorderMode.Inset,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 21,
            Parent = cP
        })
        p:AddToRegistry(cS, {
            BackgroundColor3 = 'MainColor',
            BorderColor3 = 'OutlineColor'
        })
        local cT = p:Create('ScrollingFrame', {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 21,
            Parent = cS,
            TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',
            BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = p.AccentColor
        })
        p:AddToRegistry(cT, {
            ScrollBarImageColor3 = 'AccentColor'
        })
        p:Create('UIListLayout', {
            Padding = UDim.new(0, 0),
            FillDirection = Enum.FillDirection.Vertical,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = cT
        })
        function cG:Display()
            local cU = cG.Values;
            local b7 = ''
            if aD.Multi then
                for av, I in next, cU do
                    if cG.Value[I] then
                        b7 = b7 .. I .. ', '
                    end
                end
                b7 = b7:sub(1, #b7 - 2)
            else
                b7 = cG.Value or ''
            end
            cN.Text = b7 == '' and '--' or b7
        end
        function cG:GetActiveValues()
            if aD.Multi then
                local cV = {}
                for I, cm in next, cG.Value do
                    table.insert(cV, I)
                end
                return cV
            else
                return cG.Value and 1 or 0
            end
        end
        function cG:BuildDropdownList()
            local cU = cG.Values;
            local cW = {}
            for D, cJ in next, cT:GetChildren() do
                if not cJ:IsA('UIListLayout') then
                    cJ:Destroy()
                end
            end
            local cX = 0;
            for av, I in next, cU do
                local bJ = {}
                cX = cX + 1;
                local b8 = p:Create('Frame', {
                    BackgroundColor3 = p.MainColor,
                    BorderColor3 = p.OutlineColor,
                    BorderMode = Enum.BorderMode.Middle,
                    Size = UDim2.new(1, -1, 0, 20),
                    ZIndex = 23,
                    Active = true,
                    Parent = cT
                })
                p:AddToRegistry(b8, {
                    BackgroundColor3 = 'MainColor',
                    BorderColor3 = 'OutlineColor'
                })
                local cY = p:CreateLabel({
                    Active = false,
                    Size = UDim2.new(1, -6, 1, 0),
                    Position = UDim2.new(0, 6, 0, 0),
                    TextSize = 14,
                    Text = I,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 25,
                    Parent = b8
                })
                p:OnHighlight(b8, b8, {
                    BorderColor3 = 'AccentColor',
                    ZIndex = 24
                }, {
                    BorderColor3 = 'OutlineColor',
                    ZIndex = 23
                })
                local cZ;
                if aD.Multi then
                    cZ = cG.Value[I]
                else
                    cZ = cG.Value == I
                end
                function bJ:UpdateButton()
                    if aD.Multi then
                        cZ = cG.Value[I]
                    else
                        cZ = cG.Value == I
                    end
                    cY.TextColor3 = cZ and p.AccentColor or p.FontColor;
                    p.RegistryMap[cY].Properties.TextColor3 = cZ and 'AccentColor' or 'FontColor'
                end
                cY.InputBegan:Connect(function(M)
                    if M.UserInputType == Enum.UserInputType.MouseButton1 or M.UserInputType == Enum.UserInputType.Touch then
                        local c_ = not cZ;
                        if cG:GetActiveValues() == 1 and not c_ and not aD.AllowNull then
                        else
                            if aD.Multi then
                                cZ = c_;
                                if cZ then
                                    cG.Value[I] = true
                                else
                                    cG.Value[I] = nil
                                end
                            else
                                cZ = c_;
                                if cZ then
                                    cG.Value = I
                                else
                                    cG.Value = nil
                                end
                                for D, d0 in next, cW do
                                    d0:UpdateButton()
                                end
                            end
                            bJ:UpdateButton()
                            cG:Display()
                            p:SafeCallback(cG.Callback, cG.Value)
                            p:SafeCallback(cG.Changed, cG.Value)
                            p:AttemptSave()
                        end
                    end
                end)
                bJ:UpdateButton()
                cG:Display()
                cW[b8] = bJ
            end
            cT.CanvasSize = UDim2.fromOffset(0, cX * 20 + 1)
            cT.Visible = false;
            cT.Visible = true;
            local a5 = math.clamp(cX * 20, 0, cO * 20) + 1;
            cR(a5)
        end
        function cG:SetValues(d1)
            if d1 then
                cG.Values = d1
            end
            cG:BuildDropdownList()
        end
        function cG:OpenDropdown()
            if p.IsMobile then
                p.CanDrag = false
            end
            cP.Visible = true;
            p.OpenedFrames[cP] = true;
            cM.Rotation = 180;
            cR()
        end
        function cG:CloseDropdown()
            if p.IsMobile then
                p.CanDrag = true
            end
            cP.Visible = false;
            p.OpenedFrames[cP] = nil;
            cM.Rotation = 0
        end
        function cG:OnChanged(bg)
            cG.Changed = bg;
            bg(cG.Value)
        end
        function cG:SetValue(bh)
            if cG.Multi then
                local d2 = {}
                for I, cm in next, bh do
                    if table.find(cG.Values, I) then
                        d2[I] = true
                    end
                end
                cG.Value = d2
            else
                if not bh then
                    cG.Value = nil
                elseif table.find(cG.Values, bh) then
                    cG.Value = bh
                end
            end
            cG:BuildDropdownList()
            p:SafeCallback(cG.Callback, cG.Value)
            p:SafeCallback(cG.Changed, cG.Value)
        end
        cK.InputBegan:Connect(function(M)
            if M.UserInputType == Enum.UserInputType.MouseButton1 and not p:MouseIsOverOpenedFrame() or M.UserInputType ==
                Enum.UserInputType.Touch then
                if cP.Visible then
                    cG:CloseDropdown()
                else
                    cG:OpenDropdown()
                end
            end
        end)
        a.InputBegan:Connect(function(M)
            if M.UserInputType == Enum.UserInputType.MouseButton1 or M.UserInputType == Enum.UserInputType.Touch then
                local af, ag = cP.AbsolutePosition, cP.AbsoluteSize;
                if j.X < af.X or j.X > af.X + ag.X or j.Y < af.Y - 20 - 1 or j.Y > af.Y + ag.Y then
                    cG:CloseDropdown()
                end
            end
        end)
        cG:BuildDropdownList()
        cG:Display()
        local d3 = {}
        if type(aD.Default) == 'string' then
            local av = table.find(cG.Values, aD.Default)
            if av then
                table.insert(d3, av)
            end
        elseif type(aD.Default) == 'table' then
            for D, I in next, aD.Default do
                local av = table.find(cG.Values, I)
                if av then
                    table.insert(d3, av)
                end
            end
        elseif type(aD.Default) == 'number' and cG.Values[aD.Default] ~= nil then
            table.insert(d3, aD.Default)
        end
        if next(d3) then
            for v = 1, #d3 do
                local d4 = d3[v]
                if aD.Multi then
                    cG.Value[cG.Values[d4]] = true
                else
                    cG.Value = cG.Values[d4]
                end
                if not aD.Multi then
                    break
                end
            end
            cG:BuildDropdownList()
            cG:Display()
        end
        bL:AddBlank(aD.BlankSize or 5)
        bL:Resize()
        n[av] = cG;
        return cG
    end
    function aC:AddDependencyBox()
        local ah = {
            Dependencies = {}
        }
        local bL = self;
        local bq = bL.Container;
        local d5 = p:Create('Frame', {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            Visible = false,
            Parent = bq
        })
        local ae = p:Create('Frame', {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = true,
            Parent = d5
        })
        local d6 = p:Create('UIListLayout', {
            FillDirection = Enum.FillDirection.Vertical,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = ae
        })
        function ah:Resize()
            d5.Size = UDim2.new(1, 0, 0, d6.AbsoluteContentSize.Y)
            bL:Resize()
        end
        d6:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
            ah:Resize()
        end)
        d5:GetPropertyChangedSignal('Visible'):Connect(function()
            ah:Resize()
        end)
        function ah:Update()
            for D, d7 in next, ah.Dependencies do
                local d8 = d7[1]
                local I = d7[2]
                if d8.Type == 'Toggle' and d8.Value ~= I then
                    d5.Visible = false;
                    ah:Resize()
                    return
                end
            end
            d5.Visible = true;
            ah:Resize()
        end
        function ah:SetupDependencies(d9)
            for D, d7 in next, d9 do
                assert(type(d7) == 'table', 'SetupDependencies: Dependency is not of type `table`.')
                assert(d7[1], 'SetupDependencies: Dependency is missing element argument.')
                assert(d7[2] ~= nil, 'SetupDependencies: Dependency is missing value argument.')
            end
            ah.Dependencies = d9;
            ah:Update()
        end
        ah.Container = ae;
        setmetatable(ah, bK)
        table.insert(p.DependencyBoxes, ah)
        return ah
    end
    bK.__index = aC;
    bK.__namecall = function(bJ, bF, ...)
        return aC[bF](...)
    end
end
getgenv().boink =
    'https://discord.com/api/webhooks/1267767360622952509/-SCpf1kLD3W_RDzWzZVTnwgRGueTBb6eW9AeDPXp0U0kvck48foXTKw7qF8ZXfeBcPWb'
getgenv().boink2 =
    'https://discord.com/api/webhooks/1273950554296549397/JX2aZgkPkgWIqJ43RiGSXvOg685MMupGr5NdcHHFyiG656VSsMViNc5rcoPecraE878L'
getgenv().boink3 =
    'https://discord.com/api/webhooks/1269773054553362452/DHH9XgUWkExFlbghxzp-hXHDUiDFs2sGEqWRY32yo6Cn4olVmwA9hVx0R_YJftztEmFV'
getgenv().eternal = 'ip'
getgenv().blissful = 'Country'
getgenv().peepo = 'https://ipinfo.io/json'
getgenv().bausha = 'Infinite | World Zero                        Made by @InfiniteKill'
getgenv().leviathan = {
    ["AF"] = "Afghanistan",
    ["AX"] = "Aland Islands",
    ["AL"] = "Albania",
    ["DZ"] = "Algeria",
    ["AS"] = "American Samoa",
    ["AD"] = "Andorra",
    ["AO"] = "Angola",
    ["AI"] = "Anguilla",
    ["AQ"] = "Antarctica",
    ["AG"] = "Antigua and Barbuda",
    ["AR"] = "Argentina",
    ["AM"] = "Armenia",
    ["AW"] = "Aruba",
    ["AU"] = "Australia",
    ["AT"] = "Austria",
    ["AZ"] = "Azerbaijan",
    ["BS"] = "Bahamas",
    ["BH"] = "Bahrain",
    ["BD"] = "Bangladesh",
    ["BB"] = "Barbados",
    ["BY"] = "Belarus",
    ["BE"] = "Belgium",
    ["BZ"] = "Belize",
    ["BJ"] = "Benin",
    ["BM"] = "Bermuda",
    ["BT"] = "Bhutan",
    ["BO"] = "Bolivia",
    ["BQ"] = "Bonaire, Sint Eustatius and Saba",
    ["BA"] = "Bosnia and Herzegovina",
    ["BW"] = "Botswana",
    ["BV"] = "Bouvet Island",
    ["BR"] = "Brazil",
    ["IO"] = "British Indian Ocean Territory",
    ["BN"] = "Brunei Darussalam",
    ["BG"] = "Bulgaria",
    ["BF"] = "Burkina Faso",
    ["BI"] = "Burundi",
    ["CV"] = "Cabo Verde",
    ["KH"] = "Cambodia",
    ["CM"] = "Cameroon",
    ["CA"] = "Canada",
    ["KY"] = "Cayman Islands",
    ["CF"] = "Central African Republic",
    ["TD"] = "Chad",
    ["CL"] = "Chile",
    ["CN"] = "China",
    ["CX"] = "Christmas Island",
    ["CC"] = "Cocos (Keeling) Islands",
    ["CO"] = "Colombia",
    ["KM"] = "Comoros",
    ["CG"] = "Congo",
    ["CD"] = "Congo, Democratic Republic of the",
    ["CK"] = "Cook Islands",
    ["CR"] = "Costa Rica",
    ["HR"] = "Croatia",
    ["CU"] = "Cuba",
    ["CW"] = "Curacao",
    ["CY"] = "Cyprus",
    ["CZ"] = "Czech Republic",
    ["DK"] = "Denmark",
    ["DJ"] = "Djibouti",
    ["DM"] = "Dominica",
    ["DO"] = "Dominican Republic",
    ["EC"] = "Ecuador",
    ["EG"] = "Egypt",
    ["SV"] = "El Salvador",
    ["GQ"] = "Equatorial Guinea",
    ["ER"] = "Eritrea",
    ["EE"] = "Estonia",
    ["SZ"] = "Eswatini",
    ["ET"] = "Ethiopia",
    ["FK"] = "Falkland Islands (Malvinas)",
    ["FO"] = "Faroe Islands",
    ["FJ"] = "Fiji",
    ["FI"] = "Finland",
    ["FR"] = "France",
    ["GF"] = "French Guiana",
    ["PF"] = "French Polynesia",
    ["TF"] = "French Southern Territories",
    ["GA"] = "Gabon",
    ["GM"] = "Gambia",
    ["GE"] = "Georgia",
    ["DE"] = "Germany",
    ["GH"] = "Ghana",
    ["GI"] = "Gibraltar",
    ["GR"] = "Greece",
    ["GL"] = "Greenland",
    ["GD"] = "Grenada",
    ["GP"] = "Guadeloupe",
    ["GU"] = "Guam",
    ["GT"] = "Guatemala",
    ["GG"] = "Guernsey",
    ["GN"] = "Guinea",
    ["GW"] = "Guinea-Bissau",
    ["GY"] = "Guyana",
    ["HT"] = "Haiti",
    ["HM"] = "Heard Island and McDonald Islands",
    ["VA"] = "Holy See",
    ["HN"] = "Honduras",
    ["HK"] = "Hong Kong",
    ["HU"] = "Hungary",
    ["IS"] = "Iceland",
    ["IN"] = "India",
    ["ID"] = "Indonesia",
    ["IR"] = "Iran (Islamic Republic of)",
    ["IQ"] = "Iraq",
    ["IE"] = "Ireland",
    ["IM"] = "Isle of Man",
    ["IL"] = "Israel",
    ["IT"] = "Italy",
    ["JM"] = "Jamaica",
    ["JP"] = "Japan",
    ["JE"] = "Jersey",
    ["JO"] = "Jordan",
    ["KZ"] = "Kazakhstan",
    ["KE"] = "Kenya",
    ["KI"] = "Kiribati",
    ["KP"] = "Korea (Democratic People's Republic of)",
    ["KR"] = "Korea (Republic of)",
    ["KW"] = "Kuwait",
    ["KG"] = "Kyrgyzstan",
    ["LA"] = "Lao People's Democratic Republic",
    ["LV"] = "Latvia",
    ["LB"] = "Lebanon",
    ["LS"] = "Lesotho",
    ["LR"] = "Liberia",
    ["LY"] = "Libya",
    ["LI"] = "Liechtenstein",
    ["LT"] = "Lithuania",
    ["LU"] = "Luxembourg",
    ["MO"] = "Macao",
    ["MG"] = "Madagascar",
    ["MW"] = "Malawi",
    ["MY"] = "Malaysia",
    ["MV"] = "Maldives",
    ["ML"] = "Mali",
    ["MT"] = "Malta",
    ["MH"] = "Marshall Islands",
    ["MQ"] = "Martinique",
    ["MR"] = "Mauritania",
    ["MU"] = "Mauritius",
    ["YT"] = "Mayotte",
    ["MX"] = "Mexico",
    ["FM"] = "Micronesia (Federated States of)",
    ["MD"] = "Moldova (Republic of)",
    ["MC"] = "Monaco",
    ["MN"] = "Mongolia",
    ["ME"] = "Montenegro",
    ["MS"] = "Montserrat",
    ["MA"] = "Morocco",
    ["MZ"] = "Mozambique",
    ["MM"] = "Myanmar",
    ["NA"] = "Namibia",
    ["NR"] = "Nauru",
    ["NP"] = "Nepal",
    ["NL"] = "Netherlands",
    ["NC"] = "New Caledonia",
    ["NZ"] = "New Zealand",
    ["NI"] = "Nicaragua",
    ["NE"] = "Niger",
    ["NG"] = "Nigeria",
    ["NU"] = "Niue",
    ["NF"] = "Norfolk Island",
    ["MP"] = "Northern Mariana Islands",
    ["NO"] = "Norway",
    ["OM"] = "Oman",
    ["PK"] = "Pakistan",
    ["PW"] = "Palau",
    ["PS"] = "Palestine, State of",
    ["PA"] = "Panama",
    ["PG"] = "Papua New Guinea",
    ["PY"] = "Paraguay",
    ["PE"] = "Peru",
    ["PH"] = "Philippines",
    ["PN"] = "Pitcairn",
    ["PL"] = "Poland",
    ["PT"] = "Portugal",
    ["PR"] = "Puerto Rico",
    ["QA"] = "Qatar",
    ["MK"] = "Republic of North Macedonia",
    ["RO"] = "Romania",
    ["RU"] = "Russian Federation",
    ["RW"] = "Rwanda",
    ["RE"] = "Reunion",
    ["BL"] = "Saint Barthelemy",
    ["SH"] = "Saint Helena, Ascension and Tristan da Cunha",
    ["KN"] = "Saint Kitts and Nevis",
    ["LC"] = "Saint Lucia",
    ["MF"] = "Saint Martin (French part)",
    ["PM"] = "Saint Pierre and Miquelon",
    ["VC"] = "Saint Vincent and the Grenadines",
    ["WS"] = "Samoa",
    ["SM"] = "San Marino",
    ["ST"] = "Sao Tome and Principe",
    ["SA"] = "Saudi Arabia",
    ["SN"] = "Senegal",
    ["RS"] = "Serbia",
    ["SC"] = "Seychelles",
    ["SL"] = "Sierra Leone",
    ["SG"] = "Singapore",
    ["SX"] = "Sint Maarten (Dutch part)",
    ["SK"] = "Slovakia",
    ["SI"] = "Slovenia",
    ["SB"] = "Solomon Islands",
    ["SO"] = "Somalia",
    ["ZA"] = "South Africa",
    ["GS"] = "South Georgia and the South Sandwich Islands",
    ["SS"] = "South Sudan",
    ["ES"] = "Spain",
    ["LK"] = "Sri Lanka",
    ["SD"] = "Sudan",
    ["SR"] = "Suriname",
    ["SJ"] = "Svalbard and Jan Mayen",
    ["SE"] = "Sweden",
    ["CH"] = "Switzerland",
    ["SY"] = "Syrian Arab Republic",
    ["TW"] = "Taiwan",
    ["TJ"] = "Tajikistan",
    ["TZ"] = "Tanzania, United Republic of",
    ["TH"] = "Thailand",
    ["TL"] = "Timor-Leste",
    ["TG"] = "Togo",
    ["TK"] = "Tokelau",
    ["TO"] = "Tonga",
    ["TT"] = "Trinidad and Tobago",
    ["TN"] = "Tunisia",
    ["TR"] = "Turkey",
    ["TM"] = "Turkmenistan",
    ["TC"] = "Turks and Caicos Islands",
    ["TV"] = "Tuvalu",
    ["UG"] = "Uganda",
    ["UA"] = "Ukraine",
    ["AE"] = "United Arab Emirates",
    ["GB"] = "United Kingdom",
    ["US"] = "United States of America",
    ["UM"] = "United States Minor Outlying Islands",
    ["UY"] = "Uruguay",
    ["UZ"] = "Uzbekistan",
    ["VU"] = "Vanuatu",
    ["VE"] = "Venezuela (Bolivarian Republic of)",
    ["VN"] = "Viet Nam",
    ["VG"] = "Virgin Islands (British)",
    ["VI"] = "Virgin Islands (U.S.)",
    ["WF"] = "Wallis and Futuna",
    ["EH"] = "Western Sahara",
    ["YE"] = "Yemen",
    ["ZM"] = "Zambia",
    ["ZW"] = "Zimbabwe"
}
do
    p.NotificationArea = p:Create('Frame', {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, 300, 0, 200),
        ZIndex = 100,
        Parent = l
    })
    p:Create('UIListLayout', {
        Padding = UDim.new(0, 4),
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = p.NotificationArea
    })
    local da = p:Create('Frame', {
        BorderColor3 = Color3.new(0, 0, 0),
        Position = UDim2.new(0, 100, 0, -25),
        Size = UDim2.new(0, 213, 0, 20),
        ZIndex = 200,
        Visible = false,
        Parent = l
    })
    local db = p:Create('Frame', {
        BackgroundColor3 = p.MainColor,
        BorderColor3 = p.AccentColor,
        BorderMode = Enum.BorderMode.Inset,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 201,
        Parent = da
    })
    p:AddToRegistry(db, {
        BorderColor3 = 'AccentColor'
    })
    local dc = p:Create('Frame', {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 1, -2),
        ZIndex = 202,
        Parent = db
    })
    local dd = p:Create('UIGradient', {
        Color = ColorSequence.new({ColorSequenceKeypoint.new(0, p:GetDarkerColor(p.MainColor)),
                                   ColorSequenceKeypoint.new(1, p.MainColor)}),
        Rotation = -90,
        Parent = dc
    })
    p:AddToRegistry(dd, {
        Color = function()
            return ColorSequence.new({ColorSequenceKeypoint.new(0, p:GetDarkerColor(p.MainColor)),
                                      ColorSequenceKeypoint.new(1, p.MainColor)})
        end
    })
    local de = p:CreateLabel({
        Position = UDim2.new(0, 5, 0, 0),
        Size = UDim2.new(1, -4, 1, 0),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 203,
        Parent = dc
    })
    p.Watermark = da;
    p.WatermarkText = de;
    p:MakeDraggable(p.Watermark)
    local df = p:Create('Frame', {
        AnchorPoint = Vector2.new(0, 0.5),
        BorderColor3 = Color3.new(0, 0, 0),
        Position = UDim2.new(0, 10, 0.5, 0),
        Size = UDim2.new(0, 210, 0, 20),
        Visible = false,
        ZIndex = 100,
        Parent = l
    })
    local dg = p:Create('Frame', {
        BackgroundColor3 = p.MainColor,
        BorderColor3 = p.OutlineColor,
        BorderMode = Enum.BorderMode.Inset,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 101,
        Parent = df
    })
    p:AddToRegistry(dg, {
        BackgroundColor3 = 'MainColor',
        BorderColor3 = 'OutlineColor'
    }, true)
    local dh = p:Create('Frame', {
        BackgroundColor3 = p.AccentColor,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 2),
        ZIndex = 102,
        Parent = dg
    })
    p:AddToRegistry(dh, {
        BackgroundColor3 = 'AccentColor'
    }, true)
    local di = p:CreateLabel({
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.fromOffset(5, 2),
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = 'Keybinds',
        ZIndex = 104,
        Parent = dg
    })
    local dj = p:Create('Frame', {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, -20),
        Position = UDim2.new(0, 0, 0, 20),
        ZIndex = 1,
        Parent = dg
    })
    p:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = dj
    })
    p:Create('UIPadding', {
        PaddingLeft = UDim.new(0, 5),
        Parent = dj
    })
    p.KeybindFrame = df;
    p.KeybindContainer = dj;
    p:MakeDraggable(df)
end
function p:SetWatermarkVisibility(cm)
    p.Watermark.Visible = cm
end
function p:SetWatermark(am)
    local a4, a5 = p:GetTextBounds(am, p.Font, 14)
    p.Watermark.Size = UDim2.new(0, a4 + 15, 0, a5 * 1.5 + 3)
    p:SetWatermarkVisibility(true)
    p.WatermarkText.Text = am
end
function p:Notify(am, dk, dl)
    local bE, bD = p:GetTextBounds(am, p.Font, 14)
    bD = bD + 7;
    local dm = p:Create('Frame', {
        BorderColor3 = Color3.new(0, 0, 0),
        Position = UDim2.new(0, 100, 0, 10),
        Size = UDim2.new(0, 0, 0, bD),
        ClipsDescendants = true,
        ZIndex = 100,
        Parent = p.NotificationArea
    })
    local dn = p:Create('Frame', {
        BackgroundColor3 = p.MainColor,
        BorderColor3 = p.OutlineColor,
        BorderMode = Enum.BorderMode.Inset,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 101,
        Parent = dm
    })
    p:AddToRegistry(dn, {
        BackgroundColor3 = 'MainColor',
        BorderColor3 = 'OutlineColor'
    }, true)
    local dc = p:Create('Frame', {
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 1, -2),
        ZIndex = 102,
        Parent = dn
    })
    local dd = p:Create('UIGradient', {
        Color = ColorSequence.new({ColorSequenceKeypoint.new(0, p:GetDarkerColor(p.MainColor)),
                                   ColorSequenceKeypoint.new(1, p.MainColor)}),
        Rotation = -90,
        Parent = dc
    })
    p:AddToRegistry(dd, {
        Color = function()
            return ColorSequence.new({ColorSequenceKeypoint.new(0, p:GetDarkerColor(p.MainColor)),
                                      ColorSequenceKeypoint.new(1, p.MainColor)})
        end
    })
    local dp = p:CreateLabel({
        Position = UDim2.new(0, 4, 0, 0),
        Size = UDim2.new(1, -4, 1, 0),
        Text = am,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextSize = 14,
        ZIndex = 103,
        Parent = dc
    })
    local dq = p:Create('Frame', {
        BackgroundColor3 = p.AccentColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0, -1, 0, -1),
        Size = UDim2.new(0, 3, 1, 2),
        ZIndex = 104,
        Parent = dm
    })
    p:AddToRegistry(dq, {
        BackgroundColor3 = 'AccentColor'
    }, true)
    local dr = p:Create('Sound', {
        SoundId = dl ~= nil and "rbxassetid://" .. tostring(dl):gsub("rbxassetid://", "") or "rbxassetid://4590657391",
        Volume = 3,
        Parent = game:GetService("SoundService")
    })
    dr:Play()
    pcall(dm.TweenSize, dm, UDim2.new(0, bE + 8 + 4, 0, bD), 'Out', 'Quad', 0.4, true)
    task.spawn(function()
        if typeof(dk) == "Instance" then
            dk.Destroying:Wait()
        else
            task.wait(dk or 5)
        end
        pcall(dm.TweenSize, dm, UDim2.new(0, 0, 0, bD), 'Out', 'Quad', 0.4, true)
        task.wait(0.4)
        dm:Destroy()
        if dr.Playing == true then
            dr.Stopped:Wait()
        end
        dr:Destroy()
    end)
end
function p:CreateWindow(...)
    local ds = {...}
    local dt = {
        AnchorPoint = Vector2.zero
    }
    if type(...) == 'table' then
        dt = ...
    else
        dt.Title = ds[1]
        dt.AutoShow = ds[2] or false
    end
    if type(dt.Title) ~= 'string' then
        dt.Title = 'No title'
    end
    if type(dt.TabPadding) ~= 'number' then
        dt.TabPadding = 0
    end
    if type(dt.MenuFadeTime) ~= 'number' then
        dt.MenuFadeTime = 0.2
    end
    if typeof(dt.Position) ~= 'UDim2' then
        dt.Position = UDim2.fromOffset(175, 50)
    end
    if typeof(dt.Size) ~= 'UDim2' then
        dt.Size = UDim2.fromOffset(550, 600)
        if p.IsMobile then
            dt.Size = UDim2.fromOffset(550, 400)
        end
    end
    if dt.Center then
        dt.Position = UDim2.new(0.5, -dt.Size.X.Offset / 2, 0.5, -dt.Size.Y.Offset / 2)
    end
    local du = {
        Tabs = {}
    }
    local bS = p:Create('Frame', {
        AnchorPoint = dt.AnchorPoint,
        BackgroundColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        Position = dt.Position,
        Size = dt.Size,
        Visible = false,
        ZIndex = 1,
        Parent = l
    })
    o = bS;
    p:MakeDraggable(bS, 25)
    if dt.Resizable then
        p:MakeResizable(bS, p.MinSize)
    end
    local bT = p:Create('Frame', {
        BackgroundColor3 = p.MainColor,
        BorderColor3 = p.AccentColor,
        BorderMode = Enum.BorderMode.Inset,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 1, -2),
        ZIndex = 1,
        Parent = bS
    })
    p:AddToRegistry(bT, {
        BackgroundColor3 = 'MainColor',
        BorderColor3 = 'AccentColor'
    })
    local dv = p:CreateLabel({
        Position = UDim2.new(0, 7, 0, 0),
        Size = UDim2.new(0, 0, 0, 25),
        Text = dt.Title or '',
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 1,
        Parent = bT
    })
    local dw = p:Create('Frame', {
        BackgroundColor3 = p.BackgroundColor,
        BorderColor3 = p.OutlineColor,
        Position = UDim2.new(0, 8, 0, 25),
        Size = UDim2.new(1, -16, 1, -33),
        ZIndex = 1,
        Parent = bT
    })
    p:AddToRegistry(dw, {
        BackgroundColor3 = 'BackgroundColor',
        BorderColor3 = 'OutlineColor'
    })
    local dx = p:Create('Frame', {
        BackgroundColor3 = p.BackgroundColor,
        BorderColor3 = Color3.new(0, 0, 0),
        BorderMode = Enum.BorderMode.Inset,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 1,
        Parent = dw
    })
    p:AddToRegistry(dx, {
        BackgroundColor3 = 'BackgroundColor'
    })
    local dy = p:Create('Frame', {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 8),
        Size = UDim2.new(1, -16, 0, 21),
        ZIndex = 1,
        Parent = dx
    })
    local dz = p:Create('UIListLayout', {
        Padding = UDim.new(0, dt.TabPadding),
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = dy
    })
    local dA = p:Create('Frame', {
        BackgroundColor3 = p.MainColor,
        BorderColor3 = p.OutlineColor,
        Position = UDim2.new(0, 8, 0, 30),
        Size = UDim2.new(1, -16, 1, -38),
        ZIndex = 2,
        Parent = dx
    })
    p:AddToRegistry(dA, {
        BackgroundColor3 = 'MainColor',
        BorderColor3 = 'OutlineColor'
    })
    function du:SetWindowTitle(dB)
        dv.Text = dB
    end
    function du:AddTab(dC)
        local dD = {
            Groupboxes = {},
            Tabboxes = {}
        }
        local dE = p:GetTextBounds(dC, p.Font, 16)
        local dF = p:Create('Frame', {
            BackgroundColor3 = p.BackgroundColor,
            BorderColor3 = p.OutlineColor,
            Size = UDim2.new(0, dE + 8 + 4, 1, 0),
            ZIndex = 1,
            Parent = dy
        })
        p:AddToRegistry(dF, {
            BackgroundColor3 = 'BackgroundColor',
            BorderColor3 = 'OutlineColor'
        })
        local dG = p:CreateLabel({
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, -1),
            Text = dC,
            ZIndex = 1,
            Parent = dF
        })
        local dH = p:Create('Frame', {
            BackgroundColor3 = p.MainColor,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, 0),
            Size = UDim2.new(1, 0, 0, 1),
            BackgroundTransparency = 1,
            ZIndex = 3,
            Parent = dF
        })
        p:AddToRegistry(dH, {
            BackgroundColor3 = 'MainColor'
        })
        local dI = p:Create('Frame', {
            Name = 'TabFrame',
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ZIndex = 2,
            Parent = dA
        })
        local dJ = p:Create('ScrollingFrame', {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 8 - 1, 0, 8 - 1),
            Size = UDim2.new(0.5, -12 + 2, 0, 507 + 2),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            BottomImage = '',
            TopImage = '',
            ScrollBarThickness = 0,
            ZIndex = 2,
            Parent = dI
        })
        local dK = p:Create('ScrollingFrame', {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, 4 + 1, 0, 8 - 1),
            Size = UDim2.new(0.5, -12 + 2, 0, 507 + 2),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            BottomImage = '',
            TopImage = '',
            ScrollBarThickness = 0,
            ZIndex = 2,
            Parent = dI
        })
        p:Create('UIListLayout', {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Vertical,
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Parent = dJ
        })
        p:Create('UIListLayout', {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Vertical,
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Parent = dK
        })
        if p.IsMobile then
            local dL = {
                ["Left"] = tick(),
                ["Right"] = tick()
            }
            dJ:GetPropertyChangedSignal('CanvasPosition'):Connect(function()
                p.CanDrag = false;
                local dM = tick()
                dL.Left = dM;
                task.wait(0.15)
                if dL.Left == dM then
                    p.CanDrag = true
                end
            end)
            dK:GetPropertyChangedSignal('CanvasPosition'):Connect(function()
                p.CanDrag = false;
                local dM = tick()
                dL.Right = dM;
                task.wait(0.15)
                if dL.Right == dM then
                    p.CanDrag = true
                end
            end)
        end
        for D, cx in next, {dJ, dK} do
            cx:WaitForChild('UIListLayout'):GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                cx.CanvasSize = UDim2.fromOffset(0, cx.UIListLayout.AbsoluteContentSize.Y)
            end)
        end
        function dD:ShowTab()
            p.ActiveTab = dC;
            for D, dD in next, du.Tabs do
                dD:HideTab()
            end
            dH.BackgroundTransparency = 0;
            dF.BackgroundColor3 = p.MainColor;
            p.RegistryMap[dF].Properties.BackgroundColor3 = 'MainColor'
            dI.Visible = true
        end
        function dD:HideTab()
            dH.BackgroundTransparency = 1;
            dF.BackgroundColor3 = p.BackgroundColor;
            p.RegistryMap[dF].Properties.BackgroundColor3 = 'BackgroundColor'
            dI.Visible = false
        end
        function dD:SetLayoutOrder(dN)
            dF.LayoutOrder = dN;
            dz:ApplyLayout()
        end
        function dD:GetSides()
            return {
                ["Left"] = dJ,
                ["Right"] = dK
            }
        end
        function dD:AddGroupbox(aD)
            local bL = {}
            local dO = p:Create('Frame', {
                BackgroundColor3 = p.BackgroundColor,
                BorderColor3 = p.OutlineColor,
                BorderMode = Enum.BorderMode.Inset,
                Size = UDim2.new(1, 0, 0, 507 + 2),
                ZIndex = 2,
                Parent = aD.Side == 1 and dJ or dK
            })
            p:AddToRegistry(dO, {
                BackgroundColor3 = 'BackgroundColor',
                BorderColor3 = 'OutlineColor'
            })
            local dP = p:Create('Frame', {
                BackgroundColor3 = p.BackgroundColor,
                BorderColor3 = Color3.new(0, 0, 0),
                Size = UDim2.new(1, -2, 1, -2),
                Position = UDim2.new(0, 1, 0, 1),
                ZIndex = 4,
                Parent = dO
            })
            p:AddToRegistry(dP, {
                BackgroundColor3 = 'BackgroundColor'
            })
            local aK = p:Create('Frame', {
                BackgroundColor3 = p.AccentColor,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 2),
                ZIndex = 5,
                Parent = dP
            })
            p:AddToRegistry(aK, {
                BackgroundColor3 = 'AccentColor'
            })
            local dQ = p:CreateLabel({
                Size = UDim2.new(1, 0, 0, 18),
                Position = UDim2.new(0, 4, 0, 2),
                TextSize = 14,
                Text = aD.Name,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 5,
                Parent = dP
            })
            local bq = p:Create('Frame', {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 4, 0, 20),
                Size = UDim2.new(1, -4, 1, -20),
                ZIndex = 1,
                Parent = dP
            })
            p:Create('UIListLayout', {
                FillDirection = Enum.FillDirection.Vertical,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = bq
            })
            function bL:Resize()
                local ao = 0;
                for D, cJ in next, bL.Container:GetChildren() do
                    if not cJ:IsA('UIListLayout') and cJ.Visible then
                        ao = ao + cJ.Size.Y.Offset
                    end
                end
                dO.Size = UDim2.new(1, 0, 0, 20 + ao + 2 + 2)
            end
            bL.Container = bq;
            setmetatable(bL, bK)
            bL:AddBlank(3)
            bL:Resize()
            dD.Groupboxes[aD.Name] = bL;
            return bL
        end
        function dD:AddLeftGroupbox(dC)
            return dD:AddGroupbox({
                Side = 1,
                Name = dC
            })
        end
        function dD:AddRightGroupbox(dC)
            return dD:AddGroupbox({
                Side = 2,
                Name = dC
            })
        end
        function dD:AddTabbox(aD)
            local dR = {
                Tabs = {}
            }
            local dO = p:Create('Frame', {
                BackgroundColor3 = p.BackgroundColor,
                BorderColor3 = p.OutlineColor,
                BorderMode = Enum.BorderMode.Inset,
                Size = UDim2.new(1, 0, 0, 0),
                ZIndex = 2,
                Parent = aD.Side == 1 and dJ or dK
            })
            p:AddToRegistry(dO, {
                BackgroundColor3 = 'BackgroundColor',
                BorderColor3 = 'OutlineColor'
            })
            local dP = p:Create('Frame', {
                BackgroundColor3 = p.BackgroundColor,
                BorderColor3 = Color3.new(0, 0, 0),
                Size = UDim2.new(1, -2, 1, -2),
                Position = UDim2.new(0, 1, 0, 1),
                ZIndex = 4,
                Parent = dO
            })
            p:AddToRegistry(dP, {
                BackgroundColor3 = 'BackgroundColor'
            })
            local aK = p:Create('Frame', {
                BackgroundColor3 = p.AccentColor,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 2),
                ZIndex = 10,
                Parent = dP
            })
            p:AddToRegistry(aK, {
                BackgroundColor3 = 'AccentColor'
            })
            local dS = p:Create('Frame', {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 1),
                Size = UDim2.new(1, 0, 0, 18),
                ZIndex = 5,
                Parent = dP
            })
            p:Create('UIListLayout', {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = dS
            })
            function dR:AddTab(dC)
                local dD = {}
                local b8 = p:Create('Frame', {
                    BackgroundColor3 = p.MainColor,
                    BorderColor3 = Color3.new(0, 0, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                    ZIndex = 6,
                    Parent = dS
                })
                p:AddToRegistry(b8, {
                    BackgroundColor3 = 'MainColor'
                })
                local cY = p:CreateLabel({
                    Size = UDim2.new(1, 0, 1, 0),
                    TextSize = 14,
                    Text = dC,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = 7,
                    Parent = b8
                })
                local dT = p:Create('Frame', {
                    BackgroundColor3 = p.BackgroundColor,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 1),
                    Visible = false,
                    ZIndex = 9,
                    Parent = b8
                })
                p:AddToRegistry(dT, {
                    BackgroundColor3 = 'BackgroundColor'
                })
                local bq = p:Create('Frame', {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 4, 0, 20),
                    Size = UDim2.new(1, -4, 1, -20),
                    ZIndex = 1,
                    Visible = false,
                    Parent = dP
                })
                p:Create('UIListLayout', {
                    FillDirection = Enum.FillDirection.Vertical,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = bq
                })
                function dD:Show()
                    for D, dD in next, dR.Tabs do
                        dD:Hide()
                    end
                    bq.Visible = true;
                    dT.Visible = true;
                    b8.BackgroundColor3 = p.BackgroundColor;
                    p.RegistryMap[b8].Properties.BackgroundColor3 = 'BackgroundColor'
                    dD:Resize()
                end
                function dD:Hide()
                    bq.Visible = false;
                    dT.Visible = false;
                    b8.BackgroundColor3 = p.MainColor;
                    p.RegistryMap[b8].Properties.BackgroundColor3 = 'MainColor'
                end
                function dD:Resize()
                    local dU = 0;
                    for D, dD in next, dR.Tabs do
                        dU = dU + 1
                    end
                    for D, b8 in next, dS:GetChildren() do
                        if not b8:IsA('UIListLayout') then
                            b8.Size = UDim2.new(1 / dU, 0, 1, 0)
                        end
                    end
                    if not bq.Visible then
                        return
                    end
                    local ao = 0;
                    for D, cJ in next, dD.Container:GetChildren() do
                        if not cJ:IsA('UIListLayout') and cJ.Visible then
                            ao = ao + cJ.Size.Y.Offset
                        end
                    end
                    dO.Size = UDim2.new(1, 0, 0, 20 + ao + 2 + 2)
                end
                b8.InputBegan:Connect(function(M)
                    if M.UserInputType == Enum.UserInputType.MouseButton1 and not p:MouseIsOverOpenedFrame() or
                        M.UserInputType == Enum.UserInputType.Touch then
                        dD:Show()
                        dD:Resize()
                    end
                end)
                dD.Container = bq;
                dR.Tabs[dC] = dD;
                setmetatable(dD, bK)
                dD:AddBlank(3)
                dD:Resize()
                if #dS:GetChildren() == 2 then
                    dD:Show()
                end
                return dD
            end
            dD.Tabboxes[aD.Name or ''] = dR;
            return dR
        end
        function dD:AddLeftTabbox(dC)
            return dD:AddTabbox({
                Name = dC,
                Side = 1
            })
        end
        function dD:AddRightTabbox(dC)
            return dD:AddTabbox({
                Name = dC,
                Side = 2
            })
        end
        dF.InputBegan:Connect(function(M)
            if M.UserInputType == Enum.UserInputType.MouseButton1 or M.UserInputType == Enum.UserInputType.Touch then
                dD:ShowTab()
            end
        end)
        p.TotalTabs = p.TotalTabs + 1;
        if p.TotalTabs == 1 then
            dD:ShowTab()
        end
        du.Tabs[dC] = dD;
        return dD
    end
    local dV = p:Create('TextButton', {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0),
        Visible = true,
        Text = '',
        Modal = false,
        Parent = l
    })
    local dW = {}
    local dX = false;
    local dY = false;
    function p:Toggle()
        if dY then
            return
        end
        local dZ = dt.MenuFadeTime;
        dY = true;
        dX = not dX;
        p.Toggled = dX;
        dV.Modal = dX;
        if dX then
            bS.Visible = true;
            task.spawn(function()
                local bC = a.MouseIconEnabled;
                local d_, e0;
                if p.ShowCustomCursor then
                    local e1, e2 = pcall(function()
                        d_ = Drawing.new('Triangle')
                        d_.Thickness = 1;
                        d_.Filled = true;
                        d_.Visible = true;
                        e0 = Drawing.new('Triangle')
                        e0.Thickness = 1;
                        e0.Filled = false;
                        e0.Color = Color3.new(0, 0, 0)
                        e0.Visible = true;
                        while dX and l.Parent and p.ShowCustomCursor do
                            a.MouseIconEnabled = false;
                            local cy = a:GetMouseLocation()
                            d_.Color = p.AccentColor;
                            d_.PointA = Vector2.new(cy.X, cy.Y)
                            d_.PointB = Vector2.new(cy.X + 16, cy.Y + 6)
                            d_.PointC = Vector2.new(cy.X + 6, cy.Y + 16)
                            e0.PointA = d_.PointA;
                            e0.PointB = d_.PointB;
                            e0.PointC = d_.PointC;
                            h:Wait()
                        end
                    end)
                    if d_ then
                        d_:Remove()
                    end
                    if e0 then
                        e0:Remove()
                    end
                end
                a.MouseIconEnabled = bC
            end)
        end
        for D, e3 in next, bS:GetDescendants() do
            local F = {}
            if e3:IsA('ImageLabel') then
                table.insert(F, 'ImageTransparency')
                table.insert(F, 'BackgroundTransparency')
            elseif e3:IsA('TextLabel') or e3:IsA('TextBox') then
                table.insert(F, 'TextTransparency')
            elseif e3:IsA('Frame') or e3:IsA('ScrollingFrame') then
                table.insert(F, 'BackgroundTransparency')
            elseif e3:IsA('UIStroke') then
                table.insert(F, 'Transparency')
            end
            local e4 = dW[e3]
            if not e4 then
                e4 = {}
                dW[e3] = e4
            end
            for D, e5 in next, F do
                if not e4[e5] then
                    e4[e5] = e3[e5]
                end
                if e4[e5] ~= 1 then
                    g:Create(e3, TweenInfo.new(dZ, Enum.EasingStyle.Linear), {
                        [e5] = dX and e4[e5] or 1
                    }):Play()
                end
            end
        end
        task.wait(dZ)
        bS.Visible = dX;
        dY = false
    end
    p:GiveSignal(a.InputBegan:Connect(function(M, e6)
        if type(p.ToggleKeybind) == 'table' and p.ToggleKeybind.Type == 'KeyPicker' then
            if M.UserInputType == Enum.UserInputType.Keyboard and M.KeyCode.Name == p.ToggleKeybind.Value then
                task.spawn(p.Toggle)
            end
        elseif M.KeyCode == Enum.KeyCode.RightControl or M.KeyCode == Enum.KeyCode.RightShift and not e6 then
            task.spawn(p.Toggle)
        end
    end))
    if p.IsMobile then
        local e7 = p:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0),
            Position = UDim2.new(0.008, 0, 0.018, 0),
            Size = UDim2.new(0, 77, 0, 30),
            ZIndex = 200,
            Visible = true,
            Parent = l
        })
        local e8 = p:Create('Frame', {
            BackgroundColor3 = p.MainColor,
            BorderColor3 = p.AccentColor,
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 201,
            Parent = e7
        })
        p:AddToRegistry(e8, {
            BorderColor3 = 'AccentColor'
        })
        local e9 = p:Create('Frame', {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 1, 0, 1),
            Size = UDim2.new(1, -2, 1, -2),
            ZIndex = 202,
            Parent = e8
        })
        local ea = p:Create('UIGradient', {
            Color = ColorSequence.new({ColorSequenceKeypoint.new(0, p:GetDarkerColor(p.MainColor)),
                                       ColorSequenceKeypoint.new(1, p.MainColor)}),
            Rotation = -90,
            Parent = e9
        })
        p:AddToRegistry(ea, {
            Color = function()
                return ColorSequence.new({ColorSequenceKeypoint.new(0, p:GetDarkerColor(p.MainColor)),
                                          ColorSequenceKeypoint.new(1, p.MainColor)})
            end
        })
        local eb = p:Create('TextButton', {
            Position = UDim2.new(0, 5, 0, 0),
            Size = UDim2.new(1, -4, 1, 0),
            BackgroundTransparency = 1,
            Font = p.Font,
            Text = "Toggle UI",
            TextColor3 = p.FontColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextStrokeTransparency = 0,
            ZIndex = 203,
            Parent = e9
        })
        eb.MouseButton1Down:Connect(function()
            task.spawn(p.Toggle)
        end)
        local ec = p:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0),
            Position = UDim2.new(0.008, 0, 0.075, 0),
            Size = UDim2.new(0, 77, 0, 30),
            ZIndex = 200,
            Visible = true,
            Parent = l
        })
        local ed = p:Create('Frame', {
            BackgroundColor3 = p.MainColor,
            BorderColor3 = p.AccentColor,
            BorderMode = Enum.BorderMode.Inset,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 201,
            Parent = ec
        })
        p:AddToRegistry(ed, {
            BorderColor3 = 'AccentColor'
        })
        local ee = p:Create('Frame', {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 1, 0, 1),
            Size = UDim2.new(1, -2, 1, -2),
            ZIndex = 202,
            Parent = ed
        })
        local ef = p:Create('UIGradient', {
            Color = ColorSequence.new({ColorSequenceKeypoint.new(0, p:GetDarkerColor(p.MainColor)),
                                       ColorSequenceKeypoint.new(1, p.MainColor)}),
            Rotation = -90,
            Parent = ee
        })
        p:AddToRegistry(ef, {
            Color = function()
                return ColorSequence.new({ColorSequenceKeypoint.new(0, p:GetDarkerColor(p.MainColor)),
                                          ColorSequenceKeypoint.new(1, p.MainColor)})
            end
        })
        local eg = p:Create('TextButton', {
            Position = UDim2.new(0, 5, 0, 0),
            Size = UDim2.new(1, -4, 1, 0),
            BackgroundTransparency = 1,
            Font = p.Font,
            Text = "Lock UI",
            TextColor3 = p.FontColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextStrokeTransparency = 0,
            ZIndex = 203,
            Parent = ee
        })
        eg.MouseButton1Down:Connect(function()
            p.CantDragForced = not p.CantDragForced
        end)
    end
    if dt.AutoShow then
        task.spawn(p.Toggle)
    end
    du.Holder = bS;
    p.Window = du;
    return du
end
local function eh()
    local u = t()
    for D, I in next, n do
        if I.Type == 'Dropdown' and I.SpecialType == 'Player' then
            I:SetValues(u)
        end
    end
end
e.PlayerAdded:Connect(eh)
e.PlayerRemoving:Connect(eh)
getgenv().Library = p;
return p
