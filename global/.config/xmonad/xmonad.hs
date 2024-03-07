{-# LANGUAGE LambdaCase #-}
-- =========================================== --
--  ______     ______     ______     __        --
-- /\  ___\   /\  ___\   /\  __ \   /\ \       --
-- \ \  __\   \ \ \____  \ \  __ \  \ \ \____  --
--  \ \_____\  \ \_____\  \ \_\ \_\  \ \_____\ --
--   \/_____/   \/_____/   \/_/\/_/   \/_____/ --
--                                             --
-- =========================================== --

--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------
    -- Base
import XMonad hiding ( (|||) )
import System.Exit
import XMonad.ManageHook
import XMonad.Operations
import Control.Monad
import Data.List (isInfixOf)
import Control.Concurrent (threadDelay)
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.WithAll (killAll)
import XMonad.Actions.WindowNavigation
import XMonad.Actions.GroupNavigation
import XMonad.Actions.CycleWS
import XMonad.Actions.Minimize
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.OnScreen
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Monoid
import Data.Ratio
import Data.Word (Word32)
import qualified Data.Map as M

    -- Hooks
-- import XMonad.Hooks.FadeInactive
import XMonad.Hooks.FadeWindows
import XMonad.Hooks.Place
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Minimize
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicProperty
import XMonad.Hooks.SetWMName
import XMonad.Hooks.InsertPosition

    -- Layouts
import XMonad.Layout hiding ( (|||) )
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.Named
import XMonad.Layout.Accordion
import XMonad.Layout.Spiral
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.WindowArranger
import XMonad.Layout.ResizableTile
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Simplest
import XMonad.Layout.SimplestFloat
import XMonad.Layout.SubLayouts
import XMonad.Layout.Renamed
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.Minimize
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Column
import XMonad.Layout.ToggleLayouts
import qualified XMonad.Layout.BoringWindows as BW
import XMonad.Layout.Gaps
    ( Direction2D(D, L, R, U),
      gaps,
      setGaps,
      GapMessage(DecGap, ToggleGaps, IncGap) )

    -- Utils
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad
import XMonad.Util.WorkspaceCompare
import XMonad.Util.WindowProperties (getProp32s)

    -- DBus
import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

--------------------------------------------------------------------------------
-- Variables
--------------------------------------------------------------------------------
    -- Modkey
myModMask :: KeyMask
myModMask = mod4Mask -- Windows key

    -- Alt Mask
altMask :: KeyMask
altMask = mod1Mask

    -- Terminal
myTerminal :: String
myTerminal = "kitty"

    -- Editor
myEditor :: String
myEditor = "nvim"

    -- Browser
mainBrowser = "firefox"
altBrowser = "microsoft-edge-dev"
altBrowserClass = "Microsoft-edge-dev"

    -- Border
myBorderWidth :: Dimension
myBorderWidth = 0
myBorderColor = "#272A29"
myFocusColor = "#4ec9b0"

focusMouse = True

--------------------------------------------------------------------------------
-- Workspaces
--------------------------------------------------------------------------------
myExtraWorkspaces = ["NSP"]
myWorkspaces = map show [1..8] ++ myExtraWorkspaces

getSortByIndexNoNSP = fmap (. filter (\(W.Workspace tag _ _) -> not (tag `elem` myExtraWorkspaces))) getSortByIndex

--------------------------------------------------------------------------------
-- Layouts
--------------------------------------------------------------------------------
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw
                True -- smart border
                     -- T B R L
                (Border 0 i i i) False -- screen border
                (Border i i i i) True -- window border

horizontal  = renamed [Replace "horizontal"]
            $ smartBorders
            $ minimize . BW.boringWindows
            $ mouseResize
            $ mySpacing 5
        -- params: windows in master, increment on resize, proportion for master
            $ ResizableTall 1 (1/100) (1/2) []
full    = renamed [Replace "full"]
            $ noBorders Full
vertical  = renamed [Replace "vertical"]
            $ smartBorders
            $ minimize . BW.boringWindows
            $ mouseResize
            $ mySpacing 5
            $ Column 1.6

-- Not using
accordion = renamed [Replace "Accordion"]
            $ Accordion
cols  = renamed [Replace "cols"]
            $ smartBorders
            $ mySpacing 5
            $ minimize . BW.boringWindows
            $ ThreeCol 1 (3/100) (3/7)
spirals  = renamed [Replace "Spiral"]
            $ smartBorders
            $ minimize . BW.boringWindows
            $ mySpacing 5
            $ spiral (6/7)

myLayouts =
    toggleLayouts full horizontal |||
    toggleLayouts full vertical |||
    toggleLayouts full cols
    -- named "horizontal" horizontal |||
    -- named "full" full |||
    -- named "vertical" vertical |||
    -- named "cols" cols

myLayoutHook = avoidStruts $ windowArrange $ gaps [(L,0), (R,0), (U,0), (D,0)]
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myLayouts

--------------------------------------------------------------------------------
-- Manage Hook
--------------------------------------------------------------------------------
myManageHook :: ManageHook
myManageHook = composeAll
    [resource  =? "desktop_window"  --> doIgnore

    -- float
    , role      =? "pop-up"         --> doFloat -- most popups
    , role      =? "AlarmWindow"    --> doFloat -- thunderbird calendar
    , role      =? "GtkFileChooserDialog" --> doFloat
    , className =? "MATLAB R2020b - academic use" --> doFloat
    , className =? "Nemo"           --> doFloat
    , className =? "Nitrogen"       --> doFloat
    , className =? "flameshot"      --> doFloat
    -- , className =? "zoom "           --> doFloat
    , className =? "uk-org-jape-Jape" --> doFloat

    -- shift to workspace
    , className =? "ClickUp"        --> doShift "2"
    , className =? "Slack"          --> doShift "4"
    , className =? "discord"        --> doShift "4"
    , className =? "Microsoft Teams - Preview" --> doShift "4"
    , className =? "thunderbird"    --> doShift "5"
    , className =? "barrier"        --> doShift "5"
    , className =? "Spotify"        --> doShift "6"
    , className =? "zoom "           --> doShift "7"
    , manageDocks
    ]
  where
    role = stringProperty "WM_WINDOW_ROLE"

--------------------------------------------------------------------------------
-- Event Hooks
--------------------------------------------------------------------------------
-- bring clicked floating window to the front
clickFocusFloatHook :: Event -> X All
clickFocusFloatHook ButtonEvent { ev_window = w } = do
    withWindowSet $ \s -> do
        if isFloat w s
           then (focus w >> promote)
           else return ()
        return (All True)
        where isFloat w ss = M.member w $ W.floating ss
clickFocusFloatHook _ = return (All True)

--------------------------------------------------------------------------------
-- Startup Hook
--------------------------------------------------------------------------------
myStartupHook :: X ()
myStartupHook = do
    spawnOnce "startup"
    setWMName "LG3D"
    -- swap left and right monitors
    windows (greedyViewOnScreen 2 "2")
    windows (greedyViewOnScreen 1 "3")
    windows (greedyViewOnScreen 0 "1")

--------------------------------------------------------------------------------
-- Scratchpads
--------------------------------------------------------------------------------
myScratchPads :: [NamedScratchpad]
myScratchPads = [
                    NS "terminal" spawnTerm findTerm manageScratchpad,
                    NS "ask" spawnAsk findAsk manageScratchpadSmall,
                    NS "browser" spawnBrowser findBrowser manageScratchpad
                ]
                    where
                        spawnTerm = myTerminal ++ " --title scratch"
                        findTerm = title =? "scratch"

                        spawnAsk= myTerminal ++ " --title ask"
                        findAsk = title =? "ask"

                        spawnBrowser = altBrowser
                        findBrowser = className =? altBrowserClass

                        -- % from left, % from top, width, height
                        manageScratchpad = customFloating $ W.RationalRect l t w h
                            where
                                l = 0.95 - w -- offset from left
                                t = 0.95 - h -- offset from top
                                w = 0.9 -- width
                                h = 0.9 -- height

                        manageScratchpadSmall = customFloating $ W.RationalRect l t w h
                            where
                                l = 0.90 - w -- offset from left
                                t = 0.90 - h -- offset from top
                                w = 0.8 -- width
                                h = 0.8 -- height



--------------------------------------------------------------------------------
-- Mouse Bindings
--------------------------------------------------------------------------------
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    -- scroll up
    , ((modm, button4), (\w -> spawn "volume up"))
    -- scroll down
    , ((modm, button5), (\w -> spawn "volume down"))
    -- click to raise
    -- , ((0, button1), (\w -> focus w >> do
    --  { floats <- gets (W.floating . windowset);
    --      if w `M.member` floats
    --      then (focus w >> promote)
    --      else return ()
    --  }
    -- ))
    ]

--------------------------------------------------------------------------------
-- Keybindings
--------------------------------------------------------------------------------
myKeys :: [(String, X())]
myKeys = [
    -- Launch Programs
    ("M-<Return>", spawn myTerminal)
    , ("M-S-<Return>", spawn "rofi -show drun -config $HOME/.config/rofi/main.rasi")
    , ("M-e", spawn "nemo")
    , ("M-w", spawn mainBrowser)
    , ("M-S-g", spawn (mainBrowser ++ " https://github.com/e-cal"))
    , ("M-S-d", spawn "inkscape $HOME/sketch.svg")
    , ("M-S-p", spawn "pass -l")
    , ("M-b", spawn "bt menu")
    , ("M-s", spawn "focus-spotify")
    -- , ("M-<Esc> <Return>", spawn "$HOME/.config/polybar/scripts/powermenu")
    , ("M-<Esc> <Return>", spawn "$HOME/.config/eww/dashboard/launch_dashboard")
    , ("M-S-s", spawn "flameshot gui")
    , ("M1-S-s", spawn "flameshot full -p ~/Dropbox/images/screenshots/")
    , ("M-S-m", spawn "thunderbird")
    , ("M-S-t", spawn "launch-comm")
    , ("M-S-n", spawn "obsidian")
    , ("M-;", spawn "setxkbmap us")
    , ("M-S-c", spawn "colorpicker")
    , ("M-t", spawn "picom-trans -c -d")

    -- Scratchpads
    , ("M-\\", namedScratchpadAction myScratchPads "terminal")
    , ("M-/", namedScratchpadAction myScratchPads "ask")
    , ("M-S-\\", namedScratchpadAction myScratchPads "browser")
    -- , ("M-/", spawn "browser-scratchpad")

    -- Kill Windows
    , ("M-q", kill) -- Focused window
    , ("M-S-q", killAll) -- Kill all windows

    -- Gaps / Spacing
    , ("M-g g", sequence_[
        sendMessage $ setGaps [(L,40), (R,40), (U,20), (D,40)],
        setWindowSpacing (Border 20 20 20 20)
        ])
    , ("M-g r", sequence_[
        sendMessage $ setGaps [(L,0), (R,0), (U,0), (D,0)],
        setWindowSpacing (Border 5 5 5 5)
        ])

    -- Window Management
    -- tiled
    , ("M-C-<Down>", sequence_[sendMessage DeArrange, withFocused $ windows . W.sink]) -- Tile Mode
    , ("M-S-h", sendMessage Shrink)
    , ("M-S-l", sendMessage Expand)
    , ("M-S-j", sendMessage MirrorShrink)
    , ("M-S-k", sendMessage MirrorExpand)
    , ("M-,", sendMessage (IncMasterN 1))
    , ("M-.", sendMessage (IncMasterN (-1)))
    , ("M--", withFocused minimizeWindow)
    , ("M-$", withLastMinimized maximizeWindowAndFocus)
    , ("M-M1-\\", nextMatch History (return True))

    , ("M-f", withFocused toggleFloat)
    , ("M-C-f", sequence_[broadcastMessage $ ToggleStruts, refresh, spawn "polybar-toggle"])
    , ("M-M1-f", sequence_[broadcastMessage $ ToggleStruts, refresh, spawn "polybar-msg cmd toggle", broadcastMessage $ ToggleStruts, refresh, spawn "polybar-msg cmd toggle"])
    , ("M-S-f", sendMessage ToggleLayout)

    -- floating
    , ("M-C-<Up>", sendMessage Arrange)
    , ("M-<Up>", sendMessage (MoveUp 20))
    , ("M-<Down>", sendMessage (MoveDown 20))
    , ("M-<Left>", sendMessage (MoveLeft 20))
    , ("M-<Right>", sendMessage (MoveRight 20))
    , ("M-S-<Up>", sendMessage (IncreaseUp 20))
    , ("M-S-<Down>", sendMessage (IncreaseDown 20))
    , ("M-S-<Left>", sendMessage (IncreaseLeft 20))
    , ("M-S-<Right>", sendMessage (IncreaseRight 20))
    , ("M-M1-<Up>", sendMessage (DecreaseUp 20))
    , ("M-M1-<Down>", sendMessage (DecreaseDown 20))
    , ("M-M1-<Left>", sendMessage (DecreaseLeft 20))
    , ("M-M1-<Right>", sendMessage (DecreaseRight 20))

    -- XMonad
    , ("C-M1-<Delete>", io (exitWith ExitSuccess))
    , ("M-S-r", sequence_[spawn "xmonad --recompile; xmonad --restart", spawn "$HOME/.config/polybar/launch.sh"])

    -- Function Keys
    , ("<XF86AudioMute>", spawn "volume mute")
    , ("<XF86AudioLowerVolume>", spawn "volume down")
    , ("<XF86AudioRaiseVolume>", spawn "volume up")
    , ("<XF86AudioPrev>", spawn "playerctl previous")
    , ("<XF86AudioPlay>", spawn "playerctl play-pause")
    , ("<XF86AudioNext>", spawn "playerctl next")
    , ("<XF86MonBrightnessDown>", spawn "brightness down")
    , ("<XF86MonBrightnessUp>", spawn "brightness up")

    ---------------------------------------------------------------------------
    -- Leader mappings
    ---------------------------------------------------------------------------

    -- Layout
    , ("M-<Space> l n", sendMessage NextLayout)
    , ("M-<Space> l f", sendMessage $ JumpToLayout "full")
    , ("M-<Space> l h", sendMessage $ JumpToLayout "horizontal")
    , ("M-<Space> l v", sendMessage $ JumpToLayout "vertical")
    , ("M-<Space> l c", sendMessage $ JumpToLayout "cols")

    -- Brightness
    -- presets
    , ("M-<Space> b d", spawn "brightness set 5")
    , ("M-<Space> b m", spawn "brightness set 25")
    , ("M-<Space> b b", spawn "brightness set 75")
    , ("M-<Space> b f", spawn "brightness set 100")
    -- intervals
    , ("M-<Space> +", spawn "brightness set 10")
    , ("M-<Space> [", spawn "brightness set 20")
    , ("M-<Space> {", spawn "brightness set 30")
    , ("M-<Space> (", spawn "brightness set 40")
    , ("M-<Space> &", spawn "brightness set 50")
    , ("M-<Space> =", spawn "brightness set 60")
    , ("M-<Space> )", spawn "brightness set 70")
    , ("M-<Space> }", spawn "brightness set 80")
    , ("M-<Space> ]", spawn "brightness set 90")
    , ("M-<Space> *", spawn "brightness set 100")

    -- Volume / Audio Control
    -- volume
    , ("M-<Space> S-+", spawn "volume set 10")
    , ("M-<Space> S-[", spawn "volume set 20")
    , ("M-<Space> S-{", spawn "volume set 30")
    , ("M-<Space> S-(", spawn "volume set 40")
    , ("M-<Space> S-&", spawn "volume set 50")
    , ("M-<Space> S-=", spawn "volume set 60")
    , ("M-<Space> S-)", spawn "volume set 70")
    , ("M-<Space> S-}", spawn "volume set 80")
    , ("M-<Space> S-]", spawn "volume set 90")
    , ("M-<Space> S-*", spawn "volume set 100")
    , ("M-<Space> m", spawn "volume mute")
    -- player
    , ("M-<Space> v p", spawn "playerctl previous")
    , ("M-<Space> v <Space>", spawn "playerctl play-pause")
    , ("M-<Space> v n", spawn "playerctl next")

    , ("M-+", sequence_[windows $ W.greedyView "1", spawn "wsnotify"])
    , ("M-[", sequence_[windows $ W.greedyView "2", spawn "wsnotify"])
    , ("M-{", sequence_[windows $ W.greedyView "3", spawn "wsnotify"])
    , ("M-(", sequence_[windows $ W.greedyView "4", spawn "wsnotify"])
    , ("M-&", sequence_[windows $ W.greedyView "5", spawn "wsnotify"])
    , ("M-=", sequence_[windows $ W.greedyView "6", spawn "wsnotify"])
    , ("M-)", sequence_[windows $ W.greedyView "7", spawn "wsnotify"])
    , ("M-}", sequence_[windows $ W.greedyView "8", spawn "wsnotify"])
    , ("M-]", sequence_[windows $ W.greedyView "9", spawn "wsnotify"])
    , ("M-*", sequence_[windows $ W.greedyView "10", spawn "wsnotify"])

    ]
    -- Change workspace with number keys
    ++
    [ (otherModMasks ++ "M-" ++ key, action tag)
    | (tag, key)  <- zip myWorkspaces ["+", "[", "{", "(", "&", "=", ")", "}", "]", "*"]
     -- , (otherModMasks, action) <- [ ("", windows . W.greedyView) -- or W.view
     --                              , ("S-", windows . W.shift)]
        , (otherModMasks, action) <- [("S-", windows . W.shift)]
    ]

    -- Function keys
    ++
    [ (otherModMasks ++ "M-" ++ key, action tag)
    | (tag, key)  <- zip myWorkspaces (map (\x -> "<F" ++ show x ++ ">") [1..12])
     , (otherModMasks, action) <- [ ("", windows . W.greedyView) -- or W.view
                                  , ("S-", windows . W.shift)]
    ]

    where
        _l = 0.95 - _w -- offset from left
        _t = 0.95 - _h -- offset from top
        _w = 0.9 -- width
        _h = 0.9 -- height
        toggleFloat w = windows (\s -> if M.member w (W.floating s)
                            then W.sink w s
                            else (W.float w (W.RationalRect _l _t _w _h) s))

myWindowNavigation = withWindowNavigationKeys ([
    ((myModMask, xK_k), WNGo U),
    ((myModMask, xK_j), WNGo D),
    ((myModMask, xK_h), WNGo L),
    ((myModMask, xK_l), WNGo R),
    ((myModMask .|. controlMask, xK_k), WNSwap U),
    ((myModMask .|. controlMask, xK_j), WNSwap D),
    ((myModMask .|. controlMask, xK_h), WNSwap L),
    ((myModMask .|. controlMask, xK_l), WNSwap R)])


--------------------------------------------------------------------------------
-- Config
--------------------------------------------------------------------------------
-- fh = manageFocus $ composeOne
--         -- For activated windows.
--         [ liftQuery activated -?> keepWorkspace <+> keepFocus
--         -- For new windows.
--         , Just <$> switchFocus
--         ]
myConfig = def
    { terminal           = myTerminal
    , layoutHook         = myLayoutHook
    , manageHook         = namedScratchpadManageHook myScratchPads
        -- <+> fh
        <+> placeHook(smart(0.5, 0.5))
        <+> manageDocks
        <+> myManageHook
        <+> manageHook def
        <+> insertPosition Below Newer
        <+> (isFullscreen --> doFullFloat)
    -- , handleEventHook    = docksEventHook
    , handleEventHook   = minimizeEventHook
        <+> clickFocusFloatHook
        -- Allows windows to properly fullscreen
        -- breaks flameshot: https://github.com/flameshot-org/flameshot/issues/773#issuecomment-752933143
        -- <+> fullscreenEventHook
    -- Move Spotify to workspace 5
        <+> dynamicPropertyChange "WM_NAME"
            (className =? "Spotify" --> doShift "6")
    , startupHook        = myStartupHook
    , focusFollowsMouse  = focusMouse
    , clickJustFocuses   = False
    , borderWidth        = myBorderWidth
    , modMask            = myModMask
    , workspaces         = myWorkspaces
    , normalBorderColor  = myBorderColor
    , focusedBorderColor = myFocusColor
    , mouseBindings      = myMouseBindings
    } `additionalKeysP` myKeys
        where
            wmName = stringProperty "WM_NAME"


--------------------------------------------------------------------------------
-- LogHook (xmonad-log output)
--------------------------------------------------------------------------------
myLogHook :: D.Client -> PP
myLogHook dbus = def
    { ppOutput = dbusOutput dbus
    -- , ppSort = fmap (.namedScratchpadFilterOutWorkspace) getSortByTag
    }

dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
            D.signalBody = [D.toVariant $ UTF8.decodeString str]
        }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"


myFadeHook = composeAll [
    isUnfocused --> transparency 0.2, 
    className =? "Microsoft-edge-dev" --> opaque,
    className =? "firefox-aurora" --> opaque,
    className =? "Navigator" --> opaque
    ]

--------------------------------------------------------------------------------
-- Main
--------------------------------------------------------------------------------
main = do
    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

    fullConfig <- myWindowNavigation
        $ ewmh
        $ docks
        $ myConfig {
         logHook = dynamicLogWithPP (myLogHook dbus)
             >> fadeWindowsLogHook myFadeHook
             >> historyHook
        }

    xmonad fullConfig

