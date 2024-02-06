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