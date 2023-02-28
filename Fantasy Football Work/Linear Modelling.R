library(gam)

mids_fwds.data <- read.csv("midfielders_forwards_data.csv")

head(mids_fwds.data)

names(mids_fwds.data)

#specify final predictors for modelling
drop_vars <- c("start_time", "player_id", "fix_id", "points", "game_diff"
               , "team_qual", "position_Defender", "position_Midfielder"
               , "X3G_avg_minutes", "X3G_avg_bonus", "X3G_avg_goals_scored"
               , "X3G_avg_assists", "X3G_avg_goals_scored_qual", "X3G_avg_assists_qual")

#filter data
X <- mids_fwds.data[, !names(mids_fwds.data) %in% drop_vars]
head(X)

#set response for regression
y <- mids_fwds.data$points

#model fitting
linear_fit <- lm(y ~ ., data = X) 
fit

#set number of folds
k <- 10
#use second filtered data set
data <- mids_fwds.data
n <- nrow(data)
#set response and predictors
y_var <- c("points")
X_vars_drops <- drop_vars

#create vector of fold rmses
linear_rmse_cv <- rep(0, k)

#set vector of fold indexes, specifies which observations belong to each fold
fold_idx <- sample(cut(1:n, breaks = k, labels = FALSE)) 

#loop through each fold
for (j in 1:k) {
  
  #get the k-th fold for test data
  test_idx <- which(fold_idx == j)
  #data not in k-th fold becomes training set
  train_set <- data[-test_idx, ]
  train_X <- train_set[ ,!names(train_set) %in% X_vars_drops]
  train_y <- train_set[ ,y_var]
  
  #set test set
  test_set <- data[test_idx, ]
  #specify test predictor and y data
  test_X <- test_set[ ,!names(test_set) %in% X_vars_drops]
  test_y <- test_set[ ,y_var]
  
  #fit gam without specifying spline degrees of freedome
  linear_model_cv <- lm(train_y ~ ., data = train_X)
  
  #predict using test data
  y_hat <- predict(linear_model_cv, test_X)
  
  #append RMSE of k-th fold to rmse vector
  linear_rmse_cv[j] <- sqrt(mean((test_y - y_hat)^2))
}

#mean of 10-fold CV RMSEs
mean_linear_rmse_cv <- mean(linear_rmse_cv)

print(mean_linear_rmse_cv)

#summary output to show evidence of non-linearity in variable effects
summary(linear_model_cv)

plot(linear_model_cv)




# Generalized Additive Model

#set number of folds
k <- 10
#use second filtered data set
data <- mids_fwds.data
n <- nrow(data)
#set response and predictors
y_var <- c("points")
X_vars_drops <- drop_vars

#create vector of fold rmses
gam_rmse_cv <- rep(0, k)

#set vector of fold indexes, specifies which observations belong to each fold
fold_idx <- sample(cut(1:n, breaks = k, labels = FALSE)) 

#loop through each fold
for (j in 1:k) {
  
  #get the k-th fold for test data
  test_idx <- which(fold_idx == j)
  #data not in k-th fold becomes training set
  train_set <- data[-test_idx, ]
  train_X <- train_set[ ,!names(train_set) %in% X_vars_drops]
  train_y <- train_set[ ,y_var]
  
  #set test set
  test_set <- data[test_idx, ]
  #specify test predictor and y data
  test_X <- test_set[ ,!names(test_set) %in% X_vars_drops]
  test_y <- test_set[ ,y_var]
  
  #fit gam without specifying spline degrees of freedome
  model_cv <- gam(train_y ~ s(qual_diff) + below_half + s(influence) + s(creativity) +
                    s(threat) + position_Forward + is_home_game + s(X3G_avg_points) +
                    X3G_sum_brace_or_more
                  , data=train_set)
  
  #predict using test data
  y_hat <- predict(model_cv, test_X)
  
  #append RMSE of k-th fold to rmse vector
  gam_rmse_cv[j] <- sqrt(mean((test_y - y_hat)^2))
}

#mean of 10-fold CV RMSEs
mean_gam_rmse_cv <- mean(gam_rmse_cv)
print(mean_gam_rmse_cv)

#summary output to show evidence of non-linearity in variable effects
summary(model_cv)

#plot smoothing function of variables from GAM
plot(model_cv, se = TRUE)
