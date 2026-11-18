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
-- Jednocześnie Tables przynoszą głęboką stratę już przy średnim rabacie (~26%).
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


-- 4. Rentowność w podziale na regiony geograficzne
-- Wniosek: Region Central generuje najniższy zysk (39,7 tys. USD, marża <8%) mimo wysokiego wolumenu zamówień
SELECT 
    Region, 
    COUNT(*) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct,
    ROUND(AVG(Discount) * 100, 2) AS average_discount_pct
FROM orders
GROUP BY Region
ORDER BY total_profit ASC;


-- 5. Identyfikacja nierentownych stanów (łączny zysk < 0)
-- Wniosek: Straty w całej firmie koncentrują się w 10 konkretnych stanach ze średnim rabatem 
-- na poziomie 28-39%, na czele z Teksasem (-25,7 tys. USD) i Illinois (-12,6 tys. USD).
SELECT 
    Region,
    State,
    COUNT(*) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct,
    ROUND(AVG(Discount) * 100, 2) AS average_discount_pct
FROM orders
GROUP BY Region, State
HAVING total_profit < 0
ORDER BY total_profit ASC;


-- 6. Sezonowość sprzedaży i rentowności w ujęciu miesięcznym
-- Wniosek: Szczyty sprzedaży przypadają na wrzesień (Back-to-Office) oraz czwarty kwartał roku (listopad-grudzień).
-- Średni rabat pozostaje jednak stały przez cały rok (~15-16%), co dowodzi, 
-- Że problem rabatowy ma charakter strukturalny (regionalny), a nie sezonowy.
SELECT 
    MONTH(`Order Date`) AS order_month, 
    COUNT(*) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct,
    ROUND(AVG(Discount) * 100, 2) AS average_discount_pct
FROM orders
GROUP BY order_month
ORDER BY order_month ASC;