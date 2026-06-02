--
-- PostgreSQL database dump (schema only)
--

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

CREATE TYPE public.enum_composition_suggestions_status AS ENUM (
    'pending',
    'approved',
    'rejected'
);

CREATE TYPE public.enum_recordings_status AS ENUM (
    'processing',
    'completed',
    'failed'
);

CREATE TYPE public.enum_users_role AS ENUM (
    'musician',
    'admin'
);

SET default_tablespace = '';
SET default_table_access_method = heap;

CREATE TABLE public.achievements (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    title character varying(150) NOT NULL,
    description text NOT NULL
);

CREATE SEQUENCE public.achievements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.achievements_id_seq OWNED BY public.achievements.id;

CREATE TABLE public.composition_suggestions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    title character varying(200) NOT NULL,
    composer character varying(150) NOT NULL,
    instrument character varying(100),
    reference_audio_path character varying(500),
    sheet_file_path character varying(500),
    status public.enum_composition_suggestions_status DEFAULT 'pending'::public.enum_composition_suggestions_status,
    created_at timestamp with time zone,
    midi_path character varying(500),
    difficulty character varying(30) DEFAULT 'Легкий'::character varying NOT NULL
);

CREATE SEQUENCE public.composition_suggestions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.composition_suggestions_id_seq OWNED BY public.composition_suggestions.id;

CREATE TABLE public.compositions (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    composer character varying(150) NOT NULL,
    instrument character varying(100) NOT NULL,
    difficulty character varying(30) DEFAULT 'Легкий'::character varying,
    material_type character varying(30) DEFAULT 'composition'::character varying NOT NULL,
    midi_path character varying(500),
    reference_audio_path character varying(500),
    sheet_file_path character varying(500),
    sheet_notes text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

CREATE SEQUENCE public.compositions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.compositions_id_seq OWNED BY public.compositions.id;

CREATE TABLE public.errors (
    id integer NOT NULL,
    report_id integer NOT NULL,
    type character varying(50) NOT NULL,
    description text NOT NULL,
    expected_value character varying(100),
    actual_value character varying(100),
    time_sec double precision
);

CREATE SEQUENCE public.errors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.errors_id_seq OWNED BY public.errors.id;

CREATE TABLE public.notifications (
    id integer NOT NULL,
    user_id integer NOT NULL,
    type character varying(50) NOT NULL,
    title character varying(200) NOT NULL,
    is_read boolean DEFAULT false,
    link character varying(300),
    created_at timestamp with time zone
);

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;

CREATE TABLE public.recommendations (
    id integer NOT NULL,
    user_id integer NOT NULL,
    report_id integer,
    text text NOT NULL,
    created_at timestamp with time zone
);

CREATE SEQUENCE public.recommendations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.recommendations_id_seq OWNED BY public.recommendations.id;

CREATE TABLE public.recordings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    composition_id integer NOT NULL,
    audio_path character varying(500) NOT NULL,
    status public.enum_recordings_status DEFAULT 'processing'::public.enum_recordings_status,
    uploaded_at timestamp with time zone
);

CREATE SEQUENCE public.recordings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.recordings_id_seq OWNED BY public.recordings.id;

CREATE TABLE public.reports (
    id integer NOT NULL,
    recording_id integer NOT NULL,
    total_score integer NOT NULL,
    intonation integer NOT NULL,
    rhythm integer NOT NULL,
    articulation integer NOT NULL,
    created_at timestamp with time zone
);

CREATE SEQUENCE public.reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.reports_id_seq OWNED BY public.reports.id;

CREATE TABLE public.user_achievements (
    id integer NOT NULL,
    user_id integer NOT NULL,
    achievement_id integer NOT NULL,
    earned_at timestamp with time zone
);

CREATE SEQUENCE public.user_achievements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.user_achievements_id_seq OWNED BY public.user_achievements.id;

CREATE TABLE public.users (
    id integer NOT NULL,
    login character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    role public.enum_users_role DEFAULT 'musician'::public.enum_users_role,
    instrument character varying(100),
    registration_date timestamp with time zone
);

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;

ALTER TABLE ONLY public.achievements ALTER COLUMN id SET DEFAULT nextval('public.achievements_id_seq'::regclass);
ALTER TABLE ONLY public.composition_suggestions ALTER COLUMN id SET DEFAULT nextval('public.composition_suggestions_id_seq'::regclass);
ALTER TABLE ONLY public.compositions ALTER COLUMN id SET DEFAULT nextval('public.compositions_id_seq'::regclass);
ALTER TABLE ONLY public.errors ALTER COLUMN id SET DEFAULT nextval('public.errors_id_seq'::regclass);
ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);
ALTER TABLE ONLY public.recommendations ALTER COLUMN id SET DEFAULT nextval('public.recommendations_id_seq'::regclass);
ALTER TABLE ONLY public.recordings ALTER COLUMN id SET DEFAULT nextval('public.recordings_id_seq'::regclass);
ALTER TABLE ONLY public.reports ALTER COLUMN id SET DEFAULT nextval('public.reports_id_seq'::regclass);
ALTER TABLE ONLY public.user_achievements ALTER COLUMN id SET DEFAULT nextval('public.user_achievements_id_seq'::regclass);
ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);

ALTER TABLE ONLY public.achievements ADD CONSTRAINT achievements_code_key UNIQUE (code);
ALTER TABLE ONLY public.achievements ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.composition_suggestions ADD CONSTRAINT composition_suggestions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.compositions ADD CONSTRAINT compositions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.errors ADD CONSTRAINT errors_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.notifications ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.recommendations ADD CONSTRAINT recommendations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.recordings ADD CONSTRAINT recordings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.reports ADD CONSTRAINT reports_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.reports ADD CONSTRAINT reports_recording_id_key UNIQUE (recording_id);
ALTER TABLE ONLY public.user_achievements ADD CONSTRAINT user_achievements_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.user_achievements ADD CONSTRAINT user_achievements_user_achievement_unique UNIQUE (user_id, achievement_id);
ALTER TABLE ONLY public.users ADD CONSTRAINT users_email_key UNIQUE (email);
ALTER TABLE ONLY public.users ADD CONSTRAINT users_login_key UNIQUE (login);
ALTER TABLE ONLY public.users ADD CONSTRAINT users_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.composition_suggestions
    ADD CONSTRAINT composition_suggestions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.errors
    ADD CONSTRAINT errors_report_id_fkey FOREIGN KEY (report_id) REFERENCES public.reports(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.recommendations
    ADD CONSTRAINT recommendations_report_id_fkey FOREIGN KEY (report_id) REFERENCES public.reports(id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY public.recommendations
    ADD CONSTRAINT recommendations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.recordings
    ADD CONSTRAINT recordings_composition_id_fkey FOREIGN KEY (composition_id) REFERENCES public.compositions(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.recordings
    ADD CONSTRAINT recordings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_recording_id_fkey FOREIGN KEY (recording_id) REFERENCES public.recordings(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_achievement_id_fkey FOREIGN KEY (achievement_id) REFERENCES public.achievements(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;

-- PostgreSQL database dump complete
