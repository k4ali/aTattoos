local SettingsButton = {
    Text = { X = 13, Y = 10, Scale = 0.32 },
    Rectangle = { Y = 1, Width = 30, Height = 19 },
}

---@public
function RageUI.Line()
    local CurrentMenu = RageUI.CurrentMenu
    local Description = RageUI.Settings.Items.Description;
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            local Option = RageUI.Options + 1
            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
                RenderRectangle(CurrentMenu.X + Description.Bar.Y + 85 + CurrentMenu.SubtitleHeight, CurrentMenu.Y + Description.Bar.Y + 6.0 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Description.Bar.Width - 180 + CurrentMenu.WidthOffset, Description.Bar.Height - 3.5, 255, 255, 255, 160)
                RageUI.ItemOffset = RageUI.ItemOffset + SettingsButton.Rectangle.Height + Description.Bar.Height 
                if (CurrentMenu.Index == Option) then
                    if (RageUI.LastControl) then
                        CurrentMenu.Index = Option - 0
                        if (CurrentMenu.Index < 0) then
                            CurrentMenu.Index = RageUI.CurrentMenu.Options
                        end
                    else
                        CurrentMenu.Index = Option + 0
                    end
                end
            end
            RageUI.Options = RageUI.Options + 0
        end
    end
end