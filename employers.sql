DROP TABLE IF EXISTS empleados_proyectos_original;

CREATE TABLE empleados_proyectos_original (
    employee_id INTEGER,
    employee_name TEXT,
    department TEXT,
    department_phone TEXT,
    project_id TEXT,
    project_name TEXT

);


INSERT INTO empleados_proyectos_original VALUES
(201, 'Ana Rivera', 'IT', '2222-2222', 'P001', 'Website'),
(201, 'Ana Rivera', 'IT', '2222-2222', 'P002', 'API Development'),
(202, 'Luis Mendez', 'Marketing', '1111-1111', 'P003', 'Campaign');


SELECT * FROM empleados_proyectos_original;



DROP TABLE IF EXISTS employees_2fn;
CREATE TABLE employees_2fn (
    employee_id INTEGER PRIMARY KEY,
    employee_name TEXT NOT NULL,
    department TEXT,
    department_phone TEXT

);

DROP TABLE IF EXISTS projects_2fn;
CREATE TABLE projects_2fn (
    project_id TEXT PRIMARY KEY,
    project_name TEXT NOT NULL

);

DROP TABLE IF EXISTS employee_projects_2fn;
CREATE TABLE employee_projects_2fn (
    employee_id INTEGER,
    project_id TEXT,
    PRIMARY KEY (employee_id, project_id)
    FOREIGN KEY (employee_id) REFERENCES employees_2fn(employee_id)
    FOREIGN KEY (project_id) REFERENCES projects_2fn (project_id)

);


INSERT INTO employees_2fn (employee_id, employee_name, department, department_phone)
SELECT DISTINCT employee_id, employee_name, department, department_phone
FROM empleados_proyectos_original;

INSERT INTO projects_2fn(project_id, project_name)
SELECT DISTINCT project_id, project_name
FROM empleados_proyectos_original;

INSERT  INTO employee_projects_2fn( employee_id, project_id)
SELECT employee_id, project_id
FROM empleados_proyectos_original;


SELECT "EMPLOYEES 2FN:" as tabla;
SELECT * FROM employees_2fn;

SELECT "PROJECTS 2FN : " as tabla;
SELECT * FROM projects_2fn;

SELECT "EMPLOYEE_PROJECTS 2FN : " as tabla;
SELECT * FROM employee_projects_2fn;


-- 3FN CORREGIDO
DROP TABLE IF EXISTS departments_3fn;
CREATE TABLE departments_3fn (
    department_name TEXT PRIMARY KEY,
    department_phone TEXT
);

DROP TABLE IF EXISTS employees_3fn;
CREATE TABLE employees_3fn (
    employee_id INTEGER PRIMARY KEY,
    employee_name TEXT NOT NULL,
    department_name TEXT,
    FOREIGN KEY (department_name) REFERENCES departments_3fn(department_name)
);

DROP TABLE IF EXISTS projects_3fn;
CREATE TABLE projects_3fn (
    project_id TEXT PRIMARY KEY,
    project_name TEXT NOT NULL
);

DROP TABLE IF EXISTS employee_projects_3fn;
CREATE TABLE employee_projects_3fn (
    employee_id INTEGER,
    project_id TEXT,
    PRIMARY KEY (employee_id, project_id),
    FOREIGN KEY (employee_id) REFERENCES employees_3fn(employee_id),
    FOREIGN KEY (project_id) REFERENCES projects_3fn(project_id)
);

INSERT INTO departments_3fn (department_name, department_phone)
SELECT DISTINCT department, department_phone
FROM empleados_proyectos_original;

INSERT INTO employees_3fn (employee_id, employee_name, department_name)
SELECT DISTINCT employee_id, employee_name, department
FROM empleados_proyectos_original;

INSERT INTO projects_3fn (project_id, project_name)
SELECT DISTINCT project_id, project_name
FROM empleados_proyectos_original;

INSERT INTO employee_projects_3fn (employee_id, project_id)
SELECT employee_id, project_id
FROM empleados_proyectos_original;

-- Ver resultados
SELECT * FROM departments_3fn;
SELECT * FROM employees_3fn;
SELECT * FROM projects_3fn;
SELECT * FROM employee_projects_3fn;