SELECT * FROM [Bank loan Data]

SELECT 
loan_status
FROM
[Bank loan Data]

SELECT
(COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100)
/
COUNT(id) AS Good_Loan_Percentage
FROM 
[Bank loan Data]
--Good loan percentage--

SELECT COUNT(id) AS Good_Loan_Application
FROM [Bank loan Data]
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'
--Good load Application--

SELECT SUM(loan_amount) AS Good_Loan_Funded_Amount
FROM [Bank loan Data]
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'
--Good_Loan_Funded_Amount--

SELECT SUM(total_payment) AS Good_Loan_Recieved_Amount
FROM [Bank loan Data]
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'
--Good_Loan_Recieved_Amount--

SELECT
(COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100)
/
COUNT(id) AS Bad_Loan_Percentage
FROM 
[Bank loan Data]
--Bad loan percentage--

SELECT COUNT(id) AS Bad_Loan_Application
FROM [Bank loan Data]
WHERE loan_status = 'Charged Off'
--Bad load Application--

SELECT SUM(loan_amount) AS Bad_Loan_Funded_Amount
FROM [Bank loan Data]
WHERE loan_status = 'Charged Off'
--Bad_Loan_Funded_Amount--

SELECT SUM(total_payment) AS Bad_Loan_Recieved_Amount
FROM [Bank loan Data]
WHERE loan_status = 'Charged Off'
--Bad_Loan_Recieved_Amount--

SELECT
loan_status,
        COUNT(id) AS Total_Application,
        SUM(total_payment) AS Total_Amount_Received,
        SUM(loan_amount) AS Total_Funded_Amount,
        AVG(int_rate * 100) AS Interest_Rate,
        AVG(dti * 100) AS DTI
    FROM
        [Bank loan Data]
    GROUP BY
        loan_status
