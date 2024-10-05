library(ggplot2)
library(reshape2)
library(xtable)

df <- read.csv('../dataset/NicheSonarMergedCleaned.csv')

new_names <- c("Assign Multi Targets", "Call Star", "List Comprehension", "Dict Comprehension", 
               "Set Comprehension", "Truth Value Test", "Chain Compare", "For Multi Targets", 
               "For Else")

# Pythonic cols
py_columns <- df[, grepl("^PY_", names(df))]

sums_py <- colSums(py_columns, na.rm = TRUE)

# Df to plot
sums_df_py <- data.frame(Category = new_names, Sum = sums_py)


plot_py <- ggplot(sums_df_py, aes(x = factor(Category, levels = new_names), y = Sum)) +  
  geom_bar(stat = "identity", fill = "#0073C2FF", color = "black", width = 0.7) +  
  geom_text(aes(label = Sum), vjust = -0.3, size = 3.5) +  
  labs(title = "Pythonic Idioms Frequencies", x = "Idiom", y = "Total") +  
  theme_minimal() +  
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10),  
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),  
        axis.title.x = element_text(size = 12, face = "bold"),  
        axis.title.y = element_text(size = 12, face = "bold"),  
        panel.grid.major = element_line(size = 0.5, linetype = 'solid', color = "grey80"),  
        panel.grid.minor = element_blank())  


# Non Pythonic
non_py_columns <- df[, c("Assign.Multi.Targets", "Call.Star", "List.Comprehension", "Dict.Comprehension", 
                         "Set.Comprehension", "Truth.Value.Test", "Chain.Compare", "For.Multi.Targets", 
                         "For.Else")]

sums_non_py <- colSums(non_py_columns, na.rm = TRUE)

sums_df_non_py <- data.frame(Category = new_names, Sum = sums_non_py)

plot_non_py <- ggplot(sums_df_non_py, aes(x = factor(Category, levels = new_names), y = Sum)) +  
  geom_bar(stat = "identity", fill = "red", color = "black", width = 0.7) +  
  geom_text(aes(label = Sum), vjust = -0.3, size = 3.5) +  
  labs(title = "Non Pythonic Frequencies", x = "Idiom", y = "Total") +  
  theme_minimal() +  
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10),  
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),  
        axis.title.x = element_text(size = 12, face = "bold"),  
        axis.title.y = element_text(size = 12, face = "bold"),  
        panel.grid.major = element_line(size = 0.5, linetype = 'solid', color = "grey80"),  
        panel.grid.minor = element_blank())  


combined_df <- data.frame(Category = new_names, Pythonic = sums_py, Non_Pythonic = sums_non_py)


melted_df <- melt(combined_df, id.vars = "Category")

stacked_plot <- ggplot(melted_df, aes(x = factor(Category, levels = new_names), y = value, fill = variable)) + 
  geom_bar(stat = "identity", color = "black", width = 0.7, position = "stack") + 
  geom_text(aes(label = value), position = position_stack(vjust = 0.5), size = 3.5, color = "white") + 
  scale_fill_manual(values = c("Pythonic" = "#0073C2FF", "Non_Pythonic" = "red")) +  
  labs(title = "Stacked Pythonic and Non-Pythonic Frequencies", x = "Idiom", y = "Total", fill = "Type") + 
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10), 
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"), 
        axis.title.x = element_text(size = 12, face = "bold"), 
        axis.title.y = element_text(size = 12, face = "bold"),
        panel.grid.major = element_line(size = 0.5, linetype = 'solid', color = "grey80"), 
        panel.grid.minor = element_blank())

       
       
pythonic_columns <- df[, c("PY_Assign.Multi.Targets", "PY_Call.Star", "PY_List.Comprehension", "PY_Dict.Comprehension", 
                           "PY_Set.Comprehension", "PY_Truth.Value.Test", "PY_Chain.Compare", "PY_For.Multi.Targets", 
                           "PY_For.Else", "ncloc")]
non_pythonic_columns <- df[, c("Call.Star", "List.Comprehension", "Dict.Comprehension", 
                              "Set.Comprehension", "Truth.Value.Test", "Chain.Compare", "For.Multi.Targets", 
                              "For.Else", "ncloc")]




melted_pythonic <- melt(pythonic_columns, id.vars = "ncloc")
melted_non_pythonic <- melt(non_pythonic_columns, id.vars = "ncloc")


pythonic_line_plot <- ggplot(melted_pythonic, aes(x = ncloc, y = value, color = variable)) + 
 geom_line(size = 1) + 
 geom_point(size = 2) + 
 labs(title = "Trend of Pythonic Idioms by ncloc", x = "Lines of Code (ncloc)", y = "Frequency", color = "Idiom") + 
 theme_minimal() + 
 theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"), 
       axis.title.x = element_text(size = 12, face = "bold"), 
       axis.title.y = element_text(size = 12, face = "bold"),
       legend.title = element_text(size = 10, face = "bold"),
       legend.text = element_text(size = 9),
       panel.grid.major = element_line(size = 0.5, linetype = 'solid', color = "grey80"), 
       panel.grid.minor = element_blank())




non_pythonic_line_plot <- ggplot(melted_non_pythonic, aes(x = ncloc, y = value, color = variable)) + 
 geom_line(size = 1) + 
 geom_point(size = 2) + 
 labs(title = "Trend of Non-Pythonic Idioms by ncloc", x = "Lines of Code (ncloc)", y = "Frequency", color = "Idiom") + 
 theme_minimal() + 
 theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"), 
       axis.title.x = element_text(size = 12, face = "bold"), 
       axis.title.y = element_text(size = 12, face = "bold"),
       legend.title = element_text(size = 10, face = "bold"),
       legend.text = element_text(size = 9),
       panel.grid.major = element_line(size = 0.5, linetype = 'solid', color = "grey80"), 
       panel.grid.minor = element_blank())








# 1. Pythonic Percentage vs. ncloc
pythonic_percentage_plot <- ggplot(df, aes(x = ncloc, y = pythonic_percentage)) + 
  geom_line(color = "#0073C2FF", size = 1) + 
  geom_point(color = "#0073C2FF", size = 2) + 
  labs(title = "Pythonic Percentage vs. ncloc", x = "Lines of Code (ncloc)", y = "Pythonic Percentage") + 
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"), 
        axis.title.x = element_text(size = 12, face = "bold"), 
        axis.title.y = element_text(size = 12, face = "bold"),
        panel.grid.major = element_line(size = 0.5, linetype = 'solid', color = "grey80"), 
        panel.grid.minor = element_blank())


# 2. Total Non-Pythonic vs. ncloc
tot_non_pythonic_plot <- ggplot(df, aes(x = ncloc, y = tot_non_pythonic)) + 
  geom_line(color = "red", size = 1) + 
  geom_point(color = "red", size = 2) + 
  labs(title = "Total Non-Pythonic vs. ncloc", x = "Lines of Code (ncloc)", y = "Total Non-Pythonic") + 
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"), 
        axis.title.x = element_text(size = 12, face = "bold"), 
        axis.title.y = element_text(size = 12, face = "bold"),
        panel.grid.major = element_line(size = 0.5, linetype = 'solid', color = "grey80"), 
        panel.grid.minor = element_blank())



# 3. Total Pythonic vs. ncloc
tot_pythonic_plot <- ggplot(df, aes(x = ncloc, y = tot_pythonic)) + 
  geom_line(color = "#0073C2FF", size = 1) + 
  geom_point(color = "#0073C2FF", size = 2) + 
  labs(title = "Total Pythonic vs. ncloc", x = "Lines of Code (ncloc)", y = "Total Pythonic") + 
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"), 
        axis.title.x = element_text(size = 12, face = "bold"), 
        axis.title.y = element_text(size = 12, face = "bold"),
        panel.grid.major = element_line(size = 0.5, linetype = 'solid', color = "grey80"), 
        panel.grid.minor = element_blank())


ggsave("C:\\Users\\Gerardo\\PycharmProjects\\Phytonify\\thesis_img\\Total_Pythonic_vs_ncloc.png", plot = tot_pythonic_plot, width = 10, height = 6, dpi = 300)







df$pythonic_density <- df$tot_pythonic / df$ncloc
df$non_pythonic_density <- df$tot_non_pythonic / df$ncloc

# Plot Pythonic Density vs. ncloc
pythonic_density_plot <- ggplot(df, aes(x = ncloc, y = pythonic_density)) + 
  geom_line(color = "#0073C2FF", size = 1) + 
  geom_point(color = "#0073C2FF", size = 2) + 
  labs(title = "Pythonic Density vs. ncloc", x = "Lines of Code (ncloc)", y = "Pythonic Density") + 
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"), 
        axis.title.x = element_text(size = 12, face = "bold"), 
        axis.title.y = element_text(size = 12, face = "bold"),
        panel.grid.major = element_line(size = 0.5, linetype = 'solid', color = "grey80"), 
        panel.grid.minor = element_blank())


# Plot Non-Pythonic Density vs. ncloc
non_pythonic_density_plot <- ggplot(df, aes(x = ncloc, y = non_pythonic_density)) + 
  geom_line(color = "red", size = 1) + 
  geom_point(color = "red", size = 2) + 
  labs(title = "Non-Pythonic Density vs. ncloc", x = "Lines of Code (ncloc)", y = "Non-Pythonic Density") + 
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"), 
        axis.title.x = element_text(size = 12, face = "bold"), 
        axis.title.y = element_text(size = 12, face = "bold"),
        panel.grid.major = element_line(size = 0.5, linetype = 'solid', color = "grey80"), 
        panel.grid.minor = element_blank())












# Define columns for Pythonic and Non-Pythonic idioms
pythonic_cols <- c("PY_Assign.Multi.Targets", "PY_Call.Star", "PY_List.Comprehension", "PY_Dict.Comprehension", 
                        "PY_Set.Comprehension", "PY_Truth.Value.Test", "PY_Chain.Compare", "PY_For.Multi.Targets", 
                        "PY_For.Else")
non_pythonic_cols <- c("Assign.Multi.Targets", "Call.Star", "List.Comprehension", "Dict.Comprehension", 
                       "Set.Comprehension", "Truth.Value.Test", "Chain.Compare", "For.Multi.Targets", 
                       "For.Else")

# Calculate densities for each Pythonic and Non-Pythonic idiom
pythonic_densities <- df[, pythonic_cols] / df$ncloc
non_pythonic_densities <- df[, non_pythonic_cols] / df$ncloc

# Rename columns to remove prefixes and make names appropriate for plots
colnames(pythonic_densities) <- gsub("^PY_", "", colnames(pythonic_densities))
colnames(non_pythonic_densities) <- gsub("\\.", " ", colnames(non_pythonic_densities))

# Bind ncloc to density dataframes
pythonic_densities$ncloc <- df$ncloc
non_pythonic_densities$ncloc <- df$ncloc

# Melt the data for plotting
melted_pythonic <- melt(pythonic_densities, id.vars = "ncloc")
melted_non_pythonic <- melt(non_pythonic_densities, id.vars = "ncloc")

# Create Pythonic density plot
pythonic_density_plot <- ggplot(melted_pythonic, aes(x = ncloc, y = value, color = variable)) +
  geom_line() + 
  geom_point() + 
  labs(title = "Density of Pythonic Idioms vs. ncloc", x = "Lines of Code (ncloc)", y = "Density", color = "Idiom") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        panel.grid.major = element_line(size = 0.5, linetype = 'solid', color = "grey80"),
        panel.grid.minor = element_blank())


# Create Non-Pythonic density plot
non_pythonic_density_plot <- ggplot(melted_non_pythonic, aes(x = ncloc, y = value, color = variable)) +
  geom_line() + 
  geom_point() + 
  labs(title = "Density of Non-Pythonic Idioms vs. ncloc", x = "Lines of Code (ncloc)", y = "Density", color = "Idiom") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        axis.title.x = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(size = 12, face = "bold"),
        panel.grid.major = element_line(size = 0.5, linetype = 'solid', color = "grey80"),
        panel.grid.minor = element_blank())





pythonic_density_mean <- mean(df$pythonic_density, na.rm = TRUE)
pythonic_density_sd <- sd(df$pythonic_density, na.rm = TRUE)
pythonic_density_median <- median(df$pythonic_density, na.rm = TRUE)
pythonic_density_variance <- var(df$pythonic_density, na.rm = TRUE)


pythonic_percentage_mean <- mean(df$pythonic_percentage, na.rm = TRUE)
pythonic_percentage_sd <- sd(df$pythonic_percentage, na.rm = TRUE)
pythonic_percentage_median <- median(df$pythonic_percentage, na.rm = TRUE)
pythonic_percentage_variance <- var(df$pythonic_percentage, na.rm = TRUE)

# Combine the results into a data frame
summary_table <- data.frame(
  Statistic = c("Mean", "Standard Deviation", "Median", "Variance"),
  Pythonic_Density = c(pythonic_density_mean, pythonic_density_sd, pythonic_density_median, pythonic_density_variance),
  Pythonic_Percentage = c(pythonic_percentage_mean, pythonic_percentage_sd, pythonic_percentage_median, pythonic_percentage_variance)
)






pythonic_cols <- c("PY_Assign.Multi.Targets", "PY_Call.Star", "PY_List.Comprehension", "PY_Dict.Comprehension", 
                   "PY_Set.Comprehension", "PY_Truth.Value.Test", "PY_Chain.Compare", "PY_For.Multi.Targets", 
                   "PY_For.Else")
non_pythonic_cols <- c("Assign.Multi.Targets", "Call.Star", "List.Comprehension", "Dict.Comprehension", 
                       "Set.Comprehension", "Truth.Value.Test", "Chain.Compare", "For.Multi.Targets", 
                       "For.Else")



summary_data <- data.frame()


for (i in 1:length(pythonic_cols)) {
  
  # Extract Pythonic and Non-Pythonic columns
  py_col <- pythonic_cols[i]
  non_py_col <- non_pythonic_cols[i]
  
  # Calculate Pythonic Percentage
  pythonic_percentage <- df[[py_col]] / (df[[py_col]] + df[[non_py_col]])
  
  # Calculate density
  pythonic_density <- df[[py_col]] / df$ncloc
  
  # Calculate statistics for Pythonic Percentage
  py_percentage_mean <- mean(pythonic_percentage, na.rm = TRUE)
  py_percentage_sd <- sd(pythonic_percentage, na.rm = TRUE)
  py_percentage_median <- median(pythonic_percentage, na.rm = TRUE)
  py_percentage_variance <- var(pythonic_percentage, na.rm = TRUE)
  
  # Calculate statistics for Pythonic Density
  py_density_mean <- mean(pythonic_density, na.rm = TRUE)
  py_density_sd <- sd(pythonic_density, na.rm = TRUE)
  py_density_median <- median(pythonic_density, na.rm = TRUE)
  py_density_variance <- var(pythonic_density, na.rm = TRUE)
  
  # Combine the results into a data frame
  idiom_stats <- data.frame(
    Idiom = gsub("^PY_", "", py_col),
    Pythonic_Percentage_Mean = py_percentage_mean,
    Pythonic_Percentage_SD = py_percentage_sd,
    Pythonic_Percentage_Median = py_percentage_median,
    Pythonic_Percentage_Variance = py_percentage_variance,
    Pythonic_Density_Mean = py_density_mean,
    Pythonic_Density_SD = py_density_sd,
    Pythonic_Density_Median = py_density_median,
    Pythonic_Density_Variance = py_density_variance
  )
  
  # Add the idiom's stats to the summary data frame
  summary_data <- rbind(summary_data, idiom_stats)
}

print(summary_data)
