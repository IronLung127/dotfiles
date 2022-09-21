import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Actions.CycleWS (nextScreen, prevScreen, shiftNextScreen, shiftPrevScreen)
import XMonad.Actions.SpawnOn
import System.IO (hClose, hPutStr, hPutStrLn)

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.WindowSwallowing

import XMonad.Layout.Magnifier
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile

import XMonad.Util.NamedActions
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce

import qualified XMonad.DBus as D
import qualified DBus.Client as DC

import Custom.MyVariables
import Custom.MyKeys
import Custom.MyScratchpads
import Custom.MyHooks
import Custom.MyLayouts


main :: IO ()
main = do
  dbus <- D.connect
  D.requestAccess dbus

  xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp " polybar --reload -c ~/.config/polybar/main.ini" (pure myXmobarPP)) defToggleStrutsKey
     $ docks 
     $ addDescrKeys ((mod4Mask .|. shiftMask, xK_slash), showKeybindings) myKeys
     $ myConfig { logHook = dynamicLogWithPP (myLogHook dbus) }

myConfig = def
    { modMask            = mod4Mask      -- Rebind Mod to the Super key
    , layoutHook         = myLayout      -- Use custom layouts
    , manageHook         = myManageHook  -- Match on certain windows
    -- , handleEventHook    = swallowEventHook (className =? "Alacritty") (return True)
    , terminal           = myTerminal
    , startupHook        = startup
    , normalBorderColor  = "#000000"
    , focusedBorderColor = "#FFFFFF"
    , borderWidth        = 1
    , workspaces         = myWorkspaces
    , focusFollowsMouse  = True
    }


startup :: X ()
startup = do
  spawn         "/home/rugved/.screenlayout/setup\\ with\\ lg\\ on\\ left.sh"
  spawnOnce     "polybar --reload -c ~/.config/polybar/main.ini"
  spawnOnce     "~/.fehbg"
  spawnOnce     "picom --experimental-backends"
  spawnOnce     "dunst"

  -- Tray and other crap
  spawnOnce "nm-applet"
  spawnOnce "volumeicon"
  spawnOnce "discord --start-minimized"
  spawnOnce "lxappearance"

{- $ rm -rf /bin/keyboard.CapsLock -}
  spawn "/usr/bin/setxkbmap -option '' -option 'ctrl:nocaps'"