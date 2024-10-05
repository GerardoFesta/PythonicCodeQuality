import json
import os
import shutil
import subprocess

import pandas as pd
from dotenv import load_dotenv

from PythonPercentageExtractor import NicheScraper


class RIdiomRunner:
    def __init__(self):
        load_dotenv()
        current_directory = os.path.dirname(os.path.abspath(__file__))
        self.ridiom_path = os.path.join(current_directory, 'RefactoringIdioms-0.0.11/RefactoringIdioms')

        try:
            # quick restart
            niche_csv_path = os.path.join(current_directory, '../dataset', 'updated_Niche_with_Idioms.csv')
            self.df = pd.read_csv(niche_csv_path)
            if 'Assign Multi Targets' not in self.df.columns:
                self.df['Assign Multi Targets'] = 0
                self.df['Call Star'] = 0
                self.df['List Comprehension'] = 0
                self.df['Dict Comprehension'] = 0
                self.df['Set Comprehension'] = 0
                self.df['Truth Value Test'] = 0
                self.df['Chain Compare'] = 0
                self.df['For Multi Targets'] = 0
                self.df['For Else'] = 0

        except:
            # full restart
            niche_csv_path = os.path.join(current_directory, '../dataset', 'updated_Niche.csv')
            NicheScraper().get_python_percentage()
            self.df = pd.read_csv(niche_csv_path)
            self.df = self.df[self.df['Python_Percentage'] > 50]
            self.df['GitHub Repo'] = ["https://github.com/" + repo for repo in self.df['GitHub Repo'] + ".git"]
            self.df['Assign Multi Targets'] = 0
            self.df['Call Star'] = 0
            self.df['List Comprehension'] = 0
            self.df['Dict Comprehension'] = 0
            self.df['Set Comprehension'] = 0
            self.df['Truth Value Test'] = 0
            self.df['Chain Compare'] = 0
            self.df['For Multi Targets'] = 0
            self.df['For Else'] = 0

    def run(self):
        for repo in self.df['GitHub Repo']:
            repo_name = repo.split("/")[-1].split(".")[0]
            repo_path = os.getenv("REPO_PATH")
            result_dict = {'Assign Multi Targets': 0, 'Call Star': 0, 'List Comprehension': 0, 'Dict Comprehension': 0,
                           'Set Comprehension': 0, 'Truth Value Test': 0, 'Chain Compare': 0, 'For Multi Targets': 0,
                           'For Else': 0}
            if self.df.loc[self.df['GitHub Repo'] == repo, 'Assign Multi Targets'].any() == 0 and self.df.loc[
                self.df['GitHub Repo'] == repo, 'Call Star'].any() == 0 and self.df.loc[
                self.df['GitHub Repo'] == repo, 'List Comprehension'].any() == 0 and self.df.loc[
                self.df['GitHub Repo'] == repo, 'Dict Comprehension'].any() == 0 and self.df.loc[
                self.df['GitHub Repo'] == repo, 'Set Comprehension'].any() == 0 and self.df.loc[
                self.df['GitHub Repo'] == repo, 'Truth Value Test'].any() == 0 and self.df.loc[
                self.df['GitHub Repo'] == repo, 'Chain Compare'].any() == 0 and self.df.loc[
                self.df['GitHub Repo'] == repo, 'For Multi Targets'].any() == 0 and self.df.loc[
                self.df['GitHub Repo'] == repo, 'For Else'].any() == 0:
                print("Mining repository: ", repo)
                try:
                    subprocess.check_call(["git", "clone", repo], cwd=repo_path)
                    for dir_name in os.listdir(os.getenv("REPO_PATH")):
                        # construct full directory path
                        dir_path = os.path.join(os.getenv("REPO_PATH"), dir_name)
                        # check if the directory name contains the repo_name and it's a directory
                        if repo_name in dir_name and os.path.isdir(dir_path):
                            repo_path = repo_path + dir_name
                            break
                    else:
                        repo_path = repo_path + repo.split("/")[-1].split(".")[0]
                    print(repo_path)

                    subprocess.check_call(
                        ["python3", self.ridiom_path + "/main.py", "--filepath", repo_path, "--output_codepair",
                         repo_path + "/result.json"], cwd=self.ridiom_path)
                    print(
                        "/main.py " + "--filepath \'" + repo_path + "\' --outputdir \'" + repo_path + "/result.json \'")
                except Exception as e:
                    print(f"Error: {e}. Skipping repository {repo}")
                    for dir_name in os.listdir(os.getenv("REPO_PATH")):
                        # construct full directory path
                        dir_path = os.path.join(os.getenv("REPO_PATH"), dir_name)
                        # check if the directory name contains the repo_name and it's a directory
                        if repo_name in dir_name and os.path.isdir(dir_path):
                            # delete all files and subdirectories in the directory
                            for filename in os.listdir(dir_path):
                                file_path = os.path.join(dir_path, filename)
                                try:
                                    if os.path.isfile(file_path) or os.path.islink(file_path):
                                        os.unlink(file_path)
                                    elif os.path.isdir(file_path):
                                        shutil.rmtree(file_path)
                                except Exception as e:
                                    print(f'Failed to delete {file_path}. Reason: {e}')
                                    continue
                    continue

                if os.path.isfile(repo_path + "/result.json"):
                    print("FILE ESISTE")
                    json_list = json.load(open(repo_path + "/result.json"))
                    for complicate_instance in json_list:
                        idiom_name = complicate_instance["idiom"]
                        result_dict[idiom_name] += 1
                    for idiom in result_dict.keys():
                        self.df.loc[self.df['GitHub Repo'] == repo, idiom] = result_dict[idiom]

                # clean up before next repo
                if os.path.isdir(repo_path):
                    subprocess.check_call(["rm", "-rf", repo_path])
                    subprocess.check_call(["mkdir", repo_path])
                    current_directory = os.path.dirname(os.path.abspath(__file__))
                    self.df.to_csv(os.path.join(current_directory, '../dataset', 'updated_Niche_with_Idioms.csv'),
                                   index=False)


if __name__ == "__main__":
    runner = RIdiomRunner()
    runner.run()