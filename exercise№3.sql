SELECT 
    "Code_agent",
    COUNT(*) AS AccidentInsuranceSales
FROM 
    public.reestr_a ra
WHERE 
    "Business_line" IN ('НСиБ', 'РСЖ') AND
    "Policy_status" <> 12 AND
    "Policy_number" NOT IN (SELECT "Policy_number" FROM memorandum m) AND
    "Policy_number" NOT IN (SELECT "Policy_number" FROM self_sale ss)
GROUP BY 
    "Code_agent" 
ORDER BY 
    AccidentInsuranceSales DESC
LIMIT 1; 