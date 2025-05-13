--
-- PostgreSQL database dump
--

-- Dumped from database version 11.21
-- Dumped by pg_dump version 14.15 (Ubuntu 14.15-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';

SET default_tablespace = '';

--
-- Name: activation_attribute_trail; Type: TABLE; Schema: public; Owner: tpnpms
--

CREATE TABLE activation_attribute_trail (
                                            id uuid DEFAULT uuid_generate_v4() NOT NULL,
                                            created_at timestamp without time zone DEFAULT now() NOT NULL,
                                            created_by_id character varying NOT NULL,
                                            created_by_name bytea NOT NULL,
                                            activation_tracking_id uuid NOT NULL,
                                            old_value jsonb NOT NULL,
                                            new_value jsonb NOT NULL,
                                            order_number character varying NOT NULL,
                                            old_value_bak jsonb,
                                            new_value_bak jsonb,
                                            is_encrypted boolean DEFAULT true
);


ALTER TABLE activation_attribute_trail OWNER TO tpnpms;

--
-- Name: activation_product_attributes; Type: TABLE; Schema: public; Owner: tpnpms
--

CREATE TABLE activation_product_attributes (
                                               created_at timestamp with time zone DEFAULT now() NOT NULL,
                                               updated_at timestamp with time zone DEFAULT now(),
                                               updated_by_id character varying,
                                               deleted_at timestamp with time zone,
                                               id uuid DEFAULT uuid_generate_v4() NOT NULL,
                                               attribute_name character varying(100),
                                               attribute_value bytea,
                                               prev_attribute_value bytea,
                                               activation_id uuid,
                                               updated_by_name bytea,
                                               attribute_value_bak character varying,
                                               prev_attribute_value_bak character varying,
                                               is_encrypted boolean DEFAULT true,
                                               attribute_label character varying(100)
);


ALTER TABLE activation_product_attributes OWNER TO tpnpms;

--
-- Name: activation_tracking_attachments; Type: TABLE; Schema: public; Owner: tpnpms
--

CREATE TABLE activation_tracking_attachments (
                                                 created_at timestamp with time zone DEFAULT now() NOT NULL,
                                                 updated_at timestamp with time zone DEFAULT now(),
                                                 updated_by_id character varying,
                                                 deleted_at timestamp with time zone,
                                                 id uuid DEFAULT uuid_generate_v4() NOT NULL,
                                                 filename character varying NOT NULL,
                                                 ori_filename character varying NOT NULL,
                                                 attachment_type character varying DEFAULT 'other'::character varying NOT NULL,
                                                 size integer DEFAULT 0 NOT NULL,
                                                 activation_tracking_task_id uuid NOT NULL,
                                                 url character varying NOT NULL,
                                                 updated_by_name bytea,
                                                 is_private boolean DEFAULT false
);


ALTER TABLE activation_tracking_attachments OWNER TO tpnpms;

--
-- Name: activation_tracking_inputter; Type: TABLE; Schema: public; Owner: tpnpms
--

CREATE TABLE activation_tracking_inputter (
                                              created_at timestamp with time zone DEFAULT now() NOT NULL,
                                              updated_at timestamp with time zone DEFAULT now(),
                                              updated_by_id character varying,
                                              deleted_at timestamp with time zone,
                                              id uuid DEFAULT uuid_generate_v4() NOT NULL,
                                              activation_id uuid,
                                              user_inputer bytea,
                                              nik bytea,
                                              name bytea,
                                              kcontact bytea,
                                              updated_by_name bytea
);


ALTER TABLE activation_tracking_inputter OWNER TO tpnpms;

--
-- Name: activation_tracking_tasks; Type: TABLE; Schema: public; Owner: tpnpms
--

CREATE TABLE activation_tracking_tasks (
                                           created_at timestamp with time zone DEFAULT now() NOT NULL,
                                           updated_at timestamp with time zone DEFAULT now(),
                                           updated_by_id character varying,
                                           deleted_at timestamp with time zone,
                                           id uuid DEFAULT uuid_generate_v4() NOT NULL,
                                           task_phase character varying NOT NULL,
                                           task_key character varying,
                                           task_status character varying(15) DEFAULT 'waiting'::character varying NOT NULL,
                                           user_group jsonb DEFAULT '[]'::jsonb,
                                           task_type character varying(10) NOT NULL,
                                           start_date timestamp with time zone,
                                           due_date timestamp with time zone,
                                           end_date timestamp with time zone,
                                           sla_target integer,
                                           sla_realization_in_seconds integer,
                                           is_no_action boolean DEFAULT false NOT NULL,
                                           action character varying[] DEFAULT '{}'::character varying[] NOT NULL,
                                           input_action character varying,
                                           current_subtask_index integer,
                                           latest_subtask_key character varying,
                                           task_order integer NOT NULL,
                                           is_shipping boolean DEFAULT false NOT NULL,
                                           reference jsonb DEFAULT '{}'::jsonb,
                                           "isOrderPhase" boolean DEFAULT false,
                                           oca_status character varying,
                                           activation_tracking_id uuid,
                                           parent_task uuid,
                                           updated_by_name bytea
);


ALTER TABLE activation_tracking_tasks OWNER TO tpnpms;

--
-- Name: activation_trackings; Type: TABLE; Schema: public; Owner: tpnpms
--

CREATE TABLE activation_trackings (
                                      created_at timestamp with time zone DEFAULT now() NOT NULL,
                                      updated_at timestamp with time zone DEFAULT now(),
                                      updated_by_id character varying,
                                      deleted_at timestamp with time zone,
                                      id uuid DEFAULT uuid_generate_v4() NOT NULL,
                                      order_id character varying,
                                      order_item_id uuid,
                                      order_date timestamp with time zone DEFAULT now() NOT NULL,
                                      payment_type character varying(10) DEFAULT 'prepaid'::character varying,
                                      order_type character varying(25) DEFAULT 'New'::character varying NOT NULL,
                                      order_source character varying(10) DEFAULT 'fabd'::character varying NOT NULL,
                                      order_number character varying(50),
                                      product_source character varying(10) DEFAULT 'internal'::character varying,
                                      order_detail jsonb DEFAULT '{}'::jsonb,
                                      ecosystem_id uuid,
                                      ecosystem_name character varying(100),
                                      service_id uuid,
                                      service_name character varying(100),
                                      service_description character varying,
                                      service_image character varying,
                                      activation_status character varying(15) DEFAULT 'waiting'::character varying NOT NULL,
                                      product_id uuid,
                                      product_name character varying(100),
                                      final_sla_target_in_seconds integer DEFAULT 0 NOT NULL,
                                      final_sla_realization_in_seconds integer DEFAULT 0 NOT NULL,
                                      final_sla_status character varying(20) DEFAULT 'in_progress'::character varying NOT NULL,
                                      ncx_order_source character varying,
                                      fabd_order_source character varying,
                                      current_task_index integer DEFAULT 0,
                                      latest_task_key character varying NOT NULL,
                                      latest_task_phase character varying,
                                      latest_subtask_key character varying,
                                      latest_subtask_phase character varying,
                                      division character varying(100),
                                      unit character varying(25),
                                      witel character varying(25),
                                      current_user_group jsonb DEFAULT '[]'::jsonb,
                                      order_channel jsonb DEFAULT '{}'::jsonb,
                                      webhook_payload_data jsonb DEFAULT '{}'::jsonb,
                                      callback_payload_data jsonb DEFAULT '{}'::jsonb,
                                      ncx_row_id character varying(25),
                                      cancellation_notes character varying,
                                      due_date timestamp with time zone,
                                      parent_id uuid,
                                      customer_name_bidx character varying,
                                      customer_name bytea,
                                      updated_by_name bytea,
                                      notif_date timestamp(6) with time zone,
                                      billing_mode character varying(25),
                                      updated_by_name_bak character varying,
                                      order_detail_bak jsonb,
                                      business_model character varying(50),
                                      package_existing character varying(20),
                                      bundling character varying(20),
                                      installation_type character varying(20),
                                      is_encrypted boolean DEFAULT true,
                                      invoice_number character varying(30),
                                      order_channel_id uuid,
                                      transaction_type character varying(10)
);


ALTER TABLE activation_trackings OWNER TO tpnpms;

--
-- Name: ba_activations; Type: TABLE; Schema: public; Owner: tpnpms
--

CREATE TABLE ba_activations (
                                created_at timestamp with time zone DEFAULT now() NOT NULL,
                                updated_at timestamp with time zone DEFAULT now(),
                                updated_by_id character varying,
                                deleted_at timestamp with time zone,
                                id uuid DEFAULT uuid_generate_v4() NOT NULL,
                                activation_id uuid,
                                task_id uuid,
                                sub_task_id uuid,
                                baa_number character varying(255),
                                order_number character varying(255),
                                external_baa_number character varying(255),
                                external_order_number character varying(255),
                                ori_doc_size integer,
                                verified_doc_size double precision,
                                verification_by character varying(50) NOT NULL,
                                oca_wa_msg_id character varying(255),
                                oca_wa_msg_status character varying(50),
                                status character varying(50) NOT NULL,
                                verification_serial_number character varying(255),
                                verification_token text,
                                verified_by character varying(50),
                                verified_at timestamp with time zone,
                                rejected_by character varying(50),
                                rejected_at timestamp with time zone,
                                product_name character varying(100),
                                service_name character varying(100),
                                recipient_name bytea,
                                recipient_email bytea,
                                recipient_wa_number bytea,
                                updated_by_name bytea,
                                ori_doc_path text,
                                ori_doc_filename character varying(255),
                                verified_doc_path text,
                                verified_doc_filename character varying(255),
                                recipient_wa_number_bak character varying,
                                recipient_name_bak character varying,
                                recipient_email_bak character varying
);


ALTER TABLE ba_activations OWNER TO tpnpms;
--
-- Name: child_requests; Type: TABLE; Schema: public; Owner: tpnpms
--

CREATE TABLE child_requests (
                                created_at timestamp with time zone DEFAULT now() NOT NULL,
                                updated_at timestamp with time zone DEFAULT now(),
                                updated_by_id character varying,
                                deleted_at timestamp with time zone,
                                id uuid DEFAULT uuid_generate_v4() NOT NULL,
                                parent_key character varying NOT NULL,
                                processed boolean DEFAULT false NOT NULL,
                                request_data jsonb DEFAULT '{}'::jsonb,
                                parent_id uuid,
                                updated_by_name bytea
);


ALTER TABLE child_requests OWNER TO tpnpms;

--
-- Name: holidays; Type: TABLE; Schema: public; Owner: tpnpms
--

CREATE TABLE holidays (
                          created_at timestamp with time zone DEFAULT now() NOT NULL,
                          updated_at timestamp with time zone DEFAULT now(),
                          updated_by_id character varying,
                          deleted_at timestamp with time zone,
                          id uuid DEFAULT uuid_generate_v4() NOT NULL,
                          holiday_date date NOT NULL,
                          name character varying(255) NOT NULL,
                          description character varying,
                          is_active boolean DEFAULT false NOT NULL,
                          updated_by_name bytea
);


ALTER TABLE holidays OWNER TO tpnpms;

--
-- Name: migrations; Type: TABLE; Schema: public; Owner: tpnpms
--

CREATE TABLE migrations (
                            id integer NOT NULL,
                            "timestamp" bigint NOT NULL,
                            name character varying NOT NULL
);


ALTER TABLE migrations OWNER TO tpnpms;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: tpnpms
--

CREATE SEQUENCE migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE migrations_id_seq OWNER TO tpnpms;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tpnpms
--

ALTER SEQUENCE migrations_id_seq OWNED BY migrations.id;


--
-- Name: name_text_heap; Type: TABLE; Schema: public; Owner: tpnpms
--

CREATE TABLE name_text_heap (
                                id uuid DEFAULT uuid_generate_v4() NOT NULL,
                                content character varying NOT NULL,
                                hash character varying NOT NULL
);


ALTER TABLE name_text_heap OWNER TO tpnpms;

--
-- Name: parent_requests; Type: TABLE; Schema: public; Owner: tpnpms
--

CREATE TABLE parent_requests (
                                 created_at timestamp with time zone DEFAULT now() NOT NULL,
                                 updated_at timestamp with time zone DEFAULT now(),
                                 updated_by_id character varying,
                                 deleted_at timestamp with time zone,
                                 id uuid DEFAULT uuid_generate_v4() NOT NULL,
                                 key bytea NOT NULL,
                                 processed boolean DEFAULT false NOT NULL,
                                 request_data jsonb DEFAULT '{}'::jsonb,
                                 updated_by_name bytea
);


ALTER TABLE parent_requests OWNER TO tpnpms;

--
-- Name: product_activation_attachments; Type: TABLE; Schema: public; Owner: tpnpms
--

CREATE TABLE product_activation_attachments (
                                                created_at timestamp with time zone DEFAULT now() NOT NULL,
                                                updated_at timestamp with time zone DEFAULT now(),
                                                updated_by_id character varying,
                                                deleted_at timestamp with time zone,
                                                id uuid DEFAULT uuid_generate_v4() NOT NULL,
                                                filename character varying NOT NULL,
                                                ori_filename character varying NOT NULL,
                                                attachment_type character varying DEFAULT 'other'::character varying NOT NULL,
                                                size integer DEFAULT 0 NOT NULL,
                                                product_activation_state_log_id uuid NOT NULL,
                                                requested_activation_status character varying(25) NOT NULL,
                                                confirmed_activation_status character varying(25),
                                                url character varying NOT NULL,
                                                updated_by_name bytea
);


ALTER TABLE product_activation_attachments OWNER TO tpnpms;

--
-- Name: product_activation_state; Type: TABLE; Schema: public; Owner: tpnpms
--

CREATE TABLE product_activation_state (
                                          created_at timestamp with time zone DEFAULT now() NOT NULL,
                                          updated_at timestamp with time zone DEFAULT now(),
                                          updated_by_id character varying,
                                          deleted_at timestamp with time zone,
                                          id uuid DEFAULT uuid_generate_v4() NOT NULL,
                                          last_activation_id uuid NOT NULL,
                                          requested_activation_status character varying(25) NOT NULL,
                                          confirmed_activation_status character varying(25),
                                          segment character varying(255),
                                          channel_name character varying(100),
                                          ecosystem_id uuid NOT NULL,
                                          ecosystem_name character varying(255) NOT NULL,
                                          citem character varying(25),
                                          serial_number bytea,
                                          service_id uuid NOT NULL,
                                          service_name character varying(255) NOT NULL,
                                          activation_date timestamp with time zone,
                                          confirmed_activation_date timestamp with time zone,
                                          request_activation_date timestamp with time zone,
                                          last_order_number character varying(50) NOT NULL,
                                          sid character varying(20),
                                          notes character varying(255),
                                          service_image character varying,
                                          witel character varying(50),
                                          row_id character varying(25),
                                          customer_name bytea,
                                          updated_by_name bytea,
                                          customer_name_bidx character varying,
                                          product_id uuid,
                                          product_name character varying,
                                          is_cancelled boolean,
                                          serial_number_bak character varying,
                                          serial_number_bidx character varying,
                                          is_encrypted boolean DEFAULT true,
                                          order_channel_id uuid
);


ALTER TABLE product_activation_state OWNER TO tpnpms;

--
-- Name: product_activation_state_audit_trail; Type: TABLE; Schema: public; Owner: tpnpms
--

CREATE TABLE product_activation_state_audit_trail (
                                                      id uuid DEFAULT uuid_generate_v4() NOT NULL,
                                                      created_at timestamp without time zone DEFAULT now() NOT NULL,
                                                      created_by_id character varying NOT NULL,
                                                      created_by_name bytea NOT NULL,
                                                      product_activation_state_id uuid NOT NULL,
                                                      old_value jsonb NOT NULL,
                                                      new_value jsonb NOT NULL
);


ALTER TABLE product_activation_state_audit_trail OWNER TO tpnpms;

--
-- Name: product_activation_state_log; Type: TABLE; Schema: public; Owner: tpnpms
--

CREATE TABLE product_activation_state_log (
                                              created_at timestamp with time zone DEFAULT now() NOT NULL,
                                              updated_at timestamp with time zone DEFAULT now(),
                                              updated_by_id character varying,
                                              deleted_at timestamp with time zone,
                                              id uuid DEFAULT uuid_generate_v4() NOT NULL,
                                              requested_activation_status character varying(25) NOT NULL,
                                              confirmed_activation_status character varying(25),
                                              notes character varying(255),
                                              product_activation_state_id uuid,
                                              updated_by_name bytea
);


ALTER TABLE product_activation_state_log OWNER TO tpnpms;

--
-- Name: product_activation_state_track; Type: TABLE; Schema: public; Owner: tpnpms
--

CREATE TABLE product_activation_state_track (
                                                created_at timestamp with time zone DEFAULT now() NOT NULL,
                                                updated_at timestamp with time zone DEFAULT now(),
                                                updated_by_id character varying,
                                                deleted_at timestamp with time zone,
                                                updated_by_name bytea,
                                                id uuid DEFAULT uuid_generate_v4() NOT NULL,
                                                activation_tracking_id uuid NOT NULL,
                                                activation_tracking_date timestamp with time zone NOT NULL,
                                                activation_tracking_order_number character varying(50) NOT NULL,
                                                product_activation_state_id uuid NOT NULL,
                                                is_confirmed boolean DEFAULT false NOT NULL,
                                                product_activation_status character varying(25) NOT NULL,
                                                segment character varying(255),
                                                channel_name character varying(100),
                                                ecosystem_id uuid NOT NULL,
                                                ecosystem_name character varying(255) NOT NULL,
                                                citem character varying(25),
                                                serial_number bytea,
                                                service_id uuid NOT NULL,
                                                service_name character varying(255) NOT NULL,
                                                sid character varying(20),
                                                service_image character varying,
                                                customer_name bytea,
                                                customer_name_bidx character varying,
                                                is_migrated boolean,
                                                notes character varying(255),
                                                activation_date timestamp(6) with time zone,
                                                product_activation_attachment uuid,
                                                product_id uuid,
                                                product_name character varying,
                                                is_cancelled boolean,
                                                serial_number_bak character varying,
                                                serial_number_bidx character varying,
                                                is_encrypted boolean DEFAULT true,
                                                witel character varying(50),
                                                order_channel_id uuid
);


ALTER TABLE product_activation_state_track OWNER TO tpnpms;

--
-- Name: serial_number_text_heap; Type: TABLE; Schema: public; Owner: tpnpms
--

CREATE TABLE serial_number_text_heap (
                                         id uuid DEFAULT uuid_generate_v4() NOT NULL,
                                         content character varying NOT NULL,
                                         hash character varying NOT NULL
);


ALTER TABLE serial_number_text_heap OWNER TO tpnpms;


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY migrations ALTER COLUMN id SET DEFAULT nextval('migrations_id_seq'::regclass);

--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tpnpms
--

SELECT pg_catalog.setval('migrations_id_seq', 1, false);


--
-- Name: activation_attribute_trails PK_0035276d28b31369721b0d94a01; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY activation_attribute_trails
    ADD CONSTRAINT "PK_0035276d28b31369721b0d94a01" PRIMARY KEY (id);


--
-- Name: product_activation_state_audit_trail PK_0035276d28b31369721b0d94a02; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY product_activation_state_audit_trail
    ADD CONSTRAINT "PK_0035276d28b31369721b0d94a02" PRIMARY KEY (id);


--
-- Name: activation_attribute_trail PK_0035276d28b31369721b0d94a0b; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY activation_attribute_trail
    ADD CONSTRAINT "PK_0035276d28b31369721b0d94a0b" PRIMARY KEY (id);


--
-- Name: parent_requests PK_1bdbd4f606c08b1c0c15deb9261; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY parent_requests
    ADD CONSTRAINT "PK_1bdbd4f606c08b1c0c15deb9261" PRIMARY KEY (id);


--
-- Name: delivery_roles PK_2246d270a82d960a2e9c1952b9e; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY delivery_roles
    ADD CONSTRAINT "PK_2246d270a82d960a2e9c1952b9e" PRIMARY KEY (id);


--
-- Name: product_activation_state_log PK_2924c40a34904664bd3ffbeb0f1; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY product_activation_state_log
    ADD CONSTRAINT "PK_2924c40a34904664bd3ffbeb0f1" PRIMARY KEY (id);


--
-- Name: product_activation_state PK_2ddcf345a2f82abc397018ba5af; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY product_activation_state
    ADD CONSTRAINT "PK_2ddcf345a2f82abc397018ba5af" PRIMARY KEY (id);


--
-- Name: product_state PK_2ddcf345a2f82abc397018ba5b0; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY product_state
    ADD CONSTRAINT "PK_2ddcf345a2f82abc397018ba5b0" PRIMARY KEY (id);


--
-- Name: holidays PK_3646bdd4c3817d954d830881dfe; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY holidays
    ADD CONSTRAINT "PK_3646bdd4c3817d954d830881dfe" PRIMARY KEY (id);


--
-- Name: activation_tracking_attachments PK_4f2f102e0a2fe05b2f3c67a58eb; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY activation_tracking_attachments
    ADD CONSTRAINT "PK_4f2f102e0a2fe05b2f3c67a58eb" PRIMARY KEY (id);


--
-- Name: product_activation_attachments PK_59235267a1c2f00a5c225ac59c6; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY product_activation_attachments
    ADD CONSTRAINT "PK_59235267a1c2f00a5c225ac59c6" PRIMARY KEY (id);


--
-- Name: updated_by_name_text_heap PK_71ee3e36c8f22eed301f56ada01; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY updated_by_name_text_heap
    ADD CONSTRAINT "PK_71ee3e36c8f22eed301f56ada01" PRIMARY KEY (id);


--
-- Name: ba_ori_doc_filename_text_heap PK_71ee3e36c8f22eed301f56ada02; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY ba_ori_doc_filename_text_heap
    ADD CONSTRAINT "PK_71ee3e36c8f22eed301f56ada02" PRIMARY KEY (id);


--
-- Name: customer_name_text_heap PK_71ee3e36c8f22eed301f56ada03; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY customer_name_text_heap
    ADD CONSTRAINT "PK_71ee3e36c8f22eed301f56ada03" PRIMARY KEY (id);


--
-- Name: ba_verified_doc_filename_text_heap PK_71ee3e36c8f22eed301f56ada04; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY ba_verified_doc_filename_text_heap
    ADD CONSTRAINT "PK_71ee3e36c8f22eed301f56ada04" PRIMARY KEY (id);


--
-- Name: customer_email_text_heap PK_71ee3e36c8f22eed301f56ada05; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY customer_email_text_heap
    ADD CONSTRAINT "PK_71ee3e36c8f22eed301f56ada05" PRIMARY KEY (id);


--
-- Name: filename_heap PK_71ee3e36c8f22eed301f56ada06; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY filename_heap
    ADD CONSTRAINT "PK_71ee3e36c8f22eed301f56ada06" PRIMARY KEY (id);


--
-- Name: ori_filename_text_heap PK_71ee3e36c8f22eed301f56ada07; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY ori_filename_text_heap
    ADD CONSTRAINT "PK_71ee3e36c8f22eed301f56ada07" PRIMARY KEY (id);


--
-- Name: external_configs PK_74d88df785399a619f24b2c3ef9; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY external_configs
    ADD CONSTRAINT "PK_74d88df785399a619f24b2c3ef9" PRIMARY KEY (id);


--
-- Name: ba_activations PK_84ff82b2ca6409f7f2db82826b7; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY ba_activations
    ADD CONSTRAINT "PK_84ff82b2ca6409f7f2db82826b7" PRIMARY KEY (id);


--
-- Name: migrations PK_8c82d7f526340ab734260ea46be; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY migrations
    ADD CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id);


--
-- Name: product_activation_state_track PK_9359b7d06c7027961b1a39595bf; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY product_activation_state_track
    ADD CONSTRAINT "PK_9359b7d06c7027961b1a39595bf" PRIMARY KEY (id);


--
-- Name: activation_product_attributes PK_9b5ecf166f79fa642966332f5fe; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY activation_product_attributes
    ADD CONSTRAINT "PK_9b5ecf166f79fa642966332f5fe" PRIMARY KEY (id);


--
-- Name: activation_trackings PK_cfe65b41e91f9ba9874489fc152; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY activation_trackings
    ADD CONSTRAINT "PK_cfe65b41e91f9ba9874489fc152" PRIMARY KEY (id);


--
-- Name: child_requests PK_d404d799d950bb8fa476b302454; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY child_requests
    ADD CONSTRAINT "PK_d404d799d950bb8fa476b302454" PRIMARY KEY (id);


--
-- Name: activation_tracking_inputter PK_e103c1b9ae3af74677b2c06b9aa; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY activation_tracking_inputter
    ADD CONSTRAINT "PK_e103c1b9ae3af74677b2c06b9aa" PRIMARY KEY (id);


--
-- Name: activation_tracking_tasks PK_ede46d79279345dd3ee8657f235; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY activation_tracking_tasks
    ADD CONSTRAINT "PK_ede46d79279345dd3ee8657f235" PRIMARY KEY (id);


--
-- Name: activation_tracking_inputter REL_ab7059b480e347a43fec0919cf; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY activation_tracking_inputter
    ADD CONSTRAINT "REL_ab7059b480e347a43fec0919cf" UNIQUE (activation_id);


--
-- Name: delivery_roles UQ_b6ab5169a9d1e6004370967779f; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY delivery_roles
    ADD CONSTRAINT "UQ_b6ab5169a9d1e6004370967779f" UNIQUE (delivery_key);


--
-- Name: name_text_heap name_text_heap_pkey; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY name_text_heap
    ADD CONSTRAINT name_text_heap_pkey PRIMARY KEY (id);


--
-- Name: serial_number_text_heap serial_number_text_heap_pkey; Type: CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY serial_number_text_heap
    ADD CONSTRAINT serial_number_text_heap_pkey PRIMARY KEY (id);


--
-- Name: IDX_1c5a10beafd35e3ba657192045; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "IDX_1c5a10beafd35e3ba657192045" ON product_activation_attachments USING btree (product_activation_state_log_id);


--
-- Name: IDX_8f235d5035750059858bba150b; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "IDX_8f235d5035750059858bba150b" ON activation_tracking_attachments USING btree (activation_tracking_task_id);


--
-- Name: idx-activation-attach-created_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-attach-created_at" ON activation_tracking_attachments USING btree (created_at);


--
-- Name: idx-activation-attach-deleted_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-attach-deleted_at" ON activation_tracking_attachments USING btree (deleted_at);


--
-- Name: idx-activation-attach-updated_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-attach-updated_at" ON activation_tracking_attachments USING btree (updated_at);


--
-- Name: idx-activation-created_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-created_at" ON activation_trackings USING btree (created_at);


--
-- Name: idx-activation-customer-name-bidx; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-customer-name-bidx" ON activation_trackings USING btree (customer_name_bidx);


--
-- Name: idx-activation-deleted_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-deleted_at" ON activation_trackings USING btree (deleted_at);


--
-- Name: idx-activation-ecosystem-id; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-ecosystem-id" ON activation_trackings USING btree (ecosystem_id);


--
-- Name: idx-activation-ecosystem-name; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-ecosystem-name" ON activation_trackings USING btree (ecosystem_name);


--
-- Name: idx-activation-inputter-created_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-inputter-created_at" ON activation_tracking_inputter USING btree (created_at);


--
-- Name: idx-activation-new-channel; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-new-channel" ON activation_trackings USING btree (order_type, order_channel_id);


--
-- Name: idx-activation-order-id; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-order-id" ON activation_trackings USING btree (order_id);


--
-- Name: idx-activation-order-number; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-order-number" ON activation_trackings USING btree (order_number);


--
-- Name: idx-activation-order-type; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-order-type" ON activation_trackings USING btree (order_type);


--
-- Name: idx-activation-service-id; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-service-id" ON activation_trackings USING btree (service_id);


--
-- Name: idx-activation-service-name; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-service-name" ON activation_trackings USING btree (service_name);


--
-- Name: idx-activation-status; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-status" ON activation_trackings USING btree (activation_status);


--
-- Name: idx-activation-task-created_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-task-created_at" ON activation_tracking_tasks USING btree (created_at);


--
-- Name: idx-activation-task-deleted_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-task-deleted_at" ON activation_tracking_tasks USING btree (deleted_at);


--
-- Name: idx-activation-task-updated_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-task-updated_at" ON activation_tracking_tasks USING btree (updated_at);


--
-- Name: idx-activation-updated_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-activation-updated_at" ON activation_trackings USING btree (updated_at);


--
-- Name: idx-baa-activation_id; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-baa-activation_id" ON ba_activations USING btree (activation_id);


--
-- Name: idx-baa-created_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-baa-created_at" ON ba_activations USING btree (created_at);


--
-- Name: idx-baa-deleted_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-baa-deleted_at" ON ba_activations USING btree (deleted_at);


--
-- Name: idx-baa-stat; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-baa-stat" ON ba_activations USING btree (status);


--
-- Name: idx-baa-sub_task_id; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-baa-sub_task_id" ON ba_activations USING btree (sub_task_id);


--
-- Name: idx-baa-task_id; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-baa-task_id" ON ba_activations USING btree (task_id);


--
-- Name: idx-baa-updated_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-baa-updated_at" ON ba_activations USING btree (updated_at);


--
-- Name: idx-child-request-parent-key; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-child-request-parent-key" ON child_requests USING btree (parent_key);


--
-- Name: idx-child_requests-created_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-child_requests-created_at" ON child_requests USING btree (created_at);


--
-- Name: idx-ecosystem-activation-id; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-ecosystem-activation-id" ON product_activation_state USING btree (ecosystem_id);


--
-- Name: idx-holiday-id; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-holiday-id" ON holidays USING btree (holiday_date);


--
-- Name: idx-parent-request-key; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-parent-request-key" ON parent_requests USING btree (key);


--
-- Name: idx-parent_requests-created_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-parent_requests-created_at" ON parent_requests USING btree (created_at);


--
-- Name: idx-parent_requests-updated_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-parent_requests-updated_at" ON parent_requests USING btree (updated_at);


--
-- Name: idx-priduct-state-ecosystem-activation-id; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-priduct-state-ecosystem-activation-id" ON product_state USING btree (ecosystem_id);


--
-- Name: idx-product-activation-state-serial-number-bidx; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-activation-state-serial-number-bidx" ON product_activation_state USING btree (serial_number);


--
-- Name: idx-product-activation-state-track-search; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-activation-state-track-search" ON product_activation_state_track USING btree (serial_number_bidx, sid, service_id, citem);


--
-- Name: idx-product-activation-state-track-search1; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-activation-state-track-search1" ON product_activation_state_track USING btree (serial_number_bidx, sid, service_id, citem);


--
-- Name: idx-product-activation-state-track-serial-number-bidx; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-activation-state-track-serial-number-bidx" ON product_activation_state_track USING btree (serial_number);


--
-- Name: idx-product-activation-updated_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-activation-updated_at" ON product_activation_state USING btree (updated_at);


--
-- Name: idx-product-attach-created_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-attach-created_at" ON product_activation_attachments USING btree (created_at);


--
-- Name: idx-product-attach-deleted_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-attach-deleted_at" ON product_activation_attachments USING btree (deleted_at);


--
-- Name: idx-product-attach-updated_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-attach-updated_at" ON product_activation_attachments USING btree (updated_at);


--
-- Name: idx-product-state-activation-updated_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-state-activation-updated_at" ON product_state USING btree (updated_at);


--
-- Name: idx-product-state-customer-bidx; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-state-customer-bidx" ON product_state USING btree (customer_name_bidx);


--
-- Name: idx-product-state-customer-name-bidx; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-state-customer-name-bidx" ON product_activation_state USING btree (customer_name_bidx);


--
-- Name: idx-product-state-ecosystem-activation-id; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-state-ecosystem-activation-id" ON product_activation_state_track USING btree (ecosystem_id);


--
-- Name: idx-product-state-ecosystem-name; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-state-ecosystem-name" ON product_state USING btree (ecosystem_name);


--
-- Name: idx-product-state-order-number; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-state-order-number" ON product_state USING btree (last_order_number);


--
-- Name: idx-product-state-requested_activation-id; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-state-requested_activation-id" ON product_state USING btree (requested_activation_status);


--
-- Name: idx-product-state-serial-numbers; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-state-serial-numbers" ON product_state USING btree (serial_number);


--
-- Name: idx-product-state-service-name; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-state-service-name" ON product_state USING btree (service_name);


--
-- Name: idx-product-state-track-channel; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-state-track-channel" ON product_activation_state_track USING btree (channel_name);


--
-- Name: idx-product-state-track-customer-name-bidx; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-state-track-customer-name-bidx" ON product_activation_state_track USING btree (customer_name_bidx);


--
-- Name: idx-product-state-track-data; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-state-track-data" ON product_activation_state_track USING btree (service_id, sid, serial_number);


--
-- Name: idx-product-state-track-ecosystem-name; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-state-track-ecosystem-name" ON product_activation_state_track USING btree (ecosystem_name);


--
-- Name: idx-product-state-track-order-number; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-state-track-order-number" ON product_activation_state_track USING btree (activation_tracking_order_number);


--
-- Name: idx-product-state-track-service-name; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-state-track-service-name" ON product_activation_state_track USING btree (service_name);


--
-- Name: idx-product-state-track-sid; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-state-track-sid" ON product_activation_state_track USING btree (sid);


--
-- Name: idx-product-state-track-status; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-state-track-status" ON product_activation_state_track USING btree (product_activation_status);


--
-- Name: idx-product-state-updated_at; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-product-state-updated_at" ON product_activation_state_track USING btree (updated_at);


--
-- Name: idx-requested_activation-id; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-requested_activation-id" ON product_activation_state USING btree (requested_activation_status);


--
-- Name: idx-state-ecosystem-name; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-state-ecosystem-name" ON product_activation_state USING btree (ecosystem_name);


--
-- Name: idx-state-order-number; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-state-order-number" ON product_activation_state USING btree (last_order_number);


--
-- Name: idx-state-service-name; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-state-service-name" ON product_activation_state USING btree (service_name);


--
-- Name: idx-state_channel; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX "idx-state_channel" ON product_activation_state USING btree (channel_name);


--
-- Name: idx-unique-product-activation; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE UNIQUE INDEX "idx-unique-product-activation" ON product_activation_state USING btree (sid, citem, serial_number);


--
-- Name: idx_past_optimization_3; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX idx_past_optimization_3 ON product_activation_state_track USING btree (sid, service_id, serial_number_bidx, deleted_at, is_cancelled, created_at DESC);


--
-- Name: idx_past_query_optimization; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX idx_past_query_optimization ON product_activation_state_track USING btree (sid, citem, service_id, serial_number_bidx, service_id);


--
-- Name: idx_past_query_optimization2; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX idx_past_query_optimization2 ON product_activation_state_track USING btree (sid, serial_number_bidx, citem, service_id);


--
-- Name: idx_past_sid_service_id_serial_number_bidx_deleted_at_is_cancel; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX idx_past_sid_service_id_serial_number_bidx_deleted_at_is_cancel ON product_activation_state_track USING btree (sid, service_id, serial_number_bidx, deleted_at, is_cancelled);


--
-- Name: idx_past_sid_service_serial_created; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX idx_past_sid_service_serial_created ON product_activation_state_track USING btree (sid, service_id, serial_number_bidx, deleted_at, is_cancelled, created_at DESC);


--
-- Name: idx_product_activation_state_sid; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX idx_product_activation_state_sid ON product_activation_state USING btree (sid);


--
-- Name: idx_product_state_sid; Type: INDEX; Schema: public; Owner: tpnpms
--

CREATE INDEX idx_product_state_sid ON product_state USING btree (sid);


--
-- Name: product_activation_attachments FK_1c5a10beafd35e3ba6571920454; Type: FK CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY product_activation_attachments
    ADD CONSTRAINT "FK_1c5a10beafd35e3ba6571920454" FOREIGN KEY (product_activation_state_log_id) REFERENCES product_activation_state_log(id);


--
-- Name: external_configs FK_3a57fd4ee1cb17d44954c4296ec; Type: FK CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY external_configs
    ADD CONSTRAINT "FK_3a57fd4ee1cb17d44954c4296ec" FOREIGN KEY (parent_task) REFERENCES external_configs(id);


--
-- Name: product_activation_state_log FK_4f159e790dc0a0f16b7a9aaa1fd; Type: FK CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY product_activation_state_log
    ADD CONSTRAINT "FK_4f159e790dc0a0f16b7a9aaa1fd" FOREIGN KEY (product_activation_state_id) REFERENCES product_activation_state(id);


--
-- Name: activation_trackings FK_5a1e26a80c3fb814b6339bee5df; Type: FK CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY activation_trackings
    ADD CONSTRAINT "FK_5a1e26a80c3fb814b6339bee5df" FOREIGN KEY (parent_id) REFERENCES activation_trackings(id);


--
-- Name: activation_tracking_attachments FK_8f235d5035750059858bba150b4; Type: FK CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY activation_tracking_attachments
    ADD CONSTRAINT "FK_8f235d5035750059858bba150b4" FOREIGN KEY (activation_tracking_task_id) REFERENCES activation_tracking_tasks(id) ON DELETE CASCADE;


--
-- Name: activation_tracking_tasks FK_a01bf727b7fbbabcb6e866fa866; Type: FK CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY activation_tracking_tasks
    ADD CONSTRAINT "FK_a01bf727b7fbbabcb6e866fa866" FOREIGN KEY (parent_task) REFERENCES activation_tracking_tasks(id) ON DELETE CASCADE;


--
-- Name: activation_tracking_inputter FK_ab7059b480e347a43fec0919cfb; Type: FK CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY activation_tracking_inputter
    ADD CONSTRAINT "FK_ab7059b480e347a43fec0919cfb" FOREIGN KEY (activation_id) REFERENCES activation_trackings(id) ON DELETE CASCADE;


--
-- Name: activation_tracking_tasks FK_b96790ce06fc68025112cbd75ad; Type: FK CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY activation_tracking_tasks
    ADD CONSTRAINT "FK_b96790ce06fc68025112cbd75ad" FOREIGN KEY (activation_tracking_id) REFERENCES activation_trackings(id) ON DELETE CASCADE;


--
-- Name: activation_product_attributes FK_db74bb011d436e22b4dba24006c; Type: FK CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY activation_product_attributes
    ADD CONSTRAINT "FK_db74bb011d436e22b4dba24006c" FOREIGN KEY (activation_id) REFERENCES activation_trackings(id) ON DELETE CASCADE;


--
-- Name: child_requests FK_fd71b472b436e74aa01c4a1af5a; Type: FK CONSTRAINT; Schema: public; Owner: tpnpms
--

ALTER TABLE ONLY child_requests
    ADD CONSTRAINT "FK_fd71b472b436e74aa01c4a1af5a" FOREIGN KEY (parent_id) REFERENCES parent_requests(id);


--
-- PostgreSQL database dump complete
--

