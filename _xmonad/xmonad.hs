import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

myManageHook = composeAll
       [ className =? "feh"     --> doFloat
       , className =? "Gimp"    --> doFloat
       , className =? "Firefox" --> doShift "2:www"
       , className =? "Pidgin"  --> doShift "3:chat"
       , className =? "VLC"     --> doShift "5:other"
       , className =? "Evince"  --> doShift "5:other"
       ]

main = do
    xmproc <- spawnPipe "/home/tippenein/.cabal/bin/xmobar /home/tippenein/.xmobarrc"
    xmonad $ defaultConfig
        -- xmobar stuff
      { manageHook = manageDocks <+> myManageHook
                        <+> manageHook defaultConfig
      , layoutHook = avoidStruts  $  layoutHook defaultConfig
      , logHook    = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
      -- eveything else
      , modMask             = mod1Mask
      , workspaces          = ["1:shell", "2:www", "3:chat", "4:music", "5:other"] ++ map show [6..9]
      , borderWidth         = 3
      , normalBorderColor   = "#000000" 
      , focusedBorderColor  = "#88bb77"
      , terminal            = "urxvt"
      } `additionalKeys`
      [ ((mod1Mask .|. controlMask, xK_z),
        spawn "xscreensaver-command -lock")
      -- normal screenshot
      , ((0, xK_Print),
        spawn "scrot '/tmp/%Y-%m-%d_%H:%M:%S_$wx$h_scrot.png' -e 'mv $f ~'")
      -- select screenshot
      , ((controlMask, xK_Print),
        spawn "sleep 0.2; scrot -s")
      -- Decrease volume.
      , ((mod1Mask .|. controlMask, xK_j),
        spawn "amixer -q set Master 3%-")
      -- Increase volume.
      , ((mod1Mask .|. controlMask, xK_k),
        spawn "amixer -q set Master 3%+")
      -- reboot and shutdown
      , ((mod1Mask .|. controlMask, xK_Insert),
        spawn "sudo shutdown -r now"       ) -- reboot
      , ((mod1Mask .|. controlMask, xK_Delete),
        spawn "sudo shutdown -h now"       ) -- poweroff
      , ((mod1Mask .|. shiftMask, xK_w),
        spawn "firefox")
      ] 
