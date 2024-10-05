import os

from git import Repo
import ast
import pandas as pd

from pythonicExtraction.PythonicVisitor import PythonicVisitor


class PythonicExtractor:
    def __init__(self, basepath, repolist=None, csvpath=None):
        if repolist is None and csvpath is None:
            raise ValueError("You must provide at least a list of repositories or a csv file")
        if repolist is not None:
            if not isinstance(repolist, list):
                raise ValueError("Repolist must be a list")
            self.repo_list = repolist
        self.base_path = basepath
        if (csvpath is not None):
            self.df = pd.read_csv(csvpath)
            if "GitHub Repo" not in self.df.columns:
                raise ValueError("CSV file must contain a column named 'GitHub Repo'")
            if "PY_Assign Multi Targets" not in self.df.columns:
                self.df['PY_Assign Multi Targets'] = 0
                self.df['PY_Call Star'] = 0
                self.df['PY_List Comprehension'] = 0
                self.df['PY_Dict Comprehension'] = 0
                self.df['PY_Set Comprehension'] = 0
                self.df['PY_Truth Value Test'] = 0
                self.df['PY_Chain Compare'] = 0
                self.df['PY_For Multi Targets'] = 0
                self.df['PY_For Else'] = 0

            self.csv_path = csvpath

    def __extract_pythonic(self, repo_path):
        visitor = PythonicVisitor()
        for root, dirs, files in os.walk(repo_path):
            for file in files:
                if file.endswith(".py"):
                    try:
                        with open(os.path.join(root, file), "r") as f:
                            content = f.read()
                            try:
                                tree = ast.parse(content)
                                visitor.visit(tree)
                            except:
                                print("Error parsing file: ", os.path.join(root, file))
                                continue
                    except:
                        print("SKIP: Error reading file: ", os.path.join(root, file))
                        continue
        return visitor.get_pythonic_metrics()

    def mine(self):
        if self.csv_path is not None:
            self.repo_list = self.df['GitHub Repo']
        for repo in self.repo_list:
            repo_path = None
            Repo.clone_from(repo, self.base_path + "" + repo.split("/")[-1].split(".")[0])
            # find dir where files are cloned

            for dir_name in os.listdir(self.base_path):

                # construct full directory path
                dir_path = os.path.join(self.base_path, dir_name)
                # check if the directory name contains the repo_name and it's a directory
                if repo.split("/")[-1].split(".")[0] in dir_name and os.path.isdir(dir_path):
                    repo_path = self.base_path + dir_name
                    break
            else:
                print("SKIPPING REPO " + repo + " NO DIRECTORY FOUND")

            if repo_path:
                pythonic_dict = self.__extract_pythonic(repo_path)

                for key in pythonic_dict.keys():
                    self.df.loc[self.df['GitHub Repo'] == repo, key] = pythonic_dict[key]
                self.df.to_csv(self.csv_path, index=False)

            if os.path.isdir(repo_path):
                os.system("rm -rf " + repo_path)


if __name__ == "__main__":
    project_path = os.getenv("PROJECT_PATH")
    runner = PythonicExtractor(project_path, csvpath="./dataset/updated_Niche_with_Levels.csv")
    runner.mine()
