import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Actions.CycleWS (nextScreen, prevScreen, shiftNextScreen, shiftPrevScreen)

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.EwmhDesktops

import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.Ungrab
import XMonad.Util.SpawnOnce
import XMonad.Util.Run

import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
import XMonad.Layout.IndependentScreens


-- import qualified XMonad.DBus as D
-- import qualified DBus.Client as DC

myEditor         =  "code" 
restart_xmonad   =  "xmonad --recompile ; xmonad --restart ; notify-send restarted -u normal -t 2500"

myGap            = 10
myWorkspaces     = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

--myLogHook :: DC.Client -> PP
--myLogHook dbus = def { ppOutput = D.send dbus }

main :: IO ()
main = do
  --dbus <- D.connect
  --D.requestAccess dbus

  xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp " polybar --reload -c ~/.config/polybar/main.ini" (pure myXmobarPP)) defToggleStrutsKey
--     $ myConfig { logHook = dynamicLogWithPP (myLogHook dbus) }
	 $ myConfig

myConfig = def
    { modMask            = mod4Mask      -- Rebind Mod to the Super key
    , layoutHook         = myLayout      -- Use custom layouts
    , manageHook         = myManageHook  -- Match on certain windows
    , terminal           = "alacritty -t \"Alacritty\""
    , startupHook        = startup
    , normalBorderColor  = "#000000"
    , focusedBorderColor = "#FFFFFF"
    , borderWidth        = 1
    , workspaces         = myWorkspaces
    , focusFollowsMouse  = False
    }

   `removeKeysP`
   [ ("M-S-q")
   , ("M-p")
   ]
  `additionalKeysP`
    [ ("M-S-z"          , spawn "betterlockscreen -l"                   )
    , ("M-S-s"          , spawn "flameshot gui"                         )
    , ("M-o"            , spawn "dmenu_run -l 20"                       )
    , ("M1-S-q"         , spawn "~/bin/logout.sh"                       )
    , ("M-S-q"          , kill                                          )
    , ("M-q"            , spawn restart_xmonad                          )
    , ("M-j"            , windows W.focusDown                           )
    , ("M-k"            , windows W.focusUp                             )
    , ("M-<Return>"     , windows W.swapMaster                          )
    , ("M-<Tab>"        , windows W.focusDown                           )
    , ("M-S-j"          , windows W.swapDown                            )
    , ("M-S-k"          , windows W.swapUp                              )
    , ("C-M-j"          , nextScreen                                    )
    , ("C-M-k"          , prevScreen                                    )
    , ("C-M-S-j"        , shiftNextScreen                               )
    , ("C-M-S-k"        , shiftNextScreen)
    , ("M-<Page_Up>"    , sendMessage (IncMasterN 1)                    )
    , ("M-<Page_Down>"  , sendMessage (IncMasterN (-1))                 )
-- Audio Keys
    , ("<XF86AudioPlay>"        , spawn "playerctl play-pause"          )
    , ("<XF86AudioPrev>"        , spawn "playerctl previous"            )
    , ("<XF86AudioNext>"        , spawn "playerctl next"                )
    , ("<XF86AudioMute>"        , spawn "amixer set Master toggle"      )
    , ("<XF86AudioLowerVolume>" , spawn "amixer set Master 3%- unmute"  )
    , ("<XF86AudioRaiseVolume>" , spawn "amixer set Master 3%+ unmute"  )
-- Quick launch apps
    , ("M-f"            , spawn "firefox"                               )
    , ("M-C-<Return>"   , spawn "librewolf"                             )
    , ("M-e"            , spawn "nautilus"                              )
    , ("M-c"            , spawn "code ~/.xmonad/"                       )

-- I need this 
    , ("M-z" , spawn "playerctl play-pause"                             )
-- Apps
    , ("M-a d" , spawn "discord"                                        )
    , ("M-a s" , spawn "spotify-tray -t"                                )
    , ("M-a e" , spawn myEditor                                         )
    , ("M-a m" , spawn "multimc"                                        )
--  Scripts
    , ("M1-<F9>", spawn "~/bin/picom-toggle.sh"                         )
    , ("M-p k", spawn "~/bin/kill.sh"                                   )
    ]

startup :: X ()
startup = do
  spawnOnce "xrandr --output DVI-D-0 --primary --mode 1920x1080 --pos 1920x60 --rotate normal --output HDMI-0 --mode 1920x1200 --pos 0x0 --rotate normal --output DP-0 --off --output DP-1 --off"
  spawnOnce "~/.fehbg"
  spawnOnce "picom --experimental-backends"
  spawnOnce "dunst"
  spawnOnce "xmobar -x 1"
  spawnOnce "spotify-tray -m"
  -- spawnOnce "mpd"
  -- spawnOnce "mpd-mpris"
  -- spawnOnce "md-discord-rpc"

  -- Tray and other crap
  spawnOnce "nm-applet"
  spawnOnce "flameshot"
  spawnOnce "volumeicon"
  spawnOnce "discord --start-minimized"

{- $ rm -rf /bin/keyboard.CapsLock -}
  spawnOnce "/usr/bin/setxkbmap -option '' -option 'ctrl:nocaps'"

myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Gimp" --> doFloat
    , isDialog            --> doFloat
    ]

myLayout = spacingRaw True (Border 0 0 0 0) True (Border 0 0 0 0) True $ smartSpacing myGap  $ tiled ||| Mirror tiled ||| Full
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes



myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""
