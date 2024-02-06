-- Лабораторные работы по пердмету «Базы данных» УрФУ
------------------------------------------------------------

-- Перевод базы данных в однопользовательский режим
IF EXISTS (SELECT name FROM dbo.sysdatabases WHERE name = 'udb_Kulakov_Maxim_Ivanovic')
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

USE master;
GO

-- Удаление её, если она уже создана
DROP DATABASE IF EXISTS [udb_Kulakov_Maxim_Ivanovic];
GO

-- Лабораторная работа №1
--
-- «Знакомство с утилитами администрирования сервера.
-- Создание пользовательской базы с заданными параметрами.»
------------------------------------------------------------

-- Создание базы данных, согласно указанным параметрам в
-- конструкторе
------------------------------------------------------------
CREATE DATABASE [udb_Kulakov_Maxim_Ivanovic]
    CONTAINMENT = NONE
    ON PRIMARY
    (
        NAME = [udb_Kulakov_Maxim_Ivanovic_primary],
        FILENAME = N'/var/opt/mssql/data/udb_Kulakov_Maxim_Ivanovic_primary.mdf',
        SIZE = 3072 KB,
        FILEGROWTH = 65536 KB
    ),
    FILEGROUP SECONDLY
    (
        NAME = [udb_Kulakov_Maxim_Ivanovic_secondly],
        FILENAME = N'/var/opt/mssql/data/udb_Kulakov_Maxim_Ivanovic_secondly.ndf',
        SIZE = 3072 KB,
        FILEGROWTH = 65536 KB
    )
    LOG ON
    (
        NAME = [udb_Kulakov_Maxim_Ivanovic_log],
        FILENAME = N'/var/opt/mssql/data/udb_Kulakov_Maxim_Ivanovic_log.ldf',
        SIZE = 1024 KB,
        FILEGROWTH = 65536 KB
    );
GO

-- Установка параметров по умолчанию для базы данных, согласно параметрам в конструкторе
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET COMPATIBILITY_LEVEL = 150;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET ANSI_NULL_DEFAULT OFF;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET ANSI_NULLS OFF;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET ANSI_PADDING OFF;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET ANSI_WARNINGS OFF;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET ARITHABORT OFF;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET AUTO_CLOSE OFF;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET AUTO_SHRINK OFF;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET AUTO_CREATE_STATISTICS ON (INCREMENTAL = OFF);
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET AUTO_UPDATE_STATISTICS ON;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET CURSOR_CLOSE_ON_COMMIT OFF;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET CURSOR_DEFAULT GLOBAL;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET CONCAT_NULL_YIELDS_NULL OFF;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET NUMERIC_ROUNDABORT OFF;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET QUOTED_IDENTIFIER OFF;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET RECURSIVE_TRIGGERS OFF;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET DISABLE_BROKER;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET AUTO_UPDATE_STATISTICS_ASYNC OFF;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET DATE_CORRELATION_OPTIMIZATION OFF;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET PARAMETERIZATION SIMPLE;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET READ_COMMITTED_SNAPSHOT OFF;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET READ_WRITE;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET RECOVERY FULL;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET MULTI_USER;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET PAGE_VERIFY CHECKSUM;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET TARGET_RECOVERY_TIME = 60 SECONDS;
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET DELAYED_DURABILITY = DISABLED;
GO

USE [udb_Kulakov_Maxim_Ivanovic];
GO

-- Изменение конфигурации базы данных, согласно значениям по умолчанию из конструктора
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO

USE [udb_Kulakov_Maxim_Ivanovic];
GO

-- Проверка главной группы файлов и её изменение, согласно параметрам из конструктора
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default = 1 AND name = N'PRIMARY')
ALTER DATABASE udb_Kulakov_Maxim_Ivanovic MODIFY FILEGROUP [PRIMARY] DEFAULT;
GO

-- Просмотр информации об созданной базе данных
------------------------------------------------------------
EXECUTE sp_helpdb N'udb_Kulakov_Maxim_Ivanovic';
GO

-- Просмотр всех параметров созданной базы данных
------------------------------------------------------------
SELECT *
FROM sys.databases
WHERE name = 'udb_Kulakov_Maxim_Ivanovic';

-- Изменение 11 параметра, согласно последней цифре в
-- студенческом билете
------------------------------------------------------------
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET CURSOR_CLOSE_ON_COMMIT ON;
GO

-- Создание произвольной таблицы, через конструктор
------------------------------------------------------------

-- Удаление таблицы, чтобы можно было её пересоздать не выполняя весь скрипт
DROP TABLE IF EXISTS [TestTable];
GO

-- Настройка сессии
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- Создание таблицы
CREATE TABLE [TestTable]
(
    Id          INT            NOT NULL,
    Name        NVARCHAR(MAX)  NOT NULL,
    Date        DATETIME       NOT NULL,
    Owner       VARCHAR(50)    NULL,
    MainValue   FLOAT          NOT NULL,
    SecondValue DECIMAL(18, 0) NULL,
    Formula     AS (SecondValue + Id),
    CONSTRAINT PK_TestTable PRIMARY KEY CLUSTERED (Id ASC) WITH
    (
        PAD_INDEX = OFF,
        STATISTICS_NORECOMPUTE = OFF,
        IGNORE_DUP_KEY = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON,
        OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ) ON SECONDLY,
    CONSTRAINT UQ_TestTable_Owner UNIQUE NONCLUSTERED (Owner ASC) WITH
    (
        PAD_INDEX = OFF,
        STATISTICS_NORECOMPUTE = OFF,
        IGNORE_DUP_KEY = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON,
        OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ) ON [PRIMARY]
) ON SECONDLY TEXTIMAGE_ON SECONDLY;
GO

-- Добавление указанных в конструкторе ограничений
ALTER TABLE [dbo].[TestTable] ADD CONSTRAINT DF_TestTable_SecondValue DEFAULT (NULL) FOR SecondValue;
ALTER TABLE [dbo].[TestTable] WITH NOCHECK ADD CONSTRAINT CK_TestTable_Date CHECK ((Date > GETDATE()));
ALTER TABLE [dbo].[TestTable] CHECK CONSTRAINT CK_TestTable_Date;
GO

-- Лабораторная работа №2
--
-- «Создание таблиц базы данных под
-- управлением Microsoft SQL Server.»
------------------------------------------------------------

USE [udb_Kulakov_Maxim_Ivanovic];
GO

-- Создание таблиц «Авторы» и «Продажи», согласно параметрам
-- конструктора таблиц
------------------------------------------------------------

-- Создание таблицы «Авторы»
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE [authors]
(
    [au_id]    VARCHAR(11) NOT NULL, -- Уникальный идентификатор автора
    [au_lname] VARCHAR(40) NOT NULL, -- Фамилия
    [au_fname] VARCHAR(20) NOT NULL, -- Имя
    [phone]    CHAR(12)    NOT NULL, -- Номер телефона
    [address]  VARCHAR(40) NULL,     -- Адрес
    [city]     VARCHAR(20) NULL,     -- Город
    [state]    CHAR(2)     NULL,     -- Штат
    [zip]      INT         NULL,     -- Почтовый индекс
    [contract] BIT         NOT NULL, -- Заключён ли контракт
    CONSTRAINT PK_authors PRIMARY KEY CLUSTERED (au_id ASC) WITH
    (
        PAD_INDEX = OFF,
        STATISTICS_NORECOMPUTE = OFF,
        IGNORE_DUP_KEY = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON,
        OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ) ON [PRIMARY]
) ON [PRIMARY];
GO

-- Создание таблицы «Продажи»
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
CREATE TABLE [sales]
(
    [stor_id]  CHAR(4)     NOT NULL,
    [ord_num]  VARCHAR(20) NOT NULL,
    [ord_date] DATETIME    NOT NULL,
    [qty]      SMALLINT    NOT NULL,
    [payterms] VARCHAR(12) NULL,
    [title_id] CHAR(6)  NOT NULL,
    CONSTRAINT PK_sales PRIMARY KEY CLUSTERED (stor_id ASC, ord_num ASC, title_id ASC) WITH
    (
        PAD_INDEX = OFF,
        STATISTICS_NORECOMPUTE = OFF,
        IGNORE_DUP_KEY = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON,
        OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ) ON [PRIMARY]
) ON [PRIMARY];
GO

-- Добавление требуемых ограничений
ALTER TABLE [authors] ADD  CONSTRAINT [DF_authors_phone]  DEFAULT ('UNKNOWN') FOR [phone];
ALTER TABLE [authors] WITH CHECK ADD  CONSTRAINT [CK_authors_au_id] CHECK  (([au_id] like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'));
ALTER TABLE [authors] CHECK CONSTRAINT [CK_authors_au_id];
ALTER TABLE [authors] WITH CHECK ADD  CONSTRAINT [CK_authors_state] CHECK  (([state] like '[A-Z][A-Z]'));
ALTER TABLE [authors] CHECK CONSTRAINT [CK_authors_state];
ALTER TABLE [authors] WITH CHECK ADD  CONSTRAINT [CK_authors_zip] CHECK  (([zip] like '[0-9][0-9][0-9][0-9][0-9]'));
ALTER TABLE [authors] CHECK CONSTRAINT [CK_authors_zip];
GO

-- Добавление описаний к объектам
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Уникальный идентификатор' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'COLUMN',@level2name=N'au_id';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Фамилия' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'COLUMN',@level2name=N'au_lname';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Имя' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'COLUMN',@level2name=N'au_fname';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Телефон' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'COLUMN',@level2name=N'phone';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Адрес' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'COLUMN',@level2name=N'address';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Город' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'COLUMN',@level2name=N'city';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Штат' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'COLUMN',@level2name=N'state';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Почтовый индекс' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'COLUMN',@level2name=N'zip';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Наличие контракта' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'COLUMN',@level2name=N'contract';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица «Авторы»' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ограничение указывающие на соотвествие первичного ключа, формату полиса социального страхования.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'CONSTRAINT',@level2name=N'CK_authors_au_id';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Обозначение штата может содержать только 2 большие буквы.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'CONSTRAINT',@level2name=N'CK_authors_state';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Почтовый индекс долден состоять из 5 десятичных цифр.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'authors', @level2type=N'CONSTRAINT',@level2name=N'CK_authors_zip';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Значения связанные с другой базой данных' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sales', @level2type=N'COLUMN',@level2name=N'stor_id';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Дата поставки партии' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sales', @level2type=N'COLUMN',@level2name=N'ord_date';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Количество экземпляров' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sales', @level2type=N'COLUMN',@level2name=N'qty';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Условия оплаты' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sales', @level2type=N'COLUMN',@level2name=N'payterms';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID книги' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sales', @level2type=N'COLUMN',@level2name=N'title_id';
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Таблица «Продажи»' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'sales';
GO

-- Создание таблицы «Печатные издания» и таблицы для
-- связи «Печатные издания - Автор»
------------------------------------------------------------

-- Создание таблицы «Печатные издания»
CREATE TABLE titles
(
    title_id  CHAR(6),               -- Идентификатор издания
    title     VARCHAR(80)  NOT NULL, -- Название книги
    type      CHAR(12)     NOT NULL  -- Категория литературы
        CONSTRAINT DF_title_type DEFAULT 'UNDECIDED',
    pub_id    CHAR(4)      NULL,     -- Издательство
    price     MONEY        NULL,     -- Цена
    advance   MONEY        NULL,     -- Сумма аванса
    royalty   INT          NULL,     -- Процент авторского гонорара
    ytd_sales INT          NULL,     -- Количество проданных книг
    notes     VARCHAR(200) NULL,     -- Примечание
    pubdate   DATETIME     NOT NULL  -- Дата передачи в печать
        CONSTRAINT DF_titles_pubdate DEFAULT GETDATE(),
    CONSTRAINT PK_titles PRIMARY KEY CLUSTERED (title_id),
    CONSTRAINT CK_titles_title_id CHECK (title_id LIKE '[A-Za-z][A-Za-z][0-9][0-9][0-9][0-9]')
) ON [PRIMARY];

-- Создание таблицы для связи «Печатные издания - Автор»
CREATE TABLE titleauthor
(
    au_id      VARCHAR(11) NOT NULL, -- Ссылка на автора
    title_id   CHAR(6)     NOT NULL, -- Ссылка на издание
    au_ord     TINYINT     NULL,     -- Порядковый номер автора, в списке соавторов
    royaltyper INT         NULL,     -- Процент авторского гонорара за написание книги
    CONSTRAINT PR_titleauthor PRIMARY KEY CLUSTERED (au_id, title_id),
    CONSTRAINT FK_titleauthor_To_authors FOREIGN KEY (au_id)
        REFERENCES authors (au_id),
    CONSTRAINT FK_titleauthors_To_titles FOREIGN KEY (title_id)
        REFERENCES titles (title_id)
) ON [PRIMARY];

-- Добавление связи между таблицами «Продажи» и «Печатные издания»
ALTER TABLE sales ADD CONSTRAINT FK_sales_To_titles FOREIGN KEY (title_id) REFERENCES titles (title_id);
GO

-- Исправление ошибок
------------------------------------------------------------

-- Исправление ошибок связанных с типом текстовых данных
ALTER TABLE authors ALTER COLUMN au_lname NVARCHAR(40);
ALTER TABLE authors ALTER COLUMN au_fname NVARCHAR(20);
ALTER TABLE authors ALTER COLUMN address NVARCHAR(40);
ALTER TABLE authors ALTER COLUMN city NVARCHAR(20);
ALTER TABLE authors DROP CK_authors_state;
ALTER TABLE authors ALTER COLUMN state NCHAR(2);
ALTER TABLE authors WITH CHECK ADD CONSTRAINT CK_authors_state CHECK (state LIKE N'[A-ZА-Я][A-ZА-Я]');
ALTER TABLE titles ALTER COLUMN title NVARCHAR(80);
ALTER TABLE titles ALTER COLUMN notes NVARCHAR(200);
GO

-- Проверка возможности использования неправильных значений
------------------------------------------------------------

EXECUTE sp_rename N'dbo.TestTable', N'ТестоваяТаблица';
ALTER TABLE [ТестоваяТаблица] ADD [ТестовыйСтолбец] NCHAR(3);
ALTER TABLE [ТестоваяТаблица] ADD CONSTRAINT CK_ТестоваяТаблица_ТестовыйСтолбец CHECK ([ТестовыйСтолбец] LIKE N'[А-яA-z][0-9][A-zА-я0-9]');
GO

DROP TABLE IF EXISTS TestTable, [ТестоваяТаблица];
GO

-- ER-диаграмма. Изменение связей
------------------------------------------------------------

-- Поиск информации о внешних ключах таблицы «Авторы»\
EXECUTE sp_help N'titleauthor';

-- Удаление внешнего ключа FK_titleauthor_To_authors
ALTER TABLE titleauthor DROP CONSTRAINT FK_titleauthor_To_authors;
GO

-- Восстановление внешнего ключа FK_titleauthor_To_authors
ALTER TABLE titleauthor ADD CONSTRAINT FK_titleauthor_To_authors FOREIGN KEY (au_id) REFERENCES authors (au_id);
GO

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