
import XMonad
import XMonad.Config.Desktop

import XMonad.Layout.Gaps
import XMonad.Layout

import XMonad.Hooks.DynamicHooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers

import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.XMonad

import XMonad.Util.EZConfig
import XMonad.Util.Run(spawnPipe)

import Graphics.X11.ExtraTypes.XF86

import DBus.Client as D

import System.Exit
import System.IO

import System.Taffybar.XMonadLog

import Control.Applicative
import Control.Concurrent
import Control.Exception as E

import qualified Data.Map        as M
import Data.List
import qualified XMonad.StackSet as W

myTaffybarPP = taffybarPP {
    ppTitle = taffybarColor "green" "" . shorten 300
}

main = do
    dbus <- D.connectSession
    xmonad $ ewmh $ myConfig { 
        logHook = dbusLogWithPP dbus myTaffybarPP >> logHook myConfig
    }


myConfig = defaultConfig 
    { modMask = mod4Mask
    , terminal = "gnome-terminal"
    , focusFollowsMouse = True

    , manageHook = myManageHook
    , layoutHook = myLayout
    , logHook = myLogHook 
    , keys = myKeys
    , startupHook = myStartupHook
    } `additionalKeysP` (easyKeyList myConfig)

easyKeys conf = mkKeymap conf $ easyKeyList conf

easyKeyList conf =
    -- launch a terminal
    [ ("M-<Return>", spawn $ XMonad.terminal conf)
    -- launch dmenu
    , ("M-<F2>"      , shellPrompt defaultXPConfig)
    , ("M-r"         , shellPrompt defaultXPConfig)
    -- close focused window
    , ("M-S-c"       , kill)
    -- Rotate through the available layout algorithms
    , ("M-<Space>"   , sendMessage NextLayout)
    -- This doesn't work just yet
    -- , ("M-S-<Space>" , setLayout $ XMonad.layoutHook conf)
    
    -- Resize viewed windows to the correct size
    , ("M-n"         , refresh)
    -- Move focus to the next window
    , ("M-<Tab>"     , windows W.focusDown)
    , ("M-j"         , windows W.focusDown)
    -- Move focus to the previous window
    , ("M-k"         , windows W.focusUp)
    -- Move focus to the master window
    , ("M-m"         , windows W.focusMaster)
    -- Swap the focused window and the master window
    , ("M-S-m"       , windows W.shiftMaster)
    , ("M-S-<Return>", windows W.shiftMaster)
    -- Swap the focused window with the next window
    , ("M-S-j"       , windows W.swapDown)
    -- Swap the focused window with the previous window
    , ("M-S-k"       , windows W.swapUp)
    -- Shrink the master area
    , ("M-h"         , sendMessage Shrink)
    -- Expand the master area
    , ("M-l"         , sendMessage Expand)
    -- Push window back into tiling
    , ("M-t"         , withFocused $ windows . W.sink)
    -- Lock screen
    , ("M-S-z"       , spawn 
                    "gnome-screensaver-command --activate")
    , ("M-C-w"       , spawn "google-chrome")
    , ("M-C-e"       , spawn "eclipse44")
    -- Cycle Keyboard layouts
    , ("M-<Escape>"  , spawn "~/bin/layout_switch.sh")
    -- Quit xmonad
    , ("M-S-q"       , killAndExit)
    -- Restart xmonad
    , ("M-q"         , killAndRestart)
    ]
        where
            killAndExit = 
                io (exitWith ExitSuccess)
            killAndRestart = 
                (spawn "/usr/bin/killall dzen2") <+>
                (liftIO $ threadDelay 1000000) <+>
                (restart "xmonad" True)

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ 
    --  Reset the layouts on the current workspace to default
      ((modm .|. shiftMask, xK_space ), 
                            setLayout $ XMonad.layoutHook conf)
 
    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
 
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
 
    ------------------------------------------------------------
    -- Special Keys
    ------------------------------------------------------------
    --
    ]
    ++
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) 
                        ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
 
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 
myLayout = desktopLayoutModifiers $ Tall nmaster delta ratio ||| Full
    where
    nmaster = 1
    ratio = 5/7
    delta = 5/100

myLogHook = do
    takeTopFocus
    return ()

myStartupHook = do
    spawn "taffybar"
    spawn "nm-applet"
    spawn "/usr/share/goobuntu-indicator/goobuntu_indicator.py"
    takeTopFocus
    return ()
    checkKeymap myConfig 
        (easyKeyList myConfig)


myManageHook :: ManageHook
myManageHook = 
    manageDocks <+>
    dynamicMasterHook <+>
    manageWindows

manageWindows :: ManageHook
manageWindows = composeAll . concat $
    [ [ resource   =? r --> doIgnore               | r <- myIgnores ]
    , [ className  =? c --> doCenterFloat          | c <- myFloatCC ]
    , [ fmap (c `isInfixOf`) name --> unfloat      | c <- myUnfloatCC ]
    , [ name       =? n --> doCenterFloat          | n <- myFloatCN ]
    , [ name       =? n --> doSideFloat NW         | n <- myFloatSN ]
    , [ windowRole =? n --> doSideFloat SW         | n <- myFloatSR ]
    , [ className  =? c --> doF W.focusDown        | c <- myFocusDC ]
    , [ isFullscreen    --> doFullFloat 
      , isDialog        --> doCenterFloat
      ]
    ] where
        name       = stringProperty "WM_NAME"
        windowRole = stringProperty "WM_WINDOW_ROLE"
        myIgnores  = ["desktop", "desktop_window"
                     , "xfce4-panel"]
        myAlt3S    = ["Amule", "Transmission-gtk"]
        myFloatCC  = ["MPlayer", "mplayer2", "File-roller"
                     , "zsnes", "Gcalctool", "Exo-helper-1"
                     , "Gksu", "Galculator", "Nvidia-settings"
                     , "XFontSel", "XCalc", "XClock"
                     , "Ossxmix", "Xvidcap", "Main", "Wicd-client.py"
                     , "xfrun4", "jetbrains-android-studio"]
        myFloatCN  = ["Choose a file", "Open Image"
                     , "File Operation Progress", "Firefox Preferences"
                     , "Preferences", "Search Engines", "Set up sync"
                     , "Passwords and Exceptions"
                     , "Autofill Options", "Rename File"
                     , "Copying files", "Moving files"
                     , "File Properties", "Replace", "Quit GIMP"
                     , "Change Foreground Color"
                     , "Change Background Color"
                     , "Expired/Expiring LOAS Certificate" 
                     , "action_goobuntu_check.py"
                     , "Application Finder", "xmessage", ""]
        myFloatSN  = ["Event Tester"]
        myFloatSR  = ["pop-up"]
        myFocusDC  = ["Event Tester", "Notify-osd"]
        -- Chrome Secure Shell
        myUnfloatCC = ["Secure Shell"] 
        keepMaster c = assertSlave <+> assertMaster where
            assertSlave = fmap (/= c) className --> doF W.swapDown
            assertMaster = className =? c --> doF W.swapMaster
        unfloat    = ask >>= doF . W.sink
 
