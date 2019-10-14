{-# LANGUAGE PackageImports #-}
{-# LANGUAGE OverloadedStrings #-}

import           Data.Maybe                     ( fromMaybe )
import           System.Environment             ( getArgs )
import           System.Taffybar
import           System.Taffybar.Hooks
import           System.Taffybar.Util
import           System.Taffybar.SimpleConfig

import           System.Taffybar.Widget
import           System.Taffybar.Widget.Battery
import           System.Taffybar.Widget.FreedesktopNotifications
import           System.Taffybar.Widget.Util
import           System.Taffybar.Widget.Workspaces
import           System.Taffybar.Widget.SimpleClock

import           System.Taffybar.Widget.Generic.PollingBar
import           System.Taffybar.Widget.Generic.PollingGraph
import           System.Taffybar.Widget.XDGMenu.MenuWidget
import           System.Taffybar.Information.CPU2
import           System.Taffybar.Information.Memory

import           Text.Read                      ( readMaybe )
import           Control.Monad
import           Control.Monad.IO.Class
import           Control.Monad.Trans.Class
import           Control.Monad.Trans.Reader

memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

colorFuncTemp :: (Fractional a, Num t, Ord a) => a -> (a, a, t)
colorFuncTemp pct | pct <= 0.55 = (0, 1 - pct, 0)
                  | pct < 0.70  = (pct, 1 - pct, 0)
                  | pct < 1     = (pct, 0, 0)
                  | otherwise   = (1, 1, 1)

main = do
  args <- getArgs
  let memCfg = defaultGraphConfig { graphDataColors = [(1, 0, 0, 1)]
                                  , graphLabel      = Just "mem"
                                  }
      cpuCfg = defaultGraphConfig
        { graphDataColors = [(0, 1, 0, 1), (1, 0, 1, 0.5)]
        , graphLabel      = Just "cpu"
        , graphDataStyles = [Line]
        }
  let
    clock = textClockNew Nothing "%a %b %_d %H:%M" 1
    -- pager = taffyPagerNew defaultPagerConfig
    mem         = pollingGraphNew memCfg 2 memCallback
    cpu         = pollingGraphNew cpuCfg 2 $ getCPULoad "cpu"
    tray        = getHost True >>= sniTrayNewFromHost
    battery     = textBatteryNew "$percentage$%"
    batteryIcon = batteryIconNew
    layout      = layoutNew defaultLayoutConfig
    windows     = windowsNew defaultWindowsConfig
      { getMenuLabel   = truncatedGetMenuLabel 120
      , getActiveLabel = truncatedGetActiveLabel 120
      }
    myWorkspacesConfig = defaultWorkspacesConfig
      { minIcons            = 1
      , getWindowIconPixbuf = myIcons
      , widgetGap           = 0
      , showWorkspaceFn     =
        \w ->
          foldr (&&) True $ map ($ w) [hideEmpty, ("NSP" /=) . workspaceName]
      }
    myIcons =
      scaledWindowIconPixbufGetter
        $     unscaledDefaultGetWindowIconPixbuf
        <|||> (\size _ -> lift $ loadPixbufByName size "utilities-terminal")
    workspaces       = workspacesNew myWorkspacesConfig
    myTaffybarConfig = defaultSimpleTaffyConfig
      { barHeight    = 48
      , startWidgets = workspaces : map (>>= buildContentsBox) [layout, windows]
      , endWidgets   = [clock, tray, battery, batteryIcon, mem, cpu]
      }
  startTaffybar $ withLogServer $ toTaffyConfig myTaffybarConfig
