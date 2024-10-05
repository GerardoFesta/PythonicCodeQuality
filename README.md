# Pythonic Code Quality Extraction

This project extracts non-Pythonic and Pythonic code instances and code smells from Python projects using SonarCloud and various scripts. Follow the instructions below to fully replicate the experiment.

## Prerequisites

- **SonarScanner**: Download the latest version from the [SonarScanner documentation](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/).
- **SonarCloud account**: You will need an account and a [token](https://sonarcloud.io/account/security) to access the API.
- **GitHub account**: You  need a GitHub token to calculate the Python percentage for the dataset.

## Installation Steps

### 1. Clone the Repository and Submodules

Clone the repository along with its submodules using the following command:

```bash
git clone --recurse-submodules https://github.com/GerardoFesta/PythonicCodeQuality.git
```
### 2. Install Dependencies

Make sure to install the necessary dependencies by running:

```bash
pip install -r requirements.txt
```
### 3. Create a .env File
Create a .env file in the root directory with the following content:
    
```bash
SONAR_TOKEN = <your-sonarCloud-token>
HOST = https://sonarcloud.io/  # or another host if you prefer, but the code is prepared for SonarCloud
REPO_PATH = <Path-where-the-dataset-repos-will-be-cloned>
ACCESS_TOKEN = <GithubToken>  # needed if you want to calculate Python Percentage
ORGANIZATION_NAME = <Your-Org-Name-in-SonarCloud>
```
### 4. Extracting Non-Pythonic Code Instances
Execute the script to extract non-Pythonic code instances using RIdiom and Python Percentage using GitHub API:
```bash
python nonPythonicExtraction/RIdiomRunner.py
```
### 5. Extracting Pythonic Code Instances
Run the Pythonic code extraction:
```bash
python pythonicExtraction/PythonicExtractor.py
```

### 6. Extracting Code Smells and Quality metrics
Run the following script to extract code smells and quality metrics:
```bash
python sonarCloudAnalysis/AutoAnalizer.py
```

### 7. Merge the Datasets
Run the following script to merge the datasets:
```bash
python utils/merger.py
```

## Datasets Generated

During the extraction process, the following datasets will be generated:

* **NICHE dataset**: The original NICHE dataset.
* **updated_NICHE**: NICHE dataset with the Python percentage added, created in step 4.
* **updated_NICHE_with_Idioms**: The updated NICHE dataset with both non-Pythonic and Pythonic code instances, created in step 4 and updated in step 5.
* **sonarcloud_results**: Extracted code smells and quality metrics from SonarCloud, created in step 6.
* **NicheSonarMerged.csv**: The complete dataset containing all information, created in step 7.
* **NicheSonarMergedCleaned.csv**: A cleaned version of the dataset with failed projects removed.

The project comes with all the datasets generated during the experiment. You can find them in the `dataset/` directory.
## Project Structure

Here is a brief overview of the relevant directories and files:

* `utils/`: Contains a script to calculate the percentage of Python code in the NICHE dataset and one to merge the code smells dataset and the Pythonic dataset.
* `nonPythonicExtraction/`: Contains scripts related to extracting non-Pythonic code.
* `pythonicExtraction/`: Contains scripts related to extracting Pythonic code.
* `sonarCloudAnalysis/`: Contains scripts for extracting code smells and quality metrics using SonarCloud.
* `analysis/`: Contains R scripts for data analysis.


## Credits
Credits to the authors of the [NICHE dataset](https://arxiv.org/abs/2303.06286) and the [RIdiom tool](https://pypi.org/project/RefactoringIdioms/) ([Article](https://ieeexplore.ieee.org/document/10172780)) for providing the dataset and the tool to extract non-Pythonic code instances.
This projects uses the [python-sonar-api](https://gitlab.com/schmieder.matthias/python-sonar-api), released under MIT license, as a submodule.

