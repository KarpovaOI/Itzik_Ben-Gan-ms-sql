--���� ��� ���, ���������� � ������������ MS SQL;
USE TSQL2012; --���������� USE �����������, ��� ���������� ������� ���� ������ TSQL2012.
--������������� ����������� FROM (����������� ����. � ��������� ����) � SELECT (��������� ���������, ����������� ����������, ������� ����� DIST)
--��������� ������� ��������� ������ ���� ��������� ��� �����
--��� ������������ ����������� ���. ���� AS (�������� ����������)
--������������ ����������� ��� ������������ ��������������� �������������, �� ��������������� �������� �������������� ���������������, 
--��������, ������������ � �����, ���������� � ���� ������ ��� ���������� 
--����������������� �������� T-SQL. 
--"��� �������", "COUNT" -������ ������������ ����������

--������ � ������ ������ � ����������� ���������
--�������, ��� ��� ������ ��� �����������, �.�. ����� ���� ������������ ������� �������������� �������.
--��� ������ ��������� ���������. ��������� ������������ ��� ������, �� ������� ��� ������������ ����� ���� ������ ���������, ����������������� � ����� 
--�������������� ��� ���������� � �������
/*������ ������ ������ ��� ������ ����������� ���� ������ � ��� ������. ����� 
����� �� ��������� ��������, �������� �� ������������������ �������, �������� ���������� ���������������� �����-������. ������, ������� ������ ������ 
������, ��� �������, �������� �������.*/
--�����: ����� ������������ ���������� ��� ������, ��������������� 
--����� ��������, �� ������� �� ���������������
--FLOAT � REAL - �������� ���� ������
--������������� ����� (CHAR, NCHAR, BINARY) ��� ������������ ����� 
--(VARCHAR, NVARCHAR, VARBINARY).
--CHAR(30)���������� ������ �� 30 �������� ��� ����������� �� ������������ 30 ��� ������. ��� ���������, ������� ����� ����������� � ����� ������������������ ����������

--�����
--��-�� ������� �������������� IDENTITY (����� �������� ��� ������)
--������ ������������������ Sequences ����������� ������ � �� �� �������� ����� �������� ����� ������� ������������������ 
--������������������ GUID: UNIQUEIDENTIFIER. ��� ��������� ������ GUID �� ������ ������������ ������� T-SQL NEWID, ������� ���, ��������, � ���������� �� ���������, ������������� � �������. 
--���������������� GUID: NEWSEQUENTIALID
--���������������� �������

SELECT 1+'1' -- = 2 INT ����� ����� ������� ��������� ��� VARCHAR - ������� ��������������
SELECT 5/2 -- = 2 INT/INT=INT ������������� 
SELECT 5.0/2.0 -- = 2.50000 NUMERIC ��������

--������� ���������� ����� ������
--�������������� 2 ������� ����������� ���������� �����: 
--1.�������� "+"
SELECT empid, country, region, city, 
country + N',' + region + N',' + city AS location 
FROM HR.Employees; --���� ��������� NULL �� ��� ������ ����� - NULL ��� ����� ������ ��������: COALESCE (��������) 
--����� ���������� �������� ������ CONCAT_NULL_YIELDS_NULL - �� ������������� � ���.
--2. ������� CONCAT (�������� NULL ������ �������):
SELECT empid, country, region, city, 
CONCAT(country, N',' + region, N',' + city) AS location 
FROM HR.Employees; 

--���������� ��������� � �� �������
SELECT SUBSTRING('abcde', 1, 3)
SELECT LEFT('abcde', 3)
SELECT RIGHT('abcde', 3)
SELECT CHARINDEX(' ','Itzik Ben-Gan')
SELECT LEFT('Itzik Ben-Gan', CHARINDEX(' ', 'Itzik Ben-Gan') - 1) --������ ��� ��������
SELECT PATINDEX('%[0-9]%', 'abcd123efgh') --������ ���� LIKE
--����� � ���� ��������
SELECT LEN(N'xyz') --����� - 3 �������. �������� �������
SELECT LEN(N'xyz ') --��� ����� 3 �������
--����� � ���� ����
SELECT DATALENGTH(N'xyz') --Unicode 2 ����� �� ������
SELECT DATALENGTH('xyz') --1 ���� �� ������
--��������� �����
SELECT REPLACE('.1.2.3.', '.', '/') --�������� ��� ����� ������
SELECT REPLICATE('0', 10) --��������� ������ 0 ������ ���
SELECT STUFF(',x,y,z', 1, 1, '') 
--�������������� �����
--[UPPER, LOWER, LTRIM, RTRIM, FORMAT ('������� ��������','������ ��������������', ���������� ���)]
SELECT RTRIM(LTRIM(' ,x,y,z ')) --��������� ������� � �������� �������� �� ������ MSSQL
SELECT FORMAT(1759, '0000000000')--�������� ���� �� �������

--��������� CASE
--������� �����
SELECT productid, productname, unitprice, discontinued, 
 CASE discontinued 
 WHEN 0 THEN 'No' 
 WHEN 1 THEN 'Yes' 
 ELSE 'Unknown' --���� ����������� else ������� NULL
 END AS discontinued_desc 
FROM Production.Products;
--���������
SELECT productid, productname, unitprice, 
 CASE 
 WHEN unitprice < 20.00 THEN 'Low' --������������ ��������� � ��������� WHEN
 WHEN unitprice < 40.00 THEN 'Medium' --������ "��������" ����������
 WHEN unitprice >= 40.00 THEN 'High' 
 ELSE 'Unknown' 
 END 
AS pricerange 
FROM Production.Products; 
--����� CASE �������� ��������� COALESCE � NULLIF - ���������� � ������������ ISNULL,IIF � ��.
--ISNULL ����� ����������, ������:
DECLARE 
 @x AS VARCHAR(3) = NULL, 
 @y AS VARCHAR(10) = '1234567890'; 
SELECT COALESCE(@x, @y) AS [COALESCE], ISNULL(@x, @y) AS [ISNULL]; 

--������� ��� ������ � �����:
/*
� ������������:
https://learn.microsoft.com/ru-ru/sql/t-sql/functions/date-and-time-data-types-and-functions-transact-sql?view=sql-server-ver16&redirectedfrom=MSDN
*/
--������� ���� � �����
--DATETIME
SELECT GETDATE() --T-SQL
SELECT CURRENT_TIMESTAMP --��������, ���� ��� � GETDATE

--DATETIME2
SELECT SYSDATETIME()
SELECT SYSDATETIMEOFFSET() --�� ���������
SELECT SWITCHOFFSET(SYSDATETIMEOFFSET(), '-06:00')

--�������������� � DATE ��� TIME
SELECT CAST(SYSDATETIME() AS DATE)
SELECT CAST(SYSDATETIME() AS TIME)

--���� �������� ������ ������ ��� ��������� CAST ��� CONVERT ��� FORMAT
-- 'dd.mm.yyyy'
SELECT FORMAT(SYSDATETIME(),'dd.MM.yyyy') as Birthdate
SELECT CONVERT(VarChar, SYSDATETIME(), 104)  --��������� �������� ����
SELECT CONVERT(VarChar, GETDATE(), 104)  --��������� �������� ����

--������������ ���� � �����
SELECT DATEPART(MONTH,SYSDATETIME())
SELECT DATENAME(MONTH,SYSDATETIME()) --���. ����������� ���� ������
SELECT DATEFROMPARTS(2012, 02, 12)
SELECT EOMONTH(SYSDATETIME()) -- ����. ���� ������

--������� ���������� ��� ��������� ����
SELECT DATEADD(year, 1, '20120212') --������� 1 ��� � ����
--�������� ����� ���������� ��������� ����� ����
SELECT DATEDIFF(year, '20111231', '20120101') --�. ������������� ������ ������������ � ����� ������� �� ������. ����� ����
SELECT DATEDIFF(day, '20110212', '20120212') -- 365 ����

--�������� (������� ����)
SELECT 
SWITCHOFFSET('20130212 14:00:00.0000000 -08:00', '-05:00') AS [SWITCHOFFSET], 
TODATETIMEOFFSET('20130212 14:00:00.0000000', '-08:00') AS [TODATETIMEOFFSET]; 