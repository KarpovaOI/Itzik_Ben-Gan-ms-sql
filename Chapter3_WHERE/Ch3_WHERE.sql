
--���������� � ���������� ������
--�� ������ ��������� Where �� � ����� �����: TOP, OFFSET..FETCH

--������� TOP � OFFSET-FETCH �������������� �� ����� ����������� ����� � ������� 7

-- ������������ �������
USE WideWorldImporters;
DECLARE
@pagesize BIGINT = 10, -- ������ ��������
@pagenum BIGINT = 3; -- ����� ��������
SELECT
CityID,
CityName AS City,
StateProvinceID
FROM Application.Cities
ORDER BY City, CityID
OFFSET (@pagenum - 1) * @pagesize ROWS FETCH NEXT @pagesize ROWS ONLY;

--������, �������� � 3�� ����� ������� �� ������
SELECT TOP 3 WITH TIES StockItemID, StockItemName, UnitPrice  --Top N with ties - ��� + ������ � �������, ��������� �� ������� ����������
FROM Warehouse.StockItems
ORDER BY UnitPrice DESC --���������� �����������

--��������� ����� ���� � ������������ ON WHERE HAVING
--�������� isNULL ��� �������� �� NULL


-- isnull vs coalesce
WITH cte AS (
SELECT 1 AS val
UNION all
SELECT null
)
SELECT val
, isnull(val, 1.4) AS [isnull] -- �������� � ���� val (������ ��������)
, coalesce(val, 1.4) AS [coalesce] --��� ������ ��������
FROM cte;
/*
�������� ���������� ����� � ������� (� �� �� �������), 
�� ������� �������� �� ����. ����� ����, �������� ���������� �������� � �������, SQL Server �������� ������� ����������� ������������� �������� ��� 
������������ ��������� ������ ��� ������� ������������ �������. ����� ��������, ��� ��� ������������ ������������� ������� �������� ������ ����� �����, 
��������� ��� �������� ������ (search argument, SARG).
*/
USE TSQL2012;
SELECT orderid, orderdate, empid 
FROM Sales.Orders 
WHERE COALESCE(shippeddate, '19000101') = COALESCE(@dt, '19000101'); --�������� �� �������� ���������� ������. ��� ��������, ��� SQL Server �� ����� ���������� ������������ ������ ��� ������� shippeddate. 
--��� ���� ����� ������� �������� ���������� ������, 
--������� �������� ��������������� ����������� ��������:
SELECT orderid, orderdate, empid 
FROM Sales.Orders 
WHERE shippeddate = @dt 
OR (shippeddate IS NULL AND @dt IS NULL);

--COALESCE � ISNULL �� ������������������ ������ 
--�������������� ����������:
/*
���������
0. NOT
1. (..) ������
2. AND
3. OR
*/

--������ ��������� ������

--���������� ���������� ������
--�������� ������� �������������� ��������� � ������������ N'literal'
--������ ������, ����� ������� �������������� ������� ������������������. 
--col1 LIKE '!_%' 
--ESCAPE '!' --��������� ����� ������, ������� ���������� �� ����� ������������� 
--(_), ��������� � �������� Escape-������� ��������������� ���� (!). 
--col LIKE 'ABC%' --���������� ����� �� �������
--col LIKE '%ABC%' --�� ��� ����� �� �������
--���� ����� ������ ����� ����� ������� ����������� ������� �� ���� ������ � ������ �� ���� � �������� �������

--���������� ���� � �������
--����� ������ '2012-02-12' �� ������� �� ����� ��� ����� ������ DATE, DATETIME2 � DATETIMEOFFSET, �� ������� �� ����� ��� ����� ������ 
--DATETIME � SMALLDATETIME, �������:
--���� � ������� where - ������ ������ 'yyyyMMdd': convert(varchar, <����>, 112)
SELECT * FROM Sales.Orders WHERE OrderDate ='20150527' --�� ������� �� ������������ � ���. �����

--� ������� � ������ ����� �� ��� BETWEEN ��-�� ������ �������� ������ ���
SELECT orderid, orderdate, custid, empid 
FROM Sales.Orders 
WHERE orderdate >= '20080211' AND orderdate < '20080213'


--����������
--������������ ������ ������������� ������������� ����������� ����� �������� 
--� ������������ ������� � �������� ����������� ORDER BY.

--���� ������������ ����������� DISTINCT, � ������ ORDER BY ����� 
--���� ������ ��������, �������������� � ������ SELECT, ��� � ��������� �������: 
SELECT DISTINCT city 
FROM HR.Employees 
WHERE country = N'USA' AND region = N'WA' 
ORDER BY city; 

--NULL ����������� ����� "�� NULL"

SELECT orderid, shippeddate 
FROM Sales.Orders 
WHERE custid = 20 
ORDER BY shippeddate;

--������������������� ����������
SELECT orderid, empid, shipperid, shippeddate 
FROM Sales.Orders 
WHERE custid = 77 
ORDER BY shipperid --�.�. ���� �����!

--��� ��� �������������������, �.�. ���� ����� � � ����!
SELECT orderid, empid, shipperid, shippeddate 
FROM Sales.Orders 
WHERE custid = 77 
ORDER BY shipperid, shippeddate DESC
/*
���������� �������� shipperid � shippeddate �� ���������, � �������, � ����� 
������ �������� ��� ������� ��������, ������� �� ������ � �������. ��������� � ���������� ����� ������� ����� ���� ��������� ����� � ���������� 
��������� shipperid � shippeddate. 
*/
--�����������������
SELECT orderid, empid, shipperid, shippeddate 
FROM Sales.Orders 
WHERE custid = 77 
ORDER BY shipperid, shippeddate DESC, orderid DESC;

--����������������� ������ � ��� ������, ������� ����� ������ ���� ���������� ���������