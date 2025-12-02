# Bank-Loan-Analysis-Dashboard---Risk-Performance-Insights-Overview
This end-to-end analytics project leverages MS SQL Server for data querying and Power BI for visualization to analyze a bank loan portfolio.### LinkedIn Post

**Overview**  
This end-to-end analytics project leverages MS SQL Server for data querying and Power BI for visualization to analyze a bank loan portfolio. Sourced from `financial_loan.csv` (~38K records), the dashboard tracks application trends, funding/recovery metrics, good/bad loan ratios, and borrower profiles. Focus: Empowering banks with actionable insights for risk assessment, portfolio optimization, and regulatory compliance (e.g., HMDA/KYC). Built following a SQL-to-BI pipeline, it includes three dashboards: Summary (KPIs), Overview (trends by category), and Details (granular grid).

**Business Objectives** (from problem statement in `Bank Loan PPT Power BI.pptx`):  
- Monitor core KPIs: Total/MTD/PMTD apps, funded amounts, recoveries, avg interest/DTI with MoM variance.  
- Segment good/bad loans: % apps, funded/recovered by status (Fully Paid, Current, Charged Off).  
- Visualize trends: Monthly/state/term/employment/purpose/home ownership breakdowns.  
- Enable drill-through: From aggregates to loan-level details (e.g., ID, borrower income, status).  
- Support decisions: Fraud detection, profitability, customer retention via data-driven models.

**Key Insights Generated**  
Derived from SQL queries (e.g., GROUP BY loan_status) and dashboard outputs in `Bank Loan Analysis.pdf`. Analysis assumes Dec 2025 as MTD (per queries; current date Nov 29, 2025—extend for real-time).

| Category | Metric | Value | Insight |  
|----------|--------|-------|---------|  
| **Portfolio Performance** | Total Loan Applications | 38,576 | Steady growth; MTD (4.3K) up 6.9% MoM—signals expanding demand, but validate via credit checks to curb defaults. |  
| | Total Funded Amount | $435.8M | MTD $54M (+13% MoM); recoveries at $473.1M exceed funding (8.6% over-recovery)—strong cash flow from interest. |  
| | Total Amount Received | $473.1M | MTD $58.1M (+15.8% MoM); avg installment affordability key to sustaining this. |  
| **Risk & Rates** | Average Interest Rate | 12.0% | MTD 12.4% (+3.5% MoM); Charged Off loans avg 13.9%—higher rates correlate with defaults; optimize pricing for grades A-B. |  
| | Average DTI | 13.3% | MTD 13.7% (+2.7% MoM); below 20% threshold indicates healthy borrowers, but monitor >15% segments for early warnings. |  
| **Good vs. Bad Loans** | Good Loan % (Fully Paid + Current) | 86.2% | 33K apps, $370.2M funded, $435.8M recovered—core strength; focus retention via refinancing for these low-risk profiles. |  
| | Bad Loan % (Charged Off) | 13.8% | 5K apps, $65.5M funded, $37.3M recovered (43% loss rate)—13% of portfolio; target via better DTI/employment filters. |  
| **Loan Status Breakdown** | Fully Paid | 32,145 apps ($351M funded) | 83% of apps, 11.6% avg rate, 13.2% DTI—gold standard; avg recovery $12.8K per loan. |  
| | Current | 1,098 apps ($18.9M funded) | Ongoing; 15.1% rate—watch for delinquencies; MTD funded $3.9M. |  
| | Charged Off | 5,333 apps ($65.5M funded) | Highest DTI (14.0%); only $7K avg recovery—prioritize early intervention for similar profiles. |  
| **Regional Trends** | Top States (by Apps) | CA (high volume), TX, NY | Filled map shows CA/TX hotspots (20%+ apps); lower defaults in Midwest—geo-tailor marketing/risk models. |  
| **Borrower Profiles** | Top Purposes | Debt Consolidation (40% apps) | High recovery (low risk); weddings/small biz higher defaults—custom terms for these. |  
| | Employment Length | 10+ years (stable, 25% apps) | Lower DTI/bad rates; <1 year correlates with 20% higher Charged Off—enhance verification. |  
| | Home Ownership | MORTGAGE/OWN (60%) | Better repayment (85% good loans) vs. RENT—leverage for secured products. |  
| | Loan Terms | 36 months (70%) | Faster recovery, lower defaults; 60-month for higher yields but monitor extensions. |  

**Technical Implementation**  
Structured pipeline from `Bank Loan PPT Power BI.pptx` steps: SQL ingestion → Power Query cleaning → DAX modeling → interactive viz.

1. **Data Ingestion & Cleaning** (MS SQL Server / Power Query):  
   - Created DB/table in SSMS 19.0; imported `financial_loan.csv` via BULK INSERT.  
   - Queries (from `SQL File`): COUNT/SUM/GROUP BY for KPIs; e.g., `SELECT COUNT(id) FROM bank_loan_data WHERE MONTH(issue_date)=12` for MTD.  
   - Handled data: CAST dates, DECIMAL for rates/DTI; filtered nulls (e.g., emp_length); merged sub_grade into grade.  
   - Date table: `CALENDAR(MIN(issue_date), MAX(issue_date))` with time-intel (MONTH, DATENAME).  

2. **Data Modeling** (Star Schema):  
   - Fact: Loans (keys: id, loan_status, issue_date).  
   - Dimensions: States, Purposes, Terms, Employment, Home Ownership, Grades.  
   - Relationships: Many-to-One (e.g., Loans → States on address_state); inactive for cross-filters (e.g., grade to purpose).  
   - MoM Variance: DAX `MoM % = DIVIDE([MTD] - [PMTD], [PMTD])`.  

3. **DAX Calculations** (Key Measures):  
   - **Total Funded**: `SUM(loan_amount)`.  
   - **Good Loan %**: `DIVIDE(CALCULATE(COUNT(id), loan_status IN {"Fully Paid", "Current"}), COUNT(id))`.  
   - **Avg Interest**: `AVERAGE(int_rate) * 100`.  
   - **Bad Loan Funded**: `CALCULATE(SUM(loan_amount), loan_status = "Charged Off")`.  
   - Dynamic: Field parameters for slicers (e.g., state/grade filters impacting all visuals).  

4. **Visualization & Interactivity** (Power BI June 2023):  
   - **Pages**: Summary (KPIs + status grid), Overview (line for monthly trends, filled map for states, donut/bar/tree for categories), Details (table with all fields, drill-through from KPIs).  
   - **Core Visuals**:  
     - KPI Cards: Apps/Funded/Received with MoM sparklines.  
     - Donut: Good/Bad %; Grid Table: Status metrics (apps, funded, rates).  
     - Line Chart: Monthly trends (issue_date).  
     - Filled Map: State-level (color by funded).  
     - Bar/Tree: Purpose/Employment/Home (stacked by good/bad).  
   - Slicers: State, Grade, Purpose; bookmarks for navigation.  
   - Formatting: Conditional (red for bad loans), tooltips with full KPIs.  

**Challenges & Solutions**  
- **Date Granularity**: Irregular issue_dates—used custom Date table with DATEPART/MONTH for MTD/PMTD accuracy.  
- **Large Dataset**: 38K rows—optimized queries with WHERE clauses; DirectQuery mode for SQL refresh.  
- **Risk Segmentation**: Defining "good/bad"—aligned to status via CTE in SQL for partitioning; validated vs. Excel pivots.  
- **Compliance**: Ensured anonymization (no PII beyond aggregates); cross-checked totals (e.g., SUM(total_payment) = $473M).  

**Tools & Skills Demonstrated**  
- **SQL (SSMS 19.0)**: DDL/DML, aggregates (COUNT/SUM/AVG), GROUP BY, filters (MONTH=12 for MTD).  
- **Power BI**: ETL, modeling, DAX (CALCULATE, DIVIDE for variances), visuals (maps/charts), slicers.  
- **Excel 2021**: Initial CSV validation/pivots.    

**Files Included**  
- `financial_loan.csv`: Raw dataset.    
- `Bank Loan PPT Power BI.pptx`: Requirements/wireframes.  
- `Bank Loan Analysis.pdf`: Exported dashboard visuals.
- `Bank Loan Analysis.SQL Query`.
