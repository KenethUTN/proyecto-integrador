-- Crear la base de datos
CREATE DATABASE prueba;
GO

-- Seleccionar la base de datos
USE prueba;
GO

-- Crear la tabla op_chofer
CREATE TABLE op_chofer (
    cho_cedula VARCHAR(25) PRIMARY KEY,
    cho_tipocedula CHAR(1),
    cho_ape1 VARCHAR(25),
    cho_ape VARCHAR(25),
    cho_nombre VARCHAR(25)
);
GO

-- Insertar datos en la tabla op_chofer
INSERT INTO op_chofer (cho_cedula, cho_tipocedula, cho_ape1, cho_ape, cho_nombre) VALUES ('1234567890', 'V', 'Perez', 'Lopez', 'Juan');
INSERT INTO op_chofer (cho_cedula, cho_tipocedula, cho_ape1, cho_ape, cho_nombre) VALUES ('0987654321', 'E', 'Gomez', 'Martinez', 'Pedro');
GO

-- Crear la tabla op_tipo_camion
CREATE TABLE op_tipo_camion (
    cam_idTipoCamion VARCHAR(8) PRIMARY KEY
);
GO

-- Insertar datos en la tabla op_tipo_camion
INSERT INTO op_tipo_camion (cam_idTipoCamion) VALUES ('TC123456');
INSERT INTO op_tipo_camion (cam_idTipoCamion) VALUES ('TC654321');
GO

-- Crear la tabla op_camion
CREATE TABLE op_camion (
    cam_placa VARCHAR(15) PRIMARY KEY,
    cam_idtipocamion VARCHAR(8) FOREIGN KEY REFERENCES op_tipo_camion(cam_idTipoCamion),
    cam_cedchofer VARCHAR(25) FOREIGN KEY REFERENCES op_chofer(cho_cedula),
    cam_tara NUMERIC(18, 0)
);
GO

-- Insertar datos en la tabla op_camion
INSERT INTO op_camion (cam_placa, cam_idtipocamion, cam_cedchofer, cam_tara) VALUES ('ABC123', 'TC123456', '1234567890', 12000);
INSERT INTO op_camion (cam_placa, cam_idtipocamion, cam_cedchofer, cam_tara) VALUES ('XYZ789', 'TC654321', '0987654321', 15000);
GO

-- Crear la tabla op_camion_chofer
CREATE TABLE op_camion_chofer (
    cch_id_camion VARCHAR(15),
    cch_id_chofer VARCHAR(25),
    PRIMARY KEY (cch_id_camion, cch_id_chofer),
    FOREIGN KEY (cch_id_camion) REFERENCES op_camion(cam_placa),
    FOREIGN KEY (cch_id_chofer) REFERENCES op_chofer(cho_cedula)
);
GO

-- Insertar datos en la tabla op_camion_chofer
INSERT INTO op_camion_chofer (cch_id_camion, cch_id_chofer) VALUES ('ABC123', '1234567890');
INSERT INTO op_camion_chofer (cch_id_camion, cch_id_chofer) VALUES ('XYZ789', '0987654321');
GO


-- Crear la tabla ServicioGranel
CREATE TABLE ServicioGranel (
    lxServicioGranel INT PRIMARY KEY,
    DsServicioGranel NVARCHAR(64),
    FcServicioGranel DATETIME
);
GO

-- Insertar datos en la tabla ServicioGranel
INSERT INTO ServicioGranel (lxServicioGranel, DsServicioGranel, FcServicioGranel) VALUES (1, 'Carga de Granos', '2024-07-21T10:00:00');
INSERT INTO ServicioGranel (lxServicioGranel, DsServicioGranel, FcServicioGranel) VALUES (2, 'Carga de Minerales', '2024-07-21T15:00:00');
GO

-- Crear la tabla VCliente
CREATE TABLE VCliente (
    idCliente NVARCHAR(20) PRIMARY KEY,
    DsCliente NVARCHAR(150)
);
GO

-- Insertar datos en la tabla VCliente
INSERT INTO VCliente (idCliente, DsCliente) VALUES ('CL001', 'Cliente 1 SA');
INSERT INTO VCliente (idCliente, DsCliente) VALUES ('CL002', 'Cliente 2 Ltda');
GO

-- Crear la tabla VCarga
CREATE TABLE VCarga (
    idTipoCarga INT PRIMARY KEY,
    DsTipoCarga NVARCHAR(50)
);
GO

-- Insertar datos en la tabla VCarga
INSERT INTO VCarga (idTipoCarga, DsTipoCarga) VALUES (1, 'Granos');
INSERT INTO VCarga (idTipoCarga, DsTipoCarga) VALUES (2, 'Minerales');
GO


--Tablas nuestras
-- Crear la tabla Vista
CREATE TABLE Vista (
    lx_vista INT IDENTITY(1,1) PRIMARY KEY,
    lx_ServicioGranel INT FOREIGN KEY REFERENCES ServicioGranel(lxServicioGranel),
    idTipoCarga INT FOREIGN KEY REFERENCES VCarga(idTipoCarga),
    cho_cedula VARCHAR(25),
    cam_placa VARCHAR(15),
    fecha_hora DATETIME DEFAULT SYSDATETIME(), 
    estado BIT
);
GO

-- Insertar datos en la tabla Vista
-- La fecha y hora se establecerán automáticamente
INSERT INTO Vista (lx_ServicioGranel, idTipoCarga, cho_cedula, cam_placa, estado) 
VALUES (1, 1, '1234567890', 'ABC123', 1);

INSERT INTO Vista (lx_ServicioGranel, idTipoCarga, cho_cedula, cam_placa, estado) 
VALUES (2, 2, '0987654321', 'XYZ789', 0);
GO

-- Crear la tabla SAT
CREATE TABLE SAT (
    lx_SAT INT IDENTITY(1,1) PRIMARY KEY,
    usuario VARCHAR(50),
    lxServicioGranel INT FOREIGN KEY REFERENCES ServicioGranel(lxServicioGranel),
    idTipoCarga INT FOREIGN KEY REFERENCES VCarga(idTipoCarga),
    idCliente NVARCHAR(20) FOREIGN KEY REFERENCES VCliente(idCliente),
    fecha_hora DATE,
    estado BIT
);
GO

-- Insertar datos en la tabla SAT
INSERT INTO SAT (usuario, lxServicioGranel, idTipoCarga, idCliente, fecha_hora, estado) 
VALUES ('usuario1', 1, 1, 'CL001', '2024-07-21', 1);
INSERT INTO SAT (usuario, lxServicioGranel, idTipoCarga, idCliente, fecha_hora, estado) 
VALUES ('usuario2', 2, 2, 'CL002', '2024-07-22', 0);
GO

-- Crear la tabla SAT_Detalle
CREATE TABLE SAT_Detalle (
    lx_SAT_Detalle INT IDENTITY(1,1) PRIMARY KEY,
    lxSAT INT FOREIGN KEY REFERENCES SAT(lx_SAT),
    cam_placa VARCHAR(15) FOREIGN KEY REFERENCES op_camion(cam_placa),
    cho_cedula VARCHAR(25) FOREIGN KEY REFERENCES op_chofer(cho_cedula),
    ejes INT
);
GO

-- Insertar datos en la tabla SAT_Detalle
INSERT INTO SAT_Detalle (lxSAT, cam_placa, cho_cedula, ejes) 
VALUES (1, 'ABC123', '1234567890', 2);
INSERT INTO SAT_Detalle (lxSAT, cam_placa, cho_cedula, ejes) 
VALUES (2, 'XYZ789', '0987654321', 3);
GO

-- Crear la tabla SAT_Bitacora
CREATE TABLE SAT_Bitacora (
    lx_SAT_Bitacora INT IDENTITY(1,1) PRIMARY KEY,
    fecha_hora DATE,
    usuario VARCHAR(30),
    accion VARCHAR(30),
    tabla VARCHAR(25),
    registro INT
);
GO

-- Insertar datos en la tabla SAT_Bitacora
INSERT INTO SAT_Bitacora (fecha_hora, usuario, accion, tabla, registro) 
VALUES ('2024-07-21', 'admin', 'INSERT', 'SAT', 1);
INSERT INTO SAT_Bitacora (fecha_hora, usuario, accion, tabla, registro) 
VALUES ('2024-07-22', 'admin', 'UPDATE', 'SAT_Detalle', 2);
GO

CREATE PROCEDURE ActualizarEstadoVista
AS
BEGIN
    -- Actualizar el campo 'estado' en la tabla 'Vista'
    UPDATE Vista
    SET estado = CASE
        WHEN EXISTS (
            SELECT 1
            FROM op_camion_chofer
            WHERE op_camion_chofer.cch_id_camion = Vista.cam_placa
            AND op_camion_chofer.cch_id_chofer = Vista.cho_cedula
        ) THEN 1
        ELSE 0
    END;
END
GO

EXECUTE ActualizarEstadoVista;


DELETE FROM Vista WHERE cho_cedula = 855648049;