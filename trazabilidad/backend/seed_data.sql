-- =============================================================================
-- SEED DATA COMPLEMENTARIO - Sistema de Trazabilidad
-- Solo pobla tablas que tienen 0 registros, usando IDs reales de la BD
-- Tenants existentes: 1=iStore Bolivia, 2=TechImport SCZ, 3=Andina Digital
--                     4=ElectroSur Trading, 5=Cochabamba Wireless
-- Usuarios existentes: 1=admin@trazabilidad.com (SuperAdmin, todos los tenants)
-- Unidades existentes: 1-395 (ya pobladas)
-- Compras existentes:  1-5 (recibidas_total)
-- =============================================================================

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. VENTAS (tabla vacia)
-- idcliente = idactor de tipo TIENDA de cada tenant
-- ─────────────────────────────────────────────────────────────────────────────
INSERT INTO venta (idventa, idtenant, idcliente, fechaventa, total, estado)
SELECT v.id, v.tenant, v.cliente, v.fecha::timestamp, v.total, v.estado
FROM (VALUES
  (1, 1,  4, '2025-10-01 10:30:00', 2799.00, 'completada'),
  (2, 1,  4, '2025-10-02 14:15:00', 1399.00, 'completada'),
  (3, 1,  5, '2025-10-03 09:00:00', 5198.00, 'completada'),
  (4, 2,  8, '2025-10-04 11:00:00', 2798.00, 'completada'),
  (5, 2,  8, '2025-10-05 16:30:00', 1299.00, 'completada'),
  (6, 3, 12, '2025-10-06 13:00:00', 3497.00, 'completada'),
  (7, 4, 16, '2025-10-07 10:00:00', 2599.00, 'completada'),
  (8, 5, 20, '2025-10-08 15:00:00', 1999.00, 'completada'),
  (9, 1,  4, '2025-10-09 12:00:00', 4997.00, 'completada'),
  (10,3, 12, '2025-10-10 11:30:00', 3198.00, 'completada')
) AS v(id, tenant, cliente, fecha, total, estado)
WHERE NOT EXISTS (SELECT 1 FROM venta x WHERE x.idventa = v.id);

SELECT setval('venta_idventa_seq', (SELECT MAX(idventa) FROM venta));

-- ─────────────────────────────────────────────────────────────────────────────
-- 2. VENTA DETALLE
-- Variantes existentes: 1-18 (iPhones y accesorios)
-- ─────────────────────────────────────────────────────────────────────────────
INSERT INTO ventadetalle (idventadetalle, idventa, idvariante, cantidad, preciounitario, subtotal)
SELECT v.id, v.venta, v.variante, v.cant, v.precio, v.sub
FROM (VALUES
  (1,  1,  1, 1, 1799.00, 1799.00),
  (2,  1, 17, 2,  500.00, 1000.00),
  (3,  2,  2, 1, 1399.00, 1399.00),
  (4,  3,  3, 2, 1499.00, 2998.00),
  (5,  3, 18, 2,  100.00,  200.00),
  (6,  4,  4, 1,  999.00,  999.00),
  (7,  4,  5, 1,  999.00,  999.00),
  (8,  4, 17, 2,  400.00,  800.00),
  (9,  5,  7, 1, 1299.00, 1299.00),
  (10, 6,  9, 1, 1499.00, 1499.00),
  (11, 6, 10, 1,  999.00,  999.00),
  (12, 6, 18, 1,   99.00,   99.00),
  (13, 7,  1, 1, 1799.00, 1799.00),
  (14, 7, 18, 1,  100.00,  100.00),
  (15, 7, 17, 1,  700.00,  700.00),
  (16, 8, 11, 1, 1999.00, 1999.00),
  (17, 9,  1, 2, 1799.00, 3598.00),
  (18, 9, 17, 3,  466.00, 1399.00),
  (19,10,  8, 1, 1699.00, 1699.00),
  (20,10, 16, 1,  999.00,  999.00),
  (21,10, 18, 5,  100.00,  500.00)
) AS v(id, venta, variante, cant, precio, sub)
WHERE NOT EXISTS (SELECT 1 FROM ventadetalle x WHERE x.idventadetalle = v.id);

SELECT setval('ventadetalle_idventadetalle_seq', (SELECT MAX(idventadetalle) FROM ventadetalle));

-- ─────────────────────────────────────────────────────────────────────────────
-- 3. VENTA UNIDAD (vincula unidades fisicas a ventas)
-- Unidades vendidas (estado='vendido') estan en idunidad 1-395
-- Usamos unidades de cada tenant correspondiente
-- ─────────────────────────────────────────────────────────────────────────────
INSERT INTO ventaunidad (idventaunidad, idventadetalle, idunidad)
SELECT v.id, v.det, v.unidad
FROM (VALUES
  (1,  1,   1), (2,  2,   2), (3,  2,   3),
  (4,  3,   4), (5,  4,   5), (6,  4,   6),
  (7,  5,   7), (8,  5,   8), (9,  6,  79),
  (10, 7,  80), (11, 8,  81), (12, 8,  82),
  (13, 9,  83), (14,10, 159), (15,11, 160),
  (16,12, 161), (17,13, 238), (18,14, 239),
  (19,15, 240), (20,16, 317), (21,17,   9),
  (22,17,  10), (23,18,  11), (24,18,  12),
  (25,18,  13), (26,19, 162), (27,20, 163),
  (28,21, 164), (29,21, 165), (30,21, 166)
) AS v(id, det, unidad)
WHERE NOT EXISTS (SELECT 1 FROM ventaunidad x WHERE x.idventaunidad = v.id);

SELECT setval('ventaunidad_idventaunidad_seq', (SELECT MAX(idventaunidad) FROM ventaunidad));

-- ─────────────────────────────────────────────────────────────────────────────
-- 4. PAGOS
-- ─────────────────────────────────────────────────────────────────────────────
INSERT INTO pago (idpago, idventa, metodopago, monto, fechapago, estado)
SELECT v.id, v.venta, v.metodo, v.monto, v.fecha::timestamp, v.estado
FROM (VALUES
  (1,  1,  'tarjeta_credito', 2799.00, '2025-10-01 10:35:00', 'completado'),
  (2,  2,  'efectivo',        1399.00, '2025-10-02 14:20:00', 'completado'),
  (3,  3,  'transferencia',   5198.00, '2025-10-03 09:05:00', 'completado'),
  (4,  4,  'tarjeta_debito',  2798.00, '2025-10-04 11:05:00', 'completado'),
  (5,  5,  'efectivo',        1299.00, '2025-10-05 16:35:00', 'completado'),
  (6,  6,  'tarjeta_credito', 3497.00, '2025-10-06 13:05:00', 'completado'),
  (7,  7,  'transferencia',   2599.00, '2025-10-07 10:05:00', 'completado'),
  (8,  8,  'efectivo',        1999.00, '2025-10-08 15:05:00', 'completado'),
  (9,  9,  'tarjeta_credito', 4997.00, '2025-10-09 12:05:00', 'completado'),
  (10,10,  'qr_codigo',       3198.00, '2025-10-10 11:35:00', 'completado')
) AS v(id, venta, metodo, monto, fecha, estado)
WHERE NOT EXISTS (SELECT 1 FROM pago x WHERE x.idpago = v.id);

SELECT setval('pago_idpago_seq', (SELECT MAX(idpago) FROM pago));

-- ─────────────────────────────────────────────────────────────────────────────
-- 5. ALERTAS
-- ─────────────────────────────────────────────────────────────────────────────
INSERT INTO alerta (idalerta, idtenant, idunidad, idevento, tipoalerta, descripcion, gravedad, fechadeteccion, estado)
SELECT v.id, v.tenant, v.unidad, v.evento, v.tipo, v.desc, v.grav, v.fecha::timestamp, v.estado
FROM (VALUES
  (1, 1,  14, 1, 'temperatura',          'Temperatura fuera de rango durante transporte maritimo: 38C (max 30C)', 'alta',    '2025-09-15 08:30:00', 'resuelta'),
  (2, 1,  22, 2, 'vibracion',            'Nivel de vibracion elevado detectado en unidad durante carga', 'media',   '2025-09-20 14:00:00', 'resuelta'),
  (3, 2,  89, 3, 'retraso_aduanero',     'Paquete retenido en aduana mas de 72h por documentacion incompleta', 'alta',    '2025-09-25 09:00:00', 'en_proceso'),
  (4, 3, 167, 4, 'fraude_autenticidad',  'QR escaneo detectado en ubicacion incoherente con ruta logistica', 'critica', '2025-09-28 16:45:00', 'en_proceso'),
  (5, 1, NULL, 5,'inconsistencia_cadena','Discrepancia entre stock sistema y conteo fisico en almacen principal', 'alta',   '2025-10-01 10:00:00', 'pendiente')
) AS v(id, tenant, unidad, evento, tipo, desc, grav, fecha, estado)
WHERE NOT EXISTS (SELECT 1 FROM alerta x WHERE x.idalerta = v.id);

SELECT setval('alerta_idalerta_seq', (SELECT MAX(idalerta) FROM alerta));

-- ─────────────────────────────────────────────────────────────────────────────
-- 6. GARANTIAS DE UNIDAD
-- ─────────────────────────────────────────────────────────────────────────────
INSERT INTO garantiaunidad (idgarantia, idunidad, fechainicio, fechafin, proveedor, condiciones)
SELECT v.id, v.unidad, v.inicio::date, v.fin::date, v.prov, v.cond
FROM (VALUES
  (1,   1, '2025-09-20', '2026-09-20', 'Apple Inc.',     'Garantia oficial Apple 1 anio. Cubre defectos de fabricacion. Excluye danos fisicos y liquidos.'),
  (2,   2, '2025-09-20', '2026-09-20', 'Apple Inc.',     'Garantia oficial Apple 1 anio. Cubre defectos de fabricacion. Excluye danos fisicos y liquidos.'),
  (3,   3, '2025-09-20', '2026-09-20', 'Apple Inc.',     'Garantia oficial Apple 1 anio. Cubre defectos de fabricacion. Excluye danos fisicos y liquidos.'),
  (4,   5, '2025-09-21', '2026-09-21', 'Apple Inc.',     'Garantia oficial Apple 1 anio. Cubre defectos de fabricacion. Excluye danos fisicos y liquidos.'),
  (5,   6, '2025-09-21', '2026-09-21', 'Apple Inc.',     'Garantia oficial Apple 1 anio. Cubre defectos de fabricacion. Excluye danos fisicos y liquidos.'),
  (6,  10, '2025-09-22', '2026-09-22', 'Apple Inc.',     'Garantia oficial Apple 1 anio. Cubre defectos de fabricacion. Excluye danos fisicos y liquidos.'),
  (7,  15, '2025-09-22', '2026-09-22', 'Apple Inc.',     'Garantia oficial Apple 1 anio. Cubre defectos de fabricacion. Excluye danos fisicos y liquidos.'),
  (8,  79, '2025-09-25', '2026-09-25', 'Apple Inc.',     'Garantia oficial Apple 1 anio. Cubre defectos de fabricacion. Excluye danos fisicos y liquidos.'),
  (9,  80, '2025-09-25', '2026-09-25', 'Apple Inc.',     'Garantia oficial Apple 1 anio. Cubre defectos de fabricacion. Excluye danos fisicos y liquidos.'),
  (10,159, '2025-09-27', '2026-09-27', 'Apple Inc.',     'Garantia oficial Apple 1 anio. Cubre defectos de fabricacion. Excluye danos fisicos y liquidos.'),
  (11,238, '2025-09-28', '2026-09-28', 'Apple Inc.',     'Garantia oficial Apple 1 anio. Cubre defectos de fabricacion. Excluye danos fisicos y liquidos.'),
  (12,317, '2025-09-30', '2026-09-30', 'Apple Inc.',     'Garantia oficial Apple 1 anio. Cubre defectos de fabricacion. Excluye danos fisicos y liquidos.')
) AS v(id, unidad, inicio, fin, prov, cond)
WHERE NOT EXISTS (SELECT 1 FROM garantiaunidad x WHERE x.idgarantia = v.id);

SELECT setval('garantiaunidad_idgarantia_seq', (SELECT MAX(idgarantia) FROM garantiaunidad));

-- ─────────────────────────────────────────────────────────────────────────────
-- 7. DOCUMENTOS DE UNIDAD
-- ─────────────────────────────────────────────────────────────────────────────
INSERT INTO documentounidad (iddocumento, idunidad, nombre, urlarchivo, hasharchivo, fechaemision, fechavencimiento, tipodocumento)
SELECT v.id, v.unidad, v.nombre, v.url, v.hash, v.emision::date, v.venc::date, v.tipo::tipo_documento_enum
FROM (VALUES
  (1,  1,  'Factura Compra iPhone 16 Pro Max 001', 'https://docs.trazabilidad.bo/facturas/FC-2025-001.pdf', 'a1b2c3d4e5f6789012345678901234567890abcd', '2025-09-20', '2030-09-20', 'factura_compra'),
  (2,  2,  'Factura Compra iPhone 16 Pro Max 002', 'https://docs.trazabilidad.bo/facturas/FC-2025-002.pdf', 'b2c3d4e5f67890123456789012345678901abcde', '2025-09-20', '2030-09-20', 'factura_compra'),
  (3,  1,  'Certificado Autenticidad Apple 001',   'https://docs.trazabilidad.bo/certs/CA-2025-001.pdf',   'c3d4e5f678901234567890123456789012abcdef', '2025-09-15', NULL,          'certificado_autenticidad'),
  (4,  5,  'Certificado Autenticidad Apple 005',   'https://docs.trazabilidad.bo/certs/CA-2025-005.pdf',   'd4e5f6789012345678901234567890123abcdef0', '2025-09-15', NULL,          'certificado_autenticidad'),
  (5, 79,  'Factura Compra TechImport SCZ 079',    'https://docs.trazabilidad.bo/facturas/FC-2025-079.pdf', 'e5f67890123456789012345678901234abcdef01', '2025-09-25', '2030-09-25', 'factura_compra'),
  (6, 159, 'Factura Compra Andina Digital 159',    'https://docs.trazabilidad.bo/facturas/FC-2025-159.pdf', 'f6789012345678901234567890123456abcdef012','2025-09-27', '2030-09-27', 'factura_compra'),
  (7, 238, 'Factura Compra ElectroSur 238',        'https://docs.trazabilidad.bo/facturas/FC-2025-238.pdf', '7890123456789012345678901234567abcdef0123','2025-09-28', '2030-09-28', 'factura_compra'),
  (8, 317, 'Factura Compra Cochabamba Wireless 317','https://docs.trazabilidad.bo/facturas/FC-2025-317.pdf','890123456789012345678901234567890abcdef01','2025-09-30', '2030-09-30', 'factura_compra')
) AS v(id, unidad, nombre, url, hash, emision, venc, tipo)
WHERE NOT EXISTS (SELECT 1 FROM documentounidad x WHERE x.iddocumento = v.id);

SELECT setval('documentounidad_iddocumento_seq', (SELECT MAX(iddocumento) FROM documentounidad));

-- ─────────────────────────────────────────────────────────────────────────────
-- 8. NOTIFICACIONES
-- ─────────────────────────────────────────────────────────────────────────────
INSERT INTO notificacion (idnotificacion, idusuariotenant, titulo, contenido, leida, fechaenvio, enlaceaccion)
SELECT v.id, v.ut, v.titulo, v.contenido, v.leida, v.fecha::timestamp, v.enlace
FROM (VALUES
  (1,  1, 'Nuevo envio registrado',          'Se ha registrado el envio ENV-2026-001 con 79 unidades desde Apple Distribution Hub.', false, '2025-10-01 08:00:00', '/envios/1'),
  (2,  1, 'Recepcion completada',            'La recepcion OC-2026-SCZ-01 fue completada. 79 unidades ingresadas al almacen.', false, '2025-10-02 09:30:00', '/recepciones/1'),
  (3,  1, 'Alerta de temperatura detectada','Se detecto temperatura fuera de rango en unidad SN-001 durante transporte.', true,  '2025-09-15 08:35:00', '/alertas/1'),
  (4,  2, 'Nuevo envio registrado',          'Se ha registrado el envio ENV-2026-002 con 79 unidades desde Apple Distribution Hub.', false, '2025-10-01 08:01:00', '/envios/2'),
  (5,  2, 'Venta completada',               'Se registro una venta por $2798.00 en iStore Ventura Mall Tenant 2.', true,  '2025-10-04 11:10:00', '/ventas/4'),
  (6,  3, 'Nuevo envio registrado',          'Se ha registrado el envio ENV-2026-003 con 79 unidades.', false, '2025-10-01 08:02:00', '/envios/3'),
  (7,  3, 'Alerta de retraso aduanero',     'Paquete retenido en aduana mas de 72 horas. Revise documentacion.', false, '2025-09-25 09:05:00', '/alertas/3'),
  (8,  4, 'Nuevo envio registrado',          'Se ha registrado el envio ENV-2026-004 con 79 unidades.', false, '2025-10-01 08:03:00', '/envios/4'),
  (9,  5, 'Nuevo envio registrado',          'Se ha registrado el envio ENV-2026-005 con 79 unidades.', false, '2025-10-01 08:04:00', '/envios/5'),
  (10, 1, 'Backup programado completado',   'La copia de seguridad automatica del tenant iStore Bolivia fue generada exitosamente.', true, '2025-10-05 02:00:00', '/backup'),
  (11, 1, 'Stock bajo en catalogo',         '5 productos en el catalogo tienen stock inferior al minimo configurado.', false, '2025-10-06 07:00:00', '/catalogo'),
  (12, 2, 'Venta completada',               'Se registro una venta por $1299.00 en iStore Ventura Mall.', true, '2025-10-05 16:40:00', '/ventas/5')
) AS v(id, ut, titulo, contenido, leida, fecha, enlace)
WHERE NOT EXISTS (SELECT 1 FROM notificacion x WHERE x.idnotificacion = v.id);

SELECT setval('notificacion_idnotificacion_seq', (SELECT MAX(idnotificacion) FROM notificacion));

-- ─────────────────────────────────────────────────────────────────────────────
-- 9. REGISTRO BLOCKCHAIN
-- ─────────────────────────────────────────────────────────────────────────────
INSERT INTO registroblockchain (idregistro, idevento, payloadhash, txhash, blocknumber, network, chainid, contractaddress, fechaenvio, fechaconfirmacion, estado, numeroconfirmaciones)
SELECT v.id, v.evento, v.phash, v.txhash, v.block, v.net, v.chain, v.contract, v.fenvio::timestamp, v.fconf::timestamp, v.estado, v.confs
FROM (VALUES
  (1, 1, 'a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2', '0x7d8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f', 21547823, 'Polygon Mumbai', '80001', '0xTRAZABILIDAD2025CONTRATO001', '2025-09-20 08:05:00', '2025-09-20 08:07:30', 'confirmado', 12),
  (2, 2, 'b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3', '0x8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f', 21547901, 'Polygon Mumbai', '80001', '0xTRAZABILIDAD2025CONTRATO001', '2025-09-21 09:10:00', '2025-09-21 09:12:45', 'confirmado', 12),
  (3, 3, 'c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4', '0x9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a', 21548010, 'Polygon Mumbai', '80001', '0xTRAZABILIDAD2025CONTRATO001', '2025-09-25 10:15:00', '2025-09-25 10:17:20', 'confirmado', 12),
  (4, 4, 'd4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5', '0xa0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1', 21548150, 'Polygon Mumbai', '80001', '0xTRAZABILIDAD2025CONTRATO001', '2025-09-27 11:20:00', '2025-09-27 11:22:55', 'confirmado', 8),
  (5, 5, 'e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4e5f6', NULL, NULL, 'Polygon Mumbai', '80001', '0xTRAZABILIDAD2025CONTRATO001', '2025-10-01 10:05:00', NULL, 'pendiente', 0)
) AS v(id, evento, phash, txhash, block, net, chain, contract, fenvio, fconf, estado, confs)
WHERE NOT EXISTS (SELECT 1 FROM registroblockchain x WHERE x.idregistro = v.id);

SELECT setval('registroblockchain_idregistro_seq', (SELECT MAX(idregistro) FROM registroblockchain));

-- ─────────────────────────────────────────────────────────────────────────────
-- 10. CONSULTAS DE TRAZABILIDAD (escaneos QR)
-- QR existentes: la tabla codigoqr tiene 395 registros (uno por unidad)
-- ─────────────────────────────────────────────────────────────────────────────
INSERT INTO consultatrazabilidad (idconsulta, idcodigoqr, fechahora, ip, paisaproximado, useragent)
SELECT v.id, v.qr, v.fecha::timestamp, v.ip, v.pais, v.ua
FROM (VALUES
  (1,   1, '2025-10-01 14:30:00', '190.129.45.22',  'Bolivia',  'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0) AppleWebKit/605.1.15'),
  (2,   1, '2025-10-01 15:45:00', '201.244.12.88',  'Bolivia',  'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36'),
  (3,   2, '2025-10-02 09:10:00', '190.129.45.23',  'Bolivia',  'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0) AppleWebKit/605.1.15'),
  (4,   5, '2025-10-02 11:30:00', '181.118.22.45',  'Bolivia',  'Mozilla/5.0 (Windows NT 10.0; Win64) AppleWebKit/537.36'),
  (5,   8, '2025-10-03 08:00:00', '200.105.67.11',  'Argentina','Mozilla/5.0 (iPhone; CPU iPhone OS 16_6) AppleWebKit/605.1.15'),
  (6,  10, '2025-10-03 10:20:00', '190.129.33.90',  'Bolivia',  'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36'),
  (7,  15, '2025-10-04 14:00:00', '181.118.50.77',  'Bolivia',  'Mozilla/5.0 (iPhone; CPU iPhone OS 17_1) AppleWebKit/605.1.15'),
  (8,  22, '2025-10-04 16:30:00', '190.131.11.44',  'Bolivia',  'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36'),
  (9,  79, '2025-10-05 09:45:00', '186.101.34.55',  'Ecuador',  'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0) AppleWebKit/605.1.15'),
  (10, 80, '2025-10-05 11:00:00', '190.129.45.99',  'Bolivia',  'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36'),
  (11,159, '2025-10-06 08:30:00', '201.244.33.11',  'Bolivia',  'Mozilla/5.0 (Android 13) AppleWebKit/537.36'),
  (12,238, '2025-10-07 12:00:00', '190.130.22.88',  'Bolivia',  'Mozilla/5.0 (iPhone; CPU iPhone OS 17_2) AppleWebKit/605.1.15'),
  (13,317, '2025-10-08 15:30:00', '181.119.44.22',  'Bolivia',  'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36'),
  (14,395, '2025-10-09 10:15:00', '190.129.55.66',  'Bolivia',  'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0) AppleWebKit/605.1.15'),
  (15,  1, '2025-10-10 13:45:00', '200.44.88.11',   'Peru',     'Mozilla/5.0 (Windows NT 10.0; Win64) AppleWebKit/537.36')
) AS v(id, qr, fecha, ip, pais, ua)
WHERE NOT EXISTS (SELECT 1 FROM consultatrazabilidad x WHERE x.idconsulta = v.id);

SELECT setval('consultatrazabilidad_idconsulta_seq', (SELECT MAX(idconsulta) FROM consultatrazabilidad));

-- ─────────────────────────────────────────────────────────────────────────────
-- 11. DEVOLUCIONES
-- ─────────────────────────────────────────────────────────────────────────────
INSERT INTO devolucion (iddevolucion, idventa, fechadevolucion, motivo, descripcion, estado)
SELECT v.id, v.venta, v.fecha::timestamp, v.motivo, v.desc, v.estado
FROM (VALUES
  (1, 2, '2025-10-05 10:00:00', 'defecto_fabricacion', 'Pantalla con pixel muerto detectado al momento de la compra. Cliente solicita cambio inmediato.', 'aprobada'),
  (2, 5, '2025-10-08 14:00:00', 'insatisfaccion',      'Cliente prefiere modelo con mayor capacidad de almacenamiento.', 'pendiente')
) AS v(id, venta, fecha, motivo, desc, estado)
WHERE NOT EXISTS (SELECT 1 FROM devolucion x WHERE x.iddevolucion = v.id);

SELECT setval('devolucion_iddevolucion_seq', (SELECT MAX(iddevolucion) FROM devolucion));

-- ─────────────────────────────────────────────────────────────────────────────
-- 12. DEVOLUCION UNIDADES
-- ─────────────────────────────────────────────────────────────────────────────
INSERT INTO devolucionunidad (iddevolucionunidad, iddevolucion, idunidad)
SELECT v.id, v.dev, v.unidad
FROM (VALUES
  (1, 1,  4),
  (2, 2, 83)
) AS v(id, dev, unidad)
WHERE NOT EXISTS (SELECT 1 FROM devolucionunidad x WHERE x.iddevolucionunidad = v.id);

SELECT setval('devolucionunidad_iddevolucionunidad_seq', (SELECT MAX(iddevolucionunidad) FROM devolucionunidad));

-- ─────────────────────────────────────────────────────────────────────────────
-- VERIFICACION FINAL - Estado completo de todas las tablas
-- ─────────────────────────────────────────────────────────────────────────────
SELECT tabla, registros FROM (
SELECT 'actorcadena'           AS tabla, COUNT(*) AS registros FROM actorcadena            UNION ALL
SELECT 'alerta',                          COUNT(*) FROM alerta                             UNION ALL
SELECT 'bitacora',                        COUNT(*) FROM bitacora                           UNION ALL
SELECT 'catalogotenant',                  COUNT(*) FROM catalogotenant                     UNION ALL
SELECT 'categoria',                       COUNT(*) FROM categoria                          UNION ALL
SELECT 'certificacion',                   COUNT(*) FROM certificacion                      UNION ALL
SELECT 'codigoqr',                        COUNT(*) FROM codigoqr                           UNION ALL
SELECT 'compra',                          COUNT(*) FROM compra                             UNION ALL
SELECT 'compradetalle',                   COUNT(*) FROM compradetalle                      UNION ALL
SELECT 'condiciontransporte',             COUNT(*) FROM condiciontransporte                UNION ALL
SELECT 'consultatrazabilidad',            COUNT(*) FROM consultatrazabilidad               UNION ALL
SELECT 'devolucion',                      COUNT(*) FROM devolucion                         UNION ALL
SELECT 'devolucionunidad',                COUNT(*) FROM devolucionunidad                   UNION ALL
SELECT 'documentounidad',                 COUNT(*) FROM documentounidad                    UNION ALL
SELECT 'envio',                           COUNT(*) FROM envio                              UNION ALL
SELECT 'enviounidad',                     COUNT(*) FROM enviounidad                        UNION ALL
SELECT 'eventotrazabilidad',              COUNT(*) FROM eventotrazabilidad                 UNION ALL
SELECT 'eventounidad',                    COUNT(*) FROM eventounidad                       UNION ALL
SELECT 'garantiaunidad',                  COUNT(*) FROM garantiaunidad                     UNION ALL
SELECT 'notificacion',                    COUNT(*) FROM notificacion                       UNION ALL
SELECT 'pago',                            COUNT(*) FROM pago                               UNION ALL
SELECT 'permiso',                         COUNT(*) FROM permiso                            UNION ALL
SELECT 'producto',                        COUNT(*) FROM producto                           UNION ALL
SELECT 'productocertificacion',           COUNT(*) FROM productocertificacion              UNION ALL
SELECT 'recepcioncompra',                 COUNT(*) FROM recepcioncompra                    UNION ALL
SELECT 'recepciondetalle',                COUNT(*) FROM recepciondetalle                   UNION ALL
SELECT 'registroblockchain',              COUNT(*) FROM registroblockchain                 UNION ALL
SELECT 'rol',                             COUNT(*) FROM rol                                UNION ALL
SELECT 'rolpermiso',                      COUNT(*) FROM rolpermiso                         UNION ALL
SELECT 'tenant',                          COUNT(*) FROM tenant                             UNION ALL
SELECT 'ubicacion',                       COUNT(*) FROM ubicacion                          UNION ALL
SELECT 'unidadproducto',                  COUNT(*) FROM unidadproducto                     UNION ALL
SELECT 'usuario',                         COUNT(*) FROM usuario                            UNION ALL
SELECT 'usuariotenant',                   COUNT(*) FROM usuariotenant                      UNION ALL
SELECT 'usuariotenantrol',                COUNT(*) FROM usuariotenantrol                   UNION ALL
SELECT 'varianteproducto',                COUNT(*) FROM varianteproducto                   UNION ALL
SELECT 'venta',                           COUNT(*) FROM venta                              UNION ALL
SELECT 'ventadetalle',                    COUNT(*) FROM ventadetalle                       UNION ALL
SELECT 'ventaunidad',                     COUNT(*) FROM ventaunidad
) t ORDER BY tabla;
