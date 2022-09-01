# Основы T-SQL. DDL

## Создание и удаление базы данных

### Создание базы данных

Для создания базы данных используется команда `CREATE DATABASE`.

```txt
CREATE DATABASE [name];
```

```txt
CREATE DATABASE [name]
    ON PRIMARY (
        NAME = '[name]',
        FILENAME = '[name].mdf',
        SIZE = 5 MB,
        MAXSIZE = 10 MB,
        FILEGROWTH = 10%
        )
    LOG ON (
        NAME = '[name]_log',
        FILENAME = '[name]_log.ldf',
        SIZE = 1 MB,
        MAXSIZE = 2 MB,
        FILEGROWTH = 10%
        );
```

Например:

```sql
CREATE DATABASE lesson
    ON PRIMARY (
    NAME = lesson_db,
    FILENAME = N'/var/opt/mssql/data/lesson_db.mdf',
    SIZE = 5 MB,
    MAXSIZE = 10 MB,
    FILEGROWTH = 10%
    )
    LOG ON (
    NAME = lesson_db_log,
    FILENAME = N'/var/opt/mssql/data/lesson_db_log.ldf',
    SIZE = 1 MB,
    MAXSIZE = 5 MB,
    FILEGROWTH = 10%
    );
```

Для выбора базы данных используется команда `USE`.

```txt
USE [name];
```

### Прикрепление базы данных

Файл базы данных представляет файл с расширением `.mdf`. Файл журнала базы данных имеет расширение `.ldf`. По умолчанию
файлы базы данных Microsoft SQL Server хранится в `C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA`
и '/var/opt/mssql/data/' Простой перенос данного файла не перенесёт базу данных. Для этого необходимо выполнить
прикрепление базы данных к серверу.

```txt
CREATE DATABASE [name]
    ON PRIMARY (FILENAME = '[file_name].mdf')
    FOR ATTACH;
```

### Удаление базы данных

Для удаления базы данных используется команда `DROP DATABASE`. Удаление базы данных также вызывает удаление всех её
файлов.

```txt
DROP DATABASE [name];
```

```txt
DROP DATABASE [name_1], [name_2], [name_3];
```

## Создание и удаление таблиц

Для создания таблиц используется команда `CREATE TABLE`. Вместе с ней используется ряд операторов, которые опеределяют
столбцы таблицы и их атрибуты, а также свойства таблицы в целом. Одна база данных может содержать до 2 миллионов таблиц.
Имя таблицы является её идентификатором, и оно должно быть не больше 128 символов. Если необходимо в качестве имени
использовать ключевые слова, то эти слова помещаются в квадратные скобки. Таблица может содержать от 1 до 1024 столбцов.

```txt
CREATE TABLE [name]
(
    [column-1] [type] [nullable] [default],
    ...        ...    ...        ...,
    [column-n] [type] [nullable] [default]
);
```

Например:

```sql
CREATE TABLE Customers
(
    ID        INT,
    Age       INT,
    FirstName NVARCHAR(20),
    LastName  NVARCHAR(20),
    Email     VARCHAR(30),
    Phone     VARCHAR(20)
);
```

### Удаление таблицы

Для удаления таблицы используется команда `DROP TABLE`.

```txt
DROP TABLE [name];
```

```txt
DROP TABLE [name-1], [name-2], [name-3];
```

### Переименование таблицы

Для переименования таблицы используется системная процедура `sp_rename`.

```sql
EXEC sp_rename '[old_name]', '[new_name]';
```

## Типы данных T-SQL

Тип данных определяет, какие значения могут храниться в столбце, сколько они будут занимать места в памяти.

Числовые типы данных:

| Тип          | От                    | До                   | Занимает      | Примечание                                                                                                                                                           |
|--------------|-----------------------|----------------------|---------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `BIT`        | 0                     | 16                   | [1 - 2] байта | Может выступать аналогом булевого типа, где 1 - `True`, а 0 - `False`.                                                                                               |
| `TINYINT`    | 0                     | 255                  | 1 байт        | Для хранения небольших чисел.                                                                                                                                        |
| `SMALLINT`   | -32768                | 32767                | 2 байта       |                                                                                                                                                                      |
| `INT`        | -2147483648           | 2147483647           | 4 байта       | Наиболее часто используемый тип.                                                                                                                                     |
| `BIGINT`     | -9223372036854775808  | 92233720368854775807 | 8 байт        |                                                                                                                                                                      |
| `DECIMAL`    |                       |                      | [5 - 17] байт | Целая часть может содержать от 1 до 38 чисел, а дробная от 0 до значения для целой части. По умолчанию на целую часть выделяно 18 цифр. `DECIMAL(prexision, scale)`. |
| `NUMERIC`    |                       |                      |               | Аналогичен `DECIMAL`.                                                                                                                                                |
| `SMALLMONEY` | -214748.3648          | 214748.3647          | 4 байта       | Для денежных величин. Эквивалентент `DECIMAL(10, 4)`.                                                                                                                |
| `MONEY`      | -922337203685477.5808 | 922337203685477.5807 | 8 байт        | Для денежных величин. Эквивалентент `DECIMAL(19, 4)`.                                                                                                                |
| `FLOAT`      | -1.79E+308            | 1.79E+308            | [4 - 8] байт  | Размер зависит от дробной части. По умолчанию мантисса (число для хранения десятичной части) равна 53. `FLOAT(mantissa)`.                                            |
| `REAL`       | -3.40E+38             | 3.40E+38             | 4 байта       | Эквивалентент `FLOAT(24)`.                                                                                                                                           |

Дата и время:

| Тип              | От                             | До                               | Занимает     | Примечание                                                                                         |
|------------------|--------------------------------|----------------------------------|--------------|----------------------------------------------------------------------------------------------------|
| `DATE`           | 1 января 0001                  | 31 декабря 9999                  | 3 байта      |                                                                                                    |
| `TIME`           | 00:00:00.0000000               | 23:59:59:9999999                 | [3 - 5] байт | Может объявляться с помощью `TIME(n)`, где `n` - количество цифр в дробной части секунд от 0 до 7. |
| `DATETIME`       | 1 января 1753 00:00:00         | 31 декабря 9999 23:59:59         | 8 байт       | Хранит дату и время.                                                                               |
| `DATETIME2`      | 1 января 0001 00:00:00.0000000 | 31 декабря 9999 23:59:59.9999999 | [6 - 8] байт | Позволяет указать количество цифр в дробной части секунд по аналогии с `TIME`. `DATETIME2(n)`.     |
| `SMALLDATETME`   | 1 января 1900 00:00:00         | 31 декабря 2079 23:59:59         | 4 байта      | Предназначен для хранения ближайших дат и времени.                                                 |
| `DATETIMEOFFSET` | 1 января 0001 00:00:00         | 31 декабря 9999 23:59:59         | 10 байт      | Точность до 100 наносекунд.                                                                        |

Строковые типы данных:

| Тип        | От  | До   | Занимает   | Примечание                                                                                                                                                                                               |
|------------|-----|------|------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `CHAR`     | 1   | 8000 | по 1 байту | Символы хранятся не в Unicode. `CHAR(count)`, где `count` количество символов. Если строка меньше указананного размера, то она дополняется пробелами.                                                    |
| `VARCHAR`  | 1   | 8000 | по 1 байту | Символы хранятся не в Unicode. `VARCHAR(count)`, `VARCHAR(MAX)`, позволяет указать размер больше 8000 символов. Если строка меньше указананного размера, то она не дополняется до максимального размера. |
| `NCHAR`    | 1   | 4000 | по 2 байта | Символы хранятся в Unicode. Работа с ним аналогична `CHAR`.                                                                                                                                              |
| `NVARCHAR` | 1   | 4000 | по 2 байта | Символы хранятся в Unicode. Работа с ним аналогична `VARCHAR`.                                                                                                                                           |

Типы данных `TEXT` и `NTEXT` являются устаревшими и вместо них рекомендуется использовать `VARCHAR` или `NVARCHAR`.

Бинарные типы данных:

| Тип         | От      | До                                                      | Примечание                                   |
|-------------|---------|---------------------------------------------------------|----------------------------------------------|
| `BINARY`    | 1 байта | 8000 байт                                               | Предназначен для хранения бинарных значений. |
| `VARBINARY` | 1 байта | 8000 байт или 2^31-1 при использовании `VARBINARY(MAX)` |                                              |

Остальные типы данных:

| Тип                | Занимает | Примечание                                                     |
|--------------------|----------|----------------------------------------------------------------|
| `UNIQUEIDENTIFIER` | 16 байт  | Уникальный идентификатор GUID.                                 |
| `TIMESTAMP`        | 8 байт   | Некоторое число, которое хранит номер версии строки в таблице. |
| `CURSOR`           |          | Представляет набор строк.                                      |
| `HIERARCHYID`      |          | Представляет позицию в иерархии.                               |
| `SQL_VARIANT`      |          | Может хранить данные любого другого типа данных T-SQL.         |
| `XML`              | до 2 Гб  | Хранит документы XML или фрагменты документов XML.             |
| `TABLE`            |          | Представляет определение таблицы.                              |
| `GEOGRAPHY`        |          | Хранит географические данные, такие как широта и долгота.      |
| `GEOMETRY`         |          | Хранит координаты местонахождения на плоскости.                |

Форматы даты:

- `yyyy-mm-dd`
- `dd/mm/yyyy`
- `Month dd, yyyy`
- `mm-dd-yy`. Где для года диапазон от 00 до 49 воспринимаются как даты в диапазоне от 2000 до 2049, а от 50 до 99
  воспринимаются как даты в диапазоне от 1950 до 1999.

Форматы времени:

- `hh:mm`
- `hh:mm am/pm`
- `hh:mm:ss`
- `hh:mm:ss:mmm`
- `hh:mm:ss:nnnnnnn`

## Атрибуты и ограничения столбцов и таблиц

### `PRIMARY KEY`

`PRIMARY KEY` позволяет сделать столбец первичным ключом. Первичный ключ должен быть уникален в таблице и позволяет
идентифицировать строку в таблице.

```sql
CREATE TABLE Costumers
(
    ID   INT PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL,
    Age  INT           NOT NULL
);
```

```sql
CREATE TABLE Costumers
(
    ID   INT,
    Name NVARCHAR(255) NOT NULL,
    Age  INT           NOT NULL,
    PRIMARY KEY (ID)
);
```

Состовной первичный ключ может быть составлен из нескольких столбцов. Тем самым в таблице не может быть двух и более
строк, для которых значения столбцов составного ключа совпадают.

```sql
CREATE TABLE Orders
(
    ID        INT PRIMARY KEY,
    ProductID INT   NOT NULL,
    Quantity  INT   NOT NULL,
    Price     MONEY NOT NULL,
    PRIMARY KEY (ID, ProductID)
);
```

### `IDENTITY`

`IDENTITY` позволяет сделать столбец типа `INT`, `SMALLINT`, `BIGINT`, `TYNIINT`, `DECIMAL` или `NUMBERIC`
индентификатором. При добавлении новых данных строка автоматически получит инкрементированное значение индентификатора.

```sql
CREATE TABLE Costumers
(
    ID   INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(255) NOT NULL,
    Age  INT           NOT NULL
);
```

В полной форме атритбута `IDENTITY(seed, increment)` можно указать начальное значение индентификатора `seed` и его
изменение в процессе выполнения запроса `increment`.

```sql
CREATE TABLE Costumers
(
    ID   INT PRIMARY KEY IDENTITY (1, 1),
    Name NVARCHAR(255) NOT NULL,
    Age  INT           NOT NULL
);
```

### `UNIQUE`

`UNIQUE` позволяет сделать столбец уникальным.

```sql
CREATE TABLE Costumers
(
    ID    INT PRIMARY KEY,
    Name  NVARCHAR(255) NOT NULL,
    Age   INT           NOT NULL,
    Email VARBINARY(30) UNIQUE,
    Phone VARBINARY(30) UNIQUE
);
```

```sql
CREATE TABLE Costumers
(
    ID    INT PRIMARY KEY,
    Name  NVARCHAR(255) NOT NULL,
    Age   INT           NOT NULL,
    Email VARBINARY(30),
    Phone VARBINARY(30),
    UNIQUE (Email, Phone)
);
```

### `NOT NULL` и `NULL`

Атрибут `NOT NULL` позволяет указать что для столбца недопустимо значение `NULL`. Атрибут `NULL` указывает что допустимо
значение `NULL`. По умолчанию неявно используется атрибут `NULL`, за исключением первичного ключа.

```sql
CREATE TABLE Costumers
(
    ID    INT PRIMARY KEY,
    Name  NVARCHAR(255) NOT NULL,
    Age   INT           NOT NULL,
    Email VARBINARY(30) UNIQUE,
    Phone VARBINARY(30) UNIQUE
);
```

### `DEFAULT`

Атрибут `DEFAULT` позволяет указать значение по умолчанию для столбца. Тем самым можно будет не указывать значение для
таких столбцов при добавлении новой строки.

```sql
CREATE TABLE Costumers
(
    ID    INT PRIMARY KEY,
    Name  NVARCHAR(255) NOT NULL,
    Age   INT           NOT NULL DEFAULT 18,
    Email VARBINARY(30) UNIQUE,
    Phone VARBINARY(30) UNIQUE
);
```

### `CHECK`

`CHECK` позволяет ограничить диапазон допустимых значений для столбца. После ключевого слова `CHECK` должно следовать
условие, которому должны соотвествовать значения столбца.

```sql
CREATE TABLE Costumers
(
    ID    INT PRIMARY KEY,
    Name  NVARCHAR(255) NOT NULL,
    Age   INT           NOT NULL DEFAULT 18 CHECK (Age > 0 AND Age < 120),
    Email VARBINARY(30) UNIQUE CHECK (Email != ''),
    Phone VARBINARY(30) UNIQUE CHECK (Phone != '')
);
```

Данный атрибут также может быть указан на уровне таблицы.

```sql
CREATE TABLE Costumers
(
    ID    INT PRIMARY KEY,
    Name  NVARCHAR(255) NOT NULL,
    Age   INT           NOT NULL DEFAULT 18,
    Email VARBINARY(30) UNIQUE,
    Phone VARBINARY(30) UNIQUE,
    CHECK ((Age > 0 AND Age < 120) AND (Email != '') AND (Phone != ''))
);
```

### `CONSTRAINT`

Ключевое слово `CONSTRAINT` позволяет указать имя ограничения столбца. Без явного указания имени ограничения SQL Server
автоматически определит имя ограничения по имени столбца.

```sql
CREATE TABLE Customers
(
    ID    INT
        CONSTRAINT PK_Customers_ID PRIMARY KEY,
    Name  NVARCHAR(255) NOT NULL,
    Age   INT           NOT NULL
        CONSTRAINT DF_Customers_Age DEFAULT 18
        CONSTRAINT CK_Customers_Age CHECK (Age > 0 AND Age < 120),
    Email VARBINARY(30)
        CONSTRAINT UQ_Customers_Email UNIQUE
        CONSTRAINT CK_Customers_Email CHECK (Email != ''),
    Phone VARBINARY(30)
        CONSTRAINT UQ_Customers_Phone UNIQUE
        CONSTRAINT CK_Customers_Phone CHECK (Phone != '')
);
```

Ограничения могут иметь произвольные названия, тем не менее рекомендуются следующие префиксы:

- `PK_` - первичный ключ, `PRIMARY KEY`;
- `FK_` - внешний ключ, `FOREIGN KEY`;
- `UQ_` - уникальность, `UNIQUE`;
- `DF_` - значение по умолчанию, `DEFAULT`;
- `CK_` - проверка, `CHECK`.

## Внешние ключи

Внешние ключи применяются для установки связи между таблицами. Он может указывать как на первичный ключ, так и на любой
другой столбцец таблицы с униакальными значениями.

Ключевое слово `FOREIGN KEY` не обязательно указывать при установке внешнего ключа на уровне столбца.

Общий синтаксис установки внешнего ключа на уровне столбца:

```txt
[FOREIGN KEY] REFERENCES main_table (main_column)
    [ON DELETE {CASCADE|NO ACTION}]
    [ON UPDATE {CASCADE|NO ACTION}]
```

Общий синтаксис установки внешнего ключа на уровне таблицы:

```txt
FOREIGN KEY (column_1, column_2) 
    REFERENCES main_table (main_column_1, main_column_2)
    [ON DELETE {CASCADE|NO ACTION}]
    [ON UPDATE {CASCADE|NO ACTION}]
```

Пример:

```sql
CREATE TABLE Customers
(
    ID    INT PRIMARY KEY,
    Name  NVARCHAR(255) NOT NULL,
    Age   INT           NOT NULL DEFAULT 18,
    Email VARBINARY(30) UNIQUE,
    Phone VARBINARY(30) UNIQUE
);

CREATE TABLE Orders
(
    ID         INT PRIMARY KEY,
    CustomerID INT      NOT NULL FOREIGN KEY REFERENCES Customers (ID),
    CreateAt   DATETIME NOT NULL DEFAULT GETDATE()
);
```

В данном примере, таблица `Customers` являяется главной, а `Orders` - подчиненной (зависимой). `CustomerID` - это
внешний ключ, который указывает на столбце `ID` таблицы `Customers`.

Тот же самый пример, но с определением внешнего ключа на уровне таблицы:

```sql
CREATE TABLE Customers
(
    ID    INT PRIMARY KEY,
    Name  NVARCHAR(255) NOT NULL,
    Age   INT           NOT NULL DEFAULT 18,
    Email VARBINARY(30) UNIQUE,
    Phone VARBINARY(30) UNIQUE
);

CREATE TABLE Orders
(
    ID         INT PRIMARY KEY,
    CustomerID INT      NOT NULL,
    CreateAt   DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers (ID)
);
```

### Операторы `ON DELETE` и `ON UPDATE`

Они позволяют указать поведение при удалении и обновлении записей из главной таблицы. Возможно использование следующих
опций:

- `CASCADE` - при удалении записи из главной таблицы происходит удаление всех записей из подчиненной таблицы, а при
  обновлении записи из главной таблицы выполняет обнавление записи в подчиненной таблице;
- `NO ACTION` - вслучае изменения или удаления записи в главной таблице, не будут выполняться никакие действия над
  записью в подчиненной таблице;
- `SET NULL` - в случае удаления записи из главной таблицы, значение столбца в подчиненной таблице будет установлено
  в `NULL`;
- `SET DEFAULT` - в случае удаления записи из главной таблицы, значение столбца в подчиненной таблице будет установлено
  в значение по умолчанию (если оно указано, иначе устанавливается `NULL`).

#### Каскадное удаление

По умолчанию, если на строку из главной таблицы по внешнему ключу ссылается какая-либо строка из подчиненной таблицы, то
удаление строки из главной таблицы невозможно, пока не будут удалены все связанные с ней строки из подчинённой таблицы.
Чтобы удалить строку из главной таблицы вместе с связанными снею строками из подчинённой таблицы, необходимо указать
оператор `CASCADE`. Аналогично работает оператор `ON UPDATE CASCADE`.

```sql
CREATE TABLE Orders
(
    ID         INT PRIMARY KEY,
    CustomerID INT      NOT NULL,
    CreateAt   DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers (ID) ON DELETE CASCADE
);
```

#### Установка `NULL`

`ON DELETE SET NULL` позволяет установить значение столбца в подчиненной таблице в `NULL` при удалении записи из
главной. Тем самым значение `NULL` допустимо для такого внешнего ключа.

```sql
CREATE TABLE Orders
(
    ID         INT PRIMARY KEY,
    CustomerID INT      NOT NULL,
    CreateAt   DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers (ID) ON DELETE SET NULL
);
```

#### Установка значения по умолчанию

```sql
CREATE TABLE Orders
(
    ID         INT PRIMARY KEY,
    CustomerID INT      NOT NULL,
    CreateAt   DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES customers_db (ID) ON DELETE SET DEFAULT
);
```

## Изменение таблицы

Для изменения таблицы используется оператор `ALTER TABLE`. Общий его формальный синтаксис:

```txt
ALTER TABLE [table] (WITH CHECK | WITH NOCHECK)
    ADD [column_name] [column_type] [column_options] 
    DROP [column_name]
    ALTER [column_name] [column_type] [column_options]
    ADD CONSTRAINT [constraint_name] [constraint_definition]
    DROP CONSTRAINT [constraint_name];
```

### Добавление нового столбца

```txt
ALTER TABLE [table]
    ADD [column_name] [column_type] [column_options];
```

При добавлении столбца, если для него указанно, что он должени принимать не нулевое значение, то необходимо указать
значение по умолчанию для старых записей в таблице. Например:

```sql
ALTER TABLE Customers
    ADD Address NVARCHAR(50) NOT NULL DEFAULT 'Unknown';
``` 

### Удаление столбца

Например:

```sql
ALTER TABLE Customers
    DROP COLUMN Address;
```

### Изменение типа столбца

Например:

```sql
ALTER TABLE Customers
    ALTER COLUMN Name NVARCHAR(200) NOT NULL;
```

### Добавление ограничений

При добавления ограничений SQL Server автоматически имеющиеся данные на соответствие. Если данные не соответсвуют, то
ограничение не будет добавлено и команда завершится с ошибкой. Чтобы избежать проверки испольщуется
оператор `WITH NOCHECK`. По умолчанию неявно используется оператор `WITH CHECK`.

```sql
ALTER TABLE Customers
    WITH NOCHECK
        ADD CHECK (Age > 25);
```

### Добавление внешнего ключа

Например:

```sql
ALTER TABLE Orders
    ADD FOREIGN KEY (CustomerID) REFERENCES Customers (ID);
```

### Добавление первичного ключа

Например:

```sql
ALTER TABLE Orders
    ADD PRIMARY KEY (ID);
```

### Добавление ограничений с именами

Например:

```sql
ALTER TABLE Orders
    ADD CONSTRAINT [PK_Orders] PRIMARY KEY (ID),
        CONSTRAINT [FK_Orders_Customers] FOREIGN KEY (CustomerID) REFERENCES Customers (ID);
```

### Удаление ограничений

Если нам не известно какое имя имеет ограничение, то в Microsoft SQL Management Studio можно просмотреть все ограничения
подузле `Keys`.

Пример удаления ограничения:

```sql
ALTER TABLE Orders
    DROP CONSTRAINT FK_Orders;
```

# Пакеты. Команда `GO`

Несколько команд объединённых одним скриптом называются пакетами. Каждый пакет состоит из одного или нескольких
SQL-выражений, которые выполняются как оно целое. В качестве сигнала завершения пакета и выполнения его выражений служит
команда `GO`.

```sql
CREATE DATABASE lessons;
GO;

USE lessons;
CREATE TABLE Customers
(
    ID    INT PRIMARY KEY,
    Name  NVARCHAR(255) NOT NULL,
    Age   INT           NOT NULL,
    Email VARBINARY(30) UNIQUE,
    Phone VARBINARY(30) UNIQUE
);
GO;
```