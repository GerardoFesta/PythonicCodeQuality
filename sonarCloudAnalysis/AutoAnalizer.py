import shutil
import stat

from SonarCloudScraper import SonarCloudScraper
import pandas as pd
import os
import dotenv

dotenv.load_dotenv()

token = os.getenv("SONAR_TOKEN")
host = os.getenv("HOST")


# Create a SonarCloudClient object
sonar = SonarCloudScraper(token, host)
df = pd.read_csv("../dataset/updated_Niche_with_Levels.csv")
directory = os.getenv("REPO_PATH")
organization_name = os.getenv("ORGANIZATION_NAME")
for i, repo in enumerate(df["GitHub Repo"]):
    project_name = repo.split("/")[-1].split(".")[0] + "_" + str(i)
    project_key = repo.split("/")[-1].split(".")[0]+"_"+str(i)

    try:
        sonar.create_project(project_key, project_name, organization_name)

        sonar.run_analysis(repo, directory, organization_name, project_key)

        measures_dict = sonar.get_results(project_key)
        measures_dict["GitHub Repo"] = repo
        #Put results in a csv
        df = pd.DataFrame([measures_dict])
        #append to csv

        df.to_csv("sonarcloud_results.csv", mode='a', index=False, header=not os.path.exists("sonarcloud_results.csv"))
        del df
    except Exception as e:
        print(e)
    finally:
        if os.path.exists(directory):
            for root, dirs, files in os.walk(directory):
                for dir in dirs:
                    os.chmod(os.path.join(root, dir), stat.S_IRWXU)
                for file in files:
                    os.chmod(os.path.join(root, file), stat.S_IRWXU)
            #Delete the project folder
            shutil.rmtree(directory)
