import os
import sys
current_directory = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.join(current_directory, "sonarqube"))
from sonarqube.cloud import SonarCloudClient
import subprocess
from git import Repo

class SonarCloudScraper:
    def __init__(self, token, host):
        self.token = token
        self.host = host
        # Create a SonarCloudClient object
        self.sonar = SonarCloudClient(host, token)

    def create_project(self, project_key, project_name, organization_name):
        project = self.sonar.projects.create_project(project_key, project_name, organization_name)
        return project

    def run_analysis(self, repo, directory, organization_name, project_key):
        #Clone the project
        Repo.clone_from(repo, directory)
        scanner_command = "sonar-scanner -Dsonar.organization="+organization_name +" -Dsonar.projectKey="+project_key+" -Dsonar.sources="+directory +" -Dsonar.inclusions=**/*.*py*  -Dsonar.host.url="+self.host+" -Dsonar.c.file.suffixes=- -Dsonar.cpp.file.suffixes=- -Dsonar.objc.file.suffixes=-"
        #Run sonar-scanner
        subprocess.check_call(scanner_command, shell=True, cwd = directory)

    def get_results(self, project_key):
        metrics = self.sonar.metrics.search_metrics()
        metrics = [metric["key"] for metric in metrics]
        measures = self.sonar.measures.get_component_with_specified_measures(project_key, ",".join(metrics))
        measures_dict = {measure["metric"]: measure["value"] for measure in measures["component"]["measures"]}

        complex_metrics = ["reliability_issues", "maintainability_issues", "security_issues"]
        states = ["HIGH", "MEDIUM", "LOW"]
        for metric in complex_metrics:
            for i, state in enumerate(states):
                measures_dict[f"{state}_{metric}"] = measures_dict[metric][2:-1].replace('"', '').split(",")[i + 1].split(":")[1]
            measures_dict.pop(metric, None)
        measures_dict.pop("last_commit_date", None)
        measures_dict.pop("ncloc_language_distribution", None)
        measures_dict.pop("quality_profiles", None)
        return measures_dict
