install.packages("ggplot2")
library(ggplot2)

data = read.csv('../dataset/NicheSonarMergedCleaned.csv')





#----------------------------------------------------------------------------------------------#
#boxplot violations density based on Engineered-ML-Project
data$violations_density = data$violations / data$ncloc
boxplot_gg <- ggplot(data, aes(x = factor(Engineered.ML.Project), y = violations_density)) +
  geom_boxplot(aes(fill = factor(Engineered.ML.Project)), color = "black", outlier.color = "black", outlier.shape = 16) +
  scale_fill_manual(values = c("0" = "red", "1" = "green")) +
  labs(title = "Violations Density by Engineered ML Project",
       x = "Engineered ML Project",
       y = "Violations Density") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10))
median_group_0 <- median(data$violations_density[data$Engineered.ML.Project == 0], na.rm = TRUE)
median_group_1 <- median(data$violations_density[data$Engineered.ML.Project == 1], na.rm = TRUE)




data$blocker_violations_density = data$blocker_violations / data$ncloc
wilcox.test(blocker_violations_density ~ Engineered.ML.Project, data = data)

data$critical_violations_density = data$critical_violations / data$ncloc
wilcox.test(critical_violations_density ~ Engineered.ML.Project, data = data)

data$major_violations_density = data$major_violations / data$ncloc
wilcox.test(major_violations_density ~ Engineered.ML.Project, data = data)

boxplot_gg <- ggplot(data, aes(x = factor(Engineered.ML.Project), y = major_violations_density)) +
  geom_boxplot(aes(fill = factor(Engineered.ML.Project)), color = "black", outlier.color = "black", outlier.shape = 16) +
  scale_fill_manual(values = c("0" = "red", "1" = "green")) +
  labs(title = "Major Code Smell Density by Engineered ML Project",
       x = "Engineered ML Project",
       y = "Major Code Smells Density") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10))
ggsave(paste0("C:\\Users\\Gerardo\\PycharmProjects\\Phytonify\\thesis_img\\RQ2\\Boxplot_MAJORSmells_engineered.png"), 
       plot = boxplot_gg, width = 8, height = 6, dpi = 300)



data$minor_violations_density = data$minor_violations / data$ncloc
wilcox.test(minor_violations_density ~ Engineered.ML.Project, data = data)

data$info_violations_density = data$info_violations / data$ncloc
wilcox.test(info_violations_density ~ Engineered.ML.Project, data = data)

boxplot_gg <- ggplot(data, aes(x = factor(Engineered.ML.Project), y = info_violations_density)) +
  geom_boxplot(aes(fill = factor(Engineered.ML.Project)), color = "black", outlier.color = "black", outlier.shape = 16) +
  scale_fill_manual(values = c("0" = "red", "1" = "green")) +
  labs(title = "Info Code Smell Density by Engineered ML Project",
       x = "Engineered ML Project",
       y = "Info Code Smells Density") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10))





wilcox.test(violations ~ Engineered.ML.Project, data = data)

wilcox.test(violations_density ~ Engineered.ML.Project, data = data)
#FINDING: VIOLATIONS DENSITY IS DIFFERENT BETWEEN ENGINEERED AND NON-ENGINEERED PROJECTS, AS EXPECTED
#----------------------------------------------------------------------------------------------#