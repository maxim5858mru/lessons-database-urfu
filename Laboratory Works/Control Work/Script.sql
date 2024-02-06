------------------------------------------------------------
------------------------- Контрольная работа по Базам данных
------------------------- Студента группы РИЗ-300016у
------------------------- Кулакова Максима Ивановича
------------------------------------------------------------
-- Вариант №10                           «Учёт оборудования»
------------------------------------------------------------


-- Создание базы данных
USE master;
GO

DROP DATABASE IF EXISTS lessonsUrFU;
GO

CREATE DATABASE lessonsUrFU
    ON PRIMARY
    (
        NAME = lessonUrFU_main_db,
        FILENAME = N'/var/opt/mssql/data/lessonUrFU_main.mdf',
        SIZE = 10 MB,
        MAXSIZE = 15 MB,
        FILEGROWTH = 10%
    ),
    FILEGROUP SECONDARY
    (
        NAME = lessonUrFU_secondary_db,
        FILENAME = N'/var/opt/mssql/data/lessonUrFU_secondary.ndf',
        SIZE = 5 MB,
        MAXSIZE = 10 MB,
        FILEGROWTH = 10%
    )
    LOG ON
    (
        NAME = lessonUrFU_db_log,
        FILENAME = N'/var/opt/mssql/data/lessonUrFU.ldf',
        SIZE = 1 MB,
        MAXSIZE = 5 MB,
        FILEGROWTH = 10%
    );
GO

------------------------------------------------------------
-- Создание таблиц:
--   1. Таблица-справочник «Поставщики оборудования»
--   2. Таблица-справочник «Причина возврата»
--   3. Таблица «Ответственне»
--   4. Таблица «Оборудование»
--   5. Таблица для связей «Возврат оборудования»
------------------------------------------------------------

USE lessonsUrFU;
GO

-- Таблица-справочник «Поставщики оборудования»
CREATE TABLE Suppliers
(
    Id           INT IDENTITY,          -- Идентификатор поставщика
    SupplierName NVARCHAR(50) NOT NULL, -- Наименование поставщика
    CONSTRAINT PK_Suppliers PRIMARY KEY (Id),
    CONSTRAINT UQ_Suppliers_SuppliersName UNIQUE (SupplierName)
) ON [SECONDARY];

-- Таблица-справочник «Причина возврата»
CREATE TABLE ReasonsForReturn
(
    Id         INT IDENTITY,          -- Идентификатор причины возврата
    ReasonName NVARCHAR(50) NOT NULL, -- Наименование причины возврата
    CONSTRAINT PK_ReasonsForReturn PRIMARY KEY (Id),
    CONSTRAINT UQ_ReasonsForReturn_ReasonName UNIQUE (ReasonName)
) ON [SECONDARY];
GO

-- Таблица «Оборудование»
CREATE TABLE Equipment
(
    InventoryID            INT IDENTITY,           -- Инвентарный номер оборудования
    SerialNumber           INT           NOT NULL, -- Серийный номер
    EquipmentName          NVARCHAR(60)  NOT NULL, -- Наименование
    RegistrationDate       DATE          NOT NULL  -- Дата регистрации
        CONSTRAINT DF_Equipment_RegistrationDate DEFAULT GETDATE(),
    Price                  MONEY         NULL,     -- Стоимость
    WarrantyServiceAddress NVARCHAR(100) NULL,     -- Адреса гарантийного обслуживания
    Supplier               INT           NOT NULL, -- Поставщик
    CONSTRAINT PK_Equipment PRIMARY KEY (InventoryID),
    CONSTRAINT UQ_Equipment_SerialNumber UNIQUE (SerialNumber),
    CONSTRAINT FK_Equipment_Suppliers FOREIGN KEY (Supplier)
        REFERENCES Suppliers (Id)
        ON UPDATE CASCADE
) ON [PRIMARY];
GO

-- Таблица «Ответственные»
CREATE TABLE Responsible
(
    PersonnelNumber INT IDENTITY,          -- Табельный номер сотрудника
    Surname         NVARCHAR(30) NOT NULL, -- Фамилия
    Name            NVARCHAR(30) NOT NULL, -- Имя
    MiddleName      NVARCHAR(50) NULL,     -- Отчество
    Workshop        NVARCHAR(35) NOT NULL, -- Цех
    LotNumber       INT          NOT NULL, -- Номер участка
    Department      NVARCHAR(35) NOT NULL, -- Отдел
    RoomNumber      INT          NOT NULL, -- Номер комнаты
    Telephone       NVARCHAR(16) NOT NULL, -- Телефон
    CONSTRAINT PK_Responsible PRIMARY KEY (PersonnelNumber),
    CONSTRAINT CH_Responsible_LotNumber CHECK (LotNumber >= 0),
    CONSTRAINT CH_Responsible_RoomNumber CHECK (RoomNumber > 99),
    CONSTRAINT CH_Responsible_Telephone CHECK (Telephone LIKE
                                               '+[0-9] [0-9][0-9][0-9] [0-9][0-9][0-9] [0-9][0-9]-[0-9][0-9]')
) ON [PRIMARY];
GO

-- Таблица для связей «Ответственность за оборудование»
CREATE TABLE Responsibility
(
    Id              INT IDENTITY,          -- Уникальный номер записи
    Responsible     INT          NOT NULL, -- Табельный номер ответственного
    Equipment       INT          NOT NULL, -- Инвентарный ID оборудования
    DateOfReceiving DATE         NOT NULL  -- Дата получения
        CONSTRAINT DF_Responsibility_DateOfReceiving DEFAULT GETDATE(),
    ReturnDate      DATE         NULL      -- Дата возврата
        CONSTRAINT DF_Responsibility_ReturnDate DEFAULT NULL,
    PurposeOfUse    NVARCHAR(50) NULL,     -- Цель использования
    ReasonForReturn INT          NULL,     -- Причина возврата
    CONSTRAINT PK_Responsibility PRIMARY KEY (Id),
    CONSTRAINT FK_Responsibility_Responsible FOREIGN KEY (Responsible)
        REFERENCES Responsible (PersonnelNumber)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_Responsibility_Equipment FOREIGN KEY (Equipment)
        REFERENCES Equipment (InventoryId)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT CH_Responsibility_ReturnDate CHECK (ReturnDate >= DateOfReceiving),
    CONSTRAINT FK_Responsibility_ReasonForReturn FOREIGN KEY (ReasonForReturn)
        REFERENCES ReasonsForReturn (Id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT CH_Responsibility_ReasonForReturn CHECK ((ReasonForReturn IS NOT NULL AND ReturnDate IS NOT NULL) OR
                                                        ReasonForReturn IS NULL)
) ON [SECONDARY];
GO

------------------------------------------------------------
-- Создание представлений
------------------------------------------------------------

CREATE VIEW vw_Responsibility AS
SELECT Rs.Id,
       R.Surname,
       R.Name,
       R.MiddleName,
       E.SerialNumber,
       E.EquipmentName,
       Rs.DateOfReceiving,
       Rs.ReturnDate,
       Rs.PurposeOfUse,
       Rs.ReasonForReturn,
       RF.ReasonName
FROM Responsibility AS Rs
         LEFT OUTER JOIN Responsible AS R ON R.PersonnelNumber = Rs.Responsible
         LEFT OUTER JOIN Equipment AS E ON E.InventoryID = Rs.Equipment
         LEFT OUTER JOIN ReasonsForReturn AS RF ON RF.Id = Rs.ReasonForReturn;
GO

CREATE VIEW vw_Equipment AS
SELECT E.InventoryID,
       E.SerialNumber,
       E.EquipmentName,
       E.RegistrationDate,
       E.Price,
       E.WarrantyServiceAddress,
       S.SupplierName
FROM Equipment AS E
         INNER JOIN Suppliers AS S ON S.Id = E.Supplier;
GO

------------------------------------------------------------
-- Добавление данных в таблицы
------------------------------------------------------------

INSERT INTO ReasonsForReturn (ReasonName)
VALUES (N'Поломка'),
       (N'Увольнение сотрудника'),
       (N'Плановая замена'),
       (N'По просьбе сотрудника');

INSERT INTO Suppliers (SupplierName)
VALUES ('Samsung'),
       ('Apple'),
       ('Lenovo'),
       ('HP'),
       ('Dell'),
       ('Asus'),
       ('Acer'),
       ('Microsoft'),
       ('LG'),
       ('TOYODA'),
       ('HAAS'),
       ('CIDAN');
GO

INSERT INTO Responsible (Surname, Name, MiddleName, Workshop, LotNumber, Department, RoomNumber, Telephone)
VALUES (N'Голикова', N'Агата', N'Макаровна', N'Административный', 5, N'Бухгалтерия', 305, N'+7 985 724 25-58'),
       (N'Логинов', N'Алексей', N'Миронович', N'Первичной обработки', 1, N'Основной', 105, N'+7 985 524 25-55'),
       (N'Черепанов', N'Семён', N'Тихонович', N'Первичной обработки', 2, N'Основной', 223, N'+7 971 246 45-42'),
       (N'Краснова', N'София', NULL, N'Вторичной обработки', 2, N'Основной', 103, N'+7 354 246 45-42'),
       (N'Назарова', N'Валентина', N'Марковна', N'Подготовительный', 7, N'Дополнительный', 142, N'+7 992 246 45-42'),
       (N'Новиков', N'Илья', N'Викторович', N'Административный', 5, N'Управления', 306, N'+7 985 724 25-58'),
       (N'Комарова', N'Полина', N'Егоровна', N'Подготовительный', 6, N'Внештатный', 140, N'+7 982 258 25-58'),
       (N'Кудрявцев', N'Артур', N'Романович', N'Вторичной обработки', 4, N'Дополнительный', 240, N'+7 922 555 32-21'),
       (N'Олейников', N'Степан', N'Гордеевич', N'Первичной обработки', 2, N'Основной', 124, N'+7 922 234 25-68'),
       (N'Смирнова', N'Надежда', N'Степановна', N'Переработки', 2, N'Дополнительные', 135, N'+7 901 350 25-25'),
       (N'Зимина', N'Владислава', N'Матвеевна', N'Административный', 2, N'Бухгалтерия', 352, N'+7 805 225 55-71'),
       (N'Трифонов', N'Иван', N'Артёмович', N'Подготовительный', 2, N'Основной', 320, N'+7 901 123 25-25'),
       (N'Петров', N'Георгий', N'Ярославович', N'Переработки', 5, N'Дополнительный', 420, N'+7 904 444 25-55'),
       (N'Климова', N'Кира', N'Игоревна', N'Административный', 2, N'Бухгалтерия', 230, N'+7 998 545 12-54'),
       (N'Богомолов', N'Иван', N'Константинович', N'Упаковки', 4, N'Основной', 222, N'+7 954 123 28-45'),
       (N'Попов', N'Арсен', NULL, N'Упаковки', 4, N'Дополнительный', 143, N'+7 985 424 55-88'),
       (N'Кулешова', N'Юлия', NULL, N'Первичной обработки', 5, N'Внештатный', 120, N'+7 922 485 71-82'),
       (N'Игнатов', N'Роман', N'Михайлович', N'Подготовительный', 3, N'Основной', 210, N'+7 977 124 65-22'),
       (N'Филиппов', N'Александр', N'Николаевич', N'Переработки', 5, N'Дополнительный', 244, N'+7 994 145 44-27');

INSERT INTO Equipment (SerialNumber, EquipmentName, RegistrationDate, Price, WarrantyServiceAddress, Supplier)
VALUES (40548143, N'Монитор', DEFAULT, 25000, N'г. Москва, ул. Ленина 1',
        (SELECT Id FROM Suppliers WHERE SupplierName = 'Samsung')),
       (50555167, N'Принтер', '2018-05-01', 10000, N'г. Тюмень, ул. Республики 158',
        (SELECT Id FROM Suppliers WHERE SupplierName = 'HP')),
       (60558144, N'Клавиатура', '2018-08-01', 5000, N'г. Тюмень, ул. Республики 158',
        (SELECT Id FROM Suppliers WHERE SupplierName = 'HP')),
       (70558176, N'Мышь', '2018-02-01', 3000, N'г. Екатеринбург, ул. Вайнера 58',
        (SELECT Id FROM Suppliers WHERE SupplierName = 'Asus')),
       (80558123, N'Монитор', '2018-03-01', 25000, N'г. Москва, ул. Ленина 1',
        (SELECT Id FROM Suppliers WHERE SupplierName = 'Samsung')),
       (90558165, N'Ноутбук', '2018-04-01', 80000, N'г. Тюмень, ул. Республики 158',
        (SELECT Id FROM Suppliers WHERE SupplierName = 'HP')),
       (90558183, N'Ноутбук', '2018-04-01', 80000, N'г. Тюмень, ул. Республики 158',
        (SELECT Id FROM Suppliers WHERE SupplierName = 'HP')),
       (90558110, N'Ноутбук', '2018-04-01', 80000, N'г. Тюмень, ул. Республики 158',
        (SELECT Id FROM Suppliers WHERE SupplierName = 'HP')),
       (90558157, N'Ноутбук', '2018-04-01', 80000, N'г. Тюмень, ул. Республики 158',
        (SELECT Id FROM Suppliers WHERE SupplierName = 'HP')),
       (10055813, N'Клавиатура', '2018-05-01', 5580, N'г. Владивосток, ул. Маковского 5',
        (SELECT Id FROM Suppliers WHERE SupplierName = 'Microsoft')),
       (14955819, N'Станок фрезерный', '2020-06-21', 3000, N'г. Москва, ул. Ленина 150/5',
        (SELECT Id FROM Suppliers WHERE SupplierName = 'TOYODA')),
       (17955818, N'Станок фрезерный', '2020-06-21', 3000, N'г. Москва, ул. Ленина 150/5',
        (SELECT Id FROM Suppliers WHERE SupplierName = 'TOYODA')),
       (91955810, N'Станок фрезерный', '2020-06-21', 3000, N'г. Москва, ул. Ленина 150/5',
        (SELECT Id FROM Suppliers WHERE SupplierName = 'TOYODA')),
       (11985815, N'Станок шлифовальный', '2020-05-20', 3000, N'г. Москва, ул. Ленина 150/5',
        (SELECT Id FROM Suppliers WHERE SupplierName = 'HAAS')),
       (55953018, N'Станок шлифовальный', '2020-05-20', 3000, N'г. Москва, ул. Ленина 150/5',
        (SELECT Id FROM Suppliers WHERE SupplierName = 'CIDAN'));
GO

INSERT INTO Responsibility (Responsible, Equipment, DateOfReceiving, ReturnDate, PurposeOfUse, ReasonForReturn)
VALUES ((SELECT PersonnelNumber FROM Responsible WHERE Surname = N'Краснова' AND Name = N'София'),
        (SELECT InventoryID FROM Equipment WHERE SerialNumber = 40548143),
        '2018-05-01', NULL, N'Работа', NULL),

       ((SELECT PersonnelNumber FROM Responsible WHERE Surname = N'Краснова' AND Name = N'София'),
        (SELECT InventoryID FROM Equipment WHERE SerialNumber = 90558183),
        '2018-05-01', NULL, N'Работа', NULL),

       ((SELECT PersonnelNumber
         FROM Responsible
         WHERE Surname = N'Кудрявцев'
           AND Name = N'Артур'
           AND MiddleName = N'Романович'),
        (SELECT InventoryID FROM Equipment WHERE SerialNumber = 55953018), '2020-05-20', GETDATE(), N'Временная работа',
        (SELECT Id FROM ReasonsForReturn WHERE ReasonName = N'Плановая замена')),

       ((SELECT PersonnelNumber
         FROM Responsible
         WHERE Surname = N'Зимина'
           AND Name = N'Владислава'
           AND MiddleName = N'Матвеевна'),
        (SELECT InventoryID FROM Equipment WHERE SerialNumber = 90558183), '2017-01-25', '2018-04-01', N'Работа',
        (SELECT Id FROM ReasonsForReturn WHERE ReasonName = N'Увольнение')),

       ((SELECT PersonnelNumber
         FROM Responsible
         WHERE Surname = N'Комарова'
           AND Name = N'Полина'
           AND MiddleName = N'Егоровна'),
        (SELECT InventoryID FROM Equipment WHERE SerialNumber = 90558183), '2018-04-02', '2018-04-25', N'Работа',
        (SELECT Id FROM ReasonsForReturn WHERE ReasonName = N'Плановая замена'));
GO

------------------------------------------------------------
-- Задание №1                  Поиск записей об оборудовании
--                               находящегося у пользователя
------------------------------------------------------------

CREATE PROCEDURE sp_DisplayEquipmentByUser @surname NVARCHAR(30),
                                           @name NVARCHAR(30),
                                           @middleName NVARCHAR(50) = NULL,
                                           @date DATETIME = NULL AS
BEGIN
    DECLARE @isSurname BIT, @isName BIT, @isMiddleName BIT, @isReturnDate BIT, @fullNames NVARCHAR(110) = N'';

    IF (@surname IS NULL)
        -- Имя не указано, выполняем пропуск проверки
        SET @isSurname = 1;
    ELSE
        BEGIN
            SELECT @fullNames = Surname FROM Responsible WHERE Surname = @surname;

            IF (SELECT COUNT(*) FROM Responsible WHERE Surname = @surname) = 0
                -- Имя указано, но не найдено в таблице Responsible
                SET @isSurname = 0;
            ELSE
                -- Имя указано и найдено в таблице Responsible
                SET @isSurname = 1;
        END

    IF (@name IS NULL)
        -- Фамилия не указана, выполняем пропуск проверки
        SET @isName = 1;
    ELSE
        BEGIN
            SELECT @fullNames = @fullNames + ' ' + Name FROM Responsible WHERE Name = @name;

            IF (SELECT COUNT(*) FROM Responsible WHERE Name = @name) = 0
                -- Фамилия указана, но не найдена в таблице Responsible
                SET @isName = 0;
            ELSE
                -- Фамилия указана и найдена в таблице Responsible
                SET @isName = 1;
        END

    IF (@middleName IS NULL)
        -- Отчество не указано, выполняем пропуск проверки
        SET @isMiddleName = 1;
    ELSE
        BEGIN
            SELECT @fullNames = @fullNames + ' ' + MiddleName FROM Responsible WHERE MiddleName = @middleName;

            IF (SELECT COUNT(*) FROM Responsible WHERE MiddleName = @middleName) = 0
                -- Отчество указано, но не найдено в таблице Responsible
                SET @isMiddleName = 0;
            ELSE
                -- Отчество указано и найдено в таблице Responsible
                SET @isMiddleName = 1;
        END

    IF (@date IS NULL OR (SELECT COUNT(*) FROM Responsibility WHERE @date BETWEEN DateOfReceiving AND ReturnDate) > 0)
        -- Дата не указана или найдена в таблице Responsibility
        SET @isReturnDate = 0;
    ELSE
        -- Дата найдена в таблице Responsibility
        SET @isReturnDate = 1;

    DECLARE @count INT;
    SELECT @count = COUNT(*)
    FROM Responsibility AS Rs
             INNER JOIN Equipment AS E ON E.InventoryID = Rs.Equipment
             INNER JOIN Responsible AS R ON R.PersonnelNumber = Rs.Responsible
    WHERE (R.Surname = @surname OR @isSurname = 1)
      AND (R.Name = @name OR @isName = 1)
      AND (R.MiddleName = @middleName OR @isMiddleName = 1)
      AND ((@date BETWEEN Rs.DateOfReceiving AND Rs.ReturnDate) OR @isReturnDate = 1);

    IF @count = 1
        SELECT R.Surname + ' ' + R.Name AS N'ФИО ответственного',
               E.EquipmentName          AS N'Наименование оборудования',
               E.InventoryID            AS N'Инвентарный ID',
               E.SerialNumber           AS N'Серийный номер',
               E.Price                  AS N'Цена',
               E.RegistrationDate       AS N'Дата постановки на учет',
               Rs.DateOfReceiving       AS N'Дата получения',
               Rs.ReturnDate            AS N'Дата возврата',
               Rs.PurposeOfUse          AS N'Цель использования',
               Rs.ReasonForReturn       AS N'Причина возврата'
        FROM Responsibility AS Rs
                 INNER JOIN Equipment AS E ON E.InventoryID = Rs.Equipment
                 INNER JOIN Responsible AS R ON R.PersonnelNumber = Rs.Responsible
        WHERE (R.Surname = @surname OR @isSurname = 1)
          AND (R.Name = @name OR @isName = 1)
          AND (R.MiddleName = @middleName OR @isMiddleName = 1)
          AND ((@date BETWEEN Rs.DateOfReceiving AND Rs.ReturnDate) OR @isReturnDate = 1);
    ELSE
        PRINT N'Количество пользователей с ' + @fullNames + N' равно ' + CONVERT(NVARCHAR, @count) + N'!';
END;
GO

-- Вывод сведений об оборудовании у Кудрявцева Артура Романовича на момент 25.05.2020
EXEC sp_DisplayEquipmentByUser @surname = N'Кудрявцев', @name = N'Артур', @middleName = N'Романович',
     @date = '2020-05-25';
GO

------------------------------------------------------------
-- Задание №2        Отображение пользователей задерживающие
--                              оборудование дольше среднего
------------------------------------------------------------

CREATE PROCEDURE sp_DisplayUsersDelayingEquipment AS
BEGIN
    DECLARE
        @avgDays INT = (SELECT AVG(DATEDIFF(DAY, DateOfReceiving, COALESCE(ReturnDate, GETDATE())))
                        FROM Responsibility);

    SELECT R.Surname                                                             AS N'Фамилия',
           R.Name                                                                AS N'Имя',
           R.MiddleName                                                          AS N'Отчество',
           E.EquipmentName                                                       AS N'Наименование оборудования',
           DATEDIFF(DAY, Rs.DateOfReceiving, COALESCE(Rs.ReturnDate, GETDATE())) AS N'Количество дней'
    FROM Responsibility AS Rs
             INNER JOIN Responsible AS R ON R.PersonnelNumber = Rs.Responsible
             INNER JOIN Equipment AS E ON Rs.Equipment = E.InventoryID
    WHERE DATEDIFF(DAY, DateOfReceiving, COALESCE(ReturnDate, GETDATE())) > @avgDays
END;
GO

-- Вывод пользователей задерживающие оборудование дольше среднего
EXEC sp_DisplayUsersDelayingEquipment;
GO

------------------------------------------------------------
-- Задание №3                     Изменение первичного ключа
--                                         таблицы Equipment
------------------------------------------------------------

CREATE PROCEDURE sp_ChangePrimaryKeyEquipment @oldInventoryID INT,
                                              @newInventoryID INT AS
BEGIN
    -- Временное снятие ограничений
    SET IDENTITY_INSERT Equipment ON;
    ALTER TABLE Equipment
        DROP CONSTRAINT UQ_Equipment_SerialNumber;

    -- Создание новой записи
    INSERT INTO Equipment (InventoryID, SerialNumber, EquipmentName, RegistrationDate, Price, WarrantyServiceAddress,
                           Supplier)
    SELECT @newInventoryID, SerialNumber, EquipmentName, RegistrationDate, Price, WarrantyServiceAddress, Supplier
    FROM Equipment
    WHERE InventoryID = @oldInventoryID;

    -- Изменение связки у зависимостей
    UPDATE Responsibility
    SET Equipment = @newInventoryID
    WHERE Equipment = @oldInventoryID;

    -- Удаление старой записи
    DELETE
    FROM Equipment
    WHERE InventoryID = @oldInventoryID;

    -- Восстановление ограничений
    ALTER TABLE Equipment
        ADD CONSTRAINT UQ_Equipment_SerialNumber UNIQUE (SerialNumber);
    SET IDENTITY_INSERT Equipment OFF;
END;
GO

-- Изменение первичного ключа
EXEC sp_ChangePrimaryKeyEquipment @oldInventoryID = 1, @newInventoryID = 10000;

-- Вывод сведений об оборудовании с изменёным первичным ключём
SELECT *
FROM Equipment;
GO

------------------------------------------------------------
-- Задание №4   Изменение первичного ключа таблицы Equipment
--                              с удалением связанных данных
------------------------------------------------------------

CREATE PROCEDURE sp_ChangePrimaryKeyEquipmentWithDel @oldInventoryID INT,
                                                     @newInventoryID INT AS
BEGIN
    -- Временное снятие ограничений
    SET IDENTITY_INSERT Equipment ON;
    ALTER TABLE Equipment
        DROP CONSTRAINT UQ_Equipment_SerialNumber;

    -- Создание новой записи
    INSERT INTO Equipment (InventoryID, SerialNumber, EquipmentName, RegistrationDate, Price, WarrantyServiceAddress,
                           Supplier)
    SELECT @newInventoryID, SerialNumber, EquipmentName, RegistrationDate, Price, WarrantyServiceAddress, Supplier
    FROM Equipment
    WHERE InventoryID = @oldInventoryID;


    -- Удаление старой записи
    DELETE
    FROM Equipment
    WHERE InventoryID = @oldInventoryID;

    -- Восстановление ограничений
    ALTER TABLE Equipment
        ADD CONSTRAINT UQ_Equipment_SerialNumber UNIQUE (SerialNumber);
    SET IDENTITY_INSERT Equipment OFF;
END;
GO

-- Переменая для получения старого первичного ключа
DECLARE @oldInventID INT;

-- Получение старого первичного ключа
SELECT @oldInventID = InventoryID
FROM Equipment
WHERE SerialNumber = 55953018;

-- Изменение первичного ключа, с удалением связанных данных
EXECUTE sp_ChangePrimaryKeyEquipmentWithDel @oldInventoryID = @oldInventID, @newInventoryID = 2582;
GO

-- Вывод сведений об оборудовании без удалённых связанных данных
SELECT *
FROM vw_Responsibility;
GO
------------------------------------------------------------
-- Задание №5            Получение среднего времени задержки
--       оборудования и список часто задерживаемых устройств
------------------------------------------------------------
CREATE PROCEDURE sp_DisplayEquipmentDelaying @inventoryID INT = NULL, @equipmentName NVARCHAR(60) = NULL AS
BEGIN
    IF @inventoryID IS NOT NULL OR @equipmentName IS NOT NULL
        SELECT Equipment.InventoryID                                                AS N'Инвентарный номер',
               LOWER(Equipment.EquipmentName)                                       AS N'Наименование оборудования',
               AVG(DATEDIFF(DAY, DateOfReceiving, COALESCE(ReturnDate, GETDATE()))) AS N'Среднее время задержки'
        FROM Responsibility
                 INNER JOIN Equipment ON Equipment.InventoryID = Responsibility.Equipment
        WHERE (@inventoryID IS NULL OR Equipment.InventoryID = @inventoryID)
          AND (@equipmentName IS NULL OR LOWER(Equipment.EquipmentName) = LOWER(@equipmentName))
        GROUP BY Equipment.InventoryID, LOWER(Equipment.EquipmentName);
    ELSE
        BEGIN
            PRINT N'Не указаны параметры для поиска!';
            SELECT NULL AS N'Инвентарный номер',
                   NULL AS N'Наименование оборудования',
                   NULL AS N'Среднее время задержки';
        END

    -- Четыре самых часто задерживаемых устройства
    SELECT TOP 4 Equipment.SerialNumber                                               AS N'Серийный номер',
                 Equipment.EquipmentName                                              AS N'Наименование оборудования',
                 AVG(DATEDIFF(DAY, DateOfReceiving, COALESCE(ReturnDate, GETDATE()))) AS N'Среднее время задержки',
                 COUNT(*)                                                             AS N'Количество пользователей'
    FROM Responsibility
             INNER JOIN Equipment ON Equipment.InventoryID = Responsibility.Equipment
    GROUP BY Equipment.SerialNumber, Equipment.EquipmentName
    ORDER BY COUNT(*) DESC;
END;
GO

-- Вывод среднего времени задержки по оборудованию
EXEC sp_DisplayEquipmentDelaying @inventoryID = 7;

-- Экспорт базы данных
BACKUP DATABASE lessonsUrFU TO DISK = N'/var/opt/mssql/data/lessonsUrFU.bak'
    WITH DESCRIPTION = N'Контрольная работа выполненая в рамках дисплины "Базы данных" в УрФУ.',
    NOFORMAT, INIT, NAME = N'Control Work', SKIP, NOREWIND, NOUNLOAD, STATS = 10, CHECKSUM
GO