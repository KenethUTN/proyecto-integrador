use master;

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

drop table VCliente

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

-- Crear la tabla Vista
CREATE TABLE Vista (
    lx_vista INT IDENTITY(1,1) PRIMARY KEY,
    lx_ServicioGranel INT FOREIGN KEY REFERENCES ServicioGranel(lxServicioGranel),
	idCliente NVARCHAR(20) FOREIGN KEY REFERENCES VCliente (idCliente),
    idTipoCarga INT FOREIGN KEY REFERENCES VCarga(idTipoCarga),
    cho_cedula VARCHAR(25),
    cam_placa VARCHAR(15),
    fecha_hora DATETIME DEFAULT SYSDATETIME(), 
    estado BIT
);
GO

-- Insertar datos en la tabla Vista
INSERT INTO Vista (lx_ServicioGranel, idCliente, idTipoCarga, cho_cedula, cam_placa, estado) 
VALUES (2,'CL001', 2 , '0987654321', 'XYZ789', 0);
GO 


--Keneth
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

--Tabla para cargar desde excel
CREATE TABLE CargarDesdeExcelTMP
(
    IxCargarDesdeExcelTMP INT PRIMARY KEY IDENTITY(1,1), -- Clave primaria
    lx_ServicioGranel INT FOREIGN KEY REFERENCES ServicioGranel(lxServicioGranel), -- Clave for�nea a ServicioGranel
    idCliente NVARCHAR(20) FOREIGN KEY REFERENCES VCliente(idCliente), -- Clave for�nea a VCliente
    idTipoCarga INT FOREIGN KEY REFERENCES VCarga(idTipoCarga), -- Clave for�nea a VCarga
    cho_cedula VARCHAR(25), -- Columna para c�dula del chofer
    cam_placa VARCHAR(15)  -- Columna para placa del cami�n
);

--Procedimiento almacenado para cargar datos a la tabla temporal de cargar datos
CREATE PROCEDURE AgregarCargarDesdeExcelTMP_OP
    @lx_ServicioGranel INT,
    @idCliente NVARCHAR(50),
    @idTipoCarga INT,
    @cho_cedula VARCHAR(20),
    @cam_placa VARCHAR(20)
AS
BEGIN
    -- Aqu� ir�a el c�digo para insertar los datos en la tabla correspondiente
    INSERT INTO CargarDesdeExcelTMP_OP(lx_ServicioGranel, idCliente, idTipoCarga, cho_cedula, cam_placa)
    VALUES (@lx_ServicioGranel, @idCliente, @idTipoCarga, @cho_cedula, @cam_placa);
END;

--Procedimiento para copiar los datos de temporal a vista
CREATE PROCEDURE CopiarDatosDesdeTemporal
@Usuario NVARCHAR(100) 
AS
BEGIN
    -- Insertar datos en la tabla Vista desde CargarDesdeExcelTMP
    INSERT INTO Vista (lx_ServicioGranel, idCliente, idTipoCarga, cho_cedula, cam_placa, estado)
    SELECT lx_ServicioGranel, idCliente, idTipoCarga, cho_cedula, cam_placa, 1
    FROM CargarDesdeExcelTMP;
    
    -- Opcional: Elimina los datos de la tabla temporal si ya no los necesitas
    DELETE FROM CargarDesdeExcelTMP;

    -- Insertar registro en la bit�cora
    INSERT INTO BitacoraSAT (Fecha, Usuario, Accion, Tabla, Registro)
    VALUES (GETDATE(), @Usuario, 'EXCEL', 'Vista', 000);
END;

-- --Crear tabla bitacora
-- CREATE TABLE BitacoraSAT
-- (
--     IxBitacoraSAT INT IDENTITY(1,1) PRIMARY KEY,    -- Identificador �nico de la bit�cora
--     Fecha DATETIME DEFAULT GETDATE(),                -- Fecha y hora del evento, con valor por defecto como la fecha y hora actuales
--     Usuario NVARCHAR(100),                          -- Nombre del usuario que realiz� la acci�n
--     Accion NVARCHAR(50),                            -- Tipo de acci�n (Insertar, Modificar, Borrar, Actualizar)
--     Tabla NVARCHAR(50),                             -- Nombre de la tabla afectada (Vista o Temporal)
--     Registro INT                                    -- ID del registro afectado en la tabla
-- );

--Procedimientos para bitacora
	--Eliminar
CREATE PROCEDURE EliminarRegistroYRegistrarBitacora
    @Id INT,                  -- ID del registro a eliminar
    @Usuario NVARCHAR(100)    -- Usuario que realiza la acci�n
AS
BEGIN
    -- Iniciar una transacci�n
    BEGIN TRANSACTION;

    -- Intentar eliminar el registro
    BEGIN TRY
        -- Eliminar el registro de la tabla Vista
        DELETE FROM Vista 
        WHERE lx_vista = @Id;

        -- Registrar la acci�n en la bit�cora
        INSERT INTO BitacoraSAT (Fecha, Usuario, Accion, Tabla, Registro)
        VALUES (GETDATE(), @Usuario, 'Borrar', 'Vista', @Id);

        -- Confirmar la transacci�n
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- En caso de error, revertir la transacci�n
        ROLLBACK TRANSACTION;

        -- Lanzar el error para manejo posterior
        THROW;
    END CATCH
END;

	--Mofificar/Editar
CREATE PROCEDURE ActualizarRegistroYRegistrarBitacora
    @Id INT,
    @ServicioGranel INT,
    @Cliente NVARCHAR(50),
    @TipoCarga INT,
    @Cedula NVARCHAR(50),
    @Placa NVARCHAR(50),
    @Estado BIT,
    @Usuario NVARCHAR(50)
AS
BEGIN
    -- Actualizar el registro en la tabla Vista
    UPDATE Vista
    SET lx_ServicioGranel = @ServicioGranel,
        idCliente = @Cliente,
        idTipoCarga = @TipoCarga,
        cho_cedula = @Cedula,
        cam_placa = @Placa,
        estado = @Estado
    WHERE lx_vista = @Id;

    -- Registrar la acci�n en la bit�cora
    INSERT INTO BitacoraSAT (Fecha, Usuario, Accion, Tabla, Registro)
    VALUES (GETDATE(), @Usuario, 'Actualizar', 'Vista', @Id);
END

	--Insertar
CREATE PROCEDURE InsertarRegistroYRegistrarBitacora
    @ServicioGranel INT,
    @Cliente NVARCHAR(50),
    @TipoCarga INT,
    @Cedula NVARCHAR(20),
    @Placa NVARCHAR(20),
    @Estado BIT,
    @Usuario NVARCHAR(50)
AS
BEGIN
    -- Iniciar una transacci�n
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Insertar el nuevo registro en la tabla Vista
        INSERT INTO Vista (lx_ServicioGranel, idCliente, idTipoCarga, cho_cedula, cam_placa, estado)
        VALUES (@ServicioGranel, @Cliente, @TipoCarga, @Cedula, @Placa, @Estado);

        -- Obtener el ID del nuevo registro
        DECLARE @NuevoId INT;
        SET @NuevoId = SCOPE_IDENTITY();

        -- Registrar la acci�n en la bit�cora
        INSERT INTO BitacoraSAT (Fecha, Usuario, Accion, Tabla, Registro)
        VALUES (GETDATE(), @Usuario, 'Insertar', 'Vista', @NuevoId);

        -- Confirmar la transacci�n
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Deshacer la transacci�n en caso de error
        ROLLBACK TRANSACTION;

        -- Lanzar la excepci�n para manejarla en el c�digo de la aplicaci�n
        THROW;
    END CATCH
END

--InsertarDesdeExcel
CREATE PROCEDURE CargarExcelYRegistrarBitacora
    @ServicioGranel INT,
    @Cliente NVARCHAR(50),
    @TipoCarga INT,
    @Cedula NVARCHAR(20),
    @Placa NVARCHAR(20),
    @Estado BIT,
    @Usuario NVARCHAR(50)
AS
BEGIN
    -- Iniciar una transacci�n
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Insertar el nuevo registro en la tabla Vista
        INSERT INTO Vista (lx_ServicioGranel, idCliente, idTipoCarga, cho_cedula, cam_placa, estado)
        VALUES (@ServicioGranel, @Cliente, @TipoCarga, @Cedula, @Placa, @Estado);

        -- Obtener el ID del nuevo registro
        DECLARE @NuevoId INT;
        SET @NuevoId = SCOPE_IDENTITY();

        -- Registrar la acci�n en la bit�cora
        INSERT INTO BitacoraSAT (Fecha, Usuario, Accion, Tabla, Registro)
        VALUES (GETDATE(), @Usuario, 'CARGA', 'Vista', 'EXCEL');

        -- Confirmar la transacci�n
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Deshacer la transacci�n en caso de error
        ROLLBACK TRANSACTION;

        -- Lanzar la excepci�n para manejarla en el c�digo de la aplicaci�n
        THROW;
    END CATCH
END;

SELECT * FROM BitacoraSAT;


drop table Vista

--ultima
CREATE PROCEDURE CopiarYEliminarDatosDesdeSGTemporal
AS
BEGIN
    -- Copiar los datos desde SGTemporal a op_camion_chofer, solo donde el estado sea 1
    INSERT INTO op_camion_chofer (cch_id_camion, cch_id_chofer)
    SELECT cch_id_camion, cch_id_chofer
    FROM SGTemporal
    WHERE estado = 1;

    -- Eliminar los registros copiados de SGTemporal
    DELETE FROM SGTemporal
    WHERE estado = 1;
END;