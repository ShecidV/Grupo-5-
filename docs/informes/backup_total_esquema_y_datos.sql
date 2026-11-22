--
-- PostgreSQL database dump
--

\restrict Mp9yQg2OtHJYnUObWbfT5UNkMyKIMaIk5Wg42ZAmWADyuVq4jyv1c6yWll8wt9f

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
-- Data for Name: actorcadena; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.actorcadena VALUES (2, 1, 'Tienda iStore Bolivia S.A. Centro', 'Tienda iStore Bolivia S.A. Centro', 'NIT-1-TIE', NULL, NULL, 'TIENDA');
INSERT INTO public.actorcadena VALUES (3, 2, 'Proveedor TechImport Santa Cruz S.R.L.', 'Proveedor TechImport Santa Cruz S.R.L.', 'NIT-2-DIS', NULL, NULL, 'DISTRIBUIDOR');
INSERT INTO public.actorcadena VALUES (4, 2, 'Tienda TechImport Santa Cruz S.R.L. Centro', 'Tienda TechImport Santa Cruz S.R.L. Centro', 'NIT-2-TIE', NULL, NULL, 'TIENDA');
INSERT INTO public.actorcadena VALUES (5, 3, 'Proveedor Andina Digital Ltda.', 'Proveedor Andina Digital Ltda.', 'NIT-3-DIS', NULL, NULL, 'DISTRIBUIDOR');
INSERT INTO public.actorcadena VALUES (6, 3, 'Tienda Andina Digital Ltda. Centro', 'Tienda Andina Digital Ltda. Centro', 'NIT-3-TIE', NULL, NULL, 'TIENDA');
INSERT INTO public.actorcadena VALUES (7, 4, 'Proveedor ElectroSur Trading S.A.', 'Proveedor ElectroSur Trading S.A.', 'NIT-4-DIS', NULL, NULL, 'DISTRIBUIDOR');
INSERT INTO public.actorcadena VALUES (8, 4, 'Tienda ElectroSur Trading S.A. Centro', 'Tienda ElectroSur Trading S.A. Centro', 'NIT-4-TIE', NULL, NULL, 'TIENDA');
INSERT INTO public.actorcadena VALUES (9, 5, 'Proveedor Cochabamba Wireless S.A.', 'Proveedor Cochabamba Wireless S.A.', 'NIT-5-DIS', NULL, NULL, 'DISTRIBUIDOR');
INSERT INTO public.actorcadena VALUES (10, 5, 'Tienda Cochabamba Wireless S.A. Centro', 'Tienda Cochabamba Wireless S.A. Centro', 'NIT-5-TIE', NULL, NULL, 'TIENDA');
INSERT INTO public.actorcadena VALUES (1, 1, 'Proveedor iStore Bolivia S.A.', 'Proveedor iStore Bolivia S.A.', 'NIT-1-DIS', '', '78912345', 'DISTRIBUIDOR');
INSERT INTO public.actorcadena VALUES (146, 1, 'Apple Supplier 1790797569298', 'Apple Inc USA', 'US-1790797569298', 'supplier_1790797569298@apple.com', '+1-800-123-456', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (163, 1, 'Apple Supplier 1790797598380', 'Apple Inc USA', 'US-1790797598380', 'supplier_1790797598380@apple.com', '+1-800-123-456', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (180, 1, 'Apple Supplier 1790799357434', 'Apple Inc USA', 'US-1790799357434', 'supplier_1790799357434@apple.com', '+1-800-123-456', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (27, 1, 'Apple Supplier 1790796071383', 'Apple Inc USA', 'US-1790796071383', 'supplier_1790796071383@apple.com', '+1-800-123-456', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (95, 1, 'Apple Supplier 1790797168598', 'Apple Inc USA', 'US-1790797168598', 'supplier_1790797168598@apple.com', '+1-800-123-456', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (257, 1, 'Apple Supplier 1790800875931', 'Apple Inc USA', 'US-1790800875931', 'supplier_1790800875931@apple.com', '+1-800-123-456', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (280, 1, 'Apple Supplier 1790801148200', 'Apple Inc USA', 'US-1790801148200', 'supplier_1790801148200@apple.com', '+1-800-123-456', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (44, 1, 'Apple Supplier 1790797008395', 'Apple Inc USA', 'US-1790797008395', 'supplier_1790797008395@apple.com', '+1-800-123-456', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (112, 1, 'Apple Supplier 1790797396466', 'Apple Inc USA', 'US-1790797396466', 'supplier_1790797396466@apple.com', '+1-800-123-456', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (61, 1, 'Apple Supplier 1790797109343', 'Apple Inc USA', 'US-1790797109343', 'supplier_1790797109343@apple.com', '+1-800-123-456', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (129, 1, 'Apple Supplier 1790797451156', 'Apple Inc USA', 'US-1790797451156', 'supplier_1790797451156@apple.com', '+1-800-123-456', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (78, 1, 'Apple Supplier 1790797140749', 'Apple Inc USA', 'US-1790797140749', 'supplier_1790797140749@apple.com', '+1-800-123-456', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (228, 1, 'Apple Supplier 1790800251969', 'Apple Inc USA', 'US-1790800251969', 'supplier_1790800251969@apple.com', '+1-800-123-456', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (297, 1, 'Apple Supplier 1790801217300', 'Apple Inc USA', 'US-1790801217300', 'supplier_1790801217300@apple.com', '+1-800-123-456', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (692, 1, 'Importadora iStore Bolivia S.A.', 'iStore Importaciones y Distribucion S.A.', '123456789', 'importadora@bolivia.com', '70000000', 'IMPORTADOR');
INSERT INTO public.actorcadena VALUES (693, 1, 'TransOriente Logística Express S.R.L.', 'Transportes y Carga del Oriente Boliviano S.R.L.', '482910291', 'operaciones-scz1@transoriente.bo', '77382910', 'TRANSPORTISTA_INTERNACIONAL');
INSERT INTO public.actorcadena VALUES (694, 2, 'Apple Latin America Distribution Hub', 'Apple Operations International Ltd.', '900881920', 'supplies-scz2@apple-latam.com', '+1-800-692-7753', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (695, 2, 'Importadora TechImport Santa Cruz S.R.L.', 'TechImport Santa Cruz Sociedad de Responsabilidad Limitada', '987654321', 'contacto@techimport.com', '70111111', 'IMPORTADOR');
INSERT INTO public.actorcadena VALUES (696, 2, 'TransOriente Logística Express S.R.L.', 'Transportes y Carga del Oriente Boliviano S.R.L.', '482910291', 'operaciones-scz2@transoriente.bo', '77382910', 'TRANSPORTISTA_INTERNACIONAL');
INSERT INTO public.actorcadena VALUES (697, 3, 'Apple Latin America Distribution Hub', 'Apple Operations International Ltd.', '900881920', 'supplies-scz3@apple-latam.com', '+1-800-692-7753', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (698, 3, 'Importadora Andina Digital Ltda.', 'Andina Digital Limitada', '456789123', 'contacto@andinadigital.com', '70222222', 'IMPORTADOR');
INSERT INTO public.actorcadena VALUES (699, 3, 'TransOriente Logística Express S.R.L.', 'Transportes y Carga del Oriente Boliviano S.R.L.', '482910291', 'operaciones-scz3@transoriente.bo', '77382910', 'TRANSPORTISTA_INTERNACIONAL');
INSERT INTO public.actorcadena VALUES (700, 4, 'Apple Latin America Distribution Hub', 'Apple Operations International Ltd.', '900881920', 'supplies-scz4@apple-latam.com', '+1-800-692-7753', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (701, 4, 'Importadora ElectroSur Trading S.A.', 'ElectroSur Trading Sociedad Anónima', '321654987', 'contacto@electrosur.com', '70333333', 'IMPORTADOR');
INSERT INTO public.actorcadena VALUES (702, 4, 'TransOriente Logística Express S.R.L.', 'Transportes y Carga del Oriente Boliviano S.R.L.', '482910291', 'operaciones-scz4@transoriente.bo', '77382910', 'TRANSPORTISTA_INTERNACIONAL');
INSERT INTO public.actorcadena VALUES (703, 5, 'Apple Latin America Distribution Hub', 'Apple Operations International Ltd.', '900881920', 'supplies-scz5@apple-latam.com', '+1-800-692-7753', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (704, 5, 'Importadora Cochabamba Wireless S.A.', 'Cochabamba Wireless Sociedad Anónima', '654987321', 'contacto@cochawireless.com', '70444444', 'IMPORTADOR');
INSERT INTO public.actorcadena VALUES (705, 5, 'TransOriente Logística Express S.R.L.', 'Transportes y Carga del Oriente Boliviano S.R.L.', '482910291', 'operaciones-scz5@transoriente.bo', '77382910', 'TRANSPORTISTA_INTERNACIONAL');
INSERT INTO public.actorcadena VALUES (211, 1, 'Apple Supplier 1790799756539', 'Apple Inc USA', 'US-1790799756539', 'supplier_1790799756539@apple.com', '+1-800-123-456', 'PROVEEDOR_EEUU');
INSERT INTO public.actorcadena VALUES (756, 1, 'Apple Supplier 1791246767269', 'Apple Inc USA', 'US-1791246767269', 'supplier_1791246767269@apple.com', '+1-800-123-456', 'PROVEEDOR_EEUU');


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.alembic_version VALUES ('4eaeaf39d7a4');


--
-- Data for Name: alerta; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.alerta VALUES (1, 1, 1, NULL, 'temperatura', 'Temperatura monitoreada dentro de limites optimos', 'baja', '2026-09-17 03:39:49.197009', NULL, 'resuelta', NULL);
INSERT INTO public.alerta VALUES (2, 2, 4, NULL, 'temperatura', 'Temperatura monitoreada dentro de limites optimos', 'baja', '2026-09-17 03:39:49.355692', NULL, 'resuelta', NULL);
INSERT INTO public.alerta VALUES (3, 3, 7, NULL, 'temperatura', 'Temperatura monitoreada dentro de limites optimos', 'baja', '2026-09-17 03:39:49.404049', NULL, 'resuelta', NULL);
INSERT INTO public.alerta VALUES (4, 4, 10, NULL, 'temperatura', 'Temperatura monitoreada dentro de limites optimos', 'baja', '2026-09-17 03:39:49.443658', NULL, 'resuelta', NULL);
INSERT INTO public.alerta VALUES (5, 5, 13, NULL, 'temperatura', 'Temperatura monitoreada dentro de limites optimos', 'baja', '2026-09-17 03:39:49.48232', NULL, 'resuelta', NULL);
INSERT INTO public.alerta VALUES (6, 1, 1, NULL, 'temperatura', 'Sensor IoT #TR-402 detectó temperatura crítica de 39.4°C (máx tolerado 32.0°C) durante tramo Tambo Quemado - El Alto. Riesgo de degradación térmica de batería de iones de litio.', 'critica', '2026-10-31 11:24:03.759234', NULL, 'pendiente', NULL);
INSERT INTO public.alerta VALUES (7, 1, 2, NULL, 'humedad', 'Humedad relativa sostenida del 88% en contenedor logístico marítimo C-09 durante cruce aduanero. Riesgo de condensación interna en empaque original sellado.', 'alta', '2026-10-29 07:24:03.759234', NULL, 'en_proceso', NULL);
INSERT INTO public.alerta VALUES (8, 1, 3, NULL, 'vibracion', 'Pico de impacto y aceleración anormal (4.8G) durante maniobra de estiba y descarga en depósito aduanero interior Santa Cruz.', 'media', '2026-10-25 03:24:03.759234', '2026-10-25 17:24:03.759234', 'resuelta', 1);
INSERT INTO public.alerta VALUES (9, 1, 416, NULL, 'retraso_aduanero', 'Despacho arancelario y validación de póliza DIM demorada más de 96 horas en Aduana Nacional Interior Santa Cruz por inspección física diferida.', 'alta', '2026-10-30 09:24:03.759234', NULL, 'en_proceso', NULL);
INSERT INTO public.alerta VALUES (10, 1, 149, NULL, 'fraude_autenticidad', 'Intento de escaneo de QR público desde geolocalización incongruente fuera del corredor logístico habilitado antes de la recepción formal en sucursal.', 'critica', '2026-11-01 12:24:03.759234', NULL, 'pendiente', NULL);
INSERT INTO public.alerta VALUES (11, 1, NULL, NULL, 'inconsistencia_cadena', 'Discrepancia de inventario físico vs manifiesto electrónico: el envío reporta 25 cajas máster pero se verificaron 24 en zona de recepción.', 'alta', '2026-10-31 05:24:03.759234', NULL, 'pendiente', NULL);
INSERT INTO public.alerta VALUES (12, 1, 1, NULL, 'vencimiento_garantia', 'Alerta preventiva: Cobertura de garantía de fabricante Apple Care restante menor a 30 días respecto al lote de importación inicial.', 'baja', '2026-10-17 13:24:03.759234', '2026-10-18 03:24:03.759234', 'resuelta', 1);
INSERT INTO public.alerta VALUES (13, 2, 4, NULL, 'temperatura', 'Exceso térmico persistente de 35.8°C registrado por sensor Bluetooth en transporte terrestre tramo Arica - La Paz.', 'alta', '2026-10-30 10:24:03.759234', NULL, 'pendiente', NULL);
INSERT INTO public.alerta VALUES (14, 2, 5, NULL, 'retraso_aduanero', 'Contenedor en canal rojo de aforo en Aduana Fronteriza Pisiga por discrepancia de partida arancelaria de accesorios y cables USB-C.', 'alta', '2026-10-28 06:24:03.759234', NULL, 'en_proceso', NULL);
INSERT INTO public.alerta VALUES (15, 2, 6, NULL, 'vibracion', 'Sensor de choque triaxial activado con aceleración de 6.2G por frenada intempestiva en carretera Oruro - Cochabamba.', 'critica', '2026-10-31 01:24:03.759234', NULL, 'pendiente', NULL);
INSERT INTO public.alerta VALUES (16, 2, 420, NULL, 'fraude_autenticidad', 'Reporte de código QR con lectura ilegible o manipulada. Verificado por peritaje técnico y reetiquetado oficial con token firmado.', 'alta', '2026-10-23 23:24:03.759234', '2026-10-24 13:24:03.759234', 'resuelta', 1);
INSERT INTO public.alerta VALUES (17, 2, NULL, NULL, 'inconsistencia_cadena', 'Falta de confirmación de recepción digital por transportista contratado tras entrega en Almacén Parque Industrial.', 'media', '2026-10-29 14:24:03.759234', NULL, 'en_proceso', NULL);
INSERT INTO public.alerta VALUES (18, 3, 7, NULL, 'temperatura', 'Temperatura mínima descendió a -2.1°C durante pernocte en zona altiplánica Patacamaya. Protocolo térmico aplicado.', 'media', '2026-10-22 09:24:03.759234', '2026-10-22 23:24:03.759234', 'resuelta', 1);
INSERT INTO public.alerta VALUES (19, 3, 8, NULL, 'humedad', 'Humedad ambiente en 76% controlada mediante gel desecante y empaque al vacío en furgón sellado.', 'baja', '2026-10-20 07:24:03.759234', '2026-10-20 21:24:03.759234', 'resuelta', 1);
INSERT INTO public.alerta VALUES (20, 3, 9, NULL, 'retraso_aduanero', 'Retención en recinto aduanero por observación en el certificado de homologación ATT para frecuencias 5G de terminales iPhone 16 Pro.', 'critica', '2026-10-29 21:24:03.759234', NULL, 'pendiente', NULL);
INSERT INTO public.alerta VALUES (21, 3, 439, NULL, 'fraude_autenticidad', 'Alerta de duplicidad de número de serie: intento de registro paralelo en sistema externo con IMEI coincidente.', 'critica', '2026-10-31 08:24:03.759234', NULL, 'en_proceso', NULL);
INSERT INTO public.alerta VALUES (22, 3, 440, NULL, 'inconsistencia_cadena', 'Desvío de ruta GPS no autorizado detectado en vehículo de carga durante traslado entre Depósito Franco y Tienda Sopocachi.', 'alta', '2026-11-01 10:24:03.759234', NULL, 'pendiente', NULL);
INSERT INTO public.alerta VALUES (23, 4, 10, NULL, 'vibracion', 'Múltiples eventos de trepidación continua en camino de ripio hacia frontera sur Villazón. Inspección visual obligatoria.', 'alta', '2026-10-30 04:24:03.759234', NULL, 'pendiente', NULL);
INSERT INTO public.alerta VALUES (24, 4, 11, NULL, 'retraso_aduanero', 'Demora de 48h por mantenimiento de servidores del sistema aduanero SUMA. Flujo normalizado.', 'media', '2026-10-23 11:24:03.759234', '2026-10-24 01:24:03.759234', 'resuelta', 1);
INSERT INTO public.alerta VALUES (25, 4, 12, NULL, 'temperatura', 'Cámara frigorífica / isotérmica de transporte apagada accidentalmente durante parada logística en Yacuiba (38.1°C).', 'critica', '2026-10-31 00:24:03.759234', NULL, 'en_proceso', NULL);
INSERT INTO public.alerta VALUES (26, 4, 458, NULL, 'vencimiento_garantia', 'Dispositivo con activación de fábrica registrada hace más de 60 días antes del ingreso comercial al país.', 'media', '2026-10-29 07:24:03.759234', NULL, 'pendiente', NULL);
INSERT INTO public.alerta VALUES (27, 5, 13, NULL, 'temperatura', 'Sensor termográfico reporta 36.5°C constante en zona de carga durante trayecto por El Chapare.', 'alta', '2026-10-31 07:24:03.759234', NULL, 'pendiente', NULL);
INSERT INTO public.alerta VALUES (28, 5, 14, NULL, 'vibracion', 'Vibración acumulada por bacheo en carretera nueva Cochabamba - Santa Cruz. Empaque secundario intacto.', 'media', '2026-10-29 02:24:03.759234', NULL, 'en_proceso', NULL);
INSERT INTO public.alerta VALUES (29, 5, 15, NULL, 'fraude_autenticidad', 'Etiqueta física con signos de vulneración en precinto holográfico detectada en control de calidad interno.', 'critica', '2026-11-01 13:24:03.759234', NULL, 'pendiente', NULL);
INSERT INTO public.alerta VALUES (30, 5, 476, NULL, 'retraso_aduanero', 'Retraso logístico superado tras aclaración de número de factura comercial electrónica con proveedor en Miami.', 'alta', '2026-10-26 05:24:03.759234', '2026-10-26 19:24:03.759234', 'resuelta', 1);
INSERT INTO public.alerta VALUES (31, 5, NULL, NULL, 'inconsistencia_cadena', 'Código de lote no coincide con el orden cronológico del manifiesto de carga aérea.', 'alta', '2026-10-29 20:24:03.759234', NULL, 'en_proceso', NULL);


--
-- Data for Name: bitacora; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.bitacora VALUES (1, 1, 'GET', 'Auth', NULL, '127.0.0.1', '2026-09-16 23:56:26.887514');
INSERT INTO public.bitacora VALUES (2, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-09-17 01:13:12.987151');
INSERT INTO public.bitacora VALUES (3, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-09-17 01:13:13.460052');
INSERT INTO public.bitacora VALUES (4, 1, 'GET', 'Purchases', NULL, '127.0.0.1', '2026-09-17 01:13:25.326879');
INSERT INTO public.bitacora VALUES (5, 1, 'RECHAZAR_COMPRA', 'Compra', 1, '127.0.0.1', '2026-09-17 01:14:03.351426');
INSERT INTO public.bitacora VALUES (6, 1, 'PATCH', 'Purchases', NULL, '127.0.0.1', '2026-09-17 01:14:03.54152');
INSERT INTO public.bitacora VALUES (7, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-09-17 01:14:10.575096');
INSERT INTO public.bitacora VALUES (8, 1, 'GET', 'Qr', NULL, '127.0.0.1', '2026-09-17 01:14:24.158102');
INSERT INTO public.bitacora VALUES (9, 1, 'GET', 'Qr', NULL, '127.0.0.1', '2026-09-17 01:14:31.636742');
INSERT INTO public.bitacora VALUES (10, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-09-17 01:14:39.329881');
INSERT INTO public.bitacora VALUES (11, 1, 'GET', 'Locations', NULL, '127.0.0.1', '2026-09-17 01:14:50.695786');
INSERT INTO public.bitacora VALUES (12, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-09-17 01:14:50.705871');
INSERT INTO public.bitacora VALUES (13, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-09-17 01:14:59.920334');
INSERT INTO public.bitacora VALUES (14, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-09-17 01:15:49.710855');
INSERT INTO public.bitacora VALUES (15, 1, 'GET', 'Certifications', NULL, '127.0.0.1', '2026-09-17 01:16:00.920506');
INSERT INTO public.bitacora VALUES (16, 1, 'GET', 'Products', NULL, '127.0.0.1', '2026-09-17 01:16:00.945824');
INSERT INTO public.bitacora VALUES (17, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-09-17 01:16:03.467736');
INSERT INTO public.bitacora VALUES (18, 1, 'POST', 'Auth', NULL, '127.0.0.1', '2026-09-17 01:16:04.659671');
INSERT INTO public.bitacora VALUES (19, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-09-17 06:53:09.573397');
INSERT INTO public.bitacora VALUES (20, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-09-17 06:53:10.049758');
INSERT INTO public.bitacora VALUES (21, 1, 'GET', 'Purchases', NULL, '127.0.0.1', '2026-09-17 06:53:15.722297');
INSERT INTO public.bitacora VALUES (762, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:30:44.198473');
INSERT INTO public.bitacora VALUES (24, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:21:03.270731');
INSERT INTO public.bitacora VALUES (25, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 15:21:03.446822');
INSERT INTO public.bitacora VALUES (26, 1, 'POST', 'Categories', NULL, 'testclient', '2026-09-30 15:21:03.492875');
INSERT INTO public.bitacora VALUES (27, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 15:21:03.516645');
INSERT INTO public.bitacora VALUES (28, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:21:03.676416');
INSERT INTO public.bitacora VALUES (29, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:21:03.789287');
INSERT INTO public.bitacora VALUES (30, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:21:03.827692');
INSERT INTO public.bitacora VALUES (31, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:21:03.87499');
INSERT INTO public.bitacora VALUES (32, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:21:03.894829');
INSERT INTO public.bitacora VALUES (33, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:21:04.129358');
INSERT INTO public.bitacora VALUES (34, 1, 'GET', 'Certifications', NULL, 'testclient', '2026-09-30 15:21:04.176993');
INSERT INTO public.bitacora VALUES (35, 1, 'POST', 'Certifications', NULL, 'testclient', '2026-09-30 15:21:04.216419');
INSERT INTO public.bitacora VALUES (36, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:21:04.272674');
INSERT INTO public.bitacora VALUES (37, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:21:04.305711');
INSERT INTO public.bitacora VALUES (38, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:21:04.466685');
INSERT INTO public.bitacora VALUES (39, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 15:21:04.523965');
INSERT INTO public.bitacora VALUES (40, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:21:04.541407');
INSERT INTO public.bitacora VALUES (41, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:21:04.57939');
INSERT INTO public.bitacora VALUES (42, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 15:21:04.622331');
INSERT INTO public.bitacora VALUES (765, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 16:30:44.395282');
INSERT INTO public.bitacora VALUES (767, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 16:30:44.673551');
INSERT INTO public.bitacora VALUES (768, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:30:44.703898');
INSERT INTO public.bitacora VALUES (769, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:30:44.751491');
INSERT INTO public.bitacora VALUES (169, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 15:38:21.593795');
INSERT INTO public.bitacora VALUES (170, 1, 'POST', 'Categories', NULL, 'testclient', '2026-09-30 15:38:21.639716');
INSERT INTO public.bitacora VALUES (172, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:38:21.822254');
INSERT INTO public.bitacora VALUES (176, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:38:22.037047');
INSERT INTO public.bitacora VALUES (178, 1, 'GET', 'Certifications', NULL, 'testclient', '2026-09-30 15:38:22.259179');
INSERT INTO public.bitacora VALUES (179, 1, 'POST', 'Certifications', NULL, 'testclient', '2026-09-30 15:38:22.289416');
INSERT INTO public.bitacora VALUES (180, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:38:22.329711');
INSERT INTO public.bitacora VALUES (182, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:38:22.558044');
INSERT INTO public.bitacora VALUES (206, 1, 'GET', 'Actors', NULL, 'testclient', '2026-09-30 15:38:29.327965');
INSERT INTO public.bitacora VALUES (207, 1, 'POST', 'Actors', NULL, 'testclient', '2026-09-30 15:38:29.375559');
INSERT INTO public.bitacora VALUES (209, 1, 'GET', 'Locations', NULL, 'testclient', '2026-09-30 15:38:29.566436');
INSERT INTO public.bitacora VALUES (210, 1, 'POST', 'Locations', NULL, 'testclient', '2026-09-30 15:38:29.597993');
INSERT INTO public.bitacora VALUES (212, 1, 'GET', 'Units', NULL, 'testclient', '2026-09-30 15:38:29.867114');
INSERT INTO public.bitacora VALUES (213, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:38:29.899059');
INSERT INTO public.bitacora VALUES (61, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:21:11.336188');
INSERT INTO public.bitacora VALUES (62, 1, 'GET', 'Actors', NULL, 'testclient', '2026-09-30 15:21:11.383757');
INSERT INTO public.bitacora VALUES (63, 1, 'POST', 'Actors', NULL, 'testclient', '2026-09-30 15:21:11.415617');
INSERT INTO public.bitacora VALUES (64, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:21:11.589536');
INSERT INTO public.bitacora VALUES (65, 1, 'GET', 'Locations', NULL, 'testclient', '2026-09-30 15:21:11.637082');
INSERT INTO public.bitacora VALUES (66, 1, 'POST', 'Locations', NULL, 'testclient', '2026-09-30 15:21:11.669002');
INSERT INTO public.bitacora VALUES (67, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:21:11.843635');
INSERT INTO public.bitacora VALUES (68, 1, 'GET', 'Units', NULL, 'testclient', '2026-09-30 15:21:11.891296');
INSERT INTO public.bitacora VALUES (69, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:21:11.922982');
INSERT INTO public.bitacora VALUES (70, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:21:11.954722');
INSERT INTO public.bitacora VALUES (71, 1, 'POST', 'Units', NULL, 'testclient', '2026-09-30 15:21:11.986584');
INSERT INTO public.bitacora VALUES (214, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:38:29.930639');
INSERT INTO public.bitacora VALUES (215, 1, 'POST', 'Units', NULL, 'testclient', '2026-09-30 15:38:29.97803');
INSERT INTO public.bitacora VALUES (771, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:30:44.945676');
INSERT INTO public.bitacora VALUES (775, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 16:30:45.113155');
INSERT INTO public.bitacora VALUES (777, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 16:30:45.339466');
INSERT INTO public.bitacora VALUES (778, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:30:45.369047');
INSERT INTO public.bitacora VALUES (779, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:30:45.400777');
INSERT INTO public.bitacora VALUES (780, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 16:30:45.441915');
INSERT INTO public.bitacora VALUES (799, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:30:51.928211');
INSERT INTO public.bitacora VALUES (802, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:30:52.156186');
INSERT INTO public.bitacora VALUES (805, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:30:52.414332');
INSERT INTO public.bitacora VALUES (496, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:46:00.779165');
INSERT INTO public.bitacora VALUES (499, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 15:46:00.957877');
INSERT INTO public.bitacora VALUES (501, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:46:01.254586');
INSERT INTO public.bitacora VALUES (90, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:36:40.345027');
INSERT INTO public.bitacora VALUES (91, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 15:36:40.480731');
INSERT INTO public.bitacora VALUES (92, 1, 'POST', 'Categories', NULL, 'testclient', '2026-09-30 15:36:40.528945');
INSERT INTO public.bitacora VALUES (93, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 15:36:40.552693');
INSERT INTO public.bitacora VALUES (94, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:36:40.708994');
INSERT INTO public.bitacora VALUES (95, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:36:40.804859');
INSERT INTO public.bitacora VALUES (96, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:36:40.842356');
INSERT INTO public.bitacora VALUES (97, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:36:40.888648');
INSERT INTO public.bitacora VALUES (98, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:36:40.921718');
INSERT INTO public.bitacora VALUES (99, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:36:41.084658');
INSERT INTO public.bitacora VALUES (100, 1, 'GET', 'Certifications', NULL, 'testclient', '2026-09-30 15:36:41.139134');
INSERT INTO public.bitacora VALUES (101, 1, 'POST', 'Certifications', NULL, 'testclient', '2026-09-30 15:36:41.179288');
INSERT INTO public.bitacora VALUES (102, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:36:41.238484');
INSERT INTO public.bitacora VALUES (103, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:36:41.275719');
INSERT INTO public.bitacora VALUES (104, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:36:41.436764');
INSERT INTO public.bitacora VALUES (502, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:46:01.291448');
INSERT INTO public.bitacora VALUES (503, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:46:01.338654');
INSERT INTO public.bitacora VALUES (105, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 15:36:41.498463');
INSERT INTO public.bitacora VALUES (106, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:36:41.542029');
INSERT INTO public.bitacora VALUES (107, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:36:41.572628');
INSERT INTO public.bitacora VALUES (108, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 15:36:41.611887');
INSERT INTO public.bitacora VALUES (127, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:36:48.346351');
INSERT INTO public.bitacora VALUES (130, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:36:48.5644');
INSERT INTO public.bitacora VALUES (133, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:36:48.794954');
INSERT INTO public.bitacora VALUES (300, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:39:20.664262');
INSERT INTO public.bitacora VALUES (303, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 15:39:20.892922');
INSERT INTO public.bitacora VALUES (305, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:39:21.162019');
INSERT INTO public.bitacora VALUES (306, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:39:21.206189');
INSERT INTO public.bitacora VALUES (307, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:39:21.257261');
INSERT INTO public.bitacora VALUES (309, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:39:21.463604');
INSERT INTO public.bitacora VALUES (313, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:39:21.661165');
INSERT INTO public.bitacora VALUES (315, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 15:39:21.882137');
INSERT INTO public.bitacora VALUES (316, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:39:21.921931');
INSERT INTO public.bitacora VALUES (317, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:39:21.95762');
INSERT INTO public.bitacora VALUES (318, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 15:39:22.011263');
INSERT INTO public.bitacora VALUES (337, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:39:28.546225');
INSERT INTO public.bitacora VALUES (340, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:39:28.796354');
INSERT INTO public.bitacora VALUES (343, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:39:29.039081');
INSERT INTO public.bitacora VALUES (467, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:44:11.100216');
INSERT INTO public.bitacora VALUES (470, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:44:11.329382');
INSERT INTO public.bitacora VALUES (473, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:44:11.571562');
INSERT INTO public.bitacora VALUES (497, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 15:46:00.897549');
INSERT INTO public.bitacora VALUES (498, 1, 'POST', 'Categories', NULL, 'testclient', '2026-09-30 15:46:00.941943');
INSERT INTO public.bitacora VALUES (500, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:46:01.114473');
INSERT INTO public.bitacora VALUES (504, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:46:01.360609');
INSERT INTO public.bitacora VALUES (506, 1, 'GET', 'Certifications', NULL, 'testclient', '2026-09-30 15:46:01.578224');
INSERT INTO public.bitacora VALUES (507, 1, 'POST', 'Certifications', NULL, 'testclient', '2026-09-30 15:46:01.61314');
INSERT INTO public.bitacora VALUES (508, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:46:01.662892');
INSERT INTO public.bitacora VALUES (510, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:46:01.852923');
INSERT INTO public.bitacora VALUES (534, 1, 'GET', 'Actors', NULL, 'testclient', '2026-09-30 15:46:09.290915');
INSERT INTO public.bitacora VALUES (535, 1, 'POST', 'Actors', NULL, 'testclient', '2026-09-30 15:46:09.328485');
INSERT INTO public.bitacora VALUES (537, 1, 'GET', 'Locations', NULL, 'testclient', '2026-09-30 15:46:09.569943');
INSERT INTO public.bitacora VALUES (538, 1, 'POST', 'Locations', NULL, 'testclient', '2026-09-30 15:46:09.611183');
INSERT INTO public.bitacora VALUES (540, 1, 'GET', 'Units', NULL, 'testclient', '2026-09-30 15:46:09.874598');
INSERT INTO public.bitacora VALUES (541, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:46:09.913151');
INSERT INTO public.bitacora VALUES (542, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:46:09.954567');
INSERT INTO public.bitacora VALUES (543, 1, 'POST', 'Units', NULL, 'testclient', '2026-09-30 15:46:10.018203');
INSERT INTO public.bitacora VALUES (961, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:46:47.41358');
INSERT INTO public.bitacora VALUES (563, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 15:46:30.34835');
INSERT INTO public.bitacora VALUES (564, 1, 'POST', 'Categories', NULL, 'testclient', '2026-09-30 15:46:30.386023');
INSERT INTO public.bitacora VALUES (566, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:46:30.558201');
INSERT INTO public.bitacora VALUES (570, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:46:30.804433');
INSERT INTO public.bitacora VALUES (572, 1, 'GET', 'Certifications', NULL, 'testclient', '2026-09-30 15:46:31.017343');
INSERT INTO public.bitacora VALUES (573, 1, 'POST', 'Certifications', NULL, 'testclient', '2026-09-30 15:46:31.044863');
INSERT INTO public.bitacora VALUES (574, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:46:31.101507');
INSERT INTO public.bitacora VALUES (576, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:46:31.286096');
INSERT INTO public.bitacora VALUES (763, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 16:30:44.327618');
INSERT INTO public.bitacora VALUES (764, 1, 'POST', 'Categories', NULL, 'testclient', '2026-09-30 16:30:44.358532');
INSERT INTO public.bitacora VALUES (766, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:30:44.547241');
INSERT INTO public.bitacora VALUES (770, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 16:30:44.772612');
INSERT INTO public.bitacora VALUES (772, 1, 'GET', 'Certifications', NULL, 'testclient', '2026-09-30 16:30:44.992794');
INSERT INTO public.bitacora VALUES (773, 1, 'POST', 'Certifications', NULL, 'testclient', '2026-09-30 16:30:45.024822');
INSERT INTO public.bitacora VALUES (774, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:30:45.068456');
INSERT INTO public.bitacora VALUES (776, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:30:45.280971');
INSERT INTO public.bitacora VALUES (800, 1, 'GET', 'Actors', NULL, 'testclient', '2026-09-30 16:30:51.96393');
INSERT INTO public.bitacora VALUES (801, 1, 'POST', 'Actors', NULL, 'testclient', '2026-09-30 16:30:51.999459');
INSERT INTO public.bitacora VALUES (803, 1, 'GET', 'Locations', NULL, 'testclient', '2026-09-30 16:30:52.210056');
INSERT INTO public.bitacora VALUES (804, 1, 'POST', 'Locations', NULL, 'testclient', '2026-09-30 16:30:52.235146');
INSERT INTO public.bitacora VALUES (806, 1, 'GET', 'Units', NULL, 'testclient', '2026-09-30 16:30:52.486383');
INSERT INTO public.bitacora VALUES (807, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:30:52.519498');
INSERT INTO public.bitacora VALUES (808, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:30:52.533668');
INSERT INTO public.bitacora VALUES (809, 1, 'POST', 'Units', NULL, 'testclient', '2026-09-30 16:30:52.584476');
INSERT INTO public.bitacora VALUES (964, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 16:46:47.674222');
INSERT INTO public.bitacora VALUES (966, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 16:46:48.108235');
INSERT INTO public.bitacora VALUES (600, 1, 'GET', 'Actors', NULL, 'testclient', '2026-09-30 15:46:38.373753');
INSERT INTO public.bitacora VALUES (601, 1, 'POST', 'Actors', NULL, 'testclient', '2026-09-30 15:46:38.420697');
INSERT INTO public.bitacora VALUES (603, 1, 'GET', 'Locations', NULL, 'testclient', '2026-09-30 15:46:38.650129');
INSERT INTO public.bitacora VALUES (604, 1, 'POST', 'Locations', NULL, 'testclient', '2026-09-30 15:46:38.691054');
INSERT INTO public.bitacora VALUES (606, 1, 'GET', 'Units', NULL, 'testclient', '2026-09-30 15:46:38.948426');
INSERT INTO public.bitacora VALUES (607, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:46:38.985635');
INSERT INTO public.bitacora VALUES (608, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:46:39.017035');
INSERT INTO public.bitacora VALUES (609, 1, 'POST', 'Units', NULL, 'testclient', '2026-09-30 15:46:39.070117');
INSERT INTO public.bitacora VALUES (967, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:46:48.155205');
INSERT INTO public.bitacora VALUES (968, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:46:48.221195');
INSERT INTO public.bitacora VALUES (970, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:46:48.542101');
INSERT INTO public.bitacora VALUES (974, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 16:46:48.858666');
INSERT INTO public.bitacora VALUES (976, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 16:46:49.306481');
INSERT INTO public.bitacora VALUES (977, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:46:49.353277');
INSERT INTO public.bitacora VALUES (978, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:46:49.391033');
INSERT INTO public.bitacora VALUES (979, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 16:46:49.443385');
INSERT INTO public.bitacora VALUES (998, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:46:57.223454');
INSERT INTO public.bitacora VALUES (1001, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:46:57.521475');
INSERT INTO public.bitacora VALUES (1004, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:46:57.791926');
INSERT INTO public.bitacora VALUES (628, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:15:49.433295');
INSERT INTO public.bitacora VALUES (631, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 16:15:49.627798');
INSERT INTO public.bitacora VALUES (633, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 16:15:49.926315');
INSERT INTO public.bitacora VALUES (634, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:15:49.980498');
INSERT INTO public.bitacora VALUES (635, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:15:50.043148');
INSERT INTO public.bitacora VALUES (637, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:15:50.258891');
INSERT INTO public.bitacora VALUES (641, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 16:15:50.413013');
INSERT INTO public.bitacora VALUES (643, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 16:15:50.668563');
INSERT INTO public.bitacora VALUES (644, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:15:50.702269');
INSERT INTO public.bitacora VALUES (645, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:15:50.732674');
INSERT INTO public.bitacora VALUES (646, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 16:15:50.767843');
INSERT INTO public.bitacora VALUES (301, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 15:39:20.822324');
INSERT INTO public.bitacora VALUES (302, 1, 'POST', 'Categories', NULL, 'testclient', '2026-09-30 15:39:20.862533');
INSERT INTO public.bitacora VALUES (304, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:39:21.04699');
INSERT INTO public.bitacora VALUES (308, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:39:21.286924');
INSERT INTO public.bitacora VALUES (310, 1, 'GET', 'Certifications', NULL, 'testclient', '2026-09-30 15:39:21.52436');
INSERT INTO public.bitacora VALUES (311, 1, 'POST', 'Certifications', NULL, 'testclient', '2026-09-30 15:39:21.569292');
INSERT INTO public.bitacora VALUES (312, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:39:21.624586');
INSERT INTO public.bitacora VALUES (314, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:39:21.818756');
INSERT INTO public.bitacora VALUES (338, 1, 'GET', 'Actors', NULL, 'testclient', '2026-09-30 15:39:28.584033');
INSERT INTO public.bitacora VALUES (339, 1, 'POST', 'Actors', NULL, 'testclient', '2026-09-30 15:39:28.630513');
INSERT INTO public.bitacora VALUES (341, 1, 'GET', 'Locations', NULL, 'testclient', '2026-09-30 15:39:28.837585');
INSERT INTO public.bitacora VALUES (342, 1, 'POST', 'Locations', NULL, 'testclient', '2026-09-30 15:39:28.875462');
INSERT INTO public.bitacora VALUES (344, 1, 'GET', 'Units', NULL, 'testclient', '2026-09-30 15:39:29.090967');
INSERT INTO public.bitacora VALUES (345, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:39:29.119721');
INSERT INTO public.bitacora VALUES (346, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:39:29.160576');
INSERT INTO public.bitacora VALUES (347, 1, 'POST', 'Units', NULL, 'testclient', '2026-09-30 15:39:29.200303');
INSERT INTO public.bitacora VALUES (366, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:43:05.131362');
INSERT INTO public.bitacora VALUES (369, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 15:43:05.608241');
INSERT INTO public.bitacora VALUES (371, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:43:06.748287');
INSERT INTO public.bitacora VALUES (372, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:43:07.052205');
INSERT INTO public.bitacora VALUES (373, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:43:07.634668');
INSERT INTO public.bitacora VALUES (375, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:43:08.100494');
INSERT INTO public.bitacora VALUES (379, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:43:08.383119');
INSERT INTO public.bitacora VALUES (381, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 15:43:08.637441');
INSERT INTO public.bitacora VALUES (382, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:43:08.749571');
INSERT INTO public.bitacora VALUES (383, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:43:08.792928');
INSERT INTO public.bitacora VALUES (384, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 15:43:08.850876');
INSERT INTO public.bitacora VALUES (401, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:43:16.35892');
INSERT INTO public.bitacora VALUES (404, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:43:16.676584');
INSERT INTO public.bitacora VALUES (407, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:43:16.946295');
INSERT INTO public.bitacora VALUES (430, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:44:03.076726');
INSERT INTO public.bitacora VALUES (433, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 15:44:03.268221');
INSERT INTO public.bitacora VALUES (435, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:44:03.562297');
INSERT INTO public.bitacora VALUES (436, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:44:03.589803');
INSERT INTO public.bitacora VALUES (437, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:44:03.645267');
INSERT INTO public.bitacora VALUES (439, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:44:03.858225');
INSERT INTO public.bitacora VALUES (234, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:38:53.348442');
INSERT INTO public.bitacora VALUES (237, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 15:38:53.531317');
INSERT INTO public.bitacora VALUES (239, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:38:53.78398');
INSERT INTO public.bitacora VALUES (240, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:38:53.818904');
INSERT INTO public.bitacora VALUES (241, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:38:53.848199');
INSERT INTO public.bitacora VALUES (243, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:38:54.054522');
INSERT INTO public.bitacora VALUES (247, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:38:54.201544');
INSERT INTO public.bitacora VALUES (249, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 15:38:54.401496');
INSERT INTO public.bitacora VALUES (250, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:38:54.432844');
INSERT INTO public.bitacora VALUES (251, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:38:54.464397');
INSERT INTO public.bitacora VALUES (252, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 15:38:54.51164');
INSERT INTO public.bitacora VALUES (271, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:39:00.717996');
INSERT INTO public.bitacora VALUES (274, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:39:00.923909');
INSERT INTO public.bitacora VALUES (277, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:39:01.152818');
INSERT INTO public.bitacora VALUES (443, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:44:04.035422');
INSERT INTO public.bitacora VALUES (445, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 15:44:04.261822');
INSERT INTO public.bitacora VALUES (446, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:44:04.289996');
INSERT INTO public.bitacora VALUES (447, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:44:04.326524');
INSERT INTO public.bitacora VALUES (448, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 15:44:04.369054');
INSERT INTO public.bitacora VALUES (468, 1, 'GET', 'Actors', NULL, 'testclient', '2026-09-30 15:44:11.150178');
INSERT INTO public.bitacora VALUES (469, 1, 'POST', 'Actors', NULL, 'testclient', '2026-09-30 15:44:11.187799');
INSERT INTO public.bitacora VALUES (471, 1, 'GET', 'Locations', NULL, 'testclient', '2026-09-30 15:44:11.378859');
INSERT INTO public.bitacora VALUES (472, 1, 'POST', 'Locations', NULL, 'testclient', '2026-09-30 15:44:11.413557');
INSERT INTO public.bitacora VALUES (474, 1, 'GET', 'Units', NULL, 'testclient', '2026-09-30 15:44:11.638537');
INSERT INTO public.bitacora VALUES (475, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:44:11.670159');
INSERT INTO public.bitacora VALUES (476, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:44:11.704464');
INSERT INTO public.bitacora VALUES (477, 1, 'POST', 'Units', NULL, 'testclient', '2026-09-30 15:44:11.749866');
INSERT INTO public.bitacora VALUES (505, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:46:01.532237');
INSERT INTO public.bitacora VALUES (509, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:46:01.702355');
INSERT INTO public.bitacora VALUES (511, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 15:46:01.907157');
INSERT INTO public.bitacora VALUES (512, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:46:01.950415');
INSERT INTO public.bitacora VALUES (513, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:46:01.991168');
INSERT INTO public.bitacora VALUES (514, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 15:46:02.030285');
INSERT INTO public.bitacora VALUES (533, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:46:09.241758');
INSERT INTO public.bitacora VALUES (536, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:46:09.523532');
INSERT INTO public.bitacora VALUES (539, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:46:09.788383');
INSERT INTO public.bitacora VALUES (562, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:46:30.218663');
INSERT INTO public.bitacora VALUES (565, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 15:46:30.409586');
INSERT INTO public.bitacora VALUES (567, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:46:30.682502');
INSERT INTO public.bitacora VALUES (568, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:46:30.725338');
INSERT INTO public.bitacora VALUES (569, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:46:30.770111');
INSERT INTO public.bitacora VALUES (571, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:46:30.960334');
INSERT INTO public.bitacora VALUES (575, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:46:31.136804');
INSERT INTO public.bitacora VALUES (577, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 15:46:31.354285');
INSERT INTO public.bitacora VALUES (578, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:46:31.418364');
INSERT INTO public.bitacora VALUES (579, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:46:31.450406');
INSERT INTO public.bitacora VALUES (580, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 15:46:31.499206');
INSERT INTO public.bitacora VALUES (599, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:46:38.315978');
INSERT INTO public.bitacora VALUES (602, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:46:38.592672');
INSERT INTO public.bitacora VALUES (605, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:46:38.86898');
INSERT INTO public.bitacora VALUES (962, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 16:46:47.583631');
INSERT INTO public.bitacora VALUES (963, 1, 'POST', 'Categories', NULL, 'testclient', '2026-09-30 16:46:47.646886');
INSERT INTO public.bitacora VALUES (965, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:46:47.892402');
INSERT INTO public.bitacora VALUES (969, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 16:46:48.262393');
INSERT INTO public.bitacora VALUES (971, 1, 'GET', 'Certifications', NULL, 'testclient', '2026-09-30 16:46:48.618531');
INSERT INTO public.bitacora VALUES (972, 1, 'POST', 'Certifications', NULL, 'testclient', '2026-09-30 16:46:48.70632');
INSERT INTO public.bitacora VALUES (629, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 16:15:49.556741');
INSERT INTO public.bitacora VALUES (630, 1, 'POST', 'Categories', NULL, 'testclient', '2026-09-30 16:15:49.596789');
INSERT INTO public.bitacora VALUES (632, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:15:49.799731');
INSERT INTO public.bitacora VALUES (636, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 16:15:50.076125');
INSERT INTO public.bitacora VALUES (638, 1, 'GET', 'Certifications', NULL, 'testclient', '2026-09-30 16:15:50.309465');
INSERT INTO public.bitacora VALUES (639, 1, 'POST', 'Certifications', NULL, 'testclient', '2026-09-30 16:15:50.339134');
INSERT INTO public.bitacora VALUES (640, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:15:50.390903');
INSERT INTO public.bitacora VALUES (642, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:15:50.604622');
INSERT INTO public.bitacora VALUES (973, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:46:48.77075');
INSERT INTO public.bitacora VALUES (975, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:46:49.187744');
INSERT INTO public.bitacora VALUES (999, 1, 'GET', 'Actors', NULL, 'testclient', '2026-09-30 16:46:57.2914');
INSERT INTO public.bitacora VALUES (1000, 1, 'POST', 'Actors', NULL, 'testclient', '2026-09-30 16:46:57.335285');
INSERT INTO public.bitacora VALUES (1002, 1, 'GET', 'Locations', NULL, 'testclient', '2026-09-30 16:46:57.581024');
INSERT INTO public.bitacora VALUES (1003, 1, 'POST', 'Locations', NULL, 'testclient', '2026-09-30 16:46:57.61772');
INSERT INTO public.bitacora VALUES (1005, 1, 'GET', 'Units', NULL, 'testclient', '2026-09-30 16:46:57.891179');
INSERT INTO public.bitacora VALUES (128, 1, 'GET', 'Actors', NULL, 'testclient', '2026-09-30 15:36:48.386362');
INSERT INTO public.bitacora VALUES (129, 1, 'POST', 'Actors', NULL, 'testclient', '2026-09-30 15:36:48.421981');
INSERT INTO public.bitacora VALUES (131, 1, 'GET', 'Locations', NULL, 'testclient', '2026-09-30 15:36:48.620654');
INSERT INTO public.bitacora VALUES (132, 1, 'POST', 'Locations', NULL, 'testclient', '2026-09-30 15:36:48.643667');
INSERT INTO public.bitacora VALUES (134, 1, 'GET', 'Units', NULL, 'testclient', '2026-09-30 15:36:48.881724');
INSERT INTO public.bitacora VALUES (135, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:36:48.898809');
INSERT INTO public.bitacora VALUES (136, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:36:48.944867');
INSERT INTO public.bitacora VALUES (137, 1, 'POST', 'Units', NULL, 'testclient', '2026-09-30 15:36:48.987638');
INSERT INTO public.bitacora VALUES (168, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:38:21.452662');
INSERT INTO public.bitacora VALUES (171, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 15:38:21.664541');
INSERT INTO public.bitacora VALUES (173, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:38:21.933442');
INSERT INTO public.bitacora VALUES (174, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:38:21.965999');
INSERT INTO public.bitacora VALUES (175, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:38:22.012885');
INSERT INTO public.bitacora VALUES (177, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:38:22.213555');
INSERT INTO public.bitacora VALUES (181, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:38:22.374635');
INSERT INTO public.bitacora VALUES (183, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 15:38:22.611357');
INSERT INTO public.bitacora VALUES (184, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:38:22.641286');
INSERT INTO public.bitacora VALUES (185, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:38:22.685034');
INSERT INTO public.bitacora VALUES (186, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 15:38:22.730561');
INSERT INTO public.bitacora VALUES (205, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:38:29.296451');
INSERT INTO public.bitacora VALUES (208, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:38:29.517972');
INSERT INTO public.bitacora VALUES (211, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:38:29.804092');
INSERT INTO public.bitacora VALUES (235, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 15:38:53.469572');
INSERT INTO public.bitacora VALUES (236, 1, 'POST', 'Categories', NULL, 'testclient', '2026-09-30 15:38:53.51415');
INSERT INTO public.bitacora VALUES (238, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:38:53.692835');
INSERT INTO public.bitacora VALUES (242, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:38:53.880004');
INSERT INTO public.bitacora VALUES (244, 1, 'GET', 'Certifications', NULL, 'testclient', '2026-09-30 15:38:54.086045');
INSERT INTO public.bitacora VALUES (245, 1, 'POST', 'Certifications', NULL, 'testclient', '2026-09-30 15:38:54.124867');
INSERT INTO public.bitacora VALUES (246, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:38:54.164273');
INSERT INTO public.bitacora VALUES (248, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:38:54.353452');
INSERT INTO public.bitacora VALUES (272, 1, 'GET', 'Actors', NULL, 'testclient', '2026-09-30 15:39:00.749622');
INSERT INTO public.bitacora VALUES (273, 1, 'POST', 'Actors', NULL, 'testclient', '2026-09-30 15:39:00.781457');
INSERT INTO public.bitacora VALUES (275, 1, 'GET', 'Locations', NULL, 'testclient', '2026-09-30 15:39:00.971321');
INSERT INTO public.bitacora VALUES (276, 1, 'POST', 'Locations', NULL, 'testclient', '2026-09-30 15:39:01.007468');
INSERT INTO public.bitacora VALUES (278, 1, 'GET', 'Units', NULL, 'testclient', '2026-09-30 15:39:01.213247');
INSERT INTO public.bitacora VALUES (279, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:39:01.242604');
INSERT INTO public.bitacora VALUES (280, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:39:01.258161');
INSERT INTO public.bitacora VALUES (281, 1, 'POST', 'Units', NULL, 'testclient', '2026-09-30 15:39:01.313578');
INSERT INTO public.bitacora VALUES (696, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:22:27.974752');
INSERT INTO public.bitacora VALUES (699, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 16:22:28.210648');
INSERT INTO public.bitacora VALUES (701, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 16:22:28.510894');
INSERT INTO public.bitacora VALUES (702, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:22:28.548758');
INSERT INTO public.bitacora VALUES (703, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:22:28.597775');
INSERT INTO public.bitacora VALUES (705, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:22:28.821839');
INSERT INTO public.bitacora VALUES (709, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 16:22:29.012411');
INSERT INTO public.bitacora VALUES (711, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 16:22:29.27948');
INSERT INTO public.bitacora VALUES (712, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:22:29.316308');
INSERT INTO public.bitacora VALUES (713, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:22:29.348592');
INSERT INTO public.bitacora VALUES (714, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 16:22:29.391319');
INSERT INTO public.bitacora VALUES (733, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:22:36.493042');
INSERT INTO public.bitacora VALUES (367, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 15:43:05.462571');
INSERT INTO public.bitacora VALUES (368, 1, 'POST', 'Categories', NULL, 'testclient', '2026-09-30 15:43:05.560522');
INSERT INTO public.bitacora VALUES (370, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:43:05.84811');
INSERT INTO public.bitacora VALUES (374, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:43:07.697711');
INSERT INTO public.bitacora VALUES (376, 1, 'GET', 'Certifications', NULL, 'testclient', '2026-09-30 15:43:08.228955');
INSERT INTO public.bitacora VALUES (377, 1, 'POST', 'Certifications', NULL, 'testclient', '2026-09-30 15:43:08.27395');
INSERT INTO public.bitacora VALUES (378, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:43:08.340315');
INSERT INTO public.bitacora VALUES (380, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:43:08.565914');
INSERT INTO public.bitacora VALUES (402, 1, 'GET', 'Actors', NULL, 'testclient', '2026-09-30 15:43:16.458086');
INSERT INTO public.bitacora VALUES (403, 1, 'POST', 'Actors', NULL, 'testclient', '2026-09-30 15:43:16.507583');
INSERT INTO public.bitacora VALUES (405, 1, 'GET', 'Locations', NULL, 'testclient', '2026-09-30 15:43:16.731306');
INSERT INTO public.bitacora VALUES (406, 1, 'POST', 'Locations', NULL, 'testclient', '2026-09-30 15:43:16.778301');
INSERT INTO public.bitacora VALUES (408, 1, 'GET', 'Units', NULL, 'testclient', '2026-09-30 15:43:17.018769');
INSERT INTO public.bitacora VALUES (409, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:43:17.058217');
INSERT INTO public.bitacora VALUES (410, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:43:17.089935');
INSERT INTO public.bitacora VALUES (411, 1, 'POST', 'Units', NULL, 'testclient', '2026-09-30 15:43:17.151707');
INSERT INTO public.bitacora VALUES (431, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 15:44:03.202218');
INSERT INTO public.bitacora VALUES (432, 1, 'POST', 'Categories', NULL, 'testclient', '2026-09-30 15:44:03.245254');
INSERT INTO public.bitacora VALUES (434, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:44:03.435526');
INSERT INTO public.bitacora VALUES (438, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 15:44:03.676777');
INSERT INTO public.bitacora VALUES (440, 1, 'GET', 'Certifications', NULL, 'testclient', '2026-09-30 15:44:03.907492');
INSERT INTO public.bitacora VALUES (441, 1, 'POST', 'Certifications', NULL, 'testclient', '2026-09-30 15:44:03.940568');
INSERT INTO public.bitacora VALUES (442, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 15:44:03.99364');
INSERT INTO public.bitacora VALUES (444, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 15:44:04.201462');
INSERT INTO public.bitacora VALUES (736, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:22:36.74104');
INSERT INTO public.bitacora VALUES (739, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:22:36.999843');
INSERT INTO public.bitacora VALUES (1394, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-09-30 23:25:22.896669');
INSERT INTO public.bitacora VALUES (1397, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-09-30 23:26:49.15342');
INSERT INTO public.bitacora VALUES (1398, 1, 'GET', 'Locations', NULL, '127.0.0.1', '2026-09-30 23:26:55.110155');
INSERT INTO public.bitacora VALUES (1400, 1, 'GET', 'Locations', NULL, '127.0.0.1', '2026-09-30 23:27:09.00286');
INSERT INTO public.bitacora VALUES (1403, 1, 'GET', 'Locations', NULL, '127.0.0.1', '2026-09-30 23:27:13.917313');
INSERT INTO public.bitacora VALUES (1407, 1, 'GET', 'Permissions', NULL, '127.0.0.1', '2026-09-30 23:30:38.594878');
INSERT INTO public.bitacora VALUES (1411, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-09-30 23:31:10.182865');
INSERT INTO public.bitacora VALUES (1412, 1, 'GET', 'Certifications', NULL, '127.0.0.1', '2026-09-30 23:31:13.699046');
INSERT INTO public.bitacora VALUES (1415, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-09-30 23:31:22.237921');
INSERT INTO public.bitacora VALUES (1421, 1, 'GET', 'Actors', NULL, '127.0.0.1', '2026-10-01 00:21:39.16613');
INSERT INTO public.bitacora VALUES (1422, 1, 'GET', 'Purchases', NULL, '127.0.0.1', '2026-10-01 00:21:39.19015');
INSERT INTO public.bitacora VALUES (1426, 1, 'GET', 'Actors', NULL, '127.0.0.1', '2026-10-01 00:21:49.873078');
INSERT INTO public.bitacora VALUES (1432, 1, 'GET', 'Actors', NULL, '127.0.0.1', '2026-10-01 00:22:14.472541');
INSERT INTO public.bitacora VALUES (1434, 1, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-01 00:22:14.498148');
INSERT INTO public.bitacora VALUES (1440, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-01 00:22:28.95981');
INSERT INTO public.bitacora VALUES (697, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 16:22:28.13063');
INSERT INTO public.bitacora VALUES (698, 1, 'POST', 'Categories', NULL, 'testclient', '2026-09-30 16:22:28.183576');
INSERT INTO public.bitacora VALUES (700, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:22:28.375128');
INSERT INTO public.bitacora VALUES (704, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 16:22:28.634412');
INSERT INTO public.bitacora VALUES (706, 1, 'GET', 'Certifications', NULL, 'testclient', '2026-09-30 16:22:28.879624');
INSERT INTO public.bitacora VALUES (707, 1, 'POST', 'Certifications', NULL, 'testclient', '2026-09-30 16:22:28.905665');
INSERT INTO public.bitacora VALUES (708, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:22:28.963865');
INSERT INTO public.bitacora VALUES (710, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:22:29.200137');
INSERT INTO public.bitacora VALUES (734, 1, 'GET', 'Actors', NULL, 'testclient', '2026-09-30 16:22:36.535339');
INSERT INTO public.bitacora VALUES (735, 1, 'POST', 'Actors', NULL, 'testclient', '2026-09-30 16:22:36.567587');
INSERT INTO public.bitacora VALUES (737, 1, 'GET', 'Locations', NULL, 'testclient', '2026-09-30 16:22:36.789602');
INSERT INTO public.bitacora VALUES (738, 1, 'POST', 'Locations', NULL, 'testclient', '2026-09-30 16:22:36.819879');
INSERT INTO public.bitacora VALUES (740, 1, 'GET', 'Units', NULL, 'testclient', '2026-09-30 16:22:37.064962');
INSERT INTO public.bitacora VALUES (741, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:22:37.10522');
INSERT INTO public.bitacora VALUES (742, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:22:37.141373');
INSERT INTO public.bitacora VALUES (743, 1, 'POST', 'Units', NULL, 'testclient', '2026-09-30 16:22:37.184');
INSERT INTO public.bitacora VALUES (828, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:41:07.495383');
INSERT INTO public.bitacora VALUES (831, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 16:41:07.729921');
INSERT INTO public.bitacora VALUES (833, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 16:41:08.045178');
INSERT INTO public.bitacora VALUES (834, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:41:08.093714');
INSERT INTO public.bitacora VALUES (835, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:41:08.146834');
INSERT INTO public.bitacora VALUES (837, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:41:08.376703');
INSERT INTO public.bitacora VALUES (841, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 16:41:08.564651');
INSERT INTO public.bitacora VALUES (843, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 16:41:08.805507');
INSERT INTO public.bitacora VALUES (844, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:41:08.837342');
INSERT INTO public.bitacora VALUES (845, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:41:08.874602');
INSERT INTO public.bitacora VALUES (846, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 16:41:08.920851');
INSERT INTO public.bitacora VALUES (865, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:41:15.883789');
INSERT INTO public.bitacora VALUES (868, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:41:16.1258');
INSERT INTO public.bitacora VALUES (871, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:41:16.363465');
INSERT INTO public.bitacora VALUES (895, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:45:38.020356');
INSERT INTO public.bitacora VALUES (898, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 16:45:38.219902');
INSERT INTO public.bitacora VALUES (900, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 16:45:38.535472');
INSERT INTO public.bitacora VALUES (901, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:45:38.567169');
INSERT INTO public.bitacora VALUES (902, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:45:38.616283');
INSERT INTO public.bitacora VALUES (904, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:45:38.826716');
INSERT INTO public.bitacora VALUES (908, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 16:45:39.012465');
INSERT INTO public.bitacora VALUES (910, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 16:45:39.27134');
INSERT INTO public.bitacora VALUES (911, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:45:39.295138');
INSERT INTO public.bitacora VALUES (912, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:45:39.336309');
INSERT INTO public.bitacora VALUES (913, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-09-30 16:45:39.384461');
INSERT INTO public.bitacora VALUES (933, 1, 'GET', 'Actors', NULL, 'testclient', '2026-09-30 16:45:48.194214');
INSERT INTO public.bitacora VALUES (934, 1, 'POST', 'Actors', NULL, 'testclient', '2026-09-30 16:45:48.230531');
INSERT INTO public.bitacora VALUES (936, 1, 'GET', 'Locations', NULL, 'testclient', '2026-09-30 16:45:48.443261');
INSERT INTO public.bitacora VALUES (937, 1, 'POST', 'Locations', NULL, 'testclient', '2026-09-30 16:45:48.4819');
INSERT INTO public.bitacora VALUES (939, 1, 'GET', 'Units', NULL, 'testclient', '2026-09-30 16:45:48.732408');
INSERT INTO public.bitacora VALUES (940, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:45:48.764095');
INSERT INTO public.bitacora VALUES (941, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:45:48.797063');
INSERT INTO public.bitacora VALUES (942, 1, 'POST', 'Units', NULL, 'testclient', '2026-09-30 16:45:48.852114');
INSERT INTO public.bitacora VALUES (1006, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:46:57.936088');
INSERT INTO public.bitacora VALUES (1007, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:46:57.979713');
INSERT INTO public.bitacora VALUES (1008, 1, 'POST', 'Units', NULL, 'testclient', '2026-09-30 16:46:58.034262');
INSERT INTO public.bitacora VALUES (2429, 1, 'GET', 'Auth', NULL, '127.0.0.1', '2026-11-01 14:40:19.406049');
INSERT INTO public.bitacora VALUES (2430, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-11-01 14:40:55.345004');
INSERT INTO public.bitacora VALUES (2431, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:40:55.646654');
INSERT INTO public.bitacora VALUES (2432, 1, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-01 14:41:19.334273');
INSERT INTO public.bitacora VALUES (2433, 1, 'GET', 'Trace', NULL, '127.0.0.1', '2026-11-01 14:41:19.48851');
INSERT INTO public.bitacora VALUES (2434, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:41:20.835816');
INSERT INTO public.bitacora VALUES (2435, 1, 'GET', 'Qr', NULL, '127.0.0.1', '2026-11-01 14:41:22.470091');
INSERT INTO public.bitacora VALUES (2436, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:41:23.837689');
INSERT INTO public.bitacora VALUES (2437, 1, 'GET', 'Planes', NULL, '127.0.0.1', '2026-11-01 14:41:25.953298');
INSERT INTO public.bitacora VALUES (2438, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:41:26.055235');
INSERT INTO public.bitacora VALUES (2441, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:42:10.36376');
INSERT INTO public.bitacora VALUES (2443, 1, 'GET', 'Suscripciones', NULL, '127.0.0.1', '2026-11-01 14:42:10.402922');
INSERT INTO public.bitacora VALUES (2444, 1, 'GET', 'Planes', NULL, '127.0.0.1', '2026-11-01 14:46:03.025206');
INSERT INTO public.bitacora VALUES (2447, 1, 'GET', 'Suscripciones', NULL, '127.0.0.1', '2026-11-01 14:46:05.293464');
INSERT INTO public.bitacora VALUES (2449, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:46:48.345331');
INSERT INTO public.bitacora VALUES (2452, 1, 'GET', 'Planes', NULL, '127.0.0.1', '2026-11-01 14:46:57.777636');
INSERT INTO public.bitacora VALUES (2456, 1, 'GET', 'Suscripciones', NULL, '127.0.0.1', '2026-11-01 14:47:45.077446');
INSERT INTO public.bitacora VALUES (2458, 1, 'GET', 'Planes', NULL, '127.0.0.1', '2026-11-01 14:48:10.149709');
INSERT INTO public.bitacora VALUES (2459, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:48:10.170715');
INSERT INTO public.bitacora VALUES (2472, 1, 'GET', 'Trace', NULL, '127.0.0.1', '2026-11-01 14:58:50.510551');
INSERT INTO public.bitacora VALUES (2474, 1, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-01 14:59:03.974894');
INSERT INTO public.bitacora VALUES (2477, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:59:09.103588');
INSERT INTO public.bitacora VALUES (2480, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:59:14.493351');
INSERT INTO public.bitacora VALUES (2483, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:59:28.83469');
INSERT INTO public.bitacora VALUES (2484, 1, 'GET', 'Categories', NULL, '127.0.0.1', '2026-11-01 15:00:08.438429');
INSERT INTO public.bitacora VALUES (2493, 1, 'PATCH', 'Notifications', NULL, '127.0.0.1', '2026-11-01 15:00:32.060621');
INSERT INTO public.bitacora VALUES (2495, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 15:00:34.365678');
INSERT INTO public.bitacora VALUES (2507, 1554, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-01 15:04:12.224207');
INSERT INTO public.bitacora VALUES (2528, 1554, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 15:14:54.971955');
INSERT INTO public.bitacora VALUES (2530, 1554, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-01 15:15:00.248126');
INSERT INTO public.bitacora VALUES (2533, 1554, 'GET', 'Documents', NULL, '127.0.0.1', '2026-11-01 15:15:06.419315');
INSERT INTO public.bitacora VALUES (2540, 1554, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 15:15:44.589946');
INSERT INTO public.bitacora VALUES (1429, 1, 'GET', 'Categories', NULL, '127.0.0.1', '2026-10-01 00:22:02.676117');
INSERT INTO public.bitacora VALUES (665, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:15:57.385158');
INSERT INTO public.bitacora VALUES (668, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:15:57.626922');
INSERT INTO public.bitacora VALUES (671, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:15:57.893384');
INSERT INTO public.bitacora VALUES (1389, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-09-30 23:25:15.325194');
INSERT INTO public.bitacora VALUES (1390, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-09-30 23:25:15.576421');
INSERT INTO public.bitacora VALUES (1391, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-09-30 23:25:20.978162');
INSERT INTO public.bitacora VALUES (1392, 1, 'GET', 'Actors', NULL, '127.0.0.1', '2026-09-30 23:25:21.015725');
INSERT INTO public.bitacora VALUES (1395, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-09-30 23:25:26.902022');
INSERT INTO public.bitacora VALUES (1401, 1, 'GET', 'Locations', NULL, '127.0.0.1', '2026-09-30 23:27:10.664957');
INSERT INTO public.bitacora VALUES (1404, 1, 'GET', 'Locations', NULL, '127.0.0.1', '2026-09-30 23:27:15.5924');
INSERT INTO public.bitacora VALUES (1406, 1, 'GET', 'Roles', NULL, '127.0.0.1', '2026-09-30 23:30:38.586359');
INSERT INTO public.bitacora VALUES (1408, 1, 'GET', 'Users', NULL, '127.0.0.1', '2026-09-30 23:30:38.601537');
INSERT INTO public.bitacora VALUES (1414, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-09-30 23:31:20.704099');
INSERT INTO public.bitacora VALUES (1417, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-09-30 23:34:56.46327');
INSERT INTO public.bitacora VALUES (1418, 1, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-09-30 23:34:56.501526');
INSERT INTO public.bitacora VALUES (1423, 1, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-01 00:21:39.19611');
INSERT INTO public.bitacora VALUES (1425, 1, 'GET', 'Purchases', NULL, '127.0.0.1', '2026-10-01 00:21:49.868442');
INSERT INTO public.bitacora VALUES (1427, 1, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-01 00:21:49.889895');
INSERT INTO public.bitacora VALUES (1430, 1, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-01 00:22:02.760445');
INSERT INTO public.bitacora VALUES (1433, 1, 'GET', 'Purchases', NULL, '127.0.0.1', '2026-10-01 00:22:14.472541');
INSERT INTO public.bitacora VALUES (1436, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-01 00:22:20.856188');
INSERT INTO public.bitacora VALUES (1437, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-01 00:22:26.939898');
INSERT INTO public.bitacora VALUES (1438, 1, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-01 00:22:26.969969');
INSERT INTO public.bitacora VALUES (1441, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-01 00:22:30.226969');
INSERT INTO public.bitacora VALUES (1443, 1, 'GET', 'Qr', NULL, '127.0.0.1', '2026-10-01 00:22:36.801959');
INSERT INTO public.bitacora VALUES (1444, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-01 00:22:59.842479');
INSERT INTO public.bitacora VALUES (1445, 1, 'GET', 'Actors', NULL, '127.0.0.1', '2026-10-01 00:23:02.100485');
INSERT INTO public.bitacora VALUES (1447, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-10-01 00:23:02.112933');
INSERT INTO public.bitacora VALUES (829, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 16:41:07.656122');
INSERT INTO public.bitacora VALUES (830, 1, 'POST', 'Categories', NULL, 'testclient', '2026-09-30 16:41:07.696989');
INSERT INTO public.bitacora VALUES (832, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:41:07.909881');
INSERT INTO public.bitacora VALUES (836, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 16:41:08.178627');
INSERT INTO public.bitacora VALUES (838, 1, 'GET', 'Certifications', NULL, 'testclient', '2026-09-30 16:41:08.431401');
INSERT INTO public.bitacora VALUES (839, 1, 'POST', 'Certifications', NULL, 'testclient', '2026-09-30 16:41:08.464784');
INSERT INTO public.bitacora VALUES (840, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:41:08.516033');
INSERT INTO public.bitacora VALUES (842, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:41:08.724949');
INSERT INTO public.bitacora VALUES (866, 1, 'GET', 'Actors', NULL, 'testclient', '2026-09-30 16:41:15.915347');
INSERT INTO public.bitacora VALUES (867, 1, 'POST', 'Actors', NULL, 'testclient', '2026-09-30 16:41:15.946865');
INSERT INTO public.bitacora VALUES (869, 1, 'GET', 'Locations', NULL, 'testclient', '2026-09-30 16:41:16.17022');
INSERT INTO public.bitacora VALUES (870, 1, 'POST', 'Locations', NULL, 'testclient', '2026-09-30 16:41:16.202128');
INSERT INTO public.bitacora VALUES (872, 1, 'GET', 'Units', NULL, 'testclient', '2026-09-30 16:41:16.449293');
INSERT INTO public.bitacora VALUES (873, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:41:16.490393');
INSERT INTO public.bitacora VALUES (874, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:41:16.524335');
INSERT INTO public.bitacora VALUES (875, 1, 'POST', 'Units', NULL, 'testclient', '2026-09-30 16:41:16.575123');
INSERT INTO public.bitacora VALUES (896, 1, 'GET', 'Categories', NULL, 'testclient', '2026-09-30 16:45:38.14418');
INSERT INTO public.bitacora VALUES (897, 1, 'POST', 'Categories', NULL, 'testclient', '2026-09-30 16:45:38.194159');
INSERT INTO public.bitacora VALUES (899, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:45:38.393906');
INSERT INTO public.bitacora VALUES (903, 1, 'GET', 'Products', NULL, 'testclient', '2026-09-30 16:45:38.643667');
INSERT INTO public.bitacora VALUES (905, 1, 'GET', 'Certifications', NULL, 'testclient', '2026-09-30 16:45:38.866101');
INSERT INTO public.bitacora VALUES (906, 1, 'POST', 'Certifications', NULL, 'testclient', '2026-09-30 16:45:38.911736');
INSERT INTO public.bitacora VALUES (907, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:45:38.960275');
INSERT INTO public.bitacora VALUES (909, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:45:39.184917');
INSERT INTO public.bitacora VALUES (932, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:45:48.147541');
INSERT INTO public.bitacora VALUES (935, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:45:48.39382');
INSERT INTO public.bitacora VALUES (938, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-09-30 16:45:48.650164');
INSERT INTO public.bitacora VALUES (1448, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-01 00:23:12.654944');
INSERT INTO public.bitacora VALUES (1451, 1, 'GET', 'Purchases', NULL, '127.0.0.1', '2026-10-01 00:23:14.506697');
INSERT INTO public.bitacora VALUES (1452, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-01 00:23:16.685751');
INSERT INTO public.bitacora VALUES (1454, 1, 'GENERAR_QR', 'CodigoQR', 64, '127.0.0.1', '2026-10-01 00:23:19.998925');
INSERT INTO public.bitacora VALUES (1457, 1, 'GET', 'Qr', NULL, '127.0.0.1', '2026-10-01 00:23:20.252783');
INSERT INTO public.bitacora VALUES (1458, 1, 'GET', 'Qr', NULL, '127.0.0.1', '2026-10-01 00:24:09.262455');
INSERT INTO public.bitacora VALUES (1460, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-01 00:24:10.220135');
INSERT INTO public.bitacora VALUES (1461, 1, 'POST', 'Auth', NULL, '127.0.0.1', '2026-10-01 00:24:12.561703');
INSERT INTO public.bitacora VALUES (1463, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 17:44:07.807795');
INSERT INTO public.bitacora VALUES (1465, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 17:44:36.829853');
INSERT INTO public.bitacora VALUES (1467, 1, 'POST', 'Ai', NULL, '127.0.0.1', '2026-10-05 17:45:49.204468');
INSERT INTO public.bitacora VALUES (1468, 1, 'GET', 'Ai', NULL, '127.0.0.1', '2026-10-05 17:51:27.482701');
INSERT INTO public.bitacora VALUES (1469, 1, 'POST', 'Auth', NULL, '127.0.0.1', '2026-10-05 17:53:10.635374');
INSERT INTO public.bitacora VALUES (1471, 1553, 'GET', 'Auth', NULL, '127.0.0.1', '2026-10-05 17:53:11.494172');
INSERT INTO public.bitacora VALUES (1475, 1556, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 17:53:46.31987');
INSERT INTO public.bitacora VALUES (1477, 1556, 'POST', 'Auth', NULL, '127.0.0.1', '2026-10-05 17:53:58.150098');
INSERT INTO public.bitacora VALUES (1480, 1556, 'POST', 'Ai', NULL, '127.0.0.1', '2026-10-05 17:54:13.44267');
INSERT INTO public.bitacora VALUES (1481, 1556, 'GET', 'Actors', NULL, '127.0.0.1', '2026-10-05 17:56:51.792835');
INSERT INTO public.bitacora VALUES (1482, 1556, 'GET', 'Purchases', NULL, '127.0.0.1', '2026-10-05 17:56:51.807341');
INSERT INTO public.bitacora VALUES (1483, 1556, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 17:56:51.813837');
INSERT INTO public.bitacora VALUES (1484, 1556, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 17:57:17.090262');
INSERT INTO public.bitacora VALUES (1486, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 17:57:22.425427');
INSERT INTO public.bitacora VALUES (1490, 1553, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 17:57:27.963594');
INSERT INTO public.bitacora VALUES (1491, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 17:57:33.045228');
INSERT INTO public.bitacora VALUES (1495, 1553, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-05 18:10:05.98283');
INSERT INTO public.bitacora VALUES (1497, 1553, 'GET', 'Actors', NULL, '127.0.0.1', '2026-10-05 18:10:08.282381');
INSERT INTO public.bitacora VALUES (1501, 1553, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-05 18:10:19.575768');
INSERT INTO public.bitacora VALUES (1503, 1553, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 18:10:27.927206');
INSERT INTO public.bitacora VALUES (1505, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:10:32.894367');
INSERT INTO public.bitacora VALUES (1507, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:10:39.361771');
INSERT INTO public.bitacora VALUES (1509, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:10:41.504495');
INSERT INTO public.bitacora VALUES (1510, 1553, 'GET', 'Categories', NULL, '127.0.0.1', '2026-10-05 18:10:42.360234');
INSERT INTO public.bitacora VALUES (1511, 1553, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-05 18:10:42.408369');
INSERT INTO public.bitacora VALUES (1514, 1553, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-05 18:10:45.75419');
INSERT INTO public.bitacora VALUES (1515, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:10:46.745963');
INSERT INTO public.bitacora VALUES (1516, 1553, 'GET', 'Certifications', NULL, '127.0.0.1', '2026-10-05 18:10:47.344041');
INSERT INTO public.bitacora VALUES (1519, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:10:49.765225');
INSERT INTO public.bitacora VALUES (1520, 1553, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 18:10:49.834527');
INSERT INTO public.bitacora VALUES (1521, 1553, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-05 18:10:49.860746');
INSERT INTO public.bitacora VALUES (1524, 1553, 'GET', 'Locations', NULL, '127.0.0.1', '2026-10-05 18:10:52.452586');
INSERT INTO public.bitacora VALUES (1528, 1553, 'GET', 'Locations', NULL, '127.0.0.1', '2026-10-05 18:10:54.813408');
INSERT INTO public.bitacora VALUES (1530, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:10:55.7454');
INSERT INTO public.bitacora VALUES (1531, 1553, 'GET', 'Actors', NULL, '127.0.0.1', '2026-10-05 18:10:57.396879');
INSERT INTO public.bitacora VALUES (1532, 1553, 'GET', 'Purchases', NULL, '127.0.0.1', '2026-10-05 18:10:57.416222');
INSERT INTO public.bitacora VALUES (1533, 1553, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 18:10:57.440745');
INSERT INTO public.bitacora VALUES (1534, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:10:58.320085');
INSERT INTO public.bitacora VALUES (1535, 1553, 'GET', 'Locations', NULL, '127.0.0.1', '2026-10-05 18:10:59.093954');
INSERT INTO public.bitacora VALUES (1537, 1553, 'GET', 'Receptions', NULL, '127.0.0.1', '2026-10-05 18:10:59.129967');
INSERT INTO public.bitacora VALUES (1539, 1553, 'GET', 'Qr', NULL, '127.0.0.1', '2026-10-05 18:11:02.09321');
INSERT INTO public.bitacora VALUES (1544, 1553, 'GET', 'Notifications', NULL, '127.0.0.1', '2026-10-05 18:11:10.041063');
INSERT INTO public.bitacora VALUES (1545, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:11:15.738351');
INSERT INTO public.bitacora VALUES (1546, 1553, 'GET', 'Actors', NULL, '127.0.0.1', '2026-10-05 18:11:53.279824');
INSERT INTO public.bitacora VALUES (1548, 1553, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 18:11:53.349689');
INSERT INTO public.bitacora VALUES (1554, 1, 'POST', 'Shipments', NULL, '127.0.0.1', '2026-10-05 18:13:10.918369');
INSERT INTO public.bitacora VALUES (1555, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-10-05 18:13:10.961686');
INSERT INTO public.bitacora VALUES (1556, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-10-05 18:13:18.64429');
INSERT INTO public.bitacora VALUES (1557, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-10-05 18:13:24.410135');
INSERT INTO public.bitacora VALUES (1558, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-10-05 18:13:25.456062');
INSERT INTO public.bitacora VALUES (666, 1, 'GET', 'Actors', NULL, 'testclient', '2026-09-30 16:15:57.416932');
INSERT INTO public.bitacora VALUES (667, 1, 'POST', 'Actors', NULL, 'testclient', '2026-09-30 16:15:57.464771');
INSERT INTO public.bitacora VALUES (669, 1, 'GET', 'Locations', NULL, 'testclient', '2026-09-30 16:15:57.687406');
INSERT INTO public.bitacora VALUES (670, 1, 'POST', 'Locations', NULL, 'testclient', '2026-09-30 16:15:57.725616');
INSERT INTO public.bitacora VALUES (672, 1, 'GET', 'Units', NULL, 'testclient', '2026-09-30 16:15:57.973187');
INSERT INTO public.bitacora VALUES (673, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:15:58.009564');
INSERT INTO public.bitacora VALUES (674, 1, 'POST', 'Products', NULL, 'testclient', '2026-09-30 16:15:58.051998');
INSERT INTO public.bitacora VALUES (675, 1, 'POST', 'Units', NULL, 'testclient', '2026-09-30 16:15:58.101964');
INSERT INTO public.bitacora VALUES (1393, 1, 'GET', 'Locations', NULL, '127.0.0.1', '2026-09-30 23:25:21.024643');
INSERT INTO public.bitacora VALUES (1396, 1, 'GET', 'Qr', NULL, '127.0.0.1', '2026-09-30 23:26:42.788332');
INSERT INTO public.bitacora VALUES (1399, 1, 'GET', 'Actors', NULL, '127.0.0.1', '2026-09-30 23:26:55.11638');
INSERT INTO public.bitacora VALUES (1402, 1, 'GET', 'Locations', NULL, '127.0.0.1', '2026-09-30 23:27:12.222704');
INSERT INTO public.bitacora VALUES (1405, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-09-30 23:27:17.601004');
INSERT INTO public.bitacora VALUES (1409, 1, 'GET', 'Users', NULL, '127.0.0.1', '2026-09-30 23:30:39.81477');
INSERT INTO public.bitacora VALUES (1410, 1, 'POST', 'Users', NULL, '127.0.0.1', '2026-09-30 23:30:56.815281');
INSERT INTO public.bitacora VALUES (1413, 1, 'GET', 'Products', NULL, '127.0.0.1', '2026-09-30 23:31:13.760152');
INSERT INTO public.bitacora VALUES (1416, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-09-30 23:31:25.765699');
INSERT INTO public.bitacora VALUES (1419, 1, 'GET', 'Products', NULL, '127.0.0.1', '2026-09-30 23:34:56.530292');
INSERT INTO public.bitacora VALUES (1420, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-01 00:21:35.090681');
INSERT INTO public.bitacora VALUES (1424, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-01 00:21:44.629546');
INSERT INTO public.bitacora VALUES (1428, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-01 00:21:53.403521');
INSERT INTO public.bitacora VALUES (1431, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-01 00:22:06.769831');
INSERT INTO public.bitacora VALUES (1435, 1, 'GET', 'Purchases', NULL, '127.0.0.1', '2026-10-01 00:22:18.981267');
INSERT INTO public.bitacora VALUES (1439, 1, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-01 00:22:26.996364');
INSERT INTO public.bitacora VALUES (1442, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-01 00:22:34.314075');
INSERT INTO public.bitacora VALUES (1446, 1, 'GET', 'Locations', NULL, '127.0.0.1', '2026-10-01 00:23:02.105125');
INSERT INTO public.bitacora VALUES (1449, 1, 'GET', 'Locations', NULL, '127.0.0.1', '2026-10-01 00:23:14.487592');
INSERT INTO public.bitacora VALUES (1450, 1, 'GET', 'Receptions', NULL, '127.0.0.1', '2026-10-01 00:23:14.499955');
INSERT INTO public.bitacora VALUES (1453, 1, 'GET', 'Qr', NULL, '127.0.0.1', '2026-10-01 00:23:18.089435');
INSERT INTO public.bitacora VALUES (1455, 1, 'POST', 'Qr', NULL, '127.0.0.1', '2026-10-01 00:23:20.052188');
INSERT INTO public.bitacora VALUES (1456, 1, 'GET', 'Qr', NULL, '127.0.0.1', '2026-10-01 00:23:20.124485');
INSERT INTO public.bitacora VALUES (1459, 1, 'GET', 'Auth', NULL, '127.0.0.1', '2026-10-01 00:24:09.319417');
INSERT INTO public.bitacora VALUES (1462, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-10-05 17:44:07.538437');
INSERT INTO public.bitacora VALUES (1464, 1, 'GET', 'Qr', NULL, '127.0.0.1', '2026-10-05 17:44:33.424461');
INSERT INTO public.bitacora VALUES (1466, 1, 'POST', 'Ai', NULL, '127.0.0.1', '2026-10-05 17:45:11.487134');
INSERT INTO public.bitacora VALUES (1470, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 17:53:11.413163');
INSERT INTO public.bitacora VALUES (1472, 1553, 'POST', 'Ai', NULL, '127.0.0.1', '2026-10-05 17:53:21.381329');
INSERT INTO public.bitacora VALUES (1473, 1553, 'GET', 'Ai', NULL, '127.0.0.1', '2026-10-05 17:53:28.208385');
INSERT INTO public.bitacora VALUES (1474, 1553, 'POST', 'Auth', NULL, '127.0.0.1', '2026-10-05 17:53:46.084154');
INSERT INTO public.bitacora VALUES (1476, 1556, 'GET', 'Auth', NULL, '127.0.0.1', '2026-10-05 17:53:46.345475');
INSERT INTO public.bitacora VALUES (1478, 1556, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 17:53:58.451355');
INSERT INTO public.bitacora VALUES (1479, 1556, 'GET', 'Auth', NULL, '127.0.0.1', '2026-10-05 17:53:58.475328');
INSERT INTO public.bitacora VALUES (1485, 1556, 'POST', 'Auth', NULL, '127.0.0.1', '2026-10-05 17:57:22.139814');
INSERT INTO public.bitacora VALUES (1487, 1553, 'GET', 'Auth', NULL, '127.0.0.1', '2026-10-05 17:57:22.468863');
INSERT INTO public.bitacora VALUES (2439, 1, 'GET', 'Suscripciones', NULL, '127.0.0.1', '2026-11-01 14:41:26.104268');
INSERT INTO public.bitacora VALUES (2450, 1, 'GET', 'Planes', NULL, '127.0.0.1', '2026-11-01 14:46:53.050855');
INSERT INTO public.bitacora VALUES (2454, 1, 'GET', 'Planes', NULL, '127.0.0.1', '2026-11-01 14:47:45.039621');
INSERT INTO public.bitacora VALUES (1488, 1553, 'GET', 'Actors', NULL, '127.0.0.1', '2026-10-05 17:57:27.891411');
INSERT INTO public.bitacora VALUES (1489, 1553, 'GET', 'Purchases', NULL, '127.0.0.1', '2026-10-05 17:57:27.919258');
INSERT INTO public.bitacora VALUES (1492, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:09:50.070758');
INSERT INTO public.bitacora VALUES (1493, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:09:53.978551');
INSERT INTO public.bitacora VALUES (1494, 1553, 'GET', 'Categories', NULL, '127.0.0.1', '2026-10-05 18:10:05.902502');
INSERT INTO public.bitacora VALUES (1496, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:10:07.256154');
INSERT INTO public.bitacora VALUES (1498, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:10:17.26411');
INSERT INTO public.bitacora VALUES (1499, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:10:19.491908');
INSERT INTO public.bitacora VALUES (1500, 1553, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 18:10:19.549515');
INSERT INTO public.bitacora VALUES (1502, 1553, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 18:10:25.727926');
INSERT INTO public.bitacora VALUES (1504, 1553, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 18:10:30.259768');
INSERT INTO public.bitacora VALUES (1506, 1553, 'GET', 'Categories', NULL, '127.0.0.1', '2026-10-05 18:10:37.867661');
INSERT INTO public.bitacora VALUES (1508, 1553, 'GET', 'Categories', NULL, '127.0.0.1', '2026-10-05 18:10:40.20367');
INSERT INTO public.bitacora VALUES (1512, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:10:43.459061');
INSERT INTO public.bitacora VALUES (1513, 1553, 'GET', 'Categories', NULL, '127.0.0.1', '2026-10-05 18:10:45.697092');
INSERT INTO public.bitacora VALUES (1517, 1553, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-05 18:10:47.402512');
INSERT INTO public.bitacora VALUES (1518, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:10:48.588302');
INSERT INTO public.bitacora VALUES (1522, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:10:50.666495');
INSERT INTO public.bitacora VALUES (1523, 1553, 'GET', 'Actors', NULL, '127.0.0.1', '2026-10-05 18:10:52.440464');
INSERT INTO public.bitacora VALUES (1525, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:10:53.557645');
INSERT INTO public.bitacora VALUES (1526, 1553, 'GET', 'Actors', NULL, '127.0.0.1', '2026-10-05 18:10:54.752359');
INSERT INTO public.bitacora VALUES (1527, 1553, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-05 18:10:54.784246');
INSERT INTO public.bitacora VALUES (1529, 1553, 'GET', 'Units', NULL, '127.0.0.1', '2026-10-05 18:10:54.846209');
INSERT INTO public.bitacora VALUES (1536, 1553, 'GET', 'Purchases', NULL, '127.0.0.1', '2026-10-05 18:10:59.113609');
INSERT INTO public.bitacora VALUES (1538, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:11:00.898706');
INSERT INTO public.bitacora VALUES (1540, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:11:03.021616');
INSERT INTO public.bitacora VALUES (1541, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:11:04.170876');
INSERT INTO public.bitacora VALUES (1542, 1553, 'GET', 'Users', NULL, '127.0.0.1', '2026-10-05 18:11:04.181736');
INSERT INTO public.bitacora VALUES (1543, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:11:09.004217');
INSERT INTO public.bitacora VALUES (1547, 1553, 'GET', 'Purchases', NULL, '127.0.0.1', '2026-10-05 18:11:53.290368');
INSERT INTO public.bitacora VALUES (1549, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:12:20.171096');
INSERT INTO public.bitacora VALUES (1550, 1, 'GET', 'Actors', NULL, '127.0.0.1', '2026-10-05 18:12:24.092866');
INSERT INTO public.bitacora VALUES (1551, 1, 'GET', 'Locations', NULL, '127.0.0.1', '2026-10-05 18:12:24.108468');
INSERT INTO public.bitacora VALUES (1552, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-10-05 18:12:24.117787');
INSERT INTO public.bitacora VALUES (1553, 1, 'REGISTRAR_EVENTO_TRANSPORTE', 'EventoTrazabilidad', 35, '127.0.0.1', '2026-10-05 18:13:10.842832');
INSERT INTO public.bitacora VALUES (1559, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-10-05 18:13:25.924434');
INSERT INTO public.bitacora VALUES (1560, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-10-05 18:13:28.505153');
INSERT INTO public.bitacora VALUES (1561, 1, 'PATCH', 'Shipments', NULL, '127.0.0.1', '2026-10-05 18:13:36.52741');
INSERT INTO public.bitacora VALUES (1562, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-10-05 18:13:36.560871');
INSERT INTO public.bitacora VALUES (1563, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-10-05 18:13:36.56877');
INSERT INTO public.bitacora VALUES (1564, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-10-05 18:13:43.613334');
INSERT INTO public.bitacora VALUES (1565, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:14:08.479914');
INSERT INTO public.bitacora VALUES (1566, 1, 'POST', 'Auth', NULL, '127.0.0.1', '2026-10-05 18:14:26.810459');
INSERT INTO public.bitacora VALUES (1567, 2, 'LOGIN', 'Autenticacion', 2, '127.0.0.1', '2026-10-05 18:19:37.866423');
INSERT INTO public.bitacora VALUES (1568, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:19:38.035402');
INSERT INTO public.bitacora VALUES (1569, 2, 'POST', 'Ai', NULL, '127.0.0.1', '2026-10-05 18:20:00.382235');
INSERT INTO public.bitacora VALUES (1570, 2, 'GET', 'Ai', NULL, '127.0.0.1', '2026-10-05 18:20:07.244925');
INSERT INTO public.bitacora VALUES (1571, 2, 'GET', 'Actors', NULL, '127.0.0.1', '2026-10-05 18:20:30.283676');
INSERT INTO public.bitacora VALUES (1572, 2, 'GET', 'Purchases', NULL, '127.0.0.1', '2026-10-05 18:20:30.296171');
INSERT INTO public.bitacora VALUES (1573, 2, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 18:20:30.311685');
INSERT INTO public.bitacora VALUES (1574, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:20:33.733184');
INSERT INTO public.bitacora VALUES (1575, 2, 'GET', 'Locations', NULL, '127.0.0.1', '2026-10-05 18:20:35.051908');
INSERT INTO public.bitacora VALUES (1576, 2, 'GET', 'Purchases', NULL, '127.0.0.1', '2026-10-05 18:20:35.058872');
INSERT INTO public.bitacora VALUES (1577, 2, 'GET', 'Receptions', NULL, '127.0.0.1', '2026-10-05 18:20:35.069598');
INSERT INTO public.bitacora VALUES (1578, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:20:37.725469');
INSERT INTO public.bitacora VALUES (1579, 2, 'GET', 'Qr', NULL, '127.0.0.1', '2026-10-05 18:20:38.666551');
INSERT INTO public.bitacora VALUES (1580, 2, 'GET', 'Qr', NULL, '127.0.0.1', '2026-10-05 18:20:42.960236');
INSERT INTO public.bitacora VALUES (1581, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 18:27:18.280039');
INSERT INTO public.bitacora VALUES (1582, 2, 'POST', 'Auth', NULL, '127.0.0.1', '2026-10-05 18:27:21.100336');
INSERT INTO public.bitacora VALUES (1583, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 20:30:26.786486');
INSERT INTO public.bitacora VALUES (1584, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-10-05 20:30:26.913817');
INSERT INTO public.bitacora VALUES (1585, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 20:30:27.028715');
INSERT INTO public.bitacora VALUES (1586, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 20:31:16.500955');
INSERT INTO public.bitacora VALUES (1587, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-10-05 20:31:16.595626');
INSERT INTO public.bitacora VALUES (1588, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 20:31:16.722776');
INSERT INTO public.bitacora VALUES (1589, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 20:31:57.695799');
INSERT INTO public.bitacora VALUES (1590, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-10-05 20:31:57.917255');
INSERT INTO public.bitacora VALUES (2455, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:47:45.059612');
INSERT INTO public.bitacora VALUES (1591, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 20:31:58.043826');
INSERT INTO public.bitacora VALUES (1592, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 20:32:14.007975');
INSERT INTO public.bitacora VALUES (1593, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-10-05 20:32:14.112953');
INSERT INTO public.bitacora VALUES (1594, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 20:32:14.225903');
INSERT INTO public.bitacora VALUES (2440, 1, 'GET', 'Planes', NULL, '127.0.0.1', '2026-11-01 14:41:32.250917');
INSERT INTO public.bitacora VALUES (2442, 1, 'GET', 'Planes', NULL, '127.0.0.1', '2026-11-01 14:42:10.376567');
INSERT INTO public.bitacora VALUES (2445, 1, 'GET', 'Planes', NULL, '127.0.0.1', '2026-11-01 14:46:05.247352');
INSERT INTO public.bitacora VALUES (2446, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:46:05.274537');
INSERT INTO public.bitacora VALUES (2448, 1, 'GET', 'Planes', NULL, '127.0.0.1', '2026-11-01 14:46:46.630986');
INSERT INTO public.bitacora VALUES (2451, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:46:56.105406');
INSERT INTO public.bitacora VALUES (1601, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 20:32:32.740921');
INSERT INTO public.bitacora VALUES (1602, 1, 'GET', 'Categories', NULL, 'testclient', '2026-10-05 20:32:32.842444');
INSERT INTO public.bitacora VALUES (1603, 1, 'POST', 'Categories', NULL, 'testclient', '2026-10-05 20:32:32.881584');
INSERT INTO public.bitacora VALUES (1604, 1, 'GET', 'Categories', NULL, 'testclient', '2026-10-05 20:32:32.913412');
INSERT INTO public.bitacora VALUES (1605, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 20:32:33.020304');
INSERT INTO public.bitacora VALUES (1606, 1, 'GET', 'Products', NULL, 'testclient', '2026-10-05 20:32:33.123231');
INSERT INTO public.bitacora VALUES (1607, 1, 'POST', 'Products', NULL, 'testclient', '2026-10-05 20:32:33.152224');
INSERT INTO public.bitacora VALUES (1608, 1, 'POST', 'Products', NULL, 'testclient', '2026-10-05 20:32:33.18781');
INSERT INTO public.bitacora VALUES (1609, 1, 'GET', 'Products', NULL, 'testclient', '2026-10-05 20:32:33.21567');
INSERT INTO public.bitacora VALUES (1610, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 20:32:33.320346');
INSERT INTO public.bitacora VALUES (1611, 1, 'GET', 'Certifications', NULL, 'testclient', '2026-10-05 20:32:33.360266');
INSERT INTO public.bitacora VALUES (1612, 1, 'POST', 'Certifications', NULL, 'testclient', '2026-10-05 20:32:33.395474');
INSERT INTO public.bitacora VALUES (1613, 1, 'POST', 'Products', NULL, 'testclient', '2026-10-05 20:32:33.427581');
INSERT INTO public.bitacora VALUES (1614, 1, 'GET', 'Products', NULL, 'testclient', '2026-10-05 20:32:33.45507');
INSERT INTO public.bitacora VALUES (1615, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 20:32:33.570427');
INSERT INTO public.bitacora VALUES (1616, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-10-05 20:32:33.640434');
INSERT INTO public.bitacora VALUES (1617, 1, 'POST', 'Products', NULL, 'testclient', '2026-10-05 20:32:33.665568');
INSERT INTO public.bitacora VALUES (1618, 1, 'POST', 'Products', NULL, 'testclient', '2026-10-05 20:32:33.688393');
INSERT INTO public.bitacora VALUES (1619, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-10-05 20:32:33.725397');
INSERT INTO public.bitacora VALUES (1620, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 20:32:36.505385');
INSERT INTO public.bitacora VALUES (1621, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-10-05 20:32:36.553085');
INSERT INTO public.bitacora VALUES (1622, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 20:32:36.664515');
INSERT INTO public.bitacora VALUES (2453, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:47:43.531647');
INSERT INTO public.bitacora VALUES (2457, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:48:06.803749');
INSERT INTO public.bitacora VALUES (2461, 1, 'GET', 'Planes', NULL, '127.0.0.1', '2026-11-01 14:48:13.80463');
INSERT INTO public.bitacora VALUES (2464, 1, 'GET', 'Alerts', NULL, '127.0.0.1', '2026-11-01 14:50:35.899533');
INSERT INTO public.bitacora VALUES (2469, 1, 'GET', 'Certificates', NULL, '127.0.0.1', '2026-11-01 14:55:38.594541');
INSERT INTO public.bitacora VALUES (2471, 1, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-01 14:58:50.263713');
INSERT INTO public.bitacora VALUES (2482, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-11-01 14:59:28.645582');
INSERT INTO public.bitacora VALUES (2485, 1, 'GET', 'Products', NULL, '127.0.0.1', '2026-11-01 15:00:08.543933');
INSERT INTO public.bitacora VALUES (2492, 1, 'GET', 'Notifications', NULL, '127.0.0.1', '2026-11-01 15:00:25.191915');
INSERT INTO public.bitacora VALUES (2497, 1553, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 15:00:44.094282');
INSERT INTO public.bitacora VALUES (2499, 1553, 'POST', 'Auth', NULL, '127.0.0.1', '2026-11-01 15:00:53.548798');
INSERT INTO public.bitacora VALUES (2501, 1554, 'GET', 'Auth', NULL, '127.0.0.1', '2026-11-01 15:00:54.017723');
INSERT INTO public.bitacora VALUES (2503, 1554, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 15:01:02.57062');
INSERT INTO public.bitacora VALUES (2504, 1554, 'GET', 'Qr', NULL, '127.0.0.1', '2026-11-01 15:03:53.175666');
INSERT INTO public.bitacora VALUES (2506, 1554, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 15:04:10.536092');
INSERT INTO public.bitacora VALUES (2529, 1554, 'GET', 'Auth', NULL, '127.0.0.1', '2026-11-01 15:14:55.221889');
INSERT INTO public.bitacora VALUES (2535, 1554, 'GET', 'Documents', NULL, '127.0.0.1', '2026-11-01 15:15:18.978922');
INSERT INTO public.bitacora VALUES (2537, 1554, 'GET', 'Documents', NULL, '127.0.0.1', '2026-11-01 15:15:22.046585');
INSERT INTO public.bitacora VALUES (2539, 1554, 'GET', 'Documents', NULL, '127.0.0.1', '2026-11-01 15:15:26.834938');
INSERT INTO public.bitacora VALUES (1675, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 20:32:47.222563');
INSERT INTO public.bitacora VALUES (1676, 1, 'GET', 'Actors', NULL, 'testclient', '2026-10-05 20:32:47.267812');
INSERT INTO public.bitacora VALUES (1677, 1, 'POST', 'Actors', NULL, 'testclient', '2026-10-05 20:32:47.284761');
INSERT INTO public.bitacora VALUES (1678, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 20:32:47.395875');
INSERT INTO public.bitacora VALUES (1679, 1, 'GET', 'Locations', NULL, 'testclient', '2026-10-05 20:32:47.446141');
INSERT INTO public.bitacora VALUES (1680, 1, 'POST', 'Locations', NULL, 'testclient', '2026-10-05 20:32:47.47204');
INSERT INTO public.bitacora VALUES (1681, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 20:32:47.568593');
INSERT INTO public.bitacora VALUES (1682, 1, 'GET', 'Units', NULL, 'testclient', '2026-10-05 20:32:47.644135');
INSERT INTO public.bitacora VALUES (1683, 1, 'POST', 'Products', NULL, 'testclient', '2026-10-05 20:32:47.665415');
INSERT INTO public.bitacora VALUES (1684, 1, 'POST', 'Products', NULL, 'testclient', '2026-10-05 20:32:47.691873');
INSERT INTO public.bitacora VALUES (1685, 1, 'POST', 'Units', NULL, 'testclient', '2026-10-05 20:32:47.723472');
INSERT INTO public.bitacora VALUES (2162, 1, 'POST', 'Tenants', NULL, 'testclient', '2026-11-01 14:09:22.120043');
INSERT INTO public.bitacora VALUES (2163, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-11-01 14:09:22.169992');
INSERT INTO public.bitacora VALUES (2168, 1, 'POST', 'Tenants', NULL, 'testclient', '2026-11-01 14:09:24.145596');
INSERT INTO public.bitacora VALUES (2169, 1, 'POST', 'Auth', NULL, 'testclient', '2026-11-01 14:09:24.190598');
INSERT INTO public.bitacora VALUES (2170, 1, 'GET', 'Auth', NULL, 'testclient', '2026-11-01 14:09:24.223895');
INSERT INTO public.bitacora VALUES (2460, 1, 'GET', 'Suscripciones', NULL, '127.0.0.1', '2026-11-01 14:48:10.20436');
INSERT INTO public.bitacora VALUES (2466, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:51:09.678749');
INSERT INTO public.bitacora VALUES (2467, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:52:02.01344');
INSERT INTO public.bitacora VALUES (2468, 1, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-01 14:54:53.043611');
INSERT INTO public.bitacora VALUES (2470, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:58:38.42208');
INSERT INTO public.bitacora VALUES (1698, 2, 'LOGIN', 'Autenticacion', 2, '127.0.0.1', '2026-10-05 20:39:24.75718');
INSERT INTO public.bitacora VALUES (1699, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:39:25.329415');
INSERT INTO public.bitacora VALUES (1700, 2, 'GET', 'Categories', NULL, '127.0.0.1', '2026-10-05 20:39:33.513013');
INSERT INTO public.bitacora VALUES (1701, 2, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-05 20:39:33.55113');
INSERT INTO public.bitacora VALUES (1702, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:39:36.205586');
INSERT INTO public.bitacora VALUES (1703, 2, 'GET', 'Categories', NULL, '127.0.0.1', '2026-10-05 20:39:40.562926');
INSERT INTO public.bitacora VALUES (1704, 2, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-05 20:39:40.807678');
INSERT INTO public.bitacora VALUES (1705, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:39:43.570996');
INSERT INTO public.bitacora VALUES (1706, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:39:48.254203');
INSERT INTO public.bitacora VALUES (1707, 2, 'GET', 'Users', NULL, '127.0.0.1', '2026-10-05 20:39:48.345741');
INSERT INTO public.bitacora VALUES (1708, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:39:51.001964');
INSERT INTO public.bitacora VALUES (1709, 2, 'GET', 'Categories', NULL, '127.0.0.1', '2026-10-05 20:41:33.608321');
INSERT INTO public.bitacora VALUES (1710, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:41:35.671793');
INSERT INTO public.bitacora VALUES (1711, 2, 'GET', 'Notifications', NULL, '127.0.0.1', '2026-10-05 20:41:37.868488');
INSERT INTO public.bitacora VALUES (1712, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:41:39.394053');
INSERT INTO public.bitacora VALUES (1713, 2, 'GET', 'Certifications', NULL, '127.0.0.1', '2026-10-05 20:41:41.65934');
INSERT INTO public.bitacora VALUES (1714, 2, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-05 20:41:41.783887');
INSERT INTO public.bitacora VALUES (1715, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:41:42.669492');
INSERT INTO public.bitacora VALUES (1716, 2, 'GET', 'Actors', NULL, '127.0.0.1', '2026-10-05 20:41:43.331682');
INSERT INTO public.bitacora VALUES (1717, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:41:44.31366');
INSERT INTO public.bitacora VALUES (1718, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:41:45.330911');
INSERT INTO public.bitacora VALUES (1719, 2, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:41:45.35364');
INSERT INTO public.bitacora VALUES (1720, 2, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-05 20:41:45.398037');
INSERT INTO public.bitacora VALUES (1721, 2, 'POST', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:41:47.208433');
INSERT INTO public.bitacora VALUES (1722, 2, 'POST', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:41:50.165317');
INSERT INTO public.bitacora VALUES (1723, 2, 'POST', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:42:32.008904');
INSERT INTO public.bitacora VALUES (1724, 2, 'POST', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:42:32.529515');
INSERT INTO public.bitacora VALUES (1725, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:43:39.726575');
INSERT INTO public.bitacora VALUES (1726, 2, 'GET', 'Auth', NULL, '127.0.0.1', '2026-10-05 20:43:39.763394');
INSERT INTO public.bitacora VALUES (1727, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:43:42.28706');
INSERT INTO public.bitacora VALUES (1728, 2, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:43:42.336673');
INSERT INTO public.bitacora VALUES (1729, 2, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-05 20:43:42.381871');
INSERT INTO public.bitacora VALUES (1730, 2, 'POST', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:43:43.110602');
INSERT INTO public.bitacora VALUES (1731, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:44:02.094508');
INSERT INTO public.bitacora VALUES (1732, 2, 'GET', 'Auth', NULL, '127.0.0.1', '2026-10-05 20:44:02.122931');
INSERT INTO public.bitacora VALUES (1733, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:44:04.544218');
INSERT INTO public.bitacora VALUES (1734, 2, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:44:04.592582');
INSERT INTO public.bitacora VALUES (1735, 2, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-05 20:44:04.635093');
INSERT INTO public.bitacora VALUES (1736, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:46:12.518544');
INSERT INTO public.bitacora VALUES (1737, 2, 'LOGIN', 'Autenticacion', 2, '127.0.0.1', '2026-10-05 20:53:24.352804');
INSERT INTO public.bitacora VALUES (1738, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:53:24.561097');
INSERT INTO public.bitacora VALUES (1739, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:53:27.62477');
INSERT INTO public.bitacora VALUES (1740, 2, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:53:27.694681');
INSERT INTO public.bitacora VALUES (1741, 2, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-05 20:53:27.742606');
INSERT INTO public.bitacora VALUES (1742, 2, 'POST', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:53:28.76151');
INSERT INTO public.bitacora VALUES (1743, 2, 'POST', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:53:30.664714');
INSERT INTO public.bitacora VALUES (1744, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:53:43.927099');
INSERT INTO public.bitacora VALUES (1745, 2, 'POST', 'Auth', NULL, '127.0.0.1', '2026-10-05 20:53:44.951799');
INSERT INTO public.bitacora VALUES (1746, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-10-05 20:54:00.865118');
INSERT INTO public.bitacora VALUES (1747, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:54:00.957578');
INSERT INTO public.bitacora VALUES (1748, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:54:04.642892');
INSERT INTO public.bitacora VALUES (1749, 1, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:54:04.692417');
INSERT INTO public.bitacora VALUES (1750, 1, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-05 20:54:04.728163');
INSERT INTO public.bitacora VALUES (1751, 1, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:54:10.205535');
INSERT INTO public.bitacora VALUES (1752, 1, 'POST', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:54:14.663475');
INSERT INTO public.bitacora VALUES (1753, 1, 'POST', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:54:15.259139');
INSERT INTO public.bitacora VALUES (1754, 1, 'POST', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:54:15.474728');
INSERT INTO public.bitacora VALUES (1755, 1, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:54:18.564356');
INSERT INTO public.bitacora VALUES (1756, 1, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:54:22.316118');
INSERT INTO public.bitacora VALUES (1757, 1, 'POST', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:54:24.426082');
INSERT INTO public.bitacora VALUES (1758, 1, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:54:28.333076');
INSERT INTO public.bitacora VALUES (1759, 1, 'POST', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:54:30.661455');
INSERT INTO public.bitacora VALUES (1760, 1, 'POST', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 20:54:31.560771');
INSERT INTO public.bitacora VALUES (1761, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 20:54:40.045365');
INSERT INTO public.bitacora VALUES (1762, 1, 'POST', 'Auth', NULL, '127.0.0.1', '2026-10-05 20:54:41.499588');
INSERT INTO public.bitacora VALUES (1763, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 21:04:04.377578');
INSERT INTO public.bitacora VALUES (1764, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-10-05 21:04:04.448552');
INSERT INTO public.bitacora VALUES (1765, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 21:04:04.548407');
INSERT INTO public.bitacora VALUES (1766, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 21:12:57.312975');
INSERT INTO public.bitacora VALUES (1767, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-10-05 21:12:57.382992');
INSERT INTO public.bitacora VALUES (1768, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 21:12:57.495846');
INSERT INTO public.bitacora VALUES (1769, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 21:13:19.953204');
INSERT INTO public.bitacora VALUES (1770, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-10-05 21:13:20.034317');
INSERT INTO public.bitacora VALUES (1771, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 21:13:36.501828');
INSERT INTO public.bitacora VALUES (1772, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-10-05 21:13:36.572266');
INSERT INTO public.bitacora VALUES (1773, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-10-05 21:24:18.47097');
INSERT INTO public.bitacora VALUES (1774, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 21:24:18.646301');
INSERT INTO public.bitacora VALUES (1775, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 21:24:24.115206');
INSERT INTO public.bitacora VALUES (1776, 1, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-05 21:24:24.151191');
INSERT INTO public.bitacora VALUES (1777, 1, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 21:24:24.258834');
INSERT INTO public.bitacora VALUES (1778, 1, 'POST', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 21:24:25.79954');
INSERT INTO public.bitacora VALUES (1779, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 21:24:35.525773');
INSERT INTO public.bitacora VALUES (1780, 1, 'GET', 'Qr', NULL, '127.0.0.1', '2026-10-05 21:24:39.659162');
INSERT INTO public.bitacora VALUES (1781, 1, 'GET', 'Qr', NULL, '127.0.0.1', '2026-10-05 21:24:41.404043');
INSERT INTO public.bitacora VALUES (1782, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 21:24:46.440467');
INSERT INTO public.bitacora VALUES (1783, 1, 'GET', 'Receptions', NULL, '127.0.0.1', '2026-10-05 21:24:48.122378');
INSERT INTO public.bitacora VALUES (1784, 1, 'GET', 'Locations', NULL, '127.0.0.1', '2026-10-05 21:24:48.130918');
INSERT INTO public.bitacora VALUES (1785, 1, 'GET', 'Purchases', NULL, '127.0.0.1', '2026-10-05 21:24:48.139302');
INSERT INTO public.bitacora VALUES (1786, 1, 'GET', 'Receptions', NULL, '127.0.0.1', '2026-10-05 21:24:53.671958');
INSERT INTO public.bitacora VALUES (1787, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 21:24:56.553393');
INSERT INTO public.bitacora VALUES (1788, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 21:30:00.91523');
INSERT INTO public.bitacora VALUES (1789, 1, 'POST', 'Tenant-catalog', NULL, 'testclient', '2026-10-05 21:30:00.996349');
INSERT INTO public.bitacora VALUES (1790, 1, 'LOGIN', 'Autenticacion', 1, 'testclient', '2026-10-05 21:30:01.111191');
INSERT INTO public.bitacora VALUES (1791, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-10-05 23:16:55.868328');
INSERT INTO public.bitacora VALUES (1792, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 23:16:56.469044');
INSERT INTO public.bitacora VALUES (1793, 1, 'POST', 'Ai', NULL, '127.0.0.1', '2026-10-05 23:17:30.26647');
INSERT INTO public.bitacora VALUES (1794, 1, 'GET', 'Ai', NULL, '127.0.0.1', '2026-10-05 23:17:52.043793');
INSERT INTO public.bitacora VALUES (1795, 1, 'GET', 'Ai', NULL, '127.0.0.1', '2026-10-05 23:18:02.036598');
INSERT INTO public.bitacora VALUES (1796, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 23:18:20.740576');
INSERT INTO public.bitacora VALUES (1797, 1, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-05 23:18:20.891469');
INSERT INTO public.bitacora VALUES (2473, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:58:51.490216');
INSERT INTO public.bitacora VALUES (2476, 1, 'GET', 'Trace', NULL, '127.0.0.1', '2026-11-01 14:59:07.970746');
INSERT INTO public.bitacora VALUES (1798, 1, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 23:18:20.904668');
INSERT INTO public.bitacora VALUES (1813, 1, 'GET', 'Actors', NULL, '127.0.0.1', '2026-10-05 23:20:39.897813');
INSERT INTO public.bitacora VALUES (1814, 1, 'GET', 'Purchases', NULL, '127.0.0.1', '2026-10-05 23:20:39.93161');
INSERT INTO public.bitacora VALUES (1817, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 23:21:05.43446');
INSERT INTO public.bitacora VALUES (1818, 1, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 23:21:05.492606');
INSERT INTO public.bitacora VALUES (1821, 1, 'GET', 'Qr', NULL, '127.0.0.1', '2026-10-05 23:21:15.841446');
INSERT INTO public.bitacora VALUES (1825, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-06 01:48:03.338976');
INSERT INTO public.bitacora VALUES (1828, 1, 'GET', 'Locations', NULL, '127.0.0.1', '2026-10-06 01:48:08.497607');
INSERT INTO public.bitacora VALUES (2462, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 14:50:24.947139');
INSERT INTO public.bitacora VALUES (2463, 1, 'GET', 'Alerts', NULL, '127.0.0.1', '2026-11-01 14:50:35.869514');
INSERT INTO public.bitacora VALUES (2465, 1, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-01 14:50:35.978263');
INSERT INTO public.bitacora VALUES (2475, 1, 'GET', 'Trace', NULL, '127.0.0.1', '2026-11-01 14:59:04.095927');
INSERT INTO public.bitacora VALUES (2478, 1, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-01 14:59:13.565476');
INSERT INTO public.bitacora VALUES (2486, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 15:00:13.863377');
INSERT INTO public.bitacora VALUES (2489, 1, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-01 15:00:17.3537');
INSERT INTO public.bitacora VALUES (2491, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 15:00:18.924831');
INSERT INTO public.bitacora VALUES (2494, 1, 'GET', 'Notifications', NULL, '127.0.0.1', '2026-11-01 15:00:32.106035');
INSERT INTO public.bitacora VALUES (2510, 1554, 'GET', 'Documents', NULL, '127.0.0.1', '2026-11-01 15:05:23.199569');
INSERT INTO public.bitacora VALUES (2512, 1554, 'GET', 'Documents', NULL, '127.0.0.1', '2026-11-01 15:05:25.502957');
INSERT INTO public.bitacora VALUES (2514, 1554, 'GET', 'Documents', NULL, '127.0.0.1', '2026-11-01 15:05:28.648616');
INSERT INTO public.bitacora VALUES (2531, 1554, 'GET', 'Trace', NULL, '127.0.0.1', '2026-11-01 15:15:00.362099');
INSERT INTO public.bitacora VALUES (2536, 1554, 'GET', 'Documents', NULL, '127.0.0.1', '2026-11-01 15:15:20.569381');
INSERT INTO public.bitacora VALUES (2538, 1554, 'GET', 'Documents', NULL, '127.0.0.1', '2026-11-01 15:15:24.562106');
INSERT INTO public.bitacora VALUES (1799, 1, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 23:18:30.535837');
INSERT INTO public.bitacora VALUES (1800, 1, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 23:18:32.430996');
INSERT INTO public.bitacora VALUES (1804, 1, 'GET', 'Qr', NULL, '127.0.0.1', '2026-10-05 23:19:14.718744');
INSERT INTO public.bitacora VALUES (1805, 1, 'GET', 'Qr', NULL, '127.0.0.1', '2026-10-05 23:19:18.43201');
INSERT INTO public.bitacora VALUES (1806, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 23:19:35.689483');
INSERT INTO public.bitacora VALUES (1807, 1, 'GET', 'Actors', NULL, '127.0.0.1', '2026-10-05 23:19:38.066071');
INSERT INTO public.bitacora VALUES (1808, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-10-05 23:19:38.077392');
INSERT INTO public.bitacora VALUES (1809, 1, 'GET', 'Locations', NULL, '127.0.0.1', '2026-10-05 23:19:38.085526');
INSERT INTO public.bitacora VALUES (1810, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-10-05 23:19:57.196006');
INSERT INTO public.bitacora VALUES (1811, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-10-05 23:20:27.453499');
INSERT INTO public.bitacora VALUES (1812, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 23:20:37.326092');
INSERT INTO public.bitacora VALUES (1815, 1, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 23:20:39.970182');
INSERT INTO public.bitacora VALUES (1819, 1, 'GET', 'Products', NULL, '127.0.0.1', '2026-10-05 23:21:05.521781');
INSERT INTO public.bitacora VALUES (1820, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 23:21:07.972887');
INSERT INTO public.bitacora VALUES (1826, 1, 'GET', 'Actors', NULL, '127.0.0.1', '2026-10-06 01:48:08.47482');
INSERT INTO public.bitacora VALUES (1827, 1, 'GET', 'Shipments', NULL, '127.0.0.1', '2026-10-06 01:48:08.490235');
INSERT INTO public.bitacora VALUES (2479, 1, 'GET', 'Trace', NULL, '127.0.0.1', '2026-11-01 14:59:13.630163');
INSERT INTO public.bitacora VALUES (2481, 1, 'POST', 'Auth', NULL, '127.0.0.1', '2026-11-01 14:59:16.628136');
INSERT INTO public.bitacora VALUES (2487, 1, 'GET', 'Actors', NULL, '127.0.0.1', '2026-11-01 15:00:17.209259');
INSERT INTO public.bitacora VALUES (2488, 1, 'GET', 'Locations', NULL, '127.0.0.1', '2026-11-01 15:00:17.258406');
INSERT INTO public.bitacora VALUES (2490, 1, 'GET', 'Products', NULL, '127.0.0.1', '2026-11-01 15:00:17.452216');
INSERT INTO public.bitacora VALUES (2496, 1, 'POST', 'Auth', NULL, '127.0.0.1', '2026-11-01 15:00:43.090967');
INSERT INTO public.bitacora VALUES (2498, 1553, 'GET', 'Auth', NULL, '127.0.0.1', '2026-11-01 15:00:44.255819');
INSERT INTO public.bitacora VALUES (2500, 1554, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 15:00:53.954541');
INSERT INTO public.bitacora VALUES (2502, 1554, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 15:00:58.372918');
INSERT INTO public.bitacora VALUES (2505, 1554, 'GET', 'Qr', NULL, '127.0.0.1', '2026-11-01 15:04:01.50053');
INSERT INTO public.bitacora VALUES (2508, 1554, 'GET', 'Trace', NULL, '127.0.0.1', '2026-11-01 15:04:12.324258');
INSERT INTO public.bitacora VALUES (2509, 1554, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 15:05:20.208199');
INSERT INTO public.bitacora VALUES (2511, 1554, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-01 15:05:23.29629');
INSERT INTO public.bitacora VALUES (2513, 1554, 'GET', 'Documents', NULL, '127.0.0.1', '2026-11-01 15:05:27.073731');
INSERT INTO public.bitacora VALUES (2532, 1554, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 15:15:04.043182');
INSERT INTO public.bitacora VALUES (2534, 1554, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-01 15:15:06.511252');
INSERT INTO public.bitacora VALUES (2541, 1554, 'POST', 'Auth', NULL, '127.0.0.1', '2026-11-01 15:15:48.942448');
INSERT INTO public.bitacora VALUES (1801, 1, 'GET', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 23:18:34.345339');
INSERT INTO public.bitacora VALUES (1802, 1, 'POST', 'Tenant-catalog', NULL, '127.0.0.1', '2026-10-05 23:18:35.975965');
INSERT INTO public.bitacora VALUES (1803, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 23:19:10.20521');
INSERT INTO public.bitacora VALUES (1816, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 23:20:58.690125');
INSERT INTO public.bitacora VALUES (1822, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-05 23:21:17.468549');
INSERT INTO public.bitacora VALUES (1823, 1, 'GET', 'Auth', NULL, '127.0.0.1', '2026-10-06 01:47:43.31736');
INSERT INTO public.bitacora VALUES (1824, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-10-06 01:48:03.22905');
INSERT INTO public.bitacora VALUES (1829, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-10-06 01:48:19.831606');
INSERT INTO public.bitacora VALUES (1830, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-11-01 11:01:31.502076');
INSERT INTO public.bitacora VALUES (1831, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 11:01:31.84042');
INSERT INTO public.bitacora VALUES (1832, 1, 'GET', 'Alerts', NULL, '127.0.0.1', '2026-11-01 11:02:41.503173');
INSERT INTO public.bitacora VALUES (1833, 1, 'GET', 'Alerts', NULL, '127.0.0.1', '2026-11-01 11:02:41.701189');
INSERT INTO public.bitacora VALUES (1834, 1, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-01 11:02:41.852356');
INSERT INTO public.bitacora VALUES (1835, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 11:06:11.539071');
INSERT INTO public.bitacora VALUES (1847, 1, 'GET', 'Auth', NULL, '127.0.0.1', '2026-11-01 11:43:50.195867');
INSERT INTO public.bitacora VALUES (1848, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-11-01 11:44:10.744484');
INSERT INTO public.bitacora VALUES (1849, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 11:44:10.990132');
INSERT INTO public.bitacora VALUES (1850, 1, 'GET', 'Alerts', NULL, '127.0.0.1', '2026-11-01 11:44:14.035664');
INSERT INTO public.bitacora VALUES (1851, 1, 'GET', 'Alerts', NULL, '127.0.0.1', '2026-11-01 11:44:14.166697');
INSERT INTO public.bitacora VALUES (1852, 1, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-01 11:44:14.300577');
INSERT INTO public.bitacora VALUES (1853, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 11:44:41.319877');
INSERT INTO public.bitacora VALUES (1854, 1, 'POST', 'Auth', NULL, '127.0.0.1', '2026-11-01 11:44:53.169785');
INSERT INTO public.bitacora VALUES (1855, 2, 'LOGIN', 'Autenticacion', 2, '127.0.0.1', '2026-11-01 11:45:14.708773');
INSERT INTO public.bitacora VALUES (1856, 2, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 11:45:14.826202');
INSERT INTO public.bitacora VALUES (1857, 2, 'POST', 'Auth', NULL, '127.0.0.1', '2026-11-01 11:45:27.703167');
INSERT INTO public.bitacora VALUES (1858, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-11-01 11:45:40.808556');
INSERT INTO public.bitacora VALUES (1859, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 11:45:40.983351');
INSERT INTO public.bitacora VALUES (1860, 1, 'GET', 'Auth', NULL, '127.0.0.1', '2026-11-01 12:06:40.931985');
INSERT INTO public.bitacora VALUES (1861, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 12:06:40.954469');
INSERT INTO public.bitacora VALUES (1862, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 12:07:00.99014');
INSERT INTO public.bitacora VALUES (1863, 1, 'GET', 'Auth', NULL, '127.0.0.1', '2026-11-01 12:07:01.020325');
INSERT INTO public.bitacora VALUES (1864, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 12:09:39.738466');
INSERT INTO public.bitacora VALUES (1865, 1, 'GET', 'Auth', NULL, '127.0.0.1', '2026-11-01 12:09:39.779089');
INSERT INTO public.bitacora VALUES (2542, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-11-03 21:43:28.81525');
INSERT INTO public.bitacora VALUES (2543, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-03 21:43:29.188981');
INSERT INTO public.bitacora VALUES (2544, 1, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-03 22:07:45.522307');
INSERT INTO public.bitacora VALUES (2545, 1, 'GET', 'Trace', NULL, '127.0.0.1', '2026-11-03 22:07:45.791491');
INSERT INTO public.bitacora VALUES (2546, 1, 'GET', 'Trace', NULL, '127.0.0.1', '2026-11-03 22:07:48.840303');
INSERT INTO public.bitacora VALUES (2547, 1, 'GET', 'Trace', NULL, '127.0.0.1', '2026-11-03 22:07:59.600351');
INSERT INTO public.bitacora VALUES (2548, 1, 'GET', 'Trace', NULL, '127.0.0.1', '2026-11-03 22:08:00.506472');
INSERT INTO public.bitacora VALUES (2549, 1, 'GET', 'Trace', NULL, '127.0.0.1', '2026-11-03 22:08:01.645209');
INSERT INTO public.bitacora VALUES (2550, 1, 'GET', 'Trace', NULL, '127.0.0.1', '2026-11-03 22:08:03.019259');
INSERT INTO public.bitacora VALUES (2551, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-03 22:08:08.539348');
INSERT INTO public.bitacora VALUES (2552, 1, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-03 22:16:47.355379');
INSERT INTO public.bitacora VALUES (2553, 1, 'GET', 'Trace', NULL, '127.0.0.1', '2026-11-03 22:16:47.470776');
INSERT INTO public.bitacora VALUES (2554, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-03 22:16:48.305457');
INSERT INTO public.bitacora VALUES (2555, 1, 'POST', 'Auth', NULL, '127.0.0.1', '2026-11-03 22:16:51.553929');
INSERT INTO public.bitacora VALUES (2556, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-11-03 22:17:02.920084');
INSERT INTO public.bitacora VALUES (2557, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-03 22:17:03.095695');
INSERT INTO public.bitacora VALUES (2558, 1, 'GET', 'Planes', NULL, '127.0.0.1', '2026-11-03 23:20:08.015368');
INSERT INTO public.bitacora VALUES (2559, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-03 23:20:18.445901');
INSERT INTO public.bitacora VALUES (2560, 1, 'POST', 'Auth', NULL, '127.0.0.1', '2026-11-03 23:20:22.576624');
INSERT INTO public.bitacora VALUES (2561, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-11-03 23:20:32.451206');
INSERT INTO public.bitacora VALUES (2562, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-03 23:20:32.644307');
INSERT INTO public.bitacora VALUES (2563, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-03 23:20:42.308931');
INSERT INTO public.bitacora VALUES (2564, 1, 'GET', 'Planes', NULL, '127.0.0.1', '2026-11-03 23:20:42.560306');
INSERT INTO public.bitacora VALUES (2568, 1, 'GET', 'Suscripciones', NULL, '127.0.0.1', '2026-11-03 23:21:44.911476');
INSERT INTO public.bitacora VALUES (2571, 1, 'GET', 'Planes', NULL, '127.0.0.1', '2026-11-03 23:21:55.148863');
INSERT INTO public.bitacora VALUES (2572, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-03 23:22:22.482748');
INSERT INTO public.bitacora VALUES (2574, 1, 'GET', 'Roles', NULL, '127.0.0.1', '2026-11-03 23:38:23.221744');
INSERT INTO public.bitacora VALUES (2576, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-03 23:38:31.465972');
INSERT INTO public.bitacora VALUES (2581, 1, 'GET', 'Products', NULL, '127.0.0.1', '2026-11-03 23:49:15.448022');
INSERT INTO public.bitacora VALUES (2585, 1, 'GET', 'Actors', NULL, '127.0.0.1', '2026-11-03 23:50:20.420127');
INSERT INTO public.bitacora VALUES (2586, 1, 'GET', 'Locations', NULL, '127.0.0.1', '2026-11-03 23:50:20.461476');
INSERT INTO public.bitacora VALUES (2588, 1, 'GET', 'Products', NULL, '127.0.0.1', '2026-11-03 23:50:20.671024');
INSERT INTO public.bitacora VALUES (2590, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-03 23:50:25.330541');
INSERT INTO public.bitacora VALUES (2596, 1, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-03 23:53:22.28303');
INSERT INTO public.bitacora VALUES (2606, 1, 'GET', 'Auth', NULL, '127.0.0.1', '2026-11-04 00:24:24.807043');
INSERT INTO public.bitacora VALUES (2611, 1, 'GET', 'Alerts', NULL, '127.0.0.1', '2026-11-04 00:40:05.718916');
INSERT INTO public.bitacora VALUES (2613, 1, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-04 00:40:05.847715');
INSERT INTO public.bitacora VALUES (2616, 1, 'GET', 'Receptions', NULL, '127.0.0.1', '2026-11-04 00:40:10.935001');
INSERT INTO public.bitacora VALUES (2622, 1, 'GET', 'Auth', NULL, '127.0.0.1', '2026-11-04 00:55:45.444512');
INSERT INTO public.bitacora VALUES (2631, 1, 'POST', 'Auth', NULL, '127.0.0.1', '2026-11-04 00:58:07.896211');
INSERT INTO public.bitacora VALUES (2633, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-04 00:59:47.558345');
INSERT INTO public.bitacora VALUES (2635, 1, 'GET', 'Users', NULL, '127.0.0.1', '2026-11-04 01:00:01.291171');
INSERT INTO public.bitacora VALUES (2340, 1, 'POST', 'Tenants', NULL, 'testclient', '2026-11-01 14:13:33.854052');
INSERT INTO public.bitacora VALUES (2341, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-11-01 14:13:33.889373');
INSERT INTO public.bitacora VALUES (2346, 1, 'POST', 'Tenants', NULL, 'testclient', '2026-11-01 14:13:36.20271');
INSERT INTO public.bitacora VALUES (2347, 1, 'POST', 'Auth', NULL, 'testclient', '2026-11-01 14:13:36.244298');
INSERT INTO public.bitacora VALUES (2348, 1, 'GET', 'Auth', NULL, 'testclient', '2026-11-01 14:13:36.266902');
INSERT INTO public.bitacora VALUES (2565, 1, 'GET', 'Suscripciones', NULL, '127.0.0.1', '2026-11-03 23:20:42.651581');
INSERT INTO public.bitacora VALUES (2566, 1, 'suscribir_empresa_basico', 'suscripcion', 27, '127.0.0.1', '2026-11-03 23:21:44.78688');
INSERT INTO public.bitacora VALUES (2569, 1, 'GET', 'Planes', NULL, '127.0.0.1', '2026-11-03 23:21:49.535243');
INSERT INTO public.bitacora VALUES (2573, 1, 'GET', 'Permissions', NULL, '127.0.0.1', '2026-11-03 23:38:23.200277');
INSERT INTO public.bitacora VALUES (2577, 1, 'POST', 'Auth', NULL, '127.0.0.1', '2026-11-03 23:38:34.919401');
INSERT INTO public.bitacora VALUES (2580, 1, 'GET', 'Categories', NULL, '127.0.0.1', '2026-11-03 23:49:15.212925');
INSERT INTO public.bitacora VALUES (2592, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-03 23:50:55.66029');
INSERT INTO public.bitacora VALUES (2594, 1, 'GET', 'Planes', NULL, '127.0.0.1', '2026-11-03 23:52:44.022777');
INSERT INTO public.bitacora VALUES (2598, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-03 23:53:23.327977');
INSERT INTO public.bitacora VALUES (2601, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-04 00:00:57.474343');
INSERT INTO public.bitacora VALUES (2614, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-04 00:40:08.982281');
INSERT INTO public.bitacora VALUES (2615, 1, 'GET', 'Locations', NULL, '127.0.0.1', '2026-11-04 00:40:10.911316');
INSERT INTO public.bitacora VALUES (2617, 1, 'GET', 'Purchases', NULL, '127.0.0.1', '2026-11-04 00:40:10.946195');
INSERT INTO public.bitacora VALUES (2627, 1, 'GET', 'Users', NULL, '127.0.0.1', '2026-11-04 00:56:53.48717');
INSERT INTO public.bitacora VALUES (2630, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-04 00:58:06.459846');
INSERT INTO public.bitacora VALUES (2632, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-11-04 00:59:47.420277');
INSERT INTO public.bitacora VALUES (1955, 1, 'POST', 'Tenants', NULL, 'testclient', '2026-11-01 12:12:21.081557');
INSERT INTO public.bitacora VALUES (1956, 1, 'GET', 'Tenant-catalog', NULL, 'testclient', '2026-11-01 12:12:21.105989');
INSERT INTO public.bitacora VALUES (1961, 1, 'POST', 'Tenants', NULL, 'testclient', '2026-11-01 12:12:23.165498');
INSERT INTO public.bitacora VALUES (1962, 1, 'POST', 'Auth', NULL, 'testclient', '2026-11-01 12:12:23.219289');
INSERT INTO public.bitacora VALUES (1963, 1, 'GET', 'Auth', NULL, 'testclient', '2026-11-01 12:12:23.235673');
INSERT INTO public.bitacora VALUES (2567, 1, 'POST', 'Suscripciones', NULL, '127.0.0.1', '2026-11-03 23:21:44.825756');
INSERT INTO public.bitacora VALUES (2570, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-03 23:21:51.510584');
INSERT INTO public.bitacora VALUES (2575, 1, 'GET', 'Users', NULL, '127.0.0.1', '2026-11-03 23:38:23.232742');
INSERT INTO public.bitacora VALUES (2578, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-11-03 23:48:54.851653');
INSERT INTO public.bitacora VALUES (2579, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-03 23:48:55.161434');
INSERT INTO public.bitacora VALUES (2582, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-03 23:49:18.086631');
INSERT INTO public.bitacora VALUES (2583, 1, 'GET', 'Notifications', NULL, '127.0.0.1', '2026-11-03 23:49:20.852627');
INSERT INTO public.bitacora VALUES (2584, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-03 23:50:00.913977');
INSERT INTO public.bitacora VALUES (2587, 1, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-03 23:50:20.546754');
INSERT INTO public.bitacora VALUES (2589, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-03 23:50:21.709482');
INSERT INTO public.bitacora VALUES (2591, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-03 23:50:28.479258');
INSERT INTO public.bitacora VALUES (2600, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-11-04 00:00:57.257372');
INSERT INTO public.bitacora VALUES (2603, 1, 'GET', 'Qr', NULL, '127.0.0.1', '2026-11-04 00:01:10.046244');
INSERT INTO public.bitacora VALUES (2610, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-04 00:38:09.16105');
INSERT INTO public.bitacora VALUES (2620, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-04 00:55:25.812857');
INSERT INTO public.bitacora VALUES (2621, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-04 00:55:45.405657');
INSERT INTO public.bitacora VALUES (2625, 1, 'GET', 'Roles', NULL, '127.0.0.1', '2026-11-04 00:56:53.468099');
INSERT INTO public.bitacora VALUES (2629, 1, 'GET', 'Users', NULL, '127.0.0.1', '2026-11-04 00:57:14.694269');
INSERT INTO public.bitacora VALUES (2637, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-04 01:00:13.181325');
INSERT INTO public.bitacora VALUES (2638, 1, 'POST', 'Auth', NULL, '127.0.0.1', '2026-11-04 01:05:37.114608');
INSERT INTO public.bitacora VALUES (2033, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-01 12:15:20.379388');
INSERT INTO public.bitacora VALUES (2035, 1, 'GET', 'Units', NULL, '127.0.0.1', '2026-11-01 12:16:02.267349');
INSERT INTO public.bitacora VALUES (2036, 1, 'GET', 'Trace', NULL, '127.0.0.1', '2026-11-01 12:16:02.473228');
INSERT INTO public.bitacora VALUES (2593, 1, 'GET', 'Auth', NULL, '127.0.0.1', '2026-11-03 23:50:55.724704');
INSERT INTO public.bitacora VALUES (2595, 1, 'GET', 'Auth', NULL, '127.0.0.1', '2026-11-03 23:52:44.307138');
INSERT INTO public.bitacora VALUES (2597, 1, 'GET', 'Trace', NULL, '127.0.0.1', '2026-11-03 23:53:22.495399');
INSERT INTO public.bitacora VALUES (2599, 1, 'POST', 'Auth', NULL, '127.0.0.1', '2026-11-03 23:53:26.428988');
INSERT INTO public.bitacora VALUES (2602, 1, 'GET', 'Qr', NULL, '127.0.0.1', '2026-11-04 00:01:03.373197');
INSERT INTO public.bitacora VALUES (2607, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-04 00:24:24.826721');
INSERT INTO public.bitacora VALUES (2608, 1, 'POST', 'Auth', NULL, '127.0.0.1', '2026-11-04 00:25:15.207874');
INSERT INTO public.bitacora VALUES (2609, 1, 'LOGIN', 'Autenticacion', 1, '127.0.0.1', '2026-11-04 00:38:08.924913');
INSERT INTO public.bitacora VALUES (2612, 1, 'GET', 'Alerts', NULL, '127.0.0.1', '2026-11-04 00:40:05.760641');
INSERT INTO public.bitacora VALUES (2618, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-04 00:40:12.856911');
INSERT INTO public.bitacora VALUES (2619, 1, 'GET', 'Auth', NULL, '127.0.0.1', '2026-11-04 00:55:25.792179');
INSERT INTO public.bitacora VALUES (2626, 1, 'GET', 'Permissions', NULL, '127.0.0.1', '2026-11-04 00:56:53.477646');
INSERT INTO public.bitacora VALUES (2628, 1, 'GET', 'Users', NULL, '127.0.0.1', '2026-11-04 00:56:55.132138');
INSERT INTO public.bitacora VALUES (2634, 1, 'GET', 'Tenants', NULL, '127.0.0.1', '2026-11-04 01:00:01.278888');
INSERT INTO public.bitacora VALUES (2636, 1, 'GET', 'Users', NULL, '127.0.0.1', '2026-11-04 01:00:04.637764');
INSERT INTO public.bitacora VALUES (2034, 1, 'GET', 'Auth', NULL, '127.0.0.1', '2026-11-01 12:15:20.415312');


--
-- Data for Name: catalogotenant; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.catalogotenant VALUES (1, 1, 1, 'INT-1-DEMO-GS24-128-NEG', 749.00, 599.20, true);
INSERT INTO public.catalogotenant VALUES (2, 1, 3, 'INT-1-DEMO-IP15-128-BLA', 949.00, 759.20, true);
INSERT INTO public.catalogotenant VALUES (3, 1, 6, 'INT-1-DEMO-SWF2-NEG', 179.00, 143.20, true);
INSERT INTO public.catalogotenant VALUES (4, 2, 1, 'INT-2-DEMO-GS24-128-NEG', 749.00, 599.20, true);
INSERT INTO public.catalogotenant VALUES (5, 2, 3, 'INT-2-DEMO-IP15-128-BLA', 949.00, 759.20, true);
INSERT INTO public.catalogotenant VALUES (6, 2, 6, 'INT-2-DEMO-SWF2-NEG', 179.00, 143.20, true);
INSERT INTO public.catalogotenant VALUES (7, 3, 1, 'INT-3-DEMO-GS24-128-NEG', 749.00, 599.20, true);
INSERT INTO public.catalogotenant VALUES (8, 3, 3, 'INT-3-DEMO-IP15-128-BLA', 949.00, 759.20, true);
INSERT INTO public.catalogotenant VALUES (9, 3, 6, 'INT-3-DEMO-SWF2-NEG', 179.00, 143.20, true);
INSERT INTO public.catalogotenant VALUES (10, 4, 1, 'INT-4-DEMO-GS24-128-NEG', 749.00, 599.20, true);
INSERT INTO public.catalogotenant VALUES (11, 4, 3, 'INT-4-DEMO-IP15-128-BLA', 949.00, 759.20, true);
INSERT INTO public.catalogotenant VALUES (12, 4, 6, 'INT-4-DEMO-SWF2-NEG', 179.00, 143.20, true);
INSERT INTO public.catalogotenant VALUES (13, 5, 1, 'INT-5-DEMO-GS24-128-NEG', 749.00, 599.20, true);
INSERT INTO public.catalogotenant VALUES (14, 5, 3, 'INT-5-DEMO-IP15-128-BLA', 949.00, 759.20, true);
INSERT INTO public.catalogotenant VALUES (15, 5, 6, 'INT-5-DEMO-SWF2-NEG', 179.00, 143.20, true);
INSERT INTO public.catalogotenant VALUES (16, 1, 9, 'INT-SKU-1790796064527', 150.00, 90.00, true);
INSERT INTO public.catalogotenant VALUES (17, 1, 20, 'INT-SKU-1790797001510', 150.00, 90.00, true);
INSERT INTO public.catalogotenant VALUES (18, 1, 31, 'INT-SKU-1790797102625', 150.00, 90.00, true);
INSERT INTO public.catalogotenant VALUES (19, 1, 42, 'INT-SKU-1790797134417', 150.00, 90.00, true);
INSERT INTO public.catalogotenant VALUES (20, 1, 53, 'INT-SKU-1790797161882', 150.00, 90.00, true);
INSERT INTO public.catalogotenant VALUES (21, 1, 64, 'INT-SKU-1790797388714', 150.00, 90.00, true);
INSERT INTO public.catalogotenant VALUES (22, 1, 75, 'INT-SKU-1790797444274', 150.00, 90.00, true);
INSERT INTO public.catalogotenant VALUES (23, 1, 86, 'INT-SKU-1790797561928', 150.00, 90.00, true);
INSERT INTO public.catalogotenant VALUES (24, 1, 97, 'INT-SKU-1790797591388', 150.00, 90.00, true);
INSERT INTO public.catalogotenant VALUES (25, 1, 108, 'INT-SKU-1790799350668', 150.00, 90.00, true);
INSERT INTO public.catalogotenant VALUES (443, 1, 725, 'INT-SKU-1791246753644', 150.00, 90.00, true);
INSERT INTO public.catalogotenant VALUES (45, 1, 398, '1234-IP16PM-256-DES', 1199.00, 1299.00, true);
INSERT INTO public.catalogotenant VALUES (60, 1, 413, '1234-IP15-128-NEG', 869.00, 799.00, true);
INSERT INTO public.catalogotenant VALUES (61, 1, 414, '1234-APP2-USBC-BLA', 249.00, 199.00, true);
INSERT INTO public.catalogotenant VALUES (51, 1, 404, '1234-IP16-128-AZU', 899.00, 749.00, true);
INSERT INTO public.catalogotenant VALUES (57, 1, 410, '1234-IP15P-256-BLA', 1499.00, 750.00, true);
INSERT INTO public.catalogotenant VALUES (62, 1, 415, '1234-AP20W-USB-BLA', 29.00, 22.00, true);
INSERT INTO public.catalogotenant VALUES (50, 1, 403, '1234-IP16P-128-NEG', 1120.00, 920.00, true);
INSERT INTO public.catalogotenant VALUES (49, 1, 402, '1234-IP16P-256-NAT', 1099.00, 990.00, true);
INSERT INTO public.catalogotenant VALUES (63, 2, 398, '9876-IP16PM-256-DES', 1199.00, 1299.00, true);
INSERT INTO public.catalogotenant VALUES (36, 1, 135, 'INT-SKU-1790799749289', 150.00, 90.00, true);
INSERT INTO public.catalogotenant VALUES (37, 1, 146, 'INT-SKU-1790800245355', 150.00, 90.00, true);
INSERT INTO public.catalogotenant VALUES (38, 1, 160, 'INT-SKU-1790800868814', 150.00, 90.00, true);
INSERT INTO public.catalogotenant VALUES (78, 2, 413, '9876-IP15-128-NEG', 869.00, 799.00, true);
INSERT INTO public.catalogotenant VALUES (79, 2, 414, '9876-APP2-USBC-BLA', 249.00, 199.00, true);
INSERT INTO public.catalogotenant VALUES (41, 1, 175, 'INT-SKU-1790801139279', 150.00, 90.00, true);
INSERT INTO public.catalogotenant VALUES (42, 1, 186, 'INT-SKU-1790801209314', 150.00, 90.00, true);
INSERT INTO public.catalogotenant VALUES (69, 2, 404, '9876-IP16-128-AZU', 899.00, 749.00, true);
INSERT INTO public.catalogotenant VALUES (75, 2, 410, '9876-IP15P-256-BLA', 1499.00, 750.00, true);
INSERT INTO public.catalogotenant VALUES (46, 1, 399, '1234-IP16PM-512-NAT', 1873.75, 1499.00, true);
INSERT INTO public.catalogotenant VALUES (47, 1, 400, '1234-IP16PM-256-NEG', 1623.75, 1299.00, true);
INSERT INTO public.catalogotenant VALUES (48, 1, 401, '1234-IP16P-128-BLA', 1373.75, 1099.00, true);
INSERT INTO public.catalogotenant VALUES (52, 1, 405, '1234-IP16-256-VRD', 1248.75, 999.00, true);
INSERT INTO public.catalogotenant VALUES (53, 1, 406, '1234-IP16-128-NEG', 1123.75, 899.00, true);
INSERT INTO public.catalogotenant VALUES (54, 1, 407, '1234-IP15PM-256-AZU', 1436.25, 1149.00, true);
INSERT INTO public.catalogotenant VALUES (55, 1, 408, '1234-IP15PM-512-NAT', 1686.25, 1349.00, true);
INSERT INTO public.catalogotenant VALUES (56, 1, 409, '1234-IP15P-128-NEG', 1248.75, 999.00, true);
INSERT INTO public.catalogotenant VALUES (58, 1, 411, '1234-IP15-128-AZU', 998.75, 799.00, true);
INSERT INTO public.catalogotenant VALUES (59, 1, 412, '1234-IP15-256-ROS', 1123.75, 899.00, true);
INSERT INTO public.catalogotenant VALUES (64, 2, 399, '9876-IP16PM-512-NAT', 1873.75, 1499.00, true);
INSERT INTO public.catalogotenant VALUES (65, 2, 400, '9876-IP16PM-256-NEG', 1623.75, 1299.00, true);
INSERT INTO public.catalogotenant VALUES (66, 2, 401, '9876-IP16P-128-BLA', 1373.75, 1099.00, true);
INSERT INTO public.catalogotenant VALUES (70, 2, 405, '9876-IP16-256-VRD', 1248.75, 999.00, true);
INSERT INTO public.catalogotenant VALUES (71, 2, 406, '9876-IP16-128-NEG', 1123.75, 899.00, true);
INSERT INTO public.catalogotenant VALUES (72, 2, 407, '9876-IP15PM-256-AZU', 1436.25, 1149.00, true);
INSERT INTO public.catalogotenant VALUES (73, 2, 408, '9876-IP15PM-512-NAT', 1686.25, 1349.00, true);
INSERT INTO public.catalogotenant VALUES (74, 2, 409, '9876-IP15P-128-NEG', 1248.75, 999.00, true);
INSERT INTO public.catalogotenant VALUES (76, 2, 411, '9876-IP15-128-AZU', 998.75, 799.00, true);
INSERT INTO public.catalogotenant VALUES (77, 2, 412, '9876-IP15-256-ROS', 1123.75, 899.00, true);
INSERT INTO public.catalogotenant VALUES (82, 3, 399, '4567-IP16PM-512-NAT', 1873.75, 1499.00, true);
INSERT INTO public.catalogotenant VALUES (83, 3, 400, '4567-IP16PM-256-NEG', 1623.75, 1299.00, true);
INSERT INTO public.catalogotenant VALUES (84, 3, 401, '4567-IP16P-128-BLA', 1373.75, 1099.00, true);
INSERT INTO public.catalogotenant VALUES (88, 3, 405, '4567-IP16-256-VRD', 1248.75, 999.00, true);
INSERT INTO public.catalogotenant VALUES (89, 3, 406, '4567-IP16-128-NEG', 1123.75, 899.00, true);
INSERT INTO public.catalogotenant VALUES (90, 3, 407, '4567-IP15PM-256-AZU', 1436.25, 1149.00, true);
INSERT INTO public.catalogotenant VALUES (91, 3, 408, '4567-IP15PM-512-NAT', 1686.25, 1349.00, true);
INSERT INTO public.catalogotenant VALUES (92, 3, 409, '4567-IP15P-128-NEG', 1248.75, 999.00, true);
INSERT INTO public.catalogotenant VALUES (94, 3, 411, '4567-IP15-128-AZU', 998.75, 799.00, true);
INSERT INTO public.catalogotenant VALUES (95, 3, 412, '4567-IP15-256-ROS', 1123.75, 899.00, true);
INSERT INTO public.catalogotenant VALUES (100, 4, 399, '3216-IP16PM-512-NAT', 1873.75, 1499.00, true);
INSERT INTO public.catalogotenant VALUES (101, 4, 400, '3216-IP16PM-256-NEG', 1623.75, 1299.00, true);
INSERT INTO public.catalogotenant VALUES (102, 4, 401, '3216-IP16P-128-BLA', 1373.75, 1099.00, true);
INSERT INTO public.catalogotenant VALUES (106, 4, 405, '3216-IP16-256-VRD', 1248.75, 999.00, true);
INSERT INTO public.catalogotenant VALUES (107, 4, 406, '3216-IP16-128-NEG', 1123.75, 899.00, true);
INSERT INTO public.catalogotenant VALUES (108, 4, 407, '3216-IP15PM-256-AZU', 1436.25, 1149.00, true);
INSERT INTO public.catalogotenant VALUES (109, 4, 408, '3216-IP15PM-512-NAT', 1686.25, 1349.00, true);
INSERT INTO public.catalogotenant VALUES (110, 4, 409, '3216-IP15P-128-NEG', 1248.75, 999.00, true);
INSERT INTO public.catalogotenant VALUES (80, 2, 415, '9876-AP20W-USB-BLA', 29.00, 22.00, true);
INSERT INTO public.catalogotenant VALUES (68, 2, 403, '9876-IP16P-128-NEG', 1120.00, 920.00, true);
INSERT INTO public.catalogotenant VALUES (67, 2, 402, '9876-IP16P-256-NAT', 1099.00, 990.00, true);
INSERT INTO public.catalogotenant VALUES (81, 3, 398, '4567-IP16PM-256-DES', 1199.00, 1299.00, true);
INSERT INTO public.catalogotenant VALUES (96, 3, 413, '4567-IP15-128-NEG', 869.00, 799.00, true);
INSERT INTO public.catalogotenant VALUES (97, 3, 414, '4567-APP2-USBC-BLA', 249.00, 199.00, true);
INSERT INTO public.catalogotenant VALUES (87, 3, 404, '4567-IP16-128-AZU', 899.00, 749.00, true);
INSERT INTO public.catalogotenant VALUES (93, 3, 410, '4567-IP15P-256-BLA', 1499.00, 750.00, true);
INSERT INTO public.catalogotenant VALUES (98, 3, 415, '4567-AP20W-USB-BLA', 29.00, 22.00, true);
INSERT INTO public.catalogotenant VALUES (86, 3, 403, '4567-IP16P-128-NEG', 1120.00, 920.00, true);
INSERT INTO public.catalogotenant VALUES (85, 3, 402, '4567-IP16P-256-NAT', 1099.00, 990.00, true);
INSERT INTO public.catalogotenant VALUES (99, 4, 398, '3216-IP16PM-256-DES', 1199.00, 1299.00, true);
INSERT INTO public.catalogotenant VALUES (105, 4, 404, '3216-IP16-128-AZU', 899.00, 749.00, true);
INSERT INTO public.catalogotenant VALUES (104, 4, 403, '3216-IP16P-128-NEG', 1120.00, 920.00, true);
INSERT INTO public.catalogotenant VALUES (103, 4, 402, '3216-IP16P-256-NAT', 1099.00, 990.00, true);
INSERT INTO public.catalogotenant VALUES (112, 4, 411, '3216-IP15-128-AZU', 998.75, 799.00, true);
INSERT INTO public.catalogotenant VALUES (113, 4, 412, '3216-IP15-256-ROS', 1123.75, 899.00, true);
INSERT INTO public.catalogotenant VALUES (118, 5, 399, '6549-IP16PM-512-NAT', 1873.75, 1499.00, true);
INSERT INTO public.catalogotenant VALUES (119, 5, 400, '6549-IP16PM-256-NEG', 1623.75, 1299.00, true);
INSERT INTO public.catalogotenant VALUES (120, 5, 401, '6549-IP16P-128-BLA', 1373.75, 1099.00, true);
INSERT INTO public.catalogotenant VALUES (124, 5, 405, '6549-IP16-256-VRD', 1248.75, 999.00, true);
INSERT INTO public.catalogotenant VALUES (125, 5, 406, '6549-IP16-128-NEG', 1123.75, 899.00, true);
INSERT INTO public.catalogotenant VALUES (126, 5, 407, '6549-IP15PM-256-AZU', 1436.25, 1149.00, true);
INSERT INTO public.catalogotenant VALUES (127, 5, 408, '6549-IP15PM-512-NAT', 1686.25, 1349.00, true);
INSERT INTO public.catalogotenant VALUES (128, 5, 409, '6549-IP15P-128-NEG', 1248.75, 999.00, true);
INSERT INTO public.catalogotenant VALUES (130, 5, 411, '6549-IP15-128-AZU', 998.75, 799.00, true);
INSERT INTO public.catalogotenant VALUES (131, 5, 412, '6549-IP15-256-ROS', 1123.75, 899.00, true);
INSERT INTO public.catalogotenant VALUES (114, 4, 413, '3216-IP15-128-NEG', 869.00, 799.00, true);
INSERT INTO public.catalogotenant VALUES (115, 4, 414, '3216-APP2-USBC-BLA', 249.00, 199.00, true);
INSERT INTO public.catalogotenant VALUES (111, 4, 410, '3216-IP15P-256-BLA', 1499.00, 750.00, true);
INSERT INTO public.catalogotenant VALUES (116, 4, 415, '3216-AP20W-USB-BLA', 29.00, 22.00, true);
INSERT INTO public.catalogotenant VALUES (117, 5, 398, '6549-IP16PM-256-DES', 1199.00, 1299.00, true);
INSERT INTO public.catalogotenant VALUES (132, 5, 413, '6549-IP15-128-NEG', 869.00, 799.00, true);
INSERT INTO public.catalogotenant VALUES (133, 5, 414, '6549-APP2-USBC-BLA', 249.00, 199.00, true);
INSERT INTO public.catalogotenant VALUES (123, 5, 404, '6549-IP16-128-AZU', 899.00, 749.00, true);
INSERT INTO public.catalogotenant VALUES (129, 5, 410, '6549-IP15P-256-BLA', 1499.00, 750.00, true);
INSERT INTO public.catalogotenant VALUES (134, 5, 415, '6549-AP20W-USB-BLA', 29.00, 22.00, true);
INSERT INTO public.catalogotenant VALUES (122, 5, 403, '6549-IP16P-128-NEG', 1120.00, 920.00, true);
INSERT INTO public.catalogotenant VALUES (121, 5, 402, '6549-IP16P-256-NAT', 1099.00, 990.00, true);


--
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.categoria VALUES (1, 'Smartphones', 'Teléfonos inteligentes de gama alta y media');
INSERT INTO public.categoria VALUES (2, 'Accesorios', 'Cargadores, fundas y otros accesorios');
INSERT INTO public.categoria VALUES (3, 'Wearables', 'Relojes y auriculares inteligentes');
INSERT INTO public.categoria VALUES (4, 'Categoría Test 1790796063457', 'Categoría de prueba para test');
INSERT INTO public.categoria VALUES (5, 'Categoría Test 1790797000497', 'Categoría de prueba para test');
INSERT INTO public.categoria VALUES (6, 'Categoría Test 1790797101603', 'Categoría de prueba para test');
INSERT INTO public.categoria VALUES (7, 'Categoría Test 1790797133482', 'Categoría de prueba para test');
INSERT INTO public.categoria VALUES (8, 'Categoría Test 1790797160828', 'Categoría de prueba para test');
INSERT INTO public.categoria VALUES (9, 'Categoría Test 1790797385491', 'Categoría de prueba para test');
INSERT INTO public.categoria VALUES (10, 'Categoría Test 1790797443210', 'Categoría de prueba para test');
INSERT INTO public.categoria VALUES (11, 'Categoría Test 1790797560910', 'Categoría de prueba para test');
INSERT INTO public.categoria VALUES (12, 'Categoría Test 1790797590358', 'Categoría de prueba para test');
INSERT INTO public.categoria VALUES (13, 'Categoría Test 1790799349567', 'Categoría de prueba para test');
INSERT INTO public.categoria VALUES (14, 'Categoría Test 1790799748139', 'Categoría de prueba para test');
INSERT INTO public.categoria VALUES (15, 'Categoría Test 1790800244335', 'Categoría de prueba para test');
INSERT INTO public.categoria VALUES (16, 'Categoría Test 1790800867664', 'Categoría de prueba para test');
INSERT INTO public.categoria VALUES (17, 'Categoría Test 1790801138155', 'Categoría de prueba para test');
INSERT INTO public.categoria VALUES (18, 'Categoría Test 1790801207596', 'Categoría de prueba para test');
INSERT INTO public.categoria VALUES (75, 'Audio y Wearables', 'Auriculares y relojes inteligentes');
INSERT INTO public.categoria VALUES (76, 'Accesorios Oficiales', 'Cargadores, cables y fundas originales');
INSERT INTO public.categoria VALUES (77, 'Categoría Test 1791246752857', 'Categoría de prueba para test');


--
-- Data for Name: certificacion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.certificacion VALUES (1, 'Homologación ATT Bolivia', 'Autoridad de Regulación y Fiscalización de Telecomunicaciones', 'Certificado oficial de uso de frecuencias radioeléctricas en Bolivia', NULL);
INSERT INTO public.certificacion VALUES (2, 'Certificación RoHS', 'Unión Europea', 'Restricción de sustancias peligrosas en componentes electrónicos', NULL);
INSERT INTO public.certificacion VALUES (3, 'ISO-1790796064195', 'International Organization for Standardization', 'Certificación ISO de calidad', NULL);
INSERT INTO public.certificacion VALUES (4, 'ISO-1790797001149', 'International Organization for Standardization', 'Certificación ISO de calidad', NULL);
INSERT INTO public.certificacion VALUES (5, 'ISO-1790797102266', 'International Organization for Standardization', 'Certificación ISO de calidad', NULL);
INSERT INTO public.certificacion VALUES (6, 'ISO-1790797134101', 'International Organization for Standardization', 'Certificación ISO de calidad', NULL);
INSERT INTO public.certificacion VALUES (7, 'ISO-1790797161524', 'International Organization for Standardization', 'Certificación ISO de calidad', NULL);
INSERT INTO public.certificacion VALUES (8, 'ISO-1790797388237', 'International Organization for Standardization', 'Certificación ISO de calidad', NULL);
INSERT INTO public.certificacion VALUES (9, 'ISO-1790797443915', 'International Organization for Standardization', 'Certificación ISO de calidad', NULL);
INSERT INTO public.certificacion VALUES (10, 'ISO-1790797561585', 'International Organization for Standardization', 'Certificación ISO de calidad', NULL);
INSERT INTO public.certificacion VALUES (11, 'ISO-1790797591025', 'International Organization for Standardization', 'Certificación ISO de calidad', NULL);
INSERT INTO public.certificacion VALUES (12, 'ISO-1790799350315', 'International Organization for Standardization', 'Certificación ISO de calidad', NULL);
INSERT INTO public.certificacion VALUES (13, 'ISO-1790799748880', 'International Organization for Standardization', 'Certificación ISO de calidad', NULL);
INSERT INTO public.certificacion VALUES (14, 'ISO-1790800245000', 'International Organization for Standardization', 'Certificación ISO de calidad', NULL);
INSERT INTO public.certificacion VALUES (15, 'ISO-1790800868439', 'International Organization for Standardization', 'Certificación ISO de calidad', NULL);
INSERT INTO public.certificacion VALUES (16, 'ISO-1790801138880', 'International Organization for Standardization', 'Certificación ISO de calidad', NULL);
INSERT INTO public.certificacion VALUES (17, 'ISO-1790801208630', 'International Organization for Standardization', 'Certificación ISO de calidad', NULL);
INSERT INTO public.certificacion VALUES (18, 'ISO-1791246753377', 'International Organization for Standardization', 'Certificación ISO de calidad', NULL);


--
-- Data for Name: codigoqr; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.codigoqr VALUES (1, 1, '71a28df1-78a9-46c5-9625-ad1a9c7a98cd', 'http://localhost:4200/trace/71a28df1-78a9-46c5-9625-ad1a9c7a98cd', '2026-09-17 03:39:49.135849', true);
INSERT INTO public.codigoqr VALUES (2, 2, '0edbf2cb-2f5e-4805-98d8-322df899eeca', 'http://localhost:4200/trace/0edbf2cb-2f5e-4805-98d8-322df899eeca', '2026-09-17 03:39:49.14235', true);
INSERT INTO public.codigoqr VALUES (3, 3, '5f8da2a1-fcf0-498e-9d63-f6c7c14773ac', 'http://localhost:4200/trace/5f8da2a1-fcf0-498e-9d63-f6c7c14773ac', '2026-09-17 03:39:49.144588', true);
INSERT INTO public.codigoqr VALUES (4, 4, '2786b6f4-aa24-4a3f-8640-6c725abc8289', 'http://localhost:4200/trace/2786b6f4-aa24-4a3f-8640-6c725abc8289', '2026-09-17 03:39:49.335207', true);
INSERT INTO public.codigoqr VALUES (5, 5, 'aa9f8b41-6bd6-40b9-999e-e72ee71392d7', 'http://localhost:4200/trace/aa9f8b41-6bd6-40b9-999e-e72ee71392d7', '2026-09-17 03:39:49.338234', true);
INSERT INTO public.codigoqr VALUES (6, 6, '7b00b12f-877d-4e6c-a047-854af44c46d0', 'http://localhost:4200/trace/7b00b12f-877d-4e6c-a047-854af44c46d0', '2026-09-17 03:39:49.343664', true);
INSERT INTO public.codigoqr VALUES (7, 7, '928c9dfe-3289-4ebe-a60c-d4c84aad4971', 'http://localhost:4200/trace/928c9dfe-3289-4ebe-a60c-d4c84aad4971', '2026-09-17 03:39:49.393782', true);
INSERT INTO public.codigoqr VALUES (8, 8, 'efee9d96-39f7-4e3f-8e45-63ece9464c20', 'http://localhost:4200/trace/efee9d96-39f7-4e3f-8e45-63ece9464c20', '2026-09-17 03:39:49.394798', true);
INSERT INTO public.codigoqr VALUES (9, 9, '1fa7c1db-2d92-4e9d-920d-add76059af9d', 'http://localhost:4200/trace/1fa7c1db-2d92-4e9d-920d-add76059af9d', '2026-09-17 03:39:49.396587', true);
INSERT INTO public.codigoqr VALUES (10, 10, '535a56da-1da3-431d-9675-0591581d0aad', 'http://localhost:4200/trace/535a56da-1da3-431d-9675-0591581d0aad', '2026-09-17 03:39:49.434994', true);
INSERT INTO public.codigoqr VALUES (11, 11, 'b61966f2-2688-4145-8272-d13925a094e7', 'http://localhost:4200/trace/b61966f2-2688-4145-8272-d13925a094e7', '2026-09-17 03:39:49.434994', true);
INSERT INTO public.codigoqr VALUES (12, 12, 'dccdc8f6-fef9-42e1-9d38-8ac125e2909a', 'http://localhost:4200/trace/dccdc8f6-fef9-42e1-9d38-8ac125e2909a', '2026-09-17 03:39:49.437366', true);
INSERT INTO public.codigoqr VALUES (13, 13, '63221158-f64e-4d7a-aa80-15ddfadf8dc3', 'http://localhost:4200/trace/63221158-f64e-4d7a-aa80-15ddfadf8dc3', '2026-09-17 03:39:49.473222', true);
INSERT INTO public.codigoqr VALUES (14, 14, '293396c4-9504-4809-a4f7-1d443f10a58c', 'http://localhost:4200/trace/293396c4-9504-4809-a4f7-1d443f10a58c', '2026-09-17 03:39:49.474238', true);
INSERT INTO public.codigoqr VALUES (15, 15, 'ae3849c3-269e-4b43-a9ac-77def1fcd8c1', 'http://localhost:4200/trace/ae3849c3-269e-4b43-a9ac-77def1fcd8c1', '2026-09-17 03:39:49.474238', true);
INSERT INTO public.codigoqr VALUES (64, 158, 'Jvg2Vatl0upIKFV0Xnu6owj3Mv5ZMkUuJaheNuPYd0o', 'https://blockchain-production-8de2.up.railway.app/trace/4693d5d5-c54e-40ab-894e-eb2d3246671a', '2026-10-01 00:23:19.998925', true);
INSERT INTO public.codigoqr VALUES (65, 415, '5117748f2102f463000724d018d750b6', 'https://blockchain-production-8de2.up.railway.app/trace/b2eb5722-91ed-405e-9f6b-b2fd6e3d0283', '2026-09-14 00:14:32.458111', true);
INSERT INTO public.codigoqr VALUES (66, 416, '299aed80380e98d60d942e07ada8b2ce', 'https://blockchain-production-8de2.up.railway.app/trace/9120e996-fca4-4a45-9157-f0602ddf7716', '2026-09-13 00:14:32.498531', true);
INSERT INTO public.codigoqr VALUES (67, 417, '899075d65abef4a07c428ecd172c0cad', 'https://blockchain-production-8de2.up.railway.app/trace/009bcda0-38ee-40cc-91e8-d72a86a6883d', '2026-09-20 00:14:32.533938', true);
INSERT INTO public.codigoqr VALUES (68, 418, '327f23b56e27e2334f7901c43047281e', 'https://blockchain-production-8de2.up.railway.app/trace/aa21aec4-2117-402a-b7aa-7159b9b1c918', '2026-09-13 00:14:32.545112', true);
INSERT INTO public.codigoqr VALUES (69, 419, 'ae75a68db68f33552a0d207667e46159', 'https://blockchain-production-8de2.up.railway.app/trace/d0513676-8075-47cd-8966-20b8d84ff44e', '2026-09-19 00:14:32.740425', true);
INSERT INTO public.codigoqr VALUES (70, 420, '967a727eea179a7f7f69834c471b4735', 'https://blockchain-production-8de2.up.railway.app/trace/9b474048-d3f8-42b8-bfdd-8f6725699fd5', '2026-09-24 00:14:32.740425', true);
INSERT INTO public.codigoqr VALUES (71, 421, '5a893342219fb10569e1d75eadcb1d8c', 'https://blockchain-production-8de2.up.railway.app/trace/4186bac5-537f-4fba-b4b8-bfe004b3667d', '2026-09-18 00:14:32.747448', true);
INSERT INTO public.codigoqr VALUES (72, 422, '827f48c8807fd5c473fbd17ef3d68cef', 'https://blockchain-production-8de2.up.railway.app/trace/1c255d20-4765-492b-b05a-16b27ae0915a', '2026-09-21 00:14:32.752382', true);
INSERT INTO public.codigoqr VALUES (73, 423, '63a22f564f734f2d844872263277a964', 'https://blockchain-production-8de2.up.railway.app/trace/0673516c-c68e-46a7-bd61-e605fbb0921b', '2026-09-11 00:14:32.755694', true);
INSERT INTO public.codigoqr VALUES (74, 424, 'df1b2ba9a580cbc8bf21d25a683e702e', 'https://blockchain-production-8de2.up.railway.app/trace/842aed5e-a5f9-44d3-b7ad-c6cf2167d6f3', '2026-09-15 00:14:32.759524', true);
INSERT INTO public.codigoqr VALUES (75, 425, '7089afa288208fcc2980a2f4adebba89', 'https://blockchain-production-8de2.up.railway.app/trace/f48135e1-8345-4e63-95ac-d39fe6ad18ba', '2026-09-19 00:14:32.760969', true);
INSERT INTO public.codigoqr VALUES (76, 426, 'b3940233f0a3cd1a986bff1a5abcb019', 'https://blockchain-production-8de2.up.railway.app/trace/e418ffa4-a314-41e3-962b-d14d111b4dc0', '2026-09-20 00:14:32.768507', true);
INSERT INTO public.codigoqr VALUES (77, 427, 'e03b143606ea5e926d3272e98a212c41', 'https://blockchain-production-8de2.up.railway.app/trace/f8c487b1-c423-439c-8396-de7c119bfb9d', '2026-09-18 00:14:32.772935', true);
INSERT INTO public.codigoqr VALUES (78, 428, 'fa08b23e4c115c5b2c43d93375d296aa', 'https://blockchain-production-8de2.up.railway.app/trace/85781d61-c1d0-49a7-bfd0-6255da8fa9d6', '2026-09-18 00:14:32.779466', true);
INSERT INTO public.codigoqr VALUES (79, 429, 'fe11c62436825b454ea54ee9767ebaaa', 'https://blockchain-production-8de2.up.railway.app/trace/bb621b04-0dd2-4f42-87ee-98763836d67d', '2026-09-15 00:14:32.779466', true);
INSERT INTO public.codigoqr VALUES (80, 430, '3f8f2d80c39e02392813d916d80188d1', 'https://blockchain-production-8de2.up.railway.app/trace/74f6e222-b9af-45e2-a15e-00586504cf45', '2026-09-19 00:14:32.788812', true);
INSERT INTO public.codigoqr VALUES (81, 431, 'c71cba3991ddfc3f3fd177e66be693e2', 'https://blockchain-production-8de2.up.railway.app/trace/686e33a0-80e4-4002-a4ca-11fd048594ae', '2026-09-20 00:14:32.795909', true);
INSERT INTO public.codigoqr VALUES (82, 432, 'a85fd7113e52a70377fac9080b6c2cad', 'https://blockchain-production-8de2.up.railway.app/trace/0ccf5663-7e01-4848-8d28-095fb1c665bd', '2026-09-24 00:14:32.799942', true);
INSERT INTO public.codigoqr VALUES (83, 433, '246656720ee1a8f865183c816b0a2280', 'https://blockchain-production-8de2.up.railway.app/trace/6587b6c9-4026-4c61-8b5a-00fdafcacaa1', '2026-09-13 00:14:32.807078', true);
INSERT INTO public.codigoqr VALUES (84, 434, 'd4b395846435564974c8ef26fa31b4a8', 'https://blockchain-production-8de2.up.railway.app/trace/ee7006e3-7ee0-444d-b6e2-6ef9d268fe14', '2026-09-23 00:14:32.812137', true);
INSERT INTO public.codigoqr VALUES (85, 435, '22414f3bec1178b0e1a68a67fcd9929f', 'https://blockchain-production-8de2.up.railway.app/trace/9be76531-11ee-4aa5-9a68-55484a2df433', '2026-09-10 00:14:32.819604', true);
INSERT INTO public.codigoqr VALUES (86, 436, '24424e02226a4101a72135dd7db26f9e', 'https://blockchain-production-8de2.up.railway.app/trace/bccd5205-d5f6-4016-aff8-fbe2139749fd', '2026-09-21 00:14:32.821631', true);
INSERT INTO public.codigoqr VALUES (87, 437, '6def235c9b0fed1e9d5d5cbdc9fa7876', 'https://blockchain-production-8de2.up.railway.app/trace/2f645a54-da93-4105-a6ea-9fbceacb78d5', '2026-09-20 00:14:32.830428', true);
INSERT INTO public.codigoqr VALUES (88, 438, '98026824b17b590f448b797dbd9dd67e', 'https://blockchain-production-8de2.up.railway.app/trace/274b7f8b-4cd4-472e-9e26-91f7638e5d09', '2026-09-14 00:14:33.052587', true);
INSERT INTO public.codigoqr VALUES (89, 439, '560d749202461f47dc383fbd8b42ba95', 'https://blockchain-production-8de2.up.railway.app/trace/8397858a-0ef6-4e60-95db-f6680701b3f2', '2026-09-17 00:14:33.054606', true);
INSERT INTO public.codigoqr VALUES (90, 440, '150be5275ebb622fef77f879d8482b7f', 'https://blockchain-production-8de2.up.railway.app/trace/7939feda-6955-4241-9027-4f3a9583d4ca', '2026-09-12 00:14:33.061465', true);
INSERT INTO public.codigoqr VALUES (91, 441, '67d6e66f43a46fcd15d3f94f34d21994', 'https://blockchain-production-8de2.up.railway.app/trace/1f895c8e-e63f-4030-afe8-c2e21e879a0a', '2026-09-25 00:14:33.065505', true);
INSERT INTO public.codigoqr VALUES (92, 442, '9a4eca3eeed726f09e7746b12511f16f', 'https://blockchain-production-8de2.up.railway.app/trace/f9112750-8ba6-4b28-8ece-ac71c4191a80', '2026-09-16 00:14:33.069728', true);
INSERT INTO public.codigoqr VALUES (93, 443, '53b1b376d15c3b7488ca4133cb721adb', 'https://blockchain-production-8de2.up.railway.app/trace/558252b1-b61a-4ca1-8e5e-6c2fcc6b359f', '2026-09-21 00:14:33.076436', true);
INSERT INTO public.codigoqr VALUES (94, 444, '8857bfd7e2a75eb6bbe4b4753f8ab83e', 'https://blockchain-production-8de2.up.railway.app/trace/42c3c208-5052-4457-8218-67ab65984765', '2026-09-17 00:14:33.080577', true);
INSERT INTO public.codigoqr VALUES (95, 445, 'd0e6cb9856838cc3042bab4206f4f89a', 'https://blockchain-production-8de2.up.railway.app/trace/eac17b26-3c3c-42d8-ac4c-faa775367c92', '2026-09-16 00:14:33.085285', true);
INSERT INTO public.codigoqr VALUES (96, 446, 'cf7ffafe3fc513d82ac515c072cc51e5', 'https://blockchain-production-8de2.up.railway.app/trace/b3916556-3016-4a56-b670-48d139d70779', '2026-09-18 00:14:33.092353', true);
INSERT INTO public.codigoqr VALUES (97, 447, '6c37d12fb933242cb923311b8a08979c', 'https://blockchain-production-8de2.up.railway.app/trace/0e6bd6d2-274d-4da7-a3a4-56eef0ec710f', '2026-09-16 00:14:33.09842', true);
INSERT INTO public.codigoqr VALUES (98, 448, 'd6a0952c4eb6792cb198bfd19756d7bc', 'https://blockchain-production-8de2.up.railway.app/trace/7dcc09ff-b042-4251-87e8-efa407b5a7e0', '2026-09-24 00:14:33.104487', true);
INSERT INTO public.codigoqr VALUES (99, 449, 'd9044005562a5d9a8d833cfb4636486d', 'https://blockchain-production-8de2.up.railway.app/trace/518cb9b3-901e-41f1-8835-a935c4b9773b', '2026-09-23 00:14:33.110044', true);
INSERT INTO public.codigoqr VALUES (100, 450, '165d809ecd5da3a2ee8174ff14dedbb2', 'https://blockchain-production-8de2.up.railway.app/trace/ae9ed5d1-13f2-4371-9352-79213b482828', '2026-09-19 00:14:33.115411', true);
INSERT INTO public.codigoqr VALUES (101, 451, '07b27183a2954d452579e88d0015be00', 'https://blockchain-production-8de2.up.railway.app/trace/188f6f4b-2db5-4ded-ac95-207dc4a2a3f1', '2026-09-25 00:14:33.120514', true);
INSERT INTO public.codigoqr VALUES (102, 452, '30496c257dae278e4a61104356be768d', 'https://blockchain-production-8de2.up.railway.app/trace/b74319e0-6325-4225-a0cb-77ba3d8c13ce', '2026-09-17 00:14:33.125807', true);
INSERT INTO public.codigoqr VALUES (103, 453, '1625631f19156ad45a7df18e33e0ea2a', 'https://blockchain-production-8de2.up.railway.app/trace/d4034b63-b991-48ae-a74a-10dcc7a60ed0', '2026-09-14 00:14:33.131397', true);
INSERT INTO public.codigoqr VALUES (104, 454, '2a7fae7748a16fbdfd719d017f1b73f2', 'https://blockchain-production-8de2.up.railway.app/trace/27d8be62-f48e-4eab-9cf7-1db027efd033', '2026-09-11 00:14:33.136468', true);
INSERT INTO public.codigoqr VALUES (105, 455, '0d92a6a4ed6c9800122e7ca6968cb551', 'https://blockchain-production-8de2.up.railway.app/trace/96ac2065-e038-4469-b8f5-68ec1294f5ef', '2026-09-15 00:14:33.142571', true);
INSERT INTO public.codigoqr VALUES (106, 456, 'a7f69f54f4169432ff02ccc2f41dcd9a', 'https://blockchain-production-8de2.up.railway.app/trace/82303628-d2ae-45e6-9ba2-a9f9e9d7b887', '2026-09-20 00:14:33.147062', true);
INSERT INTO public.codigoqr VALUES (107, 457, '37fe0c31bf4efd55f0bf223d8f425b92', 'https://blockchain-production-8de2.up.railway.app/trace/d34202c6-49af-4a3f-946b-c537c97a1931', '2026-09-10 00:14:33.270226', true);
INSERT INTO public.codigoqr VALUES (108, 458, 'c4e005a1ec8c79d44d6d7edffebeba50', 'https://blockchain-production-8de2.up.railway.app/trace/ed4e7c67-80cc-4fe8-b79b-c82ff74d585c', '2026-09-11 00:14:33.273766', true);
INSERT INTO public.codigoqr VALUES (109, 459, 'aa21002c18378f307cb2be15941a5648', 'https://blockchain-production-8de2.up.railway.app/trace/60a12d32-15dd-4d97-9440-16a529caeeb6', '2026-09-21 00:14:33.280088', true);
INSERT INTO public.codigoqr VALUES (110, 460, '87f06e8f17ede1c736224af6e816bf1d', 'https://blockchain-production-8de2.up.railway.app/trace/3552ce39-2d2c-481d-b8ad-53df1ecd19e2', '2026-09-10 00:14:33.284084', true);
INSERT INTO public.codigoqr VALUES (111, 461, 'ae28e4e7bdaa609d17a1ad915ce6bbb4', 'https://blockchain-production-8de2.up.railway.app/trace/72694990-3da2-4610-a269-1d70c0d9d707', '2026-09-16 00:14:33.29029', true);
INSERT INTO public.codigoqr VALUES (112, 462, '05ac1bed6fd6c609c86e5f3c41af49e6', 'https://blockchain-production-8de2.up.railway.app/trace/06c19ec7-a45e-4bf2-9ad6-df24fa7d2d2b', '2026-09-24 00:14:33.297326', true);
INSERT INTO public.codigoqr VALUES (113, 463, 'ab7a2c3944299e1f07e5b20caa981283', 'https://blockchain-production-8de2.up.railway.app/trace/24d98d92-f870-4c3b-97ea-c0c7e98fbdb3', '2026-09-15 00:14:33.301106', true);
INSERT INTO public.codigoqr VALUES (114, 464, 'fd4caaf24dfae2d63f065da45865e418', 'https://blockchain-production-8de2.up.railway.app/trace/c920439a-9a6c-4c46-aabf-659d58835efe', '2026-09-18 00:14:33.309138', true);
INSERT INTO public.codigoqr VALUES (115, 465, '099da4aca34942ddb239cb75672a29a9', 'https://blockchain-production-8de2.up.railway.app/trace/b284614a-e1d7-4923-95a5-2150bf06e099', '2026-09-11 00:14:33.315534', true);
INSERT INTO public.codigoqr VALUES (116, 466, 'ae476214c9243a370d2538d3f281538f', 'https://blockchain-production-8de2.up.railway.app/trace/883af6e5-45ce-4192-b0ec-5ea55da8a9e0', '2026-09-21 00:14:33.321611', true);
INSERT INTO public.codigoqr VALUES (117, 467, '96186836ad80bf4306a4f5ffee01da2b', 'https://blockchain-production-8de2.up.railway.app/trace/59aeca31-ce4e-4c62-bfa6-756610767329', '2026-09-16 00:14:33.325764', true);
INSERT INTO public.codigoqr VALUES (118, 468, '430392a79b8a272b72228c005bb24d5e', 'https://blockchain-production-8de2.up.railway.app/trace/441be1d0-4c43-4304-8650-9e4530dd58de', '2026-09-21 00:14:33.331842', true);
INSERT INTO public.codigoqr VALUES (119, 469, 'f4e636bbb878235e6575ba0ad1f0391c', 'https://blockchain-production-8de2.up.railway.app/trace/3aef1067-5dca-4478-b515-2f2e6d6112e6', '2026-09-14 00:14:33.33792', true);
INSERT INTO public.codigoqr VALUES (120, 470, '1e4c2c2e935615a516bf3ec50aff7615', 'https://blockchain-production-8de2.up.railway.app/trace/841de51e-8ae8-4d13-b8a6-53a8e6153ea8', '2026-09-24 00:14:33.344', true);
INSERT INTO public.codigoqr VALUES (121, 471, '109c8aaf3fc9fe73dfe7124b82337d26', 'https://blockchain-production-8de2.up.railway.app/trace/d4679ac0-1e40-45a5-ae14-fabda6d203a7', '2026-09-23 00:14:33.348052', true);
INSERT INTO public.codigoqr VALUES (122, 472, '99d01032aa8aae118bd4da77d8e2067d', 'https://blockchain-production-8de2.up.railway.app/trace/f9d04afe-d8f5-4de9-aec4-cfbeaafdba8c', '2026-09-13 00:14:33.354116', true);
INSERT INTO public.codigoqr VALUES (123, 473, 'edb0fd3a80344058af2cedd1d5a6dfce', 'https://blockchain-production-8de2.up.railway.app/trace/79ef9b5f-c9f6-4981-b2b0-484ad61df51a', '2026-09-21 00:14:33.361024', true);
INSERT INTO public.codigoqr VALUES (124, 474, 'b2b558078e82cef656f9234d0a16f538', 'https://blockchain-production-8de2.up.railway.app/trace/14ef3385-3bb3-494a-9ba4-c5c0f126ae44', '2026-09-10 00:14:33.365908', true);
INSERT INTO public.codigoqr VALUES (125, 475, 'b4186bd7e09159eb7a162b21d9d6bdfb', 'https://blockchain-production-8de2.up.railway.app/trace/3ced0f13-f61c-495e-9de5-896948a3eb85', '2026-09-19 00:14:33.369965', true);
INSERT INTO public.codigoqr VALUES (126, 476, '8ea229852872ea3e0cb7870023de33ca', 'https://blockchain-production-8de2.up.railway.app/trace/dd1e6cf4-6c5c-445f-9199-585396a05350', '2026-09-25 00:14:33.532327', true);
INSERT INTO public.codigoqr VALUES (127, 477, '758cc605d98c59501dcee121da312fcd', 'https://blockchain-production-8de2.up.railway.app/trace/d3bce725-8350-4ee6-8e81-910c88787915', '2026-09-15 00:14:33.536389', true);
INSERT INTO public.codigoqr VALUES (128, 478, '8417033aa8aeb29b4f8b20755901478d', 'https://blockchain-production-8de2.up.railway.app/trace/ac2cd414-19bb-471a-9b2c-d0e7627a88bb', '2026-09-21 00:14:33.542501', true);
INSERT INTO public.codigoqr VALUES (129, 479, '58ae662a0ac927edbeefb3a113366840', 'https://blockchain-production-8de2.up.railway.app/trace/6c1c9668-35be-4033-bb57-c27257cdab9d', '2026-09-16 00:14:33.548591', true);
INSERT INTO public.codigoqr VALUES (130, 480, '93b3b3dead62f592fec2bdc8fc9a2c85', 'https://blockchain-production-8de2.up.railway.app/trace/1847b207-9863-43ef-98c3-748014b18160', '2026-09-24 00:14:33.553236', true);
INSERT INTO public.codigoqr VALUES (131, 481, '70cd5cda7416f38c7654c25198e06c3c', 'https://blockchain-production-8de2.up.railway.app/trace/752fe763-483d-4eb2-bb9a-ddcdc3294134', '2026-09-15 00:14:33.557032', true);
INSERT INTO public.codigoqr VALUES (132, 482, 'a2ce35da4eef997ddc1f41b25cac4b6b', 'https://blockchain-production-8de2.up.railway.app/trace/7473935b-b007-4c59-b4ea-c438a88ee162', '2026-09-23 00:14:33.565946', true);
INSERT INTO public.codigoqr VALUES (133, 483, '0a5fa260ccbea77e2ead93cdba7592d7', 'https://blockchain-production-8de2.up.railway.app/trace/140888e5-818e-47a6-8f8c-55be500171d8', '2026-09-20 00:14:33.569638', true);
INSERT INTO public.codigoqr VALUES (134, 484, 'bef094136006f12dbcc592c765581cf4', 'https://blockchain-production-8de2.up.railway.app/trace/45991dcb-8547-4fe8-a39b-a0a72550a5cc', '2026-09-25 00:14:33.57358', true);
INSERT INTO public.codigoqr VALUES (135, 485, '4bbb1c9beee1366ce0852103838ddc25', 'https://blockchain-production-8de2.up.railway.app/trace/400b3d0c-2067-4bee-8952-3f92108f9b8c', '2026-09-24 00:14:33.577039', true);
INSERT INTO public.codigoqr VALUES (136, 486, '5a062b299d260c56e460584926664444', 'https://blockchain-production-8de2.up.railway.app/trace/c44aee53-cbfe-41ec-b1fa-52b2271c2324', '2026-09-22 00:14:33.581557', true);
INSERT INTO public.codigoqr VALUES (137, 487, 'e7d8bf03fae02e1c7b7cd93bb168d815', 'https://blockchain-production-8de2.up.railway.app/trace/bccd4e7d-7d2a-44e4-9e55-48dd4a533b08', '2026-09-18 00:14:33.585096', true);
INSERT INTO public.codigoqr VALUES (138, 488, '4f17ea89473fd80b19c8f9cb47358cca', 'https://blockchain-production-8de2.up.railway.app/trace/0ba4eeab-3f66-4d1d-bf91-2f3cec680af8', '2026-09-13 00:14:33.589947', true);
INSERT INTO public.codigoqr VALUES (139, 489, 'f77304c23f59104d4533f6d420c8056f', 'https://blockchain-production-8de2.up.railway.app/trace/6381c6fe-56b7-48f4-9bc9-bbd99094aef6', '2026-09-24 00:14:33.594082', true);
INSERT INTO public.codigoqr VALUES (140, 490, '9c12de7878a4f8b879a492b5784cc6b0', 'https://blockchain-production-8de2.up.railway.app/trace/2b9aff93-4c4b-41f9-9952-e10beddf5337', '2026-09-13 00:14:33.594082', true);
INSERT INTO public.codigoqr VALUES (141, 491, '0eb8f3435d872743b51da6a6ec10e69d', 'https://blockchain-production-8de2.up.railway.app/trace/91ea88ea-3d84-434b-94d1-b78cf1d0f9d6', '2026-09-14 00:14:33.594082', true);
INSERT INTO public.codigoqr VALUES (142, 492, '484fd12ae8bcd7fc84ee3e2f40d829e3', 'https://blockchain-production-8de2.up.railway.app/trace/3e9f1b18-da80-4b57-bada-0cac91b72e1c', '2026-09-15 00:14:33.604378', true);
INSERT INTO public.codigoqr VALUES (143, 493, 'a7b9ee215248650c34b5842c0a71354d', 'https://blockchain-production-8de2.up.railway.app/trace/5b1124db-220d-47ac-89c1-d08a8f168b53', '2026-09-25 00:14:33.611108', true);
INSERT INTO public.codigoqr VALUES (144, 494, '89310b84a34932259fa4adc0d4a1a62e', 'https://blockchain-production-8de2.up.railway.app/trace/7f4df001-b482-43df-8c18-b4010d2e2655', '2026-09-18 00:14:33.61425', true);
INSERT INTO public.codigoqr VALUES (148, 3173, '7159d4849542a5bbf662bc02a6ad32ff', 'https://blockchain-production-8de2.up.railway.app/trace/079abde4-35aa-4380-ae05-2e4c1a8c9877', '2026-09-10 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (149, 3174, '4abd496890ae6280b500e83da8ba9184', 'https://blockchain-production-8de2.up.railway.app/trace/ae2023e6-76ca-4b4d-abef-bf26a08f2e0c', '2026-09-10 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (150, 3175, '901a8b9d9a01ca67b5c598f02874fb82', 'https://blockchain-production-8de2.up.railway.app/trace/cd533611-fa5e-4549-9afb-57419810b635', '2026-09-10 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (151, 3176, '135ef92f4b45b640cdc9b0564609cbc5', 'https://blockchain-production-8de2.up.railway.app/trace/14c8b571-482b-493d-b91f-1507dba2e138', '2026-09-05 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (152, 3177, '44e5460aadfea9977fa465ce52f6d4b3', 'https://blockchain-production-8de2.up.railway.app/trace/4aa5c55b-62fa-4c03-a05b-6a934cdcb921', '2026-09-15 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (153, 3178, '75426515b60f3c6c9252ecb5c7e009c3', 'https://blockchain-production-8de2.up.railway.app/trace/6d7c1ffb-1fe0-45ac-a929-f9446ee4c3b8', '2026-09-15 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (154, 3179, '85855fd4c26d8a479531a674bae410a9', 'https://blockchain-production-8de2.up.railway.app/trace/bcabd763-41c8-4bc9-ae96-cebc6c87c5e9', '2026-09-15 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (155, 3180, 'f1a21933e11a7d624d109fabf6f03649', 'https://blockchain-production-8de2.up.railway.app/trace/e15472d8-e3f0-4912-96d4-1f3c1fb35e34', '2026-09-15 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (156, 3181, 'ede9e740d43cff9c025eab58f7c4a0e2', 'https://blockchain-production-8de2.up.railway.app/trace/c9cab9fc-1ffe-491d-b3e0-078c324ddce6', '2026-09-15 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (157, 3182, '3bb6af4d764cc0aa6520330ff1f5e858', 'https://blockchain-production-8de2.up.railway.app/trace/bce6042d-2e1d-4dca-afe6-7922d702fe97', '2026-09-15 11:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (158, 3183, 'b0a1554c440924371cbe938a09fce6ed', 'https://blockchain-production-8de2.up.railway.app/trace/ffdfd496-5e6e-43b7-9d42-464fc9cf4969', '2026-09-15 09:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (159, 3184, 'c71dd967d5975bdb31ab23434ad7f957', 'https://blockchain-production-8de2.up.railway.app/trace/43b9d575-e290-40a4-aa4d-36d2e3443dd1', '2026-09-15 07:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (160, 3185, '7168c39e69dcf0a2a534fdc43121ef4f', 'https://blockchain-production-8de2.up.railway.app/trace/1059a656-0aa0-48ef-b229-535135497fcd', '2026-09-13 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (161, 3186, 'e001b09a02fa4d1841653b12a174190a', 'https://blockchain-production-8de2.up.railway.app/trace/dca5e44f-54af-4137-b856-7d8127cc3a8f', '2026-09-14 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (162, 3187, '6b50295aa1ae4404bdda0932c7e9937a', 'https://blockchain-production-8de2.up.railway.app/trace/726613b3-da87-409d-b5ea-296696053b03', '2026-09-16 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (163, 3188, '14d7612e2e98b7caacb07aeca0c9d849', 'https://blockchain-production-8de2.up.railway.app/trace/2d149faa-2ca4-4e62-af1b-b7e78d718473', '2026-09-09 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (164, 3189, '7ed7233781c9fb73cbb463c04a397e49', 'https://blockchain-production-8de2.up.railway.app/trace/8197e87c-9d6c-403f-b7a7-bfcdc5ef8002', '2026-09-17 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (165, 3190, '74f3ca90969ddeb53cef87c94c5b1f34', 'https://blockchain-production-8de2.up.railway.app/trace/95093806-f6e1-4d6d-8712-25dc46e802ab', '2026-09-17 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (166, 3191, 'f273b9d201d9b7881f81d44a2f8d6fe9', 'https://blockchain-production-8de2.up.railway.app/trace/b38c528d-a0ec-4c46-a1a4-0b3b32622be2', '2026-09-17 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (167, 3192, '284f7bae80c664609434347092b99adc', 'https://blockchain-production-8de2.up.railway.app/trace/6be5276c-29d8-41df-961f-0d1a40b2725c', '2026-09-17 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (168, 3193, '4ec0b4905c8aac661665566beb7b5b92', 'https://blockchain-production-8de2.up.railway.app/trace/8adba65b-3da2-4302-b284-ce7ec718addd', '2026-09-17 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (169, 3194, '4fe4c6d9c7d782de9204aa6beb6e7c4e', 'https://blockchain-production-8de2.up.railway.app/trace/ff97864d-1885-496e-9122-47c4391430bc', '2026-09-17 11:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (170, 3195, '3084acabd2408e94cb5559dcfb29d18a', 'https://blockchain-production-8de2.up.railway.app/trace/295f2bbe-872d-4966-a192-bdd5911a7bbf', '2026-09-17 09:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (171, 3196, '8a1a1374e6ec7404af90661e7dc40294', 'https://blockchain-production-8de2.up.railway.app/trace/f3e629d8-a551-4fd3-8c29-5edb2918eeca', '2026-09-17 07:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (172, 3197, '94b478e37355fa2dd7559387a2b9766c', 'https://blockchain-production-8de2.up.railway.app/trace/2d38c686-f258-4a17-be14-ba76749b0adf', '2026-09-17 05:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (173, 3198, '9e7ba448575ef71864023735f2d9cd85', 'https://blockchain-production-8de2.up.railway.app/trace/89b647d9-30b4-4084-8ba8-75e1b9b98c19', '2026-09-05 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (174, 3199, 'd1696a0374fe3ea21907479ab7156668', 'https://blockchain-production-8de2.up.railway.app/trace/e30309b0-4d5b-4d4a-9045-1074db2056d4', '2026-08-06 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (175, 3200, '8806b9af064e732890b04e98c6458790', 'https://blockchain-production-8de2.up.railway.app/trace/52d60d4b-5bf1-4451-ad14-1ce34ee81fe5', '2026-08-06 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (176, 3201, '031e1b4e97a422452e7f4b3126841432', 'https://blockchain-production-8de2.up.railway.app/trace/6b7d626d-aa55-4036-9ffe-a77edd8901b9', '2026-08-06 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (177, 3202, '1d1e75818a82f26ef38a1bfda1ad8b1b', 'https://blockchain-production-8de2.up.railway.app/trace/eb45d217-79a7-440f-a07b-c73d48e65a2c', '2026-08-06 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (178, 3203, '8f5fdf741c0684e4d48cc5b03971dd32', 'https://blockchain-production-8de2.up.railway.app/trace/4b1036de-e770-440b-8dd4-4ab459a30fd4', '2026-08-06 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (179, 3204, '7e5024fce11ca4dfecada219cebbf1cf', 'https://blockchain-production-8de2.up.railway.app/trace/fc490e61-2bdd-4d95-b832-d9443018bfe2', '2026-08-11 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (180, 3205, '0ac2e406b7dcb18132d6daa13da3cb68', 'https://blockchain-production-8de2.up.railway.app/trace/cfeb851b-1937-44bd-8771-2aa55cced68f', '2026-08-11 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (181, 3206, '44d9be1eb4597f46c2bee38c1d39e3d3', 'https://blockchain-production-8de2.up.railway.app/trace/78a6891a-ece8-47a9-aab6-1c447f9dae48', '2026-09-10 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (182, 3207, 'f28e9623e1f94ba8dec2976ff04e837a', 'https://blockchain-production-8de2.up.railway.app/trace/692de0e7-929c-484d-a26e-9b68e8162c58', '2026-09-18 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (183, 3208, 'b8a545fe3acab2305e9b3b1c21a75b1d', 'https://blockchain-production-8de2.up.railway.app/trace/43908631-a1a5-4ba0-873b-7695fbdf26d6', '2026-09-16 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (184, 3209, '7a1bcb3a094ffed84197c52a9c2116d7', 'https://blockchain-production-8de2.up.railway.app/trace/fea181c3-cfff-4d26-8c20-e063521fe77c', '2026-09-19 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (185, 3210, '02d6e78a6736630272571b46c5fe1c32', 'https://blockchain-production-8de2.up.railway.app/trace/14e97634-9c1c-4b98-b40f-3d9986304e3d', '2026-09-14 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (186, 3211, '3ef74281e5197f95c598ec1e8e9279ff', 'https://blockchain-production-8de2.up.railway.app/trace/5c24c87b-418a-4d29-be95-6d5974ff235a', '2026-09-13 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (187, 3212, '7be95e3ec1c3eeb7e10f1a9dc9ad1b4e', 'https://blockchain-production-8de2.up.railway.app/trace/70ff42b6-516c-4087-b78e-cbf971a1d09b', '2026-09-17 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (188, 3213, '6f980c6719f9938ab14248c9aa181559', 'https://blockchain-production-8de2.up.railway.app/trace/cbb1b59d-9cc9-4cfe-9ba1-c67e1433dfe0', '2026-09-14 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (189, 3214, '38aa73754bd9851380f847899fb8791e', 'https://blockchain-production-8de2.up.railway.app/trace/c6bece16-dbc3-446e-9d3a-2b0b956de5ea', '2026-09-14 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (190, 3215, 'ce5e0fd10c45eb2d83034caf81ad9ad8', 'https://blockchain-production-8de2.up.railway.app/trace/db4362e7-a2be-49a0-9694-f17f8452608e', '2026-09-08 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (191, 3216, '99d4c07997fa619691ae6894296f0394', 'https://blockchain-production-8de2.up.railway.app/trace/f82e367d-dbdd-4079-a6ae-65c663770ef1', '2026-09-12 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (192, 3217, '0edc3f5644feeae912f8e4d7888fce8a', 'https://blockchain-production-8de2.up.railway.app/trace/97affb52-cacc-4562-b5cd-af57c2abd0d4', '2026-07-07 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (193, 3218, '1999e5feb7d3a7c7fcb76c774b8f4fee', 'https://blockchain-production-8de2.up.railway.app/trace/c20d5ca6-1b0a-4246-82cf-4aced008fffb', '2026-07-07 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (194, 3219, '2c10920381322b8e1ca4dcd90e1f83eb', 'https://blockchain-production-8de2.up.railway.app/trace/9dd74ed0-b505-43de-a133-26a4ce1df3dd', '2026-09-06 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (195, 3220, '394c8a071f8fd19c9cf5e335cefff09a', 'https://blockchain-production-8de2.up.railway.app/trace/ef91af6c-9020-49fe-b43e-4e390fac41ff', '2026-09-20 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (196, 3221, '291406e6895ca9c45db40c4755efde22', 'https://blockchain-production-8de2.up.railway.app/trace/d7bfeb10-cc7d-4638-a068-dbdb057a0aee', '2026-09-05 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (197, 3222, 'de6a6b9ad957c93af04b41cf334a7a6d', 'https://blockchain-production-8de2.up.railway.app/trace/3a38e805-3bd7-431c-a5f5-e4fecb88be9a', '2026-09-07 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (198, 3223, '2b06f97c5b3119090ee52eb7984cc7d5', 'https://blockchain-production-8de2.up.railway.app/trace/c6a50803-1d5f-4fe4-9197-cbb4e11a0f11', '2026-09-16 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (199, 3224, '7cd3e247f18263623d345b9c02904433', 'https://blockchain-production-8de2.up.railway.app/trace/b54fb33b-08be-4aaa-9de5-c80eb2469b1b', '2026-09-16 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (200, 3225, '9af4cd02979f95a477a9661d66b13df0', 'https://blockchain-production-8de2.up.railway.app/trace/f6235e49-8b85-4ed7-8fb1-a91ebc43430e', '2026-09-16 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (201, 3226, '5ed033b6e6a4075e8487005e0fdf24e7', 'https://blockchain-production-8de2.up.railway.app/trace/4dce2b11-96a2-4249-b06f-58fc4c15ab5b', '2026-09-16 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (202, 3227, 'a59debe1b7abc6faf59e817b47cd8709', 'https://blockchain-production-8de2.up.railway.app/trace/bc317139-7a70-43f4-9942-61b4f022625d', '2026-09-16 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (203, 3228, '605bf4ea61d1a2ca38f52bf4fdbc1bab', 'https://blockchain-production-8de2.up.railway.app/trace/627eae45-31e8-4218-90c4-63774361daa3', '2026-09-16 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (204, 3229, 'e29e925a531016fbf0350cac4b24c786', 'https://blockchain-production-8de2.up.railway.app/trace/473868b2-f9d8-4f4b-bebe-66d4efe21f3b', '2026-09-16 11:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (205, 3230, 'b434dd6e9ce46c6c07ba0072ea440572', 'https://blockchain-production-8de2.up.railway.app/trace/4ef740f0-11f5-4677-8ca4-786678910154', '2026-09-16 09:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (206, 3231, '619793bf28b868a82bb348e0fd3650f2', 'https://blockchain-production-8de2.up.railway.app/trace/a24ce2d8-3305-4c8e-95a2-03437823f60b', '2026-09-16 07:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (207, 3232, '73b43d319336b42792a4833ec46d2f13', 'https://blockchain-production-8de2.up.railway.app/trace/0231527f-41f2-4d33-9fff-f4edf7ee4f19', '2026-09-16 05:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (208, 3233, '163893c557d3560d9ffc5ed6acc4b240', 'https://blockchain-production-8de2.up.railway.app/trace/99414874-7b51-46d1-b51b-33ff2709f97c', '2026-09-16 03:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (209, 3234, '134fa9995b70087a3bfe43db219f204a', 'https://blockchain-production-8de2.up.railway.app/trace/61297cdb-7a5a-45ff-8bc5-9a5b448299a6', '2026-09-16 01:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (210, 3235, '322565fd1788576cc19af7cff87a1cb4', 'https://blockchain-production-8de2.up.railway.app/trace/5c508b88-1560-49c8-8517-8ab0d0e50329', '2026-09-20 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (211, 3236, '1d6c64a417b4420d2546421483819bdd', 'https://blockchain-production-8de2.up.railway.app/trace/356824be-c6f5-44fe-8364-61f6f9322b2b', '2026-09-10 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (212, 3237, '00b2f37734db499b2d6eed9ebb7263d7', 'https://blockchain-production-8de2.up.railway.app/trace/610eb8af-d8e7-4720-ae9c-3b678e12f0dd', '2026-09-10 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (213, 3238, '0c104caecbe11108e3eab0445f9418a0', 'https://blockchain-production-8de2.up.railway.app/trace/bc09a455-39dd-474b-a96c-7b60b0dbb007', '2026-09-10 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (214, 3239, '3574ff28106af688cd3f475c10db657b', 'https://blockchain-production-8de2.up.railway.app/trace/8acadda6-866d-473f-a394-8d4e6f19065c', '2026-09-16 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (215, 3240, '0657d2214da2f88111e3e817dff15e7d', 'https://blockchain-production-8de2.up.railway.app/trace/08818b72-5e1d-49d8-a5f8-ce38cf594124', '2026-09-15 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (216, 3241, 'aac636fa920bf5b0a4616642f6404f70', 'https://blockchain-production-8de2.up.railway.app/trace/1e22157c-9008-49f3-8068-2a81b83bb8c9', '2026-09-15 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (217, 3242, '890fd66ae1785382e9ebec491f7ffbe9', 'https://blockchain-production-8de2.up.railway.app/trace/8f43441f-88fa-471c-9e3a-72ac0480d1f7', '2026-09-15 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (218, 3243, 'be3e168505153657012eeeaef08bae93', 'https://blockchain-production-8de2.up.railway.app/trace/f29349ff-498a-4879-9196-569263e8ed5f', '2026-09-15 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (219, 3244, '700da4a14d58c3aadc2eed6582b85555', 'https://blockchain-production-8de2.up.railway.app/trace/85f1cb1c-6387-4556-bbfc-54393a6d7ecb', '2026-09-15 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (220, 3245, 'c0c84c49878ea17139e48481136bf159', 'https://blockchain-production-8de2.up.railway.app/trace/1cadd783-db3a-4c0d-9449-a511b368e4ef', '2026-09-15 11:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (221, 3246, '1134c497a4466c86000e63633c38aad1', 'https://blockchain-production-8de2.up.railway.app/trace/7d2ef6ff-bc6f-490e-b3fc-a047c97eed01', '2026-09-15 09:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (222, 3247, '2a93db878675c9a3370b918ccd337ffd', 'https://blockchain-production-8de2.up.railway.app/trace/ef4ed367-1962-472c-bed4-d577f602f784', '2026-09-15 07:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (223, 3248, 'fc50195715192e052cc1c3a842945e5b', 'https://blockchain-production-8de2.up.railway.app/trace/99287e28-ba5b-4f0d-916b-c59c7d7c7357', '2026-09-15 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (224, 3249, 'b0f0c01d6eaadfabbfec8db242105f67', 'https://blockchain-production-8de2.up.railway.app/trace/484cd5c3-bc4c-405e-afc6-d1f0da78cb3a', '2026-09-07 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (225, 3250, '5716e417b95869ae4ebe8a874a3d1788', 'https://blockchain-production-8de2.up.railway.app/trace/e7d1d59d-a962-479e-98c5-6c8c16027111', '2026-09-12 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (226, 3251, 'fdd9b90f8ad6a2e2471c27e4def26bc8', 'https://blockchain-production-8de2.up.railway.app/trace/ce0473b8-0f6b-4373-b5c3-bd9b2ecb5773', '2026-09-16 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (227, 3252, '62edf0c98167d78739adef37db62758f', 'https://blockchain-production-8de2.up.railway.app/trace/32c541a9-945c-46ad-842d-bb6428968fb3', '2026-09-17 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (228, 3253, 'fe974f29f4b54389f4441a5c2ac055ca', 'https://blockchain-production-8de2.up.railway.app/trace/86ca9cdf-03db-4e8b-92ec-ab544ab6b363', '2026-09-17 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (229, 3254, 'c5b1cbbc847586a8dd7f45ddd84e7e75', 'https://blockchain-production-8de2.up.railway.app/trace/3c427b34-bdd1-40ca-9d6d-66d121cfadda', '2026-09-17 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (230, 3255, '043ae049e73e8fd27372e8216b9b9238', 'https://blockchain-production-8de2.up.railway.app/trace/0a085dcf-b521-4feb-8dc6-a31ef2090fdb', '2026-09-17 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (231, 3256, '4d0804be08c48577d5f6619b097118d0', 'https://blockchain-production-8de2.up.railway.app/trace/d82e2c2a-2c73-4c99-a420-cf20e28e1b5a', '2026-09-17 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (232, 3257, '14949cf6a3f3a5abf0187d074738d590', 'https://blockchain-production-8de2.up.railway.app/trace/9475b77a-ecfe-4060-8907-94ef3fdd2a98', '2026-09-17 11:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (233, 3258, '8899b93c7099839cc23726cb8ae65dd4', 'https://blockchain-production-8de2.up.railway.app/trace/31c405df-a713-4735-a212-1dd047929b1d', '2026-09-17 09:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (234, 3259, '4257b0666721a2374ff13014a3dc1232', 'https://blockchain-production-8de2.up.railway.app/trace/feed1afa-2f66-4690-8029-4c9ccf4d34da', '2026-09-17 07:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (235, 3260, 'a1b938b042928e68ceb91987f4455270', 'https://blockchain-production-8de2.up.railway.app/trace/1c288507-2b73-4232-b706-dde7d9ebd61c', '2026-09-17 05:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (236, 3261, '1ef4524a49a8ebd51bf7608ef9e6f065', 'https://blockchain-production-8de2.up.railway.app/trace/5984d68f-6c5c-487b-9e94-bdade8b939a7', '2026-09-09 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (237, 3262, 'dbcdf0cbb7e07d7c4cd2b5ac78800226', 'https://blockchain-production-8de2.up.railway.app/trace/9b334f8a-3911-4605-a56f-71fc83629994', '2026-08-06 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (238, 3263, '98d7f0f25f7ad72505ad801073321631', 'https://blockchain-production-8de2.up.railway.app/trace/e9fc519e-01c9-4a60-92f7-943565e776f9', '2026-08-06 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (239, 3264, 'f2e4578fa64b2e9e9b69eb18f0638208', 'https://blockchain-production-8de2.up.railway.app/trace/271a463f-046c-491f-bef0-5b661d68dff9', '2026-08-06 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (240, 3265, '90d7b86912992ca5e587467e50be50e4', 'https://blockchain-production-8de2.up.railway.app/trace/24f62914-e9e9-4f9f-bb1f-c576694612da', '2026-08-06 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (241, 3266, 'ecb8154796d778399a49126b254c2f2c', 'https://blockchain-production-8de2.up.railway.app/trace/64946f48-55ca-4bc8-bc0b-f14bcc7a565b', '2026-08-06 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (242, 3267, 'd7457b3b1c262e860d5dd272eb7b94d7', 'https://blockchain-production-8de2.up.railway.app/trace/541d7687-14a2-455e-b055-7e1930ad998a', '2026-08-11 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (243, 3268, '494eb64da09c76e2579cbc4122c474c8', 'https://blockchain-production-8de2.up.railway.app/trace/735cb851-1448-4c30-9cfd-c541c680679a', '2026-08-11 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (244, 3269, '0a4d84c3539e77a722a08114628e4da8', 'https://blockchain-production-8de2.up.railway.app/trace/327efbfc-8391-4d1f-a0b4-be39b70cc674', '2026-09-09 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (245, 3270, '7fa707f82a8fa525cbd4bf81d72ba9e0', 'https://blockchain-production-8de2.up.railway.app/trace/9fe97266-873d-435b-b305-0720aa300f01', '2026-09-07 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (246, 3271, 'b637ff3cbd56edb98b7195bec239a56e', 'https://blockchain-production-8de2.up.railway.app/trace/cf4dcd0b-5fd4-4444-b2ef-6bb2ca44c534', '2026-09-11 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (247, 3272, '0ed982ab948b691b9f35dcef692f4dad', 'https://blockchain-production-8de2.up.railway.app/trace/3b7cbfc1-9262-4988-bb9b-c556bda34bee', '2026-09-09 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (248, 3273, 'eb536c490b3b192a18ac65c18d956e62', 'https://blockchain-production-8de2.up.railway.app/trace/67ff0440-0e90-4f9a-9c8e-fd4873b8d5e0', '2026-09-08 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (249, 3274, 'f8b8047a3c99deb399e6c350c00adc9b', 'https://blockchain-production-8de2.up.railway.app/trace/56b87e2b-abb5-4dfe-b92b-3bdac205a512', '2026-09-11 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (250, 3275, '7702b59e95c3ef441f59396857ff442b', 'https://blockchain-production-8de2.up.railway.app/trace/ac1056de-f18e-4717-a0f6-427c41f3c1f1', '2026-09-10 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (251, 3276, '1a9650f40f9217018b4c17eaa944b93f', 'https://blockchain-production-8de2.up.railway.app/trace/32803d89-9fef-4693-90b7-ee45851979a3', '2026-09-15 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (252, 3277, '9e8b6838cbbb4233c7523e719877121e', 'https://blockchain-production-8de2.up.railway.app/trace/26dcb3cd-d35d-436b-9fb0-9cea636e2c5d', '2026-09-16 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (253, 3278, '8f37c52cc48bf0055fe3424cf8743e67', 'https://blockchain-production-8de2.up.railway.app/trace/7c3a7b21-853a-4979-ba51-2c46a232de82', '2026-07-07 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (254, 3279, 'be96682d1bbacf0806c0f17173f75dab', 'https://blockchain-production-8de2.up.railway.app/trace/6ab2e2ce-e576-4810-bcb3-93a110e6a262', '2026-07-07 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (255, 3280, '4433fe28e82c5430239852960396b80d', 'https://blockchain-production-8de2.up.railway.app/trace/29d8fea7-13b2-433f-b0b6-a0d1fec13c77', '2026-09-12 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (256, 3281, '6f31bb0adf69b4d7bd3474ee1cdde043', 'https://blockchain-production-8de2.up.railway.app/trace/a5780354-7e1c-484a-9125-a3c913991396', '2026-09-14 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (257, 3282, 'e783c7f347d7b87c8ea373d9799a3a94', 'https://blockchain-production-8de2.up.railway.app/trace/1dc717f2-4ef0-451c-a48e-64ef58f6ec6c', '2026-09-10 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (258, 3283, '8b9304564283cd14d8e354e04c2d10eb', 'https://blockchain-production-8de2.up.railway.app/trace/120619bc-2409-4916-98c8-aa7892eed800', '2026-09-09 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (259, 3284, 'e06a7a536aa74494eb2ede91b14207f1', 'https://blockchain-production-8de2.up.railway.app/trace/dbb04bd4-03bd-4b21-9633-5184364ec4ea', '2026-09-16 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (260, 3285, 'd346ad309395c8e1007e75b87f1a119c', 'https://blockchain-production-8de2.up.railway.app/trace/c1f919c1-a447-4939-b477-d4a8e49723bf', '2026-09-16 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (261, 3286, '1868c483e8eda5194745e25d7605fbbb', 'https://blockchain-production-8de2.up.railway.app/trace/9515904e-d9b6-4fac-a22d-0e2fc667697c', '2026-09-16 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (262, 3287, 'c758721757ee45654822a04f349233b9', 'https://blockchain-production-8de2.up.railway.app/trace/5e0d7dff-2d98-4aac-ab45-3af39d9cd319', '2026-09-16 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (263, 3288, 'f0b20078136ed6aa278f5d22aa579a85', 'https://blockchain-production-8de2.up.railway.app/trace/589ea088-9f44-4166-9f03-78aa83b59381', '2026-09-16 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (264, 3289, '012140ab0ad3bdcfa5f6cf3769b36068', 'https://blockchain-production-8de2.up.railway.app/trace/02526380-dc8c-4055-a268-1ab79f58e834', '2026-09-16 11:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (265, 3290, 'dcbbe987ce1e5a1c9eac7f0d70685e07', 'https://blockchain-production-8de2.up.railway.app/trace/85eec685-aab7-4283-b07e-c14070b5c43d', '2026-09-16 09:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (266, 3291, '5811e220a615cce035625ea0899517c8', 'https://blockchain-production-8de2.up.railway.app/trace/fa6886b3-59ac-43cd-ace2-cd8a074c7742', '2026-09-16 07:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (267, 3292, 'f6aff18fc8e8366e8e2a547b6f0ce1d5', 'https://blockchain-production-8de2.up.railway.app/trace/404b75d8-801e-4838-80b5-668133f1f493', '2026-09-16 05:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (268, 3293, 'b63ed7cdf5d65b8814f31dbf0c271ca9', 'https://blockchain-production-8de2.up.railway.app/trace/358a21e9-02ca-4849-93ce-91fa3681986f', '2026-09-16 03:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (269, 3294, 'b2d58326b0010714faadc569f4472aa1', 'https://blockchain-production-8de2.up.railway.app/trace/e3958bcc-b811-4661-b6ec-4bbcd96e5f98', '2026-09-16 01:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (270, 3295, 'c0ad9ebc2d54d345f5924bffb8858e48', 'https://blockchain-production-8de2.up.railway.app/trace/93651477-05ee-4dae-8585-3e6c9001d5b1', '2026-09-10 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (271, 3296, '1369c7b4e15db652d71c48cedf94649c', 'https://blockchain-production-8de2.up.railway.app/trace/fff0daa5-d5f4-4245-bf70-600bb583c13e', '2026-09-10 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (272, 3297, '781a7fb495973ced19896b4bece98392', 'https://blockchain-production-8de2.up.railway.app/trace/271c3ac4-01a8-4cd6-a08f-f3bd5294ed92', '2026-09-10 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (273, 3298, '58b81b60301b57d6710abf02135e3b90', 'https://blockchain-production-8de2.up.railway.app/trace/823e016e-97c3-4d72-bfe2-98f2979215df', '2026-09-12 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (274, 3299, '537c09f74977964f249235da70ec6145', 'https://blockchain-production-8de2.up.railway.app/trace/0941b871-270b-494a-a381-592435aa09bf', '2026-09-15 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (275, 3300, '198e2b140fb713d28f522eeeaecf4148', 'https://blockchain-production-8de2.up.railway.app/trace/22b07f42-f6d6-4d30-942f-0a91d8e330e5', '2026-09-15 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (276, 3301, 'f6f786f3fbf1dc218e6276aa02ff1176', 'https://blockchain-production-8de2.up.railway.app/trace/a00b54a7-e3fa-4681-9e53-67b3d706b3e1', '2026-09-15 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (277, 3302, 'f9b8a4aab7084cf4a095d243c08444d1', 'https://blockchain-production-8de2.up.railway.app/trace/c9d81de8-62e1-4f3b-8355-306e15758cc7', '2026-09-15 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (278, 3303, '286a07a97a60521cfda5cd31f71ba78c', 'https://blockchain-production-8de2.up.railway.app/trace/efdccd47-4636-4ddf-a790-858b79f231ef', '2026-09-15 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (279, 3304, '0b56d7b3102c28f067d03cc91c541fd3', 'https://blockchain-production-8de2.up.railway.app/trace/1972a0a3-5d80-4fd6-a588-11726dd93704', '2026-09-15 11:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (280, 3305, 'a4ad726b276653cbc015dad09ddf1f76', 'https://blockchain-production-8de2.up.railway.app/trace/1c3a1bff-4a3d-41fe-a1b2-3b680d3d8b58', '2026-09-15 09:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (281, 3306, '9d4026ad294e29bd4c42415ad10d6e2b', 'https://blockchain-production-8de2.up.railway.app/trace/a16af985-8001-4208-838e-c7b890e4dcc1', '2026-09-15 07:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (282, 3307, '05ea59dd6de4cabe5472a9876e56f45c', 'https://blockchain-production-8de2.up.railway.app/trace/8f066954-5cae-496c-8102-2151b67b285f', '2026-09-05 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (283, 3308, '4fd48218f29576b864bfce286b7d76d1', 'https://blockchain-production-8de2.up.railway.app/trace/0f9f825a-e463-402d-9421-43e089f3e07c', '2026-09-05 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (284, 3309, '4c89ae59683043e56c9cb0161a3dd384', 'https://blockchain-production-8de2.up.railway.app/trace/06777778-bd1c-4e25-9a70-13cb8081c4d7', '2026-09-17 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (285, 3310, 'af4579f4e2bfbd6c82a65b51d19c4c99', 'https://blockchain-production-8de2.up.railway.app/trace/d3778aa9-be58-4359-b585-e32eb0947bf6', '2026-09-09 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (286, 3311, '532198a45438b04581f87400bab6516d', 'https://blockchain-production-8de2.up.railway.app/trace/865a5558-e77e-4464-a4dc-5087297a25fe', '2026-09-17 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (287, 3312, '2a87ba4ccb2a872a90c3ad6243f80a86', 'https://blockchain-production-8de2.up.railway.app/trace/573b64b1-7b73-4c4e-bd2a-e7fa51f562cf', '2026-09-17 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (288, 3313, '13ed9ea24bbff768bc1e25d35c2eb520', 'https://blockchain-production-8de2.up.railway.app/trace/2f88164c-487b-41e5-9a2e-5017f05bca5b', '2026-09-17 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (289, 3314, '4cbff3b7bbd1ccaa3d9c43e41248ccad', 'https://blockchain-production-8de2.up.railway.app/trace/b5a42ffd-0afe-4da6-84d1-8c91657a7c13', '2026-09-17 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (290, 3315, 'b5d10319401686e8cc38e8ccf835d9d5', 'https://blockchain-production-8de2.up.railway.app/trace/550aefee-3087-499b-a953-f10f13c46168', '2026-09-17 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (291, 3316, '4675ec0cb55fd2de49b275c89baa08b7', 'https://blockchain-production-8de2.up.railway.app/trace/85b5c5bf-2f9d-45b7-b2a5-a98193ba02dd', '2026-09-17 11:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (292, 3317, '79bf0d195202e56fa97f02a726ac1aaa', 'https://blockchain-production-8de2.up.railway.app/trace/f2ed85af-0e56-4f81-b656-afc943318c5d', '2026-09-17 09:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (293, 3318, 'cc3899a040bfe83b57bb89c33635d373', 'https://blockchain-production-8de2.up.railway.app/trace/2cb2bc8d-594c-4d51-9eeb-adbe089451ca', '2026-09-17 07:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (294, 3319, '29ad59788fe494b3e349646b69d83dca', 'https://blockchain-production-8de2.up.railway.app/trace/0954d537-d89a-41a6-9a50-43f5d0d16330', '2026-09-17 05:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (295, 3320, 'ca949cbdad41956ddcb768595a47cbd6', 'https://blockchain-production-8de2.up.railway.app/trace/fe2eb740-fb2d-43f9-bfe0-3e07d7271d08', '2026-09-07 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (296, 3321, '4b5bff33d9bda167051cc70506a7a01f', 'https://blockchain-production-8de2.up.railway.app/trace/d0dbc929-5301-4410-a9a3-e32d8da01832', '2026-08-06 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (297, 3322, '8bc057788be86b4086b8d65b00ecb952', 'https://blockchain-production-8de2.up.railway.app/trace/ed37e488-87d6-4d7c-ab7e-f6843390a66a', '2026-08-06 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (298, 3323, 'bbadde058ea77550c1f314e44be3a58b', 'https://blockchain-production-8de2.up.railway.app/trace/f4c4c92e-4783-4c02-a85e-f88c7a767160', '2026-08-06 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (299, 3324, 'aaa55ea8ab84bc6edfef04391611b358', 'https://blockchain-production-8de2.up.railway.app/trace/4fb00417-834d-4674-9c78-dd4f7d9342c4', '2026-08-06 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (300, 3325, '02176650cd63ab0c6c43470052b1a89e', 'https://blockchain-production-8de2.up.railway.app/trace/6152b1bd-cac2-4d1a-ad7f-901b46e32960', '2026-08-06 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (301, 3326, 'ae326bf685e0dca7b3118f4cf1d6c727', 'https://blockchain-production-8de2.up.railway.app/trace/76369a25-cec0-417d-908f-e43e9c7d5df9', '2026-08-11 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (302, 3327, '9246ab2e02906238ecab9edf3c66d7c8', 'https://blockchain-production-8de2.up.railway.app/trace/b459ee1b-1ebf-4636-91c5-5dfd312ab614', '2026-08-11 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (303, 3328, 'ef3ffb737edaf292c7dc25e49efe2af7', 'https://blockchain-production-8de2.up.railway.app/trace/891b502f-992c-4d02-87eb-3422e7903be5', '2026-09-19 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (304, 3329, 'f30bf41dea119a74940287a62178761e', 'https://blockchain-production-8de2.up.railway.app/trace/749ffea7-49f1-4e6f-bee1-c34a486236f5', '2026-09-12 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (305, 3330, 'a2bbf211f160d45ab20344d2a6bd526c', 'https://blockchain-production-8de2.up.railway.app/trace/0b8a5dd1-9a52-4663-9072-d2e7399a95ed', '2026-09-16 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (306, 3331, '10b5d5a81a0c494a3940ce0fd88705b1', 'https://blockchain-production-8de2.up.railway.app/trace/7d7e9792-e1ab-49ef-9f7d-17c4c2967998', '2026-09-12 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (307, 3332, '17c553b3319d154c70f5a7017c739fec', 'https://blockchain-production-8de2.up.railway.app/trace/e13ebf62-97e1-40cb-8d47-f98d1acee00a', '2026-09-11 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (308, 3333, 'ea76e13abe6d59b8b73ce8bf0d5f18ba', 'https://blockchain-production-8de2.up.railway.app/trace/2acc892e-e92a-4cc7-a3a3-462d2ab54520', '2026-09-11 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (309, 3334, '3e993fc0315de7b7f61bbce340ae00bf', 'https://blockchain-production-8de2.up.railway.app/trace/46a28809-f3a5-494e-b4ec-7d5e06095b68', '2026-09-05 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (310, 3335, 'c61b66673bebf87d573d87166986a899', 'https://blockchain-production-8de2.up.railway.app/trace/1a93cbde-5b4f-4545-8a78-c04d2ecd96d7', '2026-09-18 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (311, 3336, '061887bb4c957635b62718a9a0f1d5f0', 'https://blockchain-production-8de2.up.railway.app/trace/55285956-1d36-4d63-bec3-09e85097f925', '2026-09-08 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (312, 3337, '7670b44b88c76ed66a950533168eeefa', 'https://blockchain-production-8de2.up.railway.app/trace/8285c21c-6534-4265-8501-8e333a739562', '2026-07-07 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (313, 3338, 'ef4b8eee21d6fe69f685a664276cf790', 'https://blockchain-production-8de2.up.railway.app/trace/22900a74-5d88-4eec-a279-56d5fb2bbaf3', '2026-07-07 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (314, 3339, '0046e3aa9c75c7853a3a161ec9b2b7b7', 'https://blockchain-production-8de2.up.railway.app/trace/1cad9819-807e-407a-9209-f920b029bbd3', '2026-09-06 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (315, 3340, 'ff780f8675461ea697995ea3b86c12bd', 'https://blockchain-production-8de2.up.railway.app/trace/51ea1a50-7938-4623-b599-5f835e0e8a85', '2026-09-11 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (316, 3341, '7923ad1c5f4d437749ee20b6efca4d07', 'https://blockchain-production-8de2.up.railway.app/trace/4cd4d50a-60d8-4b4a-bcf6-5b1fe5f42bab', '2026-09-10 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (317, 3342, 'e60852e0baa3f7451d655272bf927566', 'https://blockchain-production-8de2.up.railway.app/trace/ee0d1234-7a76-431f-9ed2-1ba79f645796', '2026-09-13 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (318, 3343, 'b6303ee0ed446b37883c89394ebd4637', 'https://blockchain-production-8de2.up.railway.app/trace/e69a69d1-fa81-4885-aa5d-08043d47a94e', '2026-09-16 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (319, 3344, '85696d910233d0787cf64bed8fe3fed1', 'https://blockchain-production-8de2.up.railway.app/trace/17e72d3d-bd36-424f-b63e-61f738edc9f5', '2026-09-16 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (320, 3345, '049883e5e3478f8d3ff6b0c6c185dc07', 'https://blockchain-production-8de2.up.railway.app/trace/338b655b-c14e-480e-bf5d-f4d17b93a8ac', '2026-09-16 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (321, 3346, '1aa3d999dae90d1816075e5828f8d00d', 'https://blockchain-production-8de2.up.railway.app/trace/59224a42-ab12-463d-a537-febc00556743', '2026-09-16 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (322, 3347, '2f97dd2e27a1298b7de5aa27963a998d', 'https://blockchain-production-8de2.up.railway.app/trace/03bf7e83-9e80-49af-ab26-475d5ebeb35f', '2026-09-16 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (323, 3348, 'c9b2a2fc0b00c526e172bacaccccdf5b', 'https://blockchain-production-8de2.up.railway.app/trace/75cd0d98-4c0f-425e-b268-7512200fd3b2', '2026-09-16 11:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (324, 3349, 'c2c3d9bab361455aaf8bee2026a6b9f9', 'https://blockchain-production-8de2.up.railway.app/trace/95a0a59a-297d-4328-9c90-ccb3bf7bd5c5', '2026-09-16 09:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (325, 3350, '7033db236512a20d1c7ea0c23928d298', 'https://blockchain-production-8de2.up.railway.app/trace/d82a5812-9cf6-43b7-b374-a8d76db215ba', '2026-09-16 07:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (326, 3351, 'faf6e6dc230ab05124a7796125e0e761', 'https://blockchain-production-8de2.up.railway.app/trace/2a88d247-6e63-42cb-85d4-ebb5637777f7', '2026-09-16 05:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (327, 3352, '53adc8502b039495a15fa711a6b66af7', 'https://blockchain-production-8de2.up.railway.app/trace/7802a4ea-ae77-4625-9695-4fa9173a2010', '2026-09-16 03:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (328, 3353, '21ea065ecf78a912d74357fab64f78c8', 'https://blockchain-production-8de2.up.railway.app/trace/a130f4ca-f71d-41dd-b757-eadfc6628c52', '2026-09-16 01:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (329, 3354, '858e30dd0317521e0c56806cfa4a938e', 'https://blockchain-production-8de2.up.railway.app/trace/35d1b93d-a542-4727-acdc-cc4aa43628b1', '2026-09-10 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (330, 3355, 'f1f6f346bb60c29336176461de643658', 'https://blockchain-production-8de2.up.railway.app/trace/7c1b6dfc-5059-49cf-b846-77005bd93e74', '2026-09-10 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (331, 3356, 'c060e51f816720123463224ee2c03a1e', 'https://blockchain-production-8de2.up.railway.app/trace/328ef1ee-3d78-45c4-8d1c-7c6515bde40c', '2026-09-10 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (332, 3357, '2166e863fbc14dbd160488553b56308a', 'https://blockchain-production-8de2.up.railway.app/trace/405c9fa7-9bbd-4af6-b281-06dabdd20538', '2026-09-06 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (333, 3358, 'd79cc8a1ee71855c56a97ddf9c9902ec', 'https://blockchain-production-8de2.up.railway.app/trace/49e868db-ed60-48d3-8ee2-487083cf120d', '2026-09-15 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (334, 3359, '4a68030d5789ae919b94e6b6a281f56b', 'https://blockchain-production-8de2.up.railway.app/trace/acc84bdc-b73e-41a0-beff-963898dd9827', '2026-09-15 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (335, 3360, '8f654c15f1aeea9a1bb12d3f09cb77b9', 'https://blockchain-production-8de2.up.railway.app/trace/65d9934b-ab3f-4c86-85b1-a66b2a8ef79a', '2026-09-15 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (336, 3361, '3f0049a3eedbccd790e615f3adce37d8', 'https://blockchain-production-8de2.up.railway.app/trace/23ac34d8-0a41-4a84-a10e-998807504232', '2026-09-15 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (337, 3362, 'dac1db138a1a3b4226d809220c7ce360', 'https://blockchain-production-8de2.up.railway.app/trace/01eec0bf-3b4b-423c-830a-c1aab4ca7a64', '2026-09-15 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (338, 3363, 'f678bb30eb6767da8d5ba62f113c04ee', 'https://blockchain-production-8de2.up.railway.app/trace/38413c0d-2cf1-4d83-8c19-61cf50103948', '2026-09-15 11:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (339, 3364, '37e87c29fafff3adffdad33e694d30f7', 'https://blockchain-production-8de2.up.railway.app/trace/11266d90-645e-41b2-9a0f-77b97629de03', '2026-09-15 09:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (340, 3365, '5dfaef346ff457bb87acc1faf6a2705c', 'https://blockchain-production-8de2.up.railway.app/trace/e080ff31-90d6-46ca-90b6-c1a372b60a38', '2026-09-15 07:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (341, 3366, '2a1566482255acd3818954df24ab6d4b', 'https://blockchain-production-8de2.up.railway.app/trace/dd8e7f79-df1c-4a01-82cf-72d20a47fd15', '2026-09-15 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (342, 3367, '203009517767552197916258d6fdecd5', 'https://blockchain-production-8de2.up.railway.app/trace/ad91bef0-b6a2-456d-b91e-8fa6dbb5fa1c', '2026-09-16 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (343, 3368, '9c1000e468c1193284823c450e695bd9', 'https://blockchain-production-8de2.up.railway.app/trace/c9e12893-f8f5-4d1d-84eb-b69eed3ff741', '2026-09-13 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (344, 3369, '2a8644353d0ad3c7eab638fc7d08c79a', 'https://blockchain-production-8de2.up.railway.app/trace/97760e89-0ef0-4867-ac85-95579370dc0e', '2026-09-17 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (345, 3370, '96fc33269888116cb7f301293abb4b08', 'https://blockchain-production-8de2.up.railway.app/trace/9ad6a4e8-7ee5-4276-8a10-bb4a5f421845', '2026-09-17 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (346, 3371, '92e93ed6be188e4e75235ac639eba2c1', 'https://blockchain-production-8de2.up.railway.app/trace/fa28f1ba-05ed-4095-babd-d421806ac6b4', '2026-09-17 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (347, 3372, 'a333ccce19b576c3effc8035bacb6b8b', 'https://blockchain-production-8de2.up.railway.app/trace/865e7373-67ef-43f3-94b5-d8b90132bf68', '2026-09-17 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (348, 3373, '000cd16408b30a20c62d56f36789df68', 'https://blockchain-production-8de2.up.railway.app/trace/9b60e696-683f-4248-847b-265933a1f0e2', '2026-09-17 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (349, 3374, 'dfa5d97767c38278bceb13a48fe7a275', 'https://blockchain-production-8de2.up.railway.app/trace/d672b3e3-6e0c-41e0-a210-3e97952aa525', '2026-09-17 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (350, 3375, 'bf1545ccfe2bacf6f76875931ef940f2', 'https://blockchain-production-8de2.up.railway.app/trace/08b634f9-bbf5-4154-b227-3f5619405e9e', '2026-09-17 11:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (351, 3376, 'a7f089930c3f6048cd7115a560314823', 'https://blockchain-production-8de2.up.railway.app/trace/bff25ed6-0707-4550-82d2-27b6858f8721', '2026-09-17 09:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (352, 3377, 'cebb9d1315525281740e755e01165e03', 'https://blockchain-production-8de2.up.railway.app/trace/165244aa-0714-4771-8974-3e98a67f290c', '2026-09-17 07:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (353, 3378, '6d32757a8ab23ae920af4fd2a1f5e618', 'https://blockchain-production-8de2.up.railway.app/trace/f23d7e2c-bce6-4686-9c8c-f2ae7a3e215e', '2026-09-17 05:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (354, 3379, 'e691f21cb0a5616186be77ad483a8905', 'https://blockchain-production-8de2.up.railway.app/trace/e382ad4b-0f68-40e7-9d10-48534c36e13b', '2026-09-16 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (355, 3380, '9bbe255bbf2c05c466037460b3e6ca23', 'https://blockchain-production-8de2.up.railway.app/trace/2b9b49e8-7035-46f1-ac06-2759473a3952', '2026-08-06 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (356, 3381, '50e30c739604a9656f8609956ff6955c', 'https://blockchain-production-8de2.up.railway.app/trace/59ad0b0f-16ae-4ff1-8bc7-261c61365f6b', '2026-08-06 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (357, 3382, '795937a8171c320c8c760fa65fe71d97', 'https://blockchain-production-8de2.up.railway.app/trace/615f33b6-3fb6-4b4c-852a-11c8927d60cf', '2026-08-06 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (358, 3383, '923ff7f710a425d77be627e937cdb0bf', 'https://blockchain-production-8de2.up.railway.app/trace/f458eea9-d280-4a99-b542-9c0b4fc24ade', '2026-08-06 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (359, 3384, '788f0f0c059e6039e014d0f46d459bb5', 'https://blockchain-production-8de2.up.railway.app/trace/2fa8d4ea-fdf8-46c3-acd0-d77a7296554d', '2026-08-06 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (360, 3385, '2ffa1dfb28ae799672b4cd6de67ea9d4', 'https://blockchain-production-8de2.up.railway.app/trace/6c908cc2-319a-4c64-a17a-0ce2c84228ea', '2026-08-11 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (361, 3386, 'c9d8ae0f67f87684a1b54cdc419d917d', 'https://blockchain-production-8de2.up.railway.app/trace/374e5ca2-0545-4211-98a2-a40d9daad16f', '2026-08-11 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (362, 3387, '7315057963c6baa6f36899470b2c4def', 'https://blockchain-production-8de2.up.railway.app/trace/51d0fc1c-fac0-469e-abc7-bca1ef134f45', '2026-09-07 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (363, 3388, 'fc0414bc55a2d42c89e711cf8ec8c0d2', 'https://blockchain-production-8de2.up.railway.app/trace/5000fc4f-b45a-49a3-8fd7-940885dee324', '2026-09-12 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (364, 3389, '9370528b0fb97073fc5556afd249a7ad', 'https://blockchain-production-8de2.up.railway.app/trace/49b3b6d3-a891-4c14-b369-493cdc560699', '2026-09-09 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (365, 3390, 'fde4e13aad1492b49bf5fe0babb996f9', 'https://blockchain-production-8de2.up.railway.app/trace/c2afe00f-7831-4077-8e35-50b651abf08a', '2026-09-10 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (366, 3391, 'c4dd141f4a39a185c1bec5bfae586525', 'https://blockchain-production-8de2.up.railway.app/trace/1c746918-2f9d-4533-aced-dbdb02a80ed0', '2026-09-05 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (367, 3392, '1f617a72cb6e66516f3c6c919f730d09', 'https://blockchain-production-8de2.up.railway.app/trace/bcd76f24-3d48-4ceb-b77a-e65a54c4049c', '2026-09-18 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (368, 3393, '3ac87612e65b40f429eb66e328c68acd', 'https://blockchain-production-8de2.up.railway.app/trace/0bd0a175-6051-4cfc-a20e-ebbab12995f9', '2026-09-10 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (369, 3394, 'd41ebc42fb46c006621ec22b600e8f40', 'https://blockchain-production-8de2.up.railway.app/trace/eff9639e-71d4-430c-ad0c-37abba97338e', '2026-09-20 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (370, 3395, '3aa364904e54eb263f54f027864d445b', 'https://blockchain-production-8de2.up.railway.app/trace/400c0b70-37ad-42d5-a5c8-b984e3e11ec9', '2026-09-12 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (371, 3396, '3b7fb2eb95c65a6de2a31c8bdbebc9ae', 'https://blockchain-production-8de2.up.railway.app/trace/7fe96904-968e-4ce5-83dc-339365764ac5', '2026-07-07 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (372, 3397, 'a8f4f2ba06625c227cb86c708b22a5fc', 'https://blockchain-production-8de2.up.railway.app/trace/782b7141-4574-4abc-b25a-cb211b5c5f73', '2026-07-07 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (373, 3398, 'ce57d82cd5e955d20c0c369ddb662145', 'https://blockchain-production-8de2.up.railway.app/trace/e72c7d3d-1592-44e6-aacf-88cefa6ed759', '2026-09-20 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (374, 3399, 'f1544c7b2e7ee1edea72bf35544129db', 'https://blockchain-production-8de2.up.railway.app/trace/90d8ba2a-bc45-4c60-be9f-5b5ce31dfc89', '2026-09-06 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (375, 3400, '7fd41c0bb190a6b58f2f3152b08fb8f7', 'https://blockchain-production-8de2.up.railway.app/trace/06fdd1fa-b44e-4cc0-bb62-6c791a395335', '2026-09-08 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (376, 3401, 'fca34b3c609198910b67b6d18a2c0e30', 'https://blockchain-production-8de2.up.railway.app/trace/25f4e451-30fa-4472-8a5a-358d7336f103', '2026-09-05 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (377, 3402, '0f105f1a39c31268c931371e426356f2', 'https://blockchain-production-8de2.up.railway.app/trace/ed9d4fc7-a56e-4d86-8241-69ce3398b3ea', '2026-09-16 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (378, 3403, '42cbd4750c08ac697af54b00e4c9ae32', 'https://blockchain-production-8de2.up.railway.app/trace/1009ae19-b039-4b11-aac2-e4488964b52e', '2026-09-16 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (379, 3404, 'cf96fe1e9f3ff9d22309b1ceac704b37', 'https://blockchain-production-8de2.up.railway.app/trace/ef3b33d9-af0f-4a59-85b0-c00a1f06b011', '2026-09-16 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (380, 3405, 'a8100be2a3a9505b5aaaa260040c08c2', 'https://blockchain-production-8de2.up.railway.app/trace/debb3e1a-c78d-4e5b-82a9-c458a69a7590', '2026-09-16 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (381, 3406, '69e4278fa4aa3b01d0aea7403996a3e6', 'https://blockchain-production-8de2.up.railway.app/trace/267d585d-7e27-48df-a93e-7916c1b38b12', '2026-09-16 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (382, 3407, '3adc9211fc3140cb54cca7d608de9eb6', 'https://blockchain-production-8de2.up.railway.app/trace/bc95ff5b-ab4b-4199-ae80-1a7b0057c917', '2026-09-16 11:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (383, 3408, '6d6717ca8b76430e012d4f44cc684c36', 'https://blockchain-production-8de2.up.railway.app/trace/3754a884-4ae3-47c3-8536-4ea8eceef4f5', '2026-09-16 09:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (384, 3409, 'c5ba66ef855c229cd6d9986e6bf88e7a', 'https://blockchain-production-8de2.up.railway.app/trace/bfc5b381-d1c8-4653-9880-97a66934f2aa', '2026-09-16 07:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (385, 3410, 'df6741b8866cdc947331f434c822a61e', 'https://blockchain-production-8de2.up.railway.app/trace/0d2a44f2-67e0-434c-a338-6b67867eb8a5', '2026-09-16 05:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (386, 3411, '58f7336177598ef1d37b6f6aa7ee5668', 'https://blockchain-production-8de2.up.railway.app/trace/c09aae72-ecc3-458a-98b3-6197b5fc64fe', '2026-09-16 03:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (387, 3412, 'b8eddc9e8e43efa6e7c3022a056a498a', 'https://blockchain-production-8de2.up.railway.app/trace/b84a2505-fc8d-43b8-a59c-6a794553620c', '2026-09-16 01:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (388, 3413, '40dace442ac02f0ba98a0c7ce4868cd9', 'https://blockchain-production-8de2.up.railway.app/trace/f3631b17-e082-4142-958c-40596e4caa08', '2026-09-10 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (389, 3414, '4029c5a38e5fd92693a2e3e5cb9fa0a8', 'https://blockchain-production-8de2.up.railway.app/trace/358d36cb-0752-44b9-963e-45b4767b88ab', '2026-09-10 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (390, 3415, 'ae2637914e3b4bd984f883150e438998', 'https://blockchain-production-8de2.up.railway.app/trace/5468eb7d-fb03-48e8-a511-a266e815b836', '2026-09-10 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (391, 3416, 'edf302d9081624868d7059a284eabb28', 'https://blockchain-production-8de2.up.railway.app/trace/33156983-c0a2-4e1c-878d-48fed51b2dce', '2026-09-15 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (392, 3417, '13f4bf233bed44589052c5bf84ac1b56', 'https://blockchain-production-8de2.up.railway.app/trace/a4ba20b3-2abd-407a-9d75-2c4db74bd60a', '2026-09-15 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (393, 3418, 'a7b9e0b6878d8589d1cb49f8f27d3712', 'https://blockchain-production-8de2.up.railway.app/trace/f3a12048-0c78-4c01-9650-d2e3772ae8f6', '2026-09-15 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (394, 3419, '38f298d0bf09935150507ef5d8dae821', 'https://blockchain-production-8de2.up.railway.app/trace/7e2eba32-7d58-4f27-9171-adf955228ad0', '2026-09-15 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (395, 3420, '70b0b001dc7f9f1dcf92b1069474d36a', 'https://blockchain-production-8de2.up.railway.app/trace/c58ba1ef-a8cb-4a59-aeb2-9911818d2bde', '2026-09-15 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (396, 3421, 'da0c4a2d9b352097bb652c084dc6b3ab', 'https://blockchain-production-8de2.up.railway.app/trace/f7f3ed9c-135a-4286-8973-08d012af0902', '2026-09-15 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (397, 3422, '2a5a473d767743801fb9d0a9b2f95786', 'https://blockchain-production-8de2.up.railway.app/trace/e5895fae-36df-4f88-9e1e-c0bff7a11322', '2026-09-15 11:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (398, 3423, '17e1806237ea93266d2654401a3956f8', 'https://blockchain-production-8de2.up.railway.app/trace/add12079-578f-4851-9682-4fe57a47cac8', '2026-09-15 09:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (399, 3424, '3706750672f988ee8e885ec03d072f27', 'https://blockchain-production-8de2.up.railway.app/trace/b63b3c3b-e42a-49c6-96a7-932d85cc5de4', '2026-09-15 07:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (400, 3425, 'fb17e80b4201bbc5f9274748baf7680f', 'https://blockchain-production-8de2.up.railway.app/trace/00b6cada-45dd-40e5-b9f1-12966c18d4de', '2026-09-16 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (401, 3426, '896250b1a48435c772f3004db2d3bad7', 'https://blockchain-production-8de2.up.railway.app/trace/f85e685d-2548-4e08-b220-a897e85a5f4a', '2026-09-19 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (402, 3427, 'd726da5c59b2020788bdfcf5f0e6ea34', 'https://blockchain-production-8de2.up.railway.app/trace/0985a2c2-9064-43f4-9d82-e801b922ae15', '2026-09-17 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (403, 3428, 'e67272d57266c8b90ec79c03b96a1034', 'https://blockchain-production-8de2.up.railway.app/trace/262c5136-1396-41ad-963e-aed7b8727742', '2026-09-08 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (404, 3429, 'fbd2a52283aef590f70d1ef573828bc8', 'https://blockchain-production-8de2.up.railway.app/trace/dbecf1b3-c688-4a37-88cd-93152be8455c', '2026-09-17 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (405, 3430, 'f76901dc2d76199d7ebce8ba3f59f0fe', 'https://blockchain-production-8de2.up.railway.app/trace/d447d99c-3a88-4195-9d41-4489f2df1f86', '2026-09-17 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (406, 3431, '29fe95ab03e12106b1396982dcf387ee', 'https://blockchain-production-8de2.up.railway.app/trace/4ec670d5-4dac-4045-9e38-08e136f7456a', '2026-09-17 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (407, 3432, 'bb2c3f288d01951b63abfff2cc982b1b', 'https://blockchain-production-8de2.up.railway.app/trace/e5a4b83f-6fba-4434-a5c7-75e676345028', '2026-09-17 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (408, 3433, '571b36a6d12ae6e667a5e15f6aae9278', 'https://blockchain-production-8de2.up.railway.app/trace/fed22896-5bf0-4a5d-96d1-dbd3df6e07f0', '2026-09-17 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (409, 3434, '8ad3f0131f33ab6d9e0131f80e09427f', 'https://blockchain-production-8de2.up.railway.app/trace/0db75c18-1cf4-4d4b-8e0f-7439a13f173b', '2026-09-17 11:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (410, 3435, '423fa89a66e07e33aa64d07dc44def7d', 'https://blockchain-production-8de2.up.railway.app/trace/17e360e0-0dd5-47d4-bf73-def2c2c47320', '2026-09-17 09:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (411, 3436, '4b19ac6b1410eed057995d59699ef357', 'https://blockchain-production-8de2.up.railway.app/trace/4c9dfba2-573a-467b-a9bc-c39b61423ab4', '2026-09-17 07:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (412, 3437, '9df41b7cc6bd9aec7b1cb5f75ba1060d', 'https://blockchain-production-8de2.up.railway.app/trace/9f07733b-24b2-46e9-bb46-0dedfa1fafc6', '2026-09-17 05:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (413, 3438, '2c87198ffc0cf31cbc30a5f17ab9f56d', 'https://blockchain-production-8de2.up.railway.app/trace/9a0f9abe-1f85-425e-a2ac-e4d457168f2f', '2026-09-07 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (414, 3439, 'c8ec70a35a0bd7b9da5b06978b7b8425', 'https://blockchain-production-8de2.up.railway.app/trace/88d3bca1-4983-48ab-895f-358065408f31', '2026-08-06 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (415, 3440, '67aa2f0627230d49777df042f5b1a53e', 'https://blockchain-production-8de2.up.railway.app/trace/ac8f5c2c-120f-4924-9cd8-d5293a565999', '2026-08-06 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (416, 3441, '085e5008f62bfeb764c4a3e6794b4c1f', 'https://blockchain-production-8de2.up.railway.app/trace/c2c39c02-eb1e-48fe-aa92-293fa4b47f56', '2026-08-06 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (417, 3442, '053f5e4bf8d7a35320e36d0004c5d304', 'https://blockchain-production-8de2.up.railway.app/trace/1d845396-415c-4325-9a28-9a832697a2d7', '2026-08-06 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (418, 3443, 'db90f4fb375e74668d59aa3d342983e3', 'https://blockchain-production-8de2.up.railway.app/trace/666d9eed-7226-47a5-92e9-d045e4e5f78b', '2026-08-06 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (419, 3444, 'da14223f5f04d7ccba47674226970d67', 'https://blockchain-production-8de2.up.railway.app/trace/c730123e-0747-43af-a484-a9c9aaa7d6c1', '2026-08-11 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (420, 3445, '843f3fb198c155fe8b760290d10388e3', 'https://blockchain-production-8de2.up.railway.app/trace/5a8ae89f-465b-4746-bc82-cd679231e37b', '2026-08-11 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (421, 3446, '567dc0f15d965fea839032aba6a54488', 'https://blockchain-production-8de2.up.railway.app/trace/67da5834-ec47-4435-9db1-31c9522ee708', '2026-09-13 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (422, 3447, '34774459b5aea54f5c7eb67fd85b0604', 'https://blockchain-production-8de2.up.railway.app/trace/17397ad7-e597-494c-b7a7-ce3eb192c8c1', '2026-09-08 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (423, 3448, 'b6f1f18ffede0412ef9dc33fd2120c50', 'https://blockchain-production-8de2.up.railway.app/trace/31b8da88-fcba-447c-a5d4-6e6f600d42f7', '2026-09-12 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (424, 3449, '179edce2d1af0c8a31ac77482e7eb74d', 'https://blockchain-production-8de2.up.railway.app/trace/c3873b5f-8f18-4129-8de6-28893b1ab93f', '2026-09-13 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (425, 3450, '33f9ac0157da8d22ec4c204943aa1789', 'https://blockchain-production-8de2.up.railway.app/trace/6bb7f344-76a8-4120-8d75-1ac26720463f', '2026-09-11 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (426, 3451, '0f0f7a6c2ff54ce5125560ecb3a5b0a5', 'https://blockchain-production-8de2.up.railway.app/trace/510e4e87-5ae5-4cb3-907d-80dbb91b15a0', '2026-09-20 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (427, 3452, '21bf4e3edab1f27aab7d50894053ea8d', 'https://blockchain-production-8de2.up.railway.app/trace/ae5b9c14-4f49-4f89-a8ba-eb51c05950ca', '2026-09-20 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (428, 3453, 'fc883a6ab18763d122f86be3409b6572', 'https://blockchain-production-8de2.up.railway.app/trace/ae014bd7-90df-4216-8887-cd13a82b11bb', '2026-09-18 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (429, 3454, 'de2362512e26cd05ac973a7f8b44f0f5', 'https://blockchain-production-8de2.up.railway.app/trace/14907587-8662-4f0e-82f6-8092676fc01c', '2026-09-15 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (430, 3455, 'c388a6af99e55664e010126af3960bc9', 'https://blockchain-production-8de2.up.railway.app/trace/37572cca-6fdf-4fe9-a349-ec7c80cf0356', '2026-07-07 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (431, 3456, '63aa6e9e1afbeab36e7e22c31e7f30ad', 'https://blockchain-production-8de2.up.railway.app/trace/3945d588-98e3-4dbe-a4f5-7e1dea3c07f6', '2026-07-07 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (432, 3457, '9984058b6dd9ccd91a6bed7e94c760a7', 'https://blockchain-production-8de2.up.railway.app/trace/4018d301-1144-43dd-bd2f-44d576201a66', '2026-09-07 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (433, 3458, '52b1e09845a8dd9989e925c4174b125a', 'https://blockchain-production-8de2.up.railway.app/trace/856b2291-e1fa-436c-8356-7a6c193a2e4b', '2026-09-05 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (434, 3459, '34e0834f66b39b7d507476cf0b22c909', 'https://blockchain-production-8de2.up.railway.app/trace/8f1fddf6-a2f3-4e23-ac1b-0b1349c35f5f', '2026-09-14 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (435, 3460, 'f3a49ec223776120fbebe67448fc1e2d', 'https://blockchain-production-8de2.up.railway.app/trace/daa5f4b1-f7cf-4475-abf8-92a00b3a94b1', '2026-09-08 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (436, 3461, '585e91e6121af02945afb49fa18f42e2', 'https://blockchain-production-8de2.up.railway.app/trace/6d24e5e8-0d77-448a-bf85-d42ebf594052', '2026-09-16 21:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (437, 3462, '1207383f40d716893fc66803b3805fd4', 'https://blockchain-production-8de2.up.railway.app/trace/8aa6eb79-f923-4bfb-83ab-786f33ea080a', '2026-09-16 19:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (438, 3463, '13dde3ddbe089537a917540ab6fac5c7', 'https://blockchain-production-8de2.up.railway.app/trace/a16b07d6-3e78-4cd1-b2cd-54cc1013807b', '2026-09-16 17:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (439, 3464, 'c9374bc31ecb88ad753f227706f601a6', 'https://blockchain-production-8de2.up.railway.app/trace/311b6a05-58b3-4fd1-9bcf-5e565c198c65', '2026-09-16 15:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (440, 3465, '17df2185199a2d2490b3c7c311465d38', 'https://blockchain-production-8de2.up.railway.app/trace/b3024eb5-ef80-4004-94e2-6d4303a78ee0', '2026-09-16 13:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (441, 3466, 'c790495999b0e59d4be542a59d18bbcb', 'https://blockchain-production-8de2.up.railway.app/trace/6585d7fd-6068-4f31-9ff2-9bcb460b6687', '2026-09-16 11:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (442, 3467, '4724a105d7caad7e03c4c4f30935976e', 'https://blockchain-production-8de2.up.railway.app/trace/5c8f9259-db8f-4e74-825e-f5c9321efa5b', '2026-09-16 09:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (443, 3468, '8b9acbd1750175839755812898c1d66c', 'https://blockchain-production-8de2.up.railway.app/trace/1feb663e-678b-4c21-a8bc-5b0407f9abd7', '2026-09-16 07:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (444, 3469, '64c0df0f1b84e19a77a367293f0e88cb', 'https://blockchain-production-8de2.up.railway.app/trace/a3a23003-cd41-43f0-b789-cae544443fb8', '2026-09-16 05:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (445, 3470, 'b09e7c1364e9b59a97e41ae10b5b831b', 'https://blockchain-production-8de2.up.railway.app/trace/c7b8cf12-1117-43b2-bbfb-16c8414d81c5', '2026-09-16 03:10:55.388878', true);
INSERT INTO public.codigoqr VALUES (446, 3471, '936a7163f9c5fb67034f177cbb4d4364', 'https://blockchain-production-8de2.up.railway.app/trace/f5c5bf8e-12f0-42e5-a816-46fd0d9756f4', '2026-09-16 01:10:55.388878', true);


--
-- Data for Name: compra; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.compra VALUES (2, 1, 2, 'PO-1-SAMSUNG-002', '2026-09-11', 22000.00, 'enviada');
INSERT INTO public.compra VALUES (3, 2, 3, 'PO-2-APPLE-001', '2026-09-14', 15000.00, 'pendiente');
INSERT INTO public.compra VALUES (4, 2, 3, 'PO-2-SAMSUNG-002', '2026-09-11', 22000.00, 'enviada');
INSERT INTO public.compra VALUES (5, 3, 5, 'PO-3-APPLE-001', '2026-09-14', 15000.00, 'pendiente');
INSERT INTO public.compra VALUES (6, 3, 5, 'PO-3-SAMSUNG-002', '2026-09-11', 22000.00, 'enviada');
INSERT INTO public.compra VALUES (7, 4, 7, 'PO-4-APPLE-001', '2026-09-14', 15000.00, 'pendiente');
INSERT INTO public.compra VALUES (8, 4, 7, 'PO-4-SAMSUNG-002', '2026-09-11', 22000.00, 'enviada');
INSERT INTO public.compra VALUES (9, 5, 9, 'PO-5-APPLE-001', '2026-09-14', 15000.00, 'pendiente');
INSERT INTO public.compra VALUES (10, 5, 9, 'PO-5-SAMSUNG-002', '2026-09-11', 22000.00, 'enviada');
INSERT INTO public.compra VALUES (1, 1, 2, 'PO-1-APPLE-001', '2026-09-14', 15000.00, 'cancelada');
INSERT INTO public.compra VALUES (274, 1, 146, 'OC-2026-SCZ-01', '2026-09-20', 26850.00, 'recibida_total');
INSERT INTO public.compra VALUES (275, 2, 694, 'OC-2026-SCZ-02', '2026-09-20', 26850.00, 'recibida_total');
INSERT INTO public.compra VALUES (276, 3, 697, 'OC-2026-SCZ-03', '2026-09-20', 26850.00, 'recibida_total');
INSERT INTO public.compra VALUES (277, 4, 700, 'OC-2026-SCZ-04', '2026-09-20', 26850.00, 'recibida_total');
INSERT INTO public.compra VALUES (278, 5, 703, 'OC-2026-SCZ-05', '2026-09-20', 26850.00, 'recibida_total');


--
-- Data for Name: compradetalle; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.compradetalle VALUES (1, 1, 1, 10, 1500.00, 15000.00);
INSERT INTO public.compradetalle VALUES (2, 2, 2, 20, 1100.00, 22000.00);
INSERT INTO public.compradetalle VALUES (3, 3, 1, 10, 1500.00, 15000.00);
INSERT INTO public.compradetalle VALUES (4, 4, 2, 20, 1100.00, 22000.00);
INSERT INTO public.compradetalle VALUES (5, 5, 1, 10, 1500.00, 15000.00);
INSERT INTO public.compradetalle VALUES (6, 6, 2, 20, 1100.00, 22000.00);
INSERT INTO public.compradetalle VALUES (7, 7, 1, 10, 1500.00, 15000.00);
INSERT INTO public.compradetalle VALUES (8, 8, 2, 20, 1100.00, 22000.00);
INSERT INTO public.compradetalle VALUES (9, 9, 1, 10, 1500.00, 15000.00);
INSERT INTO public.compradetalle VALUES (10, 10, 2, 20, 1100.00, 22000.00);
INSERT INTO public.compradetalle VALUES (281, 274, 398, 5, 1299.00, 6495.00);
INSERT INTO public.compradetalle VALUES (322, 274, 413, 12, 799.00, 9588.00);
INSERT INTO public.compradetalle VALUES (323, 274, 414, 10, 199.00, 1990.00);
INSERT INTO public.compradetalle VALUES (324, 274, 404, 10, 749.00, 7490.00);
INSERT INTO public.compradetalle VALUES (325, 274, 410, 1, 750.00, 750.00);
INSERT INTO public.compradetalle VALUES (326, 274, 415, 7, 22.00, 154.00);
INSERT INTO public.compradetalle VALUES (286, 274, 403, 15, 920.00, 13800.00);
INSERT INTO public.compradetalle VALUES (285, 274, 402, 12, 990.00, 11880.00);
INSERT INTO public.compradetalle VALUES (287, 275, 398, 5, 1299.00, 6495.00);
INSERT INTO public.compradetalle VALUES (282, 274, 399, 4, 1499.00, 5996.00);
INSERT INTO public.compradetalle VALUES (283, 274, 400, 4, 1299.00, 5196.00);
INSERT INTO public.compradetalle VALUES (284, 274, 401, 3, 1099.00, 3297.00);
INSERT INTO public.compradetalle VALUES (288, 275, 399, 4, 1499.00, 5996.00);
INSERT INTO public.compradetalle VALUES (289, 275, 400, 4, 1299.00, 5196.00);
INSERT INTO public.compradetalle VALUES (290, 275, 401, 3, 1099.00, 3297.00);
INSERT INTO public.compradetalle VALUES (294, 276, 399, 4, 1499.00, 5996.00);
INSERT INTO public.compradetalle VALUES (295, 276, 400, 4, 1299.00, 5196.00);
INSERT INTO public.compradetalle VALUES (296, 276, 401, 3, 1099.00, 3297.00);
INSERT INTO public.compradetalle VALUES (300, 277, 399, 4, 1499.00, 5996.00);
INSERT INTO public.compradetalle VALUES (301, 277, 400, 4, 1299.00, 5196.00);
INSERT INTO public.compradetalle VALUES (302, 277, 401, 3, 1099.00, 3297.00);
INSERT INTO public.compradetalle VALUES (306, 278, 399, 4, 1499.00, 5996.00);
INSERT INTO public.compradetalle VALUES (307, 278, 400, 4, 1299.00, 5196.00);
INSERT INTO public.compradetalle VALUES (308, 278, 401, 3, 1099.00, 3297.00);
INSERT INTO public.compradetalle VALUES (327, 275, 413, 12, 799.00, 9588.00);
INSERT INTO public.compradetalle VALUES (328, 275, 414, 10, 199.00, 1990.00);
INSERT INTO public.compradetalle VALUES (329, 275, 404, 10, 749.00, 7490.00);
INSERT INTO public.compradetalle VALUES (330, 275, 410, 1, 750.00, 750.00);
INSERT INTO public.compradetalle VALUES (331, 275, 415, 7, 22.00, 154.00);
INSERT INTO public.compradetalle VALUES (292, 275, 403, 15, 920.00, 13800.00);
INSERT INTO public.compradetalle VALUES (291, 275, 402, 12, 990.00, 11880.00);
INSERT INTO public.compradetalle VALUES (293, 276, 398, 5, 1299.00, 6495.00);
INSERT INTO public.compradetalle VALUES (332, 276, 413, 12, 799.00, 9588.00);
INSERT INTO public.compradetalle VALUES (333, 276, 414, 10, 199.00, 1990.00);
INSERT INTO public.compradetalle VALUES (334, 276, 404, 10, 749.00, 7490.00);
INSERT INTO public.compradetalle VALUES (335, 276, 410, 1, 750.00, 750.00);
INSERT INTO public.compradetalle VALUES (336, 276, 415, 7, 22.00, 154.00);
INSERT INTO public.compradetalle VALUES (298, 276, 403, 15, 920.00, 13800.00);
INSERT INTO public.compradetalle VALUES (297, 276, 402, 12, 990.00, 11880.00);
INSERT INTO public.compradetalle VALUES (299, 277, 398, 5, 1299.00, 6495.00);
INSERT INTO public.compradetalle VALUES (337, 277, 413, 12, 799.00, 9588.00);
INSERT INTO public.compradetalle VALUES (338, 277, 414, 10, 199.00, 1990.00);
INSERT INTO public.compradetalle VALUES (339, 277, 404, 10, 749.00, 7490.00);
INSERT INTO public.compradetalle VALUES (340, 277, 410, 1, 750.00, 750.00);
INSERT INTO public.compradetalle VALUES (341, 277, 415, 7, 22.00, 154.00);
INSERT INTO public.compradetalle VALUES (304, 277, 403, 15, 920.00, 13800.00);
INSERT INTO public.compradetalle VALUES (303, 277, 402, 12, 990.00, 11880.00);
INSERT INTO public.compradetalle VALUES (305, 278, 398, 5, 1299.00, 6495.00);
INSERT INTO public.compradetalle VALUES (342, 278, 413, 12, 799.00, 9588.00);
INSERT INTO public.compradetalle VALUES (343, 278, 414, 10, 199.00, 1990.00);
INSERT INTO public.compradetalle VALUES (344, 278, 404, 10, 749.00, 7490.00);
INSERT INTO public.compradetalle VALUES (345, 278, 410, 1, 750.00, 750.00);
INSERT INTO public.compradetalle VALUES (346, 278, 415, 7, 22.00, 154.00);
INSERT INTO public.compradetalle VALUES (310, 278, 403, 15, 920.00, 13800.00);
INSERT INTO public.compradetalle VALUES (309, 278, 402, 12, 990.00, 11880.00);


--
-- Data for Name: condiciontransporte; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.condiciontransporte VALUES (1, 1, 20.50, 45.00, 1013.20, 0.10, '2026-09-17 03:39:49.281173', 'Sensor IoT BLE');
INSERT INTO public.condiciontransporte VALUES (2, 2, 20.50, 45.00, 1013.20, 0.10, '2026-09-17 03:39:49.364053', 'Sensor IoT BLE');
INSERT INTO public.condiciontransporte VALUES (3, 3, 20.50, 45.00, 1013.20, 0.10, '2026-09-17 03:39:49.411459', 'Sensor IoT BLE');
INSERT INTO public.condiciontransporte VALUES (4, 4, 20.50, 45.00, 1013.20, 0.10, '2026-09-17 03:39:49.449589', 'Sensor IoT BLE');
INSERT INTO public.condiciontransporte VALUES (5, 5, 20.50, 45.00, 1013.20, 0.10, '2026-09-17 03:39:49.486864', 'Sensor IoT BLE');
INSERT INTO public.condiciontransporte VALUES (30, 30, 21.50, 54.00, 965.20, 0.15, '2026-10-05 04:14:32.677705', 'Sensor IoT GPS Teltonika FMC130');
INSERT INTO public.condiciontransporte VALUES (31, 31, 21.50, 54.00, 965.20, 0.15, '2026-10-05 04:14:32.958324', 'Sensor IoT GPS Teltonika FMC130');
INSERT INTO public.condiciontransporte VALUES (32, 32, 21.50, 54.00, 965.20, 0.15, '2026-10-05 04:14:33.213982', 'Sensor IoT GPS Teltonika FMC130');
INSERT INTO public.condiciontransporte VALUES (33, 33, 21.50, 54.00, 965.20, 0.15, '2026-10-05 04:14:33.461505', 'Sensor IoT GPS Teltonika FMC130');
INSERT INTO public.condiciontransporte VALUES (34, 34, 21.50, 54.00, 965.20, 0.15, '2026-10-05 04:14:33.624497', 'Sensor IoT GPS Teltonika FMC130');
INSERT INTO public.condiciontransporte VALUES (35, 35, 21.00, 45.00, 1013.25, 0.10, '2026-10-05 18:13:10.842832', 'Plataforma Web Control');


--
-- Data for Name: consultatrazabilidad; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.consultatrazabilidad VALUES (3, 1, '2026-11-01 16:16:02.343646', '127.0.0.1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36');
INSERT INTO public.consultatrazabilidad VALUES (8, 1, '2026-11-01 18:41:19.39041', '127.0.0.1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36');
INSERT INTO public.consultatrazabilidad VALUES (9, 1, '2026-11-01 18:58:50.343039', '127.0.0.1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36');
INSERT INTO public.consultatrazabilidad VALUES (10, 1, '2026-11-01 18:59:04.020099', '127.0.0.1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36');
INSERT INTO public.consultatrazabilidad VALUES (11, 1, '2026-11-01 18:59:07.887127', '127.0.0.1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36');
INSERT INTO public.consultatrazabilidad VALUES (12, 1, '2026-11-01 18:59:13.590459', '127.0.0.1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36');
INSERT INTO public.consultatrazabilidad VALUES (13, 1, '2026-11-01 19:04:12.260583', '127.0.0.1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36');
INSERT INTO public.consultatrazabilidad VALUES (14, 1, '2026-11-01 19:15:00.285015', '127.0.0.1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36');
INSERT INTO public.consultatrazabilidad VALUES (15, 1, '2026-11-04 02:07:45.607722', '127.0.0.1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36');
INSERT INTO public.consultatrazabilidad VALUES (16, 2, '2026-11-04 02:07:48.810609', '127.0.0.1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36');
INSERT INTO public.consultatrazabilidad VALUES (17, 1, '2026-11-04 02:07:59.565818', '127.0.0.1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36');
INSERT INTO public.consultatrazabilidad VALUES (18, 3, '2026-11-04 02:08:00.474282', '127.0.0.1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36');
INSERT INTO public.consultatrazabilidad VALUES (19, 2, '2026-11-04 02:08:01.593552', '127.0.0.1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36');
INSERT INTO public.consultatrazabilidad VALUES (20, 1, '2026-11-04 02:08:02.97953', '127.0.0.1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36');
INSERT INTO public.consultatrazabilidad VALUES (21, 1, '2026-11-04 02:16:47.404347', '127.0.0.1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36');
INSERT INTO public.consultatrazabilidad VALUES (22, 1, '2026-11-04 03:53:22.36547', '127.0.0.1', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36');
INSERT INTO public.consultatrazabilidad VALUES (24, 210, '2026-11-04 04:15:19.106201', '127.0.0.1', NULL, 'Python-urllib/3.12');


--
-- Data for Name: devolucion; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: devolucionunidad; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: documentounidad; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.documentounidad VALUES (16, 1, 'Factura Comercial USA #32022', 'https://storage.appletrace.bo/tenants/1/invoices/inv_DEMO-1-SN-001_32022.pdf', '2550cc98eececef9ea5d325d787cccad3fa4ad07a44b6b1b10bd1452541f71b0', '2026-08-23', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (17, 1, 'Póliza de Importación DUI-ANB #33884', 'https://storage.appletrace.bo/tenants/1/customs/dui_DEMO-1-SN-001_33884.pdf', 'c95c49595381f5f1a22aa8d7d2110cce222c44f2d38ba1ae30e0c8cf9f4900f7', '2026-09-16', '2031-09-15', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (18, 1, 'Certificado de Garantía Apple Care #86917', 'https://storage.appletrace.bo/tenants/1/warranty/garantia_DEMO-1-SN-001.pdf', 'def0a4205eb87841ddef6948e252d3c04a93aa3efa7cc3064beece45584c4784', '2026-09-29', '2027-09-29', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (19, 1, 'Certificado Criptográfico de Autenticidad #93467', 'https://storage.appletrace.bo/tenants/1/certificates/cert_autenticidad_DEMO-1-SN-001.pdf', '9befe95584f4703aed0ade7ba591b055a85aa160461768f4c0525053f968351a', '2026-10-07', '2029-10-06', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (20, 2, 'Factura Comercial USA #74213', 'https://storage.appletrace.bo/tenants/1/invoices/inv_DEMO-1-SN-002_74213.pdf', '65e04007c0a0ba2ed8e7e6b1405fefceaa304f95a682ca8ce02493e3b8321e19', '2026-08-31', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (21, 2, 'Póliza de Importación DUI-ANB #98666', 'https://storage.appletrace.bo/tenants/1/customs/dui_DEMO-1-SN-002_98666.pdf', '8c5a78e99e27e23a1aaf8152feb259647e82d07b9bc63001e849cd42e597b7c1', '2026-09-10', '2031-09-09', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (22, 2, 'Acta de Inspección Técnica Inicial #50002', 'https://storage.appletrace.bo/tenants/1/reports/inspeccion_DEMO-1-SN-002.pdf', '17ab4f6175b1e9a976015bee25ccd2cc007d122fc8a15e507b36c048d5ca93b7', '2026-10-08', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (23, 3, 'Factura Comercial USA #80965', 'https://storage.appletrace.bo/tenants/1/invoices/inv_DEMO-1-SN-003_80965.pdf', 'e253d3b14ed10c2b733141e302b0bb1eaa38a882481012f80d29c8dc56dc247a', '2026-08-26', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (24, 3, 'Póliza de Importación DUI-ANB #20504', 'https://storage.appletrace.bo/tenants/1/customs/dui_DEMO-1-SN-003_20504.pdf', '8ff9d6b56eb180b31f56608162efbbc0183a03f177c61c773ab7857bf8b49bd2', '2026-09-17', '2031-09-16', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (25, 3, 'Certificado de Garantía Apple Care #80505', 'https://storage.appletrace.bo/tenants/1/warranty/garantia_DEMO-1-SN-003.pdf', '32b95e3a14b681758b82d1e0b40eb949b9573de808477d94bc0c8c67a5067e97', '2026-09-28', '2027-09-28', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (26, 3, 'Certificado Criptográfico de Autenticidad #24494', 'https://storage.appletrace.bo/tenants/1/certificates/cert_autenticidad_DEMO-1-SN-003.pdf', '93497ffc1c3570933f587c62d13c7acc5579d108313fc0e6d09f30e69785eef1', '2026-10-03', '2029-10-02', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (27, 24, 'Factura Comercial USA #70206', 'https://storage.appletrace.bo/tenants/1/invoices/inv_SN-1790796071891_70206.pdf', 'a337200640345c30cdcc69761e00702cdb60d56eee7f13d4dd357f49478ebd9c', '2026-09-01', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (28, 24, 'Póliza de Importación DUI-ANB #55552', 'https://storage.appletrace.bo/tenants/1/customs/dui_SN-1790796071891_55552.pdf', 'ebad64b30de51d55d381e0d6a6f5b13938448b3e6025e99ef952cb5f00258dfc', '2026-09-08', '2031-09-07', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (29, 24, 'Acta de Inspección Técnica Inicial #53384', 'https://storage.appletrace.bo/tenants/1/reports/inspeccion_SN-1790796071891.pdf', '4c10ad50dba71e79c1fd53e73c05045b2b1d22476acb985f22e6958a8ac4b259', '2026-10-12', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (30, 33, 'Factura Comercial USA #65018', 'https://storage.appletrace.bo/tenants/1/invoices/inv_SN-1790797008887_65018.pdf', '7225ee6f3c9f5cabebc25752b2068c2bad0e6fdc9036cf9700e700e6067803ea', '2026-09-01', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (31, 33, 'Póliza de Importación DUI-ANB #84905', 'https://storage.appletrace.bo/tenants/1/customs/dui_SN-1790797008887_84905.pdf', '4abed9241243efb6b21620d6644f35f3c9b69c281f10be53043e9424e9d58f92', '2026-09-10', '2031-09-09', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (32, 33, 'Certificado de Garantía Apple Care #57140', 'https://storage.appletrace.bo/tenants/1/warranty/garantia_SN-1790797008887.pdf', 'e361e6b148519cb7ece5a3a60462c0acb1e907da81b00ddce90fd51f888fc032', '2026-09-25', '2027-09-25', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (33, 33, 'Certificado Criptográfico de Autenticidad #22313', 'https://storage.appletrace.bo/tenants/1/certificates/cert_autenticidad_SN-1790797008887.pdf', '6e0043dc39fea09977a68a0e2d294df18aede5117fbd83eed020008cdbb062e7', '2026-10-04', '2029-10-03', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (34, 42, 'Factura Comercial USA #44773', 'https://storage.appletrace.bo/tenants/1/invoices/inv_SN-1790797109882_44773.pdf', '8ed9c05dcf07f5c92015ff45cedfdf7785f66f64db79ba6dd6106f383e272715', '2026-08-25', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (35, 42, 'Póliza de Importación DUI-ANB #58261', 'https://storage.appletrace.bo/tenants/1/customs/dui_SN-1790797109882_58261.pdf', '0d968c18c02bf587e8604bb4050ee0b53f3c52ce5b459b8ee3427ec1fae51dcf', '2026-09-15', '2031-09-14', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (36, 42, 'Acta de Inspección Técnica Inicial #58765', 'https://storage.appletrace.bo/tenants/1/reports/inspeccion_SN-1790797109882.pdf', '0a66d12ed2e24bcc2c5b9c491c518b57f354d8d0dfc92276a2714c930ce28fc9', '2026-10-12', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (37, 51, 'Factura Comercial USA #61998', 'https://storage.appletrace.bo/tenants/1/invoices/inv_SN-1790797141219_61998.pdf', '661f5991a61693d248bf1885721db16a5ce8547e6eb57947536381d77387e8e2', '2026-08-30', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (38, 51, 'Póliza de Importación DUI-ANB #74199', 'https://storage.appletrace.bo/tenants/1/customs/dui_SN-1790797141219_74199.pdf', 'b0bcc226f57d01b1b1da6a3fe2b6ef0a148a6d718f81eebd7ad0f324df79c104', '2026-09-15', '2031-09-14', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (39, 51, 'Certificado de Garantía Apple Care #99103', 'https://storage.appletrace.bo/tenants/1/warranty/garantia_SN-1790797141219.pdf', '9662749eb71de895999962cece8befea4eda803beae7c003b44899506712e97a', '2026-10-01', '2027-10-01', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (74, 5, 'Póliza de Importación DUI-ANB #91514', 'https://storage.appletrace.bo/tenants/2/customs/dui_DEMO-2-SN-002_91514.pdf', '1fb019ff3fa51a28b2b51718640afb1530f04319d6af195cfebb080bd383bd26', '2026-09-12', '2031-09-11', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (40, 51, 'Certificado Criptográfico de Autenticidad #18353', 'https://storage.appletrace.bo/tenants/1/certificates/cert_autenticidad_SN-1790797141219.pdf', 'eb49ed5087d9d1f740628007de2365dea467394e0b67acb0a7bef7b51f613204', '2026-10-05', '2029-10-04', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (41, 60, 'Factura Comercial USA #90454', 'https://storage.appletrace.bo/tenants/1/invoices/inv_SN-1790797169105_90454.pdf', 'c2a2ef2fd3a49b7e37fc93021f358b58c7661a76d83d56e0eabcb514eec1f728', '2026-08-24', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (42, 60, 'Póliza de Importación DUI-ANB #81659', 'https://storage.appletrace.bo/tenants/1/customs/dui_SN-1790797169105_81659.pdf', '5fa450c07284fff4f1e8ad95e8bf19265349c7ee4d0623d00632efaf578c4d7b', '2026-09-14', '2031-09-13', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (43, 60, 'Acta de Inspección Técnica Inicial #98957', 'https://storage.appletrace.bo/tenants/1/reports/inspeccion_SN-1790797169105.pdf', 'a21eaaca6338b655961ffc821ef119f5c3bd5e3ae103cb450af15d2fb6ae78d9', '2026-10-15', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (44, 69, 'Factura Comercial USA #18662', 'https://storage.appletrace.bo/tenants/1/invoices/inv_SN-1790797397033_18662.pdf', 'fb30a7597322af344d63cceaba143b36ab681d6a9e98d17f68e49cb662250077', '2026-08-29', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (45, 69, 'Póliza de Importación DUI-ANB #32393', 'https://storage.appletrace.bo/tenants/1/customs/dui_SN-1790797397033_32393.pdf', '25e1e292144f421df65977c5ca3e2aa6c7918c086e1ed00bb440aec058d9b845', '2026-09-08', '2031-09-07', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (46, 69, 'Certificado de Garantía Apple Care #40859', 'https://storage.appletrace.bo/tenants/1/warranty/garantia_SN-1790797397033.pdf', 'ce3c0c6eda65a860e5d251c074fe8a3781799d2f1fe41458a0cd4868a2efe45e', '2026-09-26', '2027-09-26', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (47, 69, 'Certificado Criptográfico de Autenticidad #87728', 'https://storage.appletrace.bo/tenants/1/certificates/cert_autenticidad_SN-1790797397033.pdf', 'e660ee3416d429665df819e37d12e66596dfa2757a281716790fe948b4c4b81f', '2026-10-10', '2029-10-09', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (48, 78, 'Factura Comercial USA #72981', 'https://storage.appletrace.bo/tenants/1/invoices/inv_SN-1790797451638_72981.pdf', 'e3f021823e5f8c8604139624476c1629a5932ae20ae9a9f3de6f53ee59897e27', '2026-08-28', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (49, 78, 'Póliza de Importación DUI-ANB #98956', 'https://storage.appletrace.bo/tenants/1/customs/dui_SN-1790797451638_98956.pdf', '8a2e9e4cd01e1bf91eb8d8dab217896e8cdc4adcae90723143c179e0d91e4750', '2026-09-10', '2031-09-09', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (50, 78, 'Acta de Inspección Técnica Inicial #64180', 'https://storage.appletrace.bo/tenants/1/reports/inspeccion_SN-1790797451638.pdf', '4a5a4247b7dff02db38880c588015a1ddc846081b035c5ebcfb6d86469270640', '2026-10-17', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (51, 87, 'Factura Comercial USA #76513', 'https://storage.appletrace.bo/tenants/1/invoices/inv_SN-1790797569880_76513.pdf', 'c0bd88a8326c8b86fa4d4789f9c344f1e2607478f272363cf4cd05f8763bc73a', '2026-08-29', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (52, 87, 'Póliza de Importación DUI-ANB #18669', 'https://storage.appletrace.bo/tenants/1/customs/dui_SN-1790797569880_18669.pdf', 'c305ab535d4ea5719bf83c942a835d61a2ca82f7a2d6eaa6a049c03755dff0c9', '2026-09-13', '2031-09-12', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (53, 87, 'Certificado de Garantía Apple Care #67313', 'https://storage.appletrace.bo/tenants/1/warranty/garantia_SN-1790797569880.pdf', '481df5e357884d2d555c99353159784752b5dcadacdd2e930fd7cb8597bc615b', '2026-10-02', '2027-10-02', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (54, 87, 'Certificado Criptográfico de Autenticidad #16332', 'https://storage.appletrace.bo/tenants/1/certificates/cert_autenticidad_SN-1790797569880.pdf', 'f17d74cb6e501d615da60296b53fe9ef182c6d8d0593a4f0d045cf78dfe856e3', '2026-10-08', '2029-10-07', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (55, 96, 'Factura Comercial USA #94242', 'https://storage.appletrace.bo/tenants/1/invoices/inv_SN-1790797598956_94242.pdf', 'c8e1cc5017e73b49b62dfe84e852c37bb4df194ceaaa78af6ad4edf420794f24', '2026-08-26', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (56, 96, 'Póliza de Importación DUI-ANB #54509', 'https://storage.appletrace.bo/tenants/1/customs/dui_SN-1790797598956_54509.pdf', 'ce808a48feeb760e2937534b609bf62627f77bfff844ba5eadaf07d4f58459e3', '2026-09-12', '2031-09-11', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (57, 96, 'Acta de Inspección Técnica Inicial #97028', 'https://storage.appletrace.bo/tenants/1/reports/inspeccion_SN-1790797598956.pdf', '9ddecae19c149d7b281bb7e4d6d06f5dfda93eb3a813cacf90880229f436c786', '2026-10-09', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (58, 105, 'Factura Comercial USA #99896', 'https://storage.appletrace.bo/tenants/1/invoices/inv_SN-1790799357995_99896.pdf', 'b68f40947403836ff2f26df0e78451129c3b927816f8131923761aca2ab5c9a5', '2026-08-29', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (59, 105, 'Póliza de Importación DUI-ANB #32903', 'https://storage.appletrace.bo/tenants/1/customs/dui_SN-1790799357995_32903.pdf', 'c868c8596a867eb036647e8a7606aaceffaa271e3c5a9482595e26eee8faf0b8', '2026-09-14', '2031-09-13', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (60, 105, 'Certificado de Garantía Apple Care #42539', 'https://storage.appletrace.bo/tenants/1/warranty/garantia_SN-1790799357995.pdf', '47f7d3b110cba18ffa9b9cd76800d278449f2d18c9cbefcb763fda64794c6e48', '2026-09-25', '2027-09-25', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (61, 105, 'Certificado Criptográfico de Autenticidad #58264', 'https://storage.appletrace.bo/tenants/1/certificates/cert_autenticidad_SN-1790799357995.pdf', '9392d99d8d9a37d2525795346cbe9ab1faa58befb8abb9ced98f289f7f54ef8a', '2026-10-03', '2029-10-02', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (62, 114, 'Factura Comercial USA #22644', 'https://storage.appletrace.bo/tenants/1/invoices/inv_SN-1790799757077_22644.pdf', 'bf6e27be485c011c005c0b14e456aa032ed16222ab6644bae78f0d320be4313f', '2026-08-26', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (63, 114, 'Póliza de Importación DUI-ANB #35708', 'https://storage.appletrace.bo/tenants/1/customs/dui_SN-1790799757077_35708.pdf', '13b101077ffb6caf56941f132ce32453421434897dad8e6ba88430880392d5a6', '2026-09-08', '2031-09-07', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (64, 114, 'Acta de Inspección Técnica Inicial #86812', 'https://storage.appletrace.bo/tenants/1/reports/inspeccion_SN-1790799757077.pdf', '8625dbcdbfb277a92839af0731475eaeb26701d8f01ec3d6d1851e213cb0dbe9', '2026-10-10', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (65, 123, 'Factura Comercial USA #35905', 'https://storage.appletrace.bo/tenants/1/invoices/inv_SN-1790800252489_35905.pdf', 'f6f862f3d09730ac689f5a03674c584a7783319d3ec0f4cec3ccd0ec47ec3b7e', '2026-09-02', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (66, 123, 'Póliza de Importación DUI-ANB #63761', 'https://storage.appletrace.bo/tenants/1/customs/dui_SN-1790800252489_63761.pdf', '4cd5421369b79301298902150df887016e305443776a01f3f74fa87e5c82d154', '2026-09-08', '2031-09-07', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (67, 123, 'Certificado de Garantía Apple Care #85830', 'https://storage.appletrace.bo/tenants/1/warranty/garantia_SN-1790800252489.pdf', 'aba1302071c85bdfcfb49a6f5cbf79a3ad9778dfedf68796748656b8f4f0e941', '2026-09-26', '2027-09-26', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (68, 123, 'Certificado Criptográfico de Autenticidad #58612', 'https://storage.appletrace.bo/tenants/1/certificates/cert_autenticidad_SN-1790800252489.pdf', 'c6f0271fde7d8e860e3161855828106562f77cc03ac484c4b8c5bdc60be66f4f', '2026-10-08', '2029-10-07', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (69, 4, 'Factura Comercial USA #63954', 'https://storage.appletrace.bo/tenants/2/invoices/inv_DEMO-2-SN-001_63954.pdf', 'c2b67a13e61e0f5e7abe23224d6c7ed7b6a11a586e50e0ad4bcf2057f838295b', '2026-08-23', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (70, 4, 'Póliza de Importación DUI-ANB #31173', 'https://storage.appletrace.bo/tenants/2/customs/dui_DEMO-2-SN-001_31173.pdf', '98e7497b21d05be8652fc28ae7e1dbd97a7cbd30befc63d3e14786e6e0a7b2aa', '2026-09-08', '2031-09-07', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (71, 4, 'Certificado de Garantía Apple Care #82112', 'https://storage.appletrace.bo/tenants/2/warranty/garantia_DEMO-2-SN-001.pdf', '288037e716c1c17b27ac7bd42db50b86a9ba70617adcc5f147414db7ecdaed8f', '2026-09-25', '2027-09-25', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (72, 4, 'Certificado Criptográfico de Autenticidad #22046', 'https://storage.appletrace.bo/tenants/2/certificates/cert_autenticidad_DEMO-2-SN-001.pdf', '1c8c62f60b4123be64b2e924a4d13760df6b907674fb0703b07a9a295a292eba', '2026-10-08', '2029-10-07', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (73, 5, 'Factura Comercial USA #19445', 'https://storage.appletrace.bo/tenants/2/invoices/inv_DEMO-2-SN-002_19445.pdf', '08585031cf514702e47accbbe585855c460298f1c611454b25a3945fc25ca7c5', '2026-08-28', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (75, 5, 'Acta de Inspección Técnica Inicial #51129', 'https://storage.appletrace.bo/tenants/2/reports/inspeccion_DEMO-2-SN-002.pdf', '15724a235280866de3169d2b5403dde048226a99cbf577cbaa10a3763d804129', '2026-10-16', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (76, 6, 'Factura Comercial USA #69469', 'https://storage.appletrace.bo/tenants/2/invoices/inv_DEMO-2-SN-003_69469.pdf', 'efcd18275a78e44e561d16d836df22e805b3828a234c88b2b8f31bf5e7cb5109', '2026-08-28', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (77, 6, 'Póliza de Importación DUI-ANB #74114', 'https://storage.appletrace.bo/tenants/2/customs/dui_DEMO-2-SN-003_74114.pdf', '260956af713fe88adb22fdf022a9f1cd02dfe7e665f31dfce64fca62c50213da', '2026-09-12', '2031-09-11', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (78, 6, 'Certificado de Garantía Apple Care #24834', 'https://storage.appletrace.bo/tenants/2/warranty/garantia_DEMO-2-SN-003.pdf', '3dfe2d9c1669810d83be37e57020b8413a31fc555a187350dd7620121c5c5adc', '2026-09-23', '2027-09-23', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (79, 6, 'Certificado Criptográfico de Autenticidad #24438', 'https://storage.appletrace.bo/tenants/2/certificates/cert_autenticidad_DEMO-2-SN-003.pdf', '160729eeda81952c24b1a046602b00113b00fc98c90e8635cb085d11ff30f6f8', '2026-10-06', '2029-10-05', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (80, 419, 'Factura Comercial USA #60110', 'https://storage.appletrace.bo/tenants/2/invoices/inv_DX32EH47BL7_60110.pdf', '176eeca4742ba1eacdab70f2ef1ecff23290375c84bc924a46534df84a18632c', '2026-08-25', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (81, 419, 'Póliza de Importación DUI-ANB #51588', 'https://storage.appletrace.bo/tenants/2/customs/dui_DX32EH47BL7_51588.pdf', 'ca1ebbf4fddc02e28428ef72f6d0654ca1d72b2e227e1ac91992ce2ecfddbf9d', '2026-09-16', '2031-09-15', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (82, 419, 'Acta de Inspección Técnica Inicial #90806', 'https://storage.appletrace.bo/tenants/2/reports/inspeccion_DX32EH47BL7.pdf', 'f1546f5df3bde4a6c9171aa0d37648fc7002a357b480e477a2c3f2a98413cd17', '2026-10-14', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (83, 420, 'Factura Comercial USA #48697', 'https://storage.appletrace.bo/tenants/2/invoices/inv_C392J46FV2T_48697.pdf', 'ec7a4f0b13961f2032069ffe62d0fd5ca447a9e9df01b95d30325d7427ab7150', '2026-09-02', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (84, 420, 'Póliza de Importación DUI-ANB #24744', 'https://storage.appletrace.bo/tenants/2/customs/dui_C392J46FV2T_24744.pdf', 'c74807c40a53553c98cf80d38a9aa13aa72358963d194479ab9d2adc20d39996', '2026-09-15', '2031-09-14', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (85, 420, 'Certificado de Garantía Apple Care #29519', 'https://storage.appletrace.bo/tenants/2/warranty/garantia_C392J46FV2T.pdf', '2b7b3c6808a3e0a188367be88f8f72980b2d169d114ccb60878dce955d9b72ad', '2026-09-30', '2027-09-30', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (86, 420, 'Certificado Criptográfico de Autenticidad #27770', 'https://storage.appletrace.bo/tenants/2/certificates/cert_autenticidad_C392J46FV2T.pdf', '0a1e1028b2212493ad047f4c3d6fcf4bccb221cc2fc26794d25ed86a4231f535', '2026-10-09', '2029-10-08', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (87, 421, 'Factura Comercial USA #44461', 'https://storage.appletrace.bo/tenants/2/invoices/inv_K4L2GXJ1HU2_44461.pdf', '67f9ad8f86e25d3169de43b71c49221119464911de9784f5ecb8c7686b7709ea', '2026-08-24', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (88, 421, 'Póliza de Importación DUI-ANB #29857', 'https://storage.appletrace.bo/tenants/2/customs/dui_K4L2GXJ1HU2_29857.pdf', '8f08f2a51ed70a5fd59472cfea28fb01ba836a47fa98b89c20d3b5fce482dd93', '2026-09-13', '2031-09-12', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (89, 421, 'Acta de Inspección Técnica Inicial #47160', 'https://storage.appletrace.bo/tenants/2/reports/inspeccion_K4L2GXJ1HU2.pdf', '666eafe1306a17ea411705d2fcb5d1729c77bbec33095d3e0d0f183058b377d8', '2026-10-13', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (90, 422, 'Factura Comercial USA #29216', 'https://storage.appletrace.bo/tenants/2/invoices/inv_DX329EJAZTH_29216.pdf', '5266b2833797529754a1cc1ec487984cad33253cca7626e2ac0023e3dc33b807', '2026-08-29', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (91, 422, 'Póliza de Importación DUI-ANB #87111', 'https://storage.appletrace.bo/tenants/2/customs/dui_DX329EJAZTH_87111.pdf', '7caaa6100a922627b0136e2710ae7ad856454c0eb741bd799fa01fc0129655e0', '2026-09-17', '2031-09-16', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (92, 422, 'Certificado de Garantía Apple Care #10751', 'https://storage.appletrace.bo/tenants/2/warranty/garantia_DX329EJAZTH.pdf', '835bb9ca4d7a944b2dce56a1d6d95c730961819280ea918dccab98c7cb5fe0c2', '2026-09-28', '2027-09-28', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (93, 422, 'Certificado Criptográfico de Autenticidad #31478', 'https://storage.appletrace.bo/tenants/2/certificates/cert_autenticidad_DX329EJAZTH.pdf', 'e659ff43f683ca62cd75a62df86575ae5bdc401db73488d385a840e5556e1735', '2026-10-10', '2029-10-09', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (94, 423, 'Factura Comercial USA #51810', 'https://storage.appletrace.bo/tenants/2/invoices/inv_M0321CJE1CX_51810.pdf', 'e4e162462ceaaaa2d8dda1e2966c6860c25c5b609dca5b10cd97931b76bdf5af', '2026-08-28', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (95, 423, 'Póliza de Importación DUI-ANB #22983', 'https://storage.appletrace.bo/tenants/2/customs/dui_M0321CJE1CX_22983.pdf', '67e2ce42be727645838bd2d0784972e2b1e3c40b8e87e94b3181f5ddf81d14e8', '2026-09-08', '2031-09-07', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (96, 423, 'Acta de Inspección Técnica Inicial #23635', 'https://storage.appletrace.bo/tenants/2/reports/inspeccion_M0321CJE1CX.pdf', '7b0212bbc7b687a7b1fa93d8a3eca296a916aa87e3f289be8de67f9457af1dc5', '2026-10-09', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (97, 424, 'Factura Comercial USA #63146', 'https://storage.appletrace.bo/tenants/2/invoices/inv_DX32AT706BV_63146.pdf', 'ae1eac80d368fc7817217d46c48f97385ff93636d27483420f344a076c5f6c82', '2026-09-02', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (98, 424, 'Póliza de Importación DUI-ANB #77957', 'https://storage.appletrace.bo/tenants/2/customs/dui_DX32AT706BV_77957.pdf', '2b43a2b85a6e19c19cdbdc39996995b2431631dd0792b044b5db2be376d1f47d', '2026-09-07', '2031-09-06', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (99, 424, 'Certificado de Garantía Apple Care #24406', 'https://storage.appletrace.bo/tenants/2/warranty/garantia_DX32AT706BV.pdf', '68289edd6aea47a122824fddc7b9ac042b58fe018dca36de23098fe010c97c85', '2026-10-01', '2027-10-01', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (100, 424, 'Certificado Criptográfico de Autenticidad #17168', 'https://storage.appletrace.bo/tenants/2/certificates/cert_autenticidad_DX32AT706BV.pdf', '058943a13ffb89f6ae86c9987383e48255a749d91b8729f2c8db046f1116a851', '2026-10-10', '2029-10-09', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (101, 425, 'Factura Comercial USA #79246', 'https://storage.appletrace.bo/tenants/2/invoices/inv_K4L2AUQAADD_79246.pdf', '3a089f7c2258444500dfa6049fee8d9439b2a081328dcd8205478a64436d3cd4', '2026-09-01', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (102, 425, 'Póliza de Importación DUI-ANB #75775', 'https://storage.appletrace.bo/tenants/2/customs/dui_K4L2AUQAADD_75775.pdf', 'ad0d380dbd180b235b1ed1a9e1ebe281a64403ecf8738e897859a4fff41f9e4d', '2026-09-14', '2031-09-13', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (103, 425, 'Acta de Inspección Técnica Inicial #76354', 'https://storage.appletrace.bo/tenants/2/reports/inspeccion_K4L2AUQAADD.pdf', '38feccf400fb75184e865239204940cef7cd29766493981727dde3ddc2cdd954', '2026-10-10', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (104, 426, 'Factura Comercial USA #27690', 'https://storage.appletrace.bo/tenants/2/invoices/inv_G6T208GU2EM_27690.pdf', '1b2ab9a808329b145a7cc4eb498a5ed6d7be15d3a95b45b38e65ba4be7167eca', '2026-08-29', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (105, 426, 'Póliza de Importación DUI-ANB #97945', 'https://storage.appletrace.bo/tenants/2/customs/dui_G6T208GU2EM_97945.pdf', 'a622145f33f84e76a2475713807c0d484b10aa08c23758373c2ac297581eadc6', '2026-09-17', '2031-09-16', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (106, 426, 'Certificado de Garantía Apple Care #82462', 'https://storage.appletrace.bo/tenants/2/warranty/garantia_G6T208GU2EM.pdf', '95b632f80c18aef524b08fc47bde7378c26cd83dea00c8401b82bb264a9e8e3f', '2026-09-27', '2027-09-27', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (107, 426, 'Certificado Criptográfico de Autenticidad #47466', 'https://storage.appletrace.bo/tenants/2/certificates/cert_autenticidad_G6T208GU2EM.pdf', '2966e5819a31754fada6db9677a858a207167ef466106bd2fa80a753b2f0a47b', '2026-10-03', '2029-10-02', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (108, 427, 'Factura Comercial USA #35426', 'https://storage.appletrace.bo/tenants/2/invoices/inv_J8K2FRU9SG8_35426.pdf', '9fef1d7028879ed17999a50dc920e8dca6088053ff9d4210cbd4f9b916aa7c3d', '2026-09-02', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (109, 427, 'Póliza de Importación DUI-ANB #57902', 'https://storage.appletrace.bo/tenants/2/customs/dui_J8K2FRU9SG8_57902.pdf', '7a6033dd8faa1c930bc3a818886945f8e126351844a0007ede99953c48f704ed', '2026-09-10', '2031-09-09', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (110, 427, 'Acta de Inspección Técnica Inicial #23713', 'https://storage.appletrace.bo/tenants/2/reports/inspeccion_J8K2FRU9SG8.pdf', '34cc6d3508f7f2a20583b8f6e460cd88aac51474db895397af6fc2fcc75b9a72', '2026-10-13', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (111, 428, 'Factura Comercial USA #34322', 'https://storage.appletrace.bo/tenants/2/invoices/inv_J8K27E0BPD5_34322.pdf', '53ca47339622e2bcf7445aab74ba75312b64fd93b3464f84018c90931320db13', '2026-09-01', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (112, 428, 'Póliza de Importación DUI-ANB #61022', 'https://storage.appletrace.bo/tenants/2/customs/dui_J8K27E0BPD5_61022.pdf', '0b93c372df9c72947ea28e1dfb8af992ca69e19f2ac6c5f3a211b9ac7f473e9e', '2026-09-07', '2031-09-06', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (113, 428, 'Certificado de Garantía Apple Care #33513', 'https://storage.appletrace.bo/tenants/2/warranty/garantia_J8K27E0BPD5.pdf', '336fabfa19fda7008ec5fa2454080eb5642bfe624a4853fe4437e02a40514512', '2026-10-01', '2027-10-01', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (114, 428, 'Certificado Criptográfico de Autenticidad #80535', 'https://storage.appletrace.bo/tenants/2/certificates/cert_autenticidad_J8K27E0BPD5.pdf', 'c555c864c177ab5245c49522f1eeb574a25029dc361e6d5a7a1d670b5556a64c', '2026-10-03', '2029-10-02', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (115, 429, 'Factura Comercial USA #18556', 'https://storage.appletrace.bo/tenants/2/invoices/inv_C392UM8G3YF_18556.pdf', 'f16cce26f20e77793d6137d83ef812f35460ed715300c5b788b03576f636e571', '2026-09-01', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (116, 429, 'Póliza de Importación DUI-ANB #48488', 'https://storage.appletrace.bo/tenants/2/customs/dui_C392UM8G3YF_48488.pdf', 'e3a0e76b54a12adca9c77f3a5e2c8bd406ed5051306664a969b027f6fe5dbedb', '2026-09-16', '2031-09-15', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (117, 429, 'Acta de Inspección Técnica Inicial #77016', 'https://storage.appletrace.bo/tenants/2/reports/inspeccion_C392UM8G3YF.pdf', 'e8d5af915244baa48f90b2df65ebcb16567acd39863194137e096d0da6ab2327', '2026-10-09', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (118, 430, 'Factura Comercial USA #92802', 'https://storage.appletrace.bo/tenants/2/invoices/inv_F172UT3YMUQ_92802.pdf', '54da517ffec04e96386f4764ce0b8ba252087eae7ae52a8528379db4ddcc8d45', '2026-08-31', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (119, 430, 'Póliza de Importación DUI-ANB #16751', 'https://storage.appletrace.bo/tenants/2/customs/dui_F172UT3YMUQ_16751.pdf', 'd751d33ec43e32588921f37e4e9a8ec8a2b07e8a23014481e9bf55e18d1f6ddf', '2026-09-10', '2031-09-09', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (120, 430, 'Certificado de Garantía Apple Care #85440', 'https://storage.appletrace.bo/tenants/2/warranty/garantia_F172UT3YMUQ.pdf', 'c2a7f3d072882924bed747156ae88ea1ed2ee5a974ce0723710ed4bab57641df', '2026-09-25', '2027-09-25', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (121, 430, 'Certificado Criptográfico de Autenticidad #68744', 'https://storage.appletrace.bo/tenants/2/certificates/cert_autenticidad_F172UT3YMUQ.pdf', 'f0598179b0cac61dad0744e8c795d8227231f3b9adafcf5eec53c60e46f732df', '2026-10-08', '2029-10-07', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (122, 7, 'Factura Comercial USA #43781', 'https://storage.appletrace.bo/tenants/3/invoices/inv_DEMO-3-SN-001_43781.pdf', 'be1ed0cfce6565fa0d8eeafdaf9c7e6194f18438df3ffe95024c6fa5ebb3f0f1', '2026-08-27', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (123, 7, 'Póliza de Importación DUI-ANB #70910', 'https://storage.appletrace.bo/tenants/3/customs/dui_DEMO-3-SN-001_70910.pdf', '2d340480731e04de3d9a8d11f4b9c8689faeb1aceb7fc63d757ab9bac2536b50', '2026-09-07', '2031-09-06', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (124, 7, 'Certificado de Garantía Apple Care #75274', 'https://storage.appletrace.bo/tenants/3/warranty/garantia_DEMO-3-SN-001.pdf', 'be9a0d561c11b2aa4d0eae8d45327b891fb98c605775a750bc3f6f927bfd05e6', '2026-10-01', '2027-10-01', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (125, 7, 'Certificado Criptográfico de Autenticidad #26871', 'https://storage.appletrace.bo/tenants/3/certificates/cert_autenticidad_DEMO-3-SN-001.pdf', '80ef1b0e5fe52eed47b5fec22dd5735c5f2e29ec4f6e2d41f2289fde7e16593a', '2026-10-09', '2029-10-08', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (126, 8, 'Factura Comercial USA #83648', 'https://storage.appletrace.bo/tenants/3/invoices/inv_DEMO-3-SN-002_83648.pdf', '4706cb5b43012abb4e531c53ad9316c0285e6e3eeb213612e044a053c114f1d2', '2026-09-01', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (127, 8, 'Póliza de Importación DUI-ANB #47564', 'https://storage.appletrace.bo/tenants/3/customs/dui_DEMO-3-SN-002_47564.pdf', '7056342d8b5e0266d67f8d42cf0de408f80ba636bb345a70037dc9f735b17cfd', '2026-09-11', '2031-09-10', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (128, 8, 'Acta de Inspección Técnica Inicial #21390', 'https://storage.appletrace.bo/tenants/3/reports/inspeccion_DEMO-3-SN-002.pdf', '084aa3ad1a63061577372ac11f28df6437dc85428345ed7f4f8d388ff873256a', '2026-10-07', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (129, 9, 'Factura Comercial USA #67651', 'https://storage.appletrace.bo/tenants/3/invoices/inv_DEMO-3-SN-003_67651.pdf', '1c113561d9096a4a346f48adfdc94b052cf4659df8a30ed0afbb97bec364dcfa', '2026-08-25', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (130, 9, 'Póliza de Importación DUI-ANB #65251', 'https://storage.appletrace.bo/tenants/3/customs/dui_DEMO-3-SN-003_65251.pdf', 'd5e519ce27edc906fe14dda63683c9435e2f17b56e3474fe0aefb8c0a19f2d13', '2026-09-10', '2031-09-09', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (131, 9, 'Certificado de Garantía Apple Care #32708', 'https://storage.appletrace.bo/tenants/3/warranty/garantia_DEMO-3-SN-003.pdf', '660a0552d5ebaba336bbbf16467ee150b341ee38ee77184ea456b1fedbe29208', '2026-09-23', '2027-09-23', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (132, 9, 'Certificado Criptográfico de Autenticidad #52753', 'https://storage.appletrace.bo/tenants/3/certificates/cert_autenticidad_DEMO-3-SN-003.pdf', 'b37b223626d4207dac9b5bcaf4d8116c305d975e4970954cfbedb189e967a983', '2026-10-11', '2029-10-10', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (133, 438, 'Factura Comercial USA #98694', 'https://storage.appletrace.bo/tenants/3/invoices/inv_F2L3W1T9C4J_98694.pdf', '231590c54ea0d70f14cf75ffbeca0144d24f919e0a13e344c172560bf82f5a89', '2026-08-30', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (134, 438, 'Póliza de Importación DUI-ANB #38539', 'https://storage.appletrace.bo/tenants/3/customs/dui_F2L3W1T9C4J_38539.pdf', 'edba195220b28125fbf388139795bb7f81b30ae6f2330a08f406e4c745a412bb', '2026-09-15', '2031-09-14', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (135, 438, 'Acta de Inspección Técnica Inicial #83263', 'https://storage.appletrace.bo/tenants/3/reports/inspeccion_F2L3W1T9C4J.pdf', 'e43d44c20050efacf671238faa8a22529df1a9a619cbc72806f36a1d35f3996b', '2026-10-09', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (136, 439, 'Factura Comercial USA #39545', 'https://storage.appletrace.bo/tenants/3/invoices/inv_K4L3AP0UD0V_39545.pdf', '5e6360f50933149b83c837ca21edc2f212abc1b2f5c403932df6cab17393b640', '2026-08-28', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (137, 439, 'Póliza de Importación DUI-ANB #29814', 'https://storage.appletrace.bo/tenants/3/customs/dui_K4L3AP0UD0V_29814.pdf', 'bb9d5d6438d3f03a468f02305ca9dd0b17e6b262ca1f2dbe4e9c245eabb3bbaf', '2026-09-12', '2031-09-11', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (138, 439, 'Certificado de Garantía Apple Care #78649', 'https://storage.appletrace.bo/tenants/3/warranty/garantia_K4L3AP0UD0V.pdf', '43d0d7064115690f79ae1336540acc4343f68a3d917601cac858a3027d04fe66', '2026-10-02', '2027-10-02', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (139, 439, 'Certificado Criptográfico de Autenticidad #81712', 'https://storage.appletrace.bo/tenants/3/certificates/cert_autenticidad_K4L3AP0UD0V.pdf', '8416cd30479878f92ae326bd0280f1255e19550e595dd90c0b09ed697891bcbb', '2026-10-05', '2029-10-04', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (140, 440, 'Factura Comercial USA #45786', 'https://storage.appletrace.bo/tenants/3/invoices/inv_G6T38UGTRB3_45786.pdf', 'fa27d551121c438c10c2629c32e527c35f53ad845729184effd109185bf4df0d', '2026-08-26', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (141, 440, 'Póliza de Importación DUI-ANB #30173', 'https://storage.appletrace.bo/tenants/3/customs/dui_G6T38UGTRB3_30173.pdf', '709fe73d55895a4208c623cfd6b94bd6bc0e5f1b174c08490496d86ce5e6d8c2', '2026-09-11', '2031-09-10', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (142, 440, 'Acta de Inspección Técnica Inicial #95626', 'https://storage.appletrace.bo/tenants/3/reports/inspeccion_G6T38UGTRB3.pdf', 'a00c3408837cef7d3b23333eb00b21da80935a9145d792e3782aa66bf6ee4c3d', '2026-10-11', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (143, 441, 'Factura Comercial USA #14690', 'https://storage.appletrace.bo/tenants/3/invoices/inv_DNP34YAG3W4_14690.pdf', 'b3f05af1769e0aeb18aab27d0ab550e06e558a4962f379cdae26533ef22b2732', '2026-08-27', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (144, 441, 'Póliza de Importación DUI-ANB #95160', 'https://storage.appletrace.bo/tenants/3/customs/dui_DNP34YAG3W4_95160.pdf', '6e84b8dbf1c0312525184941437019280657420f2fe2d8d659a06eaca6bd2598', '2026-09-17', '2031-09-16', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (145, 441, 'Certificado de Garantía Apple Care #50608', 'https://storage.appletrace.bo/tenants/3/warranty/garantia_DNP34YAG3W4.pdf', '577ea627b0293e83d23c432fff43569ada67fd9a8179c31843ad963d063c0ad3', '2026-09-22', '2027-09-22', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (146, 441, 'Certificado Criptográfico de Autenticidad #90165', 'https://storage.appletrace.bo/tenants/3/certificates/cert_autenticidad_DNP34YAG3W4.pdf', '283a311ee6f768439f7ef770b99b142467c14896fae54ddff4b276234fdf2fed', '2026-10-12', '2029-10-11', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (147, 442, 'Factura Comercial USA #31904', 'https://storage.appletrace.bo/tenants/3/invoices/inv_F173S84K2S7_31904.pdf', 'cc159c1f8e159a4d49e3951b1d0c5bc7d91c74ffdbd707eedcec397151a6066a', '2026-08-31', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (148, 442, 'Póliza de Importación DUI-ANB #43368', 'https://storage.appletrace.bo/tenants/3/customs/dui_F173S84K2S7_43368.pdf', '8bd364478a1b2af20dc71877538ec09cd118c58ce5330d7b5862d734ae5e31d8', '2026-09-09', '2031-09-08', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (149, 442, 'Acta de Inspección Técnica Inicial #13286', 'https://storage.appletrace.bo/tenants/3/reports/inspeccion_F173S84K2S7.pdf', '0becb792626971502d03c7baadc211185926ff3091e32287f0fa34f997e042f8', '2026-10-08', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (150, 443, 'Factura Comercial USA #31674', 'https://storage.appletrace.bo/tenants/3/invoices/inv_J8K3M1ZUE3Q_31674.pdf', 'af1d8a1ed0e010611ea63fc57664d1304cfb002628d32783a175b883fb42ff30', '2026-09-02', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (151, 443, 'Póliza de Importación DUI-ANB #15033', 'https://storage.appletrace.bo/tenants/3/customs/dui_J8K3M1ZUE3Q_15033.pdf', '903d183840fbb2d78261109e85ad667243cefa5fca7d810fd0fbf6da0ab165bd', '2026-09-16', '2031-09-15', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (152, 443, 'Certificado de Garantía Apple Care #68286', 'https://storage.appletrace.bo/tenants/3/warranty/garantia_J8K3M1ZUE3Q.pdf', '6a75a7b64c2fb1f9d914778f1c16f850d0db0402b0a07d3176696c6226d3f402', '2026-09-26', '2027-09-26', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (153, 443, 'Certificado Criptográfico de Autenticidad #75771', 'https://storage.appletrace.bo/tenants/3/certificates/cert_autenticidad_J8K3M1ZUE3Q.pdf', '1a1ade168f25355b55272892463f7a14615bf2321f9741e03a010ba836d097c4', '2026-10-12', '2029-10-11', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (154, 444, 'Factura Comercial USA #13097', 'https://storage.appletrace.bo/tenants/3/invoices/inv_J8K32U33RTJ_13097.pdf', '85abe2b4e5e195cbda5899e4b42808b7c23232d85e575d3f5d5e7ebb2197060e', '2026-08-31', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (155, 444, 'Póliza de Importación DUI-ANB #39633', 'https://storage.appletrace.bo/tenants/3/customs/dui_J8K32U33RTJ_39633.pdf', 'bd43da0e9986d38a2a9aba5a747cb3624c910e82012f40abf857553d8dc552f9', '2026-09-16', '2031-09-15', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (156, 444, 'Acta de Inspección Técnica Inicial #62865', 'https://storage.appletrace.bo/tenants/3/reports/inspeccion_J8K32U33RTJ.pdf', '1431574876af8f0082aa80ae30b299b8d5e2911187de61b6595a8bc0e5dc8465', '2026-10-10', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (157, 445, 'Factura Comercial USA #42861', 'https://storage.appletrace.bo/tenants/3/invoices/inv_F1736PAB0VK_42861.pdf', '9aea3580cf87f75759cc381082112ef110db09849928b64b0b6aa90e22457261', '2026-08-25', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (158, 445, 'Póliza de Importación DUI-ANB #75376', 'https://storage.appletrace.bo/tenants/3/customs/dui_F1736PAB0VK_75376.pdf', '49d471e2f5b5a625a29e5e467d9c219142e5454bb7899bd0fb88dfc1a1896143', '2026-09-15', '2031-09-14', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (159, 445, 'Certificado de Garantía Apple Care #11915', 'https://storage.appletrace.bo/tenants/3/warranty/garantia_F1736PAB0VK.pdf', 'df6e0b5fb2693dad00327a21a0393ad559c94b7b7826c3c3ef1a49c42862d18f', '2026-10-01', '2027-10-01', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (160, 445, 'Certificado Criptográfico de Autenticidad #83215', 'https://storage.appletrace.bo/tenants/3/certificates/cert_autenticidad_F1736PAB0VK.pdf', 'd058226d152d7757b51ef107566e2726c42508a6609d9af91ed03a01987ef753', '2026-10-03', '2029-10-02', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (161, 446, 'Factura Comercial USA #63763', 'https://storage.appletrace.bo/tenants/3/invoices/inv_F1737Z16YSR_63763.pdf', 'f1821b5bb09e9f5261a8a83f1a5d408a1f4d51db2e67aaca413359e7e2ada287', '2026-08-27', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (162, 446, 'Póliza de Importación DUI-ANB #29520', 'https://storage.appletrace.bo/tenants/3/customs/dui_F1737Z16YSR_29520.pdf', 'a913b07b879f94be5d7da85eda41c1f855d76054d138df5e92e79086cdfa8e36', '2026-09-08', '2031-09-07', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (163, 446, 'Acta de Inspección Técnica Inicial #40412', 'https://storage.appletrace.bo/tenants/3/reports/inspeccion_F1737Z16YSR.pdf', 'd05018ac85eecf2f1f8b549c8d0efc6ee2942a90e4688f8f4d6291a941f74bc2', '2026-10-11', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (164, 447, 'Factura Comercial USA #39028', 'https://storage.appletrace.bo/tenants/3/invoices/inv_H023LHDABB5_39028.pdf', '467bf7499d65017c148bea96188a67446c55c639ee15ccf85389151866b07031', '2026-08-31', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (165, 447, 'Póliza de Importación DUI-ANB #42534', 'https://storage.appletrace.bo/tenants/3/customs/dui_H023LHDABB5_42534.pdf', '095f6813f41617423a054cd33fe19297ad44d5cbccaf9c83b6bb6d436be2b39d', '2026-09-08', '2031-09-07', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (166, 447, 'Certificado de Garantía Apple Care #64149', 'https://storage.appletrace.bo/tenants/3/warranty/garantia_H023LHDABB5.pdf', 'f2ab80dbc76400fdc9e6af079b110fbc740e9639d0aea31d463aa7f8487de64b', '2026-09-26', '2027-09-26', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (167, 447, 'Certificado Criptográfico de Autenticidad #89712', 'https://storage.appletrace.bo/tenants/3/certificates/cert_autenticidad_H023LHDABB5.pdf', 'c5049b09713a3f627f1b649cc33ef4ecf6206b58a4c0c081d2bd0f646425129b', '2026-10-03', '2029-10-02', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (168, 448, 'Factura Comercial USA #39559', 'https://storage.appletrace.bo/tenants/3/invoices/inv_F2L3LB2F1C9_39559.pdf', '6cf07181c256a394b8858ca6ec8fc7981545b3905310f07eb9f47b6690e5a832', '2026-08-31', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (169, 448, 'Póliza de Importación DUI-ANB #75593', 'https://storage.appletrace.bo/tenants/3/customs/dui_F2L3LB2F1C9_75593.pdf', '7103666be36f4e0602899b657359858444ea47f91061132de2a04de5a194bf0a', '2026-09-13', '2031-09-12', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (170, 448, 'Acta de Inspección Técnica Inicial #98944', 'https://storage.appletrace.bo/tenants/3/reports/inspeccion_F2L3LB2F1C9.pdf', '9d87d47306ae739a56eb3ba394ea277a70c7b42a0b78dbcda61949ef5af73bc6', '2026-10-16', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (171, 449, 'Factura Comercial USA #55090', 'https://storage.appletrace.bo/tenants/3/invoices/inv_DX3323P9QNW_55090.pdf', '746dc02a64bef101742310667973abdb68d926246efc9c0991d73088926c75ca', '2026-08-25', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (172, 449, 'Póliza de Importación DUI-ANB #81259', 'https://storage.appletrace.bo/tenants/3/customs/dui_DX3323P9QNW_81259.pdf', '59d0717a1cb01869ac4a599de4906385f6e104dbbe534aa57bcf5014a2c48cd4', '2026-09-10', '2031-09-09', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (173, 449, 'Certificado de Garantía Apple Care #89141', 'https://storage.appletrace.bo/tenants/3/warranty/garantia_DX3323P9QNW.pdf', '57474e6577f7da9cbf30712b90854ff6dc364a196dff7b368f34de57dbc11806', '2026-09-22', '2027-09-22', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (174, 449, 'Certificado Criptográfico de Autenticidad #56482', 'https://storage.appletrace.bo/tenants/3/certificates/cert_autenticidad_DX3323P9QNW.pdf', 'b0cc449457e6320352e58f9dc3b05c0062a35778ca28503f7043d21c980dace4', '2026-10-02', '2029-10-01', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (175, 10, 'Factura Comercial USA #99005', 'https://storage.appletrace.bo/tenants/4/invoices/inv_DEMO-4-SN-001_99005.pdf', '5b1532890a1bc08bcfab382d82ff1f687da107a315134b63b21e76866bc1cfcb', '2026-08-23', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (176, 10, 'Póliza de Importación DUI-ANB #47337', 'https://storage.appletrace.bo/tenants/4/customs/dui_DEMO-4-SN-001_47337.pdf', '4835c6a65675519bad77d0ee2345dfb60dd396e0d98389e0429fe27f966c81c9', '2026-09-15', '2031-09-14', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (177, 10, 'Certificado de Garantía Apple Care #38959', 'https://storage.appletrace.bo/tenants/4/warranty/garantia_DEMO-4-SN-001.pdf', '057777e6589f262c152c49deaf9ffa20c4f5e4b884c9985f4d6650e51e4479d5', '2026-09-28', '2027-09-28', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (178, 10, 'Certificado Criptográfico de Autenticidad #94782', 'https://storage.appletrace.bo/tenants/4/certificates/cert_autenticidad_DEMO-4-SN-001.pdf', '39baaad74160a2e41f7c56c98502559f6f8b65cde408bf361b98404d8396c250', '2026-10-10', '2029-10-09', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (179, 11, 'Factura Comercial USA #46019', 'https://storage.appletrace.bo/tenants/4/invoices/inv_DEMO-4-SN-002_46019.pdf', '8052e1cfa7094ced63285940cb8141e347d8ec3b198e3b3e948e5964ae0a4572', '2026-08-28', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (180, 11, 'Póliza de Importación DUI-ANB #12474', 'https://storage.appletrace.bo/tenants/4/customs/dui_DEMO-4-SN-002_12474.pdf', 'cea1a99c098c6529d8ad00c414aa33c71927190a611dec2daea8189f5e37819b', '2026-09-14', '2031-09-13', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (181, 11, 'Acta de Inspección Técnica Inicial #25046', 'https://storage.appletrace.bo/tenants/4/reports/inspeccion_DEMO-4-SN-002.pdf', '8125ffde1cdb051fa660115cc8cf998c580fda54047d97833e68a0a5855de178', '2026-10-16', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (182, 12, 'Factura Comercial USA #91682', 'https://storage.appletrace.bo/tenants/4/invoices/inv_DEMO-4-SN-003_91682.pdf', '8db7b11d348a90fc510a3ca859daea17602c666674a4695e7726fc2b247e57d7', '2026-08-29', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (183, 12, 'Póliza de Importación DUI-ANB #48003', 'https://storage.appletrace.bo/tenants/4/customs/dui_DEMO-4-SN-003_48003.pdf', 'e170e896a193f9ed9bd05bed1d263c333f07a3b94e7a15a6bedb0064427a3a1f', '2026-09-13', '2031-09-12', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (184, 12, 'Certificado de Garantía Apple Care #86337', 'https://storage.appletrace.bo/tenants/4/warranty/garantia_DEMO-4-SN-003.pdf', '944159c8cbe642a89aa61131733512ff437efd9d5a9abd7db802f447b77a2fd4', '2026-09-23', '2027-09-23', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (185, 12, 'Certificado Criptográfico de Autenticidad #61285', 'https://storage.appletrace.bo/tenants/4/certificates/cert_autenticidad_DEMO-4-SN-003.pdf', 'af277c48b9457406cb2ad4344643aa17df4e889aff49f0e73c10b63234d183a1', '2026-10-07', '2029-10-06', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (186, 457, 'Factura Comercial USA #59056', 'https://storage.appletrace.bo/tenants/4/invoices/inv_G6T4EW1455A_59056.pdf', 'd6929540ce0be57719d8d823f21c0b6510aef906e12983b174263784e90eb4b0', '2026-08-30', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (187, 457, 'Póliza de Importación DUI-ANB #85798', 'https://storage.appletrace.bo/tenants/4/customs/dui_G6T4EW1455A_85798.pdf', '909d26c31112538106885bda088dc22a5fbca4f8cbdba6db64a82e11e6fe0925', '2026-09-07', '2031-09-06', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (188, 457, 'Acta de Inspección Técnica Inicial #96583', 'https://storage.appletrace.bo/tenants/4/reports/inspeccion_G6T4EW1455A.pdf', 'd649648f8fb7ba0e4a004efb191039152dd0f58dfef2f92d57465255a943a332', '2026-10-08', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (189, 458, 'Factura Comercial USA #61165', 'https://storage.appletrace.bo/tenants/4/invoices/inv_M0349YGTPA2_61165.pdf', '27ce2e2223370bd2cdd2bbf260eed100afc6e852ed94c8c540587f4af1ec5ddf', '2026-08-30', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (190, 458, 'Póliza de Importación DUI-ANB #52357', 'https://storage.appletrace.bo/tenants/4/customs/dui_M0349YGTPA2_52357.pdf', '23d5ad18ef7926be64c35947f7f19e6f85aa1e50956dd31c8593b7c7d974a5a3', '2026-09-07', '2031-09-06', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (191, 458, 'Certificado de Garantía Apple Care #65994', 'https://storage.appletrace.bo/tenants/4/warranty/garantia_M0349YGTPA2.pdf', 'd29ce82612f308e2b81a540832a60e102fa136e707075121e39a330e20478568', '2026-10-01', '2027-10-01', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (192, 458, 'Certificado Criptográfico de Autenticidad #64164', 'https://storage.appletrace.bo/tenants/4/certificates/cert_autenticidad_M0349YGTPA2.pdf', 'df8f47ec6ce7cd3a7fb1530a7fb5f33aa90b8afd08f05469fd6e29af7aaab096', '2026-10-07', '2029-10-06', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (193, 459, 'Factura Comercial USA #36612', 'https://storage.appletrace.bo/tenants/4/invoices/inv_J8K4VG3DF8K_36612.pdf', '7a345a8ed3e781958fd4352af30ca3ecadf8641b42fdec21348686a8f54f0699', '2026-08-25', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (194, 459, 'Póliza de Importación DUI-ANB #71061', 'https://storage.appletrace.bo/tenants/4/customs/dui_J8K4VG3DF8K_71061.pdf', '80284cdcbbf0f6182a1422cf9df536b3b828eac1b1cc7d9681a347e0d0f41a98', '2026-09-17', '2031-09-16', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (195, 459, 'Acta de Inspección Técnica Inicial #59582', 'https://storage.appletrace.bo/tenants/4/reports/inspeccion_J8K4VG3DF8K.pdf', '20826bc7b224f5946373d3326ed4882c640c07f01ef33cfb719a49000fae92ae', '2026-10-10', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (196, 460, 'Factura Comercial USA #64255', 'https://storage.appletrace.bo/tenants/4/invoices/inv_C394LD11QTH_64255.pdf', '9dcf7f846c7b1406349a1b796ad18493f716a1e14306fb75d73cd3c190bffc42', '2026-08-31', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (197, 460, 'Póliza de Importación DUI-ANB #24309', 'https://storage.appletrace.bo/tenants/4/customs/dui_C394LD11QTH_24309.pdf', '75a844a0eff5299ef7278813daca47024ddccfc6558233acabc92edc7f0fd46d', '2026-09-17', '2031-09-16', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (198, 460, 'Certificado de Garantía Apple Care #91941', 'https://storage.appletrace.bo/tenants/4/warranty/garantia_C394LD11QTH.pdf', '56c54ff612906ed3142e38d96e7b0ecf63c6fb8392f326e6d9f84038c008f037', '2026-09-27', '2027-09-27', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (199, 460, 'Certificado Criptográfico de Autenticidad #26384', 'https://storage.appletrace.bo/tenants/4/certificates/cert_autenticidad_C394LD11QTH.pdf', '098b19c9132a5585542c4369b9ec22bf2be9b2abab3bd13864154ba0b150ef5a', '2026-10-02', '2029-10-01', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (200, 461, 'Factura Comercial USA #47109', 'https://storage.appletrace.bo/tenants/4/invoices/inv_G6T4HQSCT8K_47109.pdf', '4f47de32c9732804cd9b9ab619bd5a6a3e07be007b446b5ce109fc6275e0d6d5', '2026-08-24', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (201, 461, 'Póliza de Importación DUI-ANB #77467', 'https://storage.appletrace.bo/tenants/4/customs/dui_G6T4HQSCT8K_77467.pdf', '3f062874b5595fbd130924828f11e3de6f65fe4a543caeff82ef6fdc58a5f186', '2026-09-12', '2031-09-11', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (202, 461, 'Acta de Inspección Técnica Inicial #87157', 'https://storage.appletrace.bo/tenants/4/reports/inspeccion_G6T4HQSCT8K.pdf', '66a2149d18b0d1449c6aa7cd5731d42035c4478f155a8575e003169aa2891d41', '2026-10-17', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (203, 462, 'Factura Comercial USA #88391', 'https://storage.appletrace.bo/tenants/4/invoices/inv_C394YZSPPGG_88391.pdf', 'f0a59b14b6f550b07529eca6e3ebd629b08b1264aa4ee634e69cb4ff1f4501e0', '2026-08-23', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (204, 462, 'Póliza de Importación DUI-ANB #62244', 'https://storage.appletrace.bo/tenants/4/customs/dui_C394YZSPPGG_62244.pdf', 'de7480274b6f4694637d635d759fb8fbc5d51f8402892bce309ce423cebcaff2', '2026-09-15', '2031-09-14', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (205, 462, 'Certificado de Garantía Apple Care #78646', 'https://storage.appletrace.bo/tenants/4/warranty/garantia_C394YZSPPGG.pdf', 'b48beba7bebcb301c7dd0951b8cb10a7ffa4c0522a86f240e02532abeb176a3c', '2026-09-23', '2027-09-23', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (206, 462, 'Certificado Criptográfico de Autenticidad #50395', 'https://storage.appletrace.bo/tenants/4/certificates/cert_autenticidad_C394YZSPPGG.pdf', '59299c067342312cb113aa1a53153d61b7cde2f416641193782002ac9e8790dd', '2026-10-05', '2029-10-04', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (207, 463, 'Factura Comercial USA #55307', 'https://storage.appletrace.bo/tenants/4/invoices/inv_DNP4EQ3S0JX_55307.pdf', 'd03f1aea478416111501acb6f3f1212d9b41cca4b2f133f40a409367f26e58ee', '2026-08-27', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (208, 463, 'Póliza de Importación DUI-ANB #81924', 'https://storage.appletrace.bo/tenants/4/customs/dui_DNP4EQ3S0JX_81924.pdf', 'c5d2c9d11fb97b1c1c51f50be47a93583e967486e8c9bc661b1c9744cde442c2', '2026-09-07', '2031-09-06', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (209, 463, 'Acta de Inspección Técnica Inicial #77182', 'https://storage.appletrace.bo/tenants/4/reports/inspeccion_DNP4EQ3S0JX.pdf', '82fc75bdb4f5dbe498d9bef714ca563e54ea41dba8405e3d01c6583b5b867f19', '2026-10-16', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (210, 464, 'Factura Comercial USA #81633', 'https://storage.appletrace.bo/tenants/4/invoices/inv_F2L4FMHW4H9_81633.pdf', '1766d0c1c132922c5eb63cf239c43c3fa70db525bf8430c11e556a3843d54d42', '2026-08-28', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (211, 464, 'Póliza de Importación DUI-ANB #90608', 'https://storage.appletrace.bo/tenants/4/customs/dui_F2L4FMHW4H9_90608.pdf', '3e772508680bb11107bdcb2bec206027edf48499e388026c0d4c585fd20080a4', '2026-09-12', '2031-09-11', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (212, 464, 'Certificado de Garantía Apple Care #65894', 'https://storage.appletrace.bo/tenants/4/warranty/garantia_F2L4FMHW4H9.pdf', 'f4d50523fe42e38383c975d8e9617623dd69b777d2ae458cee83d4220774d570', '2026-09-23', '2027-09-23', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (213, 464, 'Certificado Criptográfico de Autenticidad #81141', 'https://storage.appletrace.bo/tenants/4/certificates/cert_autenticidad_F2L4FMHW4H9.pdf', 'e3faf0178d4d27387db559a36d6eba7d885415fc775a5176ae659b38d54a4e2b', '2026-10-09', '2029-10-08', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (214, 465, 'Factura Comercial USA #41238', 'https://storage.appletrace.bo/tenants/4/invoices/inv_F174NF5PXWS_41238.pdf', '5877ca017161cb68ec9a5bf21efc046750d36134128e827e93c3bfb316db032f', '2026-08-26', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (215, 465, 'Póliza de Importación DUI-ANB #55847', 'https://storage.appletrace.bo/tenants/4/customs/dui_F174NF5PXWS_55847.pdf', '6900cb0e191bd955b1fcbbaa74ff310865c6f7546a70aae91054cb0d90c3406d', '2026-09-13', '2031-09-12', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (216, 465, 'Acta de Inspección Técnica Inicial #90958', 'https://storage.appletrace.bo/tenants/4/reports/inspeccion_F174NF5PXWS.pdf', '1ff6fe85c9b3ec095a1fed60e6aa9b2194b16ce07a916079216e902062acb32e', '2026-10-07', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (217, 466, 'Factura Comercial USA #54235', 'https://storage.appletrace.bo/tenants/4/invoices/inv_DNP4PQGWF14_54235.pdf', 'ab7648e54154b1374624d5d61272854ab7f3fffeb7155c3b4432d76ba7b77500', '2026-09-01', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (218, 466, 'Póliza de Importación DUI-ANB #66997', 'https://storage.appletrace.bo/tenants/4/customs/dui_DNP4PQGWF14_66997.pdf', 'a1f63865a8c050b0809683d738c74e5b1de349285580cbc9cf98139646971bbc', '2026-09-10', '2031-09-09', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (219, 466, 'Certificado de Garantía Apple Care #60133', 'https://storage.appletrace.bo/tenants/4/warranty/garantia_DNP4PQGWF14.pdf', '021a8ed49919006ce874b677fb7f9eaf700bce7fa20b4ee531e031522acdeac5', '2026-09-27', '2027-09-27', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (220, 466, 'Certificado Criptográfico de Autenticidad #31278', 'https://storage.appletrace.bo/tenants/4/certificates/cert_autenticidad_DNP4PQGWF14.pdf', '44bd0d4fa2835d4d4c68248d822a35fe534c99046b4fe399a9c14ed9acf3f370', '2026-10-03', '2029-10-02', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (221, 467, 'Factura Comercial USA #42166', 'https://storage.appletrace.bo/tenants/4/invoices/inv_DX344ZD4ZUR_42166.pdf', '3ace4e254e617fa29f35d021c0c8bd5608026ef87e0be7c64a7b6eb179548c18', '2026-08-27', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (222, 467, 'Póliza de Importación DUI-ANB #43445', 'https://storage.appletrace.bo/tenants/4/customs/dui_DX344ZD4ZUR_43445.pdf', 'cc3bc2d3d18c27544bac22be21d9ed7772c06459736607ddd7c265c5742d9d94', '2026-09-08', '2031-09-07', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (223, 467, 'Acta de Inspección Técnica Inicial #89155', 'https://storage.appletrace.bo/tenants/4/reports/inspeccion_DX344ZD4ZUR.pdf', '56324b4983dc851cfb8455393e49b63b31aac9c5fbd393d1b086f6e7f12dabd9', '2026-10-13', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (224, 468, 'Factura Comercial USA #10472', 'https://storage.appletrace.bo/tenants/4/invoices/inv_C394TQALNAA_10472.pdf', '81091377e173fd8d92f3b12f0ada89aba7fc13759259576740ce5e659b8fb96c', '2026-08-25', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (225, 468, 'Póliza de Importación DUI-ANB #22499', 'https://storage.appletrace.bo/tenants/4/customs/dui_C394TQALNAA_22499.pdf', 'e8a13b178f95ea0c075b42c9e462cf68fab6801e4f3d85891716b820a0c8547b', '2026-09-11', '2031-09-10', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (226, 468, 'Certificado de Garantía Apple Care #12411', 'https://storage.appletrace.bo/tenants/4/warranty/garantia_C394TQALNAA.pdf', '8ebc8613aad80cc4592d76103aba60209894aa90a41db7bcac46478ca305ef71', '2026-09-23', '2027-09-23', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (227, 468, 'Certificado Criptográfico de Autenticidad #64387', 'https://storage.appletrace.bo/tenants/4/certificates/cert_autenticidad_C394TQALNAA.pdf', '23709341e88bb161d72d58ad84a1f55c66f69aa8fa4c6a85258ce21889fd8a0d', '2026-10-11', '2029-10-10', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (228, 13, 'Factura Comercial USA #28820', 'https://storage.appletrace.bo/tenants/5/invoices/inv_DEMO-5-SN-001_28820.pdf', '06509b51639cc3f92a601841a06834f68037afdf2c810ce65f10721a34deef89', '2026-08-29', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (229, 13, 'Póliza de Importación DUI-ANB #97543', 'https://storage.appletrace.bo/tenants/5/customs/dui_DEMO-5-SN-001_97543.pdf', '63c11d6af06a014043b514f7524b3af90fcba084732fab5bb5cf4bbbfcebdd18', '2026-09-11', '2031-09-10', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (230, 13, 'Certificado de Garantía Apple Care #66103', 'https://storage.appletrace.bo/tenants/5/warranty/garantia_DEMO-5-SN-001.pdf', 'bcae8035032e1af96c81d117cb624920500d3834b9c2a2d5dc32eaa04830ceaf', '2026-09-27', '2027-09-27', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (231, 13, 'Certificado Criptográfico de Autenticidad #61338', 'https://storage.appletrace.bo/tenants/5/certificates/cert_autenticidad_DEMO-5-SN-001.pdf', '38704f53a930c7ed1fbf770dd4d7a9a11376f874429ee1a5c84602e956fc5967', '2026-10-03', '2029-10-02', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (232, 14, 'Factura Comercial USA #57498', 'https://storage.appletrace.bo/tenants/5/invoices/inv_DEMO-5-SN-002_57498.pdf', '54575c0104e8b1bd303037edd447209516ce62f991b428b05cb33c03267f16ff', '2026-08-31', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (233, 14, 'Póliza de Importación DUI-ANB #38728', 'https://storage.appletrace.bo/tenants/5/customs/dui_DEMO-5-SN-002_38728.pdf', 'eaac7d361ce2a885aafd98f6328b236309b9330ce9b1ed2c42db69498752383d', '2026-09-16', '2031-09-15', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (234, 14, 'Acta de Inspección Técnica Inicial #82101', 'https://storage.appletrace.bo/tenants/5/reports/inspeccion_DEMO-5-SN-002.pdf', '0489c6466f9d5a68431bea2d88070baece6fe772a970c73fd28966839ddbd4e9', '2026-10-15', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (235, 15, 'Factura Comercial USA #23922', 'https://storage.appletrace.bo/tenants/5/invoices/inv_DEMO-5-SN-003_23922.pdf', 'bb5a3f861329dd8f33380d03e8f4bc7170f711d3be724b934e5657cb692181e9', '2026-08-24', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (236, 15, 'Póliza de Importación DUI-ANB #93496', 'https://storage.appletrace.bo/tenants/5/customs/dui_DEMO-5-SN-003_93496.pdf', '26367d2a5e4524e0ae1ae28edaaa7c6cad2bdcf1c2f7c21c21f38a6208bc231e', '2026-09-17', '2031-09-16', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (237, 15, 'Certificado de Garantía Apple Care #95561', 'https://storage.appletrace.bo/tenants/5/warranty/garantia_DEMO-5-SN-003.pdf', 'c9c86ea9d8d8035e824a9cce68e3988ebfdfe14e8c962820b37d5e311bcc450e', '2026-09-30', '2027-09-30', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (238, 15, 'Certificado Criptográfico de Autenticidad #46378', 'https://storage.appletrace.bo/tenants/5/certificates/cert_autenticidad_DEMO-5-SN-003.pdf', '7506fa927acb22815ab6137eb460493edd51629839ace008d0a906fc9499009d', '2026-10-10', '2029-10-09', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (239, 476, 'Factura Comercial USA #16089', 'https://storage.appletrace.bo/tenants/5/invoices/inv_F2L5U2UTN4A_16089.pdf', '615798543feb7d180c6fc146f938b82f2fb755b2af8f46d6e7722b3c809e1124', '2026-09-01', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (240, 476, 'Póliza de Importación DUI-ANB #98292', 'https://storage.appletrace.bo/tenants/5/customs/dui_F2L5U2UTN4A_98292.pdf', '1f31e5a65c1e201a4c0dfe7f998d2006e66034d41241dbca49540416c9f5564c', '2026-09-17', '2031-09-16', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (241, 476, 'Acta de Inspección Técnica Inicial #14825', 'https://storage.appletrace.bo/tenants/5/reports/inspeccion_F2L5U2UTN4A.pdf', 'a3d4413aa7783409c344da0437871c794df8e25304cb57cb4d518d2912b95cc6', '2026-10-10', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (242, 477, 'Factura Comercial USA #65802', 'https://storage.appletrace.bo/tenants/5/invoices/inv_DNP58HHKKFD_65802.pdf', '423ef31669cef530d50e4a02a44ce1050346ae451588f1a240c620c51f09e54d', '2026-08-24', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (243, 477, 'Póliza de Importación DUI-ANB #25047', 'https://storage.appletrace.bo/tenants/5/customs/dui_DNP58HHKKFD_25047.pdf', '5e83d37dbe9b8a7be49a812110a55f2428a8df039f5af66da0b0c3e45d6cd92c', '2026-09-12', '2031-09-11', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (244, 477, 'Certificado de Garantía Apple Care #42951', 'https://storage.appletrace.bo/tenants/5/warranty/garantia_DNP58HHKKFD.pdf', '7e3574c5fe426ae6b56e437687c9cddab5b83adf0b4a776dcced76b558610d42', '2026-09-30', '2027-09-30', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (245, 477, 'Certificado Criptográfico de Autenticidad #80584', 'https://storage.appletrace.bo/tenants/5/certificates/cert_autenticidad_DNP58HHKKFD.pdf', '8169840c119714840d4ab5c933d5915bb5ba8e17015af461ce4aeaf22e82d349', '2026-10-04', '2029-10-03', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (246, 478, 'Factura Comercial USA #57396', 'https://storage.appletrace.bo/tenants/5/invoices/inv_M035EFTM6ND_57396.pdf', '41f6a38cc21e274efe3900f7e129c44acb36d69aa62f1168c9dda867cb3f989c', '2026-08-28', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (247, 478, 'Póliza de Importación DUI-ANB #42346', 'https://storage.appletrace.bo/tenants/5/customs/dui_M035EFTM6ND_42346.pdf', 'ce547e6f49a7122c2fcace770088936a64784cbaf6a4cc7cabb635a3b52e5953', '2026-09-15', '2031-09-14', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (248, 478, 'Acta de Inspección Técnica Inicial #49495', 'https://storage.appletrace.bo/tenants/5/reports/inspeccion_M035EFTM6ND.pdf', '6d05474671be3c181b8bfff681c788000fe5327919cfbb31aa3281dc53b1b140', '2026-10-17', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (249, 479, 'Factura Comercial USA #34035', 'https://storage.appletrace.bo/tenants/5/invoices/inv_DX354A6PHE4_34035.pdf', '6b48f4d351023ed20f47cff9400213796e74de3351d45add5e0edacac561ee58', '2026-08-24', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (250, 479, 'Póliza de Importación DUI-ANB #93201', 'https://storage.appletrace.bo/tenants/5/customs/dui_DX354A6PHE4_93201.pdf', '45ba6556fc00939dfe591aac00ebb7e738fa14aff48e25339ede7bb6e89ba01a', '2026-09-11', '2031-09-10', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (251, 479, 'Certificado de Garantía Apple Care #25500', 'https://storage.appletrace.bo/tenants/5/warranty/garantia_DX354A6PHE4.pdf', '15197e61c5a38563de10f0793250d340ea2eafac30fc12a8afabf420709a1c49', '2026-10-01', '2027-10-01', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (252, 479, 'Certificado Criptográfico de Autenticidad #11435', 'https://storage.appletrace.bo/tenants/5/certificates/cert_autenticidad_DX354A6PHE4.pdf', '3da0801558748193176595c65e9c59ea0301395ffa762c546f9f80a7dcc43645', '2026-10-11', '2029-10-10', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (253, 480, 'Factura Comercial USA #47056', 'https://storage.appletrace.bo/tenants/5/invoices/inv_G6T5SKSGHK9_47056.pdf', 'dad9d557f6bdf9628eca549412cb129125511efac19999cdc13f08509f6ddcc6', '2026-08-23', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (254, 480, 'Póliza de Importación DUI-ANB #41406', 'https://storage.appletrace.bo/tenants/5/customs/dui_G6T5SKSGHK9_41406.pdf', 'c3874507722e60db4f0441480c52a5d2ac94c949ddc1dda1403088a81755abe2', '2026-09-13', '2031-09-12', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (255, 480, 'Acta de Inspección Técnica Inicial #45947', 'https://storage.appletrace.bo/tenants/5/reports/inspeccion_G6T5SKSGHK9.pdf', '1f9cb83d62da1738453a2f17b1edcf1df933f493d098ed4bc99d14e02a330f82', '2026-10-15', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (256, 481, 'Factura Comercial USA #43038', 'https://storage.appletrace.bo/tenants/5/invoices/inv_K4L5B9JBP99_43038.pdf', 'b537352de1aa1bfc34322f7317267e2bea977ac4815ace4675e33a64e70f21c0', '2026-08-29', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (257, 481, 'Póliza de Importación DUI-ANB #26426', 'https://storage.appletrace.bo/tenants/5/customs/dui_K4L5B9JBP99_26426.pdf', '9477800f55e1c505924a09542dec35b4e9e8a161d08226fb52c6116370dce9f2', '2026-09-16', '2031-09-15', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (258, 481, 'Certificado de Garantía Apple Care #59831', 'https://storage.appletrace.bo/tenants/5/warranty/garantia_K4L5B9JBP99.pdf', '5ec8ecdc6401e914552bd01b1695a1b6812a1c6b26d26a1d7f8af4352c87a0e5', '2026-09-23', '2027-09-23', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (259, 481, 'Certificado Criptográfico de Autenticidad #92389', 'https://storage.appletrace.bo/tenants/5/certificates/cert_autenticidad_K4L5B9JBP99.pdf', '3aa441c3d11ebbff287f39b84d7f7e687354eb138a4d7b36778a3b4ab48148cc', '2026-10-05', '2029-10-04', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (260, 482, 'Factura Comercial USA #42150', 'https://storage.appletrace.bo/tenants/5/invoices/inv_K4L50SQQFNC_42150.pdf', '39c63a109852b050c77389ed4e2c6c0b29d5220ee23d13e07b94309d4ec96090', '2026-09-02', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (261, 482, 'Póliza de Importación DUI-ANB #87304', 'https://storage.appletrace.bo/tenants/5/customs/dui_K4L50SQQFNC_87304.pdf', '408a84ea1c04172ab37dd4f98f40d28fa78323db9bd17c96ad40c7b37c832f79', '2026-09-07', '2031-09-06', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (262, 482, 'Acta de Inspección Técnica Inicial #79057', 'https://storage.appletrace.bo/tenants/5/reports/inspeccion_K4L50SQQFNC.pdf', 'ee0db5b35e45cb81c2af946604b447af9661fa2db7a16b06487d97836a3e076f', '2026-10-09', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (263, 483, 'Factura Comercial USA #63401', 'https://storage.appletrace.bo/tenants/5/invoices/inv_DX358CW5DAP_63401.pdf', '4a33fcf9f90795b1b595c9b94881e0b5594c20bd103314ce08582b048df0a814', '2026-08-29', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (264, 483, 'Póliza de Importación DUI-ANB #73669', 'https://storage.appletrace.bo/tenants/5/customs/dui_DX358CW5DAP_73669.pdf', '43164ed0d4abbfd43fcfc6d16587406cc1728eb2d97cc82b549b8fe4a9d2276c', '2026-09-10', '2031-09-09', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (265, 483, 'Certificado de Garantía Apple Care #38661', 'https://storage.appletrace.bo/tenants/5/warranty/garantia_DX358CW5DAP.pdf', '7d70177976aee58637da104470c85024ab17974e5f592b00f42d53c6c83558b7', '2026-09-25', '2027-09-25', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (266, 483, 'Certificado Criptográfico de Autenticidad #15238', 'https://storage.appletrace.bo/tenants/5/certificates/cert_autenticidad_DX358CW5DAP.pdf', '7d1b29e75d8e728b40c89e2c53af68cc3f4287840c4595b4506d14f29f0a4d30', '2026-10-10', '2029-10-09', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (267, 484, 'Factura Comercial USA #19748', 'https://storage.appletrace.bo/tenants/5/invoices/inv_J8K5B7RXLF7_19748.pdf', '8e2bf18c6d46fca6be175a9155f06144000ab590338ace99219a88d48796b71f', '2026-08-30', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (268, 484, 'Póliza de Importación DUI-ANB #55062', 'https://storage.appletrace.bo/tenants/5/customs/dui_J8K5B7RXLF7_55062.pdf', '3daba3a6449481c2298c6db50b512490d4821e6bb8653da8d4753d86082ecb87', '2026-09-17', '2031-09-16', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (269, 484, 'Acta de Inspección Técnica Inicial #55472', 'https://storage.appletrace.bo/tenants/5/reports/inspeccion_J8K5B7RXLF7.pdf', '4ae9c842d252b3d887ad437f69598fa439bf30c47785992fd95d8f89a85394fa', '2026-10-12', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (270, 485, 'Factura Comercial USA #42071', 'https://storage.appletrace.bo/tenants/5/invoices/inv_DX35X4VKCPR_42071.pdf', 'fd254cd840547e881385c10fd708dec92624108afeb13e2efff0f595b6df7b73', '2026-08-24', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (271, 485, 'Póliza de Importación DUI-ANB #73075', 'https://storage.appletrace.bo/tenants/5/customs/dui_DX35X4VKCPR_73075.pdf', '2c56e0605561cb3011413ed618ccb898493db1ebe05bd92165ee9eab345cdf95', '2026-09-09', '2031-09-08', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (272, 485, 'Certificado de Garantía Apple Care #65671', 'https://storage.appletrace.bo/tenants/5/warranty/garantia_DX35X4VKCPR.pdf', 'bcaad2c00b3c7b2ea839c995c2ad4752504753adc665cefacf27c318f8d60fd4', '2026-09-28', '2027-09-28', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (273, 485, 'Certificado Criptográfico de Autenticidad #76388', 'https://storage.appletrace.bo/tenants/5/certificates/cert_autenticidad_DX35X4VKCPR.pdf', 'a8098f00ad82f6c8f9a1547deaf572da711a9c0627e98808a297c8f152c4daf3', '2026-10-06', '2029-10-05', 'certificado_autenticidad');
INSERT INTO public.documentounidad VALUES (274, 486, 'Factura Comercial USA #30020', 'https://storage.appletrace.bo/tenants/5/invoices/inv_C3952EFLARR_30020.pdf', '82f73ed9f22101733f5ff292dc89ad5770e74b7d385f97c938fa5af0111a61a6', '2026-08-24', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (275, 486, 'Póliza de Importación DUI-ANB #64338', 'https://storage.appletrace.bo/tenants/5/customs/dui_C3952EFLARR_64338.pdf', 'e6c2b42c251bea242c190f9d8d436af714453a9fd5f2200daa777ba977adb59d', '2026-09-12', '2031-09-11', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (276, 486, 'Acta de Inspección Técnica Inicial #16835', 'https://storage.appletrace.bo/tenants/5/reports/inspeccion_C3952EFLARR.pdf', '862da4507937483353db42420997fcbe9d8f400265208e8a95058060484317db', '2026-10-14', NULL, 'informe_tecnico');
INSERT INTO public.documentounidad VALUES (277, 487, 'Factura Comercial USA #47023', 'https://storage.appletrace.bo/tenants/5/invoices/inv_C395R0V01CX_47023.pdf', '7ab3aea3ecb456da69a4289de08ab7afe020d404cd2bbc48ce5c5823452971d1', '2026-08-27', NULL, 'factura_compra');
INSERT INTO public.documentounidad VALUES (278, 487, 'Póliza de Importación DUI-ANB #64092', 'https://storage.appletrace.bo/tenants/5/customs/dui_C395R0V01CX_64092.pdf', '55c3e119f7d27e0cde67cb71cb8b54ab18b35fea35427a7f177f6f8ab5d0a689', '2026-09-16', '2031-09-15', 'certificado_importacion');
INSERT INTO public.documentounidad VALUES (279, 487, 'Certificado de Garantía Apple Care #14498', 'https://storage.appletrace.bo/tenants/5/warranty/garantia_C395R0V01CX.pdf', 'e04d59b41b15997025d628902c39f8c7869225bd27d61d201f99d1ebf0ef507a', '2026-09-30', '2027-09-30', 'comprobante_garantia');
INSERT INTO public.documentounidad VALUES (280, 487, 'Certificado Criptográfico de Autenticidad #75166', 'https://storage.appletrace.bo/tenants/5/certificates/cert_autenticidad_C395R0V01CX.pdf', '060b1b27c4843efdd43708cfbf8d61fdd8ee282af18b5dc53045b6c7e7cd7467', '2026-10-06', '2029-10-05', 'certificado_autenticidad');


--
-- Data for Name: envio; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.envio VALUES (1, 1, 2, 1, NULL, 'ENV-1-001', '2026-09-14 03:39:49.161927', '2026-09-19 03:39:49.161927', NULL, 'en_transito', 'DHL-TRACK-100');
INSERT INTO public.envio VALUES (2, 1, 2, 1, NULL, 'ENV-1-002', '2026-09-16 03:39:49.161927', '2026-09-21 03:39:49.161927', NULL, 'preparacion', 'FEDEX-TRACK-200');
INSERT INTO public.envio VALUES (3, 2, 3, 4, NULL, 'ENV-2-001', '2026-09-14 03:39:49.346272', '2026-09-19 03:39:49.346272', NULL, 'en_transito', 'DHL-TRACK-100');
INSERT INTO public.envio VALUES (4, 2, 3, 4, NULL, 'ENV-2-002', '2026-09-16 03:39:49.346272', '2026-09-21 03:39:49.346272', NULL, 'preparacion', 'FEDEX-TRACK-200');
INSERT INTO public.envio VALUES (5, 3, 5, 6, NULL, 'ENV-3-001', '2026-09-14 03:39:49.397933', '2026-09-19 03:39:49.397933', NULL, 'en_transito', 'DHL-TRACK-100');
INSERT INTO public.envio VALUES (6, 3, 5, 6, NULL, 'ENV-3-002', '2026-09-16 03:39:49.397933', '2026-09-21 03:39:49.397933', NULL, 'preparacion', 'FEDEX-TRACK-200');
INSERT INTO public.envio VALUES (7, 4, 7, 8, NULL, 'ENV-4-001', '2026-09-14 03:39:49.439375', '2026-09-19 03:39:49.439375', NULL, 'en_transito', 'DHL-TRACK-100');
INSERT INTO public.envio VALUES (8, 4, 7, 8, NULL, 'ENV-4-002', '2026-09-16 03:39:49.439375', '2026-09-21 03:39:49.439375', NULL, 'preparacion', 'FEDEX-TRACK-200');
INSERT INTO public.envio VALUES (9, 5, 9, 10, NULL, 'ENV-5-001', '2026-09-14 03:39:49.477407', '2026-09-19 03:39:49.477407', NULL, 'en_transito', 'DHL-TRACK-100');
INSERT INTO public.envio VALUES (10, 5, 9, 10, NULL, 'ENV-5-002', '2026-09-16 03:39:49.477407', '2026-09-21 03:39:49.477407', NULL, 'preparacion', 'FEDEX-TRACK-200');
INSERT INTO public.envio VALUES (348, 2, 695, 4, 696, 'ENV-SCZ-02-001', '2026-10-04 18:14:32.839579', '2026-10-05 02:14:32.839579', NULL, 'en_transito', 'BOL-SCZ-827712');
INSERT INTO public.envio VALUES (349, 3, 698, 6, 699, 'ENV-SCZ-03-001', '2026-10-04 18:14:33.155497', '2026-10-05 02:14:33.155497', NULL, 'en_transito', 'BOL-SCZ-905077');
INSERT INTO public.envio VALUES (350, 4, 701, 8, 702, 'ENV-SCZ-04-001', '2026-10-04 18:14:33.381168', '2026-10-05 02:14:33.381168', NULL, 'en_transito', 'BOL-SCZ-559753');
INSERT INTO public.envio VALUES (351, 5, 704, 10, 705, 'ENV-SCZ-05-001', '2026-10-04 18:14:33.621739', '2026-10-05 02:14:33.621739', NULL, 'en_transito', 'BOL-SCZ-270557');
INSERT INTO public.envio VALUES (347, 1, 692, 2, 693, 'ENV-SCZ-01-001', '2026-10-04 18:14:32.577008', '2026-10-05 02:14:32.577008', NULL, 'cancelado', 'BOL-SCZ-804314');


--
-- Data for Name: enviounidad; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.enviounidad VALUES (1, 1, 1);
INSERT INTO public.enviounidad VALUES (2, 1, 2);
INSERT INTO public.enviounidad VALUES (3, 2, 3);
INSERT INTO public.enviounidad VALUES (4, 3, 4);
INSERT INTO public.enviounidad VALUES (5, 3, 5);
INSERT INTO public.enviounidad VALUES (6, 4, 6);
INSERT INTO public.enviounidad VALUES (7, 5, 7);
INSERT INTO public.enviounidad VALUES (8, 5, 8);
INSERT INTO public.enviounidad VALUES (9, 6, 9);
INSERT INTO public.enviounidad VALUES (10, 7, 10);
INSERT INTO public.enviounidad VALUES (11, 7, 11);
INSERT INTO public.enviounidad VALUES (12, 8, 12);
INSERT INTO public.enviounidad VALUES (13, 9, 13);
INSERT INTO public.enviounidad VALUES (14, 9, 14);
INSERT INTO public.enviounidad VALUES (15, 10, 15);
INSERT INTO public.enviounidad VALUES (325, 348, 433);
INSERT INTO public.enviounidad VALUES (326, 348, 434);
INSERT INTO public.enviounidad VALUES (327, 348, 435);
INSERT INTO public.enviounidad VALUES (328, 348, 436);
INSERT INTO public.enviounidad VALUES (329, 349, 452);
INSERT INTO public.enviounidad VALUES (330, 349, 453);
INSERT INTO public.enviounidad VALUES (331, 349, 454);
INSERT INTO public.enviounidad VALUES (332, 349, 455);
INSERT INTO public.enviounidad VALUES (333, 350, 471);
INSERT INTO public.enviounidad VALUES (334, 350, 472);
INSERT INTO public.enviounidad VALUES (335, 350, 473);
INSERT INTO public.enviounidad VALUES (336, 350, 474);
INSERT INTO public.enviounidad VALUES (337, 351, 490);
INSERT INTO public.enviounidad VALUES (338, 351, 491);
INSERT INTO public.enviounidad VALUES (339, 351, 492);
INSERT INTO public.enviounidad VALUES (340, 351, 493);


--
-- Data for Name: eventotrazabilidad; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.eventotrazabilidad VALUES (1, 1, 'transporte_aereo', '2026-09-17 03:39:49.197009', 2, 1, 1, 1, 'Vuelo de carga internacional en ruta a destino', 'd350142f9716fe03390ce5fbbf3cc35ea2c421c89a490cdece2f89d79e356bba', 'verificado');
INSERT INTO public.eventotrazabilidad VALUES (2, 2, 'transporte_aereo', '2026-09-17 03:39:49.355692', 3, 4, 3, 1, 'Vuelo de carga internacional en ruta a destino', '61e6e3792ab880c7d10f3566a3e775108b2cac944b65b38c21b89d83106244f2', 'verificado');
INSERT INTO public.eventotrazabilidad VALUES (3, 3, 'transporte_aereo', '2026-09-17 03:39:49.404049', 5, 6, 5, 1, 'Vuelo de carga internacional en ruta a destino', 'd1a4304cb984a1aa156db4f619e90794b070c995e619c588a2c6bfdb2a3700dc', 'verificado');
INSERT INTO public.eventotrazabilidad VALUES (4, 4, 'transporte_aereo', '2026-09-17 03:39:49.443658', 7, 8, 7, 1, 'Vuelo de carga internacional en ruta a destino', '489966fafe17c7e96b4f5bac89ef7c902bbcbc1eaa8582764dd5a8b05ad3f55f', 'verificado');
INSERT INTO public.eventotrazabilidad VALUES (5, 5, 'transporte_aereo', '2026-09-17 03:39:49.48232', 9, 10, 9, 1, 'Vuelo de carga internacional en ruta a destino', '83adffb653d68743d905a373c9386e8f86942c6288adf635a4ef4859601904ae', 'verificado');
INSERT INTO public.eventotrazabilidad VALUES (30, 1, 'transporte_terrestre', '2026-10-04 19:14:32.597132', 692, 2, 283, 1, 'Despacho de iPhones desde Centro de Distribución Parque Industrial hacia Ventura Mall.', NULL, 'verificado');
INSERT INTO public.eventotrazabilidad VALUES (31, 2, 'transporte_terrestre', '2026-10-04 19:14:32.846271', 695, 4, 288, 1, 'Despacho de iPhones desde Centro de Distribución Parque Industrial hacia Ventura Mall.', NULL, 'verificado');
INSERT INTO public.eventotrazabilidad VALUES (32, 3, 'transporte_terrestre', '2026-10-04 19:14:33.162469', 698, 6, 293, 1, 'Despacho de iPhones desde Centro de Distribución Parque Industrial hacia Ventura Mall.', NULL, 'verificado');
INSERT INTO public.eventotrazabilidad VALUES (33, 4, 'transporte_terrestre', '2026-10-04 19:14:33.38725', 701, 8, 298, 1, 'Despacho de iPhones desde Centro de Distribución Parque Industrial hacia Ventura Mall.', NULL, 'verificado');
INSERT INTO public.eventotrazabilidad VALUES (34, 5, 'transporte_terrestre', '2026-10-04 19:14:33.624497', 704, 10, 303, 1, 'Despacho de iPhones desde Centro de Distribución Parque Industrial hacia Ventura Mall.', NULL, 'verificado');
INSERT INTO public.eventotrazabilidad VALUES (35, 1, 'transporte_terrestre', '2026-10-05 18:13:10.842832', 692, 2, 1, 1, '', 'b4ca04969c3891b2f31942a2dc4e2e35def17cdd93383a56875e3a5054c78dbd', 'verificado');


--
-- Data for Name: eventounidad; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.eventounidad VALUES (1, 1, 1);
INSERT INTO public.eventounidad VALUES (2, 2, 4);
INSERT INTO public.eventounidad VALUES (3, 3, 7);
INSERT INTO public.eventounidad VALUES (4, 4, 10);
INSERT INTO public.eventounidad VALUES (5, 5, 13);
INSERT INTO public.eventounidad VALUES (30, 31, 433);
INSERT INTO public.eventounidad VALUES (31, 31, 434);
INSERT INTO public.eventounidad VALUES (32, 31, 435);
INSERT INTO public.eventounidad VALUES (33, 31, 436);
INSERT INTO public.eventounidad VALUES (34, 32, 452);
INSERT INTO public.eventounidad VALUES (35, 32, 453);
INSERT INTO public.eventounidad VALUES (36, 32, 454);
INSERT INTO public.eventounidad VALUES (37, 32, 455);
INSERT INTO public.eventounidad VALUES (38, 33, 471);
INSERT INTO public.eventounidad VALUES (39, 33, 472);
INSERT INTO public.eventounidad VALUES (40, 33, 473);
INSERT INTO public.eventounidad VALUES (41, 33, 474);
INSERT INTO public.eventounidad VALUES (42, 34, 490);
INSERT INTO public.eventounidad VALUES (43, 34, 491);
INSERT INTO public.eventounidad VALUES (44, 34, 492);
INSERT INTO public.eventounidad VALUES (45, 34, 493);


--
-- Data for Name: garantiaunidad; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: notificacion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.notificacion VALUES (1, 1, 'Compra #PO-1-APPLE-001 Rechazada', 'La orden de compra #PO-1-APPLE-001 fue rechazada. Motivo: porque falto x motivo', true, '2026-09-17 01:14:03.351426', '2026-11-01 19:00:32.031165', '/purchases/1');


--
-- Data for Name: pago; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: permiso; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.permiso VALUES (1, 'tenants:read', 'Consultar y listar empresas registradas en la plataforma', 'Empresas');
INSERT INTO public.permiso VALUES (2, 'tenants:create', 'Crear y dar de alta nuevas empresas (tenants)', 'Empresas');
INSERT INTO public.permiso VALUES (3, 'tenants:update', 'Modificar datos y configuración corporativa de empresas', 'Empresas');
INSERT INTO public.permiso VALUES (4, 'tenants:delete', 'Desactivar o suspender empresas de la plataforma', 'Empresas');
INSERT INTO public.permiso VALUES (5, 'tenants:switch', 'Cambiar libremente de contexto entre empresas del sistema', 'Empresas');
INSERT INTO public.permiso VALUES (6, 'users:read', 'Consultar y listar usuarios registrados en el tenant', 'Usuarios');
INSERT INTO public.permiso VALUES (7, 'users:create', 'Registrar nuevos usuarios y enviar credenciales de acceso', 'Usuarios');
INSERT INTO public.permiso VALUES (8, 'users:update', 'Modificar perfiles, datos y estado activo de usuarios', 'Usuarios');
INSERT INTO public.permiso VALUES (9, 'users:delete', 'Desactivar o suspender usuarios del sistema', 'Usuarios');
INSERT INTO public.permiso VALUES (10, 'roles:read', 'Ver catálogo de roles del sistema y sus permisos', 'Roles y Permisos');
INSERT INTO public.permiso VALUES (11, 'roles:assign', 'Asignar, modificar y revocar roles a usuarios', 'Roles y Permisos');
INSERT INTO public.permiso VALUES (12, 'categories:read', 'Visualizar categorías de productos tecnológicos', 'Categorías');
INSERT INTO public.permiso VALUES (13, 'categories:manage', 'Crear, editar y eliminar categorías de productos', 'Categorías');
INSERT INTO public.permiso VALUES (14, 'certifications:read', 'Consultar certificaciones legales (ATT Bolivia, RoHS, etc.)', 'Certificaciones');
INSERT INTO public.permiso VALUES (15, 'certifications:manage', 'Crear y homologar certificaciones oficiales para productos', 'Certificaciones');
INSERT INTO public.permiso VALUES (16, 'products:read', 'Consultar especificaciones, variantes y modelos oficiales', 'Productos');
INSERT INTO public.permiso VALUES (17, 'products:manage', 'Crear, actualizar y dar de baja productos y variantes globales', 'Productos');
INSERT INTO public.permiso VALUES (18, 'tenant_catalog:read', 'Ver catálogo interno, costos promedio y precios al público', 'Catálogo Empresa');
INSERT INTO public.permiso VALUES (19, 'tenant_catalog:manage', 'Ajustar precios de venta, márgenes de ganancia y SKU interno', 'Catálogo Empresa');
INSERT INTO public.permiso VALUES (20, 'actors:read', 'Consultar proveedores, importadores, transportistas y tiendas', 'Cadena de Suministro');
INSERT INTO public.permiso VALUES (21, 'actors:manage', 'Dar de alta y gestionar actores de la cadena de suministro', 'Cadena de Suministro');
INSERT INTO public.permiso VALUES (22, 'locations:read', 'Visualizar almacenes, aduanas, hubs logísticos y sucursales', 'Ubicaciones');
INSERT INTO public.permiso VALUES (23, 'locations:manage', 'Registrar y actualizar ubicaciones con coordenadas GPS en Bolivia', 'Ubicaciones');
INSERT INTO public.permiso VALUES (24, 'purchases:read', 'Ver órdenes de compra internacionales y de importación', 'Compras');
INSERT INTO public.permiso VALUES (25, 'purchases:create', 'Generar nuevas órdenes de compra de lotes de dispositivos', 'Compras');
INSERT INTO public.permiso VALUES (26, 'purchases:approve', 'Aprobar o cancelar órdenes de compra pendientes', 'Compras');
INSERT INTO public.permiso VALUES (27, 'receptions:read', 'Consultar actas de recepción y control de aduana', 'Recepciones');
INSERT INTO public.permiso VALUES (28, 'receptions:manage', 'Registrar ingreso físico y cotejo de cantidades de mercancía', 'Recepciones');
INSERT INTO public.permiso VALUES (29, 'units:read', 'Consultar números de serie, IMEIs, estado y custodio de unidades', 'Unidades Físicas');
INSERT INTO public.permiso VALUES (30, 'units:create', 'Registrar e individualizar unidades físicas con serial y doble IMEI', 'Unidades Físicas');
INSERT INTO public.permiso VALUES (31, 'units:update', 'Actualizar estado operativo, custodia o venta de unidades', 'Unidades Físicas');
INSERT INTO public.permiso VALUES (32, 'qr:read', 'Visualizar, escanear y descargar códigos QR de trazabilidad', 'Códigos QR');
INSERT INTO public.permiso VALUES (33, 'qr:generate', 'Generar tokens hash criptográficos y enlaces públicos de verificación', 'Códigos QR');
INSERT INTO public.permiso VALUES (34, 'shipments:read', 'Monitorear despachos en curso, rutas y estados de entrega', 'Transporte y Envíos');
INSERT INTO public.permiso VALUES (35, 'shipments:create', 'Programar y despachar envíos entre nodos de la cadena', 'Transporte y Envíos');
INSERT INTO public.permiso VALUES (36, 'shipments:assign_units', 'Asignar unidades físicas serializadas a un manifiesto de carga', 'Transporte y Envíos');
INSERT INTO public.permiso VALUES (37, 'shipments:telemetry', 'Registrar eventos de trazabilidad y telemetría de sensores IoT', 'Transporte y Envíos');
INSERT INTO public.permiso VALUES (38, 'audit:read', 'Consultar bitácora inmutable de eventos, cambios y accesos de seguridad', 'Auditoría');


--
-- Data for Name: plan; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.plan VALUES (1, 'trial', 'Prueba Gratuita (Trial)', 'Acceso inicial de 14 días para evaluación con cuotas controladas.', 0.00, 0.00, 'USD', 3, 20, 50, 100, 14, true, '2026-11-01 13:49:52.864303', '2026-11-01 13:49:52.864303');
INSERT INTO public.plan VALUES (2, 'basico', 'Plan Básico Starter', 'Ideal para pequeños importadores y tiendas boutique de Apple.', 49.00, 490.00, 'USD', 5, 100, 200, 500, 0, true, '2026-11-01 13:49:52.864303', '2026-11-01 13:49:52.864303');
INSERT INTO public.plan VALUES (3, 'pro', 'Plan Profesional Business', 'Para distribuidores mayoristas con múltiples sucursales en Bolivia.', 149.00, 1490.00, 'USD', 20, 1000, 1000, 2048, 0, true, '2026-11-01 13:49:52.864303', '2026-11-01 13:49:52.864303');
INSERT INTO public.plan VALUES (4, 'enterprise', 'Plan Enterprise Corporativo', 'Volumen ilimitado, soporte 24/7 y anclaje prioritario en blockchain.', 399.00, 3990.00, 'USD', NULL, NULL, NULL, 10240, 0, true, '2026-11-01 13:49:52.864303', '2026-11-01 13:49:52.864303');


--
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.producto VALUES (1, 1, 'Galaxy S24', 'SM-S921', 'Corea del Sur', NULL, NULL, '2026-09-10 01:41:16.467164', true);
INSERT INTO public.producto VALUES (2, 1, 'iPhone 15', 'A3090', 'China', NULL, NULL, '2026-09-10 01:41:16.506919', true);
INSERT INTO public.producto VALUES (3, 2, 'Cargador USB-C 20W', 'GAN-20W', 'China', NULL, NULL, '2026-09-10 01:41:16.518638', true);
INSERT INTO public.producto VALUES (4, 2, 'Funda Protectora Universal', 'FND-UNI', 'Vietnam', NULL, NULL, '2026-09-10 01:41:16.524497', true);
INSERT INTO public.producto VALUES (5, 3, 'Smartwatch Fit 2', 'SWF2', 'China', NULL, NULL, '2026-09-10 01:41:16.534983', true);
INSERT INTO public.producto VALUES (6, 3, 'Auriculares TWS Pro', 'TWS-PRO', 'China', NULL, NULL, '2026-09-10 01:41:16.541037', true);
INSERT INTO public.producto VALUES (7, 3, 'iPad Air 1790796063796', 'A2902', 'EEUU', 'iPad Air de prueba', NULL, '2026-09-30 19:21:03.7973', true);
INSERT INTO public.producto VALUES (8, 1, 'Producto Tenant 1790796064527', 'MOD-TEST', NULL, NULL, NULL, '2026-09-30 19:21:04.541407', true);
INSERT INTO public.producto VALUES (699, 3, 'iPad Air 1791246753123', 'A2902', 'EEUU', 'iPad Air de prueba', NULL, '2026-10-06 00:32:33.140786', true);
INSERT INTO public.producto VALUES (162, 3, 'iPad Air 1790801138535', 'A2902', 'EEUU', 'iPad Air de prueba', NULL, '2026-09-30 20:45:38.556289', true);
INSERT INTO public.producto VALUES (163, 1, 'Producto Tenant 1790801139279', 'MOD-TEST', NULL, NULL, NULL, '2026-09-30 20:45:39.291811', true);
INSERT INTO public.producto VALUES (172, 1, 'iPhone 16 Pro 1790801148737', 'A3089', NULL, NULL, NULL, '2026-09-30 20:45:48.754237', true);
INSERT INTO public.producto VALUES (83, 1, 'iPhone 16 Pro 1790797451638', 'A3089', NULL, NULL, NULL, '2026-09-30 19:44:11.655739', true);
INSERT INTO public.producto VALUES (84, 3, 'iPad Air 1790797561261', 'A2902', 'EEUU', 'iPad Air de prueba', NULL, '2026-09-30 19:46:01.274194', true);
INSERT INTO public.producto VALUES (85, 1, 'Producto Tenant 1790797561928', 'MOD-TEST', NULL, NULL, NULL, '2026-09-30 19:46:01.938828', true);
INSERT INTO public.producto VALUES (173, 3, 'iPad Air 1790801208117', 'A2902', 'EEUU', 'iPad Air de prueba', NULL, '2026-09-30 20:46:48.133745', true);
INSERT INTO public.producto VALUES (17, 1, 'iPhone 16 Pro 1790796071891', 'A3089', NULL, NULL, NULL, '2026-09-30 19:21:11.907237', true);
INSERT INTO public.producto VALUES (18, 3, 'iPad Air 1790797000810', 'A2902', 'EEUU', 'iPad Air de prueba', NULL, '2026-09-30 19:36:40.826513', true);
INSERT INTO public.producto VALUES (19, 1, 'Producto Tenant 1790797001510', 'MOD-TEST', NULL, NULL, NULL, '2026-09-30 19:36:41.526815', true);
INSERT INTO public.producto VALUES (174, 1, 'Producto Tenant 1790801209314', 'MOD-TEST', NULL, NULL, NULL, '2026-09-30 20:46:49.337777', true);
INSERT INTO public.producto VALUES (183, 1, 'iPhone 16 Pro 1790801217903', 'A3089', NULL, NULL, NULL, '2026-09-30 20:46:57.919556', true);
INSERT INTO public.producto VALUES (700, 1, 'Producto Tenant 1791246753644', 'MOD-TEST', NULL, NULL, NULL, '2026-10-06 00:32:33.652657', true);
INSERT INTO public.producto VALUES (94, 1, 'iPhone 16 Pro 1790797569880', 'A3089', NULL, NULL, NULL, '2026-09-30 19:46:09.898167', true);
INSERT INTO public.producto VALUES (28, 1, 'iPhone 16 Pro 1790797008887', 'A3089', NULL, NULL, NULL, '2026-09-30 19:36:48.898809', true);
INSERT INTO public.producto VALUES (29, 3, 'iPad Air 1790797101941', 'A2902', 'EEUU', 'iPad Air de prueba', NULL, '2026-09-30 19:38:21.955044', true);
INSERT INTO public.producto VALUES (30, 1, 'Producto Tenant 1790797102625', 'MOD-TEST', NULL, NULL, NULL, '2026-09-30 19:38:22.634916', true);
INSERT INTO public.producto VALUES (95, 3, 'iPad Air 1790797590688', 'A2902', 'EEUU', 'iPad Air de prueba', NULL, '2026-09-30 19:46:30.706243', true);
INSERT INTO public.producto VALUES (96, 1, 'Producto Tenant 1790797591388', 'MOD-TEST', NULL, NULL, NULL, '2026-09-30 19:46:31.402282', true);
INSERT INTO public.producto VALUES (39, 1, 'iPhone 16 Pro 1790797109882', 'A3089', NULL, NULL, NULL, '2026-09-30 19:38:29.899059', true);
INSERT INTO public.producto VALUES (40, 3, 'iPad Air 1790797133789', 'A2902', 'EEUU', 'iPad Air de prueba', NULL, '2026-09-30 19:38:53.801048', true);
INSERT INTO public.producto VALUES (41, 1, 'Producto Tenant 1790797134417', 'MOD-TEST', NULL, NULL, NULL, '2026-09-30 19:38:54.417057', true);
INSERT INTO public.producto VALUES (105, 1, 'iPhone 16 Pro 1790797598956', 'A3089', NULL, NULL, NULL, '2026-09-30 19:46:38.972174', true);
INSERT INTO public.producto VALUES (106, 3, 'iPad Air 1790799349929', 'A2902', 'EEUU', 'iPad Air de prueba', NULL, '2026-09-30 20:15:49.950755', true);
INSERT INTO public.producto VALUES (107, 1, 'Producto Tenant 1790799350668', 'MOD-TEST', NULL, NULL, NULL, '2026-09-30 20:15:50.688483', true);
INSERT INTO public.producto VALUES (50, 1, 'iPhone 16 Pro 1790797141219', 'A3089', NULL, NULL, NULL, '2026-09-30 19:39:01.231347', true);
INSERT INTO public.producto VALUES (51, 3, 'iPad Air 1790797161168', 'A2902', 'EEUU', 'iPad Air de prueba', NULL, '2026-09-30 19:39:21.189331', true);
INSERT INTO public.producto VALUES (52, 1, 'Producto Tenant 1790797161882', 'MOD-TEST', NULL, NULL, NULL, '2026-09-30 19:39:21.909008', true);
INSERT INTO public.producto VALUES (116, 1, 'iPhone 16 Pro 1790799357995', 'A3089', NULL, NULL, NULL, '2026-09-30 20:15:58.007638', true);
INSERT INTO public.producto VALUES (61, 1, 'iPhone 16 Pro 1790797169105', 'A3089', NULL, NULL, NULL, '2026-09-30 19:39:29.119721', true);
INSERT INTO public.producto VALUES (62, 3, 'iPad Air 1790797386951', 'A2902', 'EEUU', 'iPad Air de prueba', NULL, '2026-09-30 19:43:06.96417', true);
INSERT INTO public.producto VALUES (63, 1, 'Producto Tenant 1790797388714', 'MOD-TEST', NULL, NULL, NULL, '2026-09-30 19:43:08.728985', true);
INSERT INTO public.producto VALUES (384, 1, 'iPhone 16 Pro Max', 'A3296', 'China', 'Pantalla Super Retina XDR de 6.9'''', chip A18 Pro, botón Control de Cámara y titanio grado 5.', NULL, '2026-10-05 04:14:31.955966', true);
INSERT INTO public.producto VALUES (124, 3, 'iPad Air 1790799748518', 'A2902', 'EEUU', 'iPad Air de prueba', NULL, '2026-09-30 20:22:28.53297', true);
INSERT INTO public.producto VALUES (125, 1, 'Producto Tenant 1790799749289', 'MOD-TEST', NULL, NULL, NULL, '2026-09-30 20:22:29.302018', true);
INSERT INTO public.producto VALUES (385, 1, 'iPhone 16 Pro', 'A3293', 'China', 'Pantalla de 6.3'''', chip A18 Pro, sistema de cámaras Pro de 48 MP y acabado de titanio.', NULL, '2026-10-05 04:14:32.041107', true);
INSERT INTO public.producto VALUES (72, 1, 'iPhone 16 Pro 1790797397033', 'A3089', NULL, NULL, NULL, '2026-09-30 19:43:17.044825', true);
INSERT INTO public.producto VALUES (73, 3, 'iPad Air 1790797443569', 'A2902', 'EEUU', 'iPad Air de prueba', NULL, '2026-09-30 19:44:03.574095', true);
INSERT INTO public.producto VALUES (74, 1, 'Producto Tenant 1790797444274', 'MOD-TEST', NULL, NULL, NULL, '2026-09-30 19:44:04.279245', true);
INSERT INTO public.producto VALUES (386, 1, 'iPhone 16', 'A3287', 'China', 'Pantalla de 6.1'''' con Dynamic Island, chip A18 y nuevo botón de acción háptico.', NULL, '2026-10-05 04:14:32.067059', true);
INSERT INTO public.producto VALUES (387, 1, 'iPhone 15 Pro Max', 'A3106', 'Corea del Sur', 'Pantalla de 6.7'''', chip A17 Pro con GPU de 6 núcleos, teleobjetivo 5x óptico.', NULL, '2026-10-05 04:14:32.086257', true);
INSERT INTO public.producto VALUES (134, 1, 'iPhone 16 Pro 1790799757077', 'A3089', NULL, NULL, NULL, '2026-09-30 20:22:37.090224', true);
INSERT INTO public.producto VALUES (135, 3, 'iPad Air 1790800244676', 'A2902', 'EEUU', 'iPad Air de prueba', NULL, '2026-09-30 20:30:44.696363', true);
INSERT INTO public.producto VALUES (136, 1, 'Producto Tenant 1790800245355', 'MOD-TEST', NULL, NULL, NULL, '2026-09-30 20:30:45.364514', true);
INSERT INTO public.producto VALUES (145, 1, 'iPhone 16 Pro 1790800252489', 'A3089', NULL, NULL, NULL, '2026-09-30 20:30:52.505652', true);
INSERT INTO public.producto VALUES (149, 3, 'iPad Air 1790800868062', 'A2902', 'EEUU', 'iPad Air de prueba', NULL, '2026-09-30 20:41:08.076955', true);
INSERT INTO public.producto VALUES (150, 1, 'Producto Tenant 1790800868814', 'MOD-TEST', NULL, NULL, NULL, '2026-09-30 20:41:08.829341', true);
INSERT INTO public.producto VALUES (159, 1, 'iPhone 16 Pro 1790800876457', 'A3089', NULL, NULL, NULL, '2026-09-30 20:41:16.47429', true);
INSERT INTO public.producto VALUES (388, 1, 'iPhone 15 Pro', 'A3102', 'China', 'Pantalla de 6.1'''', conector USB-C compatible con USB 3 y diseño ultraligero de titanio.', NULL, '2026-10-05 04:14:32.100972', true);
INSERT INTO public.producto VALUES (389, 75, 'AirPods Pro (2.ª gen USB-C)', 'A3048', 'Vietnam', 'Cancelación activa de ruido 2x, audio adaptativo y estuche MagSafe USB-C.', NULL, '2026-10-05 04:14:32.128062', true);
INSERT INTO public.producto VALUES (390, 76, 'Cargador Apple 20W USB-C', 'A2305', 'China', 'Adaptador de corriente rápido USB-C de 20W oficial de Apple para Bolivia.', NULL, '2026-10-05 04:14:32.134428', true);
INSERT INTO public.producto VALUES (789, 1, 'iPhone 16 Pro 1791246767645', 'A3089', NULL, NULL, NULL, '2026-10-06 00:32:47.653125', true);


--
-- Data for Name: productocertificacion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.productocertificacion VALUES (1, 1, 1, '2026-09-09');
INSERT INTO public.productocertificacion VALUES (2, 2, 1, '2026-09-09');
INSERT INTO public.productocertificacion VALUES (3, 5, 2, '2026-09-09');
INSERT INTO public.productocertificacion VALUES (4, 1, 3, '2026-01-15');
INSERT INTO public.productocertificacion VALUES (5, 1, 4, '2026-01-15');
INSERT INTO public.productocertificacion VALUES (6, 1, 5, '2026-01-15');
INSERT INTO public.productocertificacion VALUES (7, 1, 6, '2026-01-15');
INSERT INTO public.productocertificacion VALUES (8, 1, 7, '2026-01-15');
INSERT INTO public.productocertificacion VALUES (9, 1, 8, '2026-01-15');
INSERT INTO public.productocertificacion VALUES (10, 1, 9, '2026-01-15');
INSERT INTO public.productocertificacion VALUES (11, 1, 10, '2026-01-15');
INSERT INTO public.productocertificacion VALUES (12, 1, 11, '2026-01-15');
INSERT INTO public.productocertificacion VALUES (13, 1, 12, '2026-01-15');
INSERT INTO public.productocertificacion VALUES (14, 1, 13, '2026-01-15');
INSERT INTO public.productocertificacion VALUES (15, 1, 14, '2026-01-15');
INSERT INTO public.productocertificacion VALUES (16, 1, 15, '2026-01-15');
INSERT INTO public.productocertificacion VALUES (17, 1, 16, '2026-01-15');
INSERT INTO public.productocertificacion VALUES (18, 1, 17, '2026-01-15');
INSERT INTO public.productocertificacion VALUES (19, 384, 1, '2026-08-06');
INSERT INTO public.productocertificacion VALUES (20, 385, 1, '2026-08-06');
INSERT INTO public.productocertificacion VALUES (21, 386, 1, '2026-08-06');
INSERT INTO public.productocertificacion VALUES (22, 387, 1, '2026-08-06');
INSERT INTO public.productocertificacion VALUES (23, 388, 1, '2026-08-06');
INSERT INTO public.productocertificacion VALUES (24, 1, 18, '2026-01-15');


--
-- Data for Name: recepcioncompra; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.recepcioncompra VALUES (30, 274, 283, '2026-09-25 00:14:32.438604', 'REC-2026-SCZ-01', 'completa');
INSERT INTO public.recepcioncompra VALUES (31, 275, 288, '2026-09-25 00:14:32.734895', 'REC-2026-SCZ-02', 'completa');
INSERT INTO public.recepcioncompra VALUES (32, 276, 293, '2026-09-25 00:14:33.043748', 'REC-2026-SCZ-03', 'completa');
INSERT INTO public.recepcioncompra VALUES (33, 277, 298, '2026-09-25 00:14:33.264796', 'REC-2026-SCZ-04', 'completa');
INSERT INTO public.recepcioncompra VALUES (34, 278, 303, '2026-09-25 00:14:33.523821', 'REC-2026-SCZ-05', 'completa');


--
-- Data for Name: recepciondetalle; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.recepciondetalle VALUES (100, 30, 398, 5, 5);
INSERT INTO public.recepciondetalle VALUES (101, 30, 413, 12, 12);
INSERT INTO public.recepciondetalle VALUES (102, 30, 414, 10, 10);
INSERT INTO public.recepciondetalle VALUES (103, 30, 404, 10, 10);
INSERT INTO public.recepciondetalle VALUES (104, 30, 410, 1, 1);
INSERT INTO public.recepciondetalle VALUES (105, 30, 415, 7, 7);
INSERT INTO public.recepciondetalle VALUES (106, 30, 403, 15, 15);
INSERT INTO public.recepciondetalle VALUES (107, 30, 402, 12, 12);
INSERT INTO public.recepciondetalle VALUES (108, 31, 398, 5, 5);
INSERT INTO public.recepciondetalle VALUES (109, 31, 413, 12, 12);
INSERT INTO public.recepciondetalle VALUES (110, 31, 414, 10, 10);
INSERT INTO public.recepciondetalle VALUES (111, 31, 404, 10, 10);
INSERT INTO public.recepciondetalle VALUES (112, 31, 410, 1, 1);
INSERT INTO public.recepciondetalle VALUES (113, 31, 415, 7, 7);
INSERT INTO public.recepciondetalle VALUES (114, 31, 403, 15, 15);
INSERT INTO public.recepciondetalle VALUES (115, 31, 402, 12, 12);
INSERT INTO public.recepciondetalle VALUES (116, 32, 398, 5, 5);
INSERT INTO public.recepciondetalle VALUES (117, 32, 413, 12, 12);
INSERT INTO public.recepciondetalle VALUES (118, 32, 414, 10, 10);
INSERT INTO public.recepciondetalle VALUES (119, 32, 404, 10, 10);
INSERT INTO public.recepciondetalle VALUES (120, 32, 410, 1, 1);
INSERT INTO public.recepciondetalle VALUES (121, 32, 415, 7, 7);
INSERT INTO public.recepciondetalle VALUES (122, 32, 403, 15, 15);
INSERT INTO public.recepciondetalle VALUES (123, 32, 402, 12, 12);
INSERT INTO public.recepciondetalle VALUES (124, 33, 398, 5, 5);
INSERT INTO public.recepciondetalle VALUES (125, 33, 413, 12, 12);
INSERT INTO public.recepciondetalle VALUES (126, 33, 414, 10, 10);
INSERT INTO public.recepciondetalle VALUES (127, 33, 404, 10, 10);
INSERT INTO public.recepciondetalle VALUES (128, 33, 410, 1, 1);
INSERT INTO public.recepciondetalle VALUES (129, 33, 415, 7, 7);
INSERT INTO public.recepciondetalle VALUES (130, 33, 403, 15, 15);
INSERT INTO public.recepciondetalle VALUES (131, 33, 402, 12, 12);
INSERT INTO public.recepciondetalle VALUES (132, 34, 398, 5, 5);
INSERT INTO public.recepciondetalle VALUES (133, 34, 413, 12, 12);
INSERT INTO public.recepciondetalle VALUES (134, 34, 414, 10, 10);
INSERT INTO public.recepciondetalle VALUES (135, 34, 404, 10, 10);
INSERT INTO public.recepciondetalle VALUES (136, 34, 410, 1, 1);
INSERT INTO public.recepciondetalle VALUES (137, 34, 415, 7, 7);
INSERT INTO public.recepciondetalle VALUES (138, 34, 403, 15, 15);
INSERT INTO public.recepciondetalle VALUES (139, 34, 402, 12, 12);


--
-- Data for Name: registroblockchain; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: reportesospecha; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: reportesospechaevidencia; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.rol VALUES (1, 'SuperAdministrador', 'Control total sobre la plataforma, gestión de tenants y configuración global');
INSERT INTO public.rol VALUES (2, 'AdministradorEmpresa', 'Gestión completa de una empresa (tenant): catálogo, usuarios, reportes');
INSERT INTO public.rol VALUES (3, 'GestorOperaciones', 'Gestión de abastecimiento, inventario (seriales/IMEI), logística y trazabilidad');
INSERT INTO public.rol VALUES (4, 'GestorVentasPostventa', 'Gestión de ventas, devoluciones, garantías y documentos adjuntos');
INSERT INTO public.rol VALUES (5, 'Consumidor', 'Consulta de trazabilidad, favoritos y notificaciones (solo sus productos)');
INSERT INTO public.rol VALUES (6, 'Auditor', 'Acceso de solo lectura a trazabilidad, blockchain y reportes');


--
-- Data for Name: rolpermiso; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.rolpermiso VALUES (1, 1, 1);
INSERT INTO public.rolpermiso VALUES (2, 1, 2);
INSERT INTO public.rolpermiso VALUES (3, 1, 3);
INSERT INTO public.rolpermiso VALUES (4, 1, 4);
INSERT INTO public.rolpermiso VALUES (5, 1, 5);
INSERT INTO public.rolpermiso VALUES (6, 1, 6);
INSERT INTO public.rolpermiso VALUES (7, 1, 7);
INSERT INTO public.rolpermiso VALUES (8, 1, 8);
INSERT INTO public.rolpermiso VALUES (9, 1, 9);
INSERT INTO public.rolpermiso VALUES (10, 1, 10);
INSERT INTO public.rolpermiso VALUES (11, 1, 11);
INSERT INTO public.rolpermiso VALUES (12, 1, 12);
INSERT INTO public.rolpermiso VALUES (13, 1, 13);
INSERT INTO public.rolpermiso VALUES (14, 1, 14);
INSERT INTO public.rolpermiso VALUES (15, 1, 15);
INSERT INTO public.rolpermiso VALUES (16, 1, 16);
INSERT INTO public.rolpermiso VALUES (17, 1, 17);
INSERT INTO public.rolpermiso VALUES (18, 1, 18);
INSERT INTO public.rolpermiso VALUES (19, 1, 19);
INSERT INTO public.rolpermiso VALUES (20, 1, 20);
INSERT INTO public.rolpermiso VALUES (21, 1, 21);
INSERT INTO public.rolpermiso VALUES (22, 1, 22);
INSERT INTO public.rolpermiso VALUES (23, 1, 23);
INSERT INTO public.rolpermiso VALUES (24, 1, 24);
INSERT INTO public.rolpermiso VALUES (25, 1, 25);
INSERT INTO public.rolpermiso VALUES (26, 1, 26);
INSERT INTO public.rolpermiso VALUES (27, 1, 27);
INSERT INTO public.rolpermiso VALUES (28, 1, 28);
INSERT INTO public.rolpermiso VALUES (29, 1, 29);
INSERT INTO public.rolpermiso VALUES (30, 1, 30);
INSERT INTO public.rolpermiso VALUES (31, 1, 31);
INSERT INTO public.rolpermiso VALUES (32, 1, 32);
INSERT INTO public.rolpermiso VALUES (33, 1, 33);
INSERT INTO public.rolpermiso VALUES (34, 1, 34);
INSERT INTO public.rolpermiso VALUES (35, 1, 35);
INSERT INTO public.rolpermiso VALUES (36, 1, 36);
INSERT INTO public.rolpermiso VALUES (37, 1, 37);
INSERT INTO public.rolpermiso VALUES (38, 1, 38);
INSERT INTO public.rolpermiso VALUES (39, 2, 1);
INSERT INTO public.rolpermiso VALUES (40, 2, 3);
INSERT INTO public.rolpermiso VALUES (41, 2, 6);
INSERT INTO public.rolpermiso VALUES (42, 2, 7);
INSERT INTO public.rolpermiso VALUES (43, 2, 8);
INSERT INTO public.rolpermiso VALUES (44, 2, 9);
INSERT INTO public.rolpermiso VALUES (45, 2, 10);
INSERT INTO public.rolpermiso VALUES (46, 2, 11);
INSERT INTO public.rolpermiso VALUES (47, 2, 12);
INSERT INTO public.rolpermiso VALUES (48, 2, 13);
INSERT INTO public.rolpermiso VALUES (49, 2, 14);
INSERT INTO public.rolpermiso VALUES (50, 2, 15);
INSERT INTO public.rolpermiso VALUES (51, 2, 16);
INSERT INTO public.rolpermiso VALUES (52, 2, 18);
INSERT INTO public.rolpermiso VALUES (53, 2, 19);
INSERT INTO public.rolpermiso VALUES (54, 2, 20);
INSERT INTO public.rolpermiso VALUES (55, 2, 21);
INSERT INTO public.rolpermiso VALUES (56, 2, 22);
INSERT INTO public.rolpermiso VALUES (57, 2, 23);
INSERT INTO public.rolpermiso VALUES (58, 2, 24);
INSERT INTO public.rolpermiso VALUES (59, 2, 25);
INSERT INTO public.rolpermiso VALUES (60, 2, 26);
INSERT INTO public.rolpermiso VALUES (61, 2, 27);
INSERT INTO public.rolpermiso VALUES (62, 2, 28);
INSERT INTO public.rolpermiso VALUES (63, 2, 29);
INSERT INTO public.rolpermiso VALUES (64, 2, 30);
INSERT INTO public.rolpermiso VALUES (65, 2, 31);
INSERT INTO public.rolpermiso VALUES (66, 2, 32);
INSERT INTO public.rolpermiso VALUES (67, 2, 33);
INSERT INTO public.rolpermiso VALUES (68, 2, 34);
INSERT INTO public.rolpermiso VALUES (69, 2, 35);
INSERT INTO public.rolpermiso VALUES (70, 2, 36);
INSERT INTO public.rolpermiso VALUES (71, 2, 37);
INSERT INTO public.rolpermiso VALUES (72, 2, 38);
INSERT INTO public.rolpermiso VALUES (73, 3, 12);
INSERT INTO public.rolpermiso VALUES (74, 3, 14);
INSERT INTO public.rolpermiso VALUES (75, 3, 16);
INSERT INTO public.rolpermiso VALUES (76, 3, 18);
INSERT INTO public.rolpermiso VALUES (77, 3, 20);
INSERT INTO public.rolpermiso VALUES (78, 3, 22);
INSERT INTO public.rolpermiso VALUES (79, 3, 23);
INSERT INTO public.rolpermiso VALUES (80, 3, 24);
INSERT INTO public.rolpermiso VALUES (81, 3, 25);
INSERT INTO public.rolpermiso VALUES (82, 3, 26);
INSERT INTO public.rolpermiso VALUES (83, 3, 27);
INSERT INTO public.rolpermiso VALUES (84, 3, 28);
INSERT INTO public.rolpermiso VALUES (85, 3, 29);
INSERT INTO public.rolpermiso VALUES (86, 3, 30);
INSERT INTO public.rolpermiso VALUES (87, 3, 31);
INSERT INTO public.rolpermiso VALUES (88, 3, 32);
INSERT INTO public.rolpermiso VALUES (89, 3, 33);
INSERT INTO public.rolpermiso VALUES (90, 3, 34);
INSERT INTO public.rolpermiso VALUES (91, 3, 35);
INSERT INTO public.rolpermiso VALUES (92, 3, 36);
INSERT INTO public.rolpermiso VALUES (93, 3, 37);
INSERT INTO public.rolpermiso VALUES (94, 4, 16);
INSERT INTO public.rolpermiso VALUES (95, 4, 18);
INSERT INTO public.rolpermiso VALUES (96, 4, 24);
INSERT INTO public.rolpermiso VALUES (97, 4, 29);
INSERT INTO public.rolpermiso VALUES (98, 4, 31);
INSERT INTO public.rolpermiso VALUES (99, 4, 32);
INSERT INTO public.rolpermiso VALUES (100, 4, 34);
INSERT INTO public.rolpermiso VALUES (101, 6, 1);
INSERT INTO public.rolpermiso VALUES (102, 6, 6);
INSERT INTO public.rolpermiso VALUES (103, 6, 10);
INSERT INTO public.rolpermiso VALUES (104, 6, 12);
INSERT INTO public.rolpermiso VALUES (105, 6, 14);
INSERT INTO public.rolpermiso VALUES (106, 6, 16);
INSERT INTO public.rolpermiso VALUES (107, 6, 18);
INSERT INTO public.rolpermiso VALUES (108, 6, 20);
INSERT INTO public.rolpermiso VALUES (109, 6, 22);
INSERT INTO public.rolpermiso VALUES (110, 6, 24);
INSERT INTO public.rolpermiso VALUES (111, 6, 27);
INSERT INTO public.rolpermiso VALUES (112, 6, 29);
INSERT INTO public.rolpermiso VALUES (113, 6, 32);
INSERT INTO public.rolpermiso VALUES (114, 6, 34);
INSERT INTO public.rolpermiso VALUES (115, 6, 38);
INSERT INTO public.rolpermiso VALUES (116, 5, 16);
INSERT INTO public.rolpermiso VALUES (117, 5, 29);
INSERT INTO public.rolpermiso VALUES (118, 5, 32);


--
-- Data for Name: suscripcion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.suscripcion VALUES (1, 1, 3, 'activa', '2026-11-01 13:49:52.864303', '2027-11-01 13:49:52.864303', true, NULL, '2026-11-01 13:49:52.864303', '2026-11-01 13:49:52.864303');
INSERT INTO public.suscripcion VALUES (2, 2, 3, 'activa', '2026-11-01 13:49:52.864303', '2027-11-01 13:49:52.864303', true, NULL, '2026-11-01 13:49:52.864303', '2026-11-01 13:49:52.864303');
INSERT INTO public.suscripcion VALUES (3, 3, 2, 'activa', '2026-11-01 13:49:52.864303', '2027-04-30 13:49:52.864303', true, NULL, '2026-11-01 13:49:52.864303', '2026-11-01 13:49:52.864303');
INSERT INTO public.suscripcion VALUES (4, 4, 1, 'trial', '2026-11-01 13:49:52.864303', '2026-11-15 13:49:52.864303', false, NULL, '2026-11-01 13:49:52.864303', '2026-11-01 13:49:52.864303');
INSERT INTO public.suscripcion VALUES (5, 5, 1, 'cancelada', '2026-11-01 13:49:52.864303', '2026-11-15 13:49:52.864303', false, 'Reemplazada por suscripción a plan Plan Básico Starter.', '2026-11-01 13:49:52.864303', '2026-11-03 23:21:44.748725');
INSERT INTO public.suscripcion VALUES (27, 5, 2, 'activa', '2026-11-03 23:21:44.748725', '2026-11-08 23:21:44.748725', false, NULL, '2026-11-03 23:21:44.748725', '2026-11-03 23:21:44.748725');


--
-- Data for Name: tenant; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.tenant VALUES (1, 'iStore Bolivia S.A.', 'iStore Importaciones y Distribucion S.A.', '123456789', 'importadora@bolivia.com', '70000000', true, NULL, '2026-09-09 21:41:16.589556');
INSERT INTO public.tenant VALUES (2, 'TechImport Santa Cruz S.R.L.', 'TechImport Santa Cruz Sociedad de Responsabilidad Limitada', '987654321', 'contacto@techimport.com', '70111111', true, NULL, '2026-09-09 21:41:16.880116');
INSERT INTO public.tenant VALUES (3, 'Andina Digital Ltda.', 'Andina Digital Limitada', '456789123', 'contacto@andinadigital.com', '70222222', true, NULL, '2026-09-09 21:41:17.06134');
INSERT INTO public.tenant VALUES (4, 'ElectroSur Trading S.A.', 'ElectroSur Trading Sociedad Anónima', '321654987', 'contacto@electrosur.com', '70333333', true, NULL, '2026-09-09 21:41:17.286214');
INSERT INTO public.tenant VALUES (5, 'Cochabamba Wireless S.A.', 'Cochabamba Wireless Sociedad Anónima', '654987321', 'contacto@cochawireless.com', '70444444', true, NULL, '2026-09-09 21:41:17.496209');


--
-- Data for Name: tenant_backup; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: tenant_backup_schedule; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: tokenrecuperacion; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: tokenrefresco; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.tokenrefresco VALUES (1, 1, 1, '6100f1ad66c07fe5318f424bdd20ce620ca4037a18a66cc52c299bce153ee467', '2026-09-16 21:59:52.958956-04', false, '2026-09-09 21:59:52.958956-04');
INSERT INTO public.tokenrefresco VALUES (2, 1, 1, '6a90ba69b4cd3c49bd0d5d083f814db3dbde9ec88bca8b36507671054c24634f', '2026-09-17 00:11:12.583992-04', false, '2026-09-10 00:11:12.585985-04');
INSERT INTO public.tokenrefresco VALUES (3, 1, 1, '8ae9160604a49a59366f80a3b0395493380fe3568428403b899d1a51593e5e09', '2026-09-24 01:13:12.897713-04', true, '2026-09-17 01:13:12.921453-04');
INSERT INTO public.tokenrefresco VALUES (4, 1, 1, 'b75abe1d421139b22d4f59d06af87b5a72734064e031feb755ebe7e0f217b1b8', '2026-09-24 06:53:09.507225-04', false, '2026-09-17 06:53:09.51326-04');
INSERT INTO public.tokenrefresco VALUES (7, 1, 1, '6f49b8b11d52c3b5eb4e5b84e665f59cfe33a49f9607966547ca6e92588414f9', '2026-10-07 15:21:03.24778-04', false, '2026-09-30 15:21:03.252401-04');
INSERT INTO public.tokenrefresco VALUES (8, 1, 1, '4e457a04950602eb160ca129f8b7a8c57658979dc1222c87ae1c4dd4ee987c12', '2026-10-07 15:21:03.661898-04', false, '2026-09-30 15:21:03.668949-04');
INSERT INTO public.tokenrefresco VALUES (9, 1, 1, '4fee5db4911f3b510ed65d6ed35549fc537e6fe295b5f65e6cb22dc745b5f32e', '2026-10-07 15:21:04.109786-04', false, '2026-09-30 15:21:04.109786-04');
INSERT INTO public.tokenrefresco VALUES (10, 1, 1, '54dfe8dc53b16d15d9ca56f85c3c9e1315509dab66b702f92e5360ad4c867b93', '2026-10-07 15:21:04.446694-04', false, '2026-09-30 15:21:04.44833-04');
INSERT INTO public.tokenrefresco VALUES (786, 1, 1, '3920a10d0e5a2836abefdecaf1644beb2c7a2be74c76c633342f3d75b0eb58f2', '2026-10-07 23:25:15.265978-04', true, '2026-09-30 23:25:15.278731-04');
INSERT INTO public.tokenrefresco VALUES (788, 2, 2, '1d06d2e9f17fffad7077f057946b7e4cd1f8e5a9b75eb8145fd9cf2aee29a9b7', '2026-10-12 18:19:37.817895-04', true, '2026-10-05 18:19:37.817895-04');
INSERT INTO public.tokenrefresco VALUES (793, 1, 1, '0a3e5a34fa71e96384a8727c68f741a81c391a44756a30e8584f29240b25a86b', '2026-10-12 20:31:57.678307-04', false, '2026-10-05 20:31:57.678307-04');
INSERT INTO public.tokenrefresco VALUES (95, 1, 1, '0a2cec28bd5db02ff4637d755f0d7ddf188d95964167d8b332588effb8d27a69', '2026-10-07 15:38:21.436765-04', false, '2026-09-30 15:38:21.438786-04');
INSERT INTO public.tokenrefresco VALUES (96, 1, 1, 'be1c2d402d20254ccfaf0c32e455204e2dfad965322c1378fef2fee3f634c621', '2026-10-07 15:38:21.813256-04', false, '2026-09-30 15:38:21.81501-04');
INSERT INTO public.tokenrefresco VALUES (98, 1, 1, 'df3e52c314c96b8895e860048ea93e4de36cc9ecdf2d522a278cf0a0dbb9e950', '2026-10-07 15:38:22.550499-04', false, '2026-09-30 15:38:22.55251-04');
INSERT INTO public.tokenrefresco VALUES (133, 1, 1, '55aa5fc046bb06ba8c0b6c6d9868d4d5364cb463b63fbfc1f61c3390bc0d4504', '2026-10-07 15:38:53.282563-04', false, '2026-09-30 15:38:53.282563-04');
INSERT INTO public.tokenrefresco VALUES (134, 1, 1, '698b40c615fde6b09bafce1d09015348ba80f2f7f31e73cf574704189e705666', '2026-10-07 15:38:53.685007-04', false, '2026-09-30 15:38:53.685007-04');
INSERT INTO public.tokenrefresco VALUES (136, 1, 1, '5ef23afe8dc35c76119a0d181af4aa3ee78c165c49c09efa5089e7c81a4b8f4e', '2026-10-07 15:38:54.348912-04', false, '2026-09-30 15:38:54.348912-04');
INSERT INTO public.tokenrefresco VALUES (803, 1, 1, 'fb486d0b331b1bb225959c58d40816ce384080f06d55e0375e7b80dc1249c420', '2026-10-12 20:32:32.725333-04', false, '2026-10-05 20:32:32.725333-04');
INSERT INTO public.tokenrefresco VALUES (804, 1, 1, '4d464b0611296d805139cfca7bacc53e2372aea8e9e47cbfe10c3e65173b869a', '2026-10-12 20:32:33.010763-04', false, '2026-10-05 20:32:33.010763-04');
INSERT INTO public.tokenrefresco VALUES (806, 1, 1, '84706e690280b6e6c7b970f40e615f26f7b3d1d6ebe7535d1c0c3887b2601d6c', '2026-10-12 20:32:33.549936-04', false, '2026-10-05 20:32:33.549936-04');
INSERT INTO public.tokenrefresco VALUES (24, 1, 1, '18d1e882546d39774bb967e593efcbd484e8bb9f60993026148ed7f856f1185d', '2026-10-07 15:21:11.336188-04', false, '2026-09-30 15:21:11.336188-04');
INSERT INTO public.tokenrefresco VALUES (25, 1, 1, '5bcc650a33b5ccc5e818a4c39cc464b6a2bdae25a207dab3b82245ef6b700881', '2026-10-07 15:21:11.557557-04', false, '2026-09-30 15:21:11.557557-04');
INSERT INTO public.tokenrefresco VALUES (26, 1, 1, '53fa8b0e2828920b49eff28d3bec36487b1b7242481bde0b52850a0d16386dd1', '2026-10-07 15:21:11.811264-04', false, '2026-09-30 15:21:11.811264-04');
INSERT INTO public.tokenrefresco VALUES (807, 1, 1, '44ee251aa6e991b8e71ad2634092c3d3b6444ffa847468b26ac3411ca68d7912', '2026-10-12 20:32:36.491308-04', false, '2026-10-05 20:32:36.491308-04');
INSERT INTO public.tokenrefresco VALUES (808, 1, 1, '2f697680d7ba3c4c6816a6db35eac75a05593b4e01f393e4fd9688270482edd4', '2026-10-12 20:32:36.648679-04', false, '2026-10-05 20:32:36.648679-04');
INSERT INTO public.tokenrefresco VALUES (839, 1, 1, '08d765c5fb05d92b03b06ab0776a0ec564d225a9361c9eff9386314b96f58a89', '2026-10-12 20:32:47.213562-04', false, '2026-10-05 20:32:47.215565-04');
INSERT INTO public.tokenrefresco VALUES (840, 1, 1, 'b3a913d8845e4f248e56462fd31c8d2efdfcd127e702e7ad76fe0c5f3f7fe957', '2026-10-12 20:32:47.38226-04', false, '2026-10-05 20:32:47.38226-04');
INSERT INTO public.tokenrefresco VALUES (841, 1, 1, '58ed2048e8487645e8adec8c77d5cdd1c3a3952a87518117cb8ed0a55ed80ca8', '2026-10-12 20:32:47.568593-04', false, '2026-10-05 20:32:47.568593-04');
INSERT INTO public.tokenrefresco VALUES (855, 2, 2, '88602d66e4b4301294ce8271fa7ab1ef62a876002fdb3d04d82c9279bc69608c', '2026-10-12 20:53:24.313715-04', true, '2026-10-05 20:53:24.314761-04');
INSERT INTO public.tokenrefresco VALUES (285, 1, 1, 'b239b482984d325f1e13d26d8c11d5b2318bcb593c91ea59bcae0533287e461c', '2026-10-07 15:46:00.765333-04', false, '2026-09-30 15:46:00.767342-04');
INSERT INTO public.tokenrefresco VALUES (286, 1, 1, '88de95a6418c6dd26207c105f1094260ffe7e797ee5a521dad442a3f65130fae', '2026-10-07 15:46:01.100379-04', false, '2026-09-30 15:46:01.103073-04');
INSERT INTO public.tokenrefresco VALUES (288, 1, 1, '755e4b10c271e91d6c3f33f599a54c69c5f5e2dbe868a1b6e31d34c93f1e3c31', '2026-10-07 15:46:01.83257-04', false, '2026-09-30 15:46:01.843668-04');
INSERT INTO public.tokenrefresco VALUES (323, 1, 1, '7b79dd8cee789f35735223dd5193c160c19dcfdeb92735cb05b48197ee9c0138', '2026-10-07 15:46:30.201311-04', false, '2026-09-30 15:46:30.203337-04');
INSERT INTO public.tokenrefresco VALUES (324, 1, 1, '5a9676d6fbe8e7356c97b933fc9a58e2ef1f8e83238f5a0e1901a2868a244744', '2026-10-07 15:46:30.552147-04', false, '2026-09-30 15:46:30.554165-04');
INSERT INTO public.tokenrefresco VALUES (326, 1, 1, 'b7b52cd28e97be8d1999f440c13824f0aaa20ae459d8f98ece22313a5b91f3b8', '2026-10-07 15:46:31.271525-04', false, '2026-09-30 15:46:31.273546-04');
INSERT INTO public.tokenrefresco VALUES (859, 1, 1, 'd2eb87f9a58b1f5d228be159abaf88dec8cab3e0c0a3ed6d12f1048681f41ef1', '2026-10-12 21:12:57.281252-04', false, '2026-10-05 21:12:57.281252-04');
INSERT INTO public.tokenrefresco VALUES (860, 1, 1, '46e1c446e8f97a22650ee05d94f0085139a9efd300487dc037d9e2df3e157920', '2026-10-12 21:12:57.492331-04', false, '2026-10-05 21:12:57.493308-04');
INSERT INTO public.tokenrefresco VALUES (863, 1, 1, '6e1a36c74ac7d846cf41f21374c7ef80fa7d41b66a06091c098cf11393719735', '2026-10-12 21:24:18.425171-04', false, '2026-10-05 21:24:18.42981-04');
INSERT INTO public.tokenrefresco VALUES (868, 1, 1, '0158d19d42f57382346e148507e359e250276bb4bf40c79cc2ffcb5f60b1cb32', '2026-11-08 11:01:30.944303-04', false, '2026-11-01 11:01:30.95873-04');
INSERT INTO public.tokenrefresco VALUES (880, 1, 1, '2bb17fe94708093ed8bc1be88f3df1a8044498ee50b351009a202050e547d584', '2026-11-08 11:45:40.788265-04', false, '2026-11-01 11:45:40.792788-04');
INSERT INTO public.tokenrefresco VALUES (45, 1, 1, '55cf2a2d95d63f75ff1505868e159d4b4b55a543a7b4d8b1239b8d028197d8fa', '2026-10-07 15:36:40.323316-04', false, '2026-09-30 15:36:40.323316-04');
INSERT INTO public.tokenrefresco VALUES (46, 1, 1, 'cbfe8fa1a2ed785f901482699d9e7ddaaa52fea7834b914300df04e16268a00a', '2026-10-07 15:36:40.699306-04', false, '2026-09-30 15:36:40.699306-04');
INSERT INTO public.tokenrefresco VALUES (47, 1, 1, 'ba94b116556bfdd91f39cfa2a4d797dc3195ba17ba430b5b9e2d34606610f257', '2026-10-07 15:36:41.073227-04', false, '2026-09-30 15:36:41.075254-04');
INSERT INTO public.tokenrefresco VALUES (48, 1, 1, 'e415701b7fed31df2feff9a7ff2cef0f65e8a7de5b06f6337f3ee25523854cc6', '2026-10-07 15:36:41.427291-04', false, '2026-09-30 15:36:41.427291-04');
INSERT INTO public.tokenrefresco VALUES (171, 1, 1, 'b1b869e577cc3e5fb6634c96691f60eef92d4201def28decbe25bdd1a31e1a7c', '2026-10-07 15:39:20.655844-04', false, '2026-09-30 15:39:20.657866-04');
INSERT INTO public.tokenrefresco VALUES (172, 1, 1, '1fdd6639af7f6876d821aecd380df049452d9e8e9622119a264d1293c137ec62', '2026-10-07 15:39:21.04699-04', false, '2026-09-30 15:39:21.04699-04');
INSERT INTO public.tokenrefresco VALUES (174, 1, 1, 'd53822acf453dc5896f3e7f650b4bdf14577bf5b6ff55e5578199cb16f9f36b9', '2026-10-07 15:39:21.814614-04', false, '2026-09-30 15:39:21.814614-04');
INSERT INTO public.tokenrefresco VALUES (209, 1, 1, '9e415dc5ff86afec6663c261fd180e2795c168ed1522bfb36efb396c7c172666', '2026-10-07 15:43:05.077263-04', false, '2026-09-30 15:43:05.077263-04');
INSERT INTO public.tokenrefresco VALUES (210, 1, 1, '8d6167f30c117575b0f65d37a149a3eeb32fe42ecd020ef1e4d1dc6074445885', '2026-10-07 15:43:05.800532-04', false, '2026-09-30 15:43:05.800532-04');
INSERT INTO public.tokenrefresco VALUES (212, 1, 1, '7d327142667b9bd77d7d4b72eb93a35b654ad8e0dac5e5336fce181474ee0c22', '2026-10-07 15:43:08.554227-04', false, '2026-09-30 15:43:08.554227-04');
INSERT INTO public.tokenrefresco VALUES (97, 1, 1, 'd5ff3bacbfa67d0ad8da81b5d6f32bbc61013f3060af3418fbcd880ca12441b0', '2026-10-07 15:38:22.201536-04', false, '2026-09-30 15:38:22.202554-04');
INSERT INTO public.tokenrefresco VALUES (112, 1, 1, '4df4f2c82cee5969c683ee568bb373971a0bfbe060f758c05a81f30deb55c52a', '2026-10-07 15:38:29.28075-04', false, '2026-09-30 15:38:29.296451-04');
INSERT INTO public.tokenrefresco VALUES (113, 1, 1, 'd8af028c54a970228c70c49b5f100dda02f06c263c9d8f6874d37517d04cec4c', '2026-10-07 15:38:29.517972-04', false, '2026-09-30 15:38:29.517972-04');
INSERT INTO public.tokenrefresco VALUES (114, 1, 1, '3238014fac28287e706fda299b32d01c2b252f1ac2ab255a33669782b5fd13fb', '2026-10-07 15:38:29.788231-04', false, '2026-09-30 15:38:29.788231-04');
INSERT INTO public.tokenrefresco VALUES (135, 1, 1, 'ab595c2f9ddbac58c14c9ee594077c725705c220017b5ebb1080466044abed01', '2026-10-07 15:38:54.04583-04', false, '2026-09-30 15:38:54.04583-04');
INSERT INTO public.tokenrefresco VALUES (150, 1, 1, 'a4e4ffc3d9bc9b2d8447086f598454507c065479e658c73d7d5447e7e30f8828', '2026-10-07 15:39:00.702207-04', false, '2026-09-30 15:39:00.702207-04');
INSERT INTO public.tokenrefresco VALUES (151, 1, 1, '5f197eb7ead860d2a0571cbdceb0942ddea60f00f1cdf148a960f81cc95774b0', '2026-10-07 15:39:00.912201-04', false, '2026-09-30 15:39:00.912201-04');
INSERT INTO public.tokenrefresco VALUES (152, 1, 1, '8377da1cb277a8b2d6ec3048d2d44d4335374778fb0e867e36b6ebf86054d7a1', '2026-10-07 15:39:01.143022-04', false, '2026-09-30 15:39:01.146239-04');
INSERT INTO public.tokenrefresco VALUES (264, 1, 1, '4db8e96a8cfe489f7820732d1f498546f409694e0935eef94df52faf65f28044', '2026-10-07 15:44:11.088891-04', false, '2026-09-30 15:44:11.088891-04');
INSERT INTO public.tokenrefresco VALUES (265, 1, 1, '3c382b80f72d2ae2a43cd961d8244d57d7bf70f57d141f088c0cbc9bf81312a5', '2026-10-07 15:44:11.322905-04', false, '2026-09-30 15:44:11.32472-04');
INSERT INTO public.tokenrefresco VALUES (266, 1, 1, 'a42c61fda2fd928003a4945728c9ea0d2e29c2d6e0a2b9c15dfb57bdde0ed78a', '2026-10-07 15:44:11.558985-04', false, '2026-09-30 15:44:11.558985-04');
INSERT INTO public.tokenrefresco VALUES (287, 1, 1, '43e51c18530e34cfc276fc388c8524d76c6885cd90e39ece1fb9417f5f570a03', '2026-10-07 15:46:01.521003-04', false, '2026-09-30 15:46:01.521003-04');
INSERT INTO public.tokenrefresco VALUES (302, 1, 1, 'a2b1aa08721ab0c5832acac353e89efac633b42ee3b9e77c0fd6102ae07d5d26', '2026-10-07 15:46:09.227344-04', false, '2026-09-30 15:46:09.227344-04');
INSERT INTO public.tokenrefresco VALUES (303, 1, 1, '57b8b304d5b0dc45a3bb8846b87ce9dcf9adaf70498a461dedfb5bd56a24f0df', '2026-10-07 15:46:09.51146-04', false, '2026-09-30 15:46:09.51146-04');
INSERT INTO public.tokenrefresco VALUES (304, 1, 1, '74feeb0ed9e2d51dd18338bddc13789d2480478e8f87bfc0cfedf1077a87c6ae', '2026-10-07 15:46:09.767405-04', false, '2026-09-30 15:46:09.767405-04');
INSERT INTO public.tokenrefresco VALUES (325, 1, 1, 'e79b50e36f096531c7c25f10c3f3fc6d2c74747cb55dde4744dc3e97ea982204', '2026-10-07 15:46:30.948508-04', false, '2026-09-30 15:46:30.950526-04');
INSERT INTO public.tokenrefresco VALUES (340, 1, 1, 'fdf71f2371656ea45fc4c83726f1e8bb8a09e38b98804cfa565409321cfbf932', '2026-10-07 15:46:38.297186-04', false, '2026-09-30 15:46:38.299208-04');
INSERT INTO public.tokenrefresco VALUES (341, 1, 1, '3b5bd798d0e2afebd0cac8a307cccee03bcd248337af34c11f744f1883acd32d', '2026-10-07 15:46:38.584595-04', false, '2026-09-30 15:46:38.586617-04');
INSERT INTO public.tokenrefresco VALUES (342, 1, 1, '067877306f94d3a3f264047d035ccad11eb2cee70f4e3ace2d91142257927295', '2026-10-07 15:46:38.858892-04', false, '2026-09-30 15:46:38.858892-04');
INSERT INTO public.tokenrefresco VALUES (361, 1, 1, '8298306a14de26e94995b80ee8247ea6ea32be0ad6de4150b1b7c86a87aec10d', '2026-10-07 16:15:49.399801-04', false, '2026-09-30 16:15:49.401812-04');
INSERT INTO public.tokenrefresco VALUES (362, 1, 1, '4a43c14fbd026bf8e0718051042d50e18e68b483750f8e8934a1bd3a4f25d06a', '2026-10-07 16:15:49.774149-04', false, '2026-09-30 16:15:49.774149-04');
INSERT INTO public.tokenrefresco VALUES (364, 1, 1, '204f5214803a677cc57d0a6828e2a260f5185890e0cb7d5cecb8007797299cee', '2026-10-07 16:15:50.576591-04', false, '2026-09-30 16:15:50.576591-04');
INSERT INTO public.tokenrefresco VALUES (475, 1, 1, '9ca11267153e7ff52d2ef7a1350a6a792afbd000fa6ecaaece6e73d9a260fa46', '2026-10-07 16:41:07.467602-04', false, '2026-09-30 16:41:07.471218-04');
INSERT INTO public.tokenrefresco VALUES (476, 1, 1, '01c9f744a654f0d91cb0b731ca7f4269d0b7b2ee069596f4a120c97394a73d5b', '2026-10-07 16:41:07.897373-04', false, '2026-09-30 16:41:07.897373-04');
INSERT INTO public.tokenrefresco VALUES (478, 1, 1, 'efbcd1db22ec5d3f25b918668665eba41b119f89475a01ef3fa004430f011a0d', '2026-10-07 16:41:08.71414-04', false, '2026-09-30 16:41:08.71414-04');
INSERT INTO public.tokenrefresco VALUES (401, 1, 1, '7c88150dc3b736e7b6416c8bd76b67c649505e069cac8bd5615671c1df7d21af', '2026-10-07 16:22:28.80795-04', false, '2026-09-30 16:22:28.80795-04');
INSERT INTO public.tokenrefresco VALUES (789, 1, 1, 'e5faf1823635efbf9b6b1a85394108078ede6705a0f3adf1ad3ba5f99c103f57', '2026-10-12 20:30:26.758555-04', false, '2026-10-05 20:30:26.758555-04');
INSERT INTO public.tokenrefresco VALUES (794, 1, 1, '0e6c4e11bcfbd1f668531a3beb511294abe24ffa822a8a120c02ec720878157e', '2026-10-12 20:31:58.027881-04', false, '2026-10-05 20:31:58.027881-04');
INSERT INTO public.tokenrefresco VALUES (515, 1, 1, 'ad20a924924c25bb71cdb32724960c64507d2d4f7afa2eb1388ec10717a42ad8', '2026-10-07 16:45:38.811508-04', false, '2026-09-30 16:45:38.811508-04');
INSERT INTO public.tokenrefresco VALUES (247, 1, 1, '5577b2541bc00b93304756f4aae87dce7254254be7694a62f3fff7efb7dc3909', '2026-10-07 15:44:03.05781-04', false, '2026-09-30 15:44:03.059825-04');
INSERT INTO public.tokenrefresco VALUES (248, 1, 1, '64b2b4709be6f3c7e26590fae35a4c890b9adb2ae51688ab2cc8b49e1f01de08', '2026-10-07 15:44:03.427005-04', false, '2026-09-30 15:44:03.43105-04');
INSERT INTO public.tokenrefresco VALUES (250, 1, 1, '1326835064b7ffb15b17cef95da11611cf80ffcdd8739126b41d888fd5e5846f', '2026-10-07 15:44:04.190552-04', false, '2026-09-30 15:44:04.192568-04');
INSERT INTO public.tokenrefresco VALUES (805, 1, 1, 'cc5e143c04b3e3c0f0b2a7d68cf1851aa61486f2aa755b138420195248e31046', '2026-10-12 20:32:33.312103-04', false, '2026-10-05 20:32:33.312103-04');
INSERT INTO public.tokenrefresco VALUES (856, 1, 1, '9857043c891dcc95e19a94c87a723bb519aca6672040481cbd43eaee649d58d9', '2026-10-12 20:54:00.850582-04', true, '2026-10-05 20:54:00.850582-04');
INSERT INTO public.tokenrefresco VALUES (861, 1, 1, '28ac3d1ffe498dedab1bea95d08765350ebc47dc56ed8167319b9001d7aedf57', '2026-10-12 21:13:19.91828-04', false, '2026-10-05 21:13:19.92571-04');
INSERT INTO public.tokenrefresco VALUES (864, 1, 1, '2efb9cd5cb1321bcadb7d4786aeb4a57f8964aa335b4ffa351f84705af04eb4f', '2026-10-12 21:30:00.890238-04', false, '2026-10-05 21:30:00.892777-04');
INSERT INTO public.tokenrefresco VALUES (865, 1, 1, '8051da65d328fe6f561821573c5ea3bd09a3f1ed0641c827426eb61178cabb6c', '2026-10-12 21:30:01.095363-04', false, '2026-10-05 21:30:01.095363-04');
INSERT INTO public.tokenrefresco VALUES (1292, 1, 1, 'c7c7455e4e4ce7c02ec7a4cf101070d0066afed1c9b1e1b52c0d0da833b47931', '2026-11-08 14:40:55.268903-04', true, '2026-11-01 14:40:55.278801-04');
INSERT INTO public.tokenrefresco VALUES (1293, 1, 1, '32ebcb18aa9dff6b9b133d4114318fa3e32d0567029451064b4c3b83c9adf8bd', '2026-11-08 14:59:28.620612-04', true, '2026-11-01 14:59:28.622011-04');
INSERT INTO public.tokenrefresco VALUES (416, 1, 1, '9559c79ecca9d770a25684aeae1e0b1d20970b4fb5fe1ac04fa8951f2987a121', '2026-10-07 16:22:36.4843-04', false, '2026-09-30 16:22:36.486312-04');
INSERT INTO public.tokenrefresco VALUES (417, 1, 1, '7a4904617bf8869cc49bdc95dbe0cc8ea95098cb17ce8f86efa8c92dd7bd8f54', '2026-10-07 16:22:36.713765-04', false, '2026-09-30 16:22:36.715778-04');
INSERT INTO public.tokenrefresco VALUES (418, 1, 1, '6f67fdde87e8c6034f5a938bae3b6d0c1eacb423b003451b6010f071f7cc1e39', '2026-10-07 16:22:36.961611-04', false, '2026-09-30 16:22:36.961611-04');
INSERT INTO public.tokenrefresco VALUES (1302, 1, 1, '0d2a588f02d454058fa8a03418ffa58a913b2d1068faac07aec606e56a363018', '2026-11-10 21:43:28.644944-04', true, '2026-11-03 21:43:28.669444-04');
INSERT INTO public.tokenrefresco VALUES (1303, 1, 1, 'bfc8f8fe1e3bf73b01592b308bd286245be96799b98bc44158aa9c12f28d71b6', '2026-11-10 22:17:02.894016-04', true, '2026-11-03 22:17:02.898452-04');
INSERT INTO public.tokenrefresco VALUES (1304, 1, 1, 'ba9a43f609b9617d15a647bfb5911484cc5cf183a24e67e61f212cf0d669ec6d', '2026-11-10 23:20:32.434617-04', true, '2026-11-03 23:20:32.434617-04');
INSERT INTO public.tokenrefresco VALUES (1305, 1, 1, '5fca8599775f05a1d84711ebee87608f5ef27b573914edc3dd0258aa056c0920', '2026-11-10 23:48:54.787336-04', true, '2026-11-03 23:48:54.796611-04');
INSERT INTO public.tokenrefresco VALUES (1312, 1, 1, '85ed8a9053c6413d8aaeac85e386298f961906a65820f56c78e78a7fc723a2b1', '2026-11-11 00:59:47.398854-04', true, '2026-11-04 00:59:47.40085-04');
INSERT INTO public.tokenrefresco VALUES (62, 1, 1, '45e9f28043a599779dd1de51ce478cba676035d50657e3fd9bc1bf3caab2e69f', '2026-10-07 15:36:48.323232-04', false, '2026-09-30 15:36:48.323232-04');
INSERT INTO public.tokenrefresco VALUES (63, 1, 1, '502cf5b4f3f633fb625ea78f6e2d657d44ef04793da4a99fcf85b450eebe344a', '2026-10-07 15:36:48.548633-04', false, '2026-09-30 15:36:48.548633-04');
INSERT INTO public.tokenrefresco VALUES (64, 1, 1, '99930e91a14df943f419153bc27bfc0eb70706b25b42be412f3a766031fdd29a', '2026-10-07 15:36:48.786476-04', false, '2026-09-30 15:36:48.786476-04');
INSERT INTO public.tokenrefresco VALUES (173, 1, 1, 'c9f82cf968d987c261ce8e48a1d9e456b18a267906836914c8ea7d2bfd9cae4b', '2026-10-07 15:39:21.449837-04', false, '2026-09-30 15:39:21.449837-04');
INSERT INTO public.tokenrefresco VALUES (188, 1, 1, 'f994b40616c1ba773f7a4e6990ca69c6792573c77d5eb7160dd459a127e9fc09', '2026-10-07 15:39:28.532324-04', false, '2026-09-30 15:39:28.538148-04');
INSERT INTO public.tokenrefresco VALUES (189, 1, 1, '3fcb1ac6bf64a250c618e6421d388e8f36eb8bb0fe3853f25cfbe2710c88fa60', '2026-10-07 15:39:28.78832-04', false, '2026-09-30 15:39:28.78832-04');
INSERT INTO public.tokenrefresco VALUES (190, 1, 1, 'fbfe19492d8bacdb065b335a2e562d182ced70998346a45285eb72878d9bf7cc', '2026-10-07 15:39:29.025738-04', false, '2026-09-30 15:39:29.028935-04');
INSERT INTO public.tokenrefresco VALUES (211, 1, 1, 'ee0e8611e1217a0193d60356b4c16f47947d88716ceee3611a58338e5b8c0b8b', '2026-10-07 15:43:08.067124-04', false, '2026-09-30 15:43:08.067124-04');
INSERT INTO public.tokenrefresco VALUES (226, 1, 1, 'd1e9537c4b91ee0e3d253978601a5673b8bb949ec87a85c7b2090fa27110d8f6', '2026-10-07 15:43:16.337727-04', false, '2026-09-30 15:43:16.339752-04');
INSERT INTO public.tokenrefresco VALUES (227, 1, 1, '538e32349c9e6be0d06a29563165651b5252568affccc9b72033c3ebea063f8e', '2026-10-07 15:43:16.65804-04', false, '2026-09-30 15:43:16.663308-04');
INSERT INTO public.tokenrefresco VALUES (228, 1, 1, '0998bc4267313483f4ffd80cb44a2301977e3551229dc3b6d9e3b7f2e5a579b7', '2026-10-07 15:43:16.934504-04', false, '2026-09-30 15:43:16.934504-04');
INSERT INTO public.tokenrefresco VALUES (363, 1, 1, '5122fe626624e6c025aa1d2912627d36a4e0323e292c251800a9ce047d161baa', '2026-10-07 16:15:50.222806-04', false, '2026-09-30 16:15:50.222806-04');
INSERT INTO public.tokenrefresco VALUES (378, 1, 1, '3660bcda16626d1a08d7b2c572f2c9f809407e041cb3a10db3cf6adb62bc27ca', '2026-10-07 16:15:57.3691-04', false, '2026-09-30 16:15:57.3691-04');
INSERT INTO public.tokenrefresco VALUES (379, 1, 1, '74e5a741ddb2104c5e2bf7bbcce73ccac03c4fd7bb87ef717805a248616fe04f', '2026-10-07 16:15:57.601747-04', false, '2026-09-30 16:15:57.601747-04');
INSERT INTO public.tokenrefresco VALUES (380, 1, 1, 'e3203dc433861739be88a4773f19c3632290051f78b6c49b9bd97568746edc78', '2026-10-07 16:15:57.86408-04', false, '2026-09-30 16:15:57.867313-04');
INSERT INTO public.tokenrefresco VALUES (399, 1, 1, '34dfbf851c48d8fcc909b6ade0bab186baf56a93cfbfedeba538fbc927f74416', '2026-10-07 16:22:27.95941-04', false, '2026-09-30 16:22:27.95941-04');
INSERT INTO public.tokenrefresco VALUES (400, 1, 1, '09359ca807578fc7d501f45d270ad07f76ce9792e064afecc063e1f15ecbf217', '2026-10-07 16:22:28.36967-04', false, '2026-09-30 16:22:28.36967-04');
INSERT INTO public.tokenrefresco VALUES (249, 1, 1, '899b4346ef7919424ced02772f199c573ca2e8fa96afab1b8108fc818a876039', '2026-10-07 15:44:03.840943-04', false, '2026-09-30 15:44:03.84394-04');
INSERT INTO public.tokenrefresco VALUES (402, 1, 1, 'cbce5bd319a78a8097cf17eb654934b1adf5e9cae7a76563aa6f2407900a6491', '2026-10-07 16:22:29.174599-04', false, '2026-09-30 16:22:29.17662-04');
INSERT INTO public.tokenrefresco VALUES (477, 1, 1, 'e25306eedd9bc46f398d6c33439c8e037ad4b286d5d529a2d3b8d3b03c2a6dcc', '2026-10-07 16:41:08.351963-04', false, '2026-09-30 16:41:08.351963-04');
INSERT INTO public.tokenrefresco VALUES (492, 1, 1, 'c3dc16f25041be84899b65a55c3e746d524a13c63f73daf28c29623be4f1fae3', '2026-10-07 16:41:15.86807-04', false, '2026-09-30 16:41:15.86807-04');
INSERT INTO public.tokenrefresco VALUES (493, 1, 1, '11b179332c2c49b4fd656484cad3785cb2a5e7ad8fed5f2435bb2d3e4ac98b07', '2026-10-07 16:41:16.103435-04', false, '2026-09-30 16:41:16.10649-04');
INSERT INTO public.tokenrefresco VALUES (494, 1, 1, '1b6331c8af9386421a1c281fb368a6a170e653540548aa589ade531e61deb953', '2026-10-07 16:41:16.350459-04', false, '2026-09-30 16:41:16.353701-04');
INSERT INTO public.tokenrefresco VALUES (513, 1, 1, '90bd3303269e2eccc170a39c89936cf06aab2cde32039fae48c3a5d358c6edc1', '2026-10-07 16:45:37.999876-04', false, '2026-09-30 16:45:38.003083-04');
INSERT INTO public.tokenrefresco VALUES (514, 1, 1, 'a1a8e7feeed1cf75f2b0350dceeb03d6ee2f310177919d9266f6f7dbe7026b72', '2026-10-07 16:45:38.382689-04', false, '2026-09-30 16:45:38.382689-04');
INSERT INTO public.tokenrefresco VALUES (516, 1, 1, '0d58c4b6a37ef307f14d5a5c1e4ad34dcc9e3bae8834690808bcf70188339096', '2026-10-07 16:45:39.170841-04', false, '2026-09-30 16:45:39.170841-04');
INSERT INTO public.tokenrefresco VALUES (530, 1, 1, '17f5a252f1c65efa47f40ec7253e696d08347e0c1c7ca34b5f9c3766c94d19aa', '2026-10-07 16:45:48.138469-04', false, '2026-09-30 16:45:48.140483-04');
INSERT INTO public.tokenrefresco VALUES (437, 1, 1, '398f1ca74350a9fd1a9c456a28a8815e353bf1a06e89f5d9bc4ed52d438ef74a', '2026-10-07 16:30:44.182798-04', false, '2026-09-30 16:30:44.182798-04');
INSERT INTO public.tokenrefresco VALUES (438, 1, 1, '553abe99dd13cc137e03dcea5e65bd59a4116f2ff3ea24cb0f3f0c099bc415cf', '2026-10-07 16:30:44.538378-04', false, '2026-09-30 16:30:44.540398-04');
INSERT INTO public.tokenrefresco VALUES (439, 1, 1, 'a64b970631eebc7d4c5554015fa38ba24647e5f21e7c2d977b24fd593c3ae698', '2026-10-07 16:30:44.916425-04', false, '2026-09-30 16:30:44.918431-04');
INSERT INTO public.tokenrefresco VALUES (440, 1, 1, '44cf326780ae73b9e6ecec0cb0d662c237ce368e3aa0a4ed68a084be1aca22ba', '2026-10-07 16:30:45.242332-04', false, '2026-09-30 16:30:45.242332-04');
INSERT INTO public.tokenrefresco VALUES (531, 1, 1, 'e3f29e7ee39637e468676d6d19d4c98a928e04ace4aab7da5175b455135c7495', '2026-10-07 16:45:48.385523-04', false, '2026-09-30 16:45:48.385523-04');
INSERT INTO public.tokenrefresco VALUES (532, 1, 1, '9c7b1d27f5fa87babe53cc38cc159a5929eaa711b66202f190b82f0d525db973', '2026-10-07 16:45:48.640159-04', false, '2026-09-30 16:45:48.640159-04');
INSERT INTO public.tokenrefresco VALUES (790, 1, 1, '705485c86b114e491616f6866e2dd8e32a46ff0790094a6d045c32d9c5538870', '2026-10-12 20:30:27.02359-04', false, '2026-10-05 20:30:27.02359-04');
INSERT INTO public.tokenrefresco VALUES (795, 1, 1, '4198989c9ef84cc2fee8afb6c35a0a2a55d1ae1952e640b90ca481b2f124f573', '2026-10-12 20:32:13.975165-04', false, '2026-10-05 20:32:13.980502-04');
INSERT INTO public.tokenrefresco VALUES (454, 1, 1, 'a8c87f341c704c0d17c8ad6207d784644480dea519ddaaa835e0a935f8ffbe4e', '2026-10-07 16:30:51.917346-04', false, '2026-09-30 16:30:51.917346-04');
INSERT INTO public.tokenrefresco VALUES (455, 1, 1, '6e629e1f928a9f2bf656977e95f32b5672be63d3b86291df15a86e46c0c4c3e2', '2026-10-07 16:30:52.138628-04', false, '2026-09-30 16:30:52.140647-04');
INSERT INTO public.tokenrefresco VALUES (456, 1, 1, '15c770d79b58401722a55dfe4e478baf8b599981c51f8e51650ae15d3a3da8d4', '2026-10-07 16:30:52.375087-04', false, '2026-09-30 16:30:52.375087-04');
INSERT INTO public.tokenrefresco VALUES (1306, 1, 1, 'c9312b4104d3726a3b228475fda85f5e6d12e9207ea73f41f48065a4bda0067f', '2026-11-11 00:00:57.189169-04', true, '2026-11-04 00:00:57.19471-04');
INSERT INTO public.tokenrefresco VALUES (551, 1, 1, '1171cb8d64f7708db0b547af313b05953662b4dd151317b635ef7fe94276efc7', '2026-10-07 16:46:47.391399-04', false, '2026-09-30 16:46:47.393416-04');
INSERT INTO public.tokenrefresco VALUES (552, 1, 1, 'dac2b62cca68aa42d9d955c89247604017885ae8bde41eb62592207944b20b48', '2026-10-07 16:46:47.876667-04', false, '2026-09-30 16:46:47.876667-04');
INSERT INTO public.tokenrefresco VALUES (553, 1, 1, 'ebd9289a1ebea96a25adda727ba7916dc4f7978e0129b7d2eacd9394ac018bf9', '2026-10-07 16:46:48.52114-04', false, '2026-09-30 16:46:48.52114-04');
INSERT INTO public.tokenrefresco VALUES (554, 1, 1, '536ce2b0ca80e40319f83454f6a692fce0b83b84a6f7fddcbaf73d6beadb5f0c', '2026-10-07 16:46:49.174768-04', false, '2026-09-30 16:46:49.175824-04');
INSERT INTO public.tokenrefresco VALUES (791, 1, 1, '29ab3a9bee327092ea5bfdcc8a082efb7c49ea67a85cbe6d69138961c382675e', '2026-10-12 20:31:16.466862-04', false, '2026-10-05 20:31:16.466862-04');
INSERT INTO public.tokenrefresco VALUES (796, 1, 1, '956a1fcefe2b59e23c122d1e9fb2a988def86ac28a18544b70df923530fdf628', '2026-10-12 20:32:14.21997-04', false, '2026-10-05 20:32:14.21997-04');
INSERT INTO public.tokenrefresco VALUES (854, 2, 2, 'e6ce1304a245731b5fbbf014172262a809fce2307dba8ecedf81f684cd07fca1', '2026-10-12 20:39:24.648249-04', false, '2026-10-05 20:39:24.658038-04');
INSERT INTO public.tokenrefresco VALUES (857, 1, 1, 'c242ed62941638ef5656a7518063b356fc9318ffc7815db9462dfbbd895583ef', '2026-10-12 21:04:04.347285-04', false, '2026-10-05 21:04:04.347285-04');
INSERT INTO public.tokenrefresco VALUES (858, 1, 1, '70fe677cbf630ab1e646cf4edae2fe18bff6787ba9f9e577930f7eb027afbb98', '2026-10-12 21:04:04.533525-04', false, '2026-10-05 21:04:04.533525-04');
INSERT INTO public.tokenrefresco VALUES (862, 1, 1, '6df3e647d66fd3da3d36b21a059ff7c68e57a63a7abb38301b89815f885706e3', '2026-10-12 21:13:36.480194-04', false, '2026-10-05 21:13:36.482199-04');
INSERT INTO public.tokenrefresco VALUES (866, 1, 1, '4feb73b31a19e7fc2bd28af265067d22b65b1ef652427f76e6e67c0d11d5db64', '2026-10-12 23:16:55.750041-04', false, '2026-10-05 23:16:55.766044-04');
INSERT INTO public.tokenrefresco VALUES (867, 1, 1, 'b24b7aff5a0eb3fb7bb92fbe64052d7b7e8123feca41642fa834f033fd850086', '2026-10-13 01:48:03.189128-04', false, '2026-10-06 01:48:03.200961-04');
INSERT INTO public.tokenrefresco VALUES (878, 1, 1, '11da6f80c36ec22013cef0f309d887634e8b73f686d7a3086e70725865aa90eb', '2026-11-08 11:44:10.71457-04', true, '2026-11-01 11:44:10.716578-04');
INSERT INTO public.tokenrefresco VALUES (879, 2, 2, '79d5d727a1b5ad12f7c063e34aa7006e08aa7cdca48e6890e89fee5efb3bf1e3', '2026-11-08 11:45:14.691768-04', true, '2026-11-01 11:45:14.691768-04');
INSERT INTO public.tokenrefresco VALUES (568, 1, 1, 'f4ce4da640ae550f2a6a1dc857c8c59684692877301e224d060b2b5b8c1e9780', '2026-10-07 16:46:57.208241-04', false, '2026-09-30 16:46:57.208841-04');
INSERT INTO public.tokenrefresco VALUES (569, 1, 1, '927dbf578b23af6e8d91fc73b43a00a926531f9ea11dc2435bca3039567c2497', '2026-10-07 16:46:57.5046-04', false, '2026-09-30 16:46:57.50879-04');
INSERT INTO public.tokenrefresco VALUES (570, 1, 1, '2d38072d74ebd3317f66795e62e5baf7c90df0da8c4b3e0b0c31e808c5a0baae', '2026-10-07 16:46:57.783913-04', false, '2026-09-30 16:46:57.783913-04');
INSERT INTO public.tokenrefresco VALUES (1309, 1, 1, '7c739becf272083085ae09dcc0d7d25d63d4ca8601295e9fb07ebb8280f806d4', '2026-11-11 00:38:08.859055-04', true, '2026-11-04 00:38:08.867677-04');
INSERT INTO public.tokenrefresco VALUES (787, 1, 1, 'cf72015f09318d4130885f0fb76b365dd4f855ad0938f78aa26da18dedaf0a4a', '2026-10-12 17:44:07.443807-04', true, '2026-10-05 17:44:07.459411-04');
INSERT INTO public.tokenrefresco VALUES (792, 1, 1, '3d27a00df8715901e783572e103d98d2260cbf7c0f5b8c64a06c66c50a731252', '2026-10-12 20:31:16.708319-04', false, '2026-10-05 20:31:16.708319-04');


--
-- Data for Name: ubicacion; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.ubicacion VALUES (1, 1, 1, 'Almacén Principal', 'Av. Principal, La Paz', NULL, NULL, 'La Paz', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (2, 1, 2, 'Tienda Centro', 'Av. Principal, La Paz', NULL, NULL, 'La Paz', 'Bolivia', 'punto_venta');
INSERT INTO public.ubicacion VALUES (3, 2, 3, 'Almacén Principal', 'Av. Principal, Santa Cruz de la Sierra', NULL, NULL, 'Santa Cruz de la Sierra', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (4, 2, 4, 'Tienda Centro', 'Av. Principal, Santa Cruz de la Sierra', NULL, NULL, 'Santa Cruz de la Sierra', 'Bolivia', 'punto_venta');
INSERT INTO public.ubicacion VALUES (5, 3, 5, 'Almacén Principal', 'Av. Principal, Cochabamba', NULL, NULL, 'Cochabamba', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (6, 3, 6, 'Tienda Centro', 'Av. Principal, Cochabamba', NULL, NULL, 'Cochabamba', 'Bolivia', 'punto_venta');
INSERT INTO public.ubicacion VALUES (7, 4, 7, 'Almacén Principal', 'Av. Principal, El Alto', NULL, NULL, 'El Alto', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (8, 4, 8, 'Tienda Centro', 'Av. Principal, El Alto', NULL, NULL, 'El Alto', 'Bolivia', 'punto_venta');
INSERT INTO public.ubicacion VALUES (9, 5, 9, 'Almacén Principal', 'Av. Principal, Sucre', NULL, NULL, 'Sucre', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (10, 5, 10, 'Tienda Centro', 'Av. Principal, Sucre', NULL, NULL, 'Sucre', 'Bolivia', 'punto_venta');
INSERT INTO public.ubicacion VALUES (73, 1, NULL, 'Almacén Central 1790797451386', 'Av. Banzer Km 8', NULL, NULL, 'Santa Cruz', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (322, 1, NULL, 'Almacén Central 1791246767450', 'Av. Banzer Km 8', NULL, NULL, 'Santa Cruz', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (19, 1, NULL, 'Almacén Central 1790796071637', 'Av. Banzer Km 8', NULL, NULL, 'Santa Cruz', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (82, 1, NULL, 'Almacén Central 1790797569578', 'Av. Banzer Km 8', NULL, NULL, 'Santa Cruz', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (28, 1, NULL, 'Almacén Central 1790797008622', 'Av. Banzer Km 8', NULL, NULL, 'Santa Cruz', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (91, 1, NULL, 'Almacén Central 1790797598659', 'Av. Banzer Km 8', NULL, NULL, 'Santa Cruz', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (37, 1, NULL, 'Almacén Central 1790797109566', 'Av. Banzer Km 8', NULL, NULL, 'Santa Cruz', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (100, 1, NULL, 'Almacén Central 1790799357698', 'Av. Banzer Km 8', NULL, NULL, 'Santa Cruz', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (46, 1, NULL, 'Almacén Central 1790797140971', 'Av. Banzer Km 8', NULL, NULL, 'Santa Cruz', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (55, 1, NULL, 'Almacén Central 1790797168850', 'Av. Banzer Km 8', NULL, NULL, 'Santa Cruz', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (109, 1, NULL, 'Almacén Central 1790799756789', 'Av. Banzer Km 8', NULL, NULL, 'Santa Cruz', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (64, 1, NULL, 'Almacén Central 1790797396744', 'Av. Banzer Km 8', NULL, NULL, 'Santa Cruz', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (118, 1, NULL, 'Almacén Central 1790800252218', 'Av. Banzer Km 8', NULL, NULL, 'Santa Cruz', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (127, 1, NULL, 'Almacén Central 1790800876175', 'Av. Banzer Km 8', NULL, NULL, 'Santa Cruz', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (145, 1, NULL, 'Almacén Central 1790801217587', 'Av. Banzer Km 8', NULL, NULL, 'Santa Cruz', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (136, 1, NULL, 'Almacén Central 1790801148449', 'Av. Banzer Km 8', NULL, NULL, 'Santa Cruz', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (282, 1, 146, 'Aduana Interior Santa Cruz (Viru Viru) - 1', 'Aeropuerto Internacional Viru Viru, Terminal de Carga', -17.64482000, -63.13541000, 'Santa Cruz de la Sierra', 'Bolivia', 'aduana');
INSERT INTO public.ubicacion VALUES (283, 1, 692, 'Centro de Distribución Parque Industrial - 1', 'Parque Industrial PI-27, Calle 5 Este', -17.76541000, -63.14125000, 'Santa Cruz de la Sierra', 'Bolivia', 'centro_distribucion');
INSERT INTO public.ubicacion VALUES (284, 1, 692, 'Almacén Central Equipetrol - 1', 'Av. San Martín esq. Calle 8 Este, Equipetrol Norte', -17.76312000, -63.19584000, 'Santa Cruz de la Sierra', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (285, 1, 2, 'iStore Ventura Mall - 1', 'Ventura Mall, 4to Anillo, Nivel 1 Local 142', -17.75470000, -63.20163000, 'Santa Cruz de la Sierra', 'Bolivia', 'punto_venta');
INSERT INTO public.ubicacion VALUES (286, 1, 2, 'Sucursal Las Brisas Mall - 1', 'Las Brisas Centro Comercial, 4to Anillo y Av. Cristo Redentor', -17.74721000, -63.17892000, 'Santa Cruz de la Sierra', 'Bolivia', 'punto_venta');
INSERT INTO public.ubicacion VALUES (287, 2, 694, 'Aduana Interior Santa Cruz (Viru Viru) - 2', 'Aeropuerto Internacional Viru Viru, Terminal de Carga', -17.64482000, -63.13541000, 'Santa Cruz de la Sierra', 'Bolivia', 'aduana');
INSERT INTO public.ubicacion VALUES (288, 2, 695, 'Centro de Distribución Parque Industrial - 2', 'Parque Industrial PI-27, Calle 5 Este', -17.76541000, -63.14125000, 'Santa Cruz de la Sierra', 'Bolivia', 'centro_distribucion');
INSERT INTO public.ubicacion VALUES (289, 2, 695, 'Almacén Central Equipetrol - 2', 'Av. San Martín esq. Calle 8 Este, Equipetrol Norte', -17.76312000, -63.19584000, 'Santa Cruz de la Sierra', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (290, 2, 4, 'iStore Ventura Mall - 2', 'Ventura Mall, 4to Anillo, Nivel 1 Local 142', -17.75470000, -63.20163000, 'Santa Cruz de la Sierra', 'Bolivia', 'punto_venta');
INSERT INTO public.ubicacion VALUES (291, 2, 4, 'Sucursal Las Brisas Mall - 2', 'Las Brisas Centro Comercial, 4to Anillo y Av. Cristo Redentor', -17.74721000, -63.17892000, 'Santa Cruz de la Sierra', 'Bolivia', 'punto_venta');
INSERT INTO public.ubicacion VALUES (292, 3, 697, 'Aduana Interior Santa Cruz (Viru Viru) - 3', 'Aeropuerto Internacional Viru Viru, Terminal de Carga', -17.64482000, -63.13541000, 'Santa Cruz de la Sierra', 'Bolivia', 'aduana');
INSERT INTO public.ubicacion VALUES (293, 3, 698, 'Centro de Distribución Parque Industrial - 3', 'Parque Industrial PI-27, Calle 5 Este', -17.76541000, -63.14125000, 'Santa Cruz de la Sierra', 'Bolivia', 'centro_distribucion');
INSERT INTO public.ubicacion VALUES (294, 3, 698, 'Almacén Central Equipetrol - 3', 'Av. San Martín esq. Calle 8 Este, Equipetrol Norte', -17.76312000, -63.19584000, 'Santa Cruz de la Sierra', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (295, 3, 6, 'iStore Ventura Mall - 3', 'Ventura Mall, 4to Anillo, Nivel 1 Local 142', -17.75470000, -63.20163000, 'Santa Cruz de la Sierra', 'Bolivia', 'punto_venta');
INSERT INTO public.ubicacion VALUES (296, 3, 6, 'Sucursal Las Brisas Mall - 3', 'Las Brisas Centro Comercial, 4to Anillo y Av. Cristo Redentor', -17.74721000, -63.17892000, 'Santa Cruz de la Sierra', 'Bolivia', 'punto_venta');
INSERT INTO public.ubicacion VALUES (297, 4, 700, 'Aduana Interior Santa Cruz (Viru Viru) - 4', 'Aeropuerto Internacional Viru Viru, Terminal de Carga', -17.64482000, -63.13541000, 'Santa Cruz de la Sierra', 'Bolivia', 'aduana');
INSERT INTO public.ubicacion VALUES (298, 4, 701, 'Centro de Distribución Parque Industrial - 4', 'Parque Industrial PI-27, Calle 5 Este', -17.76541000, -63.14125000, 'Santa Cruz de la Sierra', 'Bolivia', 'centro_distribucion');
INSERT INTO public.ubicacion VALUES (299, 4, 701, 'Almacén Central Equipetrol - 4', 'Av. San Martín esq. Calle 8 Este, Equipetrol Norte', -17.76312000, -63.19584000, 'Santa Cruz de la Sierra', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (300, 4, 8, 'iStore Ventura Mall - 4', 'Ventura Mall, 4to Anillo, Nivel 1 Local 142', -17.75470000, -63.20163000, 'Santa Cruz de la Sierra', 'Bolivia', 'punto_venta');
INSERT INTO public.ubicacion VALUES (301, 4, 8, 'Sucursal Las Brisas Mall - 4', 'Las Brisas Centro Comercial, 4to Anillo y Av. Cristo Redentor', -17.74721000, -63.17892000, 'Santa Cruz de la Sierra', 'Bolivia', 'punto_venta');
INSERT INTO public.ubicacion VALUES (302, 5, 703, 'Aduana Interior Santa Cruz (Viru Viru) - 5', 'Aeropuerto Internacional Viru Viru, Terminal de Carga', -17.64482000, -63.13541000, 'Santa Cruz de la Sierra', 'Bolivia', 'aduana');
INSERT INTO public.ubicacion VALUES (303, 5, 704, 'Centro de Distribución Parque Industrial - 5', 'Parque Industrial PI-27, Calle 5 Este', -17.76541000, -63.14125000, 'Santa Cruz de la Sierra', 'Bolivia', 'centro_distribucion');
INSERT INTO public.ubicacion VALUES (304, 5, 704, 'Almacén Central Equipetrol - 5', 'Av. San Martín esq. Calle 8 Este, Equipetrol Norte', -17.76312000, -63.19584000, 'Santa Cruz de la Sierra', 'Bolivia', 'almacen');
INSERT INTO public.ubicacion VALUES (305, 5, 10, 'iStore Ventura Mall - 5', 'Ventura Mall, 4to Anillo, Nivel 1 Local 142', -17.75470000, -63.20163000, 'Santa Cruz de la Sierra', 'Bolivia', 'punto_venta');
INSERT INTO public.ubicacion VALUES (306, 5, 10, 'Sucursal Las Brisas Mall - 5', 'Las Brisas Centro Comercial, 4to Anillo y Av. Cristo Redentor', -17.74721000, -63.17892000, 'Santa Cruz de la Sierra', 'Bolivia', 'punto_venta');


--
-- Data for Name: unidadproducto; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.unidadproducto VALUES (1, 1, 1, 1, 'DEMO-1-SN-001', '351100000001', NULL, NULL, '8205c0cf-d93e-4825-b82b-b75903c9b58e', 2, 1, 'disponible', '2026-09-10 01:41:16.864524', NULL);
INSERT INTO public.unidadproducto VALUES (2, 1, 3, 1, 'DEMO-1-SN-002', '351300000001', NULL, NULL, '39f97490-b73f-4d13-a929-2718405e12b2', 2, 2, 'disponible', '2026-09-10 01:41:16.874549', NULL);
INSERT INTO public.unidadproducto VALUES (3, 1, 6, 1, 'DEMO-1-SN-003', NULL, NULL, NULL, 'ba92f608-b1ec-4cd4-903b-b8726b7b38d9', 2, 1, 'disponible', '2026-09-10 01:41:16.881418', NULL);
INSERT INTO public.unidadproducto VALUES (4, 2, 1, 1, 'DEMO-2-SN-001', '352100000001', NULL, NULL, 'd11d8a1a-acdc-43a5-ae4b-c99f960cebde', 4, 3, 'disponible', '2026-09-10 01:41:17.048719', NULL);
INSERT INTO public.unidadproducto VALUES (5, 2, 3, 1, 'DEMO-2-SN-002', '352300000001', NULL, NULL, 'c6fabac6-2629-4f1d-bcd9-150840b32417', 4, 4, 'disponible', '2026-09-10 01:41:17.054459', NULL);
INSERT INTO public.unidadproducto VALUES (6, 2, 6, 1, 'DEMO-2-SN-003', NULL, NULL, NULL, '3984dedb-70d8-4a84-9094-3b662daec36d', 4, 3, 'disponible', '2026-09-10 01:41:17.063077', NULL);
INSERT INTO public.unidadproducto VALUES (7, 3, 1, 1, 'DEMO-3-SN-001', '353100000001', NULL, NULL, '74eff322-3816-4892-b6a3-add6c6ed2273', 6, 5, 'disponible', '2026-09-10 01:41:17.272609', NULL);
INSERT INTO public.unidadproducto VALUES (8, 3, 3, 1, 'DEMO-3-SN-002', '353300000001', NULL, NULL, '15fa17e0-2ace-4382-87d3-4a52bebf9a5c', 6, 6, 'disponible', '2026-09-10 01:41:17.278466', NULL);
INSERT INTO public.unidadproducto VALUES (9, 3, 6, 1, 'DEMO-3-SN-003', NULL, NULL, NULL, 'c3e1af64-13f0-4f25-95a6-58c444082fc6', 6, 5, 'disponible', '2026-09-10 01:41:17.286214', NULL);
INSERT INTO public.unidadproducto VALUES (10, 4, 1, 1, 'DEMO-4-SN-001', '354100000001', NULL, NULL, '080e17fc-047b-4e88-8047-17d9ce9232ed', 8, 7, 'disponible', '2026-09-10 01:41:17.481014', NULL);
INSERT INTO public.unidadproducto VALUES (11, 4, 3, 1, 'DEMO-4-SN-002', '354300000001', NULL, NULL, '4bbcc659-b3dd-433b-b226-01d164ca42d7', 8, 8, 'disponible', '2026-09-10 01:41:17.489805', NULL);
INSERT INTO public.unidadproducto VALUES (12, 4, 6, 1, 'DEMO-4-SN-003', NULL, NULL, NULL, '89db2076-811f-4efe-ab7f-d617ba910992', 8, 7, 'disponible', '2026-09-10 01:41:17.496209', NULL);
INSERT INTO public.unidadproducto VALUES (13, 5, 1, 1, 'DEMO-5-SN-001', '355100000001', NULL, NULL, 'f5c4b40f-84f9-4a80-a1b5-34c02fed157a', 10, 9, 'disponible', '2026-09-10 01:41:17.686546', NULL);
INSERT INTO public.unidadproducto VALUES (14, 5, 3, 1, 'DEMO-5-SN-002', '355300000001', NULL, NULL, '297986e1-5381-48ea-8bb4-49f594b6d7b9', 10, 10, 'disponible', '2026-09-10 01:41:17.693614', NULL);
INSERT INTO public.unidadproducto VALUES (15, 5, 6, 1, 'DEMO-5-SN-003', NULL, NULL, NULL, '4905ffb4-57fb-414b-9a11-b3181bba1301', 10, 9, 'disponible', '2026-09-10 01:41:17.696641', NULL);
INSERT INTO public.unidadproducto VALUES (416, 1, 399, 1, 'K4L162NSZVV', '354019232633221', '354019232633222', '8904903201EA92B26FA8ADC30543FE5A', '9120e996-fca4-4a45-9157-f0602ddf7716', 692, 286, 'disponible', '2026-09-13 00:14:32.498531', NULL);
INSERT INTO public.unidadproducto VALUES (149, 1, 184, 1, 'SN-1790801148737', '3591790801148737', '3581790801148737', 'EID1790801148737', 'e946de0b-2584-448d-acf3-17141b423a0b', NULL, NULL, 'disponible', '2026-09-30 20:45:48.835944', NULL);
INSERT INTO public.unidadproducto VALUES (158, 1, 195, 1, 'SN-1790801217903', '3591790801217903', '3581790801217903', 'EID1790801217903', '4693d5d5-c54e-40ab-894e-eb2d3246671a', NULL, NULL, 'disponible', '2026-09-30 20:46:58.017762', NULL);
INSERT INTO public.unidadproducto VALUES (417, 1, 400, 1, 'J8K144RJREK', '359812082950012', '359812082950013', '8904903201AC616F8FD0BA84A167FE48', '009bcda0-38ee-40cc-91e8-d72a86a6883d', 692, 283, 'disponible', '2026-09-20 00:14:32.533938', NULL);
INSERT INTO public.unidadproducto VALUES (418, 1, 401, 1, 'M031XVAML5R', '351829449995413', '351829449995414', '89049032015FC3391BDF82AF289FECBB', 'aa21aec4-2117-402a-b7aa-7159b9b1c918', 692, 286, 'disponible', '2026-09-13 00:14:32.545112', NULL);
INSERT INTO public.unidadproducto VALUES (420, 2, 399, 1, 'C392J46FV2T', '351829440650071', '351829440650072', '8904903202367DE206EC4BBCA7330B05', '9b474048-d3f8-42b8-bfdd-8f6725699fd5', 695, 291, 'disponible', '2026-09-24 00:14:32.740425', NULL);
INSERT INTO public.unidadproducto VALUES (24, 1, 18, 1, 'SN-1790796071891', '3591790796071891', '3581790796071891', 'EID1790796071891', 'd1a60371-019e-4ab5-99b5-c7b0f8b0bf4f', NULL, NULL, 'disponible', '2026-09-30 19:21:11.974524', NULL);
INSERT INTO public.unidadproducto VALUES (421, 2, 400, 1, 'K4L2GXJ1HU2', '352941116218252', '352941116218253', '89049032029698E3B36A45C17FF134EE', '4186bac5-537f-4fba-b4b8-bfe004b3667d', 695, 288, 'disponible', '2026-09-18 00:14:32.747448', NULL);
INSERT INTO public.unidadproducto VALUES (422, 2, 401, 1, 'DX329EJAZTH', '351829442691113', '351829442691114', '8904903202849B3A47ED1640CA4B8601', '1c255d20-4765-492b-b05a-16b27ae0915a', 695, 291, 'disponible', '2026-09-21 00:14:32.752382', NULL);
INSERT INTO public.unidadproducto VALUES (426, 2, 405, 1, 'G6T208GU2EM', '358492107331687', '358492107331688', '8904903202DEC3CB78E127885C7DE6E7', 'e418ffa4-a314-41e3-962b-d14d111b4dc0', 695, 291, 'disponible', '2026-09-20 00:14:32.768507', NULL);
INSERT INTO public.unidadproducto VALUES (427, 2, 406, 1, 'J8K2FRU9SG8', '354019230223518', '354019230223519', '89049032023BB168636E9BDC605CDF6B', 'f8c487b1-c423-439c-8396-de7c119bfb9d', 695, 288, 'disponible', '2026-09-18 00:14:32.772935', NULL);
INSERT INTO public.unidadproducto VALUES (428, 2, 407, 1, 'J8K27E0BPD5', '354019239959569', '354019239959560', '890490320216D24575E4F6D7B0F31F00', '85781d61-c1d0-49a7-bfd0-6255da8fa9d6', 695, 291, 'disponible', '2026-09-18 00:14:32.779466', NULL);
INSERT INTO public.unidadproducto VALUES (33, 1, 29, 1, 'SN-1790797008887', '3591790797008887', '3581790797008887', 'EID1790797008887', '1b20c06b-9e22-4d66-9322-67cd9ae2125e', NULL, NULL, 'disponible', '2026-09-30 19:36:48.976788', NULL);
INSERT INTO public.unidadproducto VALUES (429, 2, 408, 1, 'C392UM8G3YF', '359812087167180', '359812087167181', '8904903202F104AF6B1BA1CD91FC5658', 'bb621b04-0dd2-4f42-87ee-98763836d67d', 695, 288, 'disponible', '2026-09-15 00:14:32.779466', NULL);
INSERT INTO public.unidadproducto VALUES (430, 2, 409, 1, 'F172UT3YMUQ', '354019231566971', '354019231566972', '89049032027D953E47C9A57575449E88', '74f6e222-b9af-45e2-a15e-00586504cf45', 695, 291, 'disponible', '2026-09-19 00:14:32.788812', NULL);
INSERT INTO public.unidadproducto VALUES (432, 2, 411, 1, 'F2L20J9ZJP4', '354019231024393', '354019231024394', '89049032024D1179A2CF138699C6E496', '0ccf5663-7e01-4848-8d28-095fb1c665bd', 695, 291, 'disponible', '2026-09-24 00:14:32.799942', NULL);
INSERT INTO public.unidadproducto VALUES (433, 2, 412, 1, 'K4L2Y3RM828', '351829440045224', '351829440045225', '8904903202BB7AECAAE68AED124B941B', '6587b6c9-4026-4c61-8b5a-00fdafcacaa1', 696, 288, 'en_transito', '2026-09-13 00:14:32.807078', NULL);
INSERT INTO public.unidadproducto VALUES (434, 2, 413, 1, 'F2L2HG21EA8', '352941112685075', '352941112685076', '8904903202D9C2874F6DF7651267A6C0', 'ee7006e3-7ee0-444d-b6e2-6ef9d268fe14', 696, 288, 'en_transito', '2026-09-23 00:14:32.812137', NULL);
INSERT INTO public.unidadproducto VALUES (435, 2, 414, 1, 'DX3283SVU0V', '354019234137676', '354019234137677', '890490320238E7B1F932881FE71D7B84', '9be76531-11ee-4aa5-9a68-55484a2df433', 696, 288, 'en_transito', '2026-09-10 00:14:32.819604', NULL);
INSERT INTO public.unidadproducto VALUES (436, 2, 415, 1, 'J8K28JDXHVV', '359812087837207', '359812087837208', '8904903202BD9AD775C6EDF36D657E6F', 'bccd5205-d5f6-4016-aff8-fbe2139749fd', 696, 288, 'en_transito', '2026-09-21 00:14:32.821631', NULL);
INSERT INTO public.unidadproducto VALUES (42, 1, 40, 1, 'SN-1790797109882', '3591790797109882', '3581790797109882', 'EID1790797109882', 'b716aba9-4003-4eda-9585-be63c86739a5', NULL, NULL, 'disponible', '2026-09-30 19:38:29.967459', NULL);
INSERT INTO public.unidadproducto VALUES (437, 2, 398, 1, 'J8K2Y4YB3U3', '354019230189078', '354019230189079', '890490320249615A8FAE7893A431FCB1', '2f645a54-da93-4105-a6ea-9fbceacb78d5', 696, 288, 'en_transito', '2026-09-20 00:14:32.830428', NULL);
INSERT INTO public.unidadproducto VALUES (439, 3, 399, 1, 'K4L3AP0UD0V', '352941119789721', '352941119789722', '8904903203C334CCA21A0C052E563CE5', '8397858a-0ef6-4e60-95db-f6680701b3f2', 698, 296, 'disponible', '2026-09-17 00:14:33.054606', NULL);
INSERT INTO public.unidadproducto VALUES (440, 3, 400, 1, 'G6T38UGTRB3', '352941111987992', '352941111987993', '8904903203C5C087AA9DF130E8E31DE4', '7939feda-6955-4241-9027-4f3a9583d4ca', 698, 293, 'disponible', '2026-09-12 00:14:33.061465', NULL);
INSERT INTO public.unidadproducto VALUES (419, 2, 398, 1, 'DX32EH47BL7', '358492100700030', '358492100700031', '89049032028478BE93761A56D0AA0BC1', 'd0513676-8075-47cd-8966-20b8d84ff44e', 695, 288, 'disponible', '2026-09-08 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (438, 3, 398, 1, 'F2L3W1T9C4J', '351829446116360', '351829446116361', '8904903203793A7AE7481FF4FB74FD16', '274b7f8b-4cd4-472e-9e26-91f7638e5d09', 698, 293, 'disponible', '2026-09-06 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (51, 1, 51, 1, 'SN-1790797141219', '3591790797141219', '3581790797141219', 'EID1790797141219', '05a77a15-9787-4b85-8ba3-84419ab61096', NULL, NULL, 'disponible', '2026-09-30 19:39:01.288824', NULL);
INSERT INTO public.unidadproducto VALUES (60, 1, 62, 1, 'SN-1790797169105', '3591790797169105', '3581790797169105', 'EID1790797169105', 'b9e9b568-6a58-4ff3-89ab-30762dcfc58c', NULL, NULL, 'disponible', '2026-09-30 19:39:29.187874', NULL);
INSERT INTO public.unidadproducto VALUES (78, 1, 84, 1, 'SN-1790797451638', '3591790797451638', '3581790797451638', 'EID1790797451638', '9f884ca8-8d9a-468d-9c7e-f5035199042b', NULL, NULL, 'disponible', '2026-09-30 19:44:11.738681', NULL);
INSERT INTO public.unidadproducto VALUES (87, 1, 95, 1, 'SN-1790797569880', '3591790797569880', '3581790797569880', 'EID1790797569880', '754dc4f4-23ee-4d4a-bc70-b24a970ca778', NULL, NULL, 'disponible', '2026-09-30 19:46:09.999997', NULL);
INSERT INTO public.unidadproducto VALUES (96, 1, 106, 1, 'SN-1790797598956', '3591790797598956', '3581790797598956', 'EID1790797598956', '20217fe9-4626-49f3-9adf-fff969bd0498', NULL, NULL, 'disponible', '2026-09-30 19:46:39.055394', NULL);
INSERT INTO public.unidadproducto VALUES (105, 1, 117, 1, 'SN-1790799357995', '3591790799357995', '3581790799357995', 'EID1790799357995', 'ee948c6d-1e0c-4cca-8d5d-df76c655b1a5', NULL, NULL, 'disponible', '2026-09-30 20:15:58.088705', NULL);
INSERT INTO public.unidadproducto VALUES (114, 1, 144, 1, 'SN-1790799757077', '3591790799757077', '3581790799757077', 'EID1790799757077', '87246f6a-a422-4aff-9065-9202743b4dfd', NULL, NULL, 'disponible', '2026-09-30 20:22:37.172804', NULL);
INSERT INTO public.unidadproducto VALUES (441, 3, 401, 1, 'DNP34YAG3W4', '354019233965573', '354019233965574', '8904903203EAD9F4B3735F5EA04FFD13', '1f895c8e-e63f-4030-afe8-c2e21e879a0a', 698, 296, 'disponible', '2026-09-25 00:14:33.065505', NULL);
INSERT INTO public.unidadproducto VALUES (69, 1, 73, 1, 'SN-1790797397033', '3591790797397033', '3581790797397033', 'EID1790797397033', '2ee43dca-3c5d-4d8c-99bc-013c390df1c7', NULL, NULL, 'disponible', '2026-09-30 19:43:17.121391', NULL);
INSERT INTO public.unidadproducto VALUES (123, 1, 155, 1, 'SN-1790800252489', '3591790800252489', '3581790800252489', 'EID1790800252489', '0ba86f52-c2c4-469e-913a-9e82b00028eb', NULL, NULL, 'disponible', '2026-09-30 20:30:52.572705', NULL);
INSERT INTO public.unidadproducto VALUES (445, 3, 405, 1, 'F1736PAB0VK', '354019230790537', '354019230790538', '89049032037245F9E2C0176963851A98', 'eac17b26-3c3c-42d8-ac4c-faa775367c92', 698, 296, 'disponible', '2026-09-16 00:14:33.085285', NULL);
INSERT INTO public.unidadproducto VALUES (446, 3, 406, 1, 'F1737Z16YSR', '359812083071378', '359812083071379', '89049032038DC1D00ED99B6105C9DE1D', 'b3916556-3016-4a56-b670-48d139d70779', 698, 293, 'disponible', '2026-09-18 00:14:33.092353', NULL);
INSERT INTO public.unidadproducto VALUES (447, 3, 407, 1, 'H023LHDABB5', '351829446517399', '351829446517390', '8904903203A21422C1FA799AEAF5F577', '0e6bd6d2-274d-4da7-a3a4-56eef0ec710f', 698, 296, 'disponible', '2026-09-16 00:14:33.09842', NULL);
INSERT INTO public.unidadproducto VALUES (448, 3, 408, 1, 'F2L3LB2F1C9', '352941116545780', '352941116545781', '89049032037CA57201E5B82377825465', '7dcc09ff-b042-4251-87e8-efa407b5a7e0', 698, 293, 'disponible', '2026-09-24 00:14:33.104487', NULL);
INSERT INTO public.unidadproducto VALUES (449, 3, 409, 1, 'DX3323P9QNW', '358492103513961', '358492103513962', '890490320369F46CDADBA8A65523F732', '518cb9b3-901e-41f1-8835-a935c4b9773b', 698, 296, 'disponible', '2026-09-23 00:14:33.110044', NULL);
INSERT INTO public.unidadproducto VALUES (451, 3, 411, 1, 'K4L348MVJ3U', '352941112729143', '352941112729144', '8904903203F3750083F50EDAC24DB2B7', '188f6f4b-2db5-4ded-ac95-207dc4a2a3f1', 698, 296, 'disponible', '2026-09-25 00:14:33.120514', NULL);
INSERT INTO public.unidadproducto VALUES (452, 3, 412, 1, 'DNP3075XLES', '358492103047414', '358492103047415', '8904903203E908326936A1F188F867AF', 'b74319e0-6325-4225-a0cb-77ba3d8c13ce', 699, 293, 'en_transito', '2026-09-17 00:14:33.125807', NULL);
INSERT INTO public.unidadproducto VALUES (453, 3, 413, 1, 'F173C28N3KR', '358492100581745', '358492100581746', '8904903203BAC1C74030E8F84C35CD51', 'd4034b63-b991-48ae-a74a-10dcc7a60ed0', 699, 293, 'en_transito', '2026-09-14 00:14:33.131397', NULL);
INSERT INTO public.unidadproducto VALUES (454, 3, 414, 1, 'H023WRWDZGG', '351829442044916', '351829442044917', '890490320341547B277BE96AC0A68B20', '27d8be62-f48e-4eab-9cf7-1db027efd033', 699, 293, 'en_transito', '2026-09-11 00:14:33.136468', NULL);
INSERT INTO public.unidadproducto VALUES (455, 3, 415, 1, 'F17348MCY15', '354019239375537', '354019239375538', '8904903203A31B768447F4E71D7E71AD', '96ac2065-e038-4469-b8f5-68ec1294f5ef', 699, 293, 'en_transito', '2026-09-15 00:14:33.142571', NULL);
INSERT INTO public.unidadproducto VALUES (456, 3, 398, 1, 'DX33QJ9A5QP', '358492107512178', '358492107512179', '8904903203085C8914FB8CD1FA7A5ECA', '82303628-d2ae-45e6-9ba2-a9f9e9d7b887', 699, 293, 'en_transito', '2026-09-20 00:14:33.147062', NULL);
INSERT INTO public.unidadproducto VALUES (458, 4, 399, 1, 'M0349YGTPA2', '352941111443181', '352941111443182', '89049032045F56C8131720FD6FEDEB32', 'ed4e7c67-80cc-4fe8-b79b-c82ff74d585c', 701, 301, 'disponible', '2026-09-11 00:14:33.273766', NULL);
INSERT INTO public.unidadproducto VALUES (138, 1, 169, 1, 'SN-1790800876457', '3591790800876457', '3581790800876457', 'EID1790800876457', '6b5e1c87-ac9d-4778-a46a-ef8df8eca2bb', NULL, NULL, 'disponible', '2026-09-30 20:41:16.55764', NULL);
INSERT INTO public.unidadproducto VALUES (459, 4, 400, 1, 'J8K4VG3DF8K', '352941110486452', '352941110486453', '8904903204D6EBC5693818C4FA1F6C5F', '60a12d32-15dd-4d97-9440-16a529caeeb6', 701, 298, 'disponible', '2026-09-21 00:14:33.280088', NULL);
INSERT INTO public.unidadproducto VALUES (460, 4, 401, 1, 'C394LD11QTH', '358492106536193', '358492106536194', '8904903204B45D8B4D5AF9CBB07FCC9B', '3552ce39-2d2c-481d-b8ad-53df1ecd19e2', 701, 301, 'disponible', '2026-09-10 00:14:33.284084', NULL);
INSERT INTO public.unidadproducto VALUES (464, 4, 405, 1, 'F2L4FMHW4H9', '352941113767037', '352941113767038', '89049032044A39A66561F7E067459945', 'c920439a-9a6c-4c46-aabf-659d58835efe', 701, 301, 'disponible', '2026-09-18 00:14:33.309138', NULL);
INSERT INTO public.unidadproducto VALUES (465, 4, 406, 1, 'F174NF5PXWS', '352941116932948', '352941116932949', '89049032047F5BECCDCA9C885E1DE382', 'b284614a-e1d7-4923-95a5-2150bf06e099', 701, 298, 'disponible', '2026-09-11 00:14:33.315534', NULL);
INSERT INTO public.unidadproducto VALUES (466, 4, 407, 1, 'DNP4PQGWF14', '354019234048739', '354019234048730', '8904903204DB9051FE1E06CCFA6F6DE6', '883af6e5-45ce-4192-b0ec-5ea55da8a9e0', 701, 301, 'disponible', '2026-09-21 00:14:33.321611', NULL);
INSERT INTO public.unidadproducto VALUES (467, 4, 408, 1, 'DX344ZD4ZUR', '359812084743240', '359812084743241', '890490320423EC0A9EE3197AD3078CC2', '59aeca31-ce4e-4c62-bfa6-756610767329', 701, 298, 'disponible', '2026-09-16 00:14:33.325764', NULL);
INSERT INTO public.unidadproducto VALUES (468, 4, 409, 1, 'C394TQALNAA', '358492109542551', '358492109542552', '8904903204B2A805A68B642833D27066', '441be1d0-4c43-4304-8650-9e4530dd58de', 701, 301, 'disponible', '2026-09-21 00:14:33.331842', NULL);
INSERT INTO public.unidadproducto VALUES (470, 4, 411, 1, 'M034WFTQRA6', '359812084521293', '359812084521294', '890490320496256D7AA4DFA72C2B7E8A', '841de51e-8ae8-4d13-b8a6-53a8e6153ea8', 701, 301, 'disponible', '2026-09-24 00:14:33.344', NULL);
INSERT INTO public.unidadproducto VALUES (471, 4, 412, 1, 'M0341UYNREU', '358492100124064', '358492100124065', '8904903204EEA0860B848B6F2E83945C', 'd4679ac0-1e40-45a5-ae14-fabda6d203a7', 702, 298, 'en_transito', '2026-09-23 00:14:33.348052', NULL);
INSERT INTO public.unidadproducto VALUES (472, 4, 413, 1, 'DX34YF8PAU2', '352941110350015', '352941110350016', '890490320476C9D1803DE701EE90E5F9', 'f9d04afe-d8f5-4de9-aec4-cfbeaafdba8c', 702, 298, 'en_transito', '2026-09-13 00:14:33.354116', NULL);
INSERT INTO public.unidadproducto VALUES (473, 4, 414, 1, 'DNP4AKKUPJD', '358492107607306', '358492107607307', '890490320431999F5AC7386296C43146', '79ef9b5f-c9f6-4981-b2b0-484ad61df51a', 702, 298, 'en_transito', '2026-09-21 00:14:33.361024', NULL);
INSERT INTO public.unidadproducto VALUES (474, 4, 415, 1, 'H024A30AC94', '358492104551057', '358492104551058', '89049032049CD06CB8F38A2442244C5F', '14ef3385-3bb3-494a-9ba4-c5c0f126ae44', 702, 298, 'en_transito', '2026-09-10 00:14:33.365908', NULL);
INSERT INTO public.unidadproducto VALUES (475, 4, 398, 1, 'K4L4LF40DUC', '359812084486538', '359812084486539', '89049032049B7265BAFC54C5E3F2C0BF', '3ced0f13-f61c-495e-9de5-896948a3eb85', 702, 298, 'en_transito', '2026-09-19 00:14:33.369965', NULL);
INSERT INTO public.unidadproducto VALUES (457, 4, 398, 1, 'G6T4EW1455A', '358492103988260', '358492103988261', '8904903204824882F2AB9D9D00A9AC6A', 'd34202c6-49af-4a3f-946b-c537c97a1931', 701, 298, 'disponible', '2026-09-15 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (463, 4, 404, 1, 'DNP4EQ3S0JX', '354019236846726', '354019236846727', '890490320440CA3BD0E6DE0DC2BD4049', '24d98d92-f870-4c3b-97ea-c0c7e98fbdb3', 701, 298, 'disponible', '2026-09-06 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (469, 4, 410, 1, 'H02486MXU3Q', '358492100360082', '358492100360083', '89049032049A33E4E33BBCEBB63547A4', '3aef1067-5dca-4478-b515-2f2e6d6112e6', 701, 298, 'disponible', '2026-09-06 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (462, 4, 403, 1, 'C394YZSPPGG', '351829449721635', '351829449721636', '8904903204FDFC44B574738EB2993A8A', '06c19ec7-a45e-4bf2-9ad6-df24fa7d2d2b', 701, 301, 'disponible', '2026-09-06 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (476, 5, 398, 1, 'F2L5U2UTN4A', '359812086770940', '359812086770941', '890490320568EB8C5E8A1CA5A0FA6CF6', 'dd1e6cf4-6c5c-445f-9199-585396a05350', 704, 303, 'disponible', '2026-09-07 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (477, 5, 399, 1, 'DNP58HHKKFD', '351829446194291', '351829446194292', '89049032051DB55C851B710B051CEB88', 'd3bce725-8350-4ee6-8e81-910c88787915', 704, 306, 'disponible', '2026-09-15 00:14:33.536389', NULL);
INSERT INTO public.unidadproducto VALUES (478, 5, 400, 1, 'M035EFTM6ND', '351829448440222', '351829448440223', '8904903205BC9C8531A7F5661572ACE9', 'ac2cd414-19bb-471a-9b2c-d0e7627a88bb', 704, 303, 'disponible', '2026-09-21 00:14:33.542501', NULL);
INSERT INTO public.unidadproducto VALUES (479, 5, 401, 1, 'DX354A6PHE4', '354019234459913', '354019234459914', '8904903205242D9DF7368A67B729C303', '6c1c9668-35be-4033-bb57-c27257cdab9d', 704, 306, 'disponible', '2026-09-16 00:14:33.548591', NULL);
INSERT INTO public.unidadproducto VALUES (483, 5, 405, 1, 'DX358CW5DAP', '358492104002057', '358492104002058', '890490320587051DB731C1546DDAA199', '140888e5-818e-47a6-8f8c-55be500171d8', 704, 306, 'disponible', '2026-09-20 00:14:33.569638', NULL);
INSERT INTO public.unidadproducto VALUES (484, 5, 406, 1, 'J8K5B7RXLF7', '352941111173478', '352941111173479', '89049032053A39B4F0DE3936ACC363A1', '45991dcb-8547-4fe8-a39b-a0a72550a5cc', 704, 303, 'disponible', '2026-09-25 00:14:33.57358', NULL);
INSERT INTO public.unidadproducto VALUES (485, 5, 407, 1, 'DX35X4VKCPR', '352941110020079', '352941110020070', '89049032058A86B1894483C86ADA1BBD', '400b3d0c-2067-4bee-8952-3f92108f9b8c', 704, 306, 'disponible', '2026-09-24 00:14:33.577039', NULL);
INSERT INTO public.unidadproducto VALUES (486, 5, 408, 1, 'C3952EFLARR', '352941110104350', '352941110104351', '8904903205D45BDB1E5684FA780D22CE', 'c44aee53-cbfe-41ec-b1fa-52b2271c2324', 704, 303, 'disponible', '2026-09-22 00:14:33.581557', NULL);
INSERT INTO public.unidadproducto VALUES (487, 5, 409, 1, 'C395R0V01CX', '358492109859741', '358492109859742', '890490320556B4158E2CFF174D580394', 'bccd4e7d-7d2a-44e4-9e55-48dd4a533b08', 704, 306, 'disponible', '2026-09-18 00:14:33.585096', NULL);
INSERT INTO public.unidadproducto VALUES (489, 5, 411, 1, 'DNP5L2N49UX', '354019237732023', '354019237732024', '8904903205C922768F34412ADB0D5135', '6381c6fe-56b7-48f4-9bc9-bbd99094aef6', 704, 306, 'disponible', '2026-09-24 00:14:33.594082', NULL);
INSERT INTO public.unidadproducto VALUES (490, 5, 412, 1, 'F2L58Z1DFR8', '354019231710724', '354019231710725', '890490320536AF19E1F3AC1DC1F0E6B7', '2b9aff93-4c4b-41f9-9952-e10beddf5337', 705, 303, 'en_transito', '2026-09-13 00:14:33.594082', NULL);
INSERT INTO public.unidadproducto VALUES (491, 5, 413, 1, 'H0255769W1M', '358492106484035', '358492106484036', '89049032056AC3F806B7C5954090C4C7', '91ea88ea-3d84-434b-94d1-b78cf1d0f9d6', 705, 303, 'en_transito', '2026-09-14 00:14:33.594082', NULL);
INSERT INTO public.unidadproducto VALUES (492, 5, 414, 1, 'K4L5ZZ3N9TX', '352941117959396', '352941117959397', '8904903205F235B59B592FDCF8200907', '3e9f1b18-da80-4b57-bada-0cac91b72e1c', 705, 303, 'en_transito', '2026-09-15 00:14:33.604378', NULL);
INSERT INTO public.unidadproducto VALUES (493, 5, 415, 1, 'K4L564QXUB0', '351829447115307', '351829447115308', '8904903205BA955FB6A75B8E95AD6B42', '5b1124db-220d-47ac-89c1-d08a8f168b53', 705, 303, 'en_transito', '2026-09-25 00:14:33.611108', NULL);
INSERT INTO public.unidadproducto VALUES (494, 5, 398, 1, 'K4L5DZY1LXY', '358492106143038', '358492106143039', '89049032055AFDAB503B5CB07626E56D', '7f4df001-b482-43df-8c18-b4010d2e2655', 705, 303, 'en_transito', '2026-09-18 00:14:33.61425', NULL);
INSERT INTO public.unidadproducto VALUES (482, 5, 404, 1, 'K4L50SQQFNC', '352941117398436', '352941117398437', '8904903205482DCEC0AD0E27F6FEE4DE', '7473935b-b007-4c59-b4ea-c438a88ee162', 704, 303, 'disponible', '2026-09-18 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (488, 5, 410, 1, 'J8K5CZZSQJT', '358492100423882', '358492100423883', '8904903205F0ADB18370FB1EE8B5F112', '0ba4eeab-3f66-4d1d-bf91-2f3cec680af8', 704, 303, 'disponible', '2026-09-20 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (481, 5, 403, 1, 'K4L5B9JBP99', '351829449609795', '351829449609796', '8904903205FD2D3BDCA79467AE184E5F', '752fe763-483d-4eb2-bb9a-ddcdc3294134', 704, 306, 'disponible', '2026-09-09 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (480, 5, 402, 1, 'G6T5SKSGHK9', '351829448380754', '351829448380755', '8904903205F1DC4F75D7FC3C95BA2233', '1847b207-9863-43ef-98c3-748014b18160', 704, 303, 'disponible', '2026-09-06 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3173, 1, 398, 100, 'F171V98EAUHUBZ', '358492103413150', '358492103413151', '890490320169FFA2EDCEA75EFAB5F6F4', '079abde4-35aa-4380-ae05-2e4c1a8c9877', 2, 2, 'vendido', '2026-09-10 21:10:55.388878', '2026-09-25 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3174, 1, 398, 100, 'M031V983A9Q16F', '359812085805941', '359812085805942', '89049032010431263A0B9D2CB1B12429', 'ae2023e6-76ca-4b4d-abef-bf26a08f2e0c', 2, 2, 'vendido', '2026-09-10 19:10:55.388878', '2026-09-25 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3175, 1, 398, 100, 'F171V98JP3C5CB', '358492108238082', '358492108238083', '89049032019BA2EDFA165AA796BA8E6C', 'cd533611-fa5e-4549-9afb-57419810b635', 2, 2, 'vendido', '2026-09-10 17:10:55.388878', '2026-09-25 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (415, 1, 398, 1, 'DNP1097RPW2', '354019230026570', '354019230026571', '8904903201B674DC2643C16554071E14', 'b2eb5722-91ed-405e-9f6b-b2fd6e3d0283', 692, 283, 'disponible', '2026-09-05 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3176, 1, 398, 100, 'F171S98Y7CUUYM', '351829441981851', '351829441981852', '8904903201BB025905BC0FB9B91A3633', '14c8b571-482b-493d-b91f-1507dba2e138', 692, 1, 'disponible', '2026-09-05 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3177, 1, 413, 101, 'C391V13H5FWCMM', '354019231387260', '354019231387261', '8904903201E3317E29387C49E9791AD7', '4aa5c55b-62fa-4c03-a05b-6a934cdcb921', 2, 2, 'vendido', '2026-09-15 21:10:55.388878', '2026-09-30 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3178, 1, 413, 101, 'G6T1V13QPL9VWG', '352941114258461', '352941114258462', '8904903201038B6DF5D4C9784795689C', '6d7c1ffb-1fe0-45ac-a929-f9446ee4c3b8', 2, 2, 'vendido', '2026-09-15 19:10:55.388878', '2026-09-30 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3179, 1, 413, 101, 'K4L1V13UJ6YC19', '354019239687242', '354019239687243', '890490320154D3F3046AD1FF2E81CDB3', 'bcabd763-41c8-4bc9-ae96-cebc6c87c5e9', 2, 2, 'vendido', '2026-09-15 17:10:55.388878', '2026-09-30 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3180, 1, 413, 101, 'C391V13QGN7MAC', '352941112773033', '352941112773034', '8904903201D104121C6D130EC37646DD', 'e15472d8-e3f0-4912-96d4-1f3c1fb35e34', 2, 2, 'vendido', '2026-09-15 15:10:55.388878', '2026-09-30 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3181, 1, 413, 101, 'G6T1V13K07B7F1', '352941114604644', '352941114604645', '890490320168E13DB60AEC255C7F4243', 'c9cab9fc-1ffe-491d-b3e0-078c324ddce6', 2, 2, 'vendido', '2026-09-15 13:10:55.388878', '2026-09-30 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3182, 1, 413, 101, 'F171V136AJ90GP', '358492107923165', '358492107923166', '8904903201D49A3F009B8EBDD581E04E', 'bce6042d-2e1d-4dca-afe6-7922d702fe97', 2, 2, 'vendido', '2026-09-15 11:10:55.388878', '2026-09-30 11:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3183, 1, 413, 101, 'H021V139Q49PXB', '359812080589776', '359812080589777', '890490320119A34E8FEC7624F8630740', 'ffdfd496-5e6e-43b7-9d42-464fc9cf4969', 2, 2, 'vendido', '2026-09-15 09:10:55.388878', '2026-09-30 09:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3184, 1, 413, 101, 'F171V13TZ0H5F6', '351829444866577', '351829444866578', '8904903201ECFCC8B15E66167AB1B132', '43b9d575-e290-40a4-aa4d-36d2e3443dd1', 2, 2, 'vendido', '2026-09-15 07:10:55.388878', '2026-09-30 07:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3185, 1, 413, 101, 'H021S134PDRQM9', '359812085417320', '359812085417321', '89049032015B167FCA4F698EE20D10E0', '1059a656-0aa0-48ef-b229-535135497fcd', 692, 1, 'disponible', '2026-09-13 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3186, 1, 413, 101, 'F2L1S1300HTWYE', '359812081724641', '359812081724642', '89049032019639D339110C5E426F26D8', 'dca5e44f-54af-4137-b856-7d8127cc3a8f', 692, 1, 'disponible', '2026-09-14 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3187, 1, 413, 101, 'H021S1339XFRZZ', '351829440646602', '351829440646603', '89049032014BA8E5E132A5DB23C3579B', '726613b3-da87-409d-b5ea-296696053b03', 692, 1, 'disponible', '2026-09-16 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3188, 1, 413, 101, 'H021S13X4TX848', '352941110113683', '352941110113684', '8904903201B68E25C243DA199DDCFC4F', '2d149faa-2ca4-4e62-af1b-b7e78d718473', 692, 1, 'disponible', '2026-09-09 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3189, 1, 414, 102, 'F2L1V14TUQA7TZ', '352941117546660', '352941117546661', '8904903201A3E842657904BCCEDA4656', '8197e87c-9d6c-403f-b7a7-bfcdc5ef8002', 2, 2, 'vendido', '2026-09-17 21:10:55.388878', '2026-10-02 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3190, 1, 414, 102, 'DNP1V14NP78MNU', '351829444130721', '351829444130722', '8904903201A95BE236C13A58EFDE3558', '95093806-f6e1-4d6d-8712-25dc46e802ab', 2, 2, 'vendido', '2026-09-17 19:10:55.388878', '2026-10-02 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3191, 1, 414, 102, 'H021V14ZD1RDRL', '352941110355082', '352941110355083', '89049032019F17D1CDC2E1B4C76E899C', 'b38c528d-a0ec-4c46-a1a4-0b3b32622be2', 2, 2, 'vendido', '2026-09-17 17:10:55.388878', '2026-10-02 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3192, 1, 414, 102, 'G6T1V146KHQKVD', '351829441887583', '351829441887584', '89049032017EB29351655E666A843BD7', '6be5276c-29d8-41df-961f-0d1a40b2725c', 2, 2, 'vendido', '2026-09-17 15:10:55.388878', '2026-10-02 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3193, 1, 414, 102, 'J8K1V14V7NS401', '354019235720604', '354019235720605', '890490320127581582673779F32D5115', '8adba65b-3da2-4302-b284-ce7ec718addd', 2, 2, 'vendido', '2026-09-17 13:10:55.388878', '2026-10-02 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3194, 1, 414, 102, 'F2L1V14HA6E0Z4', '352941115928555', '352941115928556', '8904903201A23B1A97EAC5DFF40BFD0C', 'ff97864d-1885-496e-9122-47c4391430bc', 2, 2, 'vendido', '2026-09-17 11:10:55.388878', '2026-10-02 11:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3195, 1, 414, 102, 'F171V14Y8RU71L', '358492102248566', '358492102248567', '8904903201717DC3A369C3FB11A1AC53', '295f2bbe-872d-4966-a192-bdd5911a7bbf', 2, 2, 'vendido', '2026-09-17 09:10:55.388878', '2026-10-02 09:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3196, 1, 414, 102, 'DX31V14ETWMUNL', '358492102678107', '358492102678108', '8904903201940ED6E6269CE45DE0A11C', 'f3e629d8-a551-4fd3-8c29-5edb2918eeca', 2, 2, 'vendido', '2026-09-17 07:10:55.388878', '2026-10-02 07:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3197, 1, 414, 102, 'G6T1V14NRGGTWE', '359812088421478', '359812088421479', '8904903201D18BE88B4BF54A01AD2A74', '2d38c686-f258-4a17-be14-ba76749b0adf', 2, 2, 'vendido', '2026-09-17 05:10:55.388878', '2026-10-02 05:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3198, 1, 414, 102, 'DNP1S14UEDEM8V', '354019235740190', '354019235740191', '89049032011519372BD9DED35DE9E83B', '89b647d9-30b4-4084-8ba8-75e1b9b98c19', 692, 1, 'disponible', '2026-09-05 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3199, 1, 404, 103, 'DX31V04RC9GATQ', '351829443887320', '351829443887321', '89049032019B792897EA3C134783E273', 'e30309b0-4d5b-4d4a-9045-1074db2056d4', 2, 2, 'vendido', '2026-08-06 21:10:55.388878', '2026-08-21 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3200, 1, 404, 103, 'C391V043C8XJ6M', '352941119145061', '352941119145062', '89049032018C418D7F50F77DB8C447E7', '52d60d4b-5bf1-4451-ad14-1ce34ee81fe5', 2, 2, 'vendido', '2026-08-06 19:10:55.388878', '2026-08-21 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3201, 1, 404, 103, 'M031V04EV3GGF2', '351829447376642', '351829447376643', '8904903201AD25600DCD4142A3CF0911', '6b7d626d-aa55-4036-9ffe-a77edd8901b9', 2, 2, 'vendido', '2026-08-06 17:10:55.388878', '2026-08-21 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3202, 1, 404, 103, 'M031V04Z1MUMR4', '354019235811893', '354019235811894', '8904903201D8E89201054E4553096267', 'eb45d217-79a7-440f-a07b-c73d48e65a2c', 2, 2, 'vendido', '2026-08-06 15:10:55.388878', '2026-08-21 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3203, 1, 404, 103, 'DNP1V04AFC8CBB', '352941118507674', '352941118507675', '89049032017EA7CFABB409E32D2EE254', '4b1036de-e770-440b-8dd4-4ab459a30fd4', 2, 2, 'vendido', '2026-08-06 13:10:55.388878', '2026-08-21 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3204, 1, 404, 103, 'C391D04ELFJT33', '352941111577280', '352941111577281', '8904903201B16CAA1604CAF6AA904A83', 'fc490e61-2bdd-4d95-b832-d9443018bfe2', 2, 2, 'devuelto', '2026-08-11 21:10:55.388878', '2026-08-26 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3205, 1, 404, 103, 'DNP1D0456P3DMZ', '354019236244881', '354019236244882', '89049032011A2408D09BAE466588E151', 'cfeb851b-1937-44bd-8771-2aa55cced68f', 2, 2, 'devuelto', '2026-08-11 19:10:55.388878', '2026-08-26 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3206, 1, 404, 103, 'H021S048DSPWAW', '354019236572810', '354019236572811', '8904903201B48A35C02410D75C277937', '78a6891a-ece8-47a9-aab6-1c447f9dae48', 692, 1, 'disponible', '2026-09-10 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3207, 1, 404, 103, 'G6T1S04FM329DP', '351829445435491', '351829445435492', '8904903201CE0C9BB32E4A4C3031A96E', '692de0e7-929c-484d-a26e-9b68e8162c58', 692, 1, 'disponible', '2026-09-18 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3208, 1, 404, 103, 'K4L1S04HCNTJZ6', '351829440183902', '351829440183903', '89049032015932586E9F83E55ABBB8FF', '43908631-a1a5-4ba0-873b-7695fbdf26d6', 692, 1, 'disponible', '2026-09-16 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3209, 1, 410, 104, 'G6T1S10DMCKPBG', '359812083448620', '359812083448621', '89049032015CDCCAD5EA51B13C427DAF', 'fea181c3-cfff-4d26-8c20-e063521fe77c', 692, 1, 'disponible', '2026-09-19 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3210, 1, 415, 105, 'DX31S159T68FQD', '358492103335430', '358492103335431', '8904903201CED145E8657A2691CC8725', '14e97634-9c1c-4b98-b40f-3d9986304e3d', 692, 1, 'disponible', '2026-09-14 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3211, 1, 415, 105, 'J8K1S15E6XJQD4', '351829447457681', '351829447457682', '8904903201C1B4A83D7CB2B70EC7E0C1', '5c24c87b-418a-4d29-be95-6d5974ff235a', 692, 1, 'disponible', '2026-09-13 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3212, 1, 415, 105, 'F171S1524ZP73X', '358492102454472', '358492102454473', '890490320112F5500949DE861CA16FD4', '70ff42b6-516c-4087-b78e-cbf971a1d09b', 692, 1, 'disponible', '2026-09-17 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3213, 1, 415, 105, 'C391S15748BC7Q', '351829440275553', '351829440275554', '890490320144828949D49BBEEDDC822C', 'cbb1b59d-9cc9-4cfe-9ba1-c67e1433dfe0', 692, 1, 'disponible', '2026-09-14 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3214, 1, 415, 105, 'K4L1S15CNT2UD5', '359812083112234', '359812083112235', '890490320171D3269ADCFFAE16A8DB8B', 'c6bece16-dbc3-446e-9d3a-2b0b956de5ea', 692, 1, 'disponible', '2026-09-14 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3215, 1, 415, 105, 'H021S15TXL2X3V', '351829441108525', '351829441108526', '8904903201DF66498BF7EDFBA73087D5', 'db4362e7-a2be-49a0-9694-f17f8452608e', 692, 1, 'disponible', '2026-09-08 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3216, 1, 415, 105, 'G6T1S1562Q66A9', '358492107635546', '358492107635547', '89049032010C5D912C906D99EF934C99', 'f82e367d-dbdd-4079-a6ae-65c663770ef1', 692, 1, 'disponible', '2026-09-12 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3217, 1, 403, 106, 'J8K1V03YZ8UKK4', '351829449179020', '351829449179021', '8904903201C006DDBD6EF7BAD3DA78FE', '97affb52-cacc-4562-b5cd-af57c2abd0d4', 2, 2, 'vendido', '2026-07-07 21:10:55.388878', '2026-07-22 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3218, 1, 403, 106, 'DX31V03NDBQJB1', '358492109044431', '358492109044432', '8904903201AEC204D26BC461EF2DBB30', 'c20d5ca6-1b0a-4246-82cf-4aced008fffb', 2, 2, 'vendido', '2026-07-07 19:10:55.388878', '2026-07-22 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3219, 1, 403, 106, 'F171S03SMJXJXC', '354019238643820', '354019238643821', '89049032011D71C9B0159F821B3A248D', '9dd74ed0-b505-43de-a133-26a4ce1df3dd', 692, 1, 'disponible', '2026-09-06 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3220, 1, 403, 106, 'J8K1S037QGBEMW', '358492100120991', '358492100120992', '8904903201AB845EDBDFBB92D126C9E3', 'ef91af6c-9020-49fe-b43e-4e390fac41ff', 692, 1, 'disponible', '2026-09-20 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3221, 1, 403, 106, 'M031S036KGD91V', '351829444593272', '351829444593273', '8904903201975B911FCC765C2F67217F', 'd7bfeb10-cc7d-4638-a068-dbdb057a0aee', 692, 1, 'disponible', '2026-09-05 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3222, 1, 403, 106, 'DX31S031ZUTX1C', '358492108656953', '358492108656954', '8904903201D75BDF8DD7FAA261D17EC3', '3a38e805-3bd7-431c-a5f5-e4fecb88be9a', 692, 1, 'disponible', '2026-09-07 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3223, 1, 403, 106, 'DX31S0345WSHEL', '359812083014104', '359812083014105', '89049032015724FCBE8124E179E0FF0D', 'c6a50803-1d5f-4fe4-9197-cbb4e11a0f11', 692, 1, 'disponible', '2026-09-16 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3224, 1, 402, 107, 'F2L1V02JY3VTYX', '352941110503310', '352941110503311', '890490320125F14B9657DE69F7502D39', 'b54fb33b-08be-4aaa-9de5-c80eb2469b1b', 2, 2, 'vendido', '2026-09-16 21:10:55.388878', '2026-10-01 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3225, 1, 402, 107, 'J8K1V025ZYJSWX', '358492105671051', '358492105671052', '890490320135B4D9F0C6F7084F85F8DB', 'f6235e49-8b85-4ed7-8fb1-a91ebc43430e', 2, 2, 'vendido', '2026-09-16 19:10:55.388878', '2026-10-01 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3226, 1, 402, 107, 'H021V02SH5UXXB', '358492106758442', '358492106758443', '89049032014260A8A0D0EFF3ED197065', '4dce2b11-96a2-4249-b06f-58fc4c15ab5b', 2, 2, 'vendido', '2026-09-16 17:10:55.388878', '2026-10-01 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3227, 1, 402, 107, 'F171V02XD9UYFV', '354019230109633', '354019230109634', '890490320157C6873970BFCD24DAF3C8', 'bc317139-7a70-43f4-9942-61b4f022625d', 2, 2, 'vendido', '2026-09-16 15:10:55.388878', '2026-10-01 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3228, 1, 402, 107, 'F2L1V02WTB2ETL', '359812082757964', '359812082757965', '89049032012207205321534C67D9113B', '627eae45-31e8-4218-90c4-63774361daa3', 2, 2, 'vendido', '2026-09-16 13:10:55.388878', '2026-10-01 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3229, 1, 402, 107, 'J8K1V02BPBLL0J', '358492102154435', '358492102154436', '890490320142BAEA358C1A170E8769F3', '473868b2-f9d8-4f4b-bebe-66d4efe21f3b', 2, 2, 'vendido', '2026-09-16 11:10:55.388878', '2026-10-01 11:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3230, 1, 402, 107, 'C391V027CPM2YN', '358492102009456', '358492102009457', '8904903201965618BF4608319D1F7F52', '4ef740f0-11f5-4677-8ca4-786678910154', 2, 2, 'vendido', '2026-09-16 09:10:55.388878', '2026-10-01 09:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3231, 1, 402, 107, 'F171V0263XCNGW', '351829445158777', '351829445158778', '89049032017284A5832F105C6AB11D5B', 'a24ce2d8-3305-4c8e-95a2-03437823f60b', 2, 2, 'vendido', '2026-09-16 07:10:55.388878', '2026-10-01 07:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3232, 1, 402, 107, 'K4L1V02WBFN6BE', '352941112837678', '352941112837679', '890490320136CCA312C54F21B1522AD6', '0231527f-41f2-4d33-9fff-f4edf7ee4f19', 2, 2, 'vendido', '2026-09-16 05:10:55.388878', '2026-10-01 05:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3233, 1, 402, 107, 'F171V02LY6VVHC', '352941110504069', '352941110504060', '8904903201D5ED5C1B7B0C156AD3901D', '99414874-7b51-46d1-b51b-33ff2709f97c', 2, 2, 'vendido', '2026-09-16 03:10:55.388878', '2026-10-01 03:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3234, 1, 402, 107, 'K4L1V02461JLUV', '359812085275070', '359812085275071', '890490320113EF71CFD180A7E6E069B7', '61297cdb-7a5a-45ff-8bc5-9a5b448299a6', 2, 2, 'vendido', '2026-09-16 01:10:55.388878', '2026-10-01 01:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3235, 1, 402, 107, 'G6T1S0239CY79J', '352941115733150', '352941115733151', '89049032016783762689523006BB3166', '5c508b88-1560-49c8-8517-8ab0d0e50329', 692, 1, 'disponible', '2026-09-20 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3236, 2, 398, 108, 'K4L2V98RVPZJA8', '358492103122050', '358492103122051', '890490320213C819A57128C07BC977B4', '356824be-c6f5-44fe-8364-61f6f9322b2b', 4, 4, 'vendido', '2026-09-10 21:10:55.388878', '2026-09-25 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3237, 2, 398, 108, 'DNP2V981C6SBMX', '352941114198131', '352941114198132', '890490320211501A6168FBC4AACB68E0', '610eb8af-d8e7-4720-ae9c-3b678e12f0dd', 4, 4, 'vendido', '2026-09-10 19:10:55.388878', '2026-09-25 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3238, 2, 398, 108, 'C392V981TMKJ35', '352941116110642', '352941116110643', '8904903202B12C8840A0D6D573D13CC0', 'bc09a455-39dd-474b-a96c-7b60b0dbb007', 4, 4, 'vendido', '2026-09-10 17:10:55.388878', '2026-09-25 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3239, 2, 398, 108, 'DX32S98US1C3K3', '354019231855891', '354019231855892', '8904903202372703600B59E7AC0C497A', '8acadda6-866d-473f-a394-8d4e6f19065c', 695, 3, 'disponible', '2026-09-16 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3240, 2, 413, 109, 'M032V13JYWEJWG', '358492103887330', '358492103887331', '8904903202A96EBB3EDE76A6A937B57C', '08818b72-5e1d-49d8-a5f8-ce38cf594124', 4, 4, 'vendido', '2026-09-15 21:10:55.388878', '2026-09-30 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3241, 2, 413, 109, 'F172V1395RLQ3V', '354019236320421', '354019236320422', '8904903202EA6062655EE92E5BB3BCB7', '1e22157c-9008-49f3-8068-2a81b83bb8c9', 4, 4, 'vendido', '2026-09-15 19:10:55.388878', '2026-09-30 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3242, 2, 413, 109, 'DNP2V137ZHRVUY', '354019237555282', '354019237555283', '89049032023EA369F1F2D6728FCC91C2', '8f43441f-88fa-471c-9e3a-72ac0480d1f7', 4, 4, 'vendido', '2026-09-15 17:10:55.388878', '2026-09-30 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3243, 2, 413, 109, 'C392V13AB8QH1K', '358492102039303', '358492102039304', '890490320236D10582901E3AD25E4BB8', 'f29349ff-498a-4879-9196-569263e8ed5f', 4, 4, 'vendido', '2026-09-15 15:10:55.388878', '2026-09-30 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3244, 2, 413, 109, 'M032V13VCPN3S0', '351829445783794', '351829445783795', '89049032020AB66C795B1257CB23B894', '85f1cb1c-6387-4556-bbfc-54393a6d7ecb', 4, 4, 'vendido', '2026-09-15 13:10:55.388878', '2026-09-30 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3245, 2, 413, 109, 'K4L2V130HAWE4D', '351829444016985', '351829444016986', '8904903202DEC609443FE6E4657EAC1B', '1cadd783-db3a-4c0d-9449-a511b368e4ef', 4, 4, 'vendido', '2026-09-15 11:10:55.388878', '2026-09-30 11:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3246, 2, 413, 109, 'H022V132ENFRD4', '358492107884536', '358492107884537', '89049032020CF2A2719561D2F41FAD33', '7d2ef6ff-bc6f-490e-b3fc-a047c97eed01', 4, 4, 'vendido', '2026-09-15 09:10:55.388878', '2026-09-30 09:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3247, 2, 413, 109, 'H022V13TTXHBG2', '358492108915887', '358492108915888', '8904903202DBA6B55E6DE55272C23810', 'ef4ed367-1962-472c-bed4-d577f602f784', 4, 4, 'vendido', '2026-09-15 07:10:55.388878', '2026-09-30 07:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3248, 2, 413, 109, 'J8K2S13M9EDRT1', '352941116486010', '352941116486011', '89049032021296461F7FD4FD8CA55180', '99287e28-ba5b-4f0d-916b-c59c7d7c7357', 695, 3, 'disponible', '2026-09-15 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3249, 2, 413, 109, 'C392S138EN8HC7', '354019233246621', '354019233246622', '8904903202934F2DF88CD81177F4670E', '484cd5c3-bc4c-405e-afc6-d1f0da78cb3a', 695, 3, 'disponible', '2026-09-07 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3250, 2, 413, 109, 'F2L2S139Z7105G', '358492108380282', '358492108380283', '8904903202E85B04C56A05613AF87A12', 'e7d1d59d-a962-479e-98c5-6c8c16027111', 695, 3, 'disponible', '2026-09-12 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3251, 2, 413, 109, 'G6T2S138CM0F1M', '352941111067833', '352941111067834', '890490320282D393527347FBFF86308B', 'ce0473b8-0f6b-4373-b5c3-bd9b2ecb5773', 695, 3, 'disponible', '2026-09-16 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3252, 2, 414, 110, 'C392V1415H73CQ', '352941117193110', '352941117193111', '890490320228EABF8B2115016C9370CA', '32c541a9-945c-46ad-842d-bb6428968fb3', 4, 4, 'vendido', '2026-09-17 21:10:55.388878', '2026-10-02 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3253, 2, 414, 110, 'DX32V14C9NXNSU', '359812085716701', '359812085716702', '89049032022DF8C54ABE94101E5E69A3', '86ca9cdf-03db-4e8b-92ec-ab544ab6b363', 4, 4, 'vendido', '2026-09-17 19:10:55.388878', '2026-10-02 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3254, 2, 414, 110, 'M032V140LKYB1D', '358492100916792', '358492100916793', '8904903202E80A45F900C007DBDF67EA', '3c427b34-bdd1-40ca-9d6d-66d121cfadda', 4, 4, 'vendido', '2026-09-17 17:10:55.388878', '2026-10-02 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3255, 2, 414, 110, 'DX32V14D2ZRJEY', '354019235149743', '354019235149744', '890490320201B7B8321329669A54D3CA', '0a085dcf-b521-4feb-8dc6-a31ef2090fdb', 4, 4, 'vendido', '2026-09-17 15:10:55.388878', '2026-10-02 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3256, 2, 414, 110, 'G6T2V14HWNE05P', '354019237751624', '354019237751625', '89049032024D1DCC44EA69255A375B23', 'd82e2c2a-2c73-4c99-a420-cf20e28e1b5a', 4, 4, 'vendido', '2026-09-17 13:10:55.388878', '2026-10-02 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3257, 2, 414, 110, 'C392V142QY5A55', '359812081175855', '359812081175856', '89049032027D61F7541C70B01697497D', '9475b77a-ecfe-4060-8907-94ef3fdd2a98', 4, 4, 'vendido', '2026-09-17 11:10:55.388878', '2026-10-02 11:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3258, 2, 414, 110, 'M032V14SY2RP6Q', '352941115674146', '352941115674147', '89049032020C04EA003F0F17B263A15C', '31c405df-a713-4735-a212-1dd047929b1d', 4, 4, 'vendido', '2026-09-17 09:10:55.388878', '2026-10-02 09:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3259, 2, 414, 110, 'F172V145FQT5G9', '351829444351627', '351829444351628', '8904903202D3BCD95BD69535A11112E3', 'feed1afa-2f66-4690-8029-4c9ccf4d34da', 4, 4, 'vendido', '2026-09-17 07:10:55.388878', '2026-10-02 07:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3260, 2, 414, 110, 'DX32V14LL4ZREC', '351829448178758', '351829448178759', '8904903202D65D531DCC29805AE053F4', '1c288507-2b73-4232-b706-dde7d9ebd61c', 4, 4, 'vendido', '2026-09-17 05:10:55.388878', '2026-10-02 05:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3261, 2, 414, 110, 'DNP2S1472S5ZL2', '352941116747770', '352941116747771', '89049032026627BE91F815CF3B92A438', '5984d68f-6c5c-487b-9e94-bdade8b939a7', 695, 3, 'disponible', '2026-09-09 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3262, 2, 404, 111, 'K4L2V048WPXKJ0', '354019237229420', '354019237229421', '89049032020B90468EF9CCB5D45DDDEA', '9b334f8a-3911-4605-a56f-71fc83629994', 4, 4, 'vendido', '2026-08-06 21:10:55.388878', '2026-08-21 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3263, 2, 404, 111, 'DNP2V04FWY1L1L', '351829447051921', '351829447051922', '8904903202C54CB17E9D9EEFAC4E4EB2', 'e9fc519e-01c9-4a60-92f7-943565e776f9', 4, 4, 'vendido', '2026-08-06 19:10:55.388878', '2026-08-21 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3264, 2, 404, 111, 'J8K2V044X91HWT', '352941110316462', '352941110316463', '890490320276F8EED059F6121F92504A', '271a463f-046c-491f-bef0-5b661d68dff9', 4, 4, 'vendido', '2026-08-06 17:10:55.388878', '2026-08-21 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3265, 2, 404, 111, 'DNP2V043WAPW3K', '354019231467963', '354019231467964', '8904903202892A5952280BA967F096AC', '24f62914-e9e9-4f9f-bb1f-c576694612da', 4, 4, 'vendido', '2026-08-06 15:10:55.388878', '2026-08-21 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3266, 2, 404, 111, 'C392V04KRCHSNN', '352941116688094', '352941116688095', '8904903202A53835968BFABEECED73B9', '64946f48-55ca-4bc8-bc0b-f14bcc7a565b', 4, 4, 'vendido', '2026-08-06 13:10:55.388878', '2026-08-21 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3267, 2, 404, 111, 'DNP2D0400L7XZQ', '358492109307860', '358492109307861', '89049032029A0DF4FB5457922714F034', '541d7687-14a2-455e-b055-7e1930ad998a', 4, 4, 'devuelto', '2026-08-11 21:10:55.388878', '2026-08-26 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3268, 2, 404, 111, 'K4L2D041JR0JMF', '359812085559331', '359812085559332', '8904903202FCB12F035749DA4B9EBAAB', '735cb851-1448-4c30-9cfd-c541c680679a', 4, 4, 'devuelto', '2026-08-11 19:10:55.388878', '2026-08-26 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (425, 2, 404, 1, 'K4L2AUQAADD', '359812085163716', '359812085163717', '890490320296D43C957A8CFBA4A91F34', 'f48135e1-8345-4e63-95ac-d39fe6ad18ba', 695, 288, 'disponible', '2026-09-10 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3269, 2, 404, 111, 'G6T2S046L2ND3A', '358492100893141', '358492100893142', '8904903202FED6131606E6E1856C339D', '327efbfc-8391-4d1f-a0b4-be39b70cc674', 695, 3, 'disponible', '2026-09-09 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3270, 2, 404, 111, 'DNP2S046JC08AL', '352941115078032', '352941115078033', '890490320271DEE173584C6CBC0EE508', '9fe97266-873d-435b-b305-0720aa300f01', 695, 3, 'disponible', '2026-09-07 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (431, 2, 410, 1, 'DNP28DJ8GQF', '352941110263542', '352941110263543', '890490320286B5B441318C237BF84133', '686e33a0-80e4-4002-a4ca-11fd048594ae', 695, 288, 'disponible', '2026-09-14 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3271, 2, 415, 113, 'C392S154MAAWJ5', '359812087295900', '359812087295901', '8904903202ABA4D6F08F78198B9B058F', 'cf4dcd0b-5fd4-4444-b2ef-6bb2ca44c534', 695, 3, 'disponible', '2026-09-11 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3272, 2, 415, 113, 'H022S15HHGN46D', '351829443347661', '351829443347662', '89049032025B3DC91A1B7AE852ED99C2', '3b7cbfc1-9262-4988-bb9b-c556bda34bee', 695, 3, 'disponible', '2026-09-09 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3273, 2, 415, 113, 'F2L2S15R4NQSJ2', '359812085428982', '359812085428983', '8904903202A8BB87573AB1F9D514FA38', '67ff0440-0e90-4f9a-9c8e-fd4873b8d5e0', 695, 3, 'disponible', '2026-09-08 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3274, 2, 415, 113, 'DX32S15RFZ9VR3', '354019239913333', '354019239913334', '8904903202C65C977522AA0159B87F3F', '56b87e2b-abb5-4dfe-b92b-3bdac205a512', 695, 3, 'disponible', '2026-09-11 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3275, 2, 415, 113, 'F2L2S15QW8NT2B', '351829445824494', '351829445824495', '89049032022431923A2873D49D40630D', 'ac1056de-f18e-4717-a0f6-427c41f3c1f1', 695, 3, 'disponible', '2026-09-10 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3276, 2, 415, 113, 'F2L2S15RLJ03MM', '351829442637045', '351829442637046', '89049032020B35A939DBD31AD4E2046A', '32803d89-9fef-4693-90b7-ee45851979a3', 695, 3, 'disponible', '2026-09-15 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3277, 2, 415, 113, 'DX32S15TY3U7AC', '352941116413476', '352941116413477', '890490320240DA38291EB0F6EDB5FA59', '26dcb3cd-d35d-436b-9fb0-9cea636e2c5d', 695, 3, 'disponible', '2026-09-16 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3278, 2, 403, 114, 'DX32V03FTYVD7Y', '352941111062410', '352941111062411', '8904903202A89572626E52ED7F103E75', '7c3a7b21-853a-4979-ba51-2c46a232de82', 4, 4, 'vendido', '2026-07-07 21:10:55.388878', '2026-07-22 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3279, 2, 403, 114, 'DNP2V03Z55EKT0', '358492101014461', '358492101014462', '89049032025D96ABBE6BE450B61700B0', '6ab2e2ce-e576-4810-bcb3-93a110e6a262', 4, 4, 'vendido', '2026-07-07 19:10:55.388878', '2026-07-22 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (424, 2, 403, 1, 'DX32AT706BV', '359812083568305', '359812083568306', '8904903202E49F095C6F1E3068CAFB36', '842aed5e-a5f9-44d3-b7ad-c6cf2167d6f3', 695, 291, 'disponible', '2026-09-07 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3280, 2, 403, 114, 'J8K2S03SU8N03E', '358492101347471', '358492101347472', '8904903202941DC7600B6467CF61E8AA', '29d8fea7-13b2-433f-b0b6-a0d1fec13c77', 695, 3, 'disponible', '2026-09-12 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3281, 2, 403, 114, 'C392S031LHUEQP', '351829443230012', '351829443230013', '890490320250EAA18DFC5C671DCCBB61', 'a5780354-7e1c-484a-9125-a3c913991396', 695, 3, 'disponible', '2026-09-14 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3282, 2, 403, 114, 'G6T2S034866Z1W', '352941111310183', '352941111310184', '890490320272789BF4FA1CF97B03B580', '1dc717f2-4ef0-451c-a48e-64ef58f6ec6c', 695, 3, 'disponible', '2026-09-10 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3283, 2, 403, 114, 'J8K2S039ZUUN48', '358492105674474', '358492105674475', '89049032021A9EE567E9FB603D4A4EC7', '120619bc-2409-4916-98c8-aa7892eed800', 695, 3, 'disponible', '2026-09-09 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3284, 2, 402, 115, 'H022V02ALSDLFT', '352941119592780', '352941119592781', '8904903202C1509A6619183E14EC788C', 'dbb04bd4-03bd-4b21-9633-5184364ec4ea', 4, 4, 'vendido', '2026-09-16 21:10:55.388878', '2026-10-01 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3285, 2, 402, 115, 'H022V02SRACVZA', '358492106310241', '358492106310242', '8904903202EFE37688AEF639ABFA8AC4', 'c1f919c1-a447-4939-b477-d4a8e49723bf', 4, 4, 'vendido', '2026-09-16 19:10:55.388878', '2026-10-01 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3286, 2, 402, 115, 'DNP2V02QX9EG42', '358492106847542', '358492106847543', '890490320277653CA22FB401E3D87383', '9515904e-d9b6-4fac-a22d-0e2fc667697c', 4, 4, 'vendido', '2026-09-16 17:10:55.388878', '2026-10-01 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3287, 2, 402, 115, 'M032V0237SQWDM', '352941114073763', '352941114073764', '8904903202CEC703AA7029C24576D5F6', '5e0d7dff-2d98-4aac-ab45-3af39d9cd319', 4, 4, 'vendido', '2026-09-16 15:10:55.388878', '2026-10-01 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3288, 2, 402, 115, 'F2L2V024ZLTZ9P', '351829447586474', '351829447586475', '89049032029867FC8F9F126AD485BD0D', '589ea088-9f44-4166-9f03-78aa83b59381', 4, 4, 'vendido', '2026-09-16 13:10:55.388878', '2026-10-01 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3289, 2, 402, 115, 'DX32V02FXMNTQJ', '354019235791585', '354019235791586', '8904903202BC8D1EA5028838C325F108', '02526380-dc8c-4055-a268-1ab79f58e834', 4, 4, 'vendido', '2026-09-16 11:10:55.388878', '2026-10-01 11:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3290, 2, 402, 115, 'H022V02WBKC5VY', '358492106316336', '358492106316337', '8904903202C06445D47E4295C6BEABEC', '85eec685-aab7-4283-b07e-c14070b5c43d', 4, 4, 'vendido', '2026-09-16 09:10:55.388878', '2026-10-01 09:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3291, 2, 402, 115, 'M032V02WX47F3N', '354019235639287', '354019235639288', '890490320212E72AF2F56F40299564EE', 'fa6886b3-59ac-43cd-ace2-cd8a074c7742', 4, 4, 'vendido', '2026-09-16 07:10:55.388878', '2026-10-01 07:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3292, 2, 402, 115, 'J8K2V02XFV1RPZ', '358492105539398', '358492105539399', '8904903202ABCF3E159131D896B71E72', '404b75d8-801e-4838-80b5-668133f1f493', 4, 4, 'vendido', '2026-09-16 05:10:55.388878', '2026-10-01 05:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3293, 2, 402, 115, 'DNP2V02CMXSU14', '354019238701479', '354019238701470', '8904903202F305027F3FA12C1CE1CEDA', '358a21e9-02ca-4849-93ce-91fa3681986f', 4, 4, 'vendido', '2026-09-16 03:10:55.388878', '2026-10-01 03:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3294, 2, 402, 115, 'K4L2V02DZAZ4WP', '358492103770470', '358492103770471', '8904903202E5C0680F2668AB350824F8', 'e3958bcc-b811-4661-b6ec-4bbcd96e5f98', 4, 4, 'vendido', '2026-09-16 01:10:55.388878', '2026-10-01 01:10:55.388878');
INSERT INTO public.unidadproducto VALUES (423, 2, 402, 1, 'M0321CJE1CX', '352941118221784', '352941118221785', '8904903202692EDFCE0B5ECDC4C1DD3D', '0673516c-c68e-46a7-bd61-e605fbb0921b', 695, 288, 'disponible', '2026-09-17 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3295, 3, 398, 116, 'F173V980FVUYS6', '354019236329360', '354019236329361', '8904903203F6C768EC485B018666D80E', '93651477-05ee-4dae-8585-3e6c9001d5b1', 6, 6, 'vendido', '2026-09-10 21:10:55.388878', '2026-09-25 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3296, 3, 398, 116, 'DNP3V981PS54D1', '358492104416731', '358492104416732', '8904903203179712672686E26986B345', 'fff0daa5-d5f4-4245-bf70-600bb583c13e', 6, 6, 'vendido', '2026-09-10 19:10:55.388878', '2026-09-25 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3297, 3, 398, 116, 'H023V98Y8RXZYK', '352941112995252', '352941112995253', '8904903203C6CA689933FE5096A7705F', '271c3ac4-01a8-4cd6-a08f-f3bd5294ed92', 6, 6, 'vendido', '2026-09-10 17:10:55.388878', '2026-09-25 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3298, 3, 398, 116, 'G6T3S98EHDQ2M6', '354019231201691', '354019231201692', '890490320387A4076E515555B21875BA', '823e016e-97c3-4d72-bfe2-98f2979215df', 698, 5, 'disponible', '2026-09-12 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3299, 3, 413, 117, 'F2L3V136ARJSCB', '359812088385190', '359812088385191', '89049032036FAA6A53977D9F3C41768F', '0941b871-270b-494a-a381-592435aa09bf', 6, 6, 'vendido', '2026-09-15 21:10:55.388878', '2026-09-30 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3300, 3, 413, 117, 'G6T3V13CF4B8Q7', '358492102172001', '358492102172002', '8904903203C29A75F425FFF223122287', '22b07f42-f6d6-4d30-942f-0a91d8e330e5', 6, 6, 'vendido', '2026-09-15 19:10:55.388878', '2026-09-30 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3301, 3, 413, 117, 'DNP3V13AHXF6AS', '351829442416602', '351829442416603', '8904903203585AAA470FEEAF1D21947C', 'a00b54a7-e3fa-4681-9e53-67b3d706b3e1', 6, 6, 'vendido', '2026-09-15 17:10:55.388878', '2026-09-30 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3302, 3, 413, 117, 'DNP3V13FYZ6UY9', '358492100102683', '358492100102684', '8904903203DB24A06E69F4431A6B2437', 'c9d81de8-62e1-4f3b-8355-306e15758cc7', 6, 6, 'vendido', '2026-09-15 15:10:55.388878', '2026-09-30 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3303, 3, 413, 117, 'K4L3V137Q8YX51', '352941117621954', '352941117621955', '8904903203C600BBB7DABA06B69D26DB', 'efdccd47-4636-4ddf-a790-858b79f231ef', 6, 6, 'vendido', '2026-09-15 13:10:55.388878', '2026-09-30 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3304, 3, 413, 117, 'K4L3V13Z83419D', '351829445288785', '351829445288786', '890490320333AD220F3A6F44BEACF419', '1972a0a3-5d80-4fd6-a588-11726dd93704', 6, 6, 'vendido', '2026-09-15 11:10:55.388878', '2026-09-30 11:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3305, 3, 413, 117, 'J8K3V13TZA5L7Q', '358492102316966', '358492102316967', '8904903203DF9025C7361CE9427CFB0E', '1c3a1bff-4a3d-41fe-a1b2-3b680d3d8b58', 6, 6, 'vendido', '2026-09-15 09:10:55.388878', '2026-09-30 09:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3306, 3, 413, 117, 'C393V13X9AFMC1', '352941116384727', '352941116384728', '890490320335F707C14CB3727F619ECD', 'a16af985-8001-4208-838e-c7b890e4dcc1', 6, 6, 'vendido', '2026-09-15 07:10:55.388878', '2026-09-30 07:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3307, 3, 413, 117, 'H023S13YZ2FWXG', '351829449973330', '351829449973331', '89049032033B9ACD3CA673F620FD1DE3', '8f066954-5cae-496c-8102-2151b67b285f', 698, 5, 'disponible', '2026-09-05 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3308, 3, 413, 117, 'K4L3S13ZNMJRPT', '359812089029601', '359812089029602', '8904903203BC8A7125B8463CAF8E5563', '0f9f825a-e463-402d-9421-43e089f3e07c', 698, 5, 'disponible', '2026-09-05 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3309, 3, 413, 117, 'M033S13GU3NPLK', '359812081930322', '359812081930323', '8904903203A7FA37032BD8FFE7191377', '06777778-bd1c-4e25-9a70-13cb8081c4d7', 698, 5, 'disponible', '2026-09-17 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3310, 3, 413, 117, 'K4L3S13T5BZGPK', '351829448095053', '351829448095054', '8904903203FEF47283499BCB5CEA68D9', 'd3778aa9-be58-4359-b585-e32eb0947bf6', 698, 5, 'disponible', '2026-09-09 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3311, 3, 414, 118, 'DX33V14Q7M1RTN', '352941113137790', '352941113137791', '89049032037302852F71EB124AF67C4E', '865a5558-e77e-4464-a4dc-5087297a25fe', 6, 6, 'vendido', '2026-09-17 21:10:55.388878', '2026-10-02 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3312, 3, 414, 118, 'F2L3V14V19XS3Q', '359812087986571', '359812087986572', '8904903203F4532D04FCABD00A58AA14', '573b64b1-7b73-4c4e-bd2a-e7fa51f562cf', 6, 6, 'vendido', '2026-09-17 19:10:55.388878', '2026-10-02 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3313, 3, 414, 118, 'G6T3V14GU924PA', '352941118609582', '352941118609583', '89049032031863C54A8D9D1B88E7A16D', '2f88164c-487b-41e5-9a2e-5017f05bca5b', 6, 6, 'vendido', '2026-09-17 17:10:55.388878', '2026-10-02 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3314, 3, 414, 118, 'DX33V14WW72MZT', '352941119819673', '352941119819674', '8904903203EEEB447844C4935D238385', 'b5a42ffd-0afe-4da6-84d1-8c91657a7c13', 6, 6, 'vendido', '2026-09-17 15:10:55.388878', '2026-10-02 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3315, 3, 414, 118, 'J8K3V14JPTV8Q5', '352941112878584', '352941112878585', '8904903203A85EE7B9197DDA8C242562', '550aefee-3087-499b-a953-f10f13c46168', 6, 6, 'vendido', '2026-09-17 13:10:55.388878', '2026-10-02 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3316, 3, 414, 118, 'DNP3V1495KMPK0', '354019238538495', '354019238538496', '89049032035957B243877F855B3A7034', '85b5c5bf-2f9d-45b7-b2a5-a98193ba02dd', 6, 6, 'vendido', '2026-09-17 11:10:55.388878', '2026-10-02 11:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3317, 3, 414, 118, 'M033V14DZ9EYZG', '351829442325536', '351829442325537', '890490320333898B5A7FF769D6004201', 'f2ed85af-0e56-4f81-b656-afc943318c5d', 6, 6, 'vendido', '2026-09-17 09:10:55.388878', '2026-10-02 09:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3318, 3, 414, 118, 'M033V14GJ1HSR4', '358492107409477', '358492107409478', '8904903203012A9C25B0BD2E3C7E0CC1', '2cb2bc8d-594c-4d51-9eeb-adbe089451ca', 6, 6, 'vendido', '2026-09-17 07:10:55.388878', '2026-10-02 07:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3319, 3, 414, 118, 'H023V14BM3DKNB', '352941110266088', '352941110266089', '8904903203E42BB011DA9C9480762FF1', '0954d537-d89a-41a6-9a50-43f5d0d16330', 6, 6, 'vendido', '2026-09-17 05:10:55.388878', '2026-10-02 05:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3320, 3, 414, 118, 'H023S148EVSRW6', '358492104317240', '358492104317241', '8904903203116173E5C25AE5AFD556D6', 'fe2eb740-fb2d-43f9-bfe0-3e07d7271d08', 698, 5, 'disponible', '2026-09-07 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3321, 3, 404, 119, 'M033V045FWC40H', '352941113671170', '352941113671171', '890490320337467BF6B2165344F85383', 'd0dbc929-5301-4410-a9a3-e32d8da01832', 6, 6, 'vendido', '2026-08-06 21:10:55.388878', '2026-08-21 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3322, 3, 404, 119, 'DX33V04MR4DPQV', '358492104069301', '358492104069302', '8904903203621AB78670F72FB995AE97', 'ed37e488-87d6-4d7c-ab7e-f6843390a66a', 6, 6, 'vendido', '2026-08-06 19:10:55.388878', '2026-08-21 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3323, 3, 404, 119, 'H023V044RQG003', '354019234059832', '354019234059833', '89049032039C5B4BC6400E9786791691', 'f4c4c92e-4783-4c02-a85e-f88c7a767160', 6, 6, 'vendido', '2026-08-06 17:10:55.388878', '2026-08-21 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3324, 3, 404, 119, 'K4L3V04ZVS9H2Z', '359812089170713', '359812089170714', '8904903203612730A6E364BE6E87DDA1', '4fb00417-834d-4674-9c78-dd4f7d9342c4', 6, 6, 'vendido', '2026-08-06 15:10:55.388878', '2026-08-21 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3325, 3, 404, 119, 'F173V04HF0PSQH', '352941115291364', '352941115291365', '8904903203FE1A6A646E412C65F6873E', '6152b1bd-cac2-4d1a-ad7f-901b46e32960', 6, 6, 'vendido', '2026-08-06 13:10:55.388878', '2026-08-21 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3326, 3, 404, 119, 'F2L3D0471JNJ2J', '351829442965060', '351829442965061', '8904903203F245BB45299DF709BA565F', '76369a25-cec0-417d-908f-e43e9c7d5df9', 6, 6, 'devuelto', '2026-08-11 21:10:55.388878', '2026-08-26 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3327, 3, 404, 119, 'DNP3D04L154YDU', '354019231540611', '354019231540612', '8904903203461DD80A3A46C7FBA7D57A', 'b459ee1b-1ebf-4636-91c5-5dfd312ab614', 6, 6, 'devuelto', '2026-08-11 19:10:55.388878', '2026-08-26 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (444, 3, 404, 1, 'J8K32U33RTJ', '351829449564896', '351829449564897', '89049032036E0441827D5814368C9A89', '42c3c208-5052-4457-8218-67ab65984765', 698, 293, 'disponible', '2026-09-05 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3328, 3, 404, 119, 'H023S04CBZZMN3', '359812084142591', '359812084142592', '8904903203C17C741BDD42101EFAC0B1', '891b502f-992c-4d02-87eb-3422e7903be5', 698, 5, 'disponible', '2026-09-19 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3329, 3, 404, 119, 'DX33S04RM8L46K', '354019238422862', '354019238422863', '8904903203CD6C10982611ABC72C7D80', '749ffea7-49f1-4e6f-bee1-c34a486236f5', 698, 5, 'disponible', '2026-09-12 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (450, 3, 410, 1, 'F2L3U3SUW1B', '351829441318782', '351829441318783', '8904903203276A374B784C7D5FF7468F', 'ae9ed5d1-13f2-4371-9352-79213b482828', 698, 293, 'disponible', '2026-09-13 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3330, 3, 415, 121, 'DX33S15BMMUGTP', '351829448686170', '351829448686171', '89049032035DF1CD57BF4AC20784A001', '0b8a5dd1-9a52-4663-9072-d2e7399a95ed', 698, 5, 'disponible', '2026-09-16 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3331, 3, 415, 121, 'DNP3S15ZP4QV1V', '359812087889781', '359812087889782', '89049032038DF7770FDECBB6F2708AB1', '7d7e9792-e1ab-49ef-9f7d-17c4c2967998', 698, 5, 'disponible', '2026-09-12 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3332, 3, 415, 121, 'H023S159WXL1E3', '359812082890632', '359812082890633', '8904903203E2147EE3D1915E36C4C07D', 'e13ebf62-97e1-40cb-8d47-f98d1acee00a', 698, 5, 'disponible', '2026-09-11 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3333, 3, 415, 121, 'G6T3S15GUPGWNZ', '359812085084903', '359812085084904', '89049032037C9DBCADDC6CE76EDBC7D9', '2acc892e-e92a-4cc7-a3a3-462d2ab54520', 698, 5, 'disponible', '2026-09-11 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3334, 3, 415, 121, 'H023S15W5VBFDP', '351829440387574', '351829440387575', '890490320373F59A4A262ECC1A2EBD1F', '46a28809-f3a5-494e-b4ec-7d5e06095b68', 698, 5, 'disponible', '2026-09-05 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3335, 3, 415, 121, 'C393S15SCUVJCQ', '351829445733695', '351829445733696', '8904903203B407C2478713B262EB6542', '1a93cbde-5b4f-4545-8a78-c04d2ecd96d7', 698, 5, 'disponible', '2026-09-18 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3336, 3, 415, 121, 'F173S15561QPAV', '351829448953226', '351829448953227', '8904903203C56966EC1A06F36DC61699', '55285956-1d36-4d63-bec3-09e85097f925', 698, 5, 'disponible', '2026-09-08 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3337, 3, 403, 122, 'DNP3V03LXHDVWF', '351829442217590', '351829442217591', '89049032035342B2274C0F4EF3A1FEB4', '8285c21c-6534-4265-8501-8e333a739562', 6, 6, 'vendido', '2026-07-07 21:10:55.388878', '2026-07-22 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3338, 3, 403, 122, 'C393V03U1JRVYV', '352941118256491', '352941118256492', '8904903203D88102FE4AC9C847FE946C', '22900a74-5d88-4eec-a279-56d5fb2bbaf3', 6, 6, 'vendido', '2026-07-07 19:10:55.388878', '2026-07-22 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (443, 3, 403, 1, 'J8K3M1ZUE3Q', '354019230060265', '354019230060266', '890490320385F8791BDACB37357616A5', '558252b1-b61a-4ca1-8e5e-6c2fcc6b359f', 698, 296, 'disponible', '2026-09-16 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3339, 3, 403, 122, 'H023S03RDH3G3D', '351829445759011', '351829445759012', '8904903203AF4A77C3EDD40017AE4AC0', '1cad9819-807e-407a-9209-f920b029bbd3', 698, 5, 'disponible', '2026-09-06 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3340, 3, 403, 122, 'G6T3S03U5UM8S8', '358492103764362', '358492103764363', '89049032038942EEFEDAC6F5205491CE', '51ea1a50-7938-4623-b599-5f835e0e8a85', 698, 5, 'disponible', '2026-09-11 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3341, 3, 403, 122, 'DNP3S03Z7QN7UJ', '354019235130063', '354019235130064', '890490320319711DF51C639C7599DDDA', '4cd4d50a-60d8-4b4a-bcf6-5b1fe5f42bab', 698, 5, 'disponible', '2026-09-10 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3342, 3, 403, 122, 'H023S03RMLWZ4D', '358492106502664', '358492106502665', '8904903203F0E53F86B71BF7DABC06FB', 'ee0d1234-7a76-431f-9ed2-1ba79f645796', 698, 5, 'disponible', '2026-09-13 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3343, 3, 402, 123, 'J8K3V02JRE9WY5', '354019231536600', '354019231536601', '89049032038C3A2AFC8F73A8656AA46E', 'e69a69d1-fa81-4885-aa5d-08043d47a94e', 6, 6, 'vendido', '2026-09-16 21:10:55.388878', '2026-10-01 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3344, 3, 402, 123, 'K4L3V02GELPTJL', '359812080333351', '359812080333352', '89049032033F690C822CF54D3B37A1A0', '17e72d3d-bd36-424f-b63e-61f738edc9f5', 6, 6, 'vendido', '2026-09-16 19:10:55.388878', '2026-10-01 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3345, 3, 402, 123, 'G6T3V02L0A2BT3', '359812089505222', '359812089505223', '89049032039A56C9CB7EB74A028FF207', '338b655b-c14e-480e-bf5d-f4d17b93a8ac', 6, 6, 'vendido', '2026-09-16 17:10:55.388878', '2026-10-01 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3346, 3, 402, 123, 'F2L3V02KFT7ACM', '354019230095903', '354019230095904', '8904903203E14A31EFAD0A5C8AF55C5B', '59224a42-ab12-463d-a537-febc00556743', 6, 6, 'vendido', '2026-09-16 15:10:55.388878', '2026-10-01 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3347, 3, 402, 123, 'H023V02WY60GF8', '359812089003754', '359812089003755', '8904903203ADAF6E111AE5A702B561FD', '03bf7e83-9e80-49af-ab26-475d5ebeb35f', 6, 6, 'vendido', '2026-09-16 13:10:55.388878', '2026-10-01 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3348, 3, 402, 123, 'F2L3V02R35607H', '358492105597055', '358492105597056', '89049032032096C6CF191B3C42E35C47', '75cd0d98-4c0f-425e-b268-7512200fd3b2', 6, 6, 'vendido', '2026-09-16 11:10:55.388878', '2026-10-01 11:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3349, 3, 402, 123, 'DNP3V02JD6F1KZ', '358492104452406', '358492104452407', '890490320335F56797912DA256F6FBA1', '95a0a59a-297d-4328-9c90-ccb3bf7bd5c5', 6, 6, 'vendido', '2026-09-16 09:10:55.388878', '2026-10-01 09:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3350, 3, 402, 123, 'J8K3V028GFRJD8', '359812082652177', '359812082652178', '8904903203A9819FD5064A884E39B12B', 'd82a5812-9cf6-43b7-b374-a8d76db215ba', 6, 6, 'vendido', '2026-09-16 07:10:55.388878', '2026-10-01 07:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3351, 3, 402, 123, 'G6T3V02QAM085X', '354019235337428', '354019235337429', '8904903203AF0D5B3AFFE5A840655341', '2a88d247-6e63-42cb-85d4-ebb5637777f7', 6, 6, 'vendido', '2026-09-16 05:10:55.388878', '2026-10-01 05:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3352, 3, 402, 123, 'F2L3V02Q0USVF4', '352941118343009', '352941118343000', '8904903203BEA07DF40489311CEA7B1C', '7802a4ea-ae77-4625-9695-4fa9173a2010', 6, 6, 'vendido', '2026-09-16 03:10:55.388878', '2026-10-01 03:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3353, 3, 402, 123, 'C393V02K4KW3QP', '358492106953670', '358492106953671', '89049032030703B9D74A01E5D0A7B6BD', 'a130f4ca-f71d-41dd-b757-eadfc6628c52', 6, 6, 'vendido', '2026-09-16 01:10:55.388878', '2026-10-01 01:10:55.388878');
INSERT INTO public.unidadproducto VALUES (442, 3, 402, 1, 'F173S84K2S7', '358492108277524', '358492108277525', '8904903203FF8C1D25C9042611759739', 'f9112750-8ba6-4b28-8ece-ac71c4191a80', 698, 293, 'disponible', '2026-09-15 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3354, 4, 398, 124, 'DX34V98N4H4B5J', '359812081790390', '359812081790391', '8904903204D417282B59B91DF9EDFEFC', '35d1b93d-a542-4727-acdc-cc4aa43628b1', 8, 8, 'vendido', '2026-09-10 21:10:55.388878', '2026-09-25 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3355, 4, 398, 124, 'G6T4V980EGMWJS', '358492107103091', '358492107103092', '890490320492B70EB507AABF577BDB72', '7c1b6dfc-5059-49cf-b846-77005bd93e74', 8, 8, 'vendido', '2026-09-10 19:10:55.388878', '2026-09-25 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3356, 4, 398, 124, 'K4L4V98MY4FY5Z', '358492105133092', '358492105133093', '8904903204466169536965A6458B1103', '328ef1ee-3d78-45c4-8d1c-7c6515bde40c', 8, 8, 'vendido', '2026-09-10 17:10:55.388878', '2026-09-25 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3357, 4, 398, 124, 'DX34S98WNEAAM8', '359812086493121', '359812086493122', '8904903204BD19A5CAA4630AB4637F79', '405c9fa7-9bbd-4af6-b281-06dabdd20538', 701, 7, 'disponible', '2026-09-06 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3358, 4, 413, 125, 'M034V136MWMCU8', '358492106813170', '358492106813171', '8904903204D04C506AFDB8B56E5D3238', '49e868db-ed60-48d3-8ee2-487083cf120d', 8, 8, 'vendido', '2026-09-15 21:10:55.388878', '2026-09-30 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3359, 4, 413, 125, 'M034V136LN1USF', '359812083917241', '359812083917242', '89049032048BAEFA96F0644289C3A242', 'acc84bdc-b73e-41a0-beff-963898dd9827', 8, 8, 'vendido', '2026-09-15 19:10:55.388878', '2026-09-30 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3360, 4, 413, 125, 'F2L4V1353BZ2J5', '354019239385032', '354019239385033', '8904903204E1BE13C342D221CEC680CC', '65d9934b-ab3f-4c86-85b1-a66b2a8ef79a', 8, 8, 'vendido', '2026-09-15 17:10:55.388878', '2026-09-30 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3361, 4, 413, 125, 'F174V13VWXEMZB', '358492107602603', '358492107602604', '89049032043DBE409A7BF7FB3FE54D42', '23ac34d8-0a41-4a84-a10e-998807504232', 8, 8, 'vendido', '2026-09-15 15:10:55.388878', '2026-09-30 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3362, 4, 413, 125, 'F174V13AZKUTC3', '359812080071484', '359812080071485', '890490320424E41C568074D2FF3CC334', '01eec0bf-3b4b-423c-830a-c1aab4ca7a64', 8, 8, 'vendido', '2026-09-15 13:10:55.388878', '2026-09-30 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3363, 4, 413, 125, 'J8K4V13V9G1A51', '358492101587175', '358492101587176', '89049032040E1B6AAC6667E26C78F748', '38413c0d-2cf1-4d83-8c19-61cf50103948', 8, 8, 'vendido', '2026-09-15 11:10:55.388878', '2026-09-30 11:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3364, 4, 413, 125, 'DX34V13GFHL9LW', '352941113342546', '352941113342547', '8904903204DE5D07BEDF532ECE70D7DB', '11266d90-645e-41b2-9a0f-77b97629de03', 8, 8, 'vendido', '2026-09-15 09:10:55.388878', '2026-09-30 09:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3365, 4, 413, 125, 'F2L4V13T5GW827', '354019234248427', '354019234248428', '89049032041EFC3359BE2B2FAA906852', 'e080ff31-90d6-46ca-90b6-c1a372b60a38', 8, 8, 'vendido', '2026-09-15 07:10:55.388878', '2026-09-30 07:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3366, 4, 413, 125, 'DNP4S138Z2MQQR', '359812087845740', '359812087845741', '890490320499AD1E159B234F0ED578BB', 'dd8e7f79-df1c-4a01-82cf-72d20a47fd15', 701, 7, 'disponible', '2026-09-15 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3367, 4, 413, 125, 'H024S13286K5X7', '354019233564531', '354019233564532', '89049032048A5E6330CF44D98F6202D4', 'ad91bef0-b6a2-456d-b91e-8fa6dbb5fa1c', 701, 7, 'disponible', '2026-09-16 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3368, 4, 413, 125, 'H024S13N2HD8AV', '354019230159062', '354019230159063', '8904903204C2CE46A2FCDF980C2001F3', 'c9e12893-f8f5-4d1d-84eb-b69eed3ff741', 701, 7, 'disponible', '2026-09-13 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3369, 4, 413, 125, 'DNP4S13F1YLYAY', '352941114571673', '352941114571674', '89049032041FF0BAB6C454E310E648A5', '97760e89-0ef0-4867-ac85-95579370dc0e', 701, 7, 'disponible', '2026-09-17 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3370, 4, 414, 126, 'F174V14YWKZPM5', '358492106740860', '358492106740861', '89049032041CA2B56A01130AC4327748', '9ad6a4e8-7ee5-4276-8a10-bb4a5f421845', 8, 8, 'vendido', '2026-09-17 21:10:55.388878', '2026-10-02 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3371, 4, 414, 126, 'G6T4V14NKT45C1', '359812083005681', '359812083005682', '890490320486CC6CF742911E4BCBE9E6', 'fa28f1ba-05ed-4095-babd-d421806ac6b4', 8, 8, 'vendido', '2026-09-17 19:10:55.388878', '2026-10-02 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3372, 4, 414, 126, 'J8K4V14F208QHY', '352941116392722', '352941116392723', '89049032046C7DFB24C42EE14FA805EA', '865e7373-67ef-43f3-94b5-d8b90132bf68', 8, 8, 'vendido', '2026-09-17 17:10:55.388878', '2026-10-02 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3373, 4, 414, 126, 'DNP4V14P124UXZ', '354019233225333', '354019233225334', '8904903204FBF96AE73D597EB3ED89D9', '9b60e696-683f-4248-847b-265933a1f0e2', 8, 8, 'vendido', '2026-09-17 15:10:55.388878', '2026-10-02 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3374, 4, 414, 126, 'K4L4V149L8LPFJ', '352941116612564', '352941116612565', '890490320452E4CEEED26D26E00B3D9F', 'd672b3e3-6e0c-41e0-a210-3e97952aa525', 8, 8, 'vendido', '2026-09-17 13:10:55.388878', '2026-10-02 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3375, 4, 414, 126, 'DNP4V14BHA46DU', '352941118811045', '352941118811046', '89049032041AF4CF04BD193A0D57EDAF', '08b634f9-bbf5-4154-b227-3f5619405e9e', 8, 8, 'vendido', '2026-09-17 11:10:55.388878', '2026-10-02 11:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3376, 4, 414, 126, 'J8K4V14BMC210L', '354019234121076', '354019234121077', '8904903204115F4FD6CB79FC0EBDB5BD', 'bff25ed6-0707-4550-82d2-27b6858f8721', 8, 8, 'vendido', '2026-09-17 09:10:55.388878', '2026-10-02 09:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3377, 4, 414, 126, 'DNP4V146NTR7TP', '352941113063267', '352941113063268', '89049032040BE00A12CAF6BE8AD48CBD', '165244aa-0714-4771-8974-3e98a67f290c', 8, 8, 'vendido', '2026-09-17 07:10:55.388878', '2026-10-02 07:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3378, 4, 414, 126, 'K4L4V145M1XWGX', '358492103195038', '358492103195039', '8904903204C5027951AF4221CA93722A', 'f23d7e2c-bce6-4686-9c8c-f2ae7a3e215e', 8, 8, 'vendido', '2026-09-17 05:10:55.388878', '2026-10-02 05:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3379, 4, 414, 126, 'H024S14B7MNMPC', '351829449275070', '351829449275071', '8904903204D9B703E33BE26E5F8D4C5E', 'e382ad4b-0f68-40e7-9d10-48534c36e13b', 701, 7, 'disponible', '2026-09-16 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3380, 4, 404, 127, 'M034V04QYLABJV', '354019230410380', '354019230410381', '8904903204D32E1DD1D821D3934BBAB0', '2b9b49e8-7035-46f1-ac06-2759473a3952', 8, 8, 'vendido', '2026-08-06 21:10:55.388878', '2026-08-21 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3381, 4, 404, 127, 'H024V04EZC2H8Z', '354019232201581', '354019232201582', '8904903204D04EF6F849067DF9513191', '59ad0b0f-16ae-4ff1-8bc7-261c61365f6b', 8, 8, 'vendido', '2026-08-06 19:10:55.388878', '2026-08-21 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3382, 4, 404, 127, 'J8K4V04Y1KJ50X', '354019237746292', '354019237746293', '89049032042B228F3F2A52B951164035', '615f33b6-3fb6-4b4c-852a-11c8927d60cf', 8, 8, 'vendido', '2026-08-06 17:10:55.388878', '2026-08-21 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3383, 4, 404, 127, 'F2L4V0454RDQM3', '359812082208083', '359812082208084', '89049032046DBCC87A624A1FBEEDD510', 'f458eea9-d280-4a99-b542-9c0b4fc24ade', 8, 8, 'vendido', '2026-08-06 15:10:55.388878', '2026-08-21 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3384, 4, 404, 127, 'DNP4V04A4QH6KN', '352941110173694', '352941110173695', '89049032043DA5089C869AE727427BD9', '2fa8d4ea-fdf8-46c3-acd0-d77a7296554d', 8, 8, 'vendido', '2026-08-06 13:10:55.388878', '2026-08-21 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3385, 4, 404, 127, 'C394D04LDDXP5P', '352941112458490', '352941112458491', '8904903204628BF9951DE0DC5E59CD58', '6c908cc2-319a-4c64-a17a-0ce2c84228ea', 8, 8, 'devuelto', '2026-08-11 21:10:55.388878', '2026-08-26 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3386, 4, 404, 127, 'M034D045SZE69D', '352941117910201', '352941117910202', '890490320477EA978BF10A7BA8D0B3B4', '374e5ca2-0545-4211-98a2-a40d9daad16f', 8, 8, 'devuelto', '2026-08-11 19:10:55.388878', '2026-08-26 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3387, 4, 404, 127, 'DX34S0412486FE', '352941117395681', '352941117395682', '890490320483B8C601668C417A7DDBB3', '51d0fc1c-fac0-469e-abc7-bca1ef134f45', 701, 7, 'disponible', '2026-09-07 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3388, 4, 404, 127, 'DNP4S04TXV1C9H', '352941113646762', '352941113646763', '8904903204E3B78ED2D718E1D5A84C70', '5000fc4f-b45a-49a3-8fd7-940885dee324', 701, 7, 'disponible', '2026-09-12 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3389, 4, 415, 129, 'J8K4S15YHXCHTZ', '354019239779430', '354019239779431', '89049032042F37656240EED7B7E42F14', '49b3b6d3-a891-4c14-b369-493cdc560699', 701, 7, 'disponible', '2026-09-09 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3390, 4, 415, 129, 'J8K4S15FDP7WBJ', '351829443376111', '351829443376112', '8904903204FA6ECEC4E979B0BC54D4B2', 'c2afe00f-7831-4077-8e35-50b651abf08a', 701, 7, 'disponible', '2026-09-10 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3391, 4, 415, 129, 'K4L4S15DPL7D8B', '359812082949862', '359812082949863', '89049032040EB95E7ED4B39914F8D69A', '1c746918-2f9d-4533-aced-dbdb02a80ed0', 701, 7, 'disponible', '2026-09-05 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3392, 4, 415, 129, 'DNP4S150ATBQPL', '351829445101523', '351829445101524', '890490320435E98C7DB7EB7049620D6B', 'bcd76f24-3d48-4ceb-b77a-e65a54c4049c', 701, 7, 'disponible', '2026-09-18 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3393, 4, 415, 129, 'K4L4S15QYTYG3E', '358492100290364', '358492100290365', '89049032048F5AA637A2FCA1AFD2F0CB', '0bd0a175-6051-4cfc-a20e-ebbab12995f9', 701, 7, 'disponible', '2026-09-10 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3394, 4, 415, 129, 'H024S15W8ADZ9N', '358492104435655', '358492104435656', '89049032046D9CC15563ADA6342FDD70', 'eff9639e-71d4-430c-ad0c-37abba97338e', 701, 7, 'disponible', '2026-09-20 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3395, 4, 415, 129, 'M034S15ZWVXS1M', '359812081245816', '359812081245817', '89049032047DA7155E6EAD955E130D75', '400c0b70-37ad-42d5-a5c8-b984e3e11ec9', 701, 7, 'disponible', '2026-09-12 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3396, 4, 403, 130, 'DX34V03WR5JXGG', '351829442985880', '351829442985881', '890490320471175F15A495CB5D813EEF', '7fe96904-968e-4ce5-83dc-339365764ac5', 8, 8, 'vendido', '2026-07-07 21:10:55.388878', '2026-07-22 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3397, 4, 403, 130, 'H024V030ZZRG5F', '354019233657751', '354019233657752', '89049032041E67845D8BEE0E903696FD', '782b7141-4574-4abc-b25a-cb211b5c5f73', 8, 8, 'vendido', '2026-07-07 19:10:55.388878', '2026-07-22 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3398, 4, 403, 130, 'DNP4S03HRHNJZU', '358492100530461', '358492100530462', '890490320400F4AE60ADE176D5C58FD9', 'e72c7d3d-1592-44e6-aacf-88cefa6ed759', 701, 7, 'disponible', '2026-09-20 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3399, 4, 403, 130, 'F174S03JXUQUWF', '352941112380882', '352941112380883', '8904903204C9DD775E9003C7176A09C2', '90d8ba2a-bc45-4c60-be9f-5b5ce31dfc89', 701, 7, 'disponible', '2026-09-06 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3400, 4, 403, 130, 'DX34S03APPWBML', '351829446006803', '351829446006804', '8904903204DC0AD257D63AAF070024D6', '06fdd1fa-b44e-4cc0-bb62-6c791a395335', 701, 7, 'disponible', '2026-09-08 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3401, 4, 403, 130, 'C394S03WL6R1ZZ', '352941111440034', '352941111440035', '89049032042A48BAFCF35D1C8A78D194', '25f4e451-30fa-4472-8a5a-358d7336f103', 701, 7, 'disponible', '2026-09-05 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3402, 4, 402, 131, 'H024V026XRGK0R', '358492101047260', '358492101047261', '890490320424FE01CDEB59B3C055F356', 'ed9d4fc7-a56e-4d86-8241-69ce3398b3ea', 8, 8, 'vendido', '2026-09-16 21:10:55.388878', '2026-10-01 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3403, 4, 402, 131, 'K4L4V025FZU9UV', '352941110684981', '352941110684982', '8904903204839750BE60BC1352216B7B', '1009ae19-b039-4b11-aac2-e4488964b52e', 8, 8, 'vendido', '2026-09-16 19:10:55.388878', '2026-10-01 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3404, 4, 402, 131, 'M034V02Y7K37F9', '359812081590002', '359812081590003', '89049032045026433A0E9A0E561E83CF', 'ef3b33d9-af0f-4a59-85b0-c00a1f06b011', 8, 8, 'vendido', '2026-09-16 17:10:55.388878', '2026-10-01 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3405, 4, 402, 131, 'J8K4V0249J2X75', '352941112935953', '352941112935954', '8904903204D9A680F5A256156CB5AF58', 'debb3e1a-c78d-4e5b-82a9-c458a69a7590', 8, 8, 'vendido', '2026-09-16 15:10:55.388878', '2026-10-01 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3406, 4, 402, 131, 'DX34V02YM54356', '352941112010504', '352941112010505', '8904903204AA168B2EBD462EA71A4F56', '267d585d-7e27-48df-a93e-7916c1b38b12', 8, 8, 'vendido', '2026-09-16 13:10:55.388878', '2026-10-01 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3407, 4, 402, 131, 'H024V02G5KMER6', '352941118882795', '352941118882796', '890490320466B410D2CA791907FD595C', 'bc95ff5b-ab4b-4199-ae80-1a7b0057c917', 8, 8, 'vendido', '2026-09-16 11:10:55.388878', '2026-10-01 11:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3408, 4, 402, 131, 'G6T4V02YLRV8EG', '358492105000836', '358492105000837', '890490320453D0C465BFFED9F4FF7F81', '3754a884-4ae3-47c3-8536-4ea8eceef4f5', 8, 8, 'vendido', '2026-09-16 09:10:55.388878', '2026-10-01 09:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3409, 4, 402, 131, 'F2L4V02GE63GH2', '354019235710777', '354019235710778', '8904903204F91FAF7C19C56655B2B09E', 'bfc5b381-d1c8-4653-9880-97a66934f2aa', 8, 8, 'vendido', '2026-09-16 07:10:55.388878', '2026-10-01 07:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3410, 4, 402, 131, 'H024V02264JY11', '358492100212318', '358492100212319', '890490320490EEE39FC7A5FB950D2763', '0d2a44f2-67e0-434c-a338-6b67867eb8a5', 8, 8, 'vendido', '2026-09-16 05:10:55.388878', '2026-10-01 05:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3411, 4, 402, 131, 'M034V021WK1WWE', '358492107708999', '358492107708990', '8904903204FED928EF55868B0AE82F9B', 'c09aae72-ecc3-458a-98b3-6197b5fc64fe', 8, 8, 'vendido', '2026-09-16 03:10:55.388878', '2026-10-01 03:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3412, 4, 402, 131, 'H024V022M53XX6', '351829445124510', '351829445124511', '8904903204C0629B05F86FC443564AD2', 'b84a2505-fc8d-43b8-a59c-6a794553620c', 8, 8, 'vendido', '2026-09-16 01:10:55.388878', '2026-10-01 01:10:55.388878');
INSERT INTO public.unidadproducto VALUES (461, 4, 402, 1, 'G6T4HQSCT8K', '352941111444254', '352941111444255', '890490320497DBB88F76F788ADAC47F4', '72694990-3da2-4610-a269-1d70c0d9d707', 701, 298, 'disponible', '2026-09-09 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3413, 5, 398, 132, 'DX35V98BCQWL8Z', '354019239612270', '354019239612271', '89049032057BA36E7624CE3C47EB3FEF', 'f3631b17-e082-4142-958c-40596e4caa08', 10, 10, 'vendido', '2026-09-10 21:10:55.388878', '2026-09-25 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3414, 5, 398, 132, 'C395V98DVMLFMN', '351829440792161', '351829440792162', '89049032052FB0451F32D71055A08C54', '358d36cb-0752-44b9-963e-45b4767b88ab', 10, 10, 'vendido', '2026-09-10 19:10:55.388878', '2026-09-25 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3415, 5, 398, 132, 'C395V98ZBS8ZQ4', '359812087166382', '359812087166383', '8904903205CE22B1E2F7E772B07C8CCF', '5468eb7d-fb03-48e8-a511-a266e815b836', 10, 10, 'vendido', '2026-09-10 17:10:55.388878', '2026-09-25 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3416, 5, 398, 132, 'K4L5S985GSLMVT', '358492108661361', '358492108661362', '8904903205A708DC1BF8922A9F898DBE', '33156983-c0a2-4e1c-878d-48fed51b2dce', 704, 9, 'disponible', '2026-09-15 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3417, 5, 413, 133, 'F2L5V13MYPRS4W', '354019235650450', '354019235650451', '890490320527C06BB9C6A10FC5CE7D63', 'a4ba20b3-2abd-407a-9d75-2c4db74bd60a', 10, 10, 'vendido', '2026-09-15 21:10:55.388878', '2026-09-30 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3418, 5, 413, 133, 'C395V13ZCW208K', '352941110889151', '352941110889152', '89049032050AF232C1EBFCA0272E71F1', 'f3a12048-0c78-4c01-9650-d2e3772ae8f6', 10, 10, 'vendido', '2026-09-15 19:10:55.388878', '2026-09-30 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3419, 5, 413, 133, 'C395V131AUX706', '358492105939292', '358492105939293', '8904903205009A9E2594600F510537E0', '7e2eba32-7d58-4f27-9171-adf955228ad0', 10, 10, 'vendido', '2026-09-15 17:10:55.388878', '2026-09-30 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3420, 5, 413, 133, 'F175V1312DWA8C', '354019236124693', '354019236124694', '89049032053D183D3A726BA536709809', 'c58ba1ef-a8cb-4a59-aeb2-9911818d2bde', 10, 10, 'vendido', '2026-09-15 15:10:55.388878', '2026-09-30 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3421, 5, 413, 133, 'F2L5V13LQFLJ9A', '351829446333924', '351829446333925', '8904903205347F0D9859F5BAA7D8EB2B', 'f7f3ed9c-135a-4286-8973-08d012af0902', 10, 10, 'vendido', '2026-09-15 13:10:55.388878', '2026-09-30 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3422, 5, 413, 133, 'DNP5V1336W1UD8', '352941113986485', '352941113986486', '8904903205CD2C20E508743105536FB1', 'e5895fae-36df-4f88-9e1e-c0bff7a11322', 10, 10, 'vendido', '2026-09-15 11:10:55.388878', '2026-09-30 11:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3423, 5, 413, 133, 'J8K5V13Y119FM7', '358492103809586', '358492103809587', '890490320523F968BD65CD4AC93A9E15', 'add12079-578f-4851-9682-4fe57a47cac8', 10, 10, 'vendido', '2026-09-15 09:10:55.388878', '2026-09-30 09:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3424, 5, 413, 133, 'G6T5V13NSX22F6', '351829448726447', '351829448726448', '8904903205D65BFE441344196B178DA6', 'b63b3c3b-e42a-49c6-96a7-932d85cc5de4', 10, 10, 'vendido', '2026-09-15 07:10:55.388878', '2026-09-30 07:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3425, 5, 413, 133, 'J8K5S13B2KJ50D', '358492105348890', '358492105348891', '89049032056572BB9F5434BC4DF61A55', '00b6cada-45dd-40e5-b9f1-12966c18d4de', 704, 9, 'disponible', '2026-09-16 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3426, 5, 413, 133, 'K4L5S138K0D7LL', '352941112570611', '352941112570612', '89049032059DDC9F2269B68127B72B88', 'f85e685d-2548-4e08-b220-a897e85a5f4a', 704, 9, 'disponible', '2026-09-19 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3427, 5, 413, 133, 'G6T5S13S3Q83L9', '352941117436372', '352941117436373', '8904903205AC2CBF291C456C83D97D2F', '0985a2c2-9064-43f4-9d82-e801b922ae15', 704, 9, 'disponible', '2026-09-17 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3428, 5, 413, 133, 'G6T5S13YDBLY21', '354019239304023', '354019239304024', '890490320527BF361C028F17636FBDFD', '262c5136-1396-41ad-963e-aed7b8727742', 704, 9, 'disponible', '2026-09-08 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3429, 5, 414, 134, 'H025V1472QY5ZX', '358492107490690', '358492107490691', '8904903205267929336DC4E0175D0D47', 'dbecf1b3-c688-4a37-88cd-93152be8455c', 10, 10, 'vendido', '2026-09-17 21:10:55.388878', '2026-10-02 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3430, 5, 414, 134, 'M035V140JCRU36', '351829447147861', '351829447147862', '8904903205E014DA54C30B1634F92D2C', 'd447d99c-3a88-4195-9d41-4489f2df1f86', 10, 10, 'vendido', '2026-09-17 19:10:55.388878', '2026-10-02 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3431, 5, 414, 134, 'C395V14A1ZK2WT', '358492102285872', '358492102285873', '89049032057DC41B7DBFA0BF3462E5C9', '4ec670d5-4dac-4045-9e38-08e136f7456a', 10, 10, 'vendido', '2026-09-17 17:10:55.388878', '2026-10-02 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3432, 5, 414, 134, 'M035V14HPJU5PM', '358492101704403', '358492101704404', '890490320563CBE9427F84E87F9563D8', 'e5a4b83f-6fba-4434-a5c7-75e676345028', 10, 10, 'vendido', '2026-09-17 15:10:55.388878', '2026-10-02 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3433, 5, 414, 134, 'C395V142TR8ZR2', '351829448859874', '351829448859875', '8904903205EB54E2C42C8A4D5261FDD2', 'fed22896-5bf0-4a5d-96d1-dbd3df6e07f0', 10, 10, 'vendido', '2026-09-17 13:10:55.388878', '2026-10-02 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3434, 5, 414, 134, 'DNP5V14Z7C2U52', '359812084447385', '359812084447386', '89049032059A3CD53DE0F0B97A8F8FEC', '0db75c18-1cf4-4d4b-8e0f-7439a13f173b', 10, 10, 'vendido', '2026-09-17 11:10:55.388878', '2026-10-02 11:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3435, 5, 414, 134, 'F2L5V14165DTF1', '352941114949416', '352941114949417', '8904903205790785258570A76B54C544', '17e360e0-0dd5-47d4-bf73-def2c2c47320', 10, 10, 'vendido', '2026-09-17 09:10:55.388878', '2026-10-02 09:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3436, 5, 414, 134, 'DNP5V148BV6JC4', '354019232975347', '354019232975348', '89049032053517203EF470A4458F3473', '4c9dfba2-573a-467b-a9bc-c39b61423ab4', 10, 10, 'vendido', '2026-09-17 07:10:55.388878', '2026-10-02 07:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3437, 5, 414, 134, 'F2L5V140QVV6A4', '351829449434638', '351829449434639', '890490320541364FB85F654068C84A93', '9f07733b-24b2-46e9-bb46-0dedfa1fafc6', 10, 10, 'vendido', '2026-09-17 05:10:55.388878', '2026-10-02 05:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3438, 5, 414, 134, 'DNP5S14N7RRM6S', '359812088675760', '359812088675761', '89049032056FC657F61825A55D6DA621', '9a0f9abe-1f85-425e-a2ac-e4d457168f2f', 704, 9, 'disponible', '2026-09-07 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3439, 5, 404, 135, 'H025V04URZ7B8Y', '358492108736950', '358492108736951', '890490320587426E9211981F350DD643', '88d3bca1-4983-48ab-895f-358065408f31', 10, 10, 'vendido', '2026-08-06 21:10:55.388878', '2026-08-21 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3440, 5, 404, 135, 'K4L5V04168MY8J', '351829444542461', '351829444542462', '89049032059E89A812BD7E2C4DB70B9A', 'ac8f5c2c-120f-4924-9cd8-d5293a565999', 10, 10, 'vendido', '2026-08-06 19:10:55.388878', '2026-08-21 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3441, 5, 404, 135, 'H025V045EK039U', '354019235264742', '354019235264743', '89049032056B67B0CE94CA4B92EC48F8', 'c2c39c02-eb1e-48fe-aa92-293fa4b47f56', 10, 10, 'vendido', '2026-08-06 17:10:55.388878', '2026-08-21 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3442, 5, 404, 135, 'H025V04SHNV3VM', '351829442409933', '351829442409934', '89049032052C5A30F9484A3536A2FE8C', '1d845396-415c-4325-9a28-9a832697a2d7', 10, 10, 'vendido', '2026-08-06 15:10:55.388878', '2026-08-21 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3443, 5, 404, 135, 'F2L5V044RUA7HR', '351829444630644', '351829444630645', '89049032055EEB1CC71219DAB61DF1A5', '666d9eed-7226-47a5-92e9-d045e4e5f78b', 10, 10, 'vendido', '2026-08-06 13:10:55.388878', '2026-08-21 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3444, 5, 404, 135, 'F175D04CLFDQ20', '359812086178300', '359812086178301', '8904903205D0F0371F2E06F82019E1C2', 'c730123e-0747-43af-a484-a9c9aaa7d6c1', 10, 10, 'devuelto', '2026-08-11 21:10:55.388878', '2026-08-26 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3445, 5, 404, 135, 'K4L5D043GWU52U', '358492100237111', '358492100237112', '890490320592AC1BD6EF45B324EB469E', '5a8ae89f-465b-4746-bc82-cd679231e37b', 10, 10, 'devuelto', '2026-08-11 19:10:55.388878', '2026-08-26 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3446, 5, 404, 135, 'C395S04DN3BRMX', '352941110802661', '352941110802662', '89049032055105CFC769A7453C22D6EA', '67da5834-ec47-4435-9db1-31c9522ee708', 704, 9, 'disponible', '2026-09-13 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3447, 5, 404, 135, 'H025S04EEV0Z6M', '351829447527512', '351829447527513', '8904903205F75FA6FF69676DDCAFD9A9', '17397ad7-e597-494c-b7a7-ce3eb192c8c1', 704, 9, 'disponible', '2026-09-08 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3448, 5, 415, 137, 'J8K5S15FZKAM13', '352941110475920', '352941110475921', '8904903205F8B8B6555130C26AB6A401', '31b8da88-fcba-447c-a5d4-6e6f600d42f7', 704, 9, 'disponible', '2026-09-12 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3449, 5, 415, 137, 'F175S15ZZC3M68', '354019238130271', '354019238130272', '8904903205F0A68F19EF8D05E71FBA5A', 'c3873b5f-8f18-4129-8de6-28893b1ab93f', 704, 9, 'disponible', '2026-09-13 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3450, 5, 415, 137, 'F2L5S15JD3T49P', '359812087018822', '359812087018823', '890490320587E8FFEB4F7B022820C279', '6bb7f344-76a8-4120-8d75-1ac26720463f', 704, 9, 'disponible', '2026-09-11 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3451, 5, 415, 137, 'M035S15XHH68AH', '354019233980583', '354019233980584', '890490320539F01727491CE67906A238', '510e4e87-5ae5-4cb3-907d-80dbb91b15a0', 704, 9, 'disponible', '2026-09-20 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3452, 5, 415, 137, 'F2L5S153042Z83', '354019236531134', '354019236531135', '8904903205D2FE694037A50BB88E5BB1', 'ae5b9c14-4f49-4f89-a8ba-eb51c05950ca', 704, 9, 'disponible', '2026-09-20 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3453, 5, 415, 137, 'F2L5S15XDJFXU8', '354019236168385', '354019236168386', '8904903205CB1CF738CD647B296D61BD', 'ae014bd7-90df-4216-8887-cd13a82b11bb', 704, 9, 'disponible', '2026-09-18 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3454, 5, 415, 137, 'DNP5S15VDY9A4E', '358492100388756', '358492100388757', '890490320549BA688ECD0F0194BC5E3E', '14907587-8662-4f0e-82f6-8092676fc01c', 704, 9, 'disponible', '2026-09-15 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3455, 5, 403, 138, 'F2L5V03XMPD7HB', '352941110309650', '352941110309651', '8904903205A094EB927CAB532821009B', '37572cca-6fdf-4fe9-a349-ec7c80cf0356', 10, 10, 'vendido', '2026-07-07 21:10:55.388878', '2026-07-22 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3456, 5, 403, 138, 'F175V03LGSLFVY', '359812088189251', '359812088189252', '8904903205F16F6A9611FD9E267D3D51', '3945d588-98e3-4dbe-a4f5-7e1dea3c07f6', 10, 10, 'vendido', '2026-07-07 19:10:55.388878', '2026-07-22 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3457, 5, 403, 138, 'DNP5S0313YKUYV', '358492108223521', '358492108223522', '8904903205E9D9848273FD012B9B3DE6', '4018d301-1144-43dd-bd2f-44d576201a66', 704, 9, 'disponible', '2026-09-07 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3458, 5, 403, 138, 'M035S03DABG9H4', '352941113554642', '352941113554643', '8904903205951787E68CE8979D609757', '856b2291-e1fa-436c-8356-7a6c193a2e4b', 704, 9, 'disponible', '2026-09-05 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3459, 5, 403, 138, 'F2L5S03TWMSTXB', '351829448898433', '351829448898434', '8904903205E5BAD8275C918895A6DBC3', '8f1fddf6-a2f3-4e23-ac1b-0b1349c35f5f', 704, 9, 'disponible', '2026-09-14 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3460, 5, 403, 138, 'DX35S03UV2MSM1', '351829449849904', '351829449849905', '8904903205DD8151485111B54227F5BB', 'daa5f4b1-f7cf-4475-abf8-92a00b3a94b1', 704, 9, 'disponible', '2026-09-08 21:10:55.388878', NULL);
INSERT INTO public.unidadproducto VALUES (3461, 5, 402, 139, 'DX35V02STWD53F', '358492100794430', '358492100794431', '890490320554D8320FCF638750ADD7BF', '6d24e5e8-0d77-448a-bf85-d42ebf594052', 10, 10, 'vendido', '2026-09-16 21:10:55.388878', '2026-10-01 21:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3462, 5, 402, 139, 'M035V02QL5WF81', '351829443061371', '351829443061372', '8904903205E12908B31800DFE24157FF', '8aa6eb79-f923-4bfb-83ab-786f33ea080a', 10, 10, 'vendido', '2026-09-16 19:10:55.388878', '2026-10-01 19:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3463, 5, 402, 139, 'C395V02K44JD9B', '358492106837302', '358492106837303', '89049032053060CA1CC3C38E9EF9DE38', 'a16b07d6-3e78-4cd1-b2cd-54cc1013807b', 10, 10, 'vendido', '2026-09-16 17:10:55.388878', '2026-10-01 17:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3464, 5, 402, 139, 'F2L5V02E85TE6C', '351829442015583', '351829442015584', '890490320567A088B7D77C8F5D797ED0', '311b6a05-58b3-4fd1-9bcf-5e565c198c65', 10, 10, 'vendido', '2026-09-16 15:10:55.388878', '2026-10-01 15:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3465, 5, 402, 139, 'G6T5V02JTGXK0T', '351829440642834', '351829440642835', '89049032056B3D6679CF67926B928763', 'b3024eb5-ef80-4004-94e2-6d4303a78ee0', 10, 10, 'vendido', '2026-09-16 13:10:55.388878', '2026-10-01 13:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3466, 5, 402, 139, 'G6T5V02D09JKSE', '351829445519035', '351829445519036', '89049032052666D68E08369BAC63F2B3', '6585d7fd-6068-4f31-9ff2-9bcb460b6687', 10, 10, 'vendido', '2026-09-16 11:10:55.388878', '2026-10-01 11:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3467, 5, 402, 139, 'K4L5V024DWQVSJ', '352941113197326', '352941113197327', '89049032056A9A0BC7DD9DAFF00E9232', '5c8f9259-db8f-4e74-825e-f5c9321efa5b', 10, 10, 'vendido', '2026-09-16 09:10:55.388878', '2026-10-01 09:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3468, 5, 402, 139, 'K4L5V0212AXRC8', '358492107824097', '358492107824098', '890490320515E77388B81442231B78DD', '1feb663e-678b-4c21-a8bc-5b0407f9abd7', 10, 10, 'vendido', '2026-09-16 07:10:55.388878', '2026-10-01 07:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3469, 5, 402, 139, 'M035V021E3GZK2', '354019232750838', '354019232750839', '890490320525BA3630CC89C2122BF6E0', 'a3a23003-cd41-43f0-b789-cae544443fb8', 10, 10, 'vendido', '2026-09-16 05:10:55.388878', '2026-10-01 05:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3470, 5, 402, 139, 'DX35V02MP6YZRG', '351829449641909', '351829449641900', '8904903205EBA6194A7AB5A4738C97E2', 'c7b8cf12-1117-43b2-bbfb-16c8414d81c5', 10, 10, 'vendido', '2026-09-16 03:10:55.388878', '2026-10-01 03:10:55.388878');
INSERT INTO public.unidadproducto VALUES (3471, 5, 402, 139, 'H025V02YSPLZ0K', '351829440822510', '351829440822511', '89049032054D9B14C2B1ED8140EC6D25', 'f5c5bf8e-12f0-42e5-a816-46fd0d9756f4', 10, 10, 'vendido', '2026-09-16 01:10:55.388878', '2026-10-01 01:10:55.388878');
INSERT INTO public.unidadproducto VALUES (2728, 1, 829, 1, 'SN-1791246767645', '3591791246767645', '3581791246767645', 'EID1791246767645', 'aca48fc7-eaec-4df8-b512-7007716f88e1', NULL, NULL, 'disponible', '2026-10-06 00:32:47.707691', NULL);


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.usuario VALUES (1, 'Administrador General', 'admin@trazabilidad.com', '$argon2id$v=19$m=65536,t=3,p=4$n2NO9R8gbYXiJv/20CSAAA$i/U/T6lbbLKxQM8U/y2fBNm1MtzH3tBNiZc2RsZDvmw', '2026-09-09 21:41:16.779098', true);
INSERT INTO public.usuario VALUES (2, 'Administrador General', 'admin@techimport.com', '$argon2id$v=19$m=65536,t=3,p=4$TuZipVPyGqb+BYr4vgwu1w$pcXfddfsi6A+m7IQAHBY9ZawR3T0u+unUVskVEFOCtY', '2026-09-09 21:41:17.010775', true);
INSERT INTO public.usuario VALUES (3, 'Administrador General', 'admin@andinadigital.com', '$argon2id$v=19$m=65536,t=3,p=4$4KdSKUkUap6mf1VNz2GcHg$7Ue7Lu+Wz/K07eje9+ym316cJKOACnJBUPZyy66zVL4', '2026-09-09 21:41:17.230104', true);
INSERT INTO public.usuario VALUES (4, 'Administrador General', 'admin@electrosur.com', '$argon2id$v=19$m=65536,t=3,p=4$Inxm5KNlpoikT57zV6Uj4g$DzUvkHzM8/BEL5YB3+ySKx+A7rwJ8Wo26GuYiYnZ82Y', '2026-09-09 21:41:17.436796', true);
INSERT INTO public.usuario VALUES (5, 'Administrador General', 'admin@cochawireless.com', '$argon2id$v=19$m=65536,t=3,p=4$nKTJzUdgcGVeEqd6CN+QYQ$4AQvcboiv2qagm58LoeY2B8++RBQPhgzxprtsKnRAUM', '2026-09-09 21:41:17.64128', true);


--
-- Data for Name: usuariotenant; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.usuariotenant VALUES (1, 1, 1, '2026-09-09 21:41:16.789512');
INSERT INTO public.usuariotenant VALUES (2, 2, 2, '2026-09-09 21:41:17.010775');
INSERT INTO public.usuariotenant VALUES (3, 3, 3, '2026-09-09 21:41:17.230104');
INSERT INTO public.usuariotenant VALUES (4, 4, 4, '2026-09-09 21:41:17.44186');
INSERT INTO public.usuariotenant VALUES (5, 5, 5, '2026-09-09 21:41:17.649854');
INSERT INTO public.usuariotenant VALUES (1553, 1, 2, '2026-10-05 00:14:31.793229');
INSERT INTO public.usuariotenant VALUES (1554, 1, 3, '2026-10-05 00:14:31.823897');
INSERT INTO public.usuariotenant VALUES (1555, 1, 4, '2026-10-05 00:14:31.854281');
INSERT INTO public.usuariotenant VALUES (1556, 1, 5, '2026-10-05 00:14:31.861104');


--
-- Data for Name: usuariotenantrol; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.usuariotenantrol VALUES (2, 2, 2);
INSERT INTO public.usuariotenantrol VALUES (3, 3, 2);
INSERT INTO public.usuariotenantrol VALUES (4, 4, 2);
INSERT INTO public.usuariotenantrol VALUES (5, 5, 2);
INSERT INTO public.usuariotenantrol VALUES (310, 1, 1);
INSERT INTO public.usuariotenantrol VALUES (311, 1, 2);
INSERT INTO public.usuariotenantrol VALUES (312, 1553, 1);
INSERT INTO public.usuariotenantrol VALUES (313, 1554, 1);
INSERT INTO public.usuariotenantrol VALUES (314, 1555, 1);
INSERT INTO public.usuariotenantrol VALUES (315, 1556, 1);


--
-- Data for Name: varianteproducto; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.varianteproducto VALUES (1, 1, '128GB', 'Negro', 'DEMO-GS24-128-NEG', 699.00);
INSERT INTO public.varianteproducto VALUES (2, 1, '256GB', 'Azul', 'DEMO-GS24-256-AZU', 799.00);
INSERT INTO public.varianteproducto VALUES (3, 2, '128GB', 'Blanco', 'DEMO-IP15-128-BLA', 899.00);
INSERT INTO public.varianteproducto VALUES (4, 3, '-', 'Blanco', 'DEMO-CARG-20W-BLA', 15.00);
INSERT INTO public.varianteproducto VALUES (5, 4, '-', 'Negro', 'DEMO-FUND-UNI-NEG', 9.00);
INSERT INTO public.varianteproducto VALUES (6, 5, '-', 'Negro', 'DEMO-SWF2-NEG', 129.00);
INSERT INTO public.varianteproducto VALUES (7, 6, '-', 'Blanco', 'DEMO-TWS-BLA', 59.00);
INSERT INTO public.varianteproducto VALUES (8, 7, '128GB', 'Azul Estelar', 'SKU-1790796063796', 599.00);
INSERT INTO public.varianteproducto VALUES (9, 8, '', '', 'SKU-T-1790796064527', 100.00);
INSERT INTO public.varianteproducto VALUES (724, 699, '128GB', 'Azul Estelar', 'SKU-1791246753123', 599.00);
INSERT INTO public.varianteproducto VALUES (725, 700, '', '', 'SKU-T-1791246753644', 100.00);
INSERT INTO public.varianteproducto VALUES (159, 149, '128GB', 'Azul Estelar', 'SKU-1790800868062', 599.00);
INSERT INTO public.varianteproducto VALUES (84, 83, '256GB', 'Titán Natural', 'SKU-IPH16-1790797451638', 999.00);
INSERT INTO public.varianteproducto VALUES (85, 84, '128GB', 'Azul Estelar', 'SKU-1790797561261', 599.00);
INSERT INTO public.varianteproducto VALUES (86, 85, '', '', 'SKU-T-1790797561928', 100.00);
INSERT INTO public.varianteproducto VALUES (160, 150, '', '', 'SKU-T-1790800868814', 100.00);
INSERT INTO public.varianteproducto VALUES (18, 17, '256GB', 'Titán Natural', 'SKU-IPH16-1790796071891', 999.00);
INSERT INTO public.varianteproducto VALUES (19, 18, '128GB', 'Azul Estelar', 'SKU-1790797000810', 599.00);
INSERT INTO public.varianteproducto VALUES (20, 19, '', '', 'SKU-T-1790797001510', 100.00);
INSERT INTO public.varianteproducto VALUES (95, 94, '256GB', 'Titán Natural', 'SKU-IPH16-1790797569880', 999.00);
INSERT INTO public.varianteproducto VALUES (29, 28, '256GB', 'Titán Natural', 'SKU-IPH16-1790797008887', 999.00);
INSERT INTO public.varianteproducto VALUES (30, 29, '128GB', 'Azul Estelar', 'SKU-1790797101941', 599.00);
INSERT INTO public.varianteproducto VALUES (31, 30, '', '', 'SKU-T-1790797102625', 100.00);
INSERT INTO public.varianteproducto VALUES (96, 95, '128GB', 'Azul Estelar', 'SKU-1790797590688', 599.00);
INSERT INTO public.varianteproducto VALUES (97, 96, '', '', 'SKU-T-1790797591388', 100.00);
INSERT INTO public.varianteproducto VALUES (169, 159, '256GB', 'Titán Natural', 'SKU-IPH16-1790800876457', 999.00);
INSERT INTO public.varianteproducto VALUES (40, 39, '256GB', 'Titán Natural', 'SKU-IPH16-1790797109882', 999.00);
INSERT INTO public.varianteproducto VALUES (41, 40, '128GB', 'Azul Estelar', 'SKU-1790797133789', 599.00);
INSERT INTO public.varianteproducto VALUES (42, 41, '', '', 'SKU-T-1790797134417', 100.00);
INSERT INTO public.varianteproducto VALUES (174, 162, '128GB', 'Azul Estelar', 'SKU-1790801138535', 599.00);
INSERT INTO public.varianteproducto VALUES (175, 163, '', '', 'SKU-T-1790801139279', 100.00);
INSERT INTO public.varianteproducto VALUES (106, 105, '256GB', 'Titán Natural', 'SKU-IPH16-1790797598956', 999.00);
INSERT INTO public.varianteproducto VALUES (107, 106, '128GB', 'Azul Estelar', 'SKU-1790799349929', 599.00);
INSERT INTO public.varianteproducto VALUES (108, 107, '', '', 'SKU-T-1790799350668', 100.00);
INSERT INTO public.varianteproducto VALUES (51, 50, '256GB', 'Titán Natural', 'SKU-IPH16-1790797141219', 999.00);
INSERT INTO public.varianteproducto VALUES (52, 51, '128GB', 'Azul Estelar', 'SKU-1790797161168', 599.00);
INSERT INTO public.varianteproducto VALUES (53, 52, '', '', 'SKU-T-1790797161882', 100.00);
INSERT INTO public.varianteproducto VALUES (117, 116, '256GB', 'Titán Natural', 'SKU-IPH16-1790799357995', 999.00);
INSERT INTO public.varianteproducto VALUES (184, 172, '256GB', 'Titán Natural', 'SKU-IPH16-1790801148737', 999.00);
INSERT INTO public.varianteproducto VALUES (185, 173, '128GB', 'Azul Estelar', 'SKU-1790801208117', 599.00);
INSERT INTO public.varianteproducto VALUES (62, 61, '256GB', 'Titán Natural', 'SKU-IPH16-1790797169105', 999.00);
INSERT INTO public.varianteproducto VALUES (63, 62, '128GB', 'Azul Estelar', 'SKU-1790797386951', 599.00);
INSERT INTO public.varianteproducto VALUES (64, 63, '', '', 'SKU-T-1790797388714', 100.00);
INSERT INTO public.varianteproducto VALUES (186, 174, '', '', 'SKU-T-1790801209314', 100.00);
INSERT INTO public.varianteproducto VALUES (398, 384, '256GB', 'Titanio Desierto', 'IP16PM-256-DES', 1299.00);
INSERT INTO public.varianteproducto VALUES (399, 384, '512GB', 'Titanio Natural', 'IP16PM-512-NAT', 1499.00);
INSERT INTO public.varianteproducto VALUES (400, 384, '256GB', 'Titanio Negro', 'IP16PM-256-NEG', 1299.00);
INSERT INTO public.varianteproducto VALUES (401, 385, '128GB', 'Titanio Blanco', 'IP16P-128-BLA', 1099.00);
INSERT INTO public.varianteproducto VALUES (73, 72, '256GB', 'Titán Natural', 'SKU-IPH16-1790797397033', 999.00);
INSERT INTO public.varianteproducto VALUES (74, 73, '128GB', 'Azul Estelar', 'SKU-1790797443569', 599.00);
INSERT INTO public.varianteproducto VALUES (75, 74, '', '', 'SKU-T-1790797444274', 100.00);
INSERT INTO public.varianteproducto VALUES (402, 385, '256GB', 'Titanio Natural', 'IP16P-256-NAT', 1199.00);
INSERT INTO public.varianteproducto VALUES (195, 183, '256GB', 'Titán Natural', 'SKU-IPH16-1790801217903', 999.00);
INSERT INTO public.varianteproducto VALUES (403, 385, '128GB', 'Titanio Negro', 'IP16P-128-NEG', 1099.00);
INSERT INTO public.varianteproducto VALUES (404, 386, '128GB', 'Azul Ultramar', 'IP16-128-AZU', 899.00);
INSERT INTO public.varianteproducto VALUES (405, 386, '256GB', 'Verde Azulado', 'IP16-256-VRD', 999.00);
INSERT INTO public.varianteproducto VALUES (406, 386, '128GB', 'Negro', 'IP16-128-NEG', 899.00);
INSERT INTO public.varianteproducto VALUES (134, 124, '128GB', 'Azul Estelar', 'SKU-1790799748518', 599.00);
INSERT INTO public.varianteproducto VALUES (135, 125, '', '', 'SKU-T-1790799749289', 100.00);
INSERT INTO public.varianteproducto VALUES (407, 387, '256GB', 'Titanio Azul', 'IP15PM-256-AZU', 1149.00);
INSERT INTO public.varianteproducto VALUES (408, 387, '512GB', 'Titanio Natural', 'IP15PM-512-NAT', 1349.00);
INSERT INTO public.varianteproducto VALUES (409, 388, '128GB', 'Titanio Negro', 'IP15P-128-NEG', 999.00);
INSERT INTO public.varianteproducto VALUES (410, 388, '256GB', 'Titanio Blanco', 'IP15P-256-BLA', 1099.00);
INSERT INTO public.varianteproducto VALUES (411, 2, '128GB', 'Azul', 'IP15-128-AZU', 799.00);
INSERT INTO public.varianteproducto VALUES (412, 2, '256GB', 'Rosa', 'IP15-256-ROS', 899.00);
INSERT INTO public.varianteproducto VALUES (413, 2, '128GB', 'Negro', 'IP15-128-NEG', 799.00);
INSERT INTO public.varianteproducto VALUES (414, 389, '-', 'Blanco', 'APP2-USBC-BLA', 249.00);
INSERT INTO public.varianteproducto VALUES (144, 134, '256GB', 'Titán Natural', 'SKU-IPH16-1790799757077', 999.00);
INSERT INTO public.varianteproducto VALUES (145, 135, '128GB', 'Azul Estelar', 'SKU-1790800244676', 599.00);
INSERT INTO public.varianteproducto VALUES (146, 136, '', '', 'SKU-T-1790800245355', 100.00);
INSERT INTO public.varianteproducto VALUES (415, 390, '20W', 'Blanco', 'AP20W-USB-BLA', 29.00);
INSERT INTO public.varianteproducto VALUES (155, 145, '256GB', 'Titán Natural', 'SKU-IPH16-1790800252489', 999.00);
INSERT INTO public.varianteproducto VALUES (829, 789, '256GB', 'Titán Natural', 'SKU-IPH16-1791246767645', 999.00);


--
-- Data for Name: venta; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: ventadetalle; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: ventaunidad; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: actorcadena_idactor_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.actorcadena_idactor_seq', 1122, true);


--
-- Name: alerta_idalerta_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.alerta_idalerta_seq', 82, true);


--
-- Name: bitacora_idbitacora_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bitacora_idbitacora_seq', 2649, true);


--
-- Name: catalogotenant_idcatalogotenant_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.catalogotenant_idcatalogotenant_seq', 968, true);


--
-- Name: categoria_idcategoria_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categoria_idcategoria_seq', 307, true);


--
-- Name: certificacion_idcertificacion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.certificacion_idcertificacion_seq', 36, true);


--
-- Name: codigoqr_idcodigoqr_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.codigoqr_idcodigoqr_seq', 512, true);


--
-- Name: compra_idcompra_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.compra_idcompra_seq', 401, true);


--
-- Name: compradetalle_idcompradetalle_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.compradetalle_idcompradetalle_seq', 461, true);


--
-- Name: condiciontransporte_idcondicion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.condiciontransporte_idcondicion_seq', 38, true);


--
-- Name: consultatrazabilidad_idconsulta_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.consultatrazabilidad_idconsulta_seq', 25, true);


--
-- Name: devolucion_iddevolucion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.devolucion_iddevolucion_seq', 1, false);


--
-- Name: devolucionunidad_iddevolucionunidad_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.devolucionunidad_iddevolucionunidad_seq', 1, false);


--
-- Name: documentounidad_iddocumento_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.documentounidad_iddocumento_seq', 285, true);


--
-- Name: envio_idenvio_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.envio_idenvio_seq', 465, true);


--
-- Name: enviounidad_idenviounidad_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.enviounidad_idenviounidad_seq', 412, true);


--
-- Name: eventotrazabilidad_idevento_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.eventotrazabilidad_idevento_seq', 79, true);


--
-- Name: eventounidad_ideventounidad_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.eventounidad_ideventounidad_seq', 71, true);


--
-- Name: garantiaunidad_idgarantia_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.garantiaunidad_idgarantia_seq', 1, false);


--
-- Name: notificacion_idnotificacion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.notificacion_idnotificacion_seq', 171, true);


--
-- Name: pago_idpago_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pago_idpago_seq', 1, false);


--
-- Name: permiso_idpermiso_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.permiso_idpermiso_seq', 38, true);


--
-- Name: plan_idplan_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.plan_idplan_seq', 10, true);


--
-- Name: producto_idproducto_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.producto_idproducto_seq', 1481, true);


--
-- Name: productocertificacion_idproductocertificacion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.productocertificacion_idproductocertificacion_seq', 42, true);


--
-- Name: recepcioncompra_idrecepcion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.recepcioncompra_idrecepcion_seq', 109, true);


--
-- Name: recepciondetalle_idrecepciondetalle_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.recepciondetalle_idrecepciondetalle_seq', 203, true);


--
-- Name: registroblockchain_idregistro_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.registroblockchain_idregistro_seq', 30, true);


--
-- Name: reportesospecha_idreporte_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reportesospecha_idreporte_seq', 9, true);


--
-- Name: reportesospechaevidencia_idevidencia_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reportesospechaevidencia_idevidencia_seq', 1, false);


--
-- Name: rol_idrol_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.rol_idrol_seq', 15, true);


--
-- Name: rolpermiso_idrolpermiso_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.rolpermiso_idrolpermiso_seq', 118, true);


--
-- Name: suscripcion_idsuscripcion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.suscripcion_idsuscripcion_seq', 30, true);


--
-- Name: tenant_backup_idbackup_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tenant_backup_idbackup_seq', 1, false);


--
-- Name: tenant_backup_schedule_idschedule_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tenant_backup_schedule_idschedule_seq', 1, false);


--
-- Name: tenant_idtenant_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tenant_idtenant_seq', 1171, true);


--
-- Name: tokenrecuperacion_idtoken_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tokenrecuperacion_idtoken_seq', 84, true);


--
-- Name: tokenrefresco_idtoken_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tokenrefresco_idtoken_seq', 1318, true);


--
-- Name: ubicacion_idubicacion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ubicacion_idubicacion_seq', 453, true);


--
-- Name: unidadproducto_idunidad_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.unidadproducto_idunidad_seq', 5898, true);


--
-- Name: usuario_idusuario_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usuario_idusuario_seq', 1164, true);


--
-- Name: usuariotenant_idusuariotenant_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usuariotenant_idusuariotenant_seq', 2718, true);


--
-- Name: usuariotenantrol_idusuariotenantrol_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usuariotenantrol_idusuariotenantrol_seq', 624, true);


--
-- Name: varianteproducto_idvariante_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.varianteproducto_idvariante_seq', 1566, true);


--
-- Name: venta_idventa_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.venta_idventa_seq', 1, false);


--
-- Name: ventadetalle_idventadetalle_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ventadetalle_idventadetalle_seq', 1, false);


--
-- Name: ventaunidad_idventaunidad_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ventaunidad_idventaunidad_seq', 1, false);


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

\unrestrict Mp9yQg2OtHJYnUObWbfT5UNkMyKIMaIk5Wg42ZAmWADyuVq4jyv1c6yWll8wt9f

