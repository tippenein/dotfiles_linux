import XMonad
--- layouts
import XMonad.Layout.Spacing
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.SimplestFloat
import XMonad.Layout.ResizableTile
import XMonad.Layout.Circle
---
import XMonad.Hooks.EwmhDesktops hiding (fullscreenEventHook)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Actions.CycleWS
import System.IO

-------------------
-- Layouts --------
-------------------
myLayout = avoidStruts  $  layoutHook defaultConfig

-------------------
-- Worspace names -
-------------------
myWorkspaces = ["shell"
               ,"web"
               ,"chat"
               ,"music"
               ,"other"
               ,"mail"]

-------------------
-- Hooks ----------
-------------------
myManageHook = composeAll [ resource =? "dmenu" --> doFloat
                          , resource =? "skype" --> doFloat
                          , resource =? "Gimp"  --> doFloat
                          , resource =? "feh"   --> doFloat
                          , resource =? "Nm-connection-editor" --> doFloat
                          , resource =? "firefox" --> doShift (myWorkspaces !! 2)
                          , resource =? "Pidgin"  --> doShift (myWorkspaces !! 3)
                          , resource =? "lowriter"--> doShift (myWorkspaces !! 5)
                          , resource =? "localc"  --> doShift (myWorkspaces !! 5)
                          , resource =? "evince"  --> doShift (myWorkspaces !! 5)
                          , manageDocks]
newManageHook = myManageHook <+> manageHook defaultConfig

main = do
    xmproc <- spawnPipe "/home/tippenein/.cabal/bin/xmobar /home/tippenein/.xmobarrc"
    xmonad $ defaultConfig
      { borderWidth        = 2
      , manageHook         = newManageHook
      , modMask            = mod1Mask
      , workspaces         = myWorkspaces
      , layoutHook         = smartBorders $ myLayout
      , normalBorderColor  = myNormalBorderColor
      , focusedBorderColor = myFocusedBorderColor
      , terminal           = myTerminal
      , handleEventHook    = fullscreenEventHook <+> docksEventHook
      , focusFollowsMouse  = False
      , logHook = dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor "green" "" . shorten 50
                }
      }
----------------
-- Keybinds ----
----------------
      `additionalKeys`
      -- screensaver
      [ ((mod1Mask .|. controlMask, xK_z),
        spawn "xscreensaver-command -lock")
      -- normal screenshot
      , ((0, xK_Print),
        spawn "scrot '/tmp/%Y-%m-%d_%H:%M:%S_$wx$h_scrot.png' -e 'mv $f ~/screenies'")
      -- select screenshot
      , ((controlMask, xK_Print),
        spawn "sleep 0.2; scrot -s")
      -- Decrease volume.
      , ((mod1Mask .|. controlMask, xK_j),
        spawn "amixer -q set Master 3%-")
      -- Increase volume.
      , ((mod1Mask .|. controlMask, xK_k),
        spawn "amixer -q set Master 3%+")
      -- firefox
      , ((mod1Mask .|. shiftMask, xK_w),
        spawn "firefox")
      -- Network manager connection editor
      , ((mod1Mask .|. shiftMask, xK_n),
        spawn "nm-connection-editor")
      ]

----------------
-- constants ---
----------------
myTerminal = "urxvt"
myFocusedBorderColor = "#88bb77"
myNormalBorderColor  = "#000033"
-- Fonts only useful if switching to dzen/conky
--myFont = "-*-terminus-medium-*-normal-*-9-*-*-*-*-*-*-*"
--myFont = "-*-lime-*-*-*-*-*-*-*-*-*-*-*-*"
--myFont = "-*-nu-*-*-*-*-*-*-*-*-*-*-*-*"
--myFont = "'sans:italic:bold:underline'"
--myFont = "xft:Droxd Sans:size=12"
--myFont = "-*-cure-*-*-*-*-*-*-*-*-*-*-*-*"
