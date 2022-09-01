--Удаление созданной базы данных
USE [master]
ALTER DATABASE [udp_Kulakov_Maxim_Ivanovic] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE [udb_Kulakov_Maxim_Ivanovic]
GO

--Лабораторная работа №1--------------------------
--------------------------------------------------

--Автосгенерированный скрипт создания базы данных
CREATE DATABASE [udb_Kulakov_Maxim_Ivanovic]
	CONTAINMENT = NONE

	ON  PRIMARY (
		NAME = N'udb_Kulakov_Maxim_Ivanovic_1',
		FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\udb_Kulakov_Maxim_Ivanovic_1.mdf' ,
		SIZE = 3072KB ,
		FILEGROWTH = 65536KB
	), (
		NAME = N'udb_Kulakov_Maxim_Ivanovic_2',
		FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\udb_Kulakov_Maxim_Ivanovic_2.ndf' ,
		SIZE = 3072KB ,
		FILEGROWTH = 65536KB
	)

	LOG ON (
		NAME = N'udb_Kulakov_Maxim_Ivanovic_log',
		FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\udb_Kulakov_Maxim_Ivanovic_log.ldf' ,
		SIZE = 1024KB ,
		FILEGROWTH = 65536KB
	)

ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET COMPATIBILITY_LEVEL = 150
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET ANSI_NULL_DEFAULT OFF
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET ANSI_NULLS OFF
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET ANSI_PADDING OFF
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET ANSI_WARNINGS OFF
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET ARITHABORT OFF
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET AUTO_CLOSE OFF
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET AUTO_SHRINK OFF
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF)
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET AUTO_UPDATE_STATISTICS ON
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET CURSOR_CLOSE_ON_COMMIT OFF
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET CURSOR_DEFAULT  GLOBAL
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET CONCAT_NULL_YIELDS_NULL OFF
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET NUMERIC_ROUNDABORT OFF
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET QUOTED_IDENTIFIER OFF
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET RECURSIVE_TRIGGERS OFF
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET  DISABLE_BROKER
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET DATE_CORRELATION_OPTIMIZATION OFF
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET PARAMETERIZATION SIMPLE
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET READ_COMMITTED_SNAPSHOT OFF
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET  READ_WRITE
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET RECOVERY SIMPLE
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET  MULTI_USER
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET PAGE_VERIFY CHECKSUM
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET TARGET_RECOVERY_TIME = 60 SECONDS
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET DELAYED_DURABILITY = DISABLED

USE [udb_Kulakov_Maxim_Ivanovic]
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = Off;
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = Primary;
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = On;
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = Primary;
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = Off;
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = Primary;

IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO

--Выбор созданной базы данных
USE [udb_Kulakov_Maxim_Ivanovic]
GO

--Получение информации об созданной базе данных
EXEC sp_helpdb N'udb_Kulakov_Maxim_Ivanovic';
GO

--Изменение 10-го параметра
ALTER DATABASE [udb_Kulakov_Maxim_Ivanovic] SET AUTO_UPDATE_STATISTICS OFF
GO

--Сгенирированны скрипт создания таблицы
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Example_Table] (
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nchar](10) NULL,
	CONSTRAINT [PK_Example_Table] PRIMARY KEY CLUSTERED (
		[ID] ASC
	)

	WITH (
		PAD_INDEX = OFF,
		STATISTICS_NORECOMPUTE = OFF,
		IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
		ALLOW_PAGE_LOCKS = ON,
		OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
	) ON [PRIMARY]
) ON [PRIMARY]
GO

--Запросы к системным представлениям INFORMATION_SCHEMA для вывода информации о таблицах, столбцах и ограничениях
SELECT * FROM udb_Kulakov_Maxim_Ivanovic.INFORMATION_SCHEMA.TABLES
SELECT * FROM udb_Kulakov_Maxim_Ivanovic.INFORMATION_SCHEMA.COLUMNS
SELECT * FROM udb_Kulakov_Maxim_Ivanovic.INFORMATION_SCHEMA.TABLE_CONSTRAINTS
GO

--Вывод информации о файлах системной таблицы
EXEC sp_helpdb N'master';
GO

--------------------------------------------------
----------------------------Лабораторная работа №2
--------------------------------------------------

----------------------------------------Задание №1

--Создание таблицы "Авторы"
CREATE TABLE authors (
	au_id VARCHAR(11) CHECK (au_id like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9]') CONSTRAINT PK_Policy_Number PRIMARY KEY CLUSTERED,
	au_lname VARCHAR(40) NOT NULL,
	au_fname VARCHAR(20) NOT NULL,
	phone CHAR(12) NOT NULL DEFAULT ('UNKNOWN'),
	address VARCHAR(40) NULL,
	city VARCHAR(20) NULL,
	state CHAR(2) NULL,
	zip CHAR(5) NULL CHECK (zip like '[0-9][0-9][0-9][0-9][0-9]'),
	contract bit NOT NULL
)
GO

--Создание таблицы "Издания"
CREATE TABLE titles (
	title_id VARCHAR(6) CONSTRAINT PK_Book_Code PRIMARY KEY CLUSTERED,
	title VARCHAR(80) NOT NULL,
	type CHAR(12) NOT NULL DEFAULT ('UNDECIDED'),
	pub_id CHAR(4) NULL,
	price MONEY NULL,
	advance MONEY NULL,
	royalty INT NULL,
	ytd_sales INT NULL,
	notes VARCHAR(200) NULL,
	pubdata DATETIME NOT NULL DEFAULT (getdate())
)

--Создание таблицы "Связь Авторы-Издатель"
CREATE TABLE titleauthor (
	au_id VARCHAR(11) REFERENCES authors(au_id),
	title_id VARCHAR(6) REFERENCES titles(title_id),
	au_ord TINYINT NULL,
	royaltyper INT NULL,
	CONSTRAINT PK_Title_ID PRIMARY KEY CLUSTERED(au_id, title_id)
)

--Создание таблицы "Продажи"
CREATE TABLE [dbo].[sales] (
    [stor_id] [CHAR](4) NOT NULL,
    [ord_num] [VARCHAR](20) NOT NULL,
    [ord_date] [DATETIME] NOT NULL,
    [qty] [SMALLINT] NOT NULL,
    [payterms] [VARCHAR](12) NOT NULL,
    [title_id] [TID] NOT NULL,
    CONSTRAINT PK_Title_ID PRIMARY KEY CLUSTRED ([stor_id], [ord_num], [title_id], FOREIGN KEY ([title_id]) REFERENCES [dbo].[titles] ([title_id]))

    --Другой способ задания внешнего ключа отельной командой
    --ALTER TABLE [dbo].[sales] ADD FOREIGN KEY ([title_id])
    --REFERENCES [dbo].[titles] (titles_id])
)
GO