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
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.WithAll (killAll)
import XMonad.Actions.WindowNavigation
import XMonad.Actions.CycleWS
import XMonad.Actions.Minimize
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Monoid
import Data.Ratio
import qualified Data.Map as M

    -- Hooks
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.Place
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Minimize
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicProperty
import XMonad.Hooks.SetWMName
import XMonad.Hooks.InsertPosition
-- import XMonad.Hooks.Focus

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
import XMonad.Layout.SubLayouts
import XMonad.Layout.Renamed
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.Minimize
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Column
import qualified XMonad.Layout.BoringWindows as BW


    -- Utils
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad
import XMonad.Util.WorkspaceCompare

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
myWorkspaces = map show [1..7] ++ myExtraWorkspaces

getSortByIndexNoNSP = fmap (. filter (\(W.Workspace tag _ _) -> not (tag `elem` myExtraWorkspaces))) getSortByIndex

--------------------------------------------------------------------------------
-- Layouts
--------------------------------------------------------------------------------
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
-- disable when one window, screen edge gaps, screen edge gaps?, window gaps, window gaps?
-- T B R L
mySpacing i = spacingRaw True (Border i i i i) True (Border 0 i 0 i) True

horizontal  = renamed [Replace "horizontal"]
            $ smartBorders
            $ minimize . BW.boringWindows
            $ mySpacing 5
        -- params: windows in master, increment on resize, proportion for master
            $ ResizableTall 1 (3/100) (55/100) []
full    = renamed [Replace "full"]
            $ noBorders Full
vertical  = renamed [Replace "vertical"]
			$ smartBorders
			$ minimize . BW.boringWindows
			$ mySpacing 5
			$ Column 1.6

-- Not using
accordion = renamed [Replace "Accordion"]
			$ Accordion
triple  = renamed [Replace "Columns"]
            $ subLayout [] (smartBorders Simplest)
            $ mySpacing 5
            $ minimize . BW.boringWindows
            $ ThreeCol 1 (3/100) (3/7)
spirals  = renamed [Replace "Spiral"]
			$ smartBorders
			$ minimize . BW.boringWindows
			$ mySpacing 5
			$ spiral (6/7)

myLayouts =
	named "horizontal" horizontal |||
	named "full" full |||
	named "vertical" vertical

myLayoutHook = avoidStruts $ windowArrange
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
    , className =? "zoom"           --> doFloat
    , className =? "uk-org-jape-Jape" --> doFloat

    -- shift to workspace
    , className =? "ClickUp"        --> doShift "2"
    , className =? "Slack"          --> doShift "4"
    , className =? "discord"        --> doShift "4"
    , className =? "Microsoft Teams - Preview" --> doShift "4"
    , className =? "Thunderbird"    --> doShift "5"
    , className =? "barrier"        --> doShift "5"
    , manageDocks
    ]
  where
    role = stringProperty "WM_WINDOW_ROLE"


--------------------------------------------------------------------------------
-- Startup Hook
--------------------------------------------------------------------------------
myStartupHook :: X ()
myStartupHook = do
    spawnOnce "startup"
    setWMName "LG3D"

--------------------------------------------------------------------------------
-- Scratchpads
--------------------------------------------------------------------------------
myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageScratchpad ]
                    where
                        spawnTerm = myTerminal ++ " --title scratch"
                        findTerm = title =? "scratch"

                        -- % from left, % from top, width, height
                        manageScratchpad = customFloating $ W.RationalRect l t w h
                            where
                                h = 0.9 -- height
                                w = 0.9 -- width
                                t = 0.945 - h -- offset from top
                                l = 0.95 - w -- offset from left

--------------------------------------------------------------------------------
-- Search Engines
--------------------------------------------------------------------------------
archwiki = S.searchEngine "archwiki" "https://wiki.archlinux.org/index.php?search="
searchList :: [(String, S.SearchEngine)]
searchList = [
    ("a", archwiki),
    ("d", S.vocabulary),
    ("i", S.images),
    ("g", S.google),
    ("t", S.thesaurus),
    ("v", S.youtube),
    ("w", S.wikipedia)
    ]

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
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]


--------------------------------------------------------------------------------
-- Keybindings
--------------------------------------------------------------------------------
myKeys :: [(String, X())]
myKeys = [
    -- Launch Programs
    ("M-<Return>", spawn myTerminal) -- Terminal
    , ("M-S-<Return>", spawn "rofi -show drun -config $HOME/.config/rofi/main.rasi") -- Run Prompt
    , ("M-e", spawn "nemo") -- files
    , ("M-c", spawn "firefox -P ecal") -- Firefox
    , ("M1-c", spawn "firefox -P ta") -- TA firefox
    , ("M-S-g", spawn "firefox https://github.com") -- Github
    , ("M-S-d", spawn "inkscape $HOME/images/sketch.svg") -- Draw
    , ("M-S-c", spawn "firefox https://calendar.google.com") -- Calendar
    , ("M-b", spawn "bt menu")
    , ("M-S-b", spawn "polybar-msg cmd toggle") -- toggle Polybar
    , ("M-C-w", spawn "nitrogen") -- Nitrogen
    , ("M-s", spawn "focus-spotify") -- Spotify
    , ("M-<Esc> <Return>", spawn "$HOME/.config/polybar/scripts/powermenu.sh") -- Powermenu
    , ("M-S-s", spawn "flameshot gui") -- Screenshot GUI
    -- , ("M-S-s", spawn "sc -r -c ~/images")
    , ("M1-S-s", spawn "flameshot full -p ~/screenshots") -- Screenshot
    , ("M-S-m", spawn "thunderbird")
    , ("M-t", spawn "launch-comm")
    , ("M-S-n", spawn "obsidian")

    -- Scratchpads
    , ("M-\\", namedScratchpadAction myScratchPads "terminal")

    -- Kill Windows
    , ("M-q", kill) -- Focused window
    , ("M-S-q", killAll) -- Kill all windows

    -- Layout
    , ("M-<Space> n", sendMessage NextLayout)
	, ("M-<Space> f", sendMessage $ JumpToLayout "full")
	, ("M-<Space> h", sendMessage $ JumpToLayout "horizontal")
	, ("M-<Space> v", sendMessage $ JumpToLayout "vertical")
    , ("M-f", sendMessage ToggleStruts)
    , ("M-C-<Down>", sequence_[sendMessage DeArrange, withFocused $ windows . W.sink]) -- Tile Mode
    , ("M-S-h", sendMessage Shrink) -- Shrink horizontal
    , ("M-S-l", sendMessage Expand) -- Expand horizontal
    , ("M-S-j", sendMessage MirrorShrink) -- Shrink vertical
    , ("M-S-k", sendMessage MirrorExpand) -- Expand vertical
    , ("M-,", sendMessage (IncMasterN 1)) -- Add a window to master area
    , ("M-.", sendMessage (IncMasterN (-1))) -- Remove a window from master area
    , ("M--", withFocused minimizeWindow) -- Minimize
    , ("M-+", withLastMinimized maximizeWindowAndFocus) -- Maximize

    -- Floating Layout
    , ("M-C-<Up>", sendMessage Arrange) -- Floating Mode
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

    -- Focus
    --, ("M-m", windows W.focusMaster) -- Focus master window
    , ("M-C-m", windows W.swapMaster) -- Swap focused with master

    -- Workspace
    , ("M-<Tab>", nextWS) -- Next workspace
    , ("M-S-<Tab>", shiftToNext >> nextWS) -- Move window to next workspace
    , ("M-C-<Tab>", shiftToPrev >> prevWS) -- Move window to prev workspace
	-- , ("M-<F1>", windows $ W.greedyView "1")
	-- , ("M-<F2>", windows $ W.greedyView "2")
	-- , ("M-<F3>", windows $ W.greedyView "3")


    -- XMonad
    , ("C-M1-<Delete>", io (exitWith ExitSuccess)) -- Quit
    , ("M-S-r", sequence_[spawn "xmonad --recompile; xmonad --restart", spawn "$HOME/.config/polybar/launch.sh"]) -- Restart

    -- Function Keys
    , ("<XF86AudioMute>", spawn "volume mute")
    -- , ("M-<F1>", spawn "volume mute")
    , ("<XF86AudioLowerVolume>", spawn "volume down")
    -- , ("M-<F2>", spawn "volume down")
    , ("<XF86AudioRaiseVolume>", spawn "volume up")
    -- , ("M-<F3>", spawn "volume up")

    , ("<XF86AudioPrev>", spawn "playerctl previous")
    -- , ("M-<F4>", spawn "playerctl previous")
    , ("<XF86AudioPlay>", spawn "playerctl play-pause")
    -- , ("M-<F5>", spawn "playerctl play-pause")
    , ("<XF86AudioNext>", spawn "playerctl next")
    -- , ("M-<F6>", spawn "playerctl next")

    , ("<XF86MonBrightnessDown>", spawn "brightness down")
    , ("M-<F11>", spawn "brightness down")
    , ("M-C-<F11>", spawn "brightness set 10")
    , ("<XF86MonBrightnessUp>", spawn "brightness up")
    , ("M-<F12>", spawn "brightness up")
    , ("M-C-<F12>", spawn "brightness set 70")
    ]
	-- Change workspace with function keys
	++
    [ (otherModMasks ++ "M-" ++ key, action tag)
        | (tag, key)  <- zip myWorkspaces (map (\x -> "<F" ++ show x ++ ">") [1..12])
        , (otherModMasks, action) <- [ ("", windows . W.greedyView) -- or W.view
                                     , ("S-", windows . W.shift)]
    ]

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
             >> fadeInactiveLogHook 0.8
        }

    xmonad fullConfig

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
--        <+> fh
        <+> placeHook(smart(0.5, 0.5))
        <+> manageDocks
        <+> myManageHook
        <+> manageHook def
        <+> insertPosition Below Newer
        <+> (isFullscreen --> doFullFloat)
    , handleEventHook    = docksEventHook
        <+> minimizeEventHook
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


--------------------------------------------------------------------------------
-- LogHook (xmonad-log output)
--------------------------------------------------------------------------------
myLogHook :: D.Client -> PP
myLogHook dbus = def
    { ppOutput = dbusOutput dbus
    , ppSort = fmap (.namedScratchpadFilterOutWorkspace) getSortByTag
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
