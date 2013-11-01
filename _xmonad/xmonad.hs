-- xmonad.hs  
-- some of the structure inspired by this:
-- http://thinkingeek.com/2011/11/21/simple-guide-configure-xmonad-dzen2-conky/
-- otherwise most is cargoculted from other shit

import XMonad
-- Hooks
import XMonad.Operations

import System.IO
import System.Exit

import XMonad.Util.Run
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Actions.CycleWS

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops

import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.PerWorkspace (onWorkspace, onWorkspaces)
import XMonad.Layout.SimpleFloat

import qualified XMonad.StackSet as W
import qualified Data.Map as M
-------------------
-- Layouts --------
-------------------
myLayout = avoidStruts  $  layoutHook defaultConfig

-------------------
-- Worspace names -
-------------------
myWorkspaces = ["1:shell"
               ,"2:web"
               ,"3:chat"
               ,"4:mail"
               ,"5:music"
               ,"6:vm"
               ,"7"
               ,"8"
               ,"9:rdesk"]
-------------------
-- Hooks ----------
-------------------
myManageHook :: ManageHook
myManageHook = (composeAll . concat $
    [ [resource     =? r   --> doIgnore            |   r   <- myIgnores]
    , [className    =? c   --> doShift  "1:dev"    |   c   <- myDev    ]
    , [className    =? c   --> doShift  "2:web"    |   c   <- myWeb    ]
    , [className    =? c   --> doShift  "3:chat"   |   c   <- myChat   ]
    , [className    =? c   --> doShift  "4:music"  |   c   <- myMusic  ]
    , [className    =? c   --> doShift  "5:other"  |   c   <- myOther  ]
    , [className    =? c   --> doShift  "6:mail"   |   c   <- myMail   ]
    , [className    =? c   --> doShift  "9:rdesk"  |   c   <- myRdesk  ]
    , [className    =? c   --> doCenterFloat       |   c   <- myFloats ]
    , [name         =? n   --> doCenterFloat       |   n   <- myNames  ]
    , [isFullscreen        --> myDoFullFloat                           ]
    ])

    where

        role      = stringProperty "WM_WINDOW_ROLE"
        name      = stringProperty "WM_NAME"

        -- classnames  --- Use 'xprop' on the commandline to click windows and find out classname
        myDev     = ["Eclipse"]  -- hate eclipse :(
        myWeb     = ["Firefox"]
        myMusic   = ["Google-chrome","Chromium","Chromium-browser","vlc"]  -- I usually use subsonic with chrome
        myChat    = ["Pidgin","Buddy List"]
        myOther   = ["Evince","xchm","libreoffice-writer","libreoffice-startcenter"]
        myMail    = ["Thunderbird", "mutt"]  -- just a reminder to use mutt instead, eventually
        myFloats  = ["feh","Gimp","Xmessage","XFontSel","Nm-connection-editor"]
        myRdesk   = ["rdesktop"]
 
        -- resources
        myIgnores = ["desktop","desktop_window","notify-osd","stalonetray","trayer"]
 
        -- names
        myNames   = ["bashrun","Google Chrome Options","Chromium Options"]
 
        -- a trick for fullscreen but stil allow focusing of other WSs
        myDoFullFloat :: ManageHook
        myDoFullFloat = doF W.focusDown <+> doFullFloat


newManageHook = myManageHook <+> manageHook defaultConfig

main = do
    xmproc <- spawnPipe "/home/brady/.cabal/bin/xmobar /home/brady/.xmobarrc"
    xmonad $ defaultConfig
      { borderWidth        = 2
      , manageHook         = newManageHook
      , modMask            = mod4Mask
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
      [ ((modMask .|. controlMask, xK_z),
        spawn "xscreensaver-command -lock")
      -- normal screenshot
      , ((0, xK_Print),
        spawn "scrot -e 'mv $f ~/screenies'")
      -- select screenshot
      , ((controlMask, xK_Print),
        spawn "sleep 0.2; scrot -s -e 'mv $f ~/screenies'")
      -- Decrease volume.
      , ((modMask .|. controlMask, xK_j),
        spawn "amixer -q set Master 3%-")
      -- Increase volume.
      , ((modMask .|. controlMask, xK_k),
        spawn "amixer -q set Master 3%+")
      -- firefox
      , ((modMask .|. shiftMask, xK_f),
        spawn "firefox")
      -- thunderbird
      , ((modMask .|. shiftMask, xK_t),
        spawn "thunderbird")
      -- use chromium for subsonic
      , ((modMask .|. shiftMask, xK_s),
        spawn "chromium-browser --instant-url 'tippenein.subsonic.org'")
      -- libre office
      , ((modMask .|. shiftMask, xK_l),
        spawn "libreoffice")
      -- Network manager connection editor
      , ((modMask .|. shiftMask, xK_n),
        spawn "nm-connection-editor")
      -- cmus next track
      , ((modMask, xK_b),
        spawn "cmus-remote -n")
      -- cmus pause track
      , ((modMask, xK_c),
        spawn "cmus-remote -u")
      -- workspaces
      , ((modMask .|. controlMask, xK_Right ), nextWS)
      , ((modMask .|. shiftMask,   xK_Right ), shiftToNext)
      , ((modMask .|. controlMask, xK_Left  ), prevWS)
      , ((modMask .|. shiftMask,   xK_Left  ), shiftToPrev)
      ]
    where modMask = mod4Mask

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
