Real-World Evidence (RWE) Analytics for Oncology Safety Study
Overview

This project focuses on performing a real-world data (RWD) analysis to evaluate the safety and utilization of sacituzumab govitecan (SG) in metastatic breast cancer (mBC) patients. The study compares patients with moderate hepatic impairment (HI) and normal hepatic function (HF) using electronic health record (EHR) data from the Flatiron database.

The objective is to generate real-world evidence to support clinical and regulatory decision-making in the absence of complete clinical trial data.

Objectives
Identify and construct patient cohorts based on hepatic function using NCI-ODWG criteria
Estimate and compare adverse event (AE) incidence across cohorts
Analyze treatment utilization patterns (dosing and duration)
Evaluate AE-related clinical outcomes (discontinuation, hospitalization, mortality)
Ensure cohort comparability using Propensity Score Matching (PSM)
Tech Stack
SAS – Cohort creation, inclusion/exclusion logic, data processing
SQL – Data extraction and transformation
Python / R (optional) – Statistical analysis and validation
Power BI (optional) – Visualization and reporting
EHR Data (Flatiron) – Real-world oncology dataset
Methodology
1. Cohort Identification
Defined index date (first SG dose)
Applied inclusion/exclusion criteria
Classified patients into:
Moderate Hepatic Impairment
Normal Hepatic Function
2. Data Preparation
Extracted lab values (bilirubin, AST)
Cleaned and structured patient-level datasets
Handled missing data and ensured consistency
3. Propensity Score Matching (PSM)
Matched cohorts (1:2 ratio)
Variables: age, sex, race, ECOG, comorbidity index
Ensured balance using standardized mean difference
4. Adverse Event Analysis
Calculated incidence proportions for clinical and lab AEs
Evaluated across defined follow-up windows
Compared AE rates between cohorts
5. Dosing & Outcomes Analysis
Analyzed number of doses and treatment duration
Evaluated:
Treatment discontinuation
Therapy changes
Hospitalization
Mortality
Project Structure
├── data/                # Sample or synthetic datasets
├── sas/                 # SAS scripts for cohort building
├── sql/                 # SQL queries for data extraction
├── analysis/            # AE and dosing analysis
├── docs/                # ADFs, BRD, methodology documents
├── dashboard/           # (Optional) Power BI files
├── README.md
Key Deliverables
Cohort definitions and SAS implementation
AE incidence comparison tables
Propensity score matching outputs
Dosing and treatment outcome analysis
ADF (Analytical Data Flow) diagrams
BRD (Business Requirement Document)
Key Insights
Enabled comparison of safety profiles across hepatic function groups
Provided real-world evidence to complement delayed clinical trial data
Supported data-driven decision-making in oncology safety evaluation
Disclaimer

This project is based on a real-world use case from a top Fortune 500 pharmaceutical company. All data used is anonymized/simulated for demonstration purposes.
