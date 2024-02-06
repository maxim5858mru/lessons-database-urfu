-- Лабораторная работа №4
--
-- «Построение простых SQL-запросов.»
------------------------------------------------------------

USE udb_Kulakov_Maxim_Ivanovic;
GO

-- Примеры
------------------------------------------------------------

-- Пример №1
SELECT au_id, au_lname, au_fname FROM authors;

-- Пример №2 Назначение новых наименований для столбцов
SELECT Идентификатор = au_id, Фамилия = au_fname, Имя = au_lname FROM authors;

-- Пример №3 Назначение новых наименований столбцам, содержащие пробелы или специальные символы
SELECT Идентификатор = au_id, 'Фамилия автора' = au_fname, Имя = au_lname FROM authors;

-- Пример №4 Использоание константы в качестве столбца
SELECT N'Цена $ = ', price FROM titles;

-- Пример №5 Фильтрация WHERE
SELECT id = au_id, name = au_lname, fullname = au_fname FROM authors WHERE city = N'Oakland';

-- Пример №6
SELECT  id = authors.au_id, Фамилия = authors.au_lname, Имя = authors.au_fname FROM authors WHERE city = N'Oakland';

-- Пример №7 Использование формул в качестве определения столбца
SELECT title_id, price, new_price = price * 1.15
FROM udb_Kulakov_Maxim_Ivanovic.dbo.titles
WHERE advance !< $5000;

-- Пример №8 Вычисление формулы если значение одно из столбцов равно NULL
SELECT title_id, ytd_sales, '2 * ytd' = 2 * ytd_sales FROM titles;

-- Пример №9 Вычисление формулы если значение всех столбцов равно NULL
SELECT title_id, ytd_sales, price * ytd_sales FROM titles;

-- Пример №10 Использование псевдонимов, для наименования таблиц
SELECT 'Идентификатор' = a.au_id, name = a.au_lname, fullname = a.au_fname
FROM authors a;

-- Пример №11 Комбинирование использования псевдонимов таблиц для определения столбца и обычного определения столбца
SELECT au_id, au_lname AS Фамилия, a.au_fname FROM authors a;

-- Пример №12 Выборка всех столбцов таблицы «Печатные издания»
SELECT * FROM titles;

-- Пример №13
SELECT * FROM sales;

-- Пример №14
SELECT * FROM titles, sales

-- Пример №15 Фильтрация по выражению использующему несколько столбцов
SELECT * FROM titles, sales WHERE titles.title_id = sales.title_id;

-- Пример №16 Фильтрация по сложному выражению объединённого с помощью логических операторов
SELECT *
FROM titles, sales
WHERE titles.title_id = sales.title_id AND titles.title_id = 'PS2106';

-- Пример №17 Явное внутренее соединени таблиц
SELECT titles.title_id, stor_id, qty * price
FROM titles
         INNER JOIN sales ON titles.title_id = sales.title_id
WHERE titles.title_id = 'PS2106';

-- Пример №18 Внешнее соединение по левой таблице
SELECT titles.title_id, stor_id, qty * titles.price
FROM titles
         LEFT OUTER JOIN sales ON titles.title_id = sales.title_id;

-- Пример №19 Внешнее соединение по обеим таблицам
SELECT titles.title_id, stor_id, qty * titles.price
FROM titles
         FULL OUTER JOIN sales ON titles.title_id = sales.title_id;

-- Пример №20 Запрос соединяющий таблицы «Авторы», «Печатные издания» и таблицы для связи «Печатные здания - Автор»
SELECT authors.*
FROM authors
         INNER JOIN titleauthor
         INNER JOIN titles ON titleauthor.title_id = titles.title_id ON authors.au_id = titleauthor.au_id
WHERE titles.title_id = 'PS2106';

-- Пример №21 Выборка уникальных строк
SELECT au_id FROM titleauthor;
SELECT DISTINCT au_id FROM titleauthor;

-- Пример №22 Агрегатные функции, функция COUNT
SELECT COUNT(*) FROM titleauthor;

-- Пример №23 Подсчёт только уникальных строк
SELECT DISTINCT COUNT(*) FROM titleauthor;

-- Пример №24 Подсёт только уникальных строк, для определённых строк
SELECT COUNT(DISTINCT au_id) FROM titleauthor;

-- Пример №25 Таблица столбцов пользовательских таблиц
SELECT syscolumns.name, sysobjects.name
FROM syscolumns, sysobjects
WHERE sysobjects.id = syscolumns.id AND sysobjects.type = 'U';

-- Пример №26
SELECT sys.columns.name, sys.tables.name
FROM sys.columns
         INNER JOIN sys.tables ON sys.columns.object_id = sys.tables.object_id;

-- Пример №27 Вывод методанных об столбцах таблиц
SELECT * FROM INFORMATION_SCHEMA.COLUMNS;

-- Пример №28 Информация об пользователях базы данных
SELECT * FROM sysusers;

-- Пример №29 Выбор строк, в которых сумма аванса два раза больше стоимости проданных книг
SELECT title_id, ytd_sales, 'advance * 2' = advance * 2, 'price * ytd_sales' = price * titles.ytd_sales
FROM titles
WHERE advance * 2 > ytd_sales * price

-- Пример №30 Выбор строк, для которых количество продаж находится в нужном диапазоне
SELECT title_id, ytd_sales, price * ytd_sales
FROM titles
WHERE ytd_sales BETWEEN 4095 AND 12000;

-- Пример №31 Фильтрация с использованием BETWEEN для строковых значений
SELECT au_id AS ID, au_lname, state AS N'Штат | Страна'
FROM authors
WHERE state BETWEEN N'A1' AND N'YA';

-- Пример №32 Фильтрация с использованием IN
SELECT id = au_id, name = au_lname, state = state
FROM authors
WHERE state IN (N'CA', N'IN', N'MD');

-- Пример №33 Фильтрация с использование LIKE
SELECT au_lname AS Фамилия, au_fname Имя, Телефон = phone
FROM authors
WHERE phone LIKE '415%';

-- Пример №34
SELECT id = au_id, name = au_lname, phone = phone
FROM authors
WHERE phone LIKE '4_5%';

-- Пример №35
SELECT id = au_id, name = au_lname, phone = phone
FROM authors
WHERE phone LIKE '[2-7]1[2-9]%';

-- Пример №36
SELECT id = au_id, name = au_lname, phone = phone
FROM authors
WHERE phone LIKE '[^2-7]1[2-9]%';

-- Пример №37 Фильтрация с использованием NOT LIKE
SELECT id = au_id, name = au_lname, phone = phone
FROM authors
WHERE phone NOT LIKE '415%';

-- Пример №38 Сравнение результатов запросов
SELECT au_lname, state FROM authors WHERE state = 'IN';
SELECT au_lname, state FROM authors WHERE state LIKE 'IN';

-- Пример №39 Сравнение результатов запросов
SELECT title_id, type, advance FROM titles WHERE advance IS NULL;
SELECT title_id, type, advance FROM titles WHERE advance = NULL;

-- Пример №40 Сравнение результатов запросов
SELECT title_id, type, advance FROM titles WHERE advance IS NOT NULL;
SELECT title_id, type, advance FROM titles WHERE advance > 0;
GO

-- Выполнение индивидуального варианта. Вариант №0
------------------------------------------------------------

-- 1 Вывод количества столбцов
SELECT COUNT(syscolumns.name) AS N'Количество столбцов таблицы «Авторы»'
FROM sys.syscolumns, sys.sysobjects
WHERE sysobjects.id = syscolumns.id AND sysobjects.type = 'U' AND sysobjects.name = 'authors';
GO

-- 2 Подсчёт количества изданий, которые написал Мамаев
SELECT COUNT(titles.title) AS N'Количество книг написанных Мамаевым'
FROM titleauthor
         LEFT OUTER JOIN authors ON titleauthor.au_id = authors.au_id
         LEFT OUTER JOIN titles  ON titleauthor.title_id = titles.title_id
WHERE authors.au_fname = N'Мамаев';

-- 3 Вывод всех авторов в названии книг которых содержется слово "Server"
SELECT authors.*
FROM titleauthor
         LEFT OUTER JOIN authors ON titleauthor.au_id = authors.au_id
         LEFT OUTER JOIN titles  ON titleauthor.title_id = titles.title_id
WHERE titles.title LIKE N'%Server%';

-- 4 Вывод сведений о книгах с максимальной стоимостью
SELECT *
FROM titles
WHERE titles.price = (SELECT MAX(price) FROM titles);
GO