USE banco;

-- Cambiar delimitador
DELIMITER //

-- =================================
-- PROCEDIMIENTOS CLIENTES
-- =================================

-- Insertar cliente
CREATE PROCEDURE sp_InsertCliente(
IN p_tipo_cliente VARCHAR(50),
IN p_nombre VARCHAR(100),
IN p_documento VARCHAR(50),
IN p_telefono VARCHAR(20),
IN p_correo VARCHAR(100)
)
BEGIN
INSERT INTO clientes(tipo_cliente,nombre,documento,telefono,correo)
VALUES(p_tipo_cliente,p_nombre,p_documento,p_telefono,p_correo);
END//

-- Ver todos los clientes
CREATE PROCEDURE sp_VerClientes()
BEGIN
SELECT * FROM clientes;
END//

-- Buscar cliente
CREATE PROCEDURE sp_BuscarCliente(
IN p_codigo INT
)
BEGIN
SELECT * FROM clientes
WHERE codigo = p_codigo;
END//

-- Actualizar cliente
CREATE PROCEDURE sp_ActualizarCliente(
IN p_codigo INT,
IN p_nombre VARCHAR(100),
IN p_telefono VARCHAR(20),
IN p_correo VARCHAR(100)
)
BEGIN
UPDATE clientes
SET nombre = p_nombre,
telefono = p_telefono,
correo = p_correo
WHERE codigo = p_codigo;
END//

-- Eliminar cliente
CREATE PROCEDURE sp_EliminarCliente(
IN p_codigo INT
)
BEGIN
DELETE FROM clientes
WHERE codigo = p_codigo;
END//

-- =================================
-- PROCEDIMIENTOS CUENTAS
-- =================================

-- Insertar cuenta
CREATE PROCEDURE sp_InsertCuenta(
IN p_codigo_cliente INT,
IN p_tipo_cuenta VARCHAR(50),
IN p_moneda VARCHAR(20),
IN p_sucursal VARCHAR(100),
IN p_saldo DECIMAL(15,2),
IN p_estado VARCHAR(20)
)
BEGIN
INSERT INTO cuentas(codigo_cliente,tipo_cuenta,moneda,sucursal,saldo,estado)
VALUES(p_codigo_cliente,p_tipo_cuenta,p_moneda,p_sucursal,p_saldo,p_estado);
END//

-- Ver cuentas
CREATE PROCEDURE sp_VerCuentas()
BEGIN
SELECT * FROM cuentas;
END//

-- Buscar cuenta
CREATE PROCEDURE sp_BuscarCuenta(
IN p_numero INT
)
BEGIN
SELECT * FROM cuentas
WHERE numero_cuenta = p_numero;
END//

-- Actualizar cuenta
CREATE PROCEDURE sp_ActualizarCuenta(
IN p_numero INT,
IN p_saldo DECIMAL(15,2),
IN p_estado VARCHAR(20)
)
BEGIN
UPDATE cuentas
SET saldo = p_saldo,
estado = p_estado
WHERE numero_cuenta = p_numero;
END//

-- Eliminar cuenta
CREATE PROCEDURE sp_EliminarCuenta(
IN p_numero INT
)
BEGIN
DELETE FROM cuentas
WHERE numero_cuenta = p_numero;
END//

-- =================================
-- PROCEDIMIENTOS CREDITOS
-- =================================

-- Insertar crédito
CREATE PROCEDURE sp_InsertCredito(
IN p_codigo_cliente INT,
IN p_monto DECIMAL(15,2),
IN p_plazo INT,
IN p_tasa DECIMAL(5,2),
IN p_estado VARCHAR(20)
)
BEGIN
INSERT INTO creditos(codigo_cliente,monto,plazo,tasa_interes,estado)
VALUES(p_codigo_cliente,p_monto,p_plazo,p_tasa,p_estado);
END//

-- Ver créditos
CREATE PROCEDURE sp_VerCreditos()
BEGIN
SELECT * FROM creditos;
END//

-- Buscar crédito
CREATE PROCEDURE sp_BuscarCredito(
IN p_operacion INT
)
BEGIN
SELECT * FROM creditos
WHERE numero_operacion = p_operacion;
END//

-- Eliminar crédito
CREATE PROCEDURE sp_EliminarCredito(
IN p_operacion INT
)
BEGIN
DELETE FROM creditos
WHERE numero_operacion = p_operacion;
END//

-- =================================
-- PROCEDIMIENTOS TRANSACCIONES
-- =================================

-- Insertar transacción
CREATE PROCEDURE sp_InsertTransaccion(
IN p_origen INT,
IN p_destino INT,
IN p_tipo VARCHAR(50),
IN p_monto DECIMAL(15,2),
IN p_canal VARCHAR(50)
)
BEGIN
INSERT INTO transacciones(
cuenta_origen,
cuenta_destino,
tipo,
monto,
canal,
fecha
)
VALUES(
p_origen,
p_destino,
p_tipo,
p_monto,
p_canal,
NOW()
);
END//

-- Ver transacciones
CREATE PROCEDURE sp_VerTransacciones()
BEGIN
SELECT * FROM transacciones;
END//

-- =================================
-- PROCEDIMIENTO TRANSFERENCIA
-- =================================

CREATE PROCEDURE sp_Transferencia(
IN p_cuenta_origen INT,
IN p_cuenta_destino INT,
IN p_monto DECIMAL(15,2)
)
BEGIN

DECLARE saldo_actual DECIMAL(15,2);

SELECT saldo INTO saldo_actual
FROM cuentas
WHERE numero_cuenta = p_cuenta_origen;

IF saldo_actual < p_monto THEN

SELECT 'Saldo insuficiente' AS Mensaje;

ELSE

UPDATE cuentas
SET saldo = saldo - p_monto
WHERE numero_cuenta = p_cuenta_origen;

UPDATE cuentas
SET saldo = saldo + p_monto
WHERE numero_cuenta = p_cuenta_destino;

INSERT INTO transacciones(
cuenta_origen,
cuenta_destino,
tipo,
monto,
canal,
fecha
)
VALUES(
p_cuenta_origen,
p_cuenta_destino,
'Transferencia',
p_monto,
'Sistema',
NOW()
);

SELECT 'Transferencia realizada correctamente' AS Mensaje;

END IF;

END//

-- Restaurar delimitador
DELIMITER ;