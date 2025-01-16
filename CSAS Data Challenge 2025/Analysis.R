# Load libraries
library(dplyr)
library(ggplot2)
library(knitr)
library(GGally)

# Read in the .rds file
# make sure it is created first (Data.rds and not just RawData.rds)
d = readRDS("Data.rds")

# Explore variables
table(d$pitch_type)
table(d$pitch_category)

hist(d$release_speed)

# Create a scatterplot of realease_pos_x, release_pos_z
plot(d$release_pos_x, d$release_pos_z)

# Create a 20% random subsample
d_sample <- d[sample(nrow(d), size = 0.2 * nrow(d)), ]
#plot
plot(d_sample$release_pos_x, d_sample$release_pos_z, main = "Release Point of Pitches", xlab = "Horizontal Release Point", ylab = "Vertical Release Point")
# color by pitch_category
ggplot(d_sample, aes(x = release_pos_x, y = release_pos_z, color = pitch_category)) + geom_point()

table(d$events)

table(d$description)

hist(d$zone)

hist(d$balls)
hist(d$strikes)
hist(d$outs_when_up)

# Create a scatterplot of pf_x, pf_z
plot(d$pfx_x, d$pfx_z)

# Create a scatterplot of plate_x, plate_z
plot(d$plate_x, d$plate_z)

# Create a scatterplot of hc_x, hc_y
# maybe color by home team or something
# check whether needing to switch both x & y data
plot(-d$hc_x, -d$hc_y)

# Create a scatterplot of ax, ay, colored by az
plot(d$ax, d$ay, col=d$az+100)
plot(d$ax, d$az)
plot(d$ay, d$az)

hist(d$launch_speed)
hist(d$launch_angle)

# maybe look into how this corresponds effective_speed
hist(d$release_extension)
hist(d$release_spin_rate)

#interesting, the 20 rows where the delta_run_exp is null are all pitchouts
#not recorded in the event column, put is in the pitch type & description column
d %>%
  filter(is.na(delta_run_exp)) %>%
  select(pitch_type) %>%
  distinct()

#table of the events column
table(d$events)

# show the number of balls and strikes in a table, labeling the axes
table(d$strikes, d$balls)
# label the axes?
kable(table(d$strikes, d$balls))

##THE PLAN
#examining swing lengths and bat speed by count,
#then training a model using the count and bat speed, swing length and any other
#significant predictor to estimate either wOBA or run expectancy

#we will say a swing is a pitch where the swing length and bat speed is not na

# show the number of rows where bat_speed is na
sum(is.na(d$bat_speed))

#show the number of rows where swing_length is na
sum(is.na(d$swing_length))

#histogram of bat_speed
hist(d$bat_speed)

#histogram of swing_length
hist(d$swing_length)

#split data into swings and not swings, a handful of rows lost in translation
swings = d %>%
  filter(!is.na(bat_speed)) %>%
  filter(!is.na(swing_length))

not_swings = d %>%
  filter(is.na(bat_speed)) %>%
  filter(is.na(swing_length))

# scatterplot of bat speed and swing length
plot(swings$bat_speed, swings$swing_length)

# color by pitch category
ggplot(swings, aes(x = bat_speed, y = swing_length, color = pitch_category)) + geom_point()

# correlation between bat speed and swing length
cor(swings$bat_speed, swings$swing_length)

# # examine one batter
head(swings)
explore <- swings %>%
  filter(player_name == "Judge, Aaron") %>%
  select(bat_speed, swing_length, balls, strikes, outs_when_up, pitch_category)

cor(explore$bat_speed, explore$swing_length)

plot(explore$bat_speed, explore$swing_length)
     
# examine swing_length and bat_speed by balls, strikes, and outs
swings %>%
  group_by(balls) %>%
  summarize(mean_bat_speed = mean(bat_speed),
            mean_swing_length = mean(swing_length))
# potential increase in speed, length varies

swings %>%
  group_by(strikes) %>%
  summarize(mean_bat_speed = mean(bat_speed),
            mean_swing_length = mean(swing_length))
# potential decrease in speed, potential decrease or no effect in length

swings %>%
  group_by(outs_when_up) %>%
  summarize(mean_bat_speed = mean(bat_speed),
            mean_swing_length = mean(swing_length))
# potential increase in speed, increase in length

# examine swing_length and bat_speed by pitch category
swings %>%
  group_by(pitch_category) %>%
  summarize(mean_bat_speed = mean(bat_speed),
            mean_swing_length = mean(swing_length))
# nothing obvious except bat speed and swing length seem longer for offspeed balls

# work on model:
# create a training set
train = swings %>%
  select(bat_speed, swing_length, balls, strikes, outs_when_up, pitch_category, estimated_woba_using_speedangle, woba_value, woba_denom, release_pos_x, release_pos_z, release_speed, p_throws, stand) %>%
  sample_frac(0.7)

# create a test set
test = swings %>%
  select(bat_speed, swing_length, balls, strikes, outs_when_up, pitch_category, estimated_woba_using_speedangle, woba_value, woba_denom, release_pos_x, release_pos_z, release_speed) %>%
  anti_join(train)

# train the model
# trying both bat_speed and swing_length
model_length = lm(swing_length ~ balls + strikes + outs_when_up + pitch_category, data=train)
model_speed = lm(bat_speed ~ balls + strikes + outs_when_up + pitch_category, data=train)

# NEXT STEP: change the counts to categories to see what happens
# factor the counts, don't keep them as numeric
model_length_improved = lm(swing_length ~ factor(balls) + factor(strikes) + factor(outs_when_up) + pitch_category, data=train)
model_speed_improved = lm(bat_speed ~ factor(balls) + factor(strikes) + factor(outs_when_up) + pitch_category, data=train)
table(train$pitch_category)

# evaluate the models
summary(model_length)
summary(model_speed)
summary(model_length_improved)
summary(model_speed_improved)

# add interaction term
model_length_improved2 = lm(swing_length ~ factor(balls) * factor(strikes) * factor(outs_when_up) * pitch_category, data=train)
model_speed_improved2 = lm(bat_speed ~ factor(balls) * factor(strikes) * factor(outs_when_up) * pitch_category, data=train)

# evaluate the models
summary(model_length_improved2)
summary(model_speed_improved2)
# lower R-squared, much more complicated to try to interpret

# predict the swing length
predict(model_length, test)

# compare the predicted swing length to the actual swing length
test %>%
  mutate(predicted_swing_length = predict(model, test)) %>%
  select(swing_length, predicted_swing_length)

# compare the values by plotting them
test %>%
  mutate(predicted_swing_length = predict(model, test)) %>%
  ggplot(aes(x=swing_length, y=predicted_swing_length, color = pitch_category)) +
  geom_point()

# change x and y limits
test %>%
  mutate(predicted_swing_length = predict(model_length_improved, test)) %>%
  ggplot(aes(x=swing_length, y=predicted_swing_length, color = pitch_category)) +
  geom_point() +
  coord_cartesian(xlim = c(0, 10), ylim = c(6.5, 8.25))
# regression to mean


# compare the predicted bat speed to the actual bat speed
test %>%
  mutate(predicted_bat_speed = predict(model_speed_improved, test)) %>%
  ggplot(aes(x=bat_speed, y=predicted_bat_speed, color = pitch_category)) +
  geom_point() +
  coord_cartesian(xlim = c(0, 90), ylim = c(65, 75))

# NEXT STEP: check what the clumps of points are - confirm they are bunts
# show 5 rows of the d where the bat speed is less than 20 and the swing length is less than 2
head(d %>%
       filter(bat_speed < 20) %>%
       filter(swing_length < 2), 20)
#so, the lower cloud on the batspeed swing length plot is largely bunts

# model to predict wOBA or run expectancy
d$estimated_woba_using_speedangle # we want field-independent - use this metric
d$woba_value
d$woba_denom
d$delta_run_exp

# examine other variable:
head(swings$delta_run_exp)
head(not_swings$delta_run_exp)

# wOBA model
model1 = lm(estimated_woba_using_speedangle ~ bat_speed + swing_length, data=train)
summary(model1)

model2 = lm(estimated_woba_using_speedangle ~ bat_speed + swing_length + factor(balls) + factor(strikes) + factor(outs_when_up) + pitch_category, data=train)
summary(model2)
# there was an increase in R-squared values compared to model 1
# pitch_category does not seem significant except for fastballs (when compared to reference: breaking balls)

model3 = lm(estimated_woba_using_speedangle ~ bat_speed + swing_length + factor(balls) + factor(strikes) + factor(outs_when_up), data=train)
summary(model3)

model4 = lm(woba_value ~ bat_speed + swing_length + factor(balls) + factor(strikes) + factor(outs_when_up), data=train)
summary(model4)
# models using estimated version are better

# now include more metrics that are helpful for predicting wOBA

# model 5
# include location and speed of pitch in model
# could break into regions and do categorical
model5 = lm(estimated_woba_using_speedangle ~ bat_speed + swing_length + factor(balls) + factor(strikes) + factor(outs_when_up) + pitch_category + release_pos_x + release_pos_z + release_speed, data=train)
summary(model5)

# model 6
# examine stand and p_throws - what side is batter, what hand is pitcher
model6 = lm(estimated_woba_using_speedangle ~ bat_speed + swing_length + factor(balls) + factor(strikes) + factor(outs_when_up) + pitch_category + release_pos_x + release_pos_z + release_speed + p_throws + stand, data=train)
summary(model6)
# neither one is a significant predictor or wOBA

# predict the wOBA
predict(model3, test)

# compare the predicted wOBA to the actual wOBA
test %>%
  mutate(predicted_woba = predict(model2, test)) %>%
  select(estimated_woba_using_speedangle, predicted_woba)

# compare the values by plotting them
test %>%
  mutate(predicted_woba = predict(model2, test)) %>%
  ggplot(aes(x=estimated_woba_using_speedangle, y=predicted_woba)) +
  geom_point()

# add line at x = y
test %>%
  mutate(predicted_woba = predict(model2, test)) %>%
  ggplot(aes(x=estimated_woba_using_speedangle, y=predicted_woba)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1)

# scatterplot of all predictors with outcome - to see nonlinear relationship
corrplot::corrplot(cor(swings[,c("bat_speed", "swing_length", "balls", "strikes", "outs_when_up")]), method = "number")
# use ggpairs()
ggpairs(swings[,c("bat_speed", "swing_length", "balls", "strikes", "outs_when_up")])


# future work:

# could also break into stages - if you do or do not swing, what is the wOBA
# expected wOBA of next state
# could also use expected runs matrix
# what if I don't swing and it's called a strike, or a ball?

# interaction terms?

# term for batter and pitcher? mixed effects model

#also look at cases where they dont swing and use as training set for 
#when batters should have swung, using the swings as training set (resulting wOBA)
