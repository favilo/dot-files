import           Data.Maybe                               (fromMaybe)
import           System.Environment                       (getArgs)
import           System.Taffybar

import           System.Taffybar.Battery
import           System.Taffybar.FreedesktopNotifications
import           System.Taffybar.MPRIS
import           System.Taffybar.Pager
import           System.Taffybar.SimpleClock
import           System.Taffybar.Systray
import           System.Taffybar.TaffyPager

import           System.Taffybar.Widgets.PollingBar
import           System.Taffybar.Widgets.PollingGraph

import           System.Information.CPU
import           System.Information.Memory

import           Text.Read                                (readMaybe)

memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback = do
  (userLoad, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

main = do
  args <- getArgs
  let memCfg = defaultGraphConfig { graphDataColors = [(1, 0, 0, 1)]
                                  , graphLabel = Just "mem"
                                  }
      cpuCfg = defaultGraphConfig { graphDataColors = [ (0, 1, 0, 1)
                                                      , (1, 0, 1, 0.5)
                                                      ]
                                  , graphLabel = Just "cpu"
                                  }
      chosenMonitorNumber = fromMaybe 0 $ readMaybe $ head args
  let clock = textClockNew Nothing "%a %b %_d %H:%M" 1
      pager = taffyPagerNew defaultPagerConfig
      note = notifyAreaNew defaultNotificationConfig
      mem = pollingGraphNew memCfg 1 memCallback
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      tray = systrayNew
      mpris = mprisNew defaultMPRISConfig
      battery = batteryBarNew defaultBatteryConfig 60
      myTaffybarConfig = defaultTaffybarConfig {
          barHeight = 24
        , startWidgets = [ pager, note ]
        , endWidgets = [ clock, tray, battery, mem, cpu, mpris ]
        , monitorNumber = chosenMonitorNumber
      }
  defaultTaffybar myTaffybarConfig
