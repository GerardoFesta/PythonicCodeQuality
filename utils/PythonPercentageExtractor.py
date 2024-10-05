# The scripts only selects active projects and adds python percentage. It saves the data
# in the updated_Niche.csv file. The script uses the GitHub API to get the python percentage

import pandas as pd
from github import Github
import os
from dotenv import load_dotenv



class NicheScraper:
    def __init__(self):
        load_dotenv()
        data_path = os.getenv('NICHE_PATH')
        self.df = pd.read_csv(data_path)
        self.ACCESS_TOKEN = os.getenv('ACCESS_TOKEN')

    def __get_code_language_division(self, repo):
        languages = repo.get_languages()
        total_lines = sum(languages.values())
        if total_lines == 0:
            return 0, 0
        python_lines = languages.get('Python', 0)
        python_percentage = python_lines / total_lines * 100
        return total_lines, python_percentage

    def get_python_percentage(self):
        g = Github(self.ACCESS_TOKEN)
        python_percentage = []
        for repo_name in self.df['GitHub Repo']:
            try:
                repo = g.get_repo(repo_name)
                tot_lines, py_perc = self.__get_code_language_division(repo)
                if tot_lines == 0:
                    self.df.drop(self.df.loc[self.df['GitHub Repo'] == repo_name].index, inplace=True)
                else:
                    python_percentage.append(py_perc)
            except Exception as e:
                print(f"Error: {e}. Skipping repository {repo_name}")
                self.df.drop(self.df.loc[self.df['GitHub Repo'] == repo_name].index, inplace=True)
        self.df['Pyhton_Percentage'] = python_percentage
        self.df.to_csv("./dataset/updated_Niche.csv", index=False)
