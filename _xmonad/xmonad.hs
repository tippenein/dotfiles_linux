import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import qualified XMonad.StackSet as W

myManageHook = composeAll
       [ className =? "feh"     --> doFloat
       , className =? "Gimp"    --> doFloat
       , className =? "Firefox-bin" --> doF(W.shift "2:www")
       , className =? "Pidgin" --> doF(W.shift "3:chat")
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
      , workspaces          = ["1:shell", "2:www", "3:chat", "4:vm", "5:music"] ++ map show [6..9]
      , borderWidth         = 3
      , normalBorderColor   = "#000000" 
      , focusedBorderColor  = "#88bb77"
      , terminal            = "urxvt"
      } `additionalKeys`
      [ ((mod1Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
      , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
      , ((0, xK_Print),
        spawn "scrot '/tmp/%Y-%m-%d_%H:%M:%S_$wx$h_scrot.png' -e 'mv $f ~'")
      -- Decrease volume.
      , ((mod1Mask .|. controlMask, xK_j),
          spawn "amixer -q set Master 5%-")
      -- Increase volume.
      , ((mod1Mask .|. controlMask, xK_k),
          spawn "amixer -q set Master 5%+")
      -- reboot and shutdown
      , ((mod1Mask .|. controlMask, xK_Insert),
        spawn "sudo shutdown -r now"       ) -- reboot
      , ((mod1Mask .|. controlMask, xK_Delete),
        spawn "sudo shutdown -h now"       ) -- poweroff
      , ((mod1Mask .|. shiftMask, xK_w), spawn "firefox")
      ] 
