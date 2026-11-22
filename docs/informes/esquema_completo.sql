--
-- PostgreSQL database dump
--

\restrict ZhLgJEzWwnhRQkldliUqZiRTAfGrxBYUTBXh0iLUjWd2DSmnhgJE3kqRJiHoJZf

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: estado_alerta_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.estado_alerta_enum AS ENUM (
    'pendiente',
    'en_proceso',
    'resuelta'
);


--
-- Name: estado_compra_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.estado_compra_enum AS ENUM (
    'pendiente',
    'enviada',
    'recibida_parcial',
    'recibida_total',
    'cancelada'
);


--
-- Name: estado_confirmacion_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.estado_confirmacion_enum AS ENUM (
    'pendiente',
    'confirmado',
    'rechazado'
);


--
-- Name: estado_devolucion_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.estado_devolucion_enum AS ENUM (
    'solicitada',
    'aprobada',
    'rechazada',
    'procesada'
);


--
-- Name: estado_envio_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.estado_envio_enum AS ENUM (
    'preparacion',
    'en_transito',
    'entregado',
    'retrasado',
    'cancelado'
);


--
-- Name: estado_pago_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.estado_pago_enum AS ENUM (
    'pendiente',
    'completado',
    'rechazado',
    'reembolsado'
);


--
-- Name: estado_recepcion_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.estado_recepcion_enum AS ENUM (
    'pendiente',
    'parcial',
    'completa',
    'rechazada'
);


--
-- Name: estado_reporte_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.estado_reporte_enum AS ENUM (
    'pendiente',
    'en_revision',
    'resuelta',
    'rechazada'
);


--
-- Name: estado_suscripcion_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.estado_suscripcion_enum AS ENUM (
    'trial',
    'activa',
    'vencida',
    'suspendida',
    'cancelada'
);


--
-- Name: estado_unidad_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.estado_unidad_enum AS ENUM (
    'disponible',
    'vendido',
    'en_transito',
    'devuelto',
    'retirado'
);


--
-- Name: estado_venta_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.estado_venta_enum AS ENUM (
    'pendiente',
    'pagada',
    'enviada',
    'entregada',
    'cancelada',
    'devuelta'
);


--
-- Name: estado_verificacion_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.estado_verificacion_enum AS ENUM (
    'pendiente',
    'verificado',
    'fallido'
);


--
-- Name: gravedad_alerta_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.gravedad_alerta_enum AS ENUM (
    'baja',
    'media',
    'alta',
    'critica'
);


--
-- Name: gravedad_reporte_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.gravedad_reporte_enum AS ENUM (
    'baja',
    'media',
    'alta',
    'critica'
);


--
-- Name: metodo_pago_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.metodo_pago_enum AS ENUM (
    'efectivo',
    'tarjeta_credito',
    'tarjeta_debito',
    'transferencia',
    'criptomoneda'
);


--
-- Name: motivo_devolucion_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.motivo_devolucion_enum AS ENUM (
    'defecto_fabrica',
    'daño_transporte',
    'producto_incorrecto',
    'insatisfaccion_cliente',
    'garantia'
);


--
-- Name: tipo_actor_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.tipo_actor_enum AS ENUM (
    'PROVEEDOR_EEUU',
    'TRANSPORTISTA_INTERNACIONAL',
    'ADUANA',
    'IMPORTADOR',
    'DISTRIBUIDOR',
    'TIENDA',
    'CONSUMIDOR'
);


--
-- Name: tipo_alerta_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.tipo_alerta_enum AS ENUM (
    'temperatura',
    'humedad',
    'vibracion',
    'retraso_aduanero',
    'vencimiento_garantia',
    'fraude_autenticidad',
    'inconsistencia_cadena'
);


--
-- Name: tipo_anomalia_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.tipo_anomalia_enum AS ENUM (
    'fraude_autenticidad',
    'empaque_vulnerado',
    'discrepancia_serial'
);


--
-- Name: tipo_documento_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.tipo_documento_enum AS ENUM (
    'factura_compra',
    'certificado_importacion',
    'comprobante_garantia',
    'certificado_autenticidad',
    'informe_tecnico'
);


--
-- Name: tipo_evento_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.tipo_evento_enum AS ENUM (
    'fabricacion',
    'control_calidad_apple',
    'exportacion',
    'transporte_maritimo',
    'transporte_aereo',
    'llegada_puerto',
    'despacho_aduanero',
    'transporte_terrestre',
    'recepcion_almacen',
    'venta',
    'devolucion',
    'retiro'
);


--
-- Name: tipo_ubicacion_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.tipo_ubicacion_enum AS ENUM (
    'origen',
    'almacen',
    'centro_distribucion',
    'punto_venta',
    'puerto',
    'aduana'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: actorcadena; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.actorcadena (
    idactor integer NOT NULL,
    idtenant integer NOT NULL,
    nombre character varying(100) NOT NULL,
    razonsocial character varying(100),
    nit character varying(50),
    email character varying(100),
    telefono character varying(50),
    tipoactor public.tipo_actor_enum NOT NULL
);


--
-- Name: actorcadena_idactor_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.actorcadena_idactor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: actorcadena_idactor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.actorcadena_idactor_seq OWNED BY public.actorcadena.idactor;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


--
-- Name: alerta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alerta (
    idalerta integer NOT NULL,
    idtenant integer NOT NULL,
    idunidad integer,
    idevento integer,
    tipoalerta public.tipo_alerta_enum NOT NULL,
    descripcion text NOT NULL,
    gravedad public.gravedad_alerta_enum NOT NULL,
    fechadeteccion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fecharesolucion timestamp without time zone,
    estado public.estado_alerta_enum DEFAULT 'pendiente'::public.estado_alerta_enum,
    idusuarioresolutor integer
);


--
-- Name: TABLE alerta; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.alerta IS 'Alertas automáticas ante condiciones anómalas';


--
-- Name: COLUMN alerta.idtenant; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.alerta.idtenant IS 'Empresa que recibe la alerta';


--
-- Name: COLUMN alerta.idunidad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.alerta.idunidad IS 'Unidad afectada (opcional)';


--
-- Name: COLUMN alerta.idevento; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.alerta.idevento IS 'Evento que originó la alerta';


--
-- Name: COLUMN alerta.tipoalerta; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.alerta.tipoalerta IS 'Tipo de alerta (temperatura, humedad, vibracion, retraso_aduanero, etc.)';


--
-- Name: COLUMN alerta.gravedad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.alerta.gravedad IS 'Gravedad (baja, media, alta, critica)';


--
-- Name: COLUMN alerta.fechadeteccion; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.alerta.fechadeteccion IS 'Momento de detección';


--
-- Name: COLUMN alerta.fecharesolucion; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.alerta.fecharesolucion IS 'Momento de resolución (si aplica)';


--
-- Name: COLUMN alerta.estado; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.alerta.estado IS 'Estado (pendiente, en_proceso, resuelta)';


--
-- Name: alerta_idalerta_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.alerta_idalerta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: alerta_idalerta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.alerta_idalerta_seq OWNED BY public.alerta.idalerta;


--
-- Name: bitacora; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bitacora (
    idbitacora integer NOT NULL,
    idusuariotenant integer NOT NULL,
    accion character varying(50) NOT NULL,
    entidad character varying(50) NOT NULL,
    identidad integer,
    ip character varying(45),
    fechahora timestamp without time zone NOT NULL
);


--
-- Name: bitacora_idbitacora_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bitacora_idbitacora_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bitacora_idbitacora_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bitacora_idbitacora_seq OWNED BY public.bitacora.idbitacora;


--
-- Name: catalogotenant; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.catalogotenant (
    idcatalogotenant integer NOT NULL,
    idtenant integer NOT NULL,
    idvariante integer NOT NULL,
    skuinterno character varying(50),
    precioventa numeric(10,2) NOT NULL,
    costopromedio numeric(10,2),
    activo boolean NOT NULL
);


--
-- Name: catalogotenant_idcatalogotenant_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.catalogotenant_idcatalogotenant_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: catalogotenant_idcatalogotenant_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.catalogotenant_idcatalogotenant_seq OWNED BY public.catalogotenant.idcatalogotenant;


--
-- Name: categoria; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categoria (
    idcategoria integer NOT NULL,
    nombrecategoria character varying(100) NOT NULL,
    descripcion text
);


--
-- Name: categoria_idcategoria_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categoria_idcategoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categoria_idcategoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categoria_idcategoria_seq OWNED BY public.categoria.idcategoria;


--
-- Name: certificacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.certificacion (
    idcertificacion integer NOT NULL,
    nombre character varying(100) NOT NULL,
    entidademisora character varying(100),
    descripcion text,
    logourl character varying(255)
);


--
-- Name: certificacion_idcertificacion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.certificacion_idcertificacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: certificacion_idcertificacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.certificacion_idcertificacion_seq OWNED BY public.certificacion.idcertificacion;


--
-- Name: codigoqr; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.codigoqr (
    idcodigoqr integer NOT NULL,
    idunidad integer NOT NULL,
    tokenpublico character varying(100) NOT NULL,
    url character varying(255),
    fechageneracion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    activo boolean DEFAULT true
);


--
-- Name: TABLE codigoqr; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.codigoqr IS 'Código QR único por unidad';


--
-- Name: COLUMN codigoqr.idunidad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.codigoqr.idunidad IS 'Unidad a la que pertenece el QR';


--
-- Name: COLUMN codigoqr.tokenpublico; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.codigoqr.tokenpublico IS 'Token público para acceder al historial';


--
-- Name: COLUMN codigoqr.url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.codigoqr.url IS 'URL completa para escanear';


--
-- Name: COLUMN codigoqr.fechageneracion; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.codigoqr.fechageneracion IS 'Fecha de generación del QR';


--
-- Name: COLUMN codigoqr.activo; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.codigoqr.activo IS 'Indica si el QR sigue activo';


--
-- Name: codigoqr_idcodigoqr_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.codigoqr_idcodigoqr_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: codigoqr_idcodigoqr_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.codigoqr_idcodigoqr_seq OWNED BY public.codigoqr.idcodigoqr;


--
-- Name: compra; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.compra (
    idcompra integer NOT NULL,
    idtenant integer NOT NULL,
    idproveedor integer NOT NULL,
    numeroorden character varying(50) NOT NULL,
    fechacompra date NOT NULL,
    totalusd numeric(10,2) NOT NULL,
    estado public.estado_compra_enum DEFAULT 'pendiente'::public.estado_compra_enum
);


--
-- Name: TABLE compra; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.compra IS 'Orden de compra internacional a proveedor en EE.UU.';


--
-- Name: COLUMN compra.idtenant; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.compra.idtenant IS 'Empresa que realiza la compra';


--
-- Name: COLUMN compra.idproveedor; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.compra.idproveedor IS 'Actor proveedor (PROVEEDOR_EEUU)';


--
-- Name: COLUMN compra.numeroorden; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.compra.numeroorden IS 'Número de orden de compra';


--
-- Name: COLUMN compra.fechacompra; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.compra.fechacompra IS 'Fecha de la orden';


--
-- Name: COLUMN compra.totalusd; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.compra.totalusd IS 'Monto total en USD';


--
-- Name: COLUMN compra.estado; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.compra.estado IS 'Estado de la compra (pendiente, enviada, recibida_parcial, recibida_total, cancelada)';


--
-- Name: compra_idcompra_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.compra_idcompra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: compra_idcompra_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.compra_idcompra_seq OWNED BY public.compra.idcompra;


--
-- Name: compradetalle; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.compradetalle (
    idcompradetalle integer NOT NULL,
    idcompra integer NOT NULL,
    idvariante integer NOT NULL,
    cantidad integer NOT NULL,
    costounitariousd numeric(10,2) NOT NULL,
    subtotalusd numeric(10,2) NOT NULL,
    CONSTRAINT compradetalle_cantidad_check CHECK ((cantidad > 0))
);


--
-- Name: TABLE compradetalle; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.compradetalle IS 'Detalle de los productos de una compra';


--
-- Name: COLUMN compradetalle.idcompra; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.compradetalle.idcompra IS 'Compra a la que pertenece';


--
-- Name: COLUMN compradetalle.idvariante; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.compradetalle.idvariante IS 'Variante del producto comprado';


--
-- Name: COLUMN compradetalle.cantidad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.compradetalle.cantidad IS 'Cantidad comprada';


--
-- Name: COLUMN compradetalle.costounitariousd; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.compradetalle.costounitariousd IS 'Costo unitario en USD';


--
-- Name: COLUMN compradetalle.subtotalusd; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.compradetalle.subtotalusd IS 'Subtotal en USD (cantidad * costoUnitario)';


--
-- Name: compradetalle_idcompradetalle_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.compradetalle_idcompradetalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: compradetalle_idcompradetalle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.compradetalle_idcompradetalle_seq OWNED BY public.compradetalle.idcompradetalle;


--
-- Name: condiciontransporte; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.condiciontransporte (
    idcondicion integer NOT NULL,
    idevento integer NOT NULL,
    temperatura numeric(5,2),
    humedad numeric(5,2),
    presion numeric(7,2),
    nivelvibracion numeric(5,2),
    timestampregistro timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    fuentedatos character varying(50)
);


--
-- Name: TABLE condiciontransporte; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.condiciontransporte IS 'Condiciones ambientales durante un evento de transporte';


--
-- Name: COLUMN condiciontransporte.idevento; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.condiciontransporte.idevento IS 'Evento de transporte asociado (1:1)';


--
-- Name: COLUMN condiciontransporte.temperatura; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.condiciontransporte.temperatura IS 'Temperatura en °C';


--
-- Name: COLUMN condiciontransporte.humedad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.condiciontransporte.humedad IS 'Humedad relativa (%)';


--
-- Name: COLUMN condiciontransporte.presion; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.condiciontransporte.presion IS 'Presión atmosférica';


--
-- Name: COLUMN condiciontransporte.nivelvibracion; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.condiciontransporte.nivelvibracion IS 'Nivel de vibración (protege componentes electrónicos)';


--
-- Name: COLUMN condiciontransporte.fuentedatos; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.condiciontransporte.fuentedatos IS 'Origen del dato (sensor_iot, manual)';


--
-- Name: condiciontransporte_idcondicion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.condiciontransporte_idcondicion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: condiciontransporte_idcondicion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.condiciontransporte_idcondicion_seq OWNED BY public.condiciontransporte.idcondicion;


--
-- Name: consultatrazabilidad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.consultatrazabilidad (
    idconsulta integer NOT NULL,
    idcodigoqr integer NOT NULL,
    fechahora timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    ip character varying(45),
    paisaproximado character varying(50),
    useragent text
);


--
-- Name: TABLE consultatrazabilidad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.consultatrazabilidad IS 'Registro de cada escaneo de un QR (1:N)';


--
-- Name: COLUMN consultatrazabilidad.idcodigoqr; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.consultatrazabilidad.idcodigoqr IS 'QR escaneado (relación 1:N, un QR se escanea muchas veces)';


--
-- Name: COLUMN consultatrazabilidad.fechahora; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.consultatrazabilidad.fechahora IS 'Momento del escaneo';


--
-- Name: COLUMN consultatrazabilidad.ip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.consultatrazabilidad.ip IS 'Dirección IP desde donde se escaneó';


--
-- Name: COLUMN consultatrazabilidad.paisaproximado; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.consultatrazabilidad.paisaproximado IS 'País aproximado (geolocalización por IP)';


--
-- Name: COLUMN consultatrazabilidad.useragent; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.consultatrazabilidad.useragent IS 'Navegador/dispositivo desde el que se escaneó';


--
-- Name: consultatrazabilidad_idconsulta_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.consultatrazabilidad_idconsulta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: consultatrazabilidad_idconsulta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.consultatrazabilidad_idconsulta_seq OWNED BY public.consultatrazabilidad.idconsulta;


--
-- Name: devolucion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.devolucion (
    iddevolucion integer NOT NULL,
    idventa integer NOT NULL,
    fechadevolucion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    motivo public.motivo_devolucion_enum NOT NULL,
    descripcion text,
    estado public.estado_devolucion_enum DEFAULT 'solicitada'::public.estado_devolucion_enum
);


--
-- Name: TABLE devolucion; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.devolucion IS 'Registro de devoluciones de productos (1:N con Venta)';


--
-- Name: COLUMN devolucion.idventa; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.devolucion.idventa IS 'Venta a la que pertenece la devolución';


--
-- Name: COLUMN devolucion.fechadevolucion; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.devolucion.fechadevolucion IS 'Fecha de la devolución';


--
-- Name: COLUMN devolucion.motivo; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.devolucion.motivo IS 'Motivo (defecto_fabrica, daño_transporte, producto_incorrecto, insatisfaccion_cliente, garantia)';


--
-- Name: COLUMN devolucion.descripcion; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.devolucion.descripcion IS 'Descripción adicional';


--
-- Name: COLUMN devolucion.estado; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.devolucion.estado IS 'Estado (solicitada, aprobada, rechazada, procesada)';


--
-- Name: devolucion_iddevolucion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.devolucion_iddevolucion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: devolucion_iddevolucion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.devolucion_iddevolucion_seq OWNED BY public.devolucion.iddevolucion;


--
-- Name: devolucionunidad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.devolucionunidad (
    iddevolucionunidad integer NOT NULL,
    iddevolucion integer NOT NULL,
    idunidad integer NOT NULL
);


--
-- Name: TABLE devolucionunidad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.devolucionunidad IS 'Relación N:M entre Devolucion y UnidadProducto';


--
-- Name: devolucionunidad_iddevolucionunidad_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.devolucionunidad_iddevolucionunidad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: devolucionunidad_iddevolucionunidad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.devolucionunidad_iddevolucionunidad_seq OWNED BY public.devolucionunidad.iddevolucionunidad;


--
-- Name: documentounidad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.documentounidad (
    iddocumento integer NOT NULL,
    idunidad integer NOT NULL,
    nombre character varying(100) NOT NULL,
    urlarchivo character varying(255) NOT NULL,
    hasharchivo character varying(255) NOT NULL,
    fechaemision date NOT NULL,
    fechavencimiento date,
    tipodocumento public.tipo_documento_enum NOT NULL
);


--
-- Name: TABLE documentounidad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.documentounidad IS 'Documentos adjuntos por unidad (factura, certificado, comprobante, etc.) (1:N)';


--
-- Name: COLUMN documentounidad.idunidad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.documentounidad.idunidad IS 'Unidad a la que pertenece el documento';


--
-- Name: COLUMN documentounidad.nombre; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.documentounidad.nombre IS 'Nombre del documento';


--
-- Name: COLUMN documentounidad.urlarchivo; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.documentounidad.urlarchivo IS 'URL del archivo';


--
-- Name: COLUMN documentounidad.hasharchivo; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.documentounidad.hasharchivo IS 'Hash del archivo (verifica integridad)';


--
-- Name: COLUMN documentounidad.fechaemision; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.documentounidad.fechaemision IS 'Fecha de emisión';


--
-- Name: COLUMN documentounidad.fechavencimiento; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.documentounidad.fechavencimiento IS 'Fecha de vencimiento (si aplica)';


--
-- Name: COLUMN documentounidad.tipodocumento; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.documentounidad.tipodocumento IS 'Tipo (factura_compra, certificado_importacion, comprobante_garantia, etc.)';


--
-- Name: documentounidad_iddocumento_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.documentounidad_iddocumento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documentounidad_iddocumento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.documentounidad_iddocumento_seq OWNED BY public.documentounidad.iddocumento;


--
-- Name: envio; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.envio (
    idenvio integer NOT NULL,
    idtenant integer NOT NULL,
    idactororigen integer NOT NULL,
    idactordestino integer NOT NULL,
    idtransportista integer,
    codigoenvio character varying(50) NOT NULL,
    fechasalida timestamp without time zone,
    fechaestimada timestamp without time zone,
    fechaentrega timestamp without time zone,
    estado public.estado_envio_enum DEFAULT 'preparacion'::public.estado_envio_enum,
    trackingexterno character varying(100)
);


--
-- Name: TABLE envio; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.envio IS 'Registro de un traslado logístico';


--
-- Name: COLUMN envio.idtenant; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.envio.idtenant IS 'Empresa que realiza el envío';


--
-- Name: COLUMN envio.idactororigen; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.envio.idactororigen IS 'Actor origen (ej. Almacén, Puerto)';


--
-- Name: COLUMN envio.idactordestino; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.envio.idactordestino IS 'Actor destino (ej. Tienda, Almacén)';


--
-- Name: COLUMN envio.idtransportista; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.envio.idtransportista IS 'Actor transportista';


--
-- Name: COLUMN envio.codigoenvio; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.envio.codigoenvio IS 'Código de seguimiento interno';


--
-- Name: COLUMN envio.fechasalida; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.envio.fechasalida IS 'Fecha de salida';


--
-- Name: COLUMN envio.fechaestimada; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.envio.fechaestimada IS 'Fecha estimada de llegada';


--
-- Name: COLUMN envio.fechaentrega; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.envio.fechaentrega IS 'Fecha real de entrega';


--
-- Name: COLUMN envio.estado; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.envio.estado IS 'Estado del envío (preparacion, en_transito, entregado, retrasado, cancelado)';


--
-- Name: COLUMN envio.trackingexterno; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.envio.trackingexterno IS 'Número de tracking de la empresa transportista';


--
-- Name: envio_idenvio_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.envio_idenvio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: envio_idenvio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.envio_idenvio_seq OWNED BY public.envio.idenvio;


--
-- Name: enviounidad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.enviounidad (
    idenviounidad integer NOT NULL,
    idenvio integer NOT NULL,
    idunidad integer NOT NULL
);


--
-- Name: TABLE enviounidad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.enviounidad IS 'Relación N:M entre Envio y UnidadProducto (un envío transporta muchas unidades, una unidad en varios envíos)';


--
-- Name: enviounidad_idenviounidad_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.enviounidad_idenviounidad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: enviounidad_idenviounidad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.enviounidad_idenviounidad_seq OWNED BY public.enviounidad.idenviounidad;


--
-- Name: eventotrazabilidad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.eventotrazabilidad (
    idevento integer NOT NULL,
    idtenant integer NOT NULL,
    tipoevento public.tipo_evento_enum NOT NULL,
    fechahora timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    idactororigen integer,
    idactordestino integer,
    idubicacion integer NOT NULL,
    idusuarioresponsable integer NOT NULL,
    descripcion text,
    payloadhash character varying(255),
    estadoverificacion public.estado_verificacion_enum DEFAULT 'pendiente'::public.estado_verificacion_enum
);


--
-- Name: TABLE eventotrazabilidad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.eventotrazabilidad IS 'Registro de cada evento crítico en la vida del producto';


--
-- Name: COLUMN eventotrazabilidad.idtenant; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.eventotrazabilidad.idtenant IS 'Empresa propietaria del evento';


--
-- Name: COLUMN eventotrazabilidad.tipoevento; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.eventotrazabilidad.tipoevento IS 'Tipo de evento (fabricacion, exportacion, transporte_maritimo, despacho_aduanero, venta, etc.)';


--
-- Name: COLUMN eventotrazabilidad.idactororigen; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.eventotrazabilidad.idactororigen IS 'Actor origen (opcional)';


--
-- Name: COLUMN eventotrazabilidad.idactordestino; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.eventotrazabilidad.idactordestino IS 'Actor destino (opcional)';


--
-- Name: COLUMN eventotrazabilidad.idubicacion; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.eventotrazabilidad.idubicacion IS 'Ubicación donde ocurrió el evento';


--
-- Name: COLUMN eventotrazabilidad.idusuarioresponsable; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.eventotrazabilidad.idusuarioresponsable IS 'Usuario que registró el evento';


--
-- Name: COLUMN eventotrazabilidad.descripcion; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.eventotrazabilidad.descripcion IS 'Descripción detallada del evento';


--
-- Name: COLUMN eventotrazabilidad.payloadhash; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.eventotrazabilidad.payloadhash IS 'Hash del evento para registrar en blockchain';


--
-- Name: COLUMN eventotrazabilidad.estadoverificacion; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.eventotrazabilidad.estadoverificacion IS 'Estado de verificación en blockchain';


--
-- Name: eventotrazabilidad_idevento_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.eventotrazabilidad_idevento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: eventotrazabilidad_idevento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.eventotrazabilidad_idevento_seq OWNED BY public.eventotrazabilidad.idevento;


--
-- Name: eventounidad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.eventounidad (
    ideventounidad integer NOT NULL,
    idevento integer NOT NULL,
    idunidad integer NOT NULL
);


--
-- Name: TABLE eventounidad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.eventounidad IS 'Relación N:M entre EventoTrazabilidad y UnidadProducto (un evento involucra muchas unidades, una unidad participa en muchos eventos)';


--
-- Name: eventounidad_ideventounidad_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.eventounidad_ideventounidad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: eventounidad_ideventounidad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.eventounidad_ideventounidad_seq OWNED BY public.eventounidad.ideventounidad;


--
-- Name: garantiaunidad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.garantiaunidad (
    idgarantia integer NOT NULL,
    idunidad integer NOT NULL,
    fechainicio date NOT NULL,
    fechafin date NOT NULL,
    proveedor character varying(100),
    condiciones text,
    CONSTRAINT chk_fechas_garantia CHECK ((fechafin >= fechainicio))
);


--
-- Name: TABLE garantiaunidad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.garantiaunidad IS 'Garantía asociada a una unidad física (1:1)';


--
-- Name: COLUMN garantiaunidad.idunidad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.garantiaunidad.idunidad IS 'Unidad con garantía';


--
-- Name: COLUMN garantiaunidad.fechainicio; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.garantiaunidad.fechainicio IS 'Fecha de inicio de garantía';


--
-- Name: COLUMN garantiaunidad.fechafin; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.garantiaunidad.fechafin IS 'Fecha de fin de garantía';


--
-- Name: COLUMN garantiaunidad.proveedor; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.garantiaunidad.proveedor IS 'Proveedor de la garantía (ej. Apple)';


--
-- Name: COLUMN garantiaunidad.condiciones; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.garantiaunidad.condiciones IS 'Términos y condiciones de la garantía';


--
-- Name: garantiaunidad_idgarantia_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.garantiaunidad_idgarantia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: garantiaunidad_idgarantia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.garantiaunidad_idgarantia_seq OWNED BY public.garantiaunidad.idgarantia;


--
-- Name: notificacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notificacion (
    idnotificacion integer NOT NULL,
    idusuariotenant integer NOT NULL,
    titulo character varying(100) NOT NULL,
    contenido text NOT NULL,
    leida boolean NOT NULL,
    fechaenvio timestamp without time zone NOT NULL,
    fechalectura timestamp without time zone,
    enlaceaccion character varying(255)
);


--
-- Name: notificacion_idnotificacion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notificacion_idnotificacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notificacion_idnotificacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notificacion_idnotificacion_seq OWNED BY public.notificacion.idnotificacion;


--
-- Name: pago; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pago (
    idpago integer NOT NULL,
    idventa integer NOT NULL,
    metodopago public.metodo_pago_enum NOT NULL,
    monto numeric(10,2) NOT NULL,
    fechapago timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado public.estado_pago_enum DEFAULT 'pendiente'::public.estado_pago_enum
);


--
-- Name: TABLE pago; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.pago IS 'Registro de pagos asociados a una venta (1:N)';


--
-- Name: COLUMN pago.idventa; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pago.idventa IS 'Venta a la que pertenece el pago';


--
-- Name: COLUMN pago.metodopago; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pago.metodopago IS 'Método de pago (efectivo, tarjeta, transferencia, criptomoneda)';


--
-- Name: COLUMN pago.monto; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pago.monto IS 'Monto pagado';


--
-- Name: COLUMN pago.fechapago; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pago.fechapago IS 'Fecha del pago';


--
-- Name: COLUMN pago.estado; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pago.estado IS 'Estado (pendiente, completado, rechazado, reembolsado)';


--
-- Name: pago_idpago_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pago_idpago_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pago_idpago_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pago_idpago_seq OWNED BY public.pago.idpago;


--
-- Name: permiso; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permiso (
    idpermiso integer NOT NULL,
    nombrepermiso character varying(100) NOT NULL,
    descripcion character varying(200),
    modulo character varying(50)
);


--
-- Name: permiso_idpermiso_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.permiso_idpermiso_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: permiso_idpermiso_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.permiso_idpermiso_seq OWNED BY public.permiso.idpermiso;


--
-- Name: plan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plan (
    idplan integer NOT NULL,
    codigo character varying(32) NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    preciomensual numeric(12,2) NOT NULL,
    precioanual numeric(12,2) NOT NULL,
    moneda character varying(3) NOT NULL,
    limiteusuarios integer,
    limiteunidades integer,
    limitereportesmes integer,
    limitealmacenamientomb integer,
    diastrial integer NOT NULL,
    activo boolean NOT NULL,
    creadoen timestamp without time zone NOT NULL,
    actualizadoen timestamp without time zone NOT NULL
);


--
-- Name: plan_idplan_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.plan_idplan_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plan_idplan_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.plan_idplan_seq OWNED BY public.plan.idplan;


--
-- Name: producto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.producto (
    idproducto integer NOT NULL,
    idcategoria integer NOT NULL,
    nombre character varying(100) NOT NULL,
    modelo character varying(50),
    paisorigen character varying(50),
    descripcion text,
    imagenurl character varying(255),
    fechacreacion timestamp without time zone NOT NULL,
    activo boolean NOT NULL
);


--
-- Name: producto_idproducto_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.producto_idproducto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: producto_idproducto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.producto_idproducto_seq OWNED BY public.producto.idproducto;


--
-- Name: productocertificacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.productocertificacion (
    idproductocertificacion integer NOT NULL,
    idproducto integer NOT NULL,
    idcertificacion integer NOT NULL,
    fechaobtencion date
);


--
-- Name: productocertificacion_idproductocertificacion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.productocertificacion_idproductocertificacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: productocertificacion_idproductocertificacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.productocertificacion_idproductocertificacion_seq OWNED BY public.productocertificacion.idproductocertificacion;


--
-- Name: recepcioncompra; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recepcioncompra (
    idrecepcion integer NOT NULL,
    idcompra integer NOT NULL,
    idubicacion integer NOT NULL,
    fecharecepcion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    numerodocumento character varying(50) NOT NULL,
    estado public.estado_recepcion_enum DEFAULT 'pendiente'::public.estado_recepcion_enum
);


--
-- Name: TABLE recepcioncompra; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.recepcioncompra IS 'Recepción física de la mercancía en Bolivia';


--
-- Name: COLUMN recepcioncompra.idcompra; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.recepcioncompra.idcompra IS 'Compra que se está recibiendo';


--
-- Name: COLUMN recepcioncompra.idubicacion; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.recepcioncompra.idubicacion IS 'Ubicación donde se recibe la mercancía';


--
-- Name: COLUMN recepcioncompra.fecharecepcion; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.recepcioncompra.fecharecepcion IS 'Fecha de recepción';


--
-- Name: COLUMN recepcioncompra.numerodocumento; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.recepcioncompra.numerodocumento IS 'Número de documento de recepción (ej. remisión)';


--
-- Name: COLUMN recepcioncompra.estado; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.recepcioncompra.estado IS 'Estado de la recepción (pendiente, parcial, completa, rechazada)';


--
-- Name: recepcioncompra_idrecepcion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recepcioncompra_idrecepcion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recepcioncompra_idrecepcion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recepcioncompra_idrecepcion_seq OWNED BY public.recepcioncompra.idrecepcion;


--
-- Name: recepciondetalle; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recepciondetalle (
    idrecepciondetalle integer NOT NULL,
    idrecepcion integer NOT NULL,
    idvariante integer NOT NULL,
    cantidadesperada integer NOT NULL,
    cantidadrecibida integer NOT NULL,
    CONSTRAINT chk_cantidades CHECK ((cantidadrecibida <= cantidadesperada)),
    CONSTRAINT recepciondetalle_cantidadesperada_check CHECK ((cantidadesperada > 0)),
    CONSTRAINT recepciondetalle_cantidadrecibida_check CHECK ((cantidadrecibida >= 0))
);


--
-- Name: TABLE recepciondetalle; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.recepciondetalle IS 'Detalle de productos recibidos';


--
-- Name: COLUMN recepciondetalle.idrecepcion; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.recepciondetalle.idrecepcion IS 'Recepción a la que pertenece';


--
-- Name: COLUMN recepciondetalle.idvariante; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.recepciondetalle.idvariante IS 'Variante del producto recibido';


--
-- Name: COLUMN recepciondetalle.cantidadesperada; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.recepciondetalle.cantidadesperada IS 'Cantidad esperada según compra';


--
-- Name: COLUMN recepciondetalle.cantidadrecibida; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.recepciondetalle.cantidadrecibida IS 'Cantidad efectivamente recibida';


--
-- Name: recepciondetalle_idrecepciondetalle_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recepciondetalle_idrecepciondetalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recepciondetalle_idrecepciondetalle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recepciondetalle_idrecepciondetalle_seq OWNED BY public.recepciondetalle.idrecepciondetalle;


--
-- Name: registroblockchain; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.registroblockchain (
    idregistro integer NOT NULL,
    idevento integer NOT NULL,
    payloadhash character varying(255) NOT NULL,
    txhash character varying(255),
    blocknumber bigint,
    network character varying(50),
    chainid character varying(50),
    contractaddress character varying(100),
    fechaenvio timestamp without time zone,
    fechaconfirmacion timestamp without time zone,
    estado public.estado_confirmacion_enum DEFAULT 'pendiente'::public.estado_confirmacion_enum,
    numeroconfirmaciones integer DEFAULT 0,
    mensajeerror text
);


--
-- Name: TABLE registroblockchain; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.registroblockchain IS 'Registro de cada transacción enviada a la blockchain (1:1 con EventoTrazabilidad)';


--
-- Name: COLUMN registroblockchain.idevento; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.registroblockchain.idevento IS 'Evento registrado en blockchain (1:1)';


--
-- Name: COLUMN registroblockchain.payloadhash; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.registroblockchain.payloadhash IS 'Hash del evento (único)';


--
-- Name: COLUMN registroblockchain.txhash; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.registroblockchain.txhash IS 'Hash de la transacción en la red';


--
-- Name: COLUMN registroblockchain.blocknumber; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.registroblockchain.blocknumber IS 'Número de bloque';


--
-- Name: COLUMN registroblockchain.network; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.registroblockchain.network IS 'Red blockchain (ej. Ethereum, BSV, Hyperledger)';


--
-- Name: COLUMN registroblockchain.chainid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.registroblockchain.chainid IS 'ID de la cadena';


--
-- Name: COLUMN registroblockchain.contractaddress; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.registroblockchain.contractaddress IS 'Dirección del contrato inteligente';


--
-- Name: COLUMN registroblockchain.fechaenvio; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.registroblockchain.fechaenvio IS 'Fecha de envío a la red';


--
-- Name: COLUMN registroblockchain.fechaconfirmacion; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.registroblockchain.fechaconfirmacion IS 'Fecha de confirmación';


--
-- Name: COLUMN registroblockchain.estado; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.registroblockchain.estado IS 'Estado (pendiente, confirmado, rechazado)';


--
-- Name: COLUMN registroblockchain.numeroconfirmaciones; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.registroblockchain.numeroconfirmaciones IS 'Número de confirmaciones de la red';


--
-- Name: COLUMN registroblockchain.mensajeerror; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.registroblockchain.mensajeerror IS 'Mensaje de error (si falló)';


--
-- Name: registroblockchain_idregistro_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.registroblockchain_idregistro_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: registroblockchain_idregistro_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.registroblockchain_idregistro_seq OWNED BY public.registroblockchain.idregistro;


--
-- Name: reportesospecha; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reportesospecha (
    idreporte integer NOT NULL,
    codigoticket character varying(32) NOT NULL,
    idtenant integer NOT NULL,
    idunidad integer NOT NULL,
    idusuario integer,
    tipoanomalia public.tipo_anomalia_enum NOT NULL,
    descripcion text NOT NULL,
    latitud numeric(10,6),
    longitud numeric(10,6),
    estado public.estado_reporte_enum NOT NULL,
    gravedad public.gravedad_reporte_enum NOT NULL,
    observacionresolucion text,
    idalerta integer,
    score_ml numeric(5,4),
    sugerencia_ml character varying(50),
    creadoen timestamp without time zone NOT NULL,
    actualizadoen timestamp without time zone NOT NULL
);


--
-- Name: reportesospecha_idreporte_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reportesospecha_idreporte_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reportesospecha_idreporte_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reportesospecha_idreporte_seq OWNED BY public.reportesospecha.idreporte;


--
-- Name: reportesospechaevidencia; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reportesospechaevidencia (
    idevidencia integer NOT NULL,
    idreporte integer NOT NULL,
    nombrearchivo character varying(255) NOT NULL,
    tipomime character varying(100) NOT NULL,
    tamanobytes integer NOT NULL,
    urlalmacenamiento character varying(500) NOT NULL,
    hashsha256 character varying(64) NOT NULL,
    creadoen timestamp without time zone NOT NULL
);


--
-- Name: reportesospechaevidencia_idevidencia_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reportesospechaevidencia_idevidencia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reportesospechaevidencia_idevidencia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reportesospechaevidencia_idevidencia_seq OWNED BY public.reportesospechaevidencia.idevidencia;


--
-- Name: rol; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rol (
    idrol integer NOT NULL,
    nombrerol character varying(50) NOT NULL,
    descripcion character varying(200)
);


--
-- Name: rol_idrol_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rol_idrol_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rol_idrol_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rol_idrol_seq OWNED BY public.rol.idrol;


--
-- Name: rolpermiso; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rolpermiso (
    idrolpermiso integer NOT NULL,
    idrol integer NOT NULL,
    idpermiso integer NOT NULL
);


--
-- Name: rolpermiso_idrolpermiso_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rolpermiso_idrolpermiso_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rolpermiso_idrolpermiso_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rolpermiso_idrolpermiso_seq OWNED BY public.rolpermiso.idrolpermiso;


--
-- Name: suscripcion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.suscripcion (
    idsuscripcion integer NOT NULL,
    idtenant integer NOT NULL,
    idplan integer NOT NULL,
    estado public.estado_suscripcion_enum NOT NULL,
    fechainicio timestamp without time zone NOT NULL,
    fechafin timestamp without time zone NOT NULL,
    renovacionautomatica boolean NOT NULL,
    motivocancelacion text,
    creadoen timestamp without time zone NOT NULL,
    actualizadoen timestamp without time zone NOT NULL
);


--
-- Name: suscripcion_idsuscripcion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.suscripcion_idsuscripcion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: suscripcion_idsuscripcion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.suscripcion_idsuscripcion_seq OWNED BY public.suscripcion.idsuscripcion;


--
-- Name: tenant; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tenant (
    idtenant integer NOT NULL,
    nombre character varying(100) NOT NULL,
    razonsocial character varying(100) NOT NULL,
    nit character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    telefono character varying(20),
    activo boolean,
    configuracion json,
    fechacreacion timestamp without time zone
);


--
-- Name: tenant_backup; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tenant_backup (
    idbackup integer NOT NULL,
    idtenant integer NOT NULL,
    idusuario_creador integer NOT NULL,
    nombre_archivo character varying(255) NOT NULL,
    cloud_storage character varying(50) NOT NULL,
    cloud_path character varying(500) NOT NULL,
    peso_bytes bigint NOT NULL,
    checksum_sha256 character varying(64),
    estado character varying(30) NOT NULL,
    mensaje_error text,
    total_registros integer NOT NULL,
    fechacreacion timestamp without time zone NOT NULL
);


--
-- Name: tenant_backup_idbackup_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tenant_backup_idbackup_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tenant_backup_idbackup_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tenant_backup_idbackup_seq OWNED BY public.tenant_backup.idbackup;


--
-- Name: tenant_backup_schedule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tenant_backup_schedule (
    idschedule integer NOT NULL,
    idtenant integer NOT NULL,
    idusuario_creador integer NOT NULL,
    fecha_hora_programada timestamp without time zone NOT NULL,
    frecuencia character varying(20) NOT NULL,
    activo boolean NOT NULL,
    estado character varying(20) NOT NULL,
    ultimo_ejecutado timestamp without time zone,
    proxima_ejecucion timestamp without time zone,
    mensaje_resultado text,
    fechacreacion timestamp without time zone NOT NULL
);


--
-- Name: tenant_backup_schedule_idschedule_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tenant_backup_schedule_idschedule_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tenant_backup_schedule_idschedule_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tenant_backup_schedule_idschedule_seq OWNED BY public.tenant_backup_schedule.idschedule;


--
-- Name: tenant_idtenant_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tenant_idtenant_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tenant_idtenant_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tenant_idtenant_seq OWNED BY public.tenant.idtenant;


--
-- Name: tokenrecuperacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tokenrecuperacion (
    idtoken integer NOT NULL,
    idtenant integer,
    idusuario integer NOT NULL,
    tokenhash character varying(255) NOT NULL,
    expiraen timestamp with time zone NOT NULL,
    usadoen timestamp with time zone,
    fechacreacion timestamp with time zone NOT NULL
);


--
-- Name: tokenrecuperacion_idtoken_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tokenrecuperacion_idtoken_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tokenrecuperacion_idtoken_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tokenrecuperacion_idtoken_seq OWNED BY public.tokenrecuperacion.idtoken;


--
-- Name: tokenrefresco; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tokenrefresco (
    idtoken integer NOT NULL,
    idtenant integer,
    idusuario integer NOT NULL,
    tokenhash character varying(255) NOT NULL,
    expiraen timestamp with time zone NOT NULL,
    revocado boolean NOT NULL,
    fechacreacion timestamp with time zone NOT NULL
);


--
-- Name: tokenrefresco_idtoken_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tokenrefresco_idtoken_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tokenrefresco_idtoken_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tokenrefresco_idtoken_seq OWNED BY public.tokenrefresco.idtoken;


--
-- Name: ubicacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ubicacion (
    idubicacion integer NOT NULL,
    idtenant integer NOT NULL,
    idactor integer,
    nombre character varying(100) NOT NULL,
    direccion character varying(255),
    latitud numeric(10,8),
    longitud numeric(11,8),
    ciudad character varying(100),
    pais character varying(100),
    tipo public.tipo_ubicacion_enum NOT NULL
);


--
-- Name: ubicacion_idubicacion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ubicacion_idubicacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ubicacion_idubicacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ubicacion_idubicacion_seq OWNED BY public.ubicacion.idubicacion;


--
-- Name: unidadproducto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.unidadproducto (
    idunidad integer NOT NULL,
    idtenant integer NOT NULL,
    idvariante integer NOT NULL,
    idrecepciondetalle integer,
    numeroserie character varying(100) NOT NULL,
    imei1 character varying(50),
    imei2 character varying(50),
    eid character varying(50),
    uuidpublico character varying(100) NOT NULL,
    idcustodioactual integer,
    idubicacionactual integer,
    estado public.estado_unidad_enum,
    fechaingreso timestamp without time zone NOT NULL,
    fechaventa timestamp without time zone
);


--
-- Name: unidadproducto_idunidad_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.unidadproducto_idunidad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: unidadproducto_idunidad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.unidadproducto_idunidad_seq OWNED BY public.unidadproducto.idunidad;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuario (
    idusuario integer NOT NULL,
    nombrecompleto character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    contrasenahash character varying(255) NOT NULL,
    fecharegistro timestamp without time zone,
    activo boolean
);


--
-- Name: usuario_idusuario_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usuario_idusuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usuario_idusuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.usuario_idusuario_seq OWNED BY public.usuario.idusuario;


--
-- Name: usuariotenant; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuariotenant (
    idusuariotenant integer NOT NULL,
    idusuario integer NOT NULL,
    idtenant integer NOT NULL,
    fechaasignacion timestamp without time zone
);


--
-- Name: usuariotenant_idusuariotenant_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usuariotenant_idusuariotenant_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usuariotenant_idusuariotenant_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.usuariotenant_idusuariotenant_seq OWNED BY public.usuariotenant.idusuariotenant;


--
-- Name: usuariotenantrol; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuariotenantrol (
    idusuariotenantrol integer NOT NULL,
    idusuariotenant integer NOT NULL,
    idrol integer NOT NULL
);


--
-- Name: usuariotenantrol_idusuariotenantrol_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usuariotenantrol_idusuariotenantrol_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: usuariotenantrol_idusuariotenantrol_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.usuariotenantrol_idusuariotenantrol_seq OWNED BY public.usuariotenantrol.idusuariotenantrol;


--
-- Name: varianteproducto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.varianteproducto (
    idvariante integer NOT NULL,
    idproducto integer NOT NULL,
    capacidad character varying(50),
    color character varying(50),
    sku character varying(50) NOT NULL,
    preciousd numeric(10,2) NOT NULL
);


--
-- Name: varianteproducto_idvariante_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.varianteproducto_idvariante_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: varianteproducto_idvariante_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.varianteproducto_idvariante_seq OWNED BY public.varianteproducto.idvariante;


--
-- Name: venta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.venta (
    idventa integer NOT NULL,
    idtenant integer NOT NULL,
    idcliente integer NOT NULL,
    fechaventa timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total numeric(10,2) NOT NULL,
    estado public.estado_venta_enum DEFAULT 'pendiente'::public.estado_venta_enum
);


--
-- Name: TABLE venta; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.venta IS 'Registro de venta al consumidor final';


--
-- Name: COLUMN venta.idtenant; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.venta.idtenant IS 'Empresa que realiza la venta';


--
-- Name: COLUMN venta.idcliente; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.venta.idcliente IS 'Actor consumidor (CONSUMIDOR)';


--
-- Name: COLUMN venta.fechaventa; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.venta.fechaventa IS 'Fecha de la venta';


--
-- Name: COLUMN venta.total; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.venta.total IS 'Monto total en bolivianos';


--
-- Name: COLUMN venta.estado; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.venta.estado IS 'Estado de la venta (pendiente, pagada, enviada, entregada, cancelada, devuelta)';


--
-- Name: venta_idventa_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.venta_idventa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: venta_idventa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.venta_idventa_seq OWNED BY public.venta.idventa;


--
-- Name: ventadetalle; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ventadetalle (
    idventadetalle integer NOT NULL,
    idventa integer NOT NULL,
    idvariante integer NOT NULL,
    cantidad integer NOT NULL,
    preciounitario numeric(10,2) NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    CONSTRAINT ventadetalle_cantidad_check CHECK ((cantidad > 0))
);


--
-- Name: TABLE ventadetalle; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ventadetalle IS 'Detalle de productos vendidos en una venta';


--
-- Name: COLUMN ventadetalle.idventa; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ventadetalle.idventa IS 'Venta a la que pertenece';


--
-- Name: COLUMN ventadetalle.idvariante; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ventadetalle.idvariante IS 'Variante del producto vendido';


--
-- Name: COLUMN ventadetalle.cantidad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ventadetalle.cantidad IS 'Cantidad vendida';


--
-- Name: COLUMN ventadetalle.preciounitario; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ventadetalle.preciounitario IS 'Precio unitario en bolivianos';


--
-- Name: COLUMN ventadetalle.subtotal; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ventadetalle.subtotal IS 'Subtotal (cantidad * precioUnitario)';


--
-- Name: ventadetalle_idventadetalle_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ventadetalle_idventadetalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ventadetalle_idventadetalle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ventadetalle_idventadetalle_seq OWNED BY public.ventadetalle.idventadetalle;


--
-- Name: ventaunidad; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ventaunidad (
    idventaunidad integer NOT NULL,
    idventadetalle integer NOT NULL,
    idunidad integer NOT NULL
);


--
-- Name: TABLE ventaunidad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ventaunidad IS 'Asigna unidades físicas específicas a cada línea de venta (1:N)';


--
-- Name: COLUMN ventaunidad.idventadetalle; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ventaunidad.idventadetalle IS 'Detalle de la venta';


--
-- Name: COLUMN ventaunidad.idunidad; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ventaunidad.idunidad IS 'Unidad física vendida (serial específico)';


--
-- Name: ventaunidad_idventaunidad_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ventaunidad_idventaunidad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ventaunidad_idventaunidad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ventaunidad_idventaunidad_seq OWNED BY public.ventaunidad.idventaunidad;


--
-- Name: actorcadena idactor; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.actorcadena ALTER COLUMN idactor SET DEFAULT nextval('public.actorcadena_idactor_seq'::regclass);


--
-- Name: alerta idalerta; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alerta ALTER COLUMN idalerta SET DEFAULT nextval('public.alerta_idalerta_seq'::regclass);


--
-- Name: bitacora idbitacora; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitacora ALTER COLUMN idbitacora SET DEFAULT nextval('public.bitacora_idbitacora_seq'::regclass);


--
-- Name: catalogotenant idcatalogotenant; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.catalogotenant ALTER COLUMN idcatalogotenant SET DEFAULT nextval('public.catalogotenant_idcatalogotenant_seq'::regclass);


--
-- Name: categoria idcategoria; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categoria ALTER COLUMN idcategoria SET DEFAULT nextval('public.categoria_idcategoria_seq'::regclass);


--
-- Name: certificacion idcertificacion; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificacion ALTER COLUMN idcertificacion SET DEFAULT nextval('public.certificacion_idcertificacion_seq'::regclass);


--
-- Name: codigoqr idcodigoqr; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.codigoqr ALTER COLUMN idcodigoqr SET DEFAULT nextval('public.codigoqr_idcodigoqr_seq'::regclass);


--
-- Name: compra idcompra; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compra ALTER COLUMN idcompra SET DEFAULT nextval('public.compra_idcompra_seq'::regclass);


--
-- Name: compradetalle idcompradetalle; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compradetalle ALTER COLUMN idcompradetalle SET DEFAULT nextval('public.compradetalle_idcompradetalle_seq'::regclass);


--
-- Name: condiciontransporte idcondicion; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.condiciontransporte ALTER COLUMN idcondicion SET DEFAULT nextval('public.condiciontransporte_idcondicion_seq'::regclass);


--
-- Name: consultatrazabilidad idconsulta; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consultatrazabilidad ALTER COLUMN idconsulta SET DEFAULT nextval('public.consultatrazabilidad_idconsulta_seq'::regclass);


--
-- Name: devolucion iddevolucion; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devolucion ALTER COLUMN iddevolucion SET DEFAULT nextval('public.devolucion_iddevolucion_seq'::regclass);


--
-- Name: devolucionunidad iddevolucionunidad; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devolucionunidad ALTER COLUMN iddevolucionunidad SET DEFAULT nextval('public.devolucionunidad_iddevolucionunidad_seq'::regclass);


--
-- Name: documentounidad iddocumento; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documentounidad ALTER COLUMN iddocumento SET DEFAULT nextval('public.documentounidad_iddocumento_seq'::regclass);


--
-- Name: envio idenvio; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.envio ALTER COLUMN idenvio SET DEFAULT nextval('public.envio_idenvio_seq'::regclass);


--
-- Name: enviounidad idenviounidad; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.enviounidad ALTER COLUMN idenviounidad SET DEFAULT nextval('public.enviounidad_idenviounidad_seq'::regclass);


--
-- Name: eventotrazabilidad idevento; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventotrazabilidad ALTER COLUMN idevento SET DEFAULT nextval('public.eventotrazabilidad_idevento_seq'::regclass);


--
-- Name: eventounidad ideventounidad; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventounidad ALTER COLUMN ideventounidad SET DEFAULT nextval('public.eventounidad_ideventounidad_seq'::regclass);


--
-- Name: garantiaunidad idgarantia; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.garantiaunidad ALTER COLUMN idgarantia SET DEFAULT nextval('public.garantiaunidad_idgarantia_seq'::regclass);


--
-- Name: notificacion idnotificacion; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notificacion ALTER COLUMN idnotificacion SET DEFAULT nextval('public.notificacion_idnotificacion_seq'::regclass);


--
-- Name: pago idpago; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pago ALTER COLUMN idpago SET DEFAULT nextval('public.pago_idpago_seq'::regclass);


--
-- Name: permiso idpermiso; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permiso ALTER COLUMN idpermiso SET DEFAULT nextval('public.permiso_idpermiso_seq'::regclass);


--
-- Name: plan idplan; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plan ALTER COLUMN idplan SET DEFAULT nextval('public.plan_idplan_seq'::regclass);


--
-- Name: producto idproducto; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.producto ALTER COLUMN idproducto SET DEFAULT nextval('public.producto_idproducto_seq'::regclass);


--
-- Name: productocertificacion idproductocertificacion; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productocertificacion ALTER COLUMN idproductocertificacion SET DEFAULT nextval('public.productocertificacion_idproductocertificacion_seq'::regclass);


--
-- Name: recepcioncompra idrecepcion; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recepcioncompra ALTER COLUMN idrecepcion SET DEFAULT nextval('public.recepcioncompra_idrecepcion_seq'::regclass);


--
-- Name: recepciondetalle idrecepciondetalle; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recepciondetalle ALTER COLUMN idrecepciondetalle SET DEFAULT nextval('public.recepciondetalle_idrecepciondetalle_seq'::regclass);


--
-- Name: registroblockchain idregistro; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registroblockchain ALTER COLUMN idregistro SET DEFAULT nextval('public.registroblockchain_idregistro_seq'::regclass);


--
-- Name: reportesospecha idreporte; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reportesospecha ALTER COLUMN idreporte SET DEFAULT nextval('public.reportesospecha_idreporte_seq'::regclass);


--
-- Name: reportesospechaevidencia idevidencia; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reportesospechaevidencia ALTER COLUMN idevidencia SET DEFAULT nextval('public.reportesospechaevidencia_idevidencia_seq'::regclass);


--
-- Name: rol idrol; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rol ALTER COLUMN idrol SET DEFAULT nextval('public.rol_idrol_seq'::regclass);


--
-- Name: rolpermiso idrolpermiso; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rolpermiso ALTER COLUMN idrolpermiso SET DEFAULT nextval('public.rolpermiso_idrolpermiso_seq'::regclass);


--
-- Name: suscripcion idsuscripcion; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suscripcion ALTER COLUMN idsuscripcion SET DEFAULT nextval('public.suscripcion_idsuscripcion_seq'::regclass);


--
-- Name: tenant idtenant; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant ALTER COLUMN idtenant SET DEFAULT nextval('public.tenant_idtenant_seq'::regclass);


--
-- Name: tenant_backup idbackup; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant_backup ALTER COLUMN idbackup SET DEFAULT nextval('public.tenant_backup_idbackup_seq'::regclass);


--
-- Name: tenant_backup_schedule idschedule; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant_backup_schedule ALTER COLUMN idschedule SET DEFAULT nextval('public.tenant_backup_schedule_idschedule_seq'::regclass);


--
-- Name: tokenrecuperacion idtoken; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokenrecuperacion ALTER COLUMN idtoken SET DEFAULT nextval('public.tokenrecuperacion_idtoken_seq'::regclass);


--
-- Name: tokenrefresco idtoken; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokenrefresco ALTER COLUMN idtoken SET DEFAULT nextval('public.tokenrefresco_idtoken_seq'::regclass);


--
-- Name: ubicacion idubicacion; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ubicacion ALTER COLUMN idubicacion SET DEFAULT nextval('public.ubicacion_idubicacion_seq'::regclass);


--
-- Name: unidadproducto idunidad; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unidadproducto ALTER COLUMN idunidad SET DEFAULT nextval('public.unidadproducto_idunidad_seq'::regclass);


--
-- Name: usuario idusuario; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario ALTER COLUMN idusuario SET DEFAULT nextval('public.usuario_idusuario_seq'::regclass);


--
-- Name: usuariotenant idusuariotenant; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuariotenant ALTER COLUMN idusuariotenant SET DEFAULT nextval('public.usuariotenant_idusuariotenant_seq'::regclass);


--
-- Name: usuariotenantrol idusuariotenantrol; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuariotenantrol ALTER COLUMN idusuariotenantrol SET DEFAULT nextval('public.usuariotenantrol_idusuariotenantrol_seq'::regclass);


--
-- Name: varianteproducto idvariante; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.varianteproducto ALTER COLUMN idvariante SET DEFAULT nextval('public.varianteproducto_idvariante_seq'::regclass);


--
-- Name: venta idventa; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venta ALTER COLUMN idventa SET DEFAULT nextval('public.venta_idventa_seq'::regclass);


--
-- Name: ventadetalle idventadetalle; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ventadetalle ALTER COLUMN idventadetalle SET DEFAULT nextval('public.ventadetalle_idventadetalle_seq'::regclass);


--
-- Name: ventaunidad idventaunidad; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ventaunidad ALTER COLUMN idventaunidad SET DEFAULT nextval('public.ventaunidad_idventaunidad_seq'::regclass);


--
-- Name: actorcadena actorcadena_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.actorcadena
    ADD CONSTRAINT actorcadena_pkey PRIMARY KEY (idactor);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: alerta alerta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alerta
    ADD CONSTRAINT alerta_pkey PRIMARY KEY (idalerta);


--
-- Name: bitacora bitacora_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitacora
    ADD CONSTRAINT bitacora_pkey PRIMARY KEY (idbitacora);


--
-- Name: catalogotenant catalogotenant_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.catalogotenant
    ADD CONSTRAINT catalogotenant_pkey PRIMARY KEY (idcatalogotenant);


--
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (idcategoria);


--
-- Name: certificacion certificacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.certificacion
    ADD CONSTRAINT certificacion_pkey PRIMARY KEY (idcertificacion);


--
-- Name: codigoqr codigoqr_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.codigoqr
    ADD CONSTRAINT codigoqr_pkey PRIMARY KEY (idcodigoqr);


--
-- Name: codigoqr codigoqr_tokenpublico_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.codigoqr
    ADD CONSTRAINT codigoqr_tokenpublico_key UNIQUE (tokenpublico);


--
-- Name: compra compra_numeroorden_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_numeroorden_key UNIQUE (numeroorden);


--
-- Name: compra compra_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_pkey PRIMARY KEY (idcompra);


--
-- Name: compradetalle compradetalle_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compradetalle
    ADD CONSTRAINT compradetalle_pkey PRIMARY KEY (idcompradetalle);


--
-- Name: condiciontransporte condiciontransporte_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.condiciontransporte
    ADD CONSTRAINT condiciontransporte_pkey PRIMARY KEY (idcondicion);


--
-- Name: consultatrazabilidad consultatrazabilidad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consultatrazabilidad
    ADD CONSTRAINT consultatrazabilidad_pkey PRIMARY KEY (idconsulta);


--
-- Name: devolucion devolucion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devolucion
    ADD CONSTRAINT devolucion_pkey PRIMARY KEY (iddevolucion);


--
-- Name: devolucionunidad devolucionunidad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devolucionunidad
    ADD CONSTRAINT devolucionunidad_pkey PRIMARY KEY (iddevolucionunidad);


--
-- Name: documentounidad documentounidad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documentounidad
    ADD CONSTRAINT documentounidad_pkey PRIMARY KEY (iddocumento);


--
-- Name: envio envio_codigoenvio_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.envio
    ADD CONSTRAINT envio_codigoenvio_key UNIQUE (codigoenvio);


--
-- Name: envio envio_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.envio
    ADD CONSTRAINT envio_pkey PRIMARY KEY (idenvio);


--
-- Name: enviounidad enviounidad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.enviounidad
    ADD CONSTRAINT enviounidad_pkey PRIMARY KEY (idenviounidad);


--
-- Name: eventotrazabilidad eventotrazabilidad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventotrazabilidad
    ADD CONSTRAINT eventotrazabilidad_pkey PRIMARY KEY (idevento);


--
-- Name: eventounidad eventounidad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventounidad
    ADD CONSTRAINT eventounidad_pkey PRIMARY KEY (ideventounidad);


--
-- Name: garantiaunidad garantiaunidad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.garantiaunidad
    ADD CONSTRAINT garantiaunidad_pkey PRIMARY KEY (idgarantia);


--
-- Name: notificacion notificacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notificacion
    ADD CONSTRAINT notificacion_pkey PRIMARY KEY (idnotificacion);


--
-- Name: pago pago_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT pago_pkey PRIMARY KEY (idpago);


--
-- Name: permiso permiso_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permiso
    ADD CONSTRAINT permiso_pkey PRIMARY KEY (idpermiso);


--
-- Name: plan plan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plan
    ADD CONSTRAINT plan_pkey PRIMARY KEY (idplan);


--
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (idproducto);


--
-- Name: productocertificacion productocertificacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productocertificacion
    ADD CONSTRAINT productocertificacion_pkey PRIMARY KEY (idproductocertificacion);


--
-- Name: recepcioncompra recepcioncompra_numerodocumento_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recepcioncompra
    ADD CONSTRAINT recepcioncompra_numerodocumento_key UNIQUE (numerodocumento);


--
-- Name: recepcioncompra recepcioncompra_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recepcioncompra
    ADD CONSTRAINT recepcioncompra_pkey PRIMARY KEY (idrecepcion);


--
-- Name: recepciondetalle recepciondetalle_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recepciondetalle
    ADD CONSTRAINT recepciondetalle_pkey PRIMARY KEY (idrecepciondetalle);


--
-- Name: registroblockchain registroblockchain_payloadhash_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registroblockchain
    ADD CONSTRAINT registroblockchain_payloadhash_key UNIQUE (payloadhash);


--
-- Name: registroblockchain registroblockchain_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registroblockchain
    ADD CONSTRAINT registroblockchain_pkey PRIMARY KEY (idregistro);


--
-- Name: reportesospecha reportesospecha_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reportesospecha
    ADD CONSTRAINT reportesospecha_pkey PRIMARY KEY (idreporte);


--
-- Name: reportesospechaevidencia reportesospechaevidencia_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reportesospechaevidencia
    ADD CONSTRAINT reportesospechaevidencia_pkey PRIMARY KEY (idevidencia);


--
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (idrol);


--
-- Name: rolpermiso rolpermiso_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rolpermiso
    ADD CONSTRAINT rolpermiso_pkey PRIMARY KEY (idrolpermiso);


--
-- Name: suscripcion suscripcion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suscripcion
    ADD CONSTRAINT suscripcion_pkey PRIMARY KEY (idsuscripcion);


--
-- Name: tenant_backup tenant_backup_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant_backup
    ADD CONSTRAINT tenant_backup_pkey PRIMARY KEY (idbackup);


--
-- Name: tenant_backup_schedule tenant_backup_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant_backup_schedule
    ADD CONSTRAINT tenant_backup_schedule_pkey PRIMARY KEY (idschedule);


--
-- Name: tenant tenant_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant
    ADD CONSTRAINT tenant_pkey PRIMARY KEY (idtenant);


--
-- Name: tokenrecuperacion tokenrecuperacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokenrecuperacion
    ADD CONSTRAINT tokenrecuperacion_pkey PRIMARY KEY (idtoken);


--
-- Name: tokenrefresco tokenrefresco_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokenrefresco
    ADD CONSTRAINT tokenrefresco_pkey PRIMARY KEY (idtoken);


--
-- Name: ubicacion ubicacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ubicacion
    ADD CONSTRAINT ubicacion_pkey PRIMARY KEY (idubicacion);


--
-- Name: devolucionunidad uk_devolucionunidad; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devolucionunidad
    ADD CONSTRAINT uk_devolucionunidad UNIQUE (iddevolucion, idunidad);


--
-- Name: enviounidad uk_envio_unidad; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.enviounidad
    ADD CONSTRAINT uk_envio_unidad UNIQUE (idenvio, idunidad);


--
-- Name: eventounidad uk_eventounidad; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventounidad
    ADD CONSTRAINT uk_eventounidad UNIQUE (idevento, idunidad);


--
-- Name: ventaunidad uk_ventaunidad; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ventaunidad
    ADD CONSTRAINT uk_ventaunidad UNIQUE (idventadetalle, idunidad);


--
-- Name: unidadproducto unidadproducto_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unidadproducto
    ADD CONSTRAINT unidadproducto_pkey PRIMARY KEY (idunidad);


--
-- Name: usuario usuario_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_email_key UNIQUE (email);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (idusuario);


--
-- Name: usuariotenant usuariotenant_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuariotenant
    ADD CONSTRAINT usuariotenant_pkey PRIMARY KEY (idusuariotenant);


--
-- Name: usuariotenantrol usuariotenantrol_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuariotenantrol
    ADD CONSTRAINT usuariotenantrol_pkey PRIMARY KEY (idusuariotenantrol);


--
-- Name: varianteproducto varianteproducto_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.varianteproducto
    ADD CONSTRAINT varianteproducto_pkey PRIMARY KEY (idvariante);


--
-- Name: varianteproducto varianteproducto_sku_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.varianteproducto
    ADD CONSTRAINT varianteproducto_sku_key UNIQUE (sku);


--
-- Name: venta venta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_pkey PRIMARY KEY (idventa);


--
-- Name: ventadetalle ventadetalle_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ventadetalle
    ADD CONSTRAINT ventadetalle_pkey PRIMARY KEY (idventadetalle);


--
-- Name: ventaunidad ventaunidad_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ventaunidad
    ADD CONSTRAINT ventaunidad_pkey PRIMARY KEY (idventaunidad);


--
-- Name: idx_alerta_estado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_alerta_estado ON public.alerta USING btree (estado);


--
-- Name: idx_alerta_gravedad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_alerta_gravedad ON public.alerta USING btree (gravedad);


--
-- Name: idx_alerta_tenant; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_alerta_tenant ON public.alerta USING btree (idtenant);


--
-- Name: idx_alerta_unidad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_alerta_unidad ON public.alerta USING btree (idunidad);


--
-- Name: idx_blockchain_estado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_blockchain_estado ON public.registroblockchain USING btree (estado);


--
-- Name: idx_blockchain_evento; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_blockchain_evento ON public.registroblockchain USING btree (idevento);


--
-- Name: idx_blockchain_payload; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_blockchain_payload ON public.registroblockchain USING btree (payloadhash);


--
-- Name: idx_blockchain_tx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_blockchain_tx ON public.registroblockchain USING btree (txhash);


--
-- Name: idx_compra_estado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_compra_estado ON public.compra USING btree (estado);


--
-- Name: idx_compra_numeroorden; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_compra_numeroorden ON public.compra USING btree (numeroorden);


--
-- Name: idx_compra_proveedor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_compra_proveedor ON public.compra USING btree (idproveedor);


--
-- Name: idx_compra_tenant; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_compra_tenant ON public.compra USING btree (idtenant);


--
-- Name: idx_compradetalle_compra; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_compradetalle_compra ON public.compradetalle USING btree (idcompra);


--
-- Name: idx_condicion_evento; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_condicion_evento ON public.condiciontransporte USING btree (idevento);


--
-- Name: idx_consulta_fecha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_consulta_fecha ON public.consultatrazabilidad USING btree (fechahora);


--
-- Name: idx_consulta_qr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_consulta_qr ON public.consultatrazabilidad USING btree (idcodigoqr);


--
-- Name: idx_devolucion_estado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_devolucion_estado ON public.devolucion USING btree (estado);


--
-- Name: idx_devolucion_venta; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_devolucion_venta ON public.devolucion USING btree (idventa);


--
-- Name: idx_devolucionunidad_devolucion; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_devolucionunidad_devolucion ON public.devolucionunidad USING btree (iddevolucion);


--
-- Name: idx_devolucionunidad_unidad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_devolucionunidad_unidad ON public.devolucionunidad USING btree (idunidad);


--
-- Name: idx_documento_unidad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_documento_unidad ON public.documentounidad USING btree (idunidad);


--
-- Name: idx_envio_codigo; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_envio_codigo ON public.envio USING btree (codigoenvio);


--
-- Name: idx_envio_destino; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_envio_destino ON public.envio USING btree (idactordestino);


--
-- Name: idx_envio_estado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_envio_estado ON public.envio USING btree (estado);


--
-- Name: idx_envio_origen; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_envio_origen ON public.envio USING btree (idactororigen);


--
-- Name: idx_envio_tenant; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_envio_tenant ON public.envio USING btree (idtenant);


--
-- Name: idx_envio_unidad_envio; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_envio_unidad_envio ON public.enviounidad USING btree (idenvio);


--
-- Name: idx_envio_unidad_unidad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_envio_unidad_unidad ON public.enviounidad USING btree (idunidad);


--
-- Name: idx_evento_fecha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_evento_fecha ON public.eventotrazabilidad USING btree (fechahora);


--
-- Name: idx_evento_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_evento_hash ON public.eventotrazabilidad USING btree (payloadhash);


--
-- Name: idx_evento_tenant; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_evento_tenant ON public.eventotrazabilidad USING btree (idtenant);


--
-- Name: idx_evento_tipo; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_evento_tipo ON public.eventotrazabilidad USING btree (tipoevento);


--
-- Name: idx_evento_ubicacion; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_evento_ubicacion ON public.eventotrazabilidad USING btree (idubicacion);


--
-- Name: idx_evento_usuario; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_evento_usuario ON public.eventotrazabilidad USING btree (idusuarioresponsable);


--
-- Name: idx_eventounidad_evento; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_eventounidad_evento ON public.eventounidad USING btree (idevento);


--
-- Name: idx_eventounidad_unidad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_eventounidad_unidad ON public.eventounidad USING btree (idunidad);


--
-- Name: idx_garantia_unidad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_garantia_unidad ON public.garantiaunidad USING btree (idunidad);


--
-- Name: idx_pago_venta; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pago_venta ON public.pago USING btree (idventa);


--
-- Name: idx_qr_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_qr_token ON public.codigoqr USING btree (tokenpublico);


--
-- Name: idx_qr_unidad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_qr_unidad ON public.codigoqr USING btree (idunidad);


--
-- Name: idx_recepcion_compra; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_recepcion_compra ON public.recepcioncompra USING btree (idcompra);


--
-- Name: idx_recepcion_ubicacion; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_recepcion_ubicacion ON public.recepcioncompra USING btree (idubicacion);


--
-- Name: idx_recepciondetalle_recepcion; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_recepciondetalle_recepcion ON public.recepciondetalle USING btree (idrecepcion);


--
-- Name: idx_venta_cliente; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_venta_cliente ON public.venta USING btree (idcliente);


--
-- Name: idx_venta_estado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_venta_estado ON public.venta USING btree (estado);


--
-- Name: idx_venta_fecha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_venta_fecha ON public.venta USING btree (fechaventa);


--
-- Name: idx_venta_tenant; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_venta_tenant ON public.venta USING btree (idtenant);


--
-- Name: idx_ventadetalle_venta; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ventadetalle_venta ON public.ventadetalle USING btree (idventa);


--
-- Name: idx_ventaunidad_detalle; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ventaunidad_detalle ON public.ventaunidad USING btree (idventadetalle);


--
-- Name: idx_ventaunidad_unidad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ventaunidad_unidad ON public.ventaunidad USING btree (idunidad);


--
-- Name: ix_plan_codigo; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_plan_codigo ON public.plan USING btree (codigo);


--
-- Name: ix_reportesospecha_codigoticket; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ix_reportesospecha_codigoticket ON public.reportesospecha USING btree (codigoticket);


--
-- Name: ix_reportesospecha_creadoen; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_reportesospecha_creadoen ON public.reportesospecha USING btree (creadoen);


--
-- Name: ix_reportesospecha_estado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_reportesospecha_estado ON public.reportesospecha USING btree (estado);


--
-- Name: ix_reportesospecha_idtenant; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_reportesospecha_idtenant ON public.reportesospecha USING btree (idtenant);


--
-- Name: ix_reportesospecha_idunidad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_reportesospecha_idunidad ON public.reportesospecha USING btree (idunidad);


--
-- Name: ix_reportesospechaevidencia_idreporte; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_reportesospechaevidencia_idreporte ON public.reportesospechaevidencia USING btree (idreporte);


--
-- Name: ix_suscripcion_estado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_suscripcion_estado ON public.suscripcion USING btree (estado);


--
-- Name: ix_suscripcion_fechafin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_suscripcion_fechafin ON public.suscripcion USING btree (fechafin);


--
-- Name: ix_suscripcion_idplan; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_suscripcion_idplan ON public.suscripcion USING btree (idplan);


--
-- Name: ix_suscripcion_idtenant; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_suscripcion_idtenant ON public.suscripcion USING btree (idtenant);


--
-- Name: actorcadena actorcadena_idtenant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.actorcadena
    ADD CONSTRAINT actorcadena_idtenant_fkey FOREIGN KEY (idtenant) REFERENCES public.tenant(idtenant);


--
-- Name: bitacora bitacora_idusuariotenant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bitacora
    ADD CONSTRAINT bitacora_idusuariotenant_fkey FOREIGN KEY (idusuariotenant) REFERENCES public.usuariotenant(idusuariotenant);


--
-- Name: catalogotenant catalogotenant_idtenant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.catalogotenant
    ADD CONSTRAINT catalogotenant_idtenant_fkey FOREIGN KEY (idtenant) REFERENCES public.tenant(idtenant);


--
-- Name: catalogotenant catalogotenant_idvariante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.catalogotenant
    ADD CONSTRAINT catalogotenant_idvariante_fkey FOREIGN KEY (idvariante) REFERENCES public.varianteproducto(idvariante);


--
-- Name: alerta fk_alerta_evento; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alerta
    ADD CONSTRAINT fk_alerta_evento FOREIGN KEY (idevento) REFERENCES public.eventotrazabilidad(idevento) ON DELETE SET NULL;


--
-- Name: alerta fk_alerta_resolutor; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alerta
    ADD CONSTRAINT fk_alerta_resolutor FOREIGN KEY (idusuarioresolutor) REFERENCES public.usuario(idusuario) ON DELETE SET NULL;


--
-- Name: alerta fk_alerta_tenant; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alerta
    ADD CONSTRAINT fk_alerta_tenant FOREIGN KEY (idtenant) REFERENCES public.tenant(idtenant) ON DELETE CASCADE;


--
-- Name: alerta fk_alerta_unidad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alerta
    ADD CONSTRAINT fk_alerta_unidad FOREIGN KEY (idunidad) REFERENCES public.unidadproducto(idunidad) ON DELETE SET NULL;


--
-- Name: compra fk_compra_proveedor; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT fk_compra_proveedor FOREIGN KEY (idproveedor) REFERENCES public.actorcadena(idactor) ON DELETE RESTRICT;


--
-- Name: compra fk_compra_tenant; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT fk_compra_tenant FOREIGN KEY (idtenant) REFERENCES public.tenant(idtenant) ON DELETE CASCADE;


--
-- Name: compradetalle fk_compradetalle_compra; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compradetalle
    ADD CONSTRAINT fk_compradetalle_compra FOREIGN KEY (idcompra) REFERENCES public.compra(idcompra) ON DELETE CASCADE;


--
-- Name: compradetalle fk_compradetalle_variante; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compradetalle
    ADD CONSTRAINT fk_compradetalle_variante FOREIGN KEY (idvariante) REFERENCES public.varianteproducto(idvariante) ON DELETE RESTRICT;


--
-- Name: consultatrazabilidad fk_consulta_qr; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consultatrazabilidad
    ADD CONSTRAINT fk_consulta_qr FOREIGN KEY (idcodigoqr) REFERENCES public.codigoqr(idcodigoqr) ON DELETE CASCADE;


--
-- Name: devolucion fk_devolucion_venta; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devolucion
    ADD CONSTRAINT fk_devolucion_venta FOREIGN KEY (idventa) REFERENCES public.venta(idventa) ON DELETE CASCADE;


--
-- Name: devolucionunidad fk_devolucionunidad_devolucion; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devolucionunidad
    ADD CONSTRAINT fk_devolucionunidad_devolucion FOREIGN KEY (iddevolucion) REFERENCES public.devolucion(iddevolucion) ON DELETE CASCADE;


--
-- Name: devolucionunidad fk_devolucionunidad_unidad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.devolucionunidad
    ADD CONSTRAINT fk_devolucionunidad_unidad FOREIGN KEY (idunidad) REFERENCES public.unidadproducto(idunidad) ON DELETE RESTRICT;


--
-- Name: documentounidad fk_documento_unidad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documentounidad
    ADD CONSTRAINT fk_documento_unidad FOREIGN KEY (idunidad) REFERENCES public.unidadproducto(idunidad) ON DELETE CASCADE;


--
-- Name: envio fk_envio_destino; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.envio
    ADD CONSTRAINT fk_envio_destino FOREIGN KEY (idactordestino) REFERENCES public.actorcadena(idactor) ON DELETE RESTRICT;


--
-- Name: envio fk_envio_origen; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.envio
    ADD CONSTRAINT fk_envio_origen FOREIGN KEY (idactororigen) REFERENCES public.actorcadena(idactor) ON DELETE RESTRICT;


--
-- Name: envio fk_envio_tenant; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.envio
    ADD CONSTRAINT fk_envio_tenant FOREIGN KEY (idtenant) REFERENCES public.tenant(idtenant) ON DELETE CASCADE;


--
-- Name: envio fk_envio_transportista; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.envio
    ADD CONSTRAINT fk_envio_transportista FOREIGN KEY (idtransportista) REFERENCES public.actorcadena(idactor) ON DELETE SET NULL;


--
-- Name: enviounidad fk_envio_unidad_envio; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.enviounidad
    ADD CONSTRAINT fk_envio_unidad_envio FOREIGN KEY (idenvio) REFERENCES public.envio(idenvio) ON DELETE CASCADE;


--
-- Name: enviounidad fk_envio_unidad_unidad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.enviounidad
    ADD CONSTRAINT fk_envio_unidad_unidad FOREIGN KEY (idunidad) REFERENCES public.unidadproducto(idunidad) ON DELETE CASCADE;


--
-- Name: eventotrazabilidad fk_evento_destino; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventotrazabilidad
    ADD CONSTRAINT fk_evento_destino FOREIGN KEY (idactordestino) REFERENCES public.actorcadena(idactor) ON DELETE SET NULL;


--
-- Name: eventotrazabilidad fk_evento_origen; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventotrazabilidad
    ADD CONSTRAINT fk_evento_origen FOREIGN KEY (idactororigen) REFERENCES public.actorcadena(idactor) ON DELETE SET NULL;


--
-- Name: eventotrazabilidad fk_evento_tenant; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventotrazabilidad
    ADD CONSTRAINT fk_evento_tenant FOREIGN KEY (idtenant) REFERENCES public.tenant(idtenant) ON DELETE CASCADE;


--
-- Name: eventotrazabilidad fk_evento_ubicacion; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventotrazabilidad
    ADD CONSTRAINT fk_evento_ubicacion FOREIGN KEY (idubicacion) REFERENCES public.ubicacion(idubicacion) ON DELETE RESTRICT;


--
-- Name: eventotrazabilidad fk_evento_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventotrazabilidad
    ADD CONSTRAINT fk_evento_usuario FOREIGN KEY (idusuarioresponsable) REFERENCES public.usuario(idusuario) ON DELETE RESTRICT;


--
-- Name: eventounidad fk_eventounidad_evento; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventounidad
    ADD CONSTRAINT fk_eventounidad_evento FOREIGN KEY (idevento) REFERENCES public.eventotrazabilidad(idevento) ON DELETE CASCADE;


--
-- Name: eventounidad fk_eventounidad_unidad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.eventounidad
    ADD CONSTRAINT fk_eventounidad_unidad FOREIGN KEY (idunidad) REFERENCES public.unidadproducto(idunidad) ON DELETE CASCADE;


--
-- Name: garantiaunidad fk_garantia_unidad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.garantiaunidad
    ADD CONSTRAINT fk_garantia_unidad FOREIGN KEY (idunidad) REFERENCES public.unidadproducto(idunidad) ON DELETE CASCADE;


--
-- Name: pago fk_pago_venta; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT fk_pago_venta FOREIGN KEY (idventa) REFERENCES public.venta(idventa) ON DELETE CASCADE;


--
-- Name: codigoqr fk_qr_unidad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.codigoqr
    ADD CONSTRAINT fk_qr_unidad FOREIGN KEY (idunidad) REFERENCES public.unidadproducto(idunidad) ON DELETE CASCADE;


--
-- Name: recepcioncompra fk_recepcion_compra; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recepcioncompra
    ADD CONSTRAINT fk_recepcion_compra FOREIGN KEY (idcompra) REFERENCES public.compra(idcompra) ON DELETE CASCADE;


--
-- Name: recepcioncompra fk_recepcion_ubicacion; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recepcioncompra
    ADD CONSTRAINT fk_recepcion_ubicacion FOREIGN KEY (idubicacion) REFERENCES public.ubicacion(idubicacion) ON DELETE RESTRICT;


--
-- Name: recepciondetalle fk_recepciondetalle_recepcion; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recepciondetalle
    ADD CONSTRAINT fk_recepciondetalle_recepcion FOREIGN KEY (idrecepcion) REFERENCES public.recepcioncompra(idrecepcion) ON DELETE CASCADE;


--
-- Name: recepciondetalle fk_recepciondetalle_variante; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recepciondetalle
    ADD CONSTRAINT fk_recepciondetalle_variante FOREIGN KEY (idvariante) REFERENCES public.varianteproducto(idvariante) ON DELETE RESTRICT;


--
-- Name: registroblockchain fk_registro_evento; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registroblockchain
    ADD CONSTRAINT fk_registro_evento FOREIGN KEY (idevento) REFERENCES public.eventotrazabilidad(idevento) ON DELETE CASCADE;


--
-- Name: venta fk_venta_cliente; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT fk_venta_cliente FOREIGN KEY (idcliente) REFERENCES public.actorcadena(idactor) ON DELETE RESTRICT;


--
-- Name: venta fk_venta_tenant; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venta
    ADD CONSTRAINT fk_venta_tenant FOREIGN KEY (idtenant) REFERENCES public.tenant(idtenant) ON DELETE CASCADE;


--
-- Name: ventadetalle fk_ventadetalle_variante; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ventadetalle
    ADD CONSTRAINT fk_ventadetalle_variante FOREIGN KEY (idvariante) REFERENCES public.varianteproducto(idvariante) ON DELETE RESTRICT;


--
-- Name: ventadetalle fk_ventadetalle_venta; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ventadetalle
    ADD CONSTRAINT fk_ventadetalle_venta FOREIGN KEY (idventa) REFERENCES public.venta(idventa) ON DELETE CASCADE;


--
-- Name: ventaunidad fk_ventaunidad_unidad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ventaunidad
    ADD CONSTRAINT fk_ventaunidad_unidad FOREIGN KEY (idunidad) REFERENCES public.unidadproducto(idunidad) ON DELETE RESTRICT;


--
-- Name: ventaunidad fk_ventaunidad_ventadetalle; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ventaunidad
    ADD CONSTRAINT fk_ventaunidad_ventadetalle FOREIGN KEY (idventadetalle) REFERENCES public.ventadetalle(idventadetalle) ON DELETE CASCADE;


--
-- Name: notificacion notificacion_idusuariotenant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notificacion
    ADD CONSTRAINT notificacion_idusuariotenant_fkey FOREIGN KEY (idusuariotenant) REFERENCES public.usuariotenant(idusuariotenant);


--
-- Name: producto producto_idcategoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_idcategoria_fkey FOREIGN KEY (idcategoria) REFERENCES public.categoria(idcategoria);


--
-- Name: productocertificacion productocertificacion_idcertificacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productocertificacion
    ADD CONSTRAINT productocertificacion_idcertificacion_fkey FOREIGN KEY (idcertificacion) REFERENCES public.certificacion(idcertificacion);


--
-- Name: productocertificacion productocertificacion_idproducto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.productocertificacion
    ADD CONSTRAINT productocertificacion_idproducto_fkey FOREIGN KEY (idproducto) REFERENCES public.producto(idproducto);


--
-- Name: reportesospecha reportesospecha_idalerta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reportesospecha
    ADD CONSTRAINT reportesospecha_idalerta_fkey FOREIGN KEY (idalerta) REFERENCES public.alerta(idalerta);


--
-- Name: reportesospecha reportesospecha_idtenant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reportesospecha
    ADD CONSTRAINT reportesospecha_idtenant_fkey FOREIGN KEY (idtenant) REFERENCES public.tenant(idtenant);


--
-- Name: reportesospecha reportesospecha_idunidad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reportesospecha
    ADD CONSTRAINT reportesospecha_idunidad_fkey FOREIGN KEY (idunidad) REFERENCES public.unidadproducto(idunidad);


--
-- Name: reportesospecha reportesospecha_idusuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reportesospecha
    ADD CONSTRAINT reportesospecha_idusuario_fkey FOREIGN KEY (idusuario) REFERENCES public.usuario(idusuario);


--
-- Name: reportesospechaevidencia reportesospechaevidencia_idreporte_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reportesospechaevidencia
    ADD CONSTRAINT reportesospechaevidencia_idreporte_fkey FOREIGN KEY (idreporte) REFERENCES public.reportesospecha(idreporte);


--
-- Name: rolpermiso rolpermiso_idpermiso_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rolpermiso
    ADD CONSTRAINT rolpermiso_idpermiso_fkey FOREIGN KEY (idpermiso) REFERENCES public.permiso(idpermiso);


--
-- Name: rolpermiso rolpermiso_idrol_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rolpermiso
    ADD CONSTRAINT rolpermiso_idrol_fkey FOREIGN KEY (idrol) REFERENCES public.rol(idrol);


--
-- Name: suscripcion suscripcion_idplan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suscripcion
    ADD CONSTRAINT suscripcion_idplan_fkey FOREIGN KEY (idplan) REFERENCES public.plan(idplan);


--
-- Name: suscripcion suscripcion_idtenant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suscripcion
    ADD CONSTRAINT suscripcion_idtenant_fkey FOREIGN KEY (idtenant) REFERENCES public.tenant(idtenant);


--
-- Name: tenant_backup tenant_backup_idtenant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant_backup
    ADD CONSTRAINT tenant_backup_idtenant_fkey FOREIGN KEY (idtenant) REFERENCES public.tenant(idtenant) ON DELETE CASCADE;


--
-- Name: tenant_backup tenant_backup_idusuario_creador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant_backup
    ADD CONSTRAINT tenant_backup_idusuario_creador_fkey FOREIGN KEY (idusuario_creador) REFERENCES public.usuario(idusuario) ON DELETE CASCADE;


--
-- Name: tenant_backup_schedule tenant_backup_schedule_idtenant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant_backup_schedule
    ADD CONSTRAINT tenant_backup_schedule_idtenant_fkey FOREIGN KEY (idtenant) REFERENCES public.tenant(idtenant) ON DELETE CASCADE;


--
-- Name: tenant_backup_schedule tenant_backup_schedule_idusuario_creador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant_backup_schedule
    ADD CONSTRAINT tenant_backup_schedule_idusuario_creador_fkey FOREIGN KEY (idusuario_creador) REFERENCES public.usuario(idusuario) ON DELETE CASCADE;


--
-- Name: tokenrecuperacion tokenrecuperacion_idtenant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokenrecuperacion
    ADD CONSTRAINT tokenrecuperacion_idtenant_fkey FOREIGN KEY (idtenant) REFERENCES public.tenant(idtenant) ON DELETE CASCADE;


--
-- Name: tokenrecuperacion tokenrecuperacion_idusuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokenrecuperacion
    ADD CONSTRAINT tokenrecuperacion_idusuario_fkey FOREIGN KEY (idusuario) REFERENCES public.usuario(idusuario) ON DELETE CASCADE;


--
-- Name: tokenrefresco tokenrefresco_idtenant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokenrefresco
    ADD CONSTRAINT tokenrefresco_idtenant_fkey FOREIGN KEY (idtenant) REFERENCES public.tenant(idtenant) ON DELETE CASCADE;


--
-- Name: tokenrefresco tokenrefresco_idusuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokenrefresco
    ADD CONSTRAINT tokenrefresco_idusuario_fkey FOREIGN KEY (idusuario) REFERENCES public.usuario(idusuario) ON DELETE CASCADE;


--
-- Name: ubicacion ubicacion_idactor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ubicacion
    ADD CONSTRAINT ubicacion_idactor_fkey FOREIGN KEY (idactor) REFERENCES public.actorcadena(idactor);


--
-- Name: ubicacion ubicacion_idtenant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ubicacion
    ADD CONSTRAINT ubicacion_idtenant_fkey FOREIGN KEY (idtenant) REFERENCES public.tenant(idtenant);


--
-- Name: unidadproducto unidadproducto_idcustodioactual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unidadproducto
    ADD CONSTRAINT unidadproducto_idcustodioactual_fkey FOREIGN KEY (idcustodioactual) REFERENCES public.actorcadena(idactor);


--
-- Name: unidadproducto unidadproducto_idtenant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unidadproducto
    ADD CONSTRAINT unidadproducto_idtenant_fkey FOREIGN KEY (idtenant) REFERENCES public.tenant(idtenant);


--
-- Name: unidadproducto unidadproducto_idubicacionactual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unidadproducto
    ADD CONSTRAINT unidadproducto_idubicacionactual_fkey FOREIGN KEY (idubicacionactual) REFERENCES public.ubicacion(idubicacion);


--
-- Name: unidadproducto unidadproducto_idvariante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.unidadproducto
    ADD CONSTRAINT unidadproducto_idvariante_fkey FOREIGN KEY (idvariante) REFERENCES public.varianteproducto(idvariante);


--
-- Name: usuariotenant usuariotenant_idtenant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuariotenant
    ADD CONSTRAINT usuariotenant_idtenant_fkey FOREIGN KEY (idtenant) REFERENCES public.tenant(idtenant) ON DELETE CASCADE;


--
-- Name: usuariotenant usuariotenant_idusuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuariotenant
    ADD CONSTRAINT usuariotenant_idusuario_fkey FOREIGN KEY (idusuario) REFERENCES public.usuario(idusuario) ON DELETE CASCADE;


--
-- Name: usuariotenantrol usuariotenantrol_idrol_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuariotenantrol
    ADD CONSTRAINT usuariotenantrol_idrol_fkey FOREIGN KEY (idrol) REFERENCES public.rol(idrol);


--
-- Name: usuariotenantrol usuariotenantrol_idusuariotenant_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuariotenantrol
    ADD CONSTRAINT usuariotenantrol_idusuariotenant_fkey FOREIGN KEY (idusuariotenant) REFERENCES public.usuariotenant(idusuariotenant);


--
-- Name: varianteproducto varianteproducto_idproducto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.varianteproducto
    ADD CONSTRAINT varianteproducto_idproducto_fkey FOREIGN KEY (idproducto) REFERENCES public.producto(idproducto);


--
-- PostgreSQL database dump complete
--

\unrestrict ZhLgJEzWwnhRQkldliUqZiRTAfGrxBYUTBXh0iLUjWd2DSmnhgJE3kqRJiHoJZf

