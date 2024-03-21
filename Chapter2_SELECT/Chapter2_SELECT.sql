--Ицык Бен Ган, подготовка к сертификации MS SQL;
USE TSQL2012; --Инструкция USE гарантирует, что подключена целевая база данных TSQL2012.
--Использование предложений FROM (указываются табл. и операторы соед) и SELECT (оценивает выражения, присваивает псеводнимы, удаляет дубли DIST)
--Считается хорошей практикой всегда явно указывать имя схемы
--для присваивания псевдонимов исп. явно AS (улучшает читаемость)
--использовать разделители для нерегулярных идентификаторов Идентификатор, не соответствующий правилам форматирования идентификаторов, 
--например, начищающийся с цифры, включающий в себя пробел или являющийся 
--зарезервированным символом T-SQL. 
--"Имя фамилия", "COUNT" -пример стандартного применения

--Работа с типами данных и встроенными функциями
--помнить, что тип данных это ограничение, т.к. имеет явно определенную область поддерживаемых величин.
--Тип данных формирует поведение. Используя неподходящий тип данных, вы теряете все свойственное этому типу данных поведение, инкапсулированное в форме 
--поддерживающих его операторов и функций
/*Другой важный аспект при выборе подходящего типа данных — это размер. Часто 
одним из важнейших факторов, влияющих на производительность запроса, является количество задействованного ввода-вывода. Запрос, который читает меньше 
данных, как правило, работает быстрее.*/
--Итого: нужно использовать наименьший тип данных, удовлетворяющий 
--вашим запросам, не забывая об масштабировании
--FLOAT и REAL - неточные типы данных
--фиксированных типов (CHAR, NCHAR, BINARY) или динамических типов 
--(VARCHAR, NVARCHAR, VARBINARY).
--CHAR(30)использует память на 30 символов вне зависимости от используется 30 или меньше. Для атрибутов, которые часто обновляются и важна производительность обновления

--Ключи
--Св-во столбца идентификатора IDENTITY (любой числовой тип данных)
--Объект последовательности Sequences Независимый объект в БД из которого можно получить новые объекты последовательности 
--Непоследовательные GUID: UNIQUEIDENTIFIER. Для генерации нового GUID вы можете использовать функцию T-SQL NEWID, вызывая его, например, с выражением по умолчанию, прикрепленным к столбцу. 
--Последовательные GUID: NEWSEQUENTIALID
--Пользовательские решения

SELECT 1+'1' -- = 2 INT имеет более высокий приоритет чем VARCHAR - неявное преобразование
SELECT 5/2 -- = 2 INT/INT=INT целочисленные 
SELECT 5.0/2.0 -- = 2.50000 NUMERIC числовое

--Функции символьных типов данных
--поддерживается 2 способа объединения символьных строк: 
--1.оператор "+"
SELECT empid, country, region, city, 
country + N',' + region + N',' + city AS location 
FROM HR.Employees; --если попадутся NULL то вся строка будет - NULL для этого добавь проверки: COALESCE (стандарт) 
--также существует параметр сеанса CONCAT_NULL_YIELDS_NULL - не рекомендуется к исп.
--2. функция CONCAT (заменяет NULL пустой строкой):
SELECT empid, country, region, city, 
CONCAT(country, N',' + region, N',' + city) AS location 
FROM HR.Employees; 

--Извлечение подстроки и ее позиция
SELECT SUBSTRING('abcde', 1, 3)
SELECT LEFT('abcde', 3)
SELECT RIGHT('abcde', 3)
SELECT CHARINDEX(' ','Itzik Ben-Gan')
SELECT LEFT('Itzik Ben-Gan', CHARINDEX(' ', 'Itzik Ben-Gan') - 1) --только имя например
SELECT PATINDEX('%[0-9]%', 'abcd123efgh') --шаблон типа LIKE
--длина в виде СИМВОЛОВ
SELECT LEN(N'xyz') --длина - 3 символа. обрезает пробелы
SELECT LEN(N'xyz ') --все равно 3 символа
--длина в виде байт
SELECT DATALENGTH(N'xyz') --Unicode 2 байта на символ
SELECT DATALENGTH('xyz') --1 байт на символ
--Изменение строк
SELECT REPLACE('.1.2.3.', '.', '/') --заменяет все точки слешем
SELECT REPLICATE('0', 10) --повторяет символ 0 десять раз
SELECT STUFF(',x,y,z', 1, 1, '') 
--Форматирование строк
--[UPPER, LOWER, LTRIM, RTRIM, FORMAT ('входное значение','строка форматирования', культурный код)]
SELECT RTRIM(LTRIM(' ,x,y,z ')) --отсечение ведущих и корневых пробелов по версии MSSQL
SELECT FORMAT(1759, '0000000000')--добавить нули до шаблона

--Выражение CASE
--простая форма
SELECT productid, productname, unitprice, discontinued, 
 CASE discontinued 
 WHEN 0 THEN 'No' 
 WHEN 1 THEN 'Yes' 
 ELSE 'Unknown' --если отсутствует else выведет NULL
 END AS discontinued_desc 
FROM Production.Products;
--Поисковая
SELECT productid, productname, unitprice, 
 CASE 
 WHEN unitprice < 20.00 THEN 'Low' --используются предикаты в выражении WHEN
 WHEN unitprice < 40.00 THEN 'Medium' --первый "истинный" выбирается
 WHEN unitprice >= 40.00 THEN 'High' 
 ELSE 'Unknown' 
 END 
AS pricerange 
FROM Production.Products; 
--также CASE заменяют упрощенно COALESCE и NULLIF - стандарные и нестандарные ISNULL,IIF и др.
--ISNULL более ограничена, пример:
DECLARE 
 @x AS VARCHAR(3) = NULL, 
 @y AS VARCHAR(10) = '1234567890'; 
SELECT COALESCE(@x, @y) AS [COALESCE], ISNULL(@x, @y) AS [ISNULL]; 

--функции для работы с датой:
/*
В документации:
https://learn.microsoft.com/ru-ru/sql/t-sql/functions/date-and-time-data-types-and-functions-transact-sql?view=sql-server-ver16&redirectedfrom=MSDN
*/
--Текущая дата и время
--DATETIME
SELECT GETDATE() --T-SQL
SELECT CURRENT_TIMESTAMP --стандарт, тоже что и GETDATE

--DATETIME2
SELECT SYSDATETIME()
SELECT SYSDATETIMEOFFSET() --со смещением
SELECT SWITCHOFFSET(SYSDATETIMEOFFSET(), '-06:00')

--преобразование в DATE или TIME
SELECT CAST(SYSDATETIME() AS DATE)
SELECT CAST(SYSDATETIME() AS TIME)

--чтоб получить другой формат ДАТ использую CAST или CONVERT или FORMAT
-- 'dd.mm.yyyy'
SELECT FORMAT(SYSDATETIME(),'dd.MM.yyyy') as Birthdate
SELECT CONVERT(VarChar, SYSDATETIME(), 104)  --строковое значение даты
SELECT CONVERT(VarChar, GETDATE(), 104)  --строковое значение даты

--Составляющие даты и время
SELECT DATEPART(MONTH,SYSDATETIME())
SELECT DATENAME(MONTH,SYSDATETIME()) --исп. действующий язык сессии
SELECT DATEFROMPARTS(2012, 02, 12)
SELECT EOMONTH(SYSDATETIME()) -- посл. день месяца

--Функции добавления или вычитания даты
SELECT DATEADD(year, 1, '20120212') --добавит 1 год к дате
--разность между значениями выбранной части даты
SELECT DATEDIFF(year, '20111231', '20120101') --ф. рассматривает только запращиваему и более высокую по иерарх. часть даты
SELECT DATEDIFF(day, '20110212', '20120212') -- 365 дней

--смещение (часовой пояс)
SELECT 
SWITCHOFFSET('20130212 14:00:00.0000000 -08:00', '-05:00') AS [SWITCHOFFSET], 
TODATETIMEOFFSET('20130212 14:00:00.0000000', '-08:00') AS [TODATETIMEOFFSET]; 