# Walmart Data Analysis: SQL + Python 

## Project Overview

This project analyzes Walmart sales data using Python and MySQL. It covers the full workflow, from setting up the environment and downloading data via the Kaggle API, to cleaning, transforming, and analyzing the data.
The goal addresses key business challenges, such as identifying sales trends, top-performing categories, and customer purchasing patterns. Cleaned data is then loaded into MySQL for advanced SQL querying and insight generation, showcasing skills in data processing and analytical problem-solving.


---

## Project Workflow

### 1. Set Up the Environment
   - **Tools Used**: Visual Studio Code (VS Code), Python, MySQL
   - **Goal**: Set up a well-organized workspace in VS Code and arrange project folders to make development and data work easier.

### 2. Set Up Kaggle API
   - **API Setup**: Obtain your Kaggle API token from [Kaggle](https://www.kaggle.com/) by navigating to your profile settings and downloading the JSON file.
   - **Configure Kaggle**: 
      - Place the downloaded `kaggle.json` file in your local `.kaggle` folder.
      - Use the command `kaggle datasets download -d <dataset-path>` to pull datasets directly into your project.

### 3. Download Walmart Sales Data
   - **Data Source**: Use the Kaggle API to download the Walmart sales datasets from Kaggle.
   - **Dataset Link**: [Walmart Sales Dataset](https://www.kaggle.com/najir0123/walmart-10k-sales-datasets)
   - **Storage**: Save the data in the `data/` folder for easy reference and access.

### 4. Install Required Libraries and Load Data
   - **Libraries**: Install necessary Python libraries using:
     ```bash
     pip install pandas numpy sqlalchemy mysql-connector-python 
     ```
   - **Loading Data**: Load the dataset into a Pandas DataFrame using `pd.read_csv()` for further processing.


### 5. Load Data into MySQL 
   - **Database Connection**: Use `SQLAlchemy` to connect to `MySQL` and load the cleaned data into the database.
   - **Table Creation**: Load data into MySQL using `to_sql()` or similar methods to automate table creation and insert data.
   - **Verification**: Run initial queries to confirm the data has been uploaded correctly.
     
## Business Problems & Goals
   - This project tackles key challenges related to:
     - Customer behavior and payment preferences
     - Sales and revenue performance
     - Branch and shift optimization
   -  For detailed business questions and problem statements, see [`Walmart Business Problem.pdf`](./Walmart%20Business%20Problem.pdf).
