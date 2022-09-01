# Группировка

## Агрегатные функции

Агрегатные функции выполняют вычисления над значениями в наборе записей. В T-SQL имеются следующие агрегатные функции:

- `AVG` - вычисляет среднее значение;
- `SUM` - вычисляет сумму значений;
- `MIN` - вычисляет минимальное значение;
- `MAX` - вычисляет максимальное значение;
- `COUNT` - вычисляет количество записей в запросе.

В качестве аргумента принимается выражение, представляющий критерий для опеределения значений. Например, это может быть
название столбца, над значениями которого проводится вычисления. `AVG` и `SUM` принимают в качестве аргумента только
числовые значения, а `MIN`, `MAX` и `COUNT` - числовые, строки и даты. Все агрегатные функции, за исключением
`COUNT(*)`, игнорируют неопределённые значения.

### `AVG`

Например, есть таблица с данными:

```sql
CREATE TABLE Products
(
    ID           INT IDENTITY PRIMARY KEY,
    Name         NVARCHAR(30) NOT NULL,
    Manufacturer NVARCHAR(20) NOT NULL,
    Count        INT DEFAULT 0,
    Price        MONEY        NOT NULL
);

INSERT INTO Products
VALUES ('iPhone 6', 'Apple', 3, 36000),
       ('iPhone 6S', 'Apple', NULL, 41000),
       ('iPhone 7', 'Apple', NULL, 52000),
       ('Galaxy S8', 'Samsung', 2, 46000),
       ('Galaxy S8 Plus', 'Samsung', 1, 56000),
       ('Mi6', 'Xiaomi', 5, 28000),
       ('OnePlus 5', 'OnePlus', 6, 38000);
```

Пример нахождения средней цены товара:

```sql
SELECT AVG(Price) AS AveragePrice
FROM Products;
```

### `COUNT`

Существует две формы выполнения `COUNT`:

- `COUNT(*)` - вычисляет количество всех записей в запросе;
- `COUNT(column_name)` - вычисляет количество записей, значения которых не равны `NULL`.

Например:

```sql
SELECT COUNT(*)     AS TotalCount,
       COUNT(Count) AS NotNullCount
FROM Products;
```

### `MIN` и `MAX`

Например:

```sql
SELECT MIN(Price) AS MinPrice,
       MAX(Price) AS MaxPrice
FROM Products;
```

### `SUM`

Например:

```sql
SELECT SUM(Count)         AS TotalCount,
       SUM(Price * Count) AS TotalCost
FROM Products;
```

### `ALL` и `DISTINCT`

По умолчанию все указанные агрегатные функции учитывают все записи для вычисления результата. Тем самым неявно
применяется оператор `ALL`. Чтобы учитывать только уникальные значения применяется оператор `DISTINCT`. Например:

```sql
SELECT COUNT(DISTINCT Manufacturer) AS DistinctManufacturers,
       COUNT(ALL Manufacturer)      AS AllManufacturers
FROM Products;
```

### Комбинирование функций

Наример:

```sql
SELECT COUNT(*)   AS ProdCount,
       SUM(Count) AS TotalCount,
       MIN(Price) AS MinPrice,
       MAX(Price) AS MaxPrice,
       AVG(Price) AS AvgPrice
FROM Products;
```  

## Операторы `GROUP BY` и `HAVING`

Для группировки данных используется оператор `GROUP BY` и `HAVING`. Формальный синтаксис:

```txt
SELECT [column]
FROME [table]
[WHERE [condition_for_filtering]]
[GROUP BY [column_for_grouping]]
[HAVING [condition_for_filtering_groups]]
```

### `GROUP BY`

Оператор `GROUP BY` определяет, как сторки будут группироваться.

Пример группировки по производителю:

```sql
SELECT Manufacturer, COUNT(*) AS ModelsCount
FROM Products
GROUP BY Manufacturer;
```