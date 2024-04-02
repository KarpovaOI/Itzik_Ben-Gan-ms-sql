
--фильтрация и сортировка данных
--не только предикаты Where но и выбор строк: TOP, OFFSET..FETCH

--фильтры TOP и OFFSET-FETCH обрабатываются на своем собственном этапе с номером 7

-- Постраничная выборка
USE WideWorldImporters;
DECLARE
@pagesize BIGINT = 10, -- Размер страницы
@pagenum BIGINT = 3; -- Номер страницы
SELECT
CityID,
CityName AS City,
StateProvinceID
FROM Application.Cities
ORDER BY City, CityID
OFFSET (@pagenum - 1) * @pagesize ROWS FETCH NEXT @pagesize ROWS ONLY;

--товары, входящие в 3ку самых дорогих на складе
SELECT TOP 3 WITH TIES StockItemID, StockItemName, UnitPrice  --Top N with ties - топ + строки с данными, попавшими на границу сортировки
FROM Warehouse.StockItems
ORDER BY UnitPrice DESC --сортировка обязательна

--Предикаты могут быть в предложениях ON WHERE HAVING
--предикат isNULL для проверки на NULL


-- isnull vs coalesce
WITH cte AS (
SELECT 1 AS val
UNION all
SELECT null
)
SELECT val
, isnull(val, 1.4) AS [isnull] -- приводит к типу val (потеря точности)
, coalesce(val, 1.4) AS [coalesce] --нет потери точности
FROM cte;
/*
выполняя фильтрацию строк в запросе (а не на клиенте), 
мы снижаем нагрузку на сеть. Кроме того, учитывая информацию фильтров в запросе, SQL Server способен оценить возможность использования индексов для 
эффективного получения данных без полного сканирования таблицы. Важно заметить, что для эффективного использования индекса предикат должен иметь форму, 
известную как аргумент поиска (search argument, SARG).
*/
USE TSQL2012;
SELECT orderid, orderdate, empid 
FROM Sales.Orders 
WHERE COALESCE(shippeddate, '19000101') = COALESCE(@dt, '19000101'); --предикат не является аргументом поиска. Это означает, что SQL Server не может эффективно использовать индекс для столбца shippeddate. 
--Для того чтобы сделать предикат аргументом поиска, 
--следует избегать манипулирования фильтруемым столбцом:
SELECT orderid, orderdate, empid 
FROM Sales.Orders 
WHERE shippeddate = @dt 
OR (shippeddate IS NULL AND @dt IS NULL);

--COALESCE и ISNULL на производительность ВЛИЯЕТ 
--Комбинирование предикатов:
/*
Приоритет
0. NOT
1. (..) скобки
2. AND
3. OR
*/

--просто используй скобки

--Фильтрация символьных данных
--Избегать неявных преобразований литералов и использовать N'literal'
--бывают случаи, когда неявное преобразование снижает производительность. 
--col1 LIKE '!_%' 
--ESCAPE '!' --выполняет поиск строки, которая начинается со знака подчеркивания 
--(_), используя в качестве Escape-символа восклицательный знак (!). 
--col LIKE 'ABC%' --использует поиск по индексу
--col LIKE '%ABC%' --не исп поиск по индексу
--если необх частый поиск можно сделать вычисляемый столбец на него индекс и искать по нему в обратном порядке

--фильтрация даты и времени
--форма записи '2012-02-12' не зависит от языка для типов данных DATE, DATETIME2 и DATETIMEOFFSET, но зависит от языка для типов данных 
--DATETIME и SMALLDATETIME, поэтому:
--дата в условии where - удобен формат 'yyyyMMdd': convert(varchar, <дата>, 112)
SELECT * FROM Sales.Orders WHERE OrderDate ='20150527' --не зависит от разделителей и исп. языка

--в фильтре с датами лучше не исп BETWEEN из-за разной точности формат дат
SELECT orderid, orderdate, custid, empid 
FROM Sales.Orders 
WHERE orderdate >= '20080211' AND orderdate < '20080213'


--СОРТИРОВКА
--Единственный способ действительно гарантировать возвращение строк запросом 
--в определенном порядке — добавить предложение ORDER BY.

--если используется предложение DISTINCT, в списке ORDER BY могут 
--быть только элементы, присутствующие в списке SELECT, как в следующем примере: 
SELECT DISTINCT city 
FROM HR.Employees 
WHERE country = N'USA' AND region = N'WA' 
ORDER BY city; 

--NULL сортируются перед "не NULL"

SELECT orderid, shippeddate 
FROM Sales.Orders 
WHERE custid = 20 
ORDER BY shippeddate;

--недетерминированная сортировка
SELECT orderid, empid, shipperid, shippeddate 
FROM Sales.Orders 
WHERE custid = 77 
ORDER BY shipperid --т.к. есть дубли!

--все еще недетерминированная, т.к. есть дубли и в дате!
SELECT orderid, empid, shipperid, shippeddate 
FROM Sales.Orders 
WHERE custid = 77 
ORDER BY shipperid, shippeddate DESC
/*
комбинация столбцов shipperid и shippeddate не уникальна, и неважно, к каким 
мыслям приводят вас текущие значения, которые вы видите в таблице. Формально в результате этого запроса может быть несколько строк с одинаковым 
значением shipperid и shippeddate. 
*/
--детерминированная
SELECT orderid, empid, shipperid, shippeddate 
FROM Sales.Orders 
WHERE custid = 77 
ORDER BY shipperid, shippeddate DESC, orderid DESC;

--детерминированный запрос — это запрос, который имеет только один правильный результат