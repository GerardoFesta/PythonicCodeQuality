import pandas as pd

niche = pd.read_csv("../dataset/updated_Niche_with_Idioms.csv")
sonar = pd.read_csv("../dataset/sonarcloud_results.csv")

# Merge the two dataframes
merged = niche.merge(sonar, on="GitHub Repo")
merged.to_csv("../dataset/NicheSonarMerged.csv", index=False)