----------------------------------- Imports -----------------------------------
import XMonad
    ( mod4Mask, spawn, (|||), xmonad, composeAll, kill, KeyMask, Dimension,
      Default(def), ManageHook, X,
      XConfig(modMask, terminal, borderWidth, focusedBorderColor,
              normalBorderColor, layoutHook, startupHook, manageHook),
      Choose, Full(..), Mirror(..), Tall(Tall) )
import XMonad.Hooks.EwmhDesktops ( ewmh, ewmhFullscreen )
import XMonad.Layout.Spacing ( spacingWithEdge )
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Hooks.ManageDocks (manageDocks, docks, avoidStruts, AvoidStruts)
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Layout.Decoration ( def, ModifiedLayout )


-------------------------------- User variables -------------------------------
myModMask :: KeyMask
myModMask = mod4Mask    

myTerminal :: String
myTerminal = "kitty"

myFocusedBorderColor :: String
myFocusedBorderColor = "#a7c080"

myNormalBorderColor :: String
myNormalBorderColor = "#525c62"

myBorderWidth :: Dimension
myBorderWidth = 2

----------------------------------- Layouts -----------------------------------
tiled :: Tall a
tiled = Tall nmaster delta ratio    -- Standart master-stack layout
    where
        nmaster = 1      -- Default number of windows in the master pane
        ratio   = 1/2    -- Default proportion of screen occupied by master pane
        delta   = 3/100  -- Percent of screen to increment by when resizing panes

mirroredTiled :: Mirror Tall a
mirroredTiled = Mirror tiled        -- Master on top, stack on the bottom

fullscreen :: Full a
fullscreen = Full                   -- One window takes all space, others are hidden

myLayout :: ModifiedLayout AvoidStruts (Choose Tall (Choose (Mirror Tall) Full)) a
myLayout = avoidStruts $ tiled ||| mirroredTiled ||| fullscreen

--------------------------------- Keybindings ---------------------------------
myKeys :: [(String, X ())]
myKeys = 
    [ ("M-r", spawn "rofi -show drun")
    , ("M-w", kill)
    , ("M-<Return>", spawn myTerminal)

    -- Function keys
    , ("<XF86AudioMute>",           spawn "amixer sset Master toggle")
    , ("<XF86AudioLowerVolume>",    spawn "amixer sset Master 10%-")
    , ("<XF86AudioRaiseVolume>",    spawn "amixer sset Master 10%+")
    , ("<XF86MonBrightnessUp>",     spawn "brightnessctl set 10%+")
    , ("<XF86MonBrightnessDown>",   spawn "brightnessctl set 10%-")
    , ("<XF86Calculator>",          spawn $ myTerminal ++ " python")
    ]

------------------------------- Startup hooks ---------------------------------
myStartupHook :: X ()
myStartupHook = do
    spawnOnce "~/.fehbg"                    -- Restore wallpaper
    spawnOnce "~/.local/bin/eww daemon"     -- Activate eww daemon
    spawnOnce "~/.local/bin/eww open bar"   -- Show top bar

------------------------------- Manage hooks ----------------------------------
myManageHook :: ManageHook
myManageHook =
    composeAll
        [ manageDocks ]

------------------------------------ Main -------------------------------------
main :: IO ()
main = xmonad $ docks $ ewmhFullscreen $ ewmh $ def
    { modMask = myModMask
    , terminal = myTerminal
    , borderWidth = myBorderWidth
    , focusedBorderColor = myFocusedBorderColor
    , normalBorderColor = myNormalBorderColor
    , layoutHook = spacingWithEdge 12 myLayout
    , startupHook = myStartupHook
    , manageHook = myManageHook
    }
    `additionalKeysP` myKeys
