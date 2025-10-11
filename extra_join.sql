

/*
ANÁLISIS DE LA OPERACIÓN: All - Odd

En teoría de conjuntos:
- All = {1,2,3,4,5,6,7,8,9,10}
- Odd = {1,3,5,7,9}
- All - Odd = {2,4,6,8,10}

Esto significa: todos los elementos que están en All pero NO están en Odd.

EXPLICACIÓN DE CÓMO REPRESENTARLO CON JOINs:

La operación All - Odd se puede representar en SQL usando LEFT JOIN:

1. LEFT JOIN une TODAS las filas de la tabla izquierda (All_set)
2. Intenta emparejar cada fila con la tabla derecha (Odd)
3. Si NO hay match, los valores de la tabla derecha son NULL
4. Filtramos con WHERE o.value IS NULL para obtener solo elementos sin match
5. El resultado son los elementos que están en All pero NO en Odd

TIPO DE JOIN USADO: LEFT JOIN (LEFT OUTER JOIN)

Por qué LEFT JOIN y no otros:
- INNER JOIN: Solo devolvería elementos que están en AMBAS tablas (intersección)
- RIGHT JOIN: Tomaría como base Odd en lugar de All
- FULL OUTER JOIN: Incluiría elementos de ambas tablas
- LEFT JOIN: Perfecto para encontrar elementos de All que NO están en Odd
*/


DROP TABLE IF EXISTS All_set;
DROP TABLE IF EXISTS Even;
DROP TABLE IF EXISTS Odd;

CREATE TABLE All_set (value INTEGER);
INSERT INTO All_set VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

CREATE TABLE Even (value INTEGER);
INSERT INTO Even VALUES (2),(4),(6),(8),(10);

CREATE TABLE Odd (value INTEGER);
INSERT INTO Odd VALUES (1),(3),(5),(7),(9);


SELECT '========================================' AS separador;
SELECT 'EJERCICIO 1: OPERACIÓN All - Odd' AS titulo;
SELECT '========================================' AS separador;

SELECT 'Método 1: Usando EXCEPT' AS metodo;
SELECT value FROM All_set
EXCEPT
SELECT value FROM Odd;


SELECT 'Método 2: Usando LEFT JOIN (equivalente)' AS metodo;
SELECT a.value
FROM All_set a
LEFT JOIN Odd o ON a.value = o.value
WHERE o.value IS NULL;




DROP TABLE IF EXISTS Rents;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Books;

CREATE TABLE Books (
    ID INTEGER PRIMARY KEY,
    Name TEXT NOT NULL
);

CREATE TABLE Customers (
    ID INTEGER PRIMARY KEY,
    Name TEXT NOT NULL,
    Email TEXT
);

CREATE TABLE Rents (
    ID INTEGER PRIMARY KEY,
    BookID INTEGER,
    CustomerID INTEGER,
    State TEXT,
    FOREIGN KEY (BookID) REFERENCES Books(ID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(ID)
);


INSERT INTO Books (ID, Name) VALUES
(1, 'Harry Potter'),
(2, 'Lord of the Rings'),
(3, 'The Hobbit'),
(4, 'Game of Thrones'),
(5, 'Pride and Prejudice');

INSERT INTO Customers (ID, Name, Email) VALUES
(1, 'Maria Lopez', 'maria@email.com'),
(2, 'Juan Perez', 'juan@email.com'),
(3, 'Ana Garcia', 'ana@email.com'),
(4, 'Carlos Ruiz', 'carlos@email.com');

INSERT INTO Rents (ID, BookID, CustomerID, State) VALUES
(1, 1, 1, 'Returned'),
(2, 2, 1, 'On time'),
(3, 1, 2, 'Returned'),
(4, 3, 2, 'Overdue'),
(5, 4, 1, 'On time'),
(6, 2, 3, 'Returned');



*/

SELECT '========================================' AS separador;
SELECT 'EJERCICIO 2: NÚMERO DE RENTAS POR CLIENTE' AS titulo;
SELECT '========================================' AS separador;

SELECT 
    c.ID AS CustomerID,
    c.Name AS CustomerName,
    COUNT(r.ID) AS TotalRents
FROM Customers c
LEFT JOIN Rents r ON c.ID = r.CustomerID
GROUP BY c.ID, c.Name
ORDER BY TotalRents DESC
LIMIT 3;



SELECT '========================================' AS separador;
SELECT 'EJERCICIO 3: CONSULTA COMPLETA CON MÚLTIPLES JOINS' AS titulo;
SELECT '========================================' AS separador;

SELECT 
    c.Name AS CustomerName,
    b.Name AS BookName,
    r.State AS RentState
FROM Rents r
INNER JOIN Customers c ON r.CustomerID = c.ID
INNER JOIN Books b ON r.BookID = b.ID
ORDER BY c.Name, b.Name;




SELECT '========================================' AS separador;
SELECT 'VERIFICACIÓN: TODAS LAS TABLAS' AS titulo;
SELECT '========================================' AS separador;

SELECT 'Tabla: All_set' AS tabla;
SELECT * FROM All_set;

SELECT 'Tabla: Even' AS tabla;
SELECT * FROM Even;

SELECT 'Tabla: Odd' AS tabla;
SELECT * FROM Odd;

SELECT 'Tabla: Books' AS tabla;
SELECT * FROM Books;

SELECT 'Tabla: Customers' AS tabla;
SELECT * FROM Customers;

SELECT 'Tabla: Rents' AS tabla;
SELECT * FROM Rents;