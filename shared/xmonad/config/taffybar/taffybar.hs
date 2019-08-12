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

import           System.Information.CPU2
import           System.Information.Memory

import           Text.Read                                (readMaybe)

memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

tempCallback :: Fractional b => [String] -> IO [b]
tempCallback cpu = do
  [a] <- getCPUTemp cpu
  return $ [(fromIntegral a) / 100.0]

colorFuncTemp :: (Fractional a, Num t, Ord a) => a -> (a, a, t)
colorFuncTemp pct
    | pct <= 0.55 = (0, 1 - pct, 0)
    | pct < 0.70 = (pct, 1 - pct, 0)
    | pct < 1 = (pct, 0, 0)
    | otherwise = (1, 1, 1)

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
      tempCfg = defaultGraphConfig { 
                                     graphDataColors = [(1, 0, 0, 1)]
                                   , graphLabel = Just "temp"
                                   }
      chosenMonitorNumber = fromMaybe 0 $ readMaybe $ head args
  let clock = textClockNew Nothing "%a %b %_d %H:%M" 1
      pager = taffyPagerNew defaultPagerConfig
      note = notifyAreaNew defaultNotificationConfig { notificationMaxLength = 250 }
      mem = pollingGraphNew memCfg 1 memCallback
      cpu = pollingGraphNew cpuCfg 0.5 $ getCPULoad "cpu"
      -- temp = pollingGraphNew tempCfg 2 $ tempCallback ["cpu0"]
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
