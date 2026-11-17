-- ============================================================================
-- PROJEKT PORTFOLIO: Analiza rentowności i polityki rabatowej (Superstore)
-- NARZĘDZIA: MySQL (phpMyAdmin), Excel (Power Query)
-- ============================================================================

-- 1. Analiza wpływu poziomu rabatów na rentowność zamówień
-- Wniosek: Granicą opłacalności jest rabat 20% (0.20). 
-- Każdy próg od 30% (0.30) w górę generuje wyłącznie stratę finansową.
SELECT 
    Discount,
    COUNT(*) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(AVG(Profit), 2) AS average_profit,
    ROUND(SUM(Profit), 2) AS total_profit
FROM orders
GROUP BY Discount
ORDER BY Discount ASC;


-- 2. Rentowność według kategorii i podkategorii produktów 
-- Wniosek: Największe straty generują Tables, Bookcases oraz Supplies.
-- Anomalia do sprawdzenia: Binders mają wysoki średni rabat (~37%), a mimo to wysoki zysk, 
-- jednocześnie Tables przynoszą głęboką stratę już przy średnim rabacie (~26%).
SELECT 
    `Category`, 
    `Sub-Category`, 
    COUNT(*) AS total_orders, 
    ROUND(SUM(`Sales`), 2) AS total_sales, 
    ROUND(SUM(`Profit`), 2) AS total_profit, 
    ROUND((SUM(`Profit`) / SUM(`Sales`)) * 100, 2) AS profit_margin_pct, 
    ROUND(AVG(`Discount`) * 100, 2) AS average_discount_pct
FROM orders 
GROUP BY `Category`, `Sub-Category` 
ORDER BY total_profit DESC;


-- 3. Rozkład rabatów wewnątrz Binders i Tables
-- Wniosek: W Binders zysk pochodzi z transakcji 0-20%, natomiast rabaty 70-80% 
-- zjadają ponad połowę potencjalnego zysku tej podkategorii.
SELECT 
    `Sub-Category`,
    Discount,
    COUNT(*) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM orders
WHERE `Sub-Category` IN ('Binders', 'Tables')
GROUP BY `Sub-Category`, Discount
ORDER BY `Sub-Category` ASC, Discount ASC;