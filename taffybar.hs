import System.Taffybar

import System.Taffybar.Battery
import System.Taffybar.Systray
import System.Taffybar.XMonadLog
import System.Taffybar.SimpleClock
-- import System.Taffybar.FreedesktopNotifications

import System.Taffybar.Widgets.PollingBar
import System.Taffybar.Widgets.PollingGraph

import System.Information.Memory
import System.Information.CPU

memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback = do
  (userLoad, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

main = do
  let memCfg = defaultGraphConfig { graphDataColors = [(1, 0, 0, 1)]
                                  , graphLabel = Just "mem"
                                  }
      cpuCfg = defaultGraphConfig { graphDataColors = [ (0, 1, 0, 1)
                                                      , (1, 0, 1, 0.5)
                                                      ]
                                  , graphLabel = Just "cpu"
                                  }
  let clock = textClockNew Nothing "%a %b %_d %H:%M" 1
      log = xmonadLogNew
      mem = pollingGraphNew memCfg 1 memCallback
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      tray = systrayNew
      battery = batteryBarNew defaultBatteryConfig 60
  defaultTaffybar defaultTaffybarConfig {
      barHeight = 24
    , startWidgets = [ log ]
    , endWidgets = [ clock, tray, battery, mem, cpu ]
  }

