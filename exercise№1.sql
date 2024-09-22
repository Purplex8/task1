WITH Filter_sales AS (
    SELECT 
        "Code_agent", 
        "Business_line", 
        "Insurance_premium", 
        "Periodicity" 
    FROM 
        public.reestr_a ra 
    WHERE
        "Code_agent" = '52899103' AND
        "Business_line" IN ('НСЖ', 'ПСЖ', 'НСиБ', 'РСЖ') AND
        "Policy_status" <> 12 AND
        "Policy_number" NOT IN (SELECT "Policy_number" FROM memorandum m) AND
        "Policy_number" NOT IN (SELECT "Policy_number" FROM self_sale ss)
),
LifeSales AS (
    SELECT 
        COUNT(*) AS LifeCount, 
        COALESCE(SUM(CAST("Insurance_premium" AS NUMERIC)), 0) AS TotalPremiya
    FROM 
        Filter_sales 
    WHERE 
        "Business_line" IN ('НСЖ', 'ПСЖ')
),
TotalSales AS (
    SELECT 
        COUNT(*) AS TotalCount, 
        COALESCE(SUM(CAST("Insurance_premium" AS NUMERIC)), 0) AS TotalPremiya
    FROM 
        Filter_sales
)
SELECT 
    COALESCE((SELECT LifeCount FROM LifeSales), 0) * 10000 AS BonusLifeSales,
    CASE 
        WHEN (SELECT TotalPremiya FROM TotalSales) > 500000 THEN 30000 ELSE 0 
    END AS BonusTotalPremiya,
    COALESCE(SUM(CASE WHEN "Type_of_periodicity" = 'Единовременная оплата' THEN "Insurance_premium" * 0.05 ELSE 0 END), 0) AS BonusOneTime
FROM 
    public.reestr_a ra 