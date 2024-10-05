import pandas as pd
import os

current_directory = os.path.dirname(os.path.abspath(__file__))
niche = pd.read_csv(os.path.join(current_directory,"../dataset/updated_Niche_with_Idioms.csv"))
sonar = pd.read_csv(os.path.join(current_directory,"../dataset/sonarcloud_results.csv"))

# Merge the two dataframes
merged = niche.merge(sonar, on="GitHub Repo")
merged.to_csv(os.path.join(current_directory,"../dataset/NicheSonarMerged.csv"), index=False)