install.packages("ggplot2")
library(ggplot2)
install.packages("stargazer")
library(stargazer)
data = read.csv('../dataset/NicheSonarMergedCleaned.csv')

pythonic_cols <- c("PY_Assign.Multi.Targets", "PY_Call.Star", "PY_List.Comprehension", "PY_Dict.Comprehension", 
                   "PY_Set.Comprehension", "PY_Truth.Value.Test", "PY_Chain.Compare", "PY_For.Multi.Targets", 
                   "PY_For.Else")

non_pythonic_cols <- c("Assign.Multi.Targets", "Call.Star", "List.Comprehension", "Dict.Comprehension", 
                       "Set.Comprehension", "Truth.Value.Test", "Chain.Compare", "For.Multi.Targets", 
                       "For.Else")

data$Pythonic_density <- data$tot_pythonic / data$ncloc

for (idiom in c(pythonic_cols, non_pythonic_cols)) {
  density_col <- paste0(idiom, "_density")
  data[[density_col]] <- ifelse(data$ncloc == 0, NA, data[[idiom]] / data$ncloc)
}
# Single idioms percentages
for (i in 1:length(pythonic_cols)) {
  py_col <- pythonic_cols[i]
  non_py_col <- non_pythonic_cols[i]

  percentage_col <- paste0(py_col, "_Percentage")

  data[[percentage_col]] <- data[[py_col]] / (data[[py_col]] + data[[non_py_col]])
}

# Single non idioms percentages
for (i in 1:length(pythonic_cols)) {
  py_col <- pythonic_cols[i]
  non_py_col <- non_pythonic_cols[i]
  
  # Nome della nuova colonna per la percentuale
  percentage_col <- paste0(non_py_col, "_Percentage")
  
  # Calcolo della percentuale e aggiunta al dataframe
  data[[percentage_col]] <- data[[non_py_col]] / (data[[py_col]] + data[[non_py_col]])
}

idiom_percentage_cols <- c("PY_Assign.Multi.Targets_Percentage", "PY_Call.Star_Percentage", 
                           "PY_List.Comprehension_Percentage", "PY_Dict.Comprehension_Percentage", 
                           "PY_Set.Comprehension_Percentage", "PY_Truth.Value.Test_Percentage", 
                           "PY_Chain.Compare_Percentage", "PY_For.Multi.Targets_Percentage", 
                           "PY_For.Else_Percentage")

non_idiom_percentage_cols <- c("Assign.Multi.Targets_Percentage", "Call.Star_Percentage", 
                               "List.Comprehension_Percentage", "Dict.Comprehension_Percentage", 
                               "Set.Comprehension_Percentage", "Truth.Value.Test_Percentage", 
                               "Chain.Compare_Percentage", "For.Multi.Targets_Percentage", 
                               "For.Else_Percentage")

data[idiom_percentage_cols] <- lapply(data[idiom_percentage_cols], function(x) {
  ifelse(is.na(x), 0, x)
})

data[non_idiom_percentage_cols] <- lapply(data[non_idiom_percentage_cols], function(x) {
  ifelse(is.na(x), 0, x)
})

data$ncloc_per_file <- data$ncloc / data$files
data$violations_density = data$violations / data$ncloc

# IDIOMS PERCENTAGES vs CS DENSITY
independent_vars <- c(idiom_percentage_cols, "file_complexity", "ncloc_per_file")
model_formula <- as.formula(paste("violations_density ~", paste(independent_vars, collapse = " + ")))
model <- glm(model_formula, family = Gamma(link = "log"), data = data)
summary(model)


# IDIOMS PERCENTAGES vs CS
independent_vars <- c(idiom_percentage_cols, "complexity", "ncloc")
model_formula <- as.formula(paste("violations ~", paste(independent_vars, collapse = " + ")))
# NOT WORKING
model <- glm(model_formula, family = Gamma(link = "log"), data = data)
summary(model)


# NON IDIOMS PERCENTAGES vs CS DENSITY
independent_vars <- c(non_idiom_percentage_cols, "file_complexity", "ncloc_per_file")
model_formula <- as.formula(paste("violations_density ~", paste(independent_vars, collapse = " + ")))
model <- glm(model_formula, family = Gamma(link = "log"), data = data)
summary(model)



# PYTHONIC PERCENTAGE vs CS DENSITY
model_formula <- as.formula(paste("violations_density ~", "pythonic_percentage + ncloc_per_file + file_complexity"))
model <- glm(model_formula, family = Gamma(link = "log"), data = data)
summary(model)

# PYTHONIC PERCENTAGE vs CS
model_formula <- as.formula(paste("violations ~", "pythonic_percentage + ncloc + complexity"))
model <- glm(model_formula, family = Gamma(link = "log"), data = data)
summary(model)

# IDIOMS vs CS
model_formula <- as.formula(paste("violations ~", paste(pythonic_cols, collapse = " + ")," + ncloc + complexity"))
model <- glm(model_formula, family = Gamma(link = "log"), data = data)
summary(model)

# NON PYTHONIC vs CS 
model_formula <- as.formula(paste("violations ~", paste(non_pythonic_cols, collapse = " + ")," + ncloc + complexity"))
model <- glm(model_formula, family = Gamma(link = "log"), data = data)
summary(model)

# PYTHONIC DENSITY vs CS DENSITY
model_formula <- as.formula(paste("violations_density ~ Pythonic_density + ncloc + complexity"))
model <- glm(model_formula, family = Gamma(link = "log"), data = data)
summary(model)


pythonic_density_cols <- paste0(pythonic_cols, "_density")

# IDIOMS DENSITIES VS CS DENSITY
model_formula <- as.formula(paste("violations_density ~ ", paste(pythonic_density_cols, collapse = " + "),"+ ncloc_per_file + file_complexity"))
model <- glm(model_formula, family = Gamma(link = "log"), data = data)
summary(model)



non_pythonic_density_cols <- paste0(non_pythonic_cols, "_density")

# NON PYTHONIC DENSITIES VS CS DENSITY
model_formula <- as.formula(paste("violations_density ~ ", paste(non_pythonic_density_cols, collapse = " + "),"+ ncloc_per_file + file_complexity"))
model <- glm(model_formula, family = Gamma(link = "log"), data = data)
summary(model)

# NON PYTHONIC PERCENTAGE VS CS DENSITY
data$non_pythonic_percentage = 1 - data$pythonic_percentage
model_formula <- as.formula(paste("violations_density ~", "non_pythonic_percentage + ncloc_per_file + file_complexity"))
model <- glm(model_formula, family = Gamma(link = "log"), data = data)
summary(model)







