-- Лабораторная работа №3
--
-- «Загрузка таблиц базы. Передача данных между таблицами.»
------------------------------------------------------------

USE udb_Kulakov_Maxim_Ivanovic;
GO

-- Удаление таблицы созданной путём копирования записей
DROP TABLE IF EXISTS authors_UT;
GO

-- Очистка таблиц, для частичного перевыполнения скрипта
DELETE titleauthor;
DELETE sales;
DELETE authors;
DELETE titles;
GO

-- Удаление дубликата таблицы «Автора»
DROP TABLE IF EXISTS authors_UT;
GO

-- Добавление строк из файла
------------------------------------------------------------

-- Добавленис трое для таблицы «Авторы»
INSERT INTO authors (au_id, au_lname, au_fname, phone, address, city, state, zip, contract)
VALUES ('111-00-0004', N'Алексей', N'Хохлов', '223 226-2295', N'589 5-я Строителей', N'С-Петербург', N'РФ', '94113', 0),
       ('409-56-7008', N'Bennet', N'Abraham', '415 658-9932', N'6223 Bateman St.', N'Berkeley', N'CA', '94705', 1),
       ('213-46-8915', N'Green', N'Marjorie', '415 986-7020', N'309 63rd St. #411', N'Oakland', N'CA', '94618', 1),
       ('238-95-7766', N'Carson', N'Cheryl', '415 548-7723', N'589 Darwin Ln.', N'Berkeley', N'CA', '94705', 1),
       ('111-00-0001', N'Игорь', N'Фигурнов', '223 226-8884', N'589 Б.Полянка', N'Москва', N'РФ', '94111', 1),
       ('998-72-3567', N'Ringer', N'Albert', '801 826-0752', N'67 Seventh Av.', N'Salt Lake City', N'UT', '84152', 1),
       ('899-46-2035', N'Ringer', N'Anne', '801 826-0752', N'67 Seventh Av.', N'Salt Lake City', N'UT', '84152', 1),
       ('111-00-0002', N'Сергей', N'Каратыгин', '223 226-2294', N'589 2-я Ямская', N'Москва', N'РФ', '94112', 1),
       ('722-51-5454', N'DeFrance', N'Michel', '219 547-9982', N'3 Balding Pl.', N'Gary', N'IN', '46403', 1),
       ('807-91-6654', N'Panteley', N'Sylvia', '301 946-8853', N'1956 Arlington Pl.', N'Rockville', N'MD', '20853', 1),
       ('893-72-1158', N'McBadden', N'Heather', '707 448-4982', N'301 Putnam', N'Vacaville', N'CA', '95688', 0),
       ('724-08-9931', N'Stringer', N'Dirk', '415 843-2991', N'5420 Telegraph Av.', N'Oakland', N'CA', '94609', 0),
       ('274-80-9391', N'Straight', N'Dean', '415 834-2919', N'5420 College Av.', N'Oakland', N'CA', '94609', 1),
       ('756-30-7391', N'Karsen', N'Livia', '415 534-9219', N'5720 McAuley St.', N'Oakland', N'CA', '94609', 1),
       ('724-80-9391', N'MacFeather', N'Stearns', '415 354-7128', N'44 Upland Hts.', N'Oakland', N'CA', '94612', 1),
       ('427-17-2319', N'Dull', N'Ann', '415 836-7128', N'3410 Blonde St.', N'Palo Alto', N'CA', '94301', 1),
       ('672-71-3249', N'Yokomoto', N'Akiko', '415 935-4228', N'3 Silver Ct.', N'Walnut Creek', N'CA', '94595', 1),
       ('267-41-2394', N'O''Leary', N'Michael', '408 286-2428', N'22 Cleveland Av. #14', N'San Jose', N'CA', '95128', 1),
       ('472-27-2349', N'Gringlesby', N'Burt', '707 938-6445', N'PO Box 792', N'Covelo', N'CA', '95428', 3),
       ('527-72-3246', N'Greene', N'Morningstar', '615 297-2723', N'22 Graybar House Rd.', N'Nashville', N'TN', '37215', 0),
       ('172-32-1176', N'White', N'Johnson', '408 496-7223', N'10932 Bigge Rd.', N'Menlo Park', N'CA', '94025', 1),
       ('712-45-1867', N'del Castillo', N'Innes', '615 996-8275', N'2286 Cram Pl. #86', N'Ann Arbor', N'MI', '48105', 1),
       ('846-92-7186', N'Hunter', N'Sheryl', '415 836-7128', N'3410 Blonde St.', N'Palo Alto', N'CA', '94301', 1),
       ('486-29-1786', N'Locksley', N'Charlene', '415 585-4620', N'18 Broadway Av.', N'San Francisco', N'CA', '94130', 1),
       ('648-92-1872', N'Blotchet-Halls', N'Reginald', '503 745-6402', N'55 Hillsdale Bl.', N'Corvallis', N'OR', '97330', 1),
       ('341-22-1782', N'Smith', N'Meander', '913 843-0462', N'10 Mississippi Dr.', N'Lawrence', N'KS', '66044', 0);
GO

-- Добавление строк в таблицу «Печатные издания»
SET DATEFORMAT dmy;
INSERT INTO titles (title_id, title, type, pub_id, price, advance, royalty, ytd_sales, notes, pubdate)
VALUES ('PC1111', N'Популярно о компьютере', 'popular_comp', '1389', $20.00, $8000.00, 10, 4095, N'Muckraking reporting on the world''s largest computer hardware and software manufacturers.', '06/12/94'),
       ('PC8888', N'Secrets of Silicon Valley', 'popular_comp', '1389', $20.00, $8000.00, 10, 4095, N'Muckraking reporting on the world''s largest computer hardware and software manufacturers.', '06/12/94'),
       ('BU1032', N'The Busy Executive''s Database Guide', 'business', '1389', $19.99, $5000.00, 10, 4095, N'An overview of available database systems with emphasis on common business applications. Illustrated.', '06/12/91'),
       ('PS7777', N'Emotional Security: A New Algorithm', 'psychology', '0736', $7.99, $4000.00, 10, 3336, N'Protecting yourself and your loved ones from undue emotional stress in the modern world. Use of computer and nutritional aids emphasized.', '06/12/91'),
       ('PS3333', N'Prolonged Data Deprivation: Four Case Studies', 'psychology', '0736', $19.99, $2000.00, 10, 4072, N'What happens when the data runs dry? Searching evaluations of information-shortage effects.', '06/12/91'),
       ('BU1111', N'Cooking with Computers: Surreptitious Balance Sheets', 'business', '1389', $11.95, $5000.00, 10, 3876, N'Helpful hints on how to use your electronic resources to the best advantage.', '06/09/91'),
       ('MC2222', N'Silicon Valley Gastronomic Treats', 'mod_cook', '0877', $19.99, $0.00, 12, 2032, N'Favorite recipes for quick, easy, and elegant meals.', '06/09/91'),
       ('TC7777', N'Sushi, Anyone?', 'trad_cook', '0877', $14.99, $8000.00, 10, 4095, N'Detailed instructions on how to make authentic Japanese sushi in your spare time.', '06/12/91'),
       ('TC4203', N'Fifty Years in Buckingham Palace Kitchens', 'trad_cook', '0877', $11.95, $4000.00, 14, 15096, N'More anecdotes from the Queens favorite cook describing life among English royalty. Recipes, techniques, tender vignettes.', '06/12/91'),
       ('PC1035', N'But Is It User Friendly?', 'popular_comp', '1389', $22.95, $7000.00, 16, 8780, N'A survey of software for the naive user, focusing on the friendliness of each.', '06/12/91'),
       ('BU2075', N'You Can Combat Computer Stress!', 'business', '0736', $2.99, $10125.00, 24, 18722, N'The latest medical and psychological techniques for living with the electronic office. Easy-to-understand explanations.', '06/12/91'),
       ('PS2095', N'Is Anger the Enemy?', 'psychology', '0736', $10.95, $2275.00, 12, 2045, N'Carefully researched study of the effects of strong emotions on the body. Metabolic charts included.', '06/12/91'),
       ('PS2106', N'Life Without Fear', 'psychology', '0736', $7.00, $6000.00, 10, 111, N'New exercise, meditation, and nutritional techniques that can reduce the shock of daily interactions. Popular audience. Sample menus included, exercise video available separately.', '10/05/91'),
       ('MC3021', N'The Gourmet Microwave', 'mod_cook', '0877', $2.99, $15000.00, 24, 22246, N'Traditional French gourmet recipes adapted for modern microwave cooking.', '06/12/91'),
       ('TC3219', N'Onions, Leeks, and Garlic: Cooking Secrets of the Mediterranean', 'trad_cook', '0877', $20.95, $7000.00, 10, 375, N'Profusely illustrated in color, this makes a wonderful gift book for a cuisine-oriented friend.', '21/10/91'),
       ('BU7832', N'Straight Talk About Computers', 'business', '1389', $19.99, $5000.00, 10, 4095, N'Annotated analysis of what computers can do for you: a no-hype guide for the critical user.', '22/06/91'),
       ('PS1372', N'Computer Phobic AND Non-Phobic Individuals: Behavior Variations', 'psychology', '0877', $21.59, $7000.00, 10, 375, N'A must for the specialist, this book examines the difference between those who hate and fear computers and those who don''t.', '21/10/91'),
       ('PC8889', N'Secrets of Silicon Valley', 'popular_comp', '1389', $20.00, $8000.00, 10, 4095, N'Muckraking reporting on the world''s largest computer hardware and software manufacturers.', '06/12/94');
INSERT titles (title_id, title, pub_id) VALUES('MC3026', N'The Psychology of Computer Cooking', '0877');
INSERT titles (title_id, title, type, pub_id, notes) VALUES('PC9999', N'Net Etiquette', 'popular_comp', '1389', N'A must-read for computer conferencing.');
GO

-- Добавление данных в таблицу «Продажи»
SET DATEFORMAT mdy
INSERT INTO sales (stor_id, ord_num, ord_date, qty, payterms, title_id)
VALUES ('7131', 'N914014', '09/14/94', 25, 'Net 30','MC3021'),
       ('8042', '423LL922', '09/14/94', 15, 'ON invoice','MC3021'),
       ('8042', '423LL930', '09/14/94', 10, 'ON invoice','BU1032'),
       ('6380', '6871', '09/14/94', 5, 'Net 60','BU1032'),
       ('8042','P723', '03/11/93', 25, 'Net 30', 'BU1111'),
       ('7896','X999', '02/21/93', 35, 'ON invoice', 'BU2075'),
       ('7896','QQ2299', '10/28/93', 15, 'Net 60', 'BU7832'),
       ('7896','TQ456', '12/12/93', 10, 'Net 60', 'MC2222'),
       ('8042','QA879.1', '5/22/93', 30, 'Net 30', 'PC1035'),
       ('7066','A2976', '5/24/93', 50, 'Net 30', 'PC8888'),
       ('7131','P3087a', '5/29/93', 20, 'Net 60', 'PS1372'),
       ('7131','P3087a', '5/29/93', 25, 'Net 60', 'PS2106'),
       ('7131','P3087a', '5/29/93', 15, 'Net 60', 'PS3333'),
       ('7131','P3087a', '5/29/93', 25, 'Net 60', 'PS7777'),
       ('7067','P2121', '6/15/92', 20, 'Net 30', 'TC4203'),
       ('7067','P2121', '6/15/92', 20, 'Net 30', 'TC7777');

-- INSERT sales VALUES('7066', 'QA7442.3', '09/13/94', 75, 'ON invoice','PS2091');
-- INSERT sales VALUES('7067', 'D4482', '09/14/94', 10, 'Net 60','PS2091');
-- INSERT sales VALUES('7131', 'N914008', '09/14/94', 20, 'Net 30','PS2091');
-- INSERT sales VALUES('6380', '722a', '09/13/94', 3, 'Net 60','PS2091');
-- INSERT sales VALUES('7067','P2121', '6/15/92', 40, 'Net 30', 'TC3218');
GO

-- Добавление данных в таблицу для связи «Печатные издания - Автор»
INSERT titleauthor (au_id, title_id, au_ord, royaltyper)
VALUES ('409-56-7008', 'BU1032', 1, 60),
       ('486-29-1786', 'PS7777', 1, 100),
       ('486-29-1786', 'PC9999', 1, 100),
       ('712-45-1867', 'MC2222', 1, 100),
       ('172-32-1176', 'PS3333', 1, 100),
       ('213-46-8915', 'BU1032', 2, 40),
       ('238-95-7766', 'PC1035', 1, 100),
       ('213-46-8915', 'BU2075', 1, 100),
       ('998-72-3567', 'PS2106', 1, 100),
       ('722-51-5454', 'MC3021', 1, 75),
       ('274-80-9391', 'BU7832', 1, 100),
       ('427-17-2319', 'PC8888', 1, 50),
       ('846-92-7186', 'PC8888', 2, 50),
       ('756-30-7391', 'PS1372', 1, 75),
       ('724-80-9391', 'PS1372', 2, 25),
       ('724-80-9391', 'BU1111', 1, 60),
       ('267-41-2394', 'BU1111', 2, 40),
       ('672-71-3249', 'TC7777', 1, 40),
       ('267-41-2394', 'TC7777', 2, 30),
       ('472-27-2349', 'TC7777', 3, 30),
       ('648-92-1872', 'TC4203', 1, 100);

-- INSERT titleauthor VALUES ('111-00-0004', 'PC2222', 1, 100);
-- INSERT titleauthor VALUES ('998-72-3567', 'PS2091', 1, 50);
-- INSERT titleauthor VALUES ('899-46-2035', 'PS2091', 2, 50);
-- INSERT titleauthor VALUES ('899-46-2035', 'MC3021', 2, 25);
-- INSERT titleauthor VALUES ('807-91-6654', 'TC3218', 1, 100);
GO

-- Вывод значений из таблцы «Авторы»
SELECT * FROM authors;

-- Вывод значений из таблцы «Печатные издания»
SELECT * FROM titles;

-- Вывод значений из таблцы «Продажи»
SELECT * FROM sales;

-- Вывод значений из таблцы для связи «Печатные издания - Автор»
SELECT * FROM titleauthor
GO

-- Добавление данных в отдельную таблицу, а после
-- копирование данных из новой таблицы в старую
------------------------------------------------------------

-- Копирование авторов из штата 'UT' в отдельную таблицу
SELECT *
INTO authors_UT
FROM authors
WHERE state = N'UT';
GO

-- Копирование из новой таблицы в старую
INSERT INTO authors (au_id, au_lname, au_fname,phone, address, city, state, zip, contract)
SELECT CONCAT(SUBSTRING(au_id, 1, LEN(au_id) - 1), '0'), au_lname, au_fname, phone, address, city, state, zip, contract
FROM authors_UT;

-- INSERT INTO authors (au_id, au_lname, au_fname,phone, address, city, state, zip, contract)
-- SELECT au_id, au_lname, au_fname, phone, address, city, state, zip, contract
-- FROM authors_UT;

GO

-- Создание представления отображающего все данные
------------------------------------------------------------
CREATE OR ALTER VIEW AllData AS
SELECT T.title_id                                            AS N'Идентификатор издания',
       T.title                                               AS N'Название',
       T.type                                                AS N'Категория',
       T.pub_id                                              AS N'Издатель',
       T.price                                               AS N'Цена',
       T.advance                                             AS N'Аванс',
       T.royalty                                             AS N'Процент авторского гонорара',
       T.ytd_sales                                           AS N'Продано',
       T.notes                                               AS N'Примечание',
       T.pubdate                                             AS N'Дата публикации',
       L.au_ord                                              AS N'Порядковый номер автора',
       L.royaltyper                                          AS N'Процент авторского гонорара за книгу',
       A.au_id                                               AS N'Идентификатор автора',
       A.au_lname                                            AS N'Фамилия',
       A.au_fname                                            AS N'Имя',
       A.phone                                               AS N'Номер телефона',
       A.address                                             AS N'Адрес',
       A.city                                                AS N'Город',
       A.state                                               AS N'Штат',
       A.zip                                                 AS N'Индекс',
       CASE WHEN A.contract = 1 THEN N'Есть' ELSE N'Нет' END AS N'Контракт',
       S.stor_id                                             AS N'ID для внешней таблицы',
       S.ord_num,
       S.ord_date                                            AS N'Дата поставки партии',
       S.qty                                                 AS N'Количество экземпляров',
       S.payterms                                            AS N'Условия оплаты'
FROM titleauthor AS L
            LEFT OUTER JOIN authors AS A ON L.au_id = A.au_id
            LEFT OUTER JOIN titles AS T ON L.title_id = T.title_id
            FULL OUTER JOIN sales AS S ON T.title_id = S.title_id
GO

SELECT * FROM AllData;
GO

-- Выполнение индивидуального варианта. Вариант №0
------------------------------------------------------------

-- Настройка формата данных
SET DATEFORMAT dmy;

-- Добавление книги
INSERT INTO titles (title_id, title, type, pub_id, price, advance, royalty, ytd_sales, notes, pubdate)
VALUES ('MS0000', N'Microsoft SQL Server 2000', DEFAULT, '0001', $10, 4500, 15, 6785,
        N'Книга посвящена одной из самых мощных и популярных современных систем управления базами данных - Microsoft SQL Server 2000.',
        '18.02.2001');

-- Добавление автора
INSERT INTO authors (au_id, au_lname, au_fname, phone, address, city, state, zip, contract)
VALUES ('000-01-2345', N'Евгений', N'Мамаев', '578 589-7246', N'128а Республики', N'Москва', N'РФ', 75186, 0);

-- Связывание «Автора» и «Печатного изддания»
INSERT INTO titleauthor (au_id, title_id, au_ord, royaltyper)
VALUES ((SELECT au_id FROM authors WHERE au_lname = N'Евгений' AND au_fname = N'Мамаев'),
        (SELECT title_id FROM titles WHERE title = N'Microsoft SQL Server 2000'), 5, 200);

-- Добавление сведений об продажах
INSERT INTO sales (stor_id, ord_num, ord_date, qty, payterms, title_id)
VALUES (1873, 'RFW5951', '21.08.2023', 10, 'ON invoice',
        (SELECT title_id FROM titles WHERE title = N'Microsoft SQL Server 2000')),
       (1879, 'RFW968', '05.02.2024', 5, 'Net 60',
        (SELECT title_id FROM titles WHERE title = N'Microsoft SQL Server 2000'));
GO