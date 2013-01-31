import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

myManageHook = composeAll
       [ className =? "feh"     --> doFloat
       , className =? "Gimp"    --> doFloat
       ]

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/tippenein/.xmobarrc"
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
      , modMask             = mod4Mask
      , workspaces          = ["shell", "www", "chat"] ++ map show [4..9]
      , borderWidth         = 3 
      , normalBorderColor   = "#000000" 
      , focusedBorderColor  = "#8ab07f"
      , terminal            = "xterm"
      } `additionalKeys`
      [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
      , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
      , ((0, xK_Print), spawn "scrot")
      ]
