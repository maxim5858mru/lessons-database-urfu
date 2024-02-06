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