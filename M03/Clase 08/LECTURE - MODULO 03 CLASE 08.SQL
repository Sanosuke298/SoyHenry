-- Lecture

/*
df = pd.read_csv('Ejemplo.csv')

my_conn = create_engine('mysql+pymysql://root:root1234@localhost:3306/henry_m3')

if_exits ['replace','append','fail']

replace -> Carga full o completa

append -> Carga delta o incremental

df.to_sql(if_exists=)
*/

-- Carga basadas en fechas

SELECT * FROM cliente;
/*
Necesitamos que la fuente tenga un campo de fecha por cada registro a cargar
Tambien la tabla destino tiene que tener un campo fecha para comparar los datos nuevos con los existentes
*/

SELECT MAX(Fecha) FROM venta;

SELECT * FROM cliente;

USE henry_sql;

SELECT * FROM alumnos;

DROP TABLE IF EXISTS auditoria_alumnos;
CREATE TABLE IF NOT EXISTS auditoria_alumnos (
	IdAuditoria INT NOT NULL AUTO_INCREMENT,
    Nombre_nuevo VARCHAR(80),
    Nombre_viejo VARCHAR(80),
    Apellido_nuevo VARCHAR(80),
    Apellido_viejo VARCHAR(80),
	Fecha_Nacimiento_nuevo DATE,
    Fecha_Nacimiento_viejo DATE,
    Ciudad_nuevo VARCHAR(80),
    Ciudad_viejo VARCHAR(80),
    Pais_nuevo VARCHAR(80),
    Pais_viejo VARCHAR(80),
    CedulaIdentidad_nuevo VARCHAR(40),
    CedulaIdentidad_viejo VARCHAR(40),
    Fecha_Auditoria DATETIME,
    Usuario VARCHAR(80),
    PRIMARY KEY(IdAuditoria)
);

SELECT * FROM auditoria_alumnos;


-- Triggers
/*
CREATE TRIGGER nombre_trigger {BEFORE|AFTER} {INSERT|UPDATE|DELETE} ON table
FOR EACH ROW 
ARRANCA EL CODIGO
*/

-- Creamos un trigger llamado auditoria, que por cada insercion en alumnos nos guarda un registro en auditoria_alumnos

CREATE TRIGGER auditoria_delete AFTER DELETE ON alumnos
FOR EACH ROW
INSERT INTO auditoria_alumnos(nombre_nuevo, apellido_nuevo, fecha_nacimiento_nuevo, ciudad_nuevo, pais_nuevo, cedulaIdentidad_nuevo, fecha_auditoria, usuario)
VALUES (OLD.nombre, OLD.Apellido, OLD.Fecha_nacimiento, OLD.Ciudad, OLD.Pais, OLD.cedulaIdentidad, NOW(), CURRENT_USER())
; 

CREATE TRIGGER auditoria_insert AFTER INSERT ON alumnos 
FOR EACH ROW INSERT INTO auditoria_alumnos(nombre_nuevo, apellido_nuevo, fecha_nacimiento_nuevo, ciudad_nuevo, pais_nuevo, cedulaIdentidad_nuevo, fecha_auditoria, usuario) 
VALUES (NEW.nombre, NEW.Apellido, NEW.Fecha_nacimiento, NEW.Ciudad, NEW.Pais, NEW.cedulaIdentidad, NOW(), CURRENT_USER())
;

CREATE TRIGGER auditoria_update AFTER UPDATE ON alumnos
FOR EACH ROW 
INSERT INTO auditoria_alumnos(Nombre_nuevo, Nombre_viejo, Apellido_nuevo, Apellido_viejo, Fecha_Nacimiento_nuevo, Fecha_Nacimiento_viejo, Ciudad_Nuevo, Ciudad_viejo, Pais_nuevo, Pais_viejo, CedulaIdentidad_nuevo, CedulaIdentidad_viejo, Fecha_Auditoria, Usuario)
VALUES (NEW.Nombre, OLD.Nombre, NEW.Apellido, OLD.Apellido, NEW.Fecha_Nacimiento, OLD.Fecha_Nacimiento, NEW.Ciudad, OLD.Ciudad, NEW.Pais, OLD.Pais, NEW.CedulaIdentidad, OLD.CedulaIdentidad, NOW(), CURRENT_USER())
;

select * from alumnos;

INSERT INTO alumnos
VALUES ('Tomas','Veron','1998-08-24','Córdoba','Argentina','39545616');

UPDATE alumnos
SET Nombre = 'Mauro', Apellido = 'Lombardo', CedulaIdentidad = '12345678';


SELECT * FROM auditoria_alumnos;

DROP TRIGGER auditoria_delete;
DROP TRIGGER auditoria_insert;

DELETE FROM alumnos WHERE nombre = 'Mauro';

TRUNCATE TABLE alumnos;
-- 12 votaron que no, ganaron!
TRUNCATE TABLE alumnos
;ROLLBACK ;

USE henry_m3;


CREATE TABLE IF NOT EXISTS dim_canal_venta (
		IdCanal INT,
        Canal VARCHAR(40)
);

select @@global.secure_file_priv;

CREATE TABLE IF NOT EXISTS canal_venta_aud (
	IdAuditoria INT NOT NULL AUTO_INCREMENT,
    IdCanal INT,
    Canal VARCHAR(40),
    Fecha DATETIME,
    Usuario VARCHAR(40),
    PRIMARY KEY(IdAuditoria)

);


CREATE TRIGGER cargas AFTER INSERT ON dim_canal_venta
FOR EACH ROW 
INSERT INTO canal_venta_aud (IdCanal, Canal, Fecha, Usuario)
VALUES (NEW.IdCanal, NEW.Canal, NOW(), CURRENT_USER())
;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\CanalDeVenta.csv'
INTO TABLE dim_canal_venta 
FIELDS TERMINATED BY ',' ESCAPED BY '' ENCLOSED BY ''
LINES TERMINATED BY '\n' IGNORE 1 LINES
(IdCanal, Canal);

SELECT * FROM dim_canal_venta;
SELECT * FROM canal_venta_aud; -- Si cargamos datos desde un csv los guarda en lña tabla auditoria con el trigger

/*
def TRUNCATE(tabla):
	for columna in tabla.columns.to_list():
		for item in tabla[columna]:
			del tabla.columna[item]

*/
