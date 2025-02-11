library(tidyverse)

d = readRDS('Rawdata.rds')

d = d %>%
  filter(season.type == 'reg') %>%
  select(-lg, -season.type)

head(d,2)
tail(d,2)

## pivot out all of the metrics to be columns for easier data manipulation
dd = d %>%
  pivot_wider(names_from = name, values_from = value)

head(dd)

## gp - game played, 0 if not played
## mins - minutes played
## ## fgm - field goals made
## ## fga - field goals attempted
## ## fgp - field goal percentage
## fg3m - three point field goals made
## fg3a - three point field goals attempted
## ## fg3p - three point field goal percentage
## ftm - free throws made
## fta - free throws attempted
## ## ftp - free throw percentage
## oreb - offensive rebounds
## dreb - defensive rebounds
## ## reb - total rebounds
## ast - assists
## stl - steals
## blk - blocks
## to - turnovers (times it turns over while this player was in possession of the ball?)
## pf - personal fouls
## pts - points (total points they scored)
## pm - plus minus (what does this numerically represent?)
## ## e.off.rat - offensive efficiency (?)
## off.rat - offensive rating
## ## e.def.rat - defensive efficiency (?)
## def.rat - defensive rating
## ## e.net.rat - net efficiency, def - off (?)
## net.rat - net rating
## ## ast.p - assist percentage
## ast.tov - assist to turnover (?)
## ## ast.rat - assist ratio
## ## oreb.p - offensive rebound percentage
## ## dreb.p - defensive rebound percentage
## ## reb.p - rebound percentage
## tm.tov - team turnovers
## efg.p - effective field goal percentage
## ts.p - true shooting percentage
## usg.p - usage percentage (?)
## ## e.usg.p - estimated usage percentage (?)
## ## e.pace - estimated pace
## pace - pace
## ## pace40 - pace per 40 minutes
## poss - possessions
## pie - player impact estimate (?)
## fg2m - two point field goals made
## fg2a - two point field goals attempted
## ## fg2p - two point field goal percentage removed because there are NA's due to fg2a = 0

## remove columns that are not relevant to PCA, filter out player seasons that are gp = 0
dd = dd %>%
  select(
    -'fga',
    -'fgp',
    -'fg3p',
    -'ftp',
    -'reb',
    -'e.off.rat',
    -'e.def.rat',
    -'e.net.rat',
    -'ast.p',
    -'ast.rat',
    -'oreb.p',
    -'dreb.p',
    -'reb.p',
    -'e.usg.p',
    -'e.pace',
    -'pace40',
    -'fg2p') %>%
  filter(gp == 1)

# head(dd) 

# dd %>%
#   filter(pid == c('1627773', '201985'))

## sum (mins, fgm, fga, fg3m, fg3a, ftm, fta, oreb, dreb, reb, ast, stl, blk, to, pf, pts, poss, fg2m, fg2a) and average (fgp, fg3p, ftp, pm, off.rat, def. rat, net.rat, ast.p, ast.tov, ast.rat, tm.tov, efg.p. ts.p, esg.p, pace, pie, fg2p) values to group by player, team, season, pid, tid, ; filtering out game-level data ('date', 'gp', 'gid', )

dd %>% 
  group_by(player, team, season, pid, tid) %>%
  summarise(total.mins = sum(mins),
            #total.fg3m = sum(fg3m),
            total.fgm = sum(fgm),
            #total.fg3a = sum(fg3a),
            total.ftm = sum(ftm),
            #total.fta = sum(fta),
            total.oreb = sum(oreb),
            total.dreb = sum(dreb),
            total.ast = sum(ast),
            total.stl = sum(stl),
            total.blk = sum(blk),
            total.to = sum(to),
            total.pf = sum(pf),
            total.pts = sum(pts),
            total.poss = sum(poss),
            #total.fg2m = sum(fg2m),
            #total.fg2a = sum(fg2a),
            avg.pm = mean(pm),
            avg.off.rat = mean(off.rat),
            avg.def.rat = mean(def.rat),
            avg.net.rat = mean(net.rat),
            #avg.ast.tov = mean(ast.tov),
            #avg.tm.tov = mean(tm.tov),
            avg.efg.p = mean(efg.p),
            avg.ts.p = mean(ts.p),
            avg.usg.p = mean(usg.p),
            avg.pace = mean(pace),
            avg.pie = mean(pie)
  ) %>%
  ungroup() -> dd

## limit the data to only be 2022-2023 season
dd = dd %>%
  filter(season == 2022)

## save dd as a .rds file
saveRDS(dd, "Data.rds")
