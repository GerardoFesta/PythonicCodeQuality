install.packages("ggplot2")
library(ggplot2)
library(car)
data = read.csv('../dataset/NicheSonarMergedCleaned.csv')


#-------------------------------------------------------------------#
#PYTHONIC_PERCENTAGE ANALYSIS

boxplot_gg <- ggplot(data, aes(x = factor(Engineered.ML.Project), y = pythonic_percentage)) +
  geom_boxplot(aes(fill = factor(Engineered.ML.Project)), color = "black", outlier.color = "black", outlier.shape = 16) +
  scale_fill_manual(values = c("0" = "red", "1" = "green")) +
  labs(title = "Pythonic Percentage by Engineered Project",
       x = "Engineered",
       y = "Pythonic Percentage",
       fill = "Engineered") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10))

#ASSUMPTIONS FOR T-TEST
shapiro.test(data$pythonic_percentage[data$Engineered.ML.Project == 0])
shapiro.test(data$pythonic_percentage[data$Engineered.ML.Project == 1])

t_test_result <- t.test(pythonic_percentage ~ Engineered.ML.Project, data = data)
print(t_test_result)


#-------------------------------------------------------------------#


# Load necessary library
library(ggplot2)

# Define the Pythonic and Non-Pythonic columns
pythonic_cols <- c("PY_Assign.Multi.Targets", "PY_Call.Star", "PY_List.Comprehension", "PY_Dict.Comprehension", 
                   "PY_Set.Comprehension", "PY_Truth.Value.Test", "PY_Chain.Compare", "PY_For.Multi.Targets", 
                   "PY_For.Else")
non_pythonic_cols <- c("Assign.Multi.Targets", "Call.Star", "List.Comprehension", "Dict.Comprehension", 
                       "Set.Comprehension", "Truth.Value.Test", "Chain.Compare", "For.Multi.Targets", 
                       "For.Else")



# Calculate the Pythonic percentage for each idiom
for (i in 1:length(pythonic_cols)) {
  py_col <- pythonic_cols[i]
  percentage_col <- paste0(py_col, "_Percentage")
  data[[percentage_col]] <- data[[py_col]] / (data[[py_col]] + data[[non_pythonic_cols[i]]])
} 

# Wilcoxon test for each idiom percentage

wilcox.test(PY_Assign.Multi.Targets_Percentage ~ Engineered.ML.Project, data = data)
wilcox.test(PY_Call.Star_Percentage ~ Engineered.ML.Project, data = data)
wilcox.test(PY_List.Comprehension_Percentage ~ Engineered.ML.Project, data = data)
wilcox.test(PY_Dict.Comprehension_Percentage ~ Engineered.ML.Project, data = data)
wilcox.test(PY_Set.Comprehension_Percentage ~ Engineered.ML.Project, data = data)
wilcox.test(PY_Truth.Value.Test_Percentage ~ Engineered.ML.Project, data = data)
wilcox.test(PY_Chain.Compare_Percentage ~ Engineered.ML.Project, data = data)
wilcox.test(PY_For.Multi.Targets_Percentage ~ Engineered.ML.Project, data = data)
wilcox.test(PY_For.Else_Percentage ~ Engineered.ML.Project, data = data)

#Boxplot for Assign.Multi.Targets
boxplot_gg <- ggplot(data, aes(x = factor(Engineered.ML.Project), y = PY_Assign.Multi.Targets_Percentage)) +
  geom_boxplot(aes(fill = factor(Engineered.ML.Project)), color = "black", outlier.color = "black", outlier.shape = 16) +
  scale_fill_manual(values = c("0" = "red", "1" = "green")) +
  labs(title = "Assign.Multi.Targets Percentage by Engineered Project",
       x = "Engineered",
       y = "Assign.Multi.Targets Percentage",
       fill = "Engineered") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10))

#Boxplot for Set.Comprehension
boxplot_gg <- ggplot(data, aes(x = factor(Engineered.ML.Project), y = PY_Set.Comprehension_Percentage)) +
  geom_boxplot(aes(fill = factor(Engineered.ML.Project)), color = "black", outlier.color = "black", outlier.shape = 16) +
  scale_fill_manual(values = c("0" = "red", "1" = "green")) +
  labs(title = "Set.Comprehension Percentage by Engineered Project",
       x = "Engineered",
       y = "Set.Comprehension Percentage",
       fill = "Engineered") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10))

#Boxplot for Truth Value Test
boxplot_gg <- ggplot(data, aes(x = factor(Engineered.ML.Project), y = PY_Truth.Value.Test_Percentage)) +
  geom_boxplot(aes(fill = factor(Engineered.ML.Project)), color = "black", outlier.color = "black", outlier.shape = 16) +
  scale_fill_manual(values = c("0" = "red", "1" = "green")) +
  labs(title = "Truth Value Test Percentage by Engineered Project",
       x = "Engineered",
       y = "Truth Value Test Percentage",
       fill = "Engineered") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10))

#Boxplot for For.Multi.Targets
boxplot_gg <- ggplot(data, aes(x = factor(Engineered.ML.Project), y = PY_For.Multi.Targets_Percentage)) +
  geom_boxplot(aes(fill = factor(Engineered.ML.Project)), color = "black", outlier.color = "black", outlier.shape = 16) +
  scale_fill_manual(values = c("0" = "red", "1" = "green")) +
  labs(title = "For.Multi.Targets Percentage by Engineered Project",
       x = "Engineered",
       y = "For.Multi.Targets Percentage",
       fill = "Engineered") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10))









