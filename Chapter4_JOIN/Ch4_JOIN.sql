--Chapter4 Комбинирование наборов данных (JOIN)
/*
Перекрестное соединение (cross join) — это простейший и поэтому не самый 
используемый тип соединения. Это соединение выполняет то, что называют 
декартовым произведением двух входных таблиц. Самое большое кол-во строк т.к. умножает строки одной т.на другую
*/
--типовая задача: комбинации из 2х таблиц
--Пример: генерация результирующей таблицы со строкой для каждого дня недели (1—7) и номера смены (1—3) 
--при условии трех смен в день
USE TSQL2012;
SELECT D.n AS theday, S.n AS shiftno 
FROM dbo.Nums AS D 
 CROSS JOIN dbo.Nums AS S 
WHERE D.n <= 7 
 AND S.N <= 3 
ORDER BY theday, shiftno; 

--INNER JOIN - Внутреннее соединение
/*С помощью внутренних соединений можно сопоставлять строки из двух таблиц по предикату, как правило, сравнивая значение первичного ключа в одной таблице с внешним ключом в другой*/
--типовая задача - все строки которые есть в обоих таблицах
SELECT S.companyname AS supplier, S.country, 
 P.productid, P.productname, P.unitprice 
FROM Production.Suppliers AS S 
 INNER JOIN Production.Products AS P 
 ON S.supplierid = P.supplierid 
WHERE S.country = N'Japan'; 
/*
"В чем разница между предложениями ON и WHERE, и существует ли разница, в каком предложении указывают предикат?" 
Для внутренних соединений — нет, не существует. Оба предложения выполняют одну и ту же задачу 
фильтрации данных
*/
--Обычно соединение просходит по первичному и внешнему ключу, если нет, то нужно следить за уникальностью, ибо можно получить дубли, а следовательно неправильный подсчет строк

--Внешние соединения LEFT и RIGHT JOIN и FULL
/*
С помощью внешнего соединения можно запросить сохранение всех строк из 
одной или обеих сторон соединения без учета того, имеются ли соответствующие строки в другой стороне.
Предикат ON тут ВАЖЕН
*/
--Типовая задача: найти все строки, которых нет в другой т.
SELECT S.companyname AS supplier, S.country, 
 P.productid, P.productname, P.unitprice 
FROM Production.Suppliers AS S 
 LEFT OUTER JOIN Production.Products AS P 
 ON S.supplierid = P.supplierid 
WHERE S.country = N'Japan'; 
--ON сопоставляет строки, не фильтрует  WHERE фильтрует 
/*Другими словами, по отношению к сохраненной стороне соединения, предложение ON не является конечным; конечным будет 
предложение WHERE. Поэтому если вы сомневаетесь, указывать предикат в предложении ON или WHERE, задайте себе вопрос: 
для чего будет использоваться предикат — для фильтрации или сопоставления? Будет ли он конечным */

SELECT S.companyname AS supplier, S.country, 
 P.productid, P.productname, P.unitprice 
FROM Production.Suppliers AS S 
 LEFT OUTER JOIN Production.Products AS P 
 ON S.supplierid = P.supplierid 
 AND S.country = N'Japan'; --предложение ON выполнило сопоставления!!1 и добавило всех поставщиков, даже не из Японии

--Запросы с мультисоединениями содержат несколько соединений. В них возможно присутствие разных типов соединений. Логический порядок обработки соединений можно контролировать с помощью круглых скобок или изменением 
--положения предложения ON

 --пример: поставщик из Японии отброшен т. е. внутреннее соединение, которое следовало за внешним соединением, 
--аннулировало внешнюю часть соединения. 
 SELECT S.companyname AS supplier, S.country, 
 P.productid, P.productname, P.unitprice, 
 C.categoryname 
FROM Production.Suppliers AS S 
 LEFT OUTER JOIN Production.Products AS P 
 ON S.supplierid = P.supplierid 
 INNER JOIN Production.Categories AS C 
 ON C.categoryid = P.categoryid 
WHERE S.country = N'Japan'; 
--выделение соединения в логическую фазу
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
--или просто:
 SELECT S.companyname AS supplier, S.country, 
 P.productid, P.productname, P.unitprice, 
 C.categoryname 
FROM Production.Suppliers AS S 
 LEFT OUTER JOIN Production.Products AS P 
 ON S.supplierid = P.supplierid 
 LEFT JOIN Production.Categories AS C 
 ON C.categoryid = P.categoryid 
WHERE S.country = N'Japan'; 

--Напишите запрос, который возвращает всех клиентов, но находит соответствующие им заказы, только если они были размещены в феврале 2008 г. 
--Поскольку как сравнение ID клиента для самого клиента с ID клиента для заказа, 
--так и диапазон дат считаются частью логики сопоставления, то оба сравнения 
--должны быть представлены в предложении ON следующим образом
SELECT C.custid, C.companyname, O.orderid, O.orderdate 
FROM Sales.Customers AS C 
 LEFT OUTER JOIN Sales.Orders AS O 
 ON C.custid = O.custid 
 AND O.orderdate >= '20080201' 
 AND O.orderdate < '20080301'; 
 --Если вы укажете предикат диапазона дат в предложении WHERE, клиенты, которые не разместили заказы в этом месяце, будут отброшены, а это не то, что вам нужно.