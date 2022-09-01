# Основы T-SQL. DML

## Добавление данных. Команда `INSERT`

Для добавления данных применяется команда `INSERT`. Формальный синтаксиc:

```txt
INSERT INTRO [table] ([column_1], ..., [column_n]) VALUES ([value_1, value_2, value_n);
```

В начале после выражения `INSERT INTO` в скобках идёт список столбцов, в которые необходимо добавлять данные, а после
ключевого слова `VALUES` в скобках перечисляется добавляемые значения для столбцов.

Например, была создана база данных:

```sql
CREATE DATABASE products;
GO;

USE products;
CREATE TABLE Products
(
    ID           INT IDENTITY PRIMARY KEY,
    Name         VARCHAR(30) NOT NULL,
    Manufacturer VARCHAR(20) NOT NULL,
    Count        INT         NOT NULL DEFAULT 0,
    Price        MONEY       NOT NULL
);
GO;
```

Добавим в неё строчку:

```sql
INSERT INTO Products
VALUES ('iPhone 7', 'Apple', 5, 52000);
```

После ключевого слова `VALUES` в скобках перечисляются значения для столбцов по порядку их объявления, если не указан
список столбцов. Для первого столбца `ID` указан атрибут `IDENTITY`, поэтому для него значение не указывается (и
указание явного значения возможно только при использовании списка столбцов и установки параметра `IDENTITY_INSERT` для
таблицы в `ON`). Остальные значению передаются столбцам по порядку.

Также можно указать собственный порядок столбцов. В случае указания не полного списка столбцов, то для неуказнных
столбцов будет использоватся значение по умолчанию и `NULL`. Например:

```sql
INSERT INTO Products (Name, Price, Manufacturer)
VALUES ('iPhone 6S', 41000, 'Apple');
```

Пример добавления добавления нескольких строк:

```sql
INSERT INTO Products
VALUES ('iPhone X', 'Apple', 15, 168000),
       ('iPhone 8', 'Apple', 8, 52000),
       ('Galaxy S8', 'Samsung', 1, 52000);
```

При добавлении можно указать `DEFAULT`, чтобы для столбца использовалось значение по умолчанию. Например:

```sql
INSERT INTO Products
VALUES ('Mi 6', 'Xiaomi', DEFAULT, 28000); 
```

В случае если все столбцы имеют значение DEFAULT можно использовать следующую конструкцию:

```sql
INSERT INTO Products DEFAULT
VALUES;
```

## Выборка данных. Команда `SELECT`

Для получения данных применяется команда `SELECT`. Формальный синтаксиси:

```txt
SELECT [column_1], ..., [column_n] FROM [table]
```

Пример выборки всех записей из таблицы `Products`:

```sql
SELECT *
FROM Products;
```

Использование `*` для выборки всех столбцов рекомендуется использовать, когда нужно получить все данные из таблицы или
если не известны имена столбцов.

Пример выборки всех записей из таблицы `Products`, с указаннием столбцов:

```sql
SELECT Name, Price
FROM Products;
```

В качестве столбца может быть любое выражение, тем самым это может быть результат врифметической операции или
конкатенация строк. Например:

```sql
SELECT Name + ' (' + Manufacturer + ')', Price, Price * Count
FROM Products;
```

С помощью оператора `AS` можно указать имя для выводимого столбца. Например:

```sql
SELECT Name + ' (' + Manufacturer + ')' AS ProductName
FROM Products;
```

### `DISTINCT`

Оператор `DISTINCT` позволяет выбрать только уникальные значения из выборки. Например, в следующем примеру будут выбраны
только уникальные значения для указанного столбца:

```sql
SELECT DISTINCT Manufacturer
FROM Products;
```

### Выборка с добавлением

#### `SELECT INTO`

Оператор `SELECT INTO` позволяет выбрать данные из таблицы и записать их в другую таблицу. При этом вторая таблица
не должна существовать в базе данных, так как она создаётся автоматически. Например:

```sql
DROP TABLE IF EXISTS ProductsCopy;
SELECT Name + ' (' + Manufacturer + ')' AS Model,
       Price,
       Price * Count                    AS TotalSum
INTO ProductsSummary
FROM Products;
```

В случае если таблица уже существует, то нужно использовать оператор `INSERT INTO`. Например:

```sql
INSERT INTO ProductsSummary
SELECT Name + ' (' + Manufacturer + ')' AS Model,
       Price,
       Price * Count                    AS TotalSum
FROM Products;
``` 

## Сортировка. `ORDER BY`

Оператор `ORDER BY` позволяет сортировать выборку по конкретному столбцу. Например:

```sql
SELECT *
FROM Products
ORDER BY Name;
```

Сортировка также может выполняться по псевдониму столбца оперделённого с помощью `AS`. Например:

```sql
SELECT Name,
       Price * Count AS TotalSum
FROM Products
ORDER BY TotalSum;
```

По умолчанию применяется сортировка по возрастанию, что аналочино использованию оператора `ASC`. Оператор `DESC`
позволяет использовать сортировку по убыванию. Например:

```sql
SELECT Name
FROM Products
ORDER BY Name DESC;
```

Также возможна соортировка по нескольким столбцам. Например:

```sql
SELECT Name,
       Manufacturer
FROM Products
ORDER BY Manufacturer ASC, Name DESC;
```

В качестве критерия для сортировки можно использовать сложное выражение. Например:

```sql
SELECT Name, Price, Count
FROM Products
ORDER BY Price * Count DESC;
```

## Извлечение диапазона строк

### Оператор `TOP`

Оператор `TOP` позволяет выбрать определённое количество строк из таблицы. Например:

```sql
SELECT TOP 4 Name
FROM Products;
```

Дополнительный оператор `PERCENT` позволяет выбрать определённое количество строк из таблицы в процентном отношении.
Например:

```sql
SELECT TOP 75 PERCENT Name
FROM Products;
```

### `OFFSET` и `FETCH`

Для извлечения диапазона строк используются операторы `OFFSET` и `FETCH`. Данные операторы применяются только в
отстортированном наборе данных. Формальный синтаксис:

```txt
ORDER BY [columns]
OFFSET [number_rows_offsets] {ROW|ROWS}
FETCH {FIRST|NEXT} [rows_count] {ROW|ROWS}
```

Например, выборка всех строк начиная с третьей:

```sql
SELECT *
FROM Products
ORDER BY ID
OFFSET 2 ROWS;
```

Пример выборки трёх строк, начиная с третьей:

```sql
SELECT *
FROM Products
ORDER BY ID
OFFSET 2 ROWS FETCH NEXT 3 ROWS ONLY;
```

Данная комбинация операторов в основном используется для постраничной навигации. `FIRST` и `NEXT` являются синонимами и
не имеют разницу, как `ROW` и `ROWS`.

## Фильтрация. `WHERE`

Оператор `WHERE` позволяет отфильтровать таблицу по условию. Основные операции сравнения, которые можно использовать:

- `=` - равенство;
- `<>` - неравенство;
- `>` - больше;
- `>=` - больше или равно;
- `<` - меньше;
- `<=` - меньше или равно;
- `!>` - не больше;
- `!<` - не меньше.

При этом оператор равенства не учитывает регистр. Пример фильтрации:

```sql
SELECT *
FROM Products
WHERE Manufacturer = 'Samsung';
```

Пример фильтрации с использованием более сложного выражения:

```sql
SELECT *
FROM Products
WHERE Price * Count > 200000;
```

### Логические операторы

Для объединения нескольких условий можно использовать логические операторы:

- `AND` - объединение условий;
- `OR` - любое из условий должно быть выполнено;
- `NOT` - отрицание условия.

Например:

```sql
SELECT *
FROM Products
WHERE Manufacturer = 'Samsung'
   OR Price > 50000;
```

### `IS NULL`

Оператор `IS NULL` позволяет отфильтровать таблицу по неопределённому значению поля. Пример:

```sql
SELECT *
FROM Products
WHERE Count IS NULL;
```

Обратным оператором, выполняющим фильтрацию по отсуствию неопределённого значения, является `IS NOT NULL`. Пример:

```sql
SELECT *
FROM Products
WHERE Count IS NOT NULL;
```

## Операторы фильтрации

### Оператор `IN`

Оператор `IN` позволяет оперделить набор значений, которые должны иметь столбцы. Формальный синтаксис:

```txt
WHERE column [NOT] IN ([value_1], ..., [value_n]);
```

Например:

```sql
SELECT *
FROM Products
WHERE Manufacturer IN ('Samsung', 'Xiaomi');
```

### Оператор `BETWEEN`

Оператор `BETWEEN` позволяет оперделить диапазон значений, которым должны соответсвовать записи. Формальный синтаксис:

```txt
WHERE column [NOT] BETWEEN start_value AND end_value;
```

Например:

```sql
SELECT *
FROM Products
WHERE Price BETWEEN 20000 AND 40000;
```

Пример использования `BETWEEN` с более сложным выражением:

```sql
SELECT *
FROM Products
WHERE Price * Count NOT BETWEEN 100000 AND 200000;
```

### Оператор `LIKE`

Оператор `LIKE` позволяет указать строку регулярного выражения, которому должно соответсвовать значение поля. Формальный
синтаксис:

```txt
WHERE column [NOT] LIKE pattern;
```

Для определения шаблона могут применяться следующие специальные символы:

- `%` - любое количество символов, включая их отсуствие;
- `_` - один символ;
- `[]` - один символ из указанных в скобках;
- `[-]` - один сивол из указанного диапазона;
- `[^]` - любой символ, кроме тех, которые в скобках.

Например:

```sql
SELECT *
FROM Products
WHERE Name LIKE 'iPhone [0-9]%';
```

## Обновление данных. Команды `UPDATE`

Команда `UPDATE` позволяет обновить значения полей в таблице. Формальный синтаксис:

```txt
UPDATE [table]
SET [column_1] = [value_1], ..., [column_n] = [value_n]
[FROM ([selection]) AS [alias]]
[WHERE [condition]];
```

Например, увеличим значение поля `Price` для всех записей в таблице `Products`:

```sql
UPDATE Products
SET Price = Price + 5000;
```

Пример обновления записей, соответсвующих критерию:

```sql
UPDATE Products
SET Manufacturer = 'Samsung Inc.'
WHERE Manufacturer = 'Samsung';
```

Пример обновления записей, полученных из выборки:

```sql
UPDATE Products
SET Manufacturer = 'Apple Inc.'
FROM (SELECT TOP 2 * FROM Products WHERE Manufacturer = 'Apple') AS Selected
WHERE Products.ID = Selected.ID;
```

## Удаление данных. Команда `DELETE`

Для удалаения используется команда `DELETE`. Формальный синтаксис:

```txt
DELETE [FROM] [table]
[WHERE [condition]];
```

Например:

```sql
DELETE
FROM Products
WHERE ID = 12;
```

Пример удаления записей, соответсвующих выборке:

```sql
DELETE
FROM Products
WHERE ID IN (SELECT TOP 2 * FROM Products WHERE Manufacturer = 'Apple');
```

Пример удаления всех строк из таблицы:

```sql
DELETE Products;
```