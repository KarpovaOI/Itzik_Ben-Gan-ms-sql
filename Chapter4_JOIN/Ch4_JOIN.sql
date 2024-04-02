--Chapter4 �������������� ������� ������ (JOIN)
/*
������������ ���������� (cross join) � ��� ���������� � ������� �� ����� 
������������ ��� ����������. ��� ���������� ��������� ��, ��� �������� 
���������� ������������� ���� ������� ������. ����� ������� ���-�� ����� �.�. �������� ������ ����� �.�� ������
*/
--������� ������: ���������� �� 2� ������
--������: ��������� �������������� ������� �� ������� ��� ������� ��� ������ (1�7) � ������ ����� (1�3) 
--��� ������� ���� ���� � ����
USE TSQL2012;
SELECT D.n AS theday, S.n AS shiftno 
FROM dbo.Nums AS D 
 CROSS JOIN dbo.Nums AS S 
WHERE D.n <= 7 
 AND S.N <= 3 
ORDER BY theday, shiftno; 

--INNER JOIN - ���������� ����������
/*� ������� ���������� ���������� ����� ������������ ������ �� ���� ������ �� ���������, ��� �������, ��������� �������� ���������� ����� � ����� ������� � ������� ������ � ������*/
--������� ������ - ��� ������ ������� ���� � ����� ��������
SELECT S.companyname AS supplier, S.country, 
 P.productid, P.productname, P.unitprice 
FROM Production.Suppliers AS S 
 INNER JOIN Production.Products AS P 
 ON S.supplierid = P.supplierid 
WHERE S.country = N'Japan'; 
/*
"� ��� ������� ����� ������������� ON � WHERE, � ���������� �� �������, � ����� ����������� ��������� ��������?" 
��� ���������� ���������� � ���, �� ����������. ��� ����������� ��������� ���� � �� �� ������ 
���������� ������
*/
--������ ���������� ��������� �� ���������� � �������� �����, ���� ���, �� ����� ������� �� �������������, ��� ����� �������� �����, � ������������� ������������ ������� �����

--������� ���������� LEFT � RIGHT JOIN � FULL
/*
� ������� �������� ���������� ����� ��������� ���������� ���� ����� �� 
����� ��� ����� ������ ���������� ��� ����� ����, ������� �� ��������������� ������ � ������ �������.
�������� ON ��� �����
*/
--������� ������: ����� ��� ������, ������� ��� � ������ �.
SELECT S.companyname AS supplier, S.country, 
 P.productid, P.productname, P.unitprice 
FROM Production.Suppliers AS S 
 LEFT OUTER JOIN Production.Products AS P 
 ON S.supplierid = P.supplierid 
WHERE S.country = N'Japan'; 
--ON ������������ ������, �� ���������  WHERE ��������� 
/*������� �������, �� ��������� � ����������� ������� ����������, ����������� ON �� �������� ��������; �������� ����� 
����������� WHERE. ������� ���� �� ������������, ��������� �������� � ����������� ON ��� WHERE, ������� ���� ������: 
��� ���� ����� �������������� �������� � ��� ���������� ��� �������������? ����� �� �� �������� */

SELECT S.companyname AS supplier, S.country, 
 P.productid, P.productname, P.unitprice 
FROM Production.Suppliers AS S 
 LEFT OUTER JOIN Production.Products AS P 
 ON S.supplierid = P.supplierid 
 AND S.country = N'Japan'; --����������� ON ��������� �������������!!1 � �������� ���� �����������, ���� �� �� ������

--������� � ������������������ �������� ��������� ����������. � ��� �������� ����������� ������ ����� ����������. ���������� ������� ��������� ���������� ����� �������������� � ������� ������� ������ ��� ���������� 
--��������� ����������� ON

 --������: ��������� �� ������ �������� �. �. ���������� ����������, ������� ��������� �� ������� �����������, 
--������������ ������� ����� ����������. 
 SELECT S.companyname AS supplier, S.country, 
 P.productid, P.productname, P.unitprice, 
 C.categoryname 
FROM Production.Suppliers AS S 
 LEFT OUTER JOIN Production.Products AS P 
 ON S.supplierid = P.supplierid 
 INNER JOIN Production.Categories AS C 
 ON C.categoryid = P.categoryid 
WHERE S.country = N'Japan'; 
--��������� ���������� � ���������� ����
SELECT S.companyname AS supplier, S.country, 
 P.productid, P.productname, P.unitprice, 
 C.categoryname 
FROM Production.Suppliers AS S 
 LEFT OUTER JOIN 
 (Production.Products AS P 
 INNER JOIN Production.Categories AS C 
 ON C.categoryid = P.categoryid) 
 ON S.supplierid = P.supplierid 
WHERE S.country = N'Japan'; 
--��� ������:
 SELECT S.companyname AS supplier, S.country, 
 P.productid, P.productname, P.unitprice, 
 C.categoryname 
FROM Production.Suppliers AS S 
 LEFT OUTER JOIN Production.Products AS P 
 ON S.supplierid = P.supplierid 
 LEFT JOIN Production.Categories AS C 
 ON C.categoryid = P.categoryid 
WHERE S.country = N'Japan'; 

--�������� ������, ������� ���������� ���� ��������, �� ������� ��������������� �� ������, ������ ���� ��� ���� ��������� � ������� 2008 �. 
--��������� ��� ��������� ID ������� ��� ������ ������� � ID ������� ��� ������, 
--��� � �������� ��� ��������� ������ ������ �������������, �� ��� ��������� 
--������ ���� ������������ � ����������� ON ��������� �������
SELECT C.custid, C.companyname, O.orderid, O.orderdate 
FROM Sales.Customers AS C 
 LEFT OUTER JOIN Sales.Orders AS O 
 ON C.custid = O.custid 
 AND O.orderdate >= '20080201' 
 AND O.orderdate < '20080301'; 
 --���� �� ������� �������� ��������� ��� � ����������� WHERE, �������, ������� �� ���������� ������ � ���� ������, ����� ���������, � ��� �� ��, ��� ��� �����.