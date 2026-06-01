--
-- PostgreSQL database dump
--

\restrict TMntClileTn2d1xnQlbxlAMb5pJoSePHFy7OlV8ArSdpdh3t2fnsil8NsoQEajI

-- Dumped from database version 17.10
-- Dumped by pg_dump version 17.10

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
-- Name: enum_composition_suggestions_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_composition_suggestions_status AS ENUM (
    'pending',
    'approved',
    'rejected'
);


--
-- Name: enum_compositions_difficulty; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_compositions_difficulty AS ENUM (
    'easy',
    'medium',
    'hard'
);


--
-- Name: enum_recordings_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_recordings_status AS ENUM (
    'processing',
    'completed',
    'failed'
);


--
-- Name: enum_users_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_users_role AS ENUM (
    'musician',
    'admin'
);


--
-- Name: enum_users_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.enum_users_status AS ENUM (
    'active',
    'blocked'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: achievements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.achievements (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    title character varying(150) NOT NULL,
    description text NOT NULL
);


--
-- Name: achievements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.achievements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: achievements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.achievements_id_seq OWNED BY public.achievements.id;


--
-- Name: composition_suggestions; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: composition_suggestions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.composition_suggestions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: composition_suggestions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.composition_suggestions_id_seq OWNED BY public.composition_suggestions.id;


--
-- Name: compositions; Type: TABLE; Schema: public; Owner: -
--

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


--
-- Name: compositions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.compositions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: compositions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.compositions_id_seq OWNED BY public.compositions.id;


--
-- Name: errors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.errors (
    id integer NOT NULL,
    report_id integer NOT NULL,
    type character varying(50) NOT NULL,
    description text NOT NULL,
    expected_value character varying(100),
    actual_value character varying(100),
    time_sec double precision
);


--
-- Name: errors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.errors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: errors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.errors_id_seq OWNED BY public.errors.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    user_id integer NOT NULL,
    type character varying(50) NOT NULL,
    title character varying(200) NOT NULL,
    is_read boolean DEFAULT false,
    link character varying(300),
    created_at timestamp with time zone
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: recommendations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recommendations (
    id integer NOT NULL,
    user_id integer NOT NULL,
    report_id integer,
    text text NOT NULL,
    created_at timestamp with time zone
);


--
-- Name: recommendations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recommendations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recommendations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recommendations_id_seq OWNED BY public.recommendations.id;


--
-- Name: recordings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recordings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    composition_id integer NOT NULL,
    audio_path character varying(500) NOT NULL,
    status public.enum_recordings_status DEFAULT 'processing'::public.enum_recordings_status,
    uploaded_at timestamp with time zone
);


--
-- Name: recordings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recordings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recordings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recordings_id_seq OWNED BY public.recordings.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reports (
    id integer NOT NULL,
    recording_id integer NOT NULL,
    total_score integer NOT NULL,
    intonation integer NOT NULL,
    rhythm integer NOT NULL,
    articulation integer NOT NULL,
    created_at timestamp with time zone
);


--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reports_id_seq OWNED BY public.reports.id;


--
-- Name: user_achievements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_achievements (
    id integer NOT NULL,
    user_id integer NOT NULL,
    achievement_id integer NOT NULL,
    earned_at timestamp with time zone
);


--
-- Name: user_achievements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_achievements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_achievements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_achievements_id_seq OWNED BY public.user_achievements.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    login character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    role public.enum_users_role DEFAULT 'musician'::public.enum_users_role,
    avatar text,
    status public.enum_users_status DEFAULT 'active'::public.enum_users_status,
    instrument character varying(100),
    registration_date timestamp with time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: achievements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements ALTER COLUMN id SET DEFAULT nextval('public.achievements_id_seq'::regclass);


--
-- Name: composition_suggestions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.composition_suggestions ALTER COLUMN id SET DEFAULT nextval('public.composition_suggestions_id_seq'::regclass);


--
-- Name: compositions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compositions ALTER COLUMN id SET DEFAULT nextval('public.compositions_id_seq'::regclass);


--
-- Name: errors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.errors ALTER COLUMN id SET DEFAULT nextval('public.errors_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: recommendations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recommendations ALTER COLUMN id SET DEFAULT nextval('public.recommendations_id_seq'::regclass);


--
-- Name: recordings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recordings ALTER COLUMN id SET DEFAULT nextval('public.recordings_id_seq'::regclass);


--
-- Name: reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports ALTER COLUMN id SET DEFAULT nextval('public.reports_id_seq'::regclass);


--
-- Name: user_achievements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_achievements ALTER COLUMN id SET DEFAULT nextval('public.user_achievements_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: achievements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.achievements (id, code, title, description) FROM stdin;
1	first_upload	Первый шаг	Загрузите первую запись
2	five_reports	Пятёрка	Получите 5 отчётов
3	score_80	Отличник	Наберите 80+ баллов
4	week_streak	Неделя практики	7 дней подряд с записями
5	library_explorer	Исследователь	Исполните 10 произведений
\.


--
-- Data for Name: composition_suggestions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.composition_suggestions (id, user_id, title, composer, instrument, reference_audio_path, sheet_file_path, status, created_at, midi_path, difficulty) FROM stdin;
3	8	Предложение от musician6	Бетховен	Скрипка	\N	\N	rejected	2026-06-01 08:32:57.072+03	\N	Легкий
2	6	Предложение от musician4	Шуберт	Гитара	\N	\N	rejected	2026-06-01 08:32:56.904+03	\N	Легкий
1	4	Предложение от musician2	Моцарт	Гитара	\N	\N	rejected	2026-06-01 08:32:56.708+03	\N	Легкий
4	10	Предложение от musician8	Шуберт	Флейта	\N	\N	approved	2026-06-01 08:32:57.256+03	\N	Легкий
5	11	123	123	Фортепиано	uploads/reference-audio/1780293720841-615628624.mp3	uploads/sheets/1780293720837-65501286.pdf	approved	2026-06-01 09:02:00.848+03	uploads/midi/1780293720837-722856154.mid	Легкий
6	11	123	123	Фортепиано	uploads/reference-audio/1780309985693-138242749.wav	uploads/sheets/1780309985686-573675454.pdf	rejected	2026-06-01 13:33:05.737+03	uploads/midi/1780309985685-542706451.mid	Легкий
7	11	123	123	Фортепиано	uploads/reference-audio/1780310827688-475030005.wav	uploads/sheets/1780310827637-12557426.pdf	rejected	2026-06-01 13:47:07.767+03	uploads/midi/1780310827637-979454320.mid	Легкий
8	11	Соната	Шопен	Фортепиано	uploads/reference-audio/1780313099549-220275370.mp3	uploads/sheets/1780313099529-119239496.pdf	approved	2026-06-01 14:24:59.551+03	uploads/midi/1780313099528-605359455.mid	Легкий
9	11	Скерцо	Цыганков	Фортепиано	uploads/reference-audio/1780313390531-525576599.wav	uploads/sheets/1780313390527-998092257.png	rejected	2026-06-01 14:29:50.571+03	uploads/midi/1780313390527-461771764.mid	Легкий
\.


--
-- Data for Name: compositions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.compositions (id, title, composer, instrument, difficulty, material_type, midi_path, reference_audio_path, sheet_file_path, sheet_notes, created_at, updated_at) FROM stdin;
1	Маленькая ночная серенада	Бах	Фортепиано	Легкий	composition	\N	\N	\N	\N	2026-06-01 08:32:56.413+03	2026-06-01 10:27:00.607+03
2	Лунная соната	Моцарт	Скрипка	Средний	composition	\N	\N	\N	\N	2026-06-01 08:32:56.419+03	2026-06-01 10:27:00.62+03
3	Экспромт	Бетховен	Гитара	Легкий	composition	\N	\N	\N	\N	2026-06-01 08:32:56.422+03	2026-06-01 10:27:00.622+03
4	Прелюдия	Шопен	Флейта	Средний	composition	\N	\N	\N	\N	2026-06-01 08:32:56.424+03	2026-06-01 10:27:00.624+03
5	Этюд	Вивальди	Фортепиано	Средний	composition	\N	\N	\N	Этюд на легато. Следить за ровным соединением нот.	2026-06-01 08:32:56.427+03	2026-06-01 10:27:00.625+03
6	Менуэт	Гайдн	Скрипка	Легкий	composition	\N	\N	\N	\N	2026-06-01 08:32:56.429+03	2026-06-01 10:27:00.627+03
7	Сонатина	Шуберт	Гитара	Средний	composition	\N	\N	\N	\N	2026-06-01 08:32:56.431+03	2026-06-01 10:27:00.628+03
8	Гамма до мажор	Дебюсси	Флейта	Средний	exercise	\N	\N	\N	Гамма до мажор, 2 октавы, ровные восьмые, темп 60.	2026-06-01 08:32:56.433+03	2026-06-01 10:27:00.629+03
9	Вальс	Бах	Фортепиано	Средний	composition	\N	\N	\N	\N	2026-06-01 08:32:56.436+03	2026-06-01 10:27:00.631+03
10	Марш	Моцарт	Скрипка	Средний	composition	\N	\N	\N	\N	2026-06-01 08:32:56.438+03	2026-06-01 10:27:00.634+03
11	Баркарола	Бетховен	Гитара	Средний	composition	\N	\N	\N	\N	2026-06-01 08:32:56.441+03	2026-06-01 10:27:00.635+03
12	Ноктюрн	Шопен	Флейта	Средний	composition	\N	\N	\N	\N	2026-06-01 08:32:56.444+03	2026-06-01 10:27:00.636+03
13	Адажио	Вивальди	Фортепиано	Средний	composition	\N	\N	\N	\N	2026-06-01 08:32:56.446+03	2026-06-01 10:27:00.637+03
14	Скерцо	Гайдн	Скрипка	Средний	composition	\N	\N	\N	\N	2026-06-01 08:32:56.449+03	2026-06-01 10:27:00.638+03
15	Рондо	Шуберт	Гитара	Средний	composition	\N	\N	\N	\N	2026-06-01 08:32:56.451+03	2026-06-01 10:27:00.639+03
16	Каприс	Дебюсси	Флейта	Средний	composition	\N	\N	\N	\N	2026-06-01 08:32:56.453+03	2026-06-01 10:27:00.64+03
17	Баллада	Бах	Фортепиано	Средний	composition	\N	\N	\N	\N	2026-06-01 08:32:56.457+03	2026-06-01 10:27:00.64+03
18	Фантазия	Моцарт	Скрипка	Средний	composition	\N	\N	\N	\N	2026-06-01 08:32:56.459+03	2026-06-01 10:27:00.641+03
20	Полонез	Шопен	Флейта	Средний	composition	\N	\N	\N	\N	2026-06-01 08:32:56.463+03	2026-06-01 10:27:00.642+03
28	Упражнение 6	Шрадик	Скрипка	Средний	exercise	uploads/midi/1780295453580-23975128.mid	uploads/reference-audio/1780295453580-490493593.mp3	uploads/sheets/1780295453580-6489322.png	\N	2026-06-01 09:30:53.583+03	2026-06-01 10:27:00.643+03
29	Упражнение 5	Шрадик	Скрипка	Средний	exercise	uploads/midi/1780295485197-774400202.mid	uploads/reference-audio/1780295485197-760819866.mp3	uploads/sheets/1780295485197-600274817.png	\N	2026-06-01 09:31:25.2+03	2026-06-01 10:27:00.643+03
19	Пассаж	Бетховен	Гитара	Средний	exercise	\N	\N	\N	Пассаж на ровность пальцев, темп 70, следить за одинаковой длительностью нот. 	2026-06-01 08:32:56.461+03	2026-06-01 10:27:00.646+03
30	Упражнение 4	Шрадик	Скрипка	Средний	exercise	uploads/midi/1780295517880-622015210.mid	uploads/reference-audio/1780295517880-610466505.mp3	uploads/sheets/1780295517880-214362790.png	\N	2026-06-01 09:31:57.883+03	2026-06-01 10:27:00.647+03
23	Концерт номер 2	Клеванец	Скрипка	Средний	composition	uploads/midi/1780294690898-548421564.mid	uploads/reference-audio/1780294732598-39821835.mp3	uploads/sheets/1780294797358-824683263.pdf	\N	2026-06-01 09:18:10.905+03	2026-06-01 10:27:00.647+03
24	Упражнение 18	Шрадик	Скрипка	Средний	exercise	uploads/midi/1780295228874-354079523.mid	uploads/reference-audio/1780295228875-197837644.mp3	uploads/sheets/1780295228875-98709043.png	\N	2026-06-01 09:27:08.882+03	2026-06-01 10:27:00.648+03
25	Упражнение 17	Шрадик	Скрипка	Средний	exercise	uploads/midi/1780295325161-783996688.mid	uploads/reference-audio/1780295325161-225421845.mp3	uploads/sheets/1780295325161-548744614.png	\N	2026-06-01 09:28:45.165+03	2026-06-01 10:27:00.649+03
26	Упражнение 8	Шрадик	Скрипка	Средний	exercise	uploads/midi/1780295369274-380640487.mid	uploads/reference-audio/1780295369275-669658920.mp3	uploads/sheets/1780295369275-899384826.png	\N	2026-06-01 09:29:29.279+03	2026-06-01 10:27:00.65+03
27	Упражнение 7	Шрадик	Скрипка	Средний	exercise	uploads/midi/1780295419462-604798537.mid	uploads/reference-audio/1780295419462-405387930.mp3	uploads/sheets/1780295419462-575986819.png	\N	2026-06-01 09:30:19.465+03	2026-06-01 10:27:00.65+03
31	Упражнение 3	Шрадик	Скрипка	Средний	exercise	uploads/midi/1780295568783-268470875.mid	uploads/reference-audio/1780295568783-50093242.mp3	uploads/sheets/1780295568783-854108812.png	\N	2026-06-01 09:32:48.786+03	2026-06-01 10:27:00.651+03
32	Упражнение 2	Шрадик	Скрипка	Средний	exercise	uploads/midi/1780295604994-254275989.mid	uploads/reference-audio/1780295604994-122718502.mp3	uploads/sheets/1780295604994-213357148.png	\N	2026-06-01 09:33:24.997+03	2026-06-01 10:27:00.652+03
33	Упражнение 1	Шрадик	Скрипка	Средний	exercise	uploads/midi/1780295644110-831864117.mid	uploads/reference-audio/1780295644110-57375204.mp3	uploads/sheets/1780295644110-761285667.png	\N	2026-06-01 09:34:04.114+03	2026-06-01 10:27:00.653+03
34	Кукушка	Дакен Л.	Скрипка	Средний	composition	uploads/midi/1780295821213-499778131.mid	uploads/reference-audio/1780295821252-775304448.mp3	uploads/sheets/1780295821213-681328828.pdf	\N	2026-06-01 09:37:01.262+03	2026-06-01 10:27:00.653+03
35	Гамма	Неизвестно	Скрипка	Легкий	composition	uploads/midi/1780295954928-976207682.mid	\N	uploads/sheets/1780295954928-985428186.png	\N	2026-06-01 09:39:14.93+03	2026-06-01 10:27:00.654+03
36	Скерцо-тарантелла	Цыганков А.	Фортепиано	Легкий	composition	uploads/midi/1780297851729-433881833.mid	uploads/reference-audio/1780296012458-601466490.mp3	\N	\N	2026-06-01 09:40:12.461+03	2026-06-01 10:27:00.655+03
37	Соната	Шопен	Фортепиано	Легкий	composition	uploads/midi/1780313099528-605359455.mid	uploads/reference-audio/1780313099549-220275370.mp3	uploads/sheets/1780313099529-119239496.pdf	\N	2026-06-01 14:27:20.653+03	2026-06-01 14:27:20.653+03
\.


--
-- Data for Name: errors; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.errors (id, report_id, type, description, expected_value, actual_value, time_sec) FROM stdin;
1	1	articulation	Ошибка при сравнении с эталоном	C4	B3	2.47
2	1	missing_note	Ошибка при сравнении с эталоном	C4	B3	28.01
3	2	articulation	Ошибка при сравнении с эталоном	C4	B3	28.08
4	2	articulation	Ошибка при сравнении с эталоном	C4	B3	4.13
5	3	articulation	Ошибка при сравнении с эталоном	C4	B3	7.76
6	3	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	7.02
7	4	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	12.57
8	4	articulation	Ошибка при сравнении с эталоном	C4	B3	22.6
9	5	early	Ошибка при сравнении с эталоном	C4	B3	21.34
10	5	early	Ошибка при сравнении с эталоном	C4	B3	15.09
11	6	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	9.64
12	6	early	Ошибка при сравнении с эталоном	C4	B3	16.85
13	7	missing_note	Ошибка при сравнении с эталоном	C4	B3	28.85
14	7	late	Ошибка при сравнении с эталоном	C4	B3	26.07
15	8	articulation	Ошибка при сравнении с эталоном	C4	B3	11.92
16	8	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	4.75
17	9	missing_note	Ошибка при сравнении с эталоном	C4	B3	27.98
18	9	articulation	Ошибка при сравнении с эталоном	C4	B3	20.19
19	10	missing_note	Ошибка при сравнении с эталоном	C4	B3	12.53
20	10	early	Ошибка при сравнении с эталоном	C4	B3	11.43
21	11	early	Ошибка при сравнении с эталоном	C4	B3	13.82
22	11	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	23.83
23	12	articulation	Ошибка при сравнении с эталоном	C4	B3	29.18
24	12	missing_note	Ошибка при сравнении с эталоном	C4	B3	8.04
25	13	articulation	Ошибка при сравнении с эталоном	C4	B3	7.03
26	13	late	Ошибка при сравнении с эталоном	C4	B3	19.01
27	14	late	Ошибка при сравнении с эталоном	C4	B3	25.53
28	14	late	Ошибка при сравнении с эталоном	C4	B3	12.26
29	15	early	Ошибка при сравнении с эталоном	C4	B3	4.83
30	15	articulation	Ошибка при сравнении с эталоном	C4	B3	0.69
31	16	early	Ошибка при сравнении с эталоном	C4	B3	10.98
32	16	early	Ошибка при сравнении с эталоном	C4	B3	19.39
33	17	articulation	Ошибка при сравнении с эталоном	C4	B3	2.52
34	17	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	11.57
35	18	early	Ошибка при сравнении с эталоном	C4	B3	7.36
36	18	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	27.44
37	19	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	12.61
38	19	articulation	Ошибка при сравнении с эталоном	C4	B3	14.43
39	20	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	10.79
40	20	early	Ошибка при сравнении с эталоном	C4	B3	12.89
41	21	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	29.55
42	21	missing_note	Ошибка при сравнении с эталоном	C4	B3	22.59
43	22	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	3.45
44	22	missing_note	Ошибка при сравнении с эталоном	C4	B3	22.71
45	23	early	Ошибка при сравнении с эталоном	C4	B3	4.91
46	23	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	24.63
47	24	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	7.73
48	24	early	Ошибка при сравнении с эталоном	C4	B3	9.3
49	25	early	Ошибка при сравнении с эталоном	C4	B3	18.53
50	25	late	Ошибка при сравнении с эталоном	C4	B3	21.55
51	26	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	13.24
52	26	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	12.33
53	27	late	Ошибка при сравнении с эталоном	C4	B3	10.93
54	27	early	Ошибка при сравнении с эталоном	C4	B3	12.69
55	28	early	Ошибка при сравнении с эталоном	C4	B3	29.06
56	28	missing_note	Ошибка при сравнении с эталоном	C4	B3	6.62
57	29	late	Ошибка при сравнении с эталоном	C4	B3	1.01
58	29	late	Ошибка при сравнении с эталоном	C4	B3	27.87
59	30	articulation	Ошибка при сравнении с эталоном	C4	B3	17.34
60	30	articulation	Ошибка при сравнении с эталоном	C4	B3	25.65
61	31	late	Ошибка при сравнении с эталоном	C4	B3	11
62	31	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	9.88
63	32	missing_note	Ошибка при сравнении с эталоном	C4	B3	6.47
64	32	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	29.36
65	33	missing_note	Ошибка при сравнении с эталоном	C4	B3	6.23
66	33	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	17.11
67	34	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	19.81
68	34	articulation	Ошибка при сравнении с эталоном	C4	B3	24.12
69	35	early	Ошибка при сравнении с эталоном	C4	B3	12.93
70	35	late	Ошибка при сравнении с эталоном	C4	B3	18.95
71	36	early	Ошибка при сравнении с эталоном	C4	B3	22.3
72	36	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	25.39
73	37	late	Ошибка при сравнении с эталоном	C4	B3	7.87
74	37	missing_note	Ошибка при сравнении с эталоном	C4	B3	9.16
75	38	articulation	Ошибка при сравнении с эталоном	C4	B3	16.6
76	38	articulation	Ошибка при сравнении с эталоном	C4	B3	10.37
77	39	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	16.67
78	39	articulation	Ошибка при сравнении с эталоном	C4	B3	13.29
79	40	missing_note	Ошибка при сравнении с эталоном	C4	B3	22.9
80	40	missing_note	Ошибка при сравнении с эталоном	C4	B3	21.29
81	41	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	20.01
82	41	late	Ошибка при сравнении с эталоном	C4	B3	21.13
83	42	early	Ошибка при сравнении с эталоном	C4	B3	9.44
84	42	early	Ошибка при сравнении с эталоном	C4	B3	19.68
85	43	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	27.45
86	43	missing_note	Ошибка при сравнении с эталоном	C4	B3	23.52
87	44	late	Ошибка при сравнении с эталоном	C4	B3	11.98
88	44	missing_note	Ошибка при сравнении с эталоном	C4	B3	8.66
89	45	missing_note	Ошибка при сравнении с эталоном	C4	B3	15.31
90	45	missing_note	Ошибка при сравнении с эталоном	C4	B3	1.01
91	46	late	Ошибка при сравнении с эталоном	C4	B3	15.31
92	46	late	Ошибка при сравнении с эталоном	C4	B3	28.7
93	47	late	Ошибка при сравнении с эталоном	C4	B3	28.6
94	47	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	17.68
95	48	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	19.42
96	48	late	Ошибка при сравнении с эталоном	C4	B3	13.19
97	49	missing_note	Ошибка при сравнении с эталоном	C4	B3	21.45
98	49	missing_note	Ошибка при сравнении с эталоном	C4	B3	2.49
99	50	late	Ошибка при сравнении с эталоном	C4	B3	11.99
100	50	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	10.4
101	51	articulation	Ошибка при сравнении с эталоном	C4	B3	15.46
102	51	late	Ошибка при сравнении с эталоном	C4	B3	5.2
103	52	late	Ошибка при сравнении с эталоном	C4	B3	9.76
104	52	late	Ошибка при сравнении с эталоном	C4	B3	3.19
105	53	late	Ошибка при сравнении с эталоном	C4	B3	11.73
106	53	articulation	Ошибка при сравнении с эталоном	C4	B3	23.1
107	54	missing_note	Ошибка при сравнении с эталоном	C4	B3	11.87
108	54	early	Ошибка при сравнении с эталоном	C4	B3	6.75
109	55	late	Ошибка при сравнении с эталоном	C4	B3	9.79
110	55	early	Ошибка при сравнении с эталоном	C4	B3	24.82
111	56	missing_note	Ошибка при сравнении с эталоном	C4	B3	1.09
112	56	late	Ошибка при сравнении с эталоном	C4	B3	8.32
113	57	early	Ошибка при сравнении с эталоном	C4	B3	20.79
114	57	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	1.88
115	58	missing_note	Ошибка при сравнении с эталоном	C4	B3	9.44
116	58	late	Ошибка при сравнении с эталоном	C4	B3	25.69
117	59	articulation	Ошибка при сравнении с эталоном	C4	B3	16.46
118	59	early	Ошибка при сравнении с эталоном	C4	B3	13.68
119	60	early	Ошибка при сравнении с эталоном	C4	B3	2.12
120	60	early	Ошибка при сравнении с эталоном	C4	B3	2.74
121	61	missing_note	Ошибка при сравнении с эталоном	C4	B3	10.17
122	61	articulation	Ошибка при сравнении с эталоном	C4	B3	23.22
123	62	late	Ошибка при сравнении с эталоном	C4	B3	14.8
124	62	articulation	Ошибка при сравнении с эталоном	C4	B3	28.88
125	63	late	Ошибка при сравнении с эталоном	C4	B3	22.78
126	63	missing_note	Ошибка при сравнении с эталоном	C4	B3	15.27
127	64	early	Ошибка при сравнении с эталоном	C4	B3	2.49
128	64	late	Ошибка при сравнении с эталоном	C4	B3	22.35
129	65	missing_note	Ошибка при сравнении с эталоном	C4	B3	14.25
130	65	late	Ошибка при сравнении с эталоном	C4	B3	12
131	66	missing_note	Ошибка при сравнении с эталоном	C4	B3	6.74
132	66	late	Ошибка при сравнении с эталоном	C4	B3	26.57
133	67	late	Ошибка при сравнении с эталоном	C4	B3	7.5
134	67	late	Ошибка при сравнении с эталоном	C4	B3	27.21
135	68	articulation	Ошибка при сравнении с эталоном	C4	B3	0.19
136	68	late	Ошибка при сравнении с эталоном	C4	B3	6.85
137	69	late	Ошибка при сравнении с эталоном	C4	B3	1.06
138	69	late	Ошибка при сравнении с эталоном	C4	B3	18.26
139	70	early	Ошибка при сравнении с эталоном	C4	B3	23.28
140	70	early	Ошибка при сравнении с эталоном	C4	B3	17.59
141	71	early	Ошибка при сравнении с эталоном	C4	B3	15.29
142	71	early	Ошибка при сравнении с эталоном	C4	B3	6.91
143	72	late	Ошибка при сравнении с эталоном	C4	B3	12.11
144	72	articulation	Ошибка при сравнении с эталоном	C4	B3	4.69
145	73	missing_note	Ошибка при сравнении с эталоном	C4	B3	4.24
146	73	missing_note	Ошибка при сравнении с эталоном	C4	B3	24.75
147	74	early	Ошибка при сравнении с эталоном	C4	B3	14.35
148	74	articulation	Ошибка при сравнении с эталоном	C4	B3	28.23
149	75	wrong_pitch	Ошибка при сравнении с эталоном	C4	B3	18.65
150	75	early	Ошибка при сравнении с эталоном	C4	B3	22.5
151	76	missing_note	Ошибка при сравнении с эталоном	C4	B3	10.01
152	76	articulation	Ошибка при сравнении с эталоном	C4	B3	16.92
153	77	early	Ошибка при сравнении с эталоном	C4	B3	22.2
154	77	articulation	Ошибка при сравнении с эталоном	C4	B3	25.24
155	78	late	Ошибка при сравнении с эталоном	C4	B3	5.96
156	78	missing_note	Ошибка при сравнении с эталоном	C4	B3	9.76
157	79	articulation	Ошибка при сравнении с эталоном	C4	B3	20.87
158	79	missing_note	Ошибка при сравнении с эталоном	C4	B3	5.99
159	80	early	Ошибка при сравнении с эталоном	C4	B3	8.08
160	80	early	Ошибка при сравнении с эталоном	C4	B3	0.05
161	81	wrong_pitch	��������� ���������� ������ ����	E4	Eb4	1
162	82	analysis_unavailable	В загруженном аудио не удалось распознать ноты. Проверьте, что файл содержит достаточно громкую запись инструмента и не повреждён.			\N
4634	85	analysis_unavailable	MIDI-эталон не найден на сервере.			\N
193	83	missing_note	Пропущена нота D6	D6	—	0
194	83	missing_note	Пропущена нота B5	B5	—	0.38
195	83	wrong_pitch	Отклонение ноты D#6	D#6	D6	0.98
196	83	late	Задержка начала ноты	0 ms	729 ms	0.98
197	83	articulation	Несоответствие длительности ноты	0.09s	0.22s	0.98
198	83	wrong_pitch	Отклонение ноты D#6	D#6	D6	1.17
199	83	late	Задержка начала ноты	0 ms	752 ms	1.17
200	83	articulation	Несоответствие длительности ноты	0.08s	0.18s	1.17
201	83	wrong_pitch	Отклонение ноты F4	F4	B5	1.59
202	83	late	Задержка начала ноты	0 ms	590 ms	1.59
203	83	articulation	Несоответствие длительности ноты	0.03s	0.26s	1.59
204	83	missing_note	Пропущена нота D6	D6	—	1.62
205	83	missing_note	Пропущена нота F4	F4	—	1.69
206	83	missing_note	Пропущена нота F4	F4	—	1.85
207	83	wrong_pitch	Отклонение ноты F4	F4	D#6	2.17
208	83	late	Задержка начала ноты	0 ms	636 ms	2.17
209	83	articulation	Несоответствие длительности ноты	0.03s	0.30s	2.17
210	83	wrong_pitch	Отклонение ноты B5	B5	D#6	2.37
211	83	late	Задержка начала ноты	0 ms	740 ms	2.37
212	83	wrong_pitch	Отклонение ноты F4	F4	D#6	3.13
213	83	late	Задержка начала ноты	0 ms	263 ms	3.13
214	83	articulation	Несоответствие длительности ноты	0.03s	0.17s	3.13
215	83	wrong_pitch	Отклонение ноты D5	D5	D6	3.13
216	83	late	Задержка начала ноты	0 ms	576 ms	3.13
217	83	articulation	Несоответствие длительности ноты	0.03s	0.22s	3.13
218	83	wrong_pitch	Отклонение ноты D5	D5	D6	3.19
219	83	late	Задержка начала ноты	0 ms	739 ms	3.19
220	83	articulation	Несоответствие длительности ноты	0.09s	0.20s	3.19
221	83	missing_note	Пропущена нота D5	D5	—	3.31
222	83	wrong_pitch	Отклонение ноты D5	D5	D6	3.38
223	83	late	Задержка начала ноты	0 ms	740 ms	3.38
224	83	articulation	Несоответствие длительности ноты	0.05s	0.20s	3.38
225	83	wrong_pitch	Отклонение ноты D#5	D#5	D6	4.06
226	83	late	Задержка начала ноты	0 ms	263 ms	4.06
227	83	articulation	Несоответствие длительности ноты	0.17s	0.26s	4.06
228	83	wrong_pitch	Отклонение ноты F4	F4	D6	4.27
229	83	late	Задержка начала ноты	0 ms	309 ms	4.27
230	83	articulation	Несоответствие длительности ноты	0.03s	0.17s	4.27
231	83	wrong_pitch	Отклонение ноты D#5	D#5	B5	4.27
232	83	late	Задержка начала ноты	0 ms	564 ms	4.27
233	83	articulation	Несоответствие длительности ноты	0.16s	0.41s	4.27
234	83	missing_note	Пропущена нота F4	F4	—	4.48
235	83	missing_note	Пропущена нота D#5	D#5	—	4.48
236	83	missing_note	Пропущена нота D5	D5	—	4.69
237	83	missing_note	Пропущена нота D5	D5	—	4.74
238	83	wrong_pitch	Отклонение ноты D5	D5	D#6	5.36
239	83	late	Задержка начала ноты	0 ms	272 ms	5.36
240	83	articulation	Несоответствие длительности ноты	0.08s	0.15s	5.36
241	83	wrong_pitch	Отклонение ноты B5	B5	D#5	5.51
242	83	late	Задержка начала ноты	0 ms	121 ms	5.51
243	83	articulation	Несоответствие длительности ноты	0.14s	0.24s	5.51
244	83	wrong_pitch	Отклонение ноты B4	B4	D#5	5.52
245	83	late	Задержка начала ноты	0 ms	353 ms	5.52
246	83	articulation	Несоответствие длительности ноты	0.12s	0.18s	5.52
247	83	wrong_pitch	Отклонение ноты E5	E5	C5	6.08
248	83	wrong_pitch	Отклонение ноты F#4	F#4	D#5	6.09
249	83	late	Задержка начала ноты	0 ms	644 ms	6.09
250	83	articulation	Несоответствие длительности ноты	0.03s	0.30s	6.09
251	83	missing_note	Пропущена нота D#4	D#4	—	6.09
252	83	missing_note	Пропущена нота G#5	G#5	—	6.09
253	83	missing_note	Пропущена нота B4	B4	—	6.1
254	83	missing_note	Пропущена нота B6	B6	—	6.1
255	83	missing_note	Пропущена нота D#7	D#7	—	6.12
256	83	missing_note	Пропущена нота F#5	F#5	—	6.14
257	83	wrong_pitch	Отклонение ноты E4	E4	D#5	6.3
258	83	late	Задержка начала ноты	0 ms	737 ms	6.3
259	83	articulation	Несоответствие длительности ноты	0.02s	0.24s	6.3
260	83	missing_note	Пропущена нота F#4	F#4	—	6.31
261	83	missing_note	Пропущена нота F7	F7	—	6.31
262	83	missing_note	Пропущена нота A5	A5	—	6.31
263	83	missing_note	Пропущена нота F6	F6	—	6.31
264	83	missing_note	Пропущена нота D#4	D#4	—	6.33
265	83	missing_note	Пропущена нота B4	B4	—	6.33
266	83	missing_note	Пропущена нота E7	E7	—	6.33
267	83	missing_note	Пропущена нота F5	F5	—	6.33
268	83	missing_note	Пропущена нота E5	E5	—	6.34
269	83	missing_note	Пропущена нота C7	C7	—	6.36
270	83	missing_note	Пропущена нота D#4	D#4	—	6.38
271	83	missing_note	Пропущена нота E4	E4	—	6.41
272	83	wrong_pitch	Отклонение ноты B5	B5	D#5	6.98
273	83	late	Задержка начала ноты	0 ms	306 ms	6.98
274	83	articulation	Несоответствие длительности ноты	0.03s	0.26s	6.98
275	83	wrong_pitch	Отклонение ноты F4	F4	D5	6.98
276	83	late	Задержка начала ноты	0 ms	701 ms	6.98
277	83	articulation	Несоответствие длительности ноты	0.05s	0.21s	6.98
278	83	missing_note	Пропущена нота G#5	G#5	—	6.98
279	83	missing_note	Пропущена нота C6	C6	—	6.99
280	83	missing_note	Пропущена нота D#7	D#7	—	6.99
281	83	missing_note	Пропущена нота A5	A5	—	7.01
282	83	missing_note	Пропущена нота E4	E4	—	7.05
283	83	missing_note	Пропущена нота A#5	A#5	—	7.05
284	83	missing_note	Пропущена нота F4	F4	—	7.07
285	83	wrong_pitch	Отклонение ноты F4	F4	D5	7.19
286	83	late	Задержка начала ноты	0 ms	700 ms	7.19
287	83	articulation	Несоответствие длительности ноты	0.02s	0.19s	7.19
288	83	missing_note	Пропущена нота A5	A5	—	7.19
289	83	missing_note	Пропущена нота C6	C6	—	7.2
290	83	missing_note	Пропущена нота E7	E7	—	7.2
291	83	missing_note	Пропущена нота F6	F6	—	7.21
292	83	missing_note	Пропущена нота F4	F4	—	7.22
293	83	missing_note	Пропущена нота D#6	D#6	—	7.23
294	83	missing_note	Пропущена нота E6	E6	—	7.27
295	83	wrong_pitch	Отклонение ноты F4	F4	D5	7.28
296	83	late	Задержка начала ноты	0 ms	795 ms	7.28
297	83	articulation	Несоответствие длительности ноты	0.07s	0.20s	7.28
298	83	wrong_pitch	Отклонение ноты E5	E5	D5	7.83
299	83	late	Задержка начала ноты	0 ms	445 ms	7.83
300	83	wrong_pitch	Отклонение ноты F4	F4	B4	7.84
301	83	late	Задержка начала ноты	0 ms	736 ms	7.84
302	83	articulation	Несоответствие длительности ноты	0.06s	0.26s	7.84
303	83	missing_note	Пропущена нота G#5	G#5	—	7.85
304	83	missing_note	Пропущена нота G6	G6	—	7.86
305	83	missing_note	Пропущена нота B4	B4	—	7.87
306	83	missing_note	Пропущена нота A5	A5	—	7.87
307	83	missing_note	Пропущена нота E4	E4	—	7.91
308	83	missing_note	Пропущена нота D#7	D#7	—	7.91
309	83	missing_note	Пропущена нота F4	F4	—	8.05
310	83	missing_note	Пропущена нота F5	F5	—	8.05
311	83	missing_note	Пропущена нота F7	F7	—	8.06
312	83	missing_note	Пропущена нота E4	E4	—	8.07
313	83	missing_note	Пропущена нота A5	A5	—	8.07
314	83	missing_note	Пропущена нота B5	B5	—	8.08
315	83	missing_note	Пропущена нота C7	C7	—	8.08
316	83	missing_note	Пропущена нота F4	F4	—	8.09
317	83	missing_note	Пропущена нота E7	E7	—	8.1
318	83	missing_note	Пропущена нота E4	E4	—	8.12
319	83	missing_note	Пропущена нота A5	A5	—	8.29
320	83	missing_note	Пропущена нота F4	F4	—	8.33
321	83	missing_note	Пропущена нота G#5	G#5	—	8.33
322	83	missing_note	Пропущена нота E5	E5	—	8.35
323	83	missing_note	Пропущена нота D#7	D#7	—	8.38
324	83	missing_note	Пропущена нота F4	F4	—	8.43
325	83	missing_note	Пропущена нота F5	F5	—	8.44
326	83	missing_note	Пропущена нота D4	D4	—	8.45
327	83	missing_note	Пропущена нота A5	A5	—	8.47
328	83	missing_note	Пропущена нота F#5	F#5	—	8.5
329	83	wrong_pitch	Отклонение ноты F4	F4	E6	8.65
330	83	late	Задержка начала ноты	0 ms	792 ms	8.65
331	83	articulation	Несоответствие длительности ноты	0.03s	0.14s	8.65
332	83	wrong_pitch	Отклонение ноты G#5	G#5	E5	8.65
333	83	late	Задержка начала ноты	0 ms	792 ms	8.65
334	83	articulation	Несоответствие длительности ноты	0.19s	0.24s	8.65
335	83	wrong_pitch	Отклонение ноты B5	B5	G#5	8.66
336	83	late	Задержка начала ноты	0 ms	792 ms	8.66
337	83	wrong_pitch	Отклонение ноты F#7	F#7	E4	8.67
338	83	late	Задержка начала ноты	0 ms	781 ms	8.67
339	83	articulation	Несоответствие длительности ноты	0.08s	0.28s	8.67
340	83	missing_note	Пропущена нота D#7	D#7	—	8.7
341	83	missing_note	Пропущена нота D#4	D#4	—	8.73
342	83	missing_note	Пропущена нота A5	A5	—	8.81
343	83	missing_note	Пропущена нота D#5	D#5	—	8.88
344	83	missing_note	Пропущена нота F5	F5	—	8.88
345	83	missing_note	Пропущена нота E7	E7	—	8.88
346	83	missing_note	Пропущена нота F6	F6	—	8.88
347	83	missing_note	Пропущена нота E6	E6	—	8.9
348	83	missing_note	Пропущена нота D#4	D#4	—	8.9
349	83	missing_note	Пропущена нота B5	B5	—	8.9
350	83	missing_note	Пропущена нота C6	C6	—	8.93
351	83	missing_note	Пропущена нота E4	E4	—	8.97
352	83	wrong_pitch	Отклонение ноты B5	B5	A5	9.86
353	83	articulation	Несоответствие длительности ноты	0.13s	0.18s	9.86
354	83	wrong_pitch	Отклонение ноты B4	B4	F5	9.87
355	83	articulation	Несоответствие длительности ноты	0.10s	0.21s	9.87
356	83	wrong_pitch	Отклонение ноты B5	B5	A5	10.08
357	83	late	Задержка начала ноты	0 ms	675 ms	10.08
358	83	articulation	Несоответствие длительности ноты	0.07s	0.24s	10.08
359	83	missing_note	Пропущена нота B4	B4	—	10.09
360	83	missing_note	Пропущена нота F4	F4	—	10.16
361	83	wrong_pitch	Отклонение ноты D#5	D#5	F6	10.3
362	83	late	Задержка начала ноты	0 ms	791 ms	10.3
363	83	articulation	Несоответствие длительности ноты	0.13s	0.23s	10.3
364	83	missing_note	Пропущена нота D6	D6	—	10.42
365	83	missing_note	Пропущена нота D5	D5	—	10.47
366	83	missing_note	Пропущена нота F4	F4	—	10.51
367	83	missing_note	Пропущена нота D#5	D#5	—	10.52
368	83	missing_note	Пропущена нота F6	F6	—	10.62
369	83	missing_note	Пропущена нота F#5	F#5	—	10.63
370	83	missing_note	Пропущена нота F5	F5	—	10.65
371	83	missing_note	Пропущена нота F#5	F#5	—	10.76
372	83	missing_note	Пропущена нота F6	F6	—	10.83
373	83	missing_note	Пропущена нота F#5	F#5	—	10.84
374	83	missing_note	Пропущена нота F7	F7	—	10.84
375	83	missing_note	Пропущена нота F5	F5	—	10.85
376	83	missing_note	Пропущена нота F4	F4	—	10.94
377	83	missing_note	Пропущена нота D#5	D#5	—	10.94
378	83	missing_note	Пропущена нота D6	D6	—	11.05
379	83	missing_note	Пропущена нота C#5	C#5	—	11.07
380	83	wrong_pitch	Отклонение ноты D#5	D#5	E6	11.15
381	83	late	Задержка начала ноты	0 ms	791 ms	11.15
382	83	articulation	Несоответствие длительности ноты	0.06s	0.16s	11.15
383	83	wrong_pitch	Отклонение ноты F4	F4	E5	11.24
384	83	late	Задержка начала ноты	0 ms	698 ms	11.24
385	83	articulation	Несоответствие длительности ноты	0.03s	0.24s	11.24
386	83	missing_note	Пропущена нота D6	D6	—	11.26
387	83	missing_note	Пропущена нота D5	D5	—	11.27
388	83	missing_note	Пропущена нота B5	B5	—	11.37
389	83	missing_note	Пропущена нота B4	B4	—	11.4
390	83	missing_note	Пропущена нота E4	E4	—	11.45
391	83	missing_note	Пропущена нота E6	E6	—	11.49
392	83	missing_note	Пропущена нота A5	A5	—	11.49
393	83	wrong_pitch	Отклонение ноты A4	A4	F#5	11.5
394	83	late	Задержка начала ноты	0 ms	791 ms	11.5
395	83	articulation	Несоответствие длительности ноты	0.08s	0.14s	11.5
396	83	missing_note	Пропущена нота B5	B5	—	11.58
397	83	missing_note	Пропущена нота B4	B4	—	11.59
398	83	missing_note	Пропущена нота F4	F4	—	11.69
399	83	missing_note	Пропущена нота E6	E6	—	11.69
400	83	missing_note	Пропущена нота A5	A5	—	11.69
401	83	missing_note	Пропущена нота A4	A4	—	11.7
402	83	missing_note	Пропущена нота E4	E4	—	11.76
403	83	missing_note	Пропущена нота B5	B5	—	11.78
404	83	missing_note	Пропущена нота D#4	D#4	—	11.79
405	83	missing_note	Пропущена нота B4	B4	—	11.79
406	83	missing_note	Пропущена нота F4	F4	—	11.87
407	83	missing_note	Пропущена нота D5	D5	—	11.88
408	83	missing_note	Пропущена нота D6	D6	—	11.88
409	83	missing_note	Пропущена нота D#5	D#5	—	11.92
410	83	wrong_pitch	Отклонение ноты D#5	D#5	F#5	12
411	83	late	Задержка начала ноты	0 ms	732 ms	12
412	83	articulation	Несоответствие длительности ноты	0.12s	0.20s	12
413	83	missing_note	Пропущена нота E4	E4	—	12.07
414	83	missing_note	Пропущена нота D#4	D#4	—	12.1
415	83	missing_note	Пропущена нота D6	D6	—	12.1
416	83	missing_note	Пропущена нота D5	D5	—	12.12
417	83	missing_note	Пропущена нота F#7	F#7	—	12.14
418	83	missing_note	Пропущена нота E4	E4	—	12.19
419	83	wrong_pitch	Отклонение ноты D#6	D#6	G#5	12.2
420	83	late	Задержка начала ноты	0 ms	789 ms	12.2
421	83	articulation	Несоответствие длительности ноты	0.12s	0.37s	12.2
422	83	missing_note	Пропущена нота D#5	D#5	—	12.22
423	83	wrong_pitch	Отклонение ноты F4	F4	B5	12.3
424	83	late	Задержка начала ноты	0 ms	720 ms	12.3
425	83	articulation	Несоответствие длительности ноты	0.03s	0.26s	12.3
426	83	wrong_pitch	Отклонение ноты E5	E5	E4	12.31
427	83	late	Задержка начала ноты	0 ms	743 ms	12.31
428	83	articulation	Несоответствие длительности ноты	0.07s	0.17s	12.31
429	83	missing_note	Пропущена нота F5	F5	—	12.38
430	83	missing_note	Пропущена нота E5	E5	—	12.4
431	83	missing_note	Пропущена нота F4	F4	—	12.42
432	83	missing_note	Пропущена нота F#5	F#5	—	12.42
433	83	missing_note	Пропущена нота E5	E5	—	12.48
434	83	missing_note	Пропущена нота E6	E6	—	12.51
435	83	wrong_pitch	Отклонение ноты F5	F5	E6	12.53
436	83	late	Задержка начала ноты	0 ms	789 ms	12.53
437	83	articulation	Несоответствие длительности ноты	0.05s	0.14s	12.53
438	83	wrong_pitch	Отклонение ноты E5	E5	E4	12.57
439	83	late	Задержка начала ноты	0 ms	754 ms	12.57
440	83	articulation	Несоответствие длительности ноты	0.08s	0.22s	12.57
441	83	missing_note	Пропущена нота F4	F4	—	12.62
442	83	missing_note	Пропущена нота D5	D5	—	12.63
443	83	missing_note	Пропущена нота F#7	F#7	—	12.67
444	83	missing_note	Пропущена нота D#5	D#5	—	12.7
445	83	missing_note	Пропущена нота D5	D5	—	12.72
446	83	missing_note	Пропущена нота D#4	D#4	—	12.72
447	83	missing_note	Пропущена нота D#5	D#5	—	12.73
448	83	missing_note	Пропущена нота F#4	F#4	—	12.84
449	83	missing_note	Пропущена нота C#7	C#7	—	12.85
450	83	missing_note	Пропущена нота F#5	F#5	—	12.85
451	83	missing_note	Пропущена нота A5	A5	—	12.93
452	83	missing_note	Пропущена нота F4	F4	—	12.94
453	83	missing_note	Пропущена нота F4	F4	—	13.06
454	83	missing_note	Пропущена нота B5	B5	—	13.06
455	83	missing_note	Пропущена нота E4	E4	—	13.09
456	83	missing_note	Пропущена нота E4	E4	—	13.14
457	83	wrong_pitch	Отклонение ноты D5	D5	B4	13.5
458	83	late	Задержка начала ноты	0 ms	603 ms	13.5
459	83	articulation	Несоответствие длительности ноты	0.03s	0.16s	13.5
460	83	wrong_pitch	Отклонение ноты F4	F4	A4	13.51
461	83	late	Задержка начала ноты	0 ms	766 ms	13.51
462	83	articulation	Несоответствие длительности ноты	0.05s	0.14s	13.51
463	83	missing_note	Пропущена нота F#5	F#5	—	13.53
464	83	missing_note	Пропущена нота E4	E4	—	13.56
465	83	missing_note	Пропущена нота D5	D5	—	13.56
466	83	wrong_pitch	Отклонение ноты F#4	F#4	B4	13.73
467	83	late	Задержка начала ноты	0 ms	684 ms	13.73
468	83	articulation	Несоответствие длительности ноты	0.05s	0.15s	13.73
469	83	wrong_pitch	Отклонение ноты D#5	D#5	B5	13.73
470	83	late	Задержка начала ноты	0 ms	719 ms	13.73
471	83	articulation	Несоответствие длительности ноты	0.59s	0.23s	13.73
472	83	missing_note	Пропущена нота D#4	D#4	—	13.74
473	83	missing_note	Пропущена нота A5	A5	—	13.76
474	83	wrong_pitch	Отклонение ноты F#4	F#4	D5	13.94
475	83	late	Задержка начала ноты	0 ms	649 ms	13.94
476	83	articulation	Несоответствие длительности ноты	0.02s	0.15s	13.94
477	83	wrong_pitch	Отклонение ноты B5	B5	D#5	13.97
478	83	late	Задержка начала ноты	0 ms	776 ms	13.97
479	83	wrong_pitch	Отклонение ноты F#4	F#4	D5	14.16
480	83	late	Задержка начала ноты	0 ms	765 ms	14.16
481	83	articulation	Несоответствие длительности ноты	0.03s	0.15s	14.16
482	83	missing_note	Пропущена нота D4	D4	—	14.17
483	83	missing_note	Пропущена нота A5	A5	—	14.19
484	83	missing_note	Пропущена нота E4	E4	—	14.22
485	83	wrong_pitch	Отклонение ноты D5	D5	B4	14.37
486	83	late	Задержка начала ноты	0 ms	729 ms	14.37
487	83	articulation	Несоответствие длительности ноты	0.05s	0.30s	14.37
488	83	missing_note	Пропущена нота F4	F4	—	14.38
489	83	wrong_pitch	Отклонение ноты E4	E4	A4	14.43
490	83	late	Задержка начала ноты	0 ms	787 ms	14.43
491	83	articulation	Несоответствие длительности ноты	0.03s	0.15s	14.43
492	83	missing_note	Пропущена нота D5	D5	—	14.44
493	83	missing_note	Пропущена нота F4	F4	—	14.47
494	83	missing_note	Пропущена нота F4	F4	—	14.58
495	83	missing_note	Пропущена нота B5	B5	—	14.59
496	83	late	Задержка начала ноты	0 ms	799 ms	14.6
497	83	missing_note	Пропущена нота E5	E5	—	14.62
498	83	missing_note	Пропущена нота F4	F4	—	14.69
499	83	missing_note	Пропущена нота E6	E6	—	14.8
500	83	missing_note	Пропущена нота A5	A5	—	14.8
501	83	missing_note	Пропущена нота F#4	F#4	—	14.81
502	83	missing_note	Пропущена нота A4	A4	—	14.81
503	83	missing_note	Пропущена нота D#4	D#4	—	14.83
504	83	missing_note	Пропущена нота D6	D6	—	14.84
505	83	missing_note	Пропущена нота D5	D5	—	14.84
506	83	wrong_pitch	Отклонение ноты B5	B5	E6	15
507	83	late	Задержка начала ноты	0 ms	752 ms	15
508	83	wrong_pitch	Отклонение ноты F#4	F#4	E5	15.01
509	83	late	Задержка начала ноты	0 ms	740 ms	15.01
510	83	articulation	Несоответствие длительности ноты	0.05s	0.18s	15.01
511	83	missing_note	Пропущена нота D#4	D#4	—	15.02
512	83	missing_note	Пропущена нота E5	E5	—	15.02
513	83	missing_note	Пропущена нота B4	B4	—	15.02
514	83	wrong_pitch	Отклонение ноты D5	D5	G5	15.22
515	83	late	Задержка начала ноты	0 ms	671 ms	15.22
516	83	articulation	Несоответствие длительности ноты	0.05s	0.17s	15.22
517	83	wrong_pitch	Отклонение ноты D4	D4	E4	15.23
518	83	late	Задержка начала ноты	0 ms	660 ms	15.23
519	83	articulation	Несоответствие длительности ноты	0.03s	0.26s	15.23
520	83	missing_note	Пропущена нота F#4	F#4	—	15.23
521	83	missing_note	Пропущена нота D6	D6	—	15.23
522	83	missing_note	Пропущена нота F#5	F#5	—	15.26
523	83	missing_note	Пропущена нота E4	E4	—	15.28
524	83	missing_note	Пропущена нота D5	D5	—	15.29
525	83	wrong_pitch	Отклонение ноты F4	F4	G5	15.44
526	83	late	Задержка начала ноты	0 ms	752 ms	15.44
527	83	articulation	Несоответствие длительности ноты	0.06s	0.14s	15.44
528	83	missing_note	Пропущена нота B5	B5	—	15.44
529	83	missing_note	Пропущена нота D#5	D#5	—	15.47
530	83	missing_note	Пропущена нота B4	B4	—	15.47
531	83	missing_note	Пропущена нота A#6	A#6	—	15.49
532	83	missing_note	Пропущена нота E4	E4	—	15.5
533	83	missing_note	Пропущена нота F#6	F#6	—	15.5
534	83	missing_note	Пропущена нота F4	F4	—	15.53
535	83	missing_note	Пропущена нота E4	E4	—	15.57
536	83	wrong_pitch	Отклонение ноты F4	F4	E4	15.66
537	83	late	Задержка начала ноты	0 ms	752 ms	15.66
538	83	articulation	Несоответствие длительности ноты	0.05s	0.17s	15.66
539	83	missing_note	Пропущена нота E6	E6	—	15.66
540	83	missing_note	Пропущена нота A5	A5	—	15.66
541	83	missing_note	Пропущена нота A4	A4	—	15.67
542	83	missing_note	Пропущена нота D6	D6	—	15.7
543	83	wrong_pitch	Отклонение ноты E4	E4	A4	15.72
544	83	late	Задержка начала ноты	0 ms	798 ms	15.72
545	83	articulation	Несоответствие длительности ноты	0.03s	0.16s	15.72
546	83	missing_note	Пропущена нота D5	D5	—	15.72
547	83	missing_note	Пропущена нота F#4	F#4	—	15.87
548	83	missing_note	Пропущена нота C#6	C#6	—	15.87
549	83	missing_note	Пропущена нота B5	B5	—	15.88
550	83	late	Задержка начала ноты	0 ms	798 ms	15.91
551	83	articulation	Несоответствие длительности ноты	0.14s	0.42s	15.91
552	83	missing_note	Пропущена нота B5	B5	—	16.07
553	83	missing_note	Пропущена нота E4	E4	—	16.08
554	83	missing_note	Пропущена нота E6	E6	—	16.08
555	83	missing_note	Пропущена нота F4	F4	—	16.09
556	83	missing_note	Пропущена нота A5	A5	—	16.09
557	83	missing_note	Пропущена нота E5	E5	—	16.1
558	83	missing_note	Пропущена нота A4	A4	—	16.1
559	83	missing_note	Пропущена нота E4	E4	—	16.12
560	83	missing_note	Пропущена нота F4	F4	—	16.16
561	83	missing_note	Пропущена нота F#4	F#4	—	16.29
562	83	missing_note	Пропущена нота C#6	C#6	—	16.29
563	83	missing_note	Пропущена нота B5	B5	—	16.3
564	83	missing_note	Пропущена нота B4	B4	—	16.33
565	83	missing_note	Пропущена нота A5	A5	—	16.51
566	83	missing_note	Пропущена нота E6	E6	—	16.51
567	83	missing_note	Пропущена нота F#4	F#4	—	16.52
568	83	missing_note	Пропущена нота D5	D5	—	16.52
569	83	missing_note	Пропущена нота D#4	D#4	—	16.52
570	83	missing_note	Пропущена нота G7	G7	—	16.52
571	83	missing_note	Пропущена нота A4	A4	—	16.52
572	83	missing_note	Пропущена нота B4	B4	—	16.53
573	83	missing_note	Пропущена нота D6	D6	—	16.53
574	83	missing_note	Пропущена нота D5	D5	—	16.57
575	83	missing_note	Пропущена нота E4	E4	—	16.59
576	83	missing_note	Пропущена нота C#7	C#7	—	16.6
577	83	wrong_pitch	Отклонение ноты F#4	F#4	D#5	16.98
578	83	late	Задержка начала ноты	0 ms	494 ms	16.98
579	83	articulation	Несоответствие длительности ноты	0.02s	0.14s	16.98
580	83	wrong_pitch	Отклонение ноты B5	B5	E5	16.99
581	83	late	Задержка начала ноты	0 ms	622 ms	16.99
582	83	articulation	Несоответствие длительности ноты	0.03s	0.22s	16.99
583	83	wrong_pitch	Отклонение ноты C#6	C#6	E6	16.99
584	83	late	Задержка начала ноты	0 ms	634 ms	16.99
585	83	articulation	Несоответствие длительности ноты	0.06s	0.15s	16.99
586	83	wrong_pitch	Отклонение ноты D6	D6	G5	16.99
587	83	late	Задержка начала ноты	0 ms	773 ms	16.99
588	83	articulation	Несоответствие длительности ноты	0.35s	0.19s	16.99
589	83	wrong_pitch	Отклонение ноты F4	F4	E4	17
590	83	late	Задержка начала ноты	0 ms	773 ms	17
591	83	articulation	Несоответствие длительности ноты	0.02s	0.27s	17
592	83	missing_note	Пропущена нота A5	A5	—	17.01
593	83	missing_note	Пропущена нота C6	C6	—	17.03
594	83	wrong_pitch	Отклонение ноты B5	B5	G5	17.35
595	83	late	Задержка начала ноты	0 ms	600 ms	17.35
596	83	articulation	Несоответствие длительности ноты	0.22s	0.16s	17.35
597	83	missing_note	Пропущена нота C#6	C#6	—	17.97
598	83	missing_note	Пропущена нота D#6	D#6	—	17.97
599	83	missing_note	Пропущена нота F4	F4	—	17.98
600	83	missing_note	Пропущена нота E4	E4	—	18
601	83	missing_note	Пропущена нота D#6	D#6	—	18.31
602	83	missing_note	Пропущена нота C#6	C#6	—	18.4
603	83	missing_note	Пропущена нота D#6	D#6	—	18.4
604	83	missing_note	Пропущена нота F4	F4	—	18.62
605	83	missing_note	Пропущена нота B5	B5	—	18.62
606	83	missing_note	Пропущена нота C#6	C#6	—	18.62
607	83	missing_note	Пропущена нота D#6	D#6	—	18.62
608	83	missing_note	Пропущена нота D6	D6	—	18.63
609	83	missing_note	Пропущена нота E4	E4	—	18.65
610	83	wrong_pitch	Отклонение ноты C#6	C#6	D5	18.72
611	83	late	Задержка начала ноты	0 ms	760 ms	18.72
612	83	articulation	Несоответствие длительности ноты	0.03s	0.24s	18.72
613	83	missing_note	Пропущена нота D6	D6	—	18.76
614	83	missing_note	Пропущена нота D6	D6	—	19
615	83	wrong_pitch	Отклонение ноты C#6	C#6	E6	19.21
616	83	late	Задержка начала ноты	0 ms	632 ms	19.21
617	83	articulation	Несоответствие длительности ноты	0.06s	0.14s	19.21
618	83	wrong_pitch	Отклонение ноты D6	D6	E5	19.22
619	83	late	Задержка начала ноты	0 ms	632 ms	19.22
620	83	articulation	Несоответствие длительности ноты	0.16s	0.27s	19.22
621	83	wrong_pitch	Отклонение ноты B5	B5	G#5	19.42
622	83	late	Задержка начала ноты	0 ms	446 ms	19.42
623	83	wrong_pitch	Отклонение ноты A5	A5	G5	19.43
624	83	late	Задержка начала ноты	0 ms	737 ms	19.43
625	83	articulation	Несоответствие длительности ноты	0.06s	0.21s	19.43
626	83	wrong_pitch	Отклонение ноты D#5	D#5	E4	20.1
627	83	wrong_pitch	Отклонение ноты F4	F4	E6	20.12
628	83	late	Задержка начала ноты	0 ms	353 ms	20.12
629	83	articulation	Несоответствие длительности ноты	0.02s	0.17s	20.12
630	83	wrong_pitch	Отклонение ноты C#6	C#6	E5	20.12
631	83	late	Задержка начала ноты	0 ms	353 ms	20.12
632	83	articulation	Несоответствие длительности ноты	0.03s	0.28s	20.12
633	83	wrong_pitch	Отклонение ноты A#6	A#6	G#5	20.12
634	83	late	Задержка начала ноты	0 ms	376 ms	20.12
635	83	articulation	Несоответствие длительности ноты	0.13s	0.16s	20.12
636	83	wrong_pitch	Отклонение ноты G5	G5	D5	20.13
637	83	late	Задержка начала ноты	0 ms	643 ms	20.13
638	83	articulation	Несоответствие длительности ноты	0.02s	0.33s	20.13
639	83	wrong_pitch	Отклонение ноты B4	B4	F#5	20.13
640	83	late	Задержка начала ноты	0 ms	666 ms	20.13
641	83	articulation	Несоответствие длительности ноты	0.05s	0.15s	20.13
642	83	missing_note	Пропущена нота G6	G6	—	20.13
643	83	missing_note	Пропущена нота F#5	F#5	—	20.15
644	83	missing_note	Пропущена нота E4	E4	—	20.15
645	83	missing_note	Пропущена нота D7	D7	—	20.17
646	83	missing_note	Пропущена нота G5	G5	—	20.17
647	83	wrong_pitch	Отклонение ноты E5	E5	A4	20.33
648	83	late	Задержка начала ноты	0 ms	747 ms	20.33
649	83	wrong_pitch	Отклонение ноты A5	A5	D5	20.34
650	83	late	Задержка начала ноты	0 ms	759 ms	20.34
651	83	articulation	Несоответствие длительности ноты	0.02s	0.19s	20.34
652	83	missing_note	Пропущена нота F4	F4	—	20.34
653	83	missing_note	Пропущена нота B6	B6	—	20.34
654	83	missing_note	Пропущена нота C4	C4	—	20.35
655	83	missing_note	Пропущена нота B4	B4	—	20.35
656	83	missing_note	Пропущена нота D#7	D#7	—	20.35
657	83	missing_note	Пропущена нота G#6	G#6	—	20.35
658	83	missing_note	Пропущена нота G6	G6	—	20.36
659	83	missing_note	Пропущена нота G#5	G#5	—	20.36
660	83	missing_note	Пропущена нота E4	E4	—	20.37
661	83	missing_note	Пропущена нота F4	F4	—	20.43
662	83	missing_note	Пропущена нота E4	E4	—	20.47
663	83	wrong_pitch	Отклонение ноты E5	E5	B4	20.62
664	83	late	Задержка начала ноты	0 ms	747 ms	20.62
665	83	articulation	Несоответствие длительности ноты	0.37s	0.27s	20.62
666	83	wrong_pitch	Отклонение ноты G5	G5	F5	20.97
667	83	late	Задержка начала ноты	0 ms	433 ms	20.97
668	83	wrong_pitch	Отклонение ноты A5	A5	A4	20.98
669	83	late	Задержка начала ноты	0 ms	688 ms	20.98
670	83	articulation	Несоответствие длительности ноты	0.02s	0.41s	20.98
671	83	wrong_pitch	Отклонение ноты F5	F5	D5	20.98
672	83	late	Задержка начала ноты	0 ms	723 ms	20.98
673	83	articulation	Несоответствие длительности ноты	0.05s	0.20s	20.98
674	83	missing_note	Пропущена нота B5	B5	—	20.98
675	83	missing_note	Пропущена нота F#7	F#7	—	21
676	83	missing_note	Пропущена нота E4	E4	—	21.01
677	83	missing_note	Пропущена нота G#6	G#6	—	21.03
678	83	missing_note	Пропущена нота E4	E4	—	21.06
679	83	missing_note	Пропущена нота G#5	G#5	—	21.09
680	83	missing_note	Пропущена нота A5	A5	—	21.2
681	83	missing_note	Пропущена нота D4	D4	—	21.21
682	83	missing_note	Пропущена нота B5	B5	—	21.21
683	83	missing_note	Пропущена нота E7	E7	—	21.21
684	83	missing_note	Пропущена нота F6	F6	—	21.21
685	83	missing_note	Пропущена нота E6	E6	—	21.22
686	83	missing_note	Пропущена нота B4	B4	—	21.22
687	83	missing_note	Пропущена нота F4	F4	—	21.22
688	83	missing_note	Пропущена нота C6	C6	—	21.22
689	83	missing_note	Пропущена нота D#6	D#6	—	21.22
690	83	missing_note	Пропущена нота F4	F4	—	21.28
691	83	late	Задержка начала ноты	0 ms	700 ms	21.83
692	83	articulation	Несоответствие длительности ноты	0.03s	0.21s	21.83
693	83	wrong_pitch	Отклонение ноты D#5	D#5	B4	21.83
694	83	late	Задержка начала ноты	0 ms	723 ms	21.83
695	83	missing_note	Пропущена нота D#6	D#6	—	21.83
696	83	missing_note	Пропущена нота C#6	C#6	—	21.84
697	83	missing_note	Пропущена нота G7	G7	—	21.84
698	83	missing_note	Пропущена нота A#6	A#6	—	21.84
699	83	missing_note	Пропущена нота B4	B4	—	21.85
700	83	missing_note	Пропущена нота F5	F5	—	21.85
701	83	missing_note	Пропущена нота G6	G6	—	21.85
702	83	missing_note	Пропущена нота G5	G5	—	21.85
703	83	missing_note	Пропущена нота D7	D7	—	21.86
704	83	missing_note	Пропущена нота F#5	F#5	—	21.88
705	83	missing_note	Пропущена нота E4	E4	—	21.88
706	83	missing_note	Пропущена нота A#6	A#6	—	21.95
707	83	wrong_pitch	Отклонение ноты E5	E5	E4	22.05
708	83	late	Задержка начала ноты	0 ms	769 ms	22.05
709	83	wrong_pitch	Отклонение ноты F4	F4	A4	22.06
710	83	late	Задержка начала ноты	0 ms	781 ms	22.06
711	83	articulation	Несоответствие длительности ноты	0.03s	0.22s	22.06
712	83	missing_note	Пропущена нота B6	B6	—	22.06
713	83	missing_note	Пропущена нота G#5	G#5	—	22.06
714	83	missing_note	Пропущена нота D4	D4	—	22.07
715	83	missing_note	Пропущена нота B4	B4	—	22.08
716	83	missing_note	Пропущена нота G6	G6	—	22.08
717	83	missing_note	Пропущена нота A5	A5	—	22.09
718	83	missing_note	Пропущена нота D5	D5	—	22.1
719	83	missing_note	Пропущена нота D#7	D#7	—	22.1
720	83	missing_note	Пропущена нота F#5	F#5	—	22.12
721	83	missing_note	Пропущена нота F4	F4	—	22.13
722	83	wrong_pitch	Отклонение ноты G6	G6	F#4	22.34
723	83	late	Задержка начала ноты	0 ms	780 ms	22.34
724	83	articulation	Несоответствие длительности ноты	0.13s	0.23s	22.34
725	83	wrong_pitch	Отклонение ноты D#5	D#5	B4	22.35
726	83	late	Задержка начала ноты	0 ms	780 ms	22.35
727	83	articulation	Несоответствие длительности ноты	0.09s	0.17s	22.35
728	83	missing_note	Пропущена нота G5	G5	—	22.37
729	83	missing_note	Пропущена нота E4	E4	—	22.38
730	83	missing_note	Пропущена нота E5	E5	—	22.44
731	83	missing_note	Пропущена нота E4	E4	—	22.49
732	83	wrong_pitch	Отклонение ноты F4	F4	E4	22.65
733	83	late	Задержка начала ноты	0 ms	733 ms	22.65
734	83	articulation	Несоответствие длительности ноты	0.06s	0.24s	22.65
735	83	wrong_pitch	Отклонение ноты G5	G5	A4	22.65
736	83	late	Задержка начала ноты	0 ms	757 ms	22.65
737	83	missing_note	Пропущена нота A5	A5	—	22.66
738	83	missing_note	Пропущена нота A#5	A#5	—	22.66
739	83	missing_note	Пропущена нота B5	B5	—	22.69
740	83	missing_note	Пропущена нота F7	F7	—	22.69
741	83	missing_note	Пропущена нота E4	E4	—	22.71
742	83	missing_note	Пропущена нота F4	F4	—	22.74
743	83	missing_note	Пропущена нота A5	A5	—	22.88
744	83	missing_note	Пропущена нота F#4	F#4	—	22.9
745	83	missing_note	Пропущена нота E7	E7	—	22.9
746	83	wrong_pitch	Отклонение ноты C#4	C#4	B4	22.91
747	83	late	Задержка начала ноты	0 ms	791 ms	22.91
748	83	articulation	Несоответствие длительности ноты	0.02s	0.14s	22.91
749	83	wrong_pitch	Отклонение ноты B5	B5	F#4	22.91
750	83	late	Задержка начала ноты	0 ms	791 ms	22.91
751	83	articulation	Несоответствие длительности ноты	0.05s	0.18s	22.91
752	83	missing_note	Пропущена нота F5	F5	—	22.91
753	83	missing_note	Пропущена нота E6	E6	—	22.91
754	83	missing_note	Пропущена нота C#6	C#6	—	22.92
755	83	missing_note	Пропущена нота F4	F4	—	22.93
756	83	missing_note	Пропущена нота G5	G5	—	22.93
757	83	missing_note	Пропущена нота D#6	D#6	—	22.94
758	83	missing_note	Пропущена нота E4	E4	—	22.95
759	83	missing_note	Пропущена нота E4	E4	—	23.03
760	83	wrong_pitch	Отклонение ноты F4	F4	D6	23.66
761	83	late	Задержка начала ноты	0 ms	617 ms	23.66
762	83	articulation	Несоответствие длительности ноты	0.03s	0.21s	23.66
763	83	missing_note	Пропущена нота E5	E5	—	23.66
764	83	wrong_pitch	Отклонение ноты F4	F4	D6	23.78
765	83	late	Задержка начала ноты	0 ms	710 ms	23.78
766	83	articulation	Несоответствие длительности ноты	0.03s	0.20s	23.78
767	83	missing_note	Пропущена нота D5	D5	—	23.8
768	83	missing_note	Пропущена нота E6	E6	—	23.8
769	83	missing_note	Пропущена нота E5	E5	—	23.88
770	83	wrong_pitch	Отклонение ноты G5	G5	D6	24.01
771	83	late	Задержка начала ноты	0 ms	674 ms	24.01
772	83	articulation	Несоответствие длительности ноты	0.08s	0.14s	24.01
773	83	wrong_pitch	Отклонение ноты E5	E5	B5	24.09
774	83	late	Задержка начала ноты	0 ms	779 ms	24.09
775	83	articulation	Несоответствие длительности ноты	0.03s	0.29s	24.09
776	83	missing_note	Пропущена нота G#5	G#5	—	24.1
777	83	missing_note	Пропущена нота D#7	D#7	—	24.13
778	83	missing_note	Пропущена нота F4	F4	—	24.33
779	83	missing_note	Пропущена нота G#5	G#5	—	24.33
780	83	missing_note	Пропущена нота D#7	D#7	—	24.36
781	83	missing_note	Пропущена нота F4	F4	—	24.41
782	83	missing_note	Пропущена нота A#5	A#5	—	24.42
783	83	missing_note	Пропущена нота B5	B5	—	24.51
784	83	missing_note	Пропущена нота C#6	C#6	—	24.53
785	83	missing_note	Пропущена нота A5	A5	—	24.53
786	83	missing_note	Пропущена нота F4	F4	—	24.55
787	83	missing_note	Пропущена нота F#7	F#7	—	24.57
788	83	missing_note	Пропущена нота E4	E4	—	24.62
789	83	missing_note	Пропущена нота A#5	A#5	—	24.63
790	83	missing_note	Пропущена нота A5	A5	—	24.74
791	83	missing_note	Пропущена нота F5	F5	—	24.76
792	83	missing_note	Пропущена нота G#5	G#5	—	24.76
793	83	missing_note	Пропущена нота A#5	A#5	—	24.77
794	83	missing_note	Пропущена нота D#7	D#7	—	24.78
795	83	wrong_pitch	Отклонение ноты F4	F4	D#6	24.86
796	83	late	Задержка начала ноты	0 ms	766 ms	24.86
797	83	articulation	Несоответствие длительности ноты	0.02s	0.27s	24.86
798	83	missing_note	Пропущена нота D5	D5	—	24.86
799	83	missing_note	Пропущена нота D6	D6	—	24.86
800	83	missing_note	Пропущена нота A6	A6	—	24.88
801	83	missing_note	Пропущена нота E4	E4	—	24.93
802	83	missing_note	Пропущена нота D5	D5	—	24.93
803	83	missing_note	Пропущена нота F5	F5	—	24.98
804	83	missing_note	Пропущена нота G#5	G#5	—	24.99
805	83	missing_note	Пропущена нота D#7	D#7	—	25
806	83	missing_note	Пропущена нота E4	E4	—	25.06
807	83	missing_note	Пропущена нота G6	G6	—	25.09
808	83	wrong_pitch	Отклонение ноты G5	G5	D#6	25.12
809	83	late	Задержка начала ноты	0 ms	779 ms	25.12
810	83	articulation	Несоответствие длительности ноты	0.06s	0.29s	25.12
811	83	missing_note	Пропущена нота E5	E5	—	25.17
812	83	missing_note	Пропущена нота G5	G5	—	25.19
813	83	missing_note	Пропущена нота D5	D5	—	25.29
814	83	missing_note	Пропущена нота A6	A6	—	25.33
815	83	missing_note	Пропущена нота E5	E5	—	25.37
816	83	wrong_pitch	Отклонение ноты F#4	F#4	D#6	25.4
817	83	late	Задержка начала ноты	0 ms	790 ms	25.4
818	83	articulation	Несоответствие длительности ноты	0.03s	0.21s	25.4
819	83	missing_note	Пропущена нота B6	B6	—	25.4
820	83	missing_note	Пропущена нота F4	F4	—	25.49
821	83	missing_note	Пропущена нота D5	D5	—	25.51
822	83	missing_note	Пропущена нота D6	D6	—	25.51
823	83	missing_note	Пропущена нота A6	A6	—	25.53
824	83	missing_note	Пропущена нота D5	D5	—	25.58
825	83	missing_note	Пропущена нота F#4	F#4	—	25.59
826	83	missing_note	Пропущена нота E5	E5	—	25.59
827	83	missing_note	Пропущена нота B6	B6	—	25.6
828	83	wrong_pitch	Отклонение ноты G6	G6	D6	25.71
829	83	late	Задержка начала ноты	0 ms	743 ms	25.71
830	83	articulation	Несоответствие длительности ноты	0.09s	0.22s	25.71
831	83	missing_note	Пропущена нота G5	G5	—	25.74
832	83	missing_note	Пропущена нота A5	A5	—	25.79
833	83	missing_note	Пропущена нота F5	F5	—	25.8
834	83	missing_note	Пропущена нота G#6	G#6	—	25.8
835	83	missing_note	Пропущена нота G6	G6	—	25.81
836	83	missing_note	Пропущена нота D#7	D#7	—	25.81
837	83	missing_note	Пропущена нота G#5	G#5	—	25.81
838	83	wrong_pitch	Отклонение ноты E4	E4	D6	25.88
839	83	late	Задержка начала ноты	0 ms	789 ms	25.88
840	83	articulation	Несоответствие длительности ноты	0.03s	0.20s	25.88
841	83	missing_note	Пропущена нота D5	D5	—	25.92
842	83	missing_note	Пропущена нота D6	D6	—	25.92
843	83	missing_note	Пропущена нота F4	F4	—	26.02
844	83	missing_note	Пропущена нота G#5	G#5	—	26.02
845	83	wrong_pitch	Отклонение ноты A#5	A#5	D6	26.1
846	83	late	Задержка начала ноты	0 ms	765 ms	26.1
847	83	articulation	Несоответствие длительности ноты	0.10s	0.19s	26.1
848	83	missing_note	Пропущена нота A5	A5	—	26.21
849	83	missing_note	Пропущена нота B5	B5	—	26.21
850	83	missing_note	Пропущена нота F5	F5	—	26.22
851	83	missing_note	Пропущена нота F#7	F#7	—	26.26
852	83	wrong_pitch	Отклонение ноты F4	F4	D6	26.29
853	83	late	Задержка начала ноты	0 ms	765 ms	26.29
854	83	articulation	Несоответствие длительности ноты	0.03s	0.42s	26.29
855	83	missing_note	Пропущена нота D#4	D#4	—	26.31
856	83	missing_note	Пропущена нота A#5	A#5	—	26.33
857	83	missing_note	Пропущена нота B5	B5	—	26.36
858	83	missing_note	Пропущена нота F4	F4	—	26.42
859	83	missing_note	Пропущена нота G#6	G#6	—	26.42
860	83	missing_note	Пропущена нота G#5	G#5	—	26.43
861	83	missing_note	Пропущена нота D5	D5	—	26.52
862	83	missing_note	Пропущена нота D6	D6	—	26.53
863	83	missing_note	Пропущена нота G#5	G#5	—	26.62
864	83	missing_note	Пропущена нота D#4	D#4	—	26.63
865	83	missing_note	Пропущена нота F5	F5	—	26.64
866	83	missing_note	Пропущена нота A5	A5	—	26.69
867	83	missing_note	Пропущена нота B5	B5	—	26.71
868	83	missing_note	Пропущена нота E6	E6	—	26.84
869	83	missing_note	Пропущена нота C#6	C#6	—	26.85
870	83	missing_note	Пропущена нота F5	F5	—	26.86
871	83	missing_note	Пропущена нота D6	D6	—	26.86
872	83	missing_note	Пропущена нота D#6	D#6	—	26.88
873	83	wrong_pitch	Отклонение ноты F4	F4	D6	27.27
874	83	late	Задержка начала ноты	0 ms	462 ms	27.27
875	83	articulation	Несоответствие длительности ноты	0.05s	0.21s	27.27
876	83	wrong_pitch	Отклонение ноты G5	G5	B5	27.27
877	83	late	Задержка начала ноты	0 ms	753 ms	27.27
878	83	articulation	Несоответствие длительности ноты	0.17s	0.45s	27.27
879	83	missing_note	Пропущена нота B5	B5	—	27.28
880	83	missing_note	Пропущена нота A5	A5	—	27.29
881	83	missing_note	Пропущена нота F#7	F#7	—	27.29
882	83	missing_note	Пропущена нота G#5	G#5	—	27.49
883	83	missing_note	Пропущена нота F4	F4	—	27.5
884	83	missing_note	Пропущена нота F5	F5	—	27.5
885	83	missing_note	Пропущена нота B5	B5	—	27.5
886	83	missing_note	Пропущена нота C#6	C#6	—	27.51
887	83	missing_note	Пропущена нота D6	D6	—	27.51
888	83	missing_note	Пропущена нота E4	E4	—	27.52
889	83	missing_note	Пропущена нота A5	A5	—	27.53
890	83	missing_note	Пропущена нота D#6	D#6	—	27.53
891	83	missing_note	Пропущена нота D#7	D#7	—	27.67
892	83	missing_note	Пропущена нота F4	F4	—	27.71
893	83	missing_note	Пропущена нота E6	E6	—	27.72
894	83	missing_note	Пропущена нота B5	B5	—	27.73
895	83	missing_note	Пропущена нота C#6	C#6	—	27.73
896	83	missing_note	Пропущена нота D6	D6	—	27.74
897	83	missing_note	Пропущена нота A#5	A#5	—	27.74
898	83	missing_note	Пропущена нота D#6	D#6	—	27.76
899	83	missing_note	Пропущена нота F4	F4	—	27.8
900	83	missing_note	Пропущена нота F4	F4	—	27.93
901	83	missing_note	Пропущена нота B5	B5	—	27.95
902	83	missing_note	Пропущена нота C#6	C#6	—	27.95
903	83	missing_note	Пропущена нота D6	D6	—	27.95
904	83	missing_note	Пропущена нота D#6	D#6	—	27.97
905	83	missing_note	Пропущена нота D#7	D#7	—	27.97
906	83	missing_note	Пропущена нота A#5	A#5	—	27.98
907	83	missing_note	Пропущена нота E4	E4	—	27.99
908	83	missing_note	Пропущена нота F4	F4	—	28.16
909	83	missing_note	Пропущена нота B5	B5	—	28.16
910	83	missing_note	Пропущена нота D#4	D#4	—	28.19
911	83	wrong_pitch	Отклонение ноты F4	F4	D#5	28.36
912	83	late	Задержка начала ноты	0 ms	775 ms	28.36
913	83	articulation	Несоответствие длительности ноты	0.06s	0.17s	28.36
914	83	missing_note	Пропущена нота E5	E5	—	28.36
915	83	missing_note	Пропущена нота B6	B6	—	28.38
916	83	missing_note	Пропущена нота A5	A5	—	28.38
917	83	missing_note	Пропущена нота E4	E4	—	28.42
918	83	missing_note	Пропущена нота F4	F4	—	28.45
919	83	missing_note	Пропущена нота F#4	F#4	—	28.57
920	83	missing_note	Пропущена нота D5	D5	—	28.57
921	83	missing_note	Пропущена нота D6	D6	—	28.57
922	83	missing_note	Пропущена нота D4	D4	—	28.58
923	83	missing_note	Пропущена нота D#5	D#5	—	28.59
924	83	missing_note	Пропущена нота F5	F5	—	28.6
925	83	missing_note	Пропущена нота G#5	G#5	—	28.62
926	83	missing_note	Пропущена нота G6	G6	—	28.62
927	83	wrong_pitch	Отклонение ноты D5	D5	E6	28.63
928	83	late	Задержка начала ноты	0 ms	798 ms	28.63
929	83	articulation	Несоответствие длительности ноты	0.03s	0.16s	28.63
930	83	wrong_pitch	Отклонение ноты E4	E4	E5	28.64
931	83	late	Задержка начала ноты	0 ms	786 ms	28.64
932	83	articulation	Несоответствие длительности ноты	0.03s	0.29s	28.64
933	83	missing_note	Пропущена нота G5	G5	—	28.64
934	83	wrong_pitch	Отклонение ноты D5	D5	G#5	28.67
935	83	late	Задержка начала ноты	0 ms	774 ms	28.67
936	83	articulation	Несоответствие длительности ноты	0.03s	0.31s	28.67
937	83	missing_note	Пропущена нота G#5	G#5	—	28.67
938	83	missing_note	Пропущена нота F#4	F#4	—	28.78
939	83	missing_note	Пропущена нота E5	E5	—	28.79
940	83	missing_note	Пропущена нота A5	A5	—	28.81
941	83	missing_note	Пропущена нота F4	F4	—	28.83
942	83	missing_note	Пропущена нота E4	E4	—	28.85
943	83	missing_note	Пропущена нота F4	F4	—	28.9
944	83	missing_note	Пропущена нота A#5	A#5	—	28.91
945	83	missing_note	Пропущена нота G5	G5	—	29
946	83	missing_note	Пропущена нота D4	D4	—	29.01
947	83	missing_note	Пропущена нота F4	F4	—	29.01
948	83	missing_note	Пропущена нота E5	E5	—	29.05
949	83	missing_note	Пропущена нота E4	E4	—	29.06
950	83	missing_note	Пропущена нота F4	F4	—	29.1
951	83	missing_note	Пропущена нота E5	E5	—	29.21
952	83	missing_note	Пропущена нота F#4	F#4	—	29.22
953	83	missing_note	Пропущена нота D4	D4	—	29.23
954	83	missing_note	Пропущена нота G#5	G#5	—	29.24
955	83	missing_note	Пропущена нота E4	E4	—	29.27
956	83	wrong_pitch	Отклонение ноты C#5	C#5	F#5	29.44
957	83	late	Задержка начала ноты	0 ms	740 ms	29.44
958	83	articulation	Несоответствие длительности ноты	0.03s	0.21s	29.44
959	83	wrong_pitch	Отклонение ноты G5	G5	A#5	29.47
960	83	late	Задержка начала ноты	0 ms	740 ms	29.47
961	83	articulation	Несоответствие длительности ноты	0.03s	0.22s	29.47
962	83	missing_note	Пропущена нота E4	E4	—	29.49
963	83	missing_note	Пропущена нота F#5	F#5	—	29.5
964	83	missing_note	Пропущена нота G5	G5	—	29.51
965	83	missing_note	Пропущена нота F#5	F#5	—	29.57
966	83	missing_note	Пропущена нота F#4	F#4	—	29.66
967	83	missing_note	Пропущена нота B5	B5	—	29.66
968	83	missing_note	Пропущена нота B4	B4	—	29.69
969	83	missing_note	Пропущена нота F5	F5	—	29.7
970	83	missing_note	Пропущена нота E4	E4	—	29.72
971	83	wrong_pitch	Отклонение ноты E6	E6	A5	29.87
972	83	late	Задержка начала ноты	0 ms	693 ms	29.87
973	83	wrong_pitch	Отклонение ноты A5	A5	F6	29.87
974	83	late	Задержка начала ноты	0 ms	693 ms	29.87
975	83	missing_note	Пропущена нота F4	F4	—	29.88
976	83	missing_note	Пропущена нота A4	A4	—	29.88
977	83	missing_note	Пропущена нота D6	D6	—	29.91
978	83	missing_note	Пропущена нота E4	E4	—	29.93
979	83	missing_note	Пропущена нота D5	D5	—	29.98
980	83	missing_note	Пропущена нота B5	B5	—	30.07
981	83	missing_note	Пропущена нота F#4	F#4	—	30.08
982	83	missing_note	Пропущена нота B4	B4	—	30.09
983	83	missing_note	Пропущена нота E5	E5	—	30.1
984	83	missing_note	Пропущена нота D#4	D#4	—	30.12
985	83	missing_note	Пропущена нота F5	F5	—	30.17
986	83	missing_note	Пропущена нота F#4	F#4	—	30.3
987	83	missing_note	Пропущена нота D5	D5	—	30.3
988	83	missing_note	Пропущена нота C4	C4	—	30.33
989	83	missing_note	Пропущена нота G5	G5	—	30.33
990	83	missing_note	Пропущена нота G6	G6	—	30.33
991	83	missing_note	Пропущена нота B4	B4	—	30.34
992	83	missing_note	Пропущена нота E4	E4	—	30.35
993	83	missing_note	Пропущена нота F#5	F#5	—	30.36
994	83	missing_note	Пропущена нота D5	D5	—	30.36
995	83	missing_note	Пропущена нота G5	G5	—	30.38
996	83	missing_note	Пропущена нота E4	E4	—	30.4
997	83	missing_note	Пропущена нота G5	G5	—	30.45
998	83	wrong_pitch	Отклонение ноты D6	D6	E5	30.93
999	83	late	Задержка начала ноты	0 ms	482 ms	30.93
1000	83	articulation	Несоответствие длительности ноты	0.06s	0.29s	30.93
1001	83	wrong_pitch	Отклонение ноты D5	D5	G#5	30.99
1002	83	late	Задержка начала ноты	0 ms	470 ms	30.99
1003	83	articulation	Несоответствие длительности ноты	0.06s	0.20s	30.99
1004	83	wrong_pitch	Отклонение ноты D5	D5	F6	31.07
1005	83	late	Задержка начала ноты	0 ms	667 ms	31.07
1006	83	articulation	Несоответствие длительности ноты	0.05s	0.14s	31.07
1007	83	wrong_pitch	Отклонение ноты F4	F4	F5	31.08
1008	83	late	Задержка начала ноты	0 ms	656 ms	31.08
1009	83	articulation	Несоответствие длительности ноты	0.03s	0.26s	31.08
1010	83	wrong_pitch	Отклонение ноты D5	D5	A5	31.14
1011	83	late	Задержка начала ноты	0 ms	621 ms	31.14
1012	83	articulation	Несоответствие длительности ноты	0.07s	0.20s	31.14
1013	83	missing_note	Пропущена нота F4	F4	—	31.19
1014	83	missing_note	Пропущена нота B5	B5	—	31.19
1015	83	missing_note	Пропущена нота B4	B4	—	31.2
1016	83	wrong_pitch	Отклонение ноты F4	F4	B5	31.78
1017	83	late	Задержка начала ноты	0 ms	737 ms	31.78
1018	83	articulation	Несоответствие длительности ноты	0.03s	0.26s	31.78
1019	83	missing_note	Пропущена нота D#5	D#5	—	31.78
1020	83	missing_note	Пропущена нота F4	F4	—	31.99
1021	83	missing_note	Пропущена нота D#5	D#5	—	32
1022	83	wrong_pitch	Отклонение ноты F4	F4	A5	32.21
1023	83	late	Задержка начала ноты	0 ms	644 ms	32.21
1024	83	articulation	Несоответствие длительности ноты	0.03s	0.19s	32.21
1025	83	wrong_pitch	Отклонение ноты D#5	D#5	F#6	32.21
1026	83	late	Задержка начала ноты	0 ms	655 ms	32.21
1027	83	missing_note	Пропущена нота E4	E4	—	32.4
1028	83	missing_note	Пропущена нота B5	B5	—	32.41
1029	83	missing_note	Пропущена нота D#4	D#4	—	32.43
1030	83	missing_note	Пропущена нота D5	D5	—	32.43
1031	83	missing_note	Пропущена нота E4	E4	—	32.47
1032	83	missing_note	Пропущена нота D#4	D#4	—	32.49
1033	83	missing_note	Пропущена нота F4	F4	—	32.53
1034	83	missing_note	Пропущена нота E5	E5	—	32.57
1035	83	missing_note	Пропущена нота D6	D6	—	32.71
1036	83	missing_note	Пропущена нота D5	D5	—	32.72
1037	83	missing_note	Пропущена нота D5	D5	—	32.88
1038	83	wrong_pitch	Отклонение ноты F4	F4	E6	33.02
1039	83	late	Задержка начала ноты	0 ms	760 ms	33.02
1040	83	articulation	Несоответствие длительности ноты	0.03s	0.19s	33.02
1041	83	wrong_pitch	Отклонение ноты D6	D6	E5	33.03
1042	83	late	Задержка начала ноты	0 ms	760 ms	33.03
1043	83	articulation	Несоответствие длительности ноты	0.07s	0.19s	33.03
1044	83	missing_note	Пропущена нота D5	D5	—	33.09
1045	83	wrong_pitch	Отклонение ноты B5	B5	D5	33.26
1046	83	late	Задержка начала ноты	0 ms	690 ms	33.26
1047	83	articulation	Несоответствие длительности ноты	0.19s	0.14s	33.26
1048	83	missing_note	Пропущена нота B4	B4	—	33.28
1049	83	wrong_pitch	Отклонение ноты F4	F4	E6	33.86
1050	83	late	Задержка начала ноты	0 ms	294 ms	33.86
1051	83	articulation	Несоответствие длительности ноты	0.03s	0.23s	33.86
1052	83	wrong_pitch	Отклонение ноты A5	A5	E5	33.86
1053	83	late	Задержка начала ноты	0 ms	294 ms	33.86
1054	83	articulation	Несоответствие длительности ноты	0.15s	0.33s	33.86
1055	83	wrong_pitch	Отклонение ноты E4	E4	G#5	33.94
1056	83	late	Задержка начала ноты	0 ms	364 ms	33.94
1057	83	articulation	Несоответствие длительности ноты	0.03s	0.14s	33.94
1058	83	wrong_pitch	Отклонение ноты F#4	F#4	A5	33.97
1059	83	late	Задержка начала ноты	0 ms	608 ms	33.97
1060	83	articulation	Несоответствие длительности ноты	0.02s	0.17s	33.97
1061	83	wrong_pitch	Отклонение ноты D5	D5	G#5	33.97
1062	83	late	Задержка начала ноты	0 ms	782 ms	33.97
1063	83	articulation	Несоответствие длительности ноты	0.14s	0.21s	33.97
1064	83	missing_note	Пропущена нота D6	D6	—	33.98
1065	83	missing_note	Пропущена нота A5	A5	—	34.05
1066	83	missing_note	Пропущена нота C#6	C#6	—	34.07
1067	83	missing_note	Пропущена нота B5	B5	—	34.08
1068	83	missing_note	Пропущена нота F4	F4	—	34.09
1069	83	missing_note	Пропущена нота D#6	D#6	—	34.09
1070	83	missing_note	Пропущена нота C6	C6	—	34.1
1071	83	missing_note	Пропущена нота C#6	C#6	—	34.15
1072	83	wrong_pitch	Отклонение ноты D6	D6	A5	34.19
1073	83	late	Задержка начала ноты	0 ms	770 ms	34.19
1074	83	articulation	Несоответствие длительности ноты	0.07s	0.20s	34.19
1075	83	missing_note	Пропущена нота C#6	C#6	—	34.29
1076	83	missing_note	Пропущена нота B5	B5	—	34.3
1077	83	missing_note	Пропущена нота D6	D6	—	34.3
1078	83	missing_note	Пропущена нота D#6	D#6	—	34.31
1079	83	wrong_pitch	Отклонение ноты C#6	C#6	B5	34.41
1080	83	late	Задержка начала ноты	0 ms	711 ms	34.41
1081	83	articulation	Несоответствие длительности ноты	0.03s	0.15s	34.41
1082	83	wrong_pitch	Отклонение ноты C#6	C#6	C6	34.51
1083	83	late	Задержка начала ноты	0 ms	792 ms	34.51
1084	83	articulation	Несоответствие длительности ноты	0.05s	0.16s	34.51
1085	83	missing_note	Пропущена нота D6	D6	—	34.51
1086	83	missing_note	Пропущена нота D5	D5	—	34.62
1087	83	missing_note	Пропущена нота A6	A6	—	34.65
1088	83	wrong_pitch	Отклонение ноты F4	F4	B5	34.71
1089	83	late	Задержка начала ноты	0 ms	757 ms	34.71
1090	83	articulation	Несоответствие длительности ноты	0.05s	0.14s	34.71
1091	83	missing_note	Пропущена нота F5	F5	—	34.72
1092	83	missing_note	Пропущена нота C#7	C#7	—	34.72
1093	83	missing_note	Пропущена нота F#6	F#6	—	34.72
1094	83	missing_note	Пропущена нота F#5	F#5	—	34.74
1095	83	missing_note	Пропущена нота E4	E4	—	34.8
1096	83	missing_note	Пропущена нота D5	D5	—	34.83
1097	83	wrong_pitch	Отклонение ноты F4	F4	A5	34.84
1098	83	late	Задержка начала ноты	0 ms	792 ms	34.84
1099	83	articulation	Несоответствие длительности ноты	0.02s	0.13s	34.84
1100	83	missing_note	Пропущена нота D6	D6	—	34.84
1101	83	missing_note	Пропущена нота A6	A6	—	34.86
1102	83	missing_note	Пропущена нота E4	E4	—	34.9
1103	83	missing_note	Пропущена нота C7	C7	—	34.92
1104	83	missing_note	Пропущена нота F5	F5	—	34.92
1105	83	missing_note	Пропущена нота D#4	D#4	—	34.93
1106	83	missing_note	Пропущена нота F4	F4	—	34.93
1107	83	missing_note	Пропущена нота E4	E4	—	34.95
1108	83	missing_note	Пропущена нота D#4	D#4	—	35.02
1109	83	missing_note	Пропущена нота D5	D5	—	35.03
1110	83	missing_note	Пропущена нота A6	A6	—	35.06
1111	83	missing_note	Пропущена нота E4	E4	—	35.1
1112	83	missing_note	Пропущена нота F4	F4	—	35.14
1113	83	missing_note	Пропущена нота E4	E4	—	35.21
1114	83	wrong_pitch	Отклонение ноты F4	F4	A5	35.24
1115	83	late	Задержка начала ноты	0 ms	769 ms	35.24
1116	83	articulation	Несоответствие длительности ноты	0.02s	0.14s	35.24
1117	83	missing_note	Пропущена нота D5	D5	—	35.24
1118	83	missing_note	Пропущена нота F4	F4	—	35.34
1119	83	missing_note	Пропущена нота C7	C7	—	35.35
1120	83	wrong_pitch	Отклонение ноты E4	E4	G#5	35.42
1121	83	late	Задержка начала ноты	0 ms	746 ms	35.42
1122	83	articulation	Несоответствие длительности ноты	0.05s	0.16s	35.42
1123	83	missing_note	Пропущена нота F5	F5	—	35.44
1124	83	missing_note	Пропущена нота D6	D6	—	35.47
1125	83	missing_note	Пропущена нота D5	D5	—	35.47
1126	83	missing_note	Пропущена нота F4	F4	—	35.56
1127	83	missing_note	Пропущена нота A5	A5	—	35.56
1128	83	missing_note	Пропущена нота E7	E7	—	35.6
1129	83	missing_note	Пропущена нота F4	F4	—	35.65
1130	83	missing_note	Пропущена нота D6	D6	—	35.67
1131	83	wrong_pitch	Отклонение ноты A5	A5	E5	35.73
1132	83	late	Задержка начала ноты	0 ms	769 ms	35.73
1133	83	articulation	Несоответствие длительности ноты	0.08s	0.19s	35.73
1134	83	wrong_pitch	Отклонение ноты F4	F4	E6	35.74
1135	83	late	Задержка начала ноты	0 ms	757 ms	35.74
1136	83	articulation	Несоответствие длительности ноты	0.06s	0.22s	35.74
1137	83	missing_note	Пропущена нота D4	D4	—	35.77
1138	83	missing_note	Пропущена нота B5	B5	—	35.77
1139	83	missing_note	Пропущена нота C#6	C#6	—	35.77
1140	83	missing_note	Пропущена нота D6	D6	—	35.77
1141	83	missing_note	Пропущена нота D#6	D#6	—	35.78
1142	83	missing_note	Пропущена нота F4	F4	—	35.87
1143	83	missing_note	Пропущена нота D5	D5	—	35.88
1144	83	wrong_pitch	Отклонение ноты D5	D5	E5	35.95
1145	83	late	Задержка начала ноты	0 ms	733 ms	35.95
1146	83	articulation	Несоответствие длительности ноты	0.03s	0.17s	35.95
1147	83	missing_note	Пропущена нота F4	F4	—	35.99
1148	83	missing_note	Пропущена нота B5	B5	—	35.99
1149	83	missing_note	Пропущена нота C#6	C#6	—	35.99
1150	83	missing_note	Пропущена нота D#6	D#6	—	36
1151	83	wrong_pitch	Отклонение ноты D#4	D#4	D5	36.09
1152	83	late	Задержка начала ноты	0 ms	756 ms	36.09
1153	83	articulation	Несоответствие длительности ноты	0.05s	0.15s	36.09
1154	83	missing_note	Пропущена нота D5	D5	—	36.09
1155	83	missing_note	Пропущена нота A6	A6	—	36.13
1156	83	missing_note	Пропущена нота C#6	C#6	—	36.19
1157	83	missing_note	Пропущена нота D6	D6	—	36.19
1158	83	missing_note	Пропущена нота D4	D4	—	36.2
1159	83	missing_note	Пропущена нота B5	B5	—	36.2
1160	83	missing_note	Пропущена нота D#6	D#6	—	36.21
1161	83	wrong_pitch	Отклонение ноты C#6	C#6	E6	36.27
1162	83	late	Задержка начала ноты	0 ms	745 ms	36.27
1163	83	articulation	Несоответствие длительности ноты	0.03s	0.21s	36.27
1164	83	wrong_pitch	Отклонение ноты D5	D5	E5	36.3
1165	83	late	Задержка начала ноты	0 ms	710 ms	36.3
1166	83	articulation	Несоответствие длительности ноты	0.13s	0.27s	36.3
1167	83	missing_note	Пропущена нота A6	A6	—	36.34
1168	83	missing_note	Пропущена нота F5	F5	—	36.36
1169	83	missing_note	Пропущена нота F4	F4	—	36.41
1170	83	missing_note	Пропущена нота F#6	F#6	—	36.41
1171	83	missing_note	Пропущена нота E4	E4	—	36.43
1172	83	missing_note	Пропущена нота F#5	F#5	—	36.43
1173	83	missing_note	Пропущена нота E4	E4	—	36.48
1174	83	missing_note	Пропущена нота F#5	F#5	—	36.51
1175	83	missing_note	Пропущена нота D6	D6	—	36.51
1176	83	missing_note	Пропущена нота D5	D5	—	36.51
1177	83	missing_note	Пропущена нота A6	A6	—	36.55
1178	83	wrong_pitch	Отклонение ноты F5	F5	A5	36.6
1179	83	late	Задержка начала ноты	0 ms	779 ms	36.6
1180	83	articulation	Несоответствие длительности ноты	0.42s	0.16s	36.6
1181	83	missing_note	Пропущена нота C7	C7	—	36.62
1182	83	missing_note	Пропущена нота D4	D4	—	36.63
1183	83	missing_note	Пропущена нота D5	D5	—	36.72
1184	83	missing_note	Пропущена нота D#4	D#4	—	36.73
1185	83	missing_note	Пропущена нота D6	D6	—	36.73
1186	83	missing_note	Пропущена нота A6	A6	—	36.74
1187	83	wrong_pitch	Отклонение ноты E4	E4	G#5	36.81
1188	83	late	Задержка начала ноты	0 ms	732 ms	36.81
1189	83	articulation	Несоответствие длительности ноты	0.03s	0.17s	36.81
1190	83	missing_note	Пропущена нота C7	C7	—	36.84
1191	83	missing_note	Пропущена нота E4	E4	—	36.91
1192	83	missing_note	Пропущена нота D5	D5	—	36.93
1193	83	missing_note	Пропущена нота F4	F4	—	36.94
1194	83	wrong_pitch	Отклонение ноты A6	A6	A5	36.97
1195	83	late	Задержка начала ноты	0 ms	778 ms	36.97
1196	83	articulation	Несоответствие длительности ноты	0.03s	0.22s	36.97
1197	83	missing_note	Пропущена нота D5	D5	—	37
1198	83	missing_note	Пропущена нота F4	F4	—	37.03
1199	83	missing_note	Пропущена нота F6	F6	—	37.03
1200	83	missing_note	Пропущена нота C7	C7	—	37.05
1201	83	missing_note	Пропущена нота F5	F5	—	37.05
1202	83	missing_note	Пропущена нота F4	F4	—	37.14
1203	83	missing_note	Пропущена нота F5	F5	—	37.14
1204	83	missing_note	Пропущена нота D5	D5	—	37.15
1205	83	missing_note	Пропущена нота D6	D6	—	37.15
1206	83	missing_note	Пропущена нота A6	A6	—	37.19
1207	83	missing_note	Пропущена нота D5	D5	—	37.22
1208	83	missing_note	Пропущена нота F#4	F#4	—	37.24
1209	83	missing_note	Пропущена нота B5	B5	—	37.24
1210	83	missing_note	Пропущена нота F5	F5	—	37.24
1211	83	missing_note	Пропущена нота A5	A5	—	37.24
1212	83	wrong_pitch	Отклонение ноты E7	E7	A4	37.28
1213	83	late	Задержка начала ноты	0 ms	779 ms	37.28
1214	83	articulation	Несоответствие длительности ноты	0.05s	0.20s	37.28
1215	83	missing_note	Пропущена нота E4	E4	—	37.33
1216	83	missing_note	Пропущена нота D5	D5	—	37.35
1217	83	missing_note	Пропущена нота F4	F4	—	37.36
1218	83	missing_note	Пропущена нота D6	D6	—	37.36
1219	83	missing_note	Пропущена нота A5	A5	—	37.42
1220	83	missing_note	Пропущена нота C#6	C#6	—	37.44
1221	83	missing_note	Пропущена нота F4	F4	—	37.45
1222	83	missing_note	Пропущена нота B5	B5	—	37.45
1223	83	wrong_pitch	Отклонение ноты E4	E4	A4	37.48
1224	83	late	Задержка начала ноты	0 ms	779 ms	37.48
1225	83	articulation	Несоответствие длительности ноты	0.02s	0.33s	37.48
1226	83	missing_note	Пропущена нота D6	D6	—	37.48
1227	83	wrong_pitch	Отклонение ноты F4	F4	E4	37.56
1228	83	late	Задержка начала ноты	0 ms	744 ms	37.56
1229	83	articulation	Несоответствие длительности ноты	0.05s	0.21s	37.56
1230	83	missing_note	Пропущена нота D5	D5	—	37.57
1231	83	missing_note	Пропущена нота D6	D6	—	37.57
1232	83	missing_note	Пропущена нота A6	A6	—	37.59
1233	83	missing_note	Пропущена нота C#6	C#6	—	37.6
1234	83	wrong_pitch	Отклонение ноты D5	D5	G#5	37.64
1235	83	late	Задержка начала ноты	0 ms	767 ms	37.64
1236	83	articulation	Несоответствие длительности ноты	0.03s	0.17s	37.64
1237	83	missing_note	Пропущена нота A5	A5	—	37.66
1238	83	missing_note	Пропущена нота C6	C6	—	37.66
1239	83	missing_note	Пропущена нота F4	F4	—	37.67
1240	83	missing_note	Пропущена нота B5	B5	—	37.67
1241	83	missing_note	Пропущена нота E4	E4	—	37.7
1242	83	missing_note	Пропущена нота E4	E4	—	37.74
1243	83	missing_note	Пропущена нота F4	F4	—	37.78
1244	83	wrong_pitch	Отклонение ноты C#6	C#6	A4	37.79
1245	83	late	Задержка начала ноты	0 ms	790 ms	37.79
1246	83	articulation	Несоответствие длительности ноты	0.05s	0.43s	37.79
1247	83	missing_note	Пропущена нота D6	D6	—	37.79
1248	83	missing_note	Пропущена нота D5	D5	—	37.79
1249	83	missing_note	Пропущена нота A6	A6	—	37.8
1250	83	missing_note	Пропущена нота C6	C6	—	37.84
1251	83	missing_note	Пропущена нота E4	E4	—	37.86
1252	83	missing_note	Пропущена нота A5	A5	—	37.87
1253	83	missing_note	Пропущена нота F4	F4	—	37.88
1254	83	missing_note	Пропущена нота E7	E7	—	37.9
1255	83	missing_note	Пропущена нота F4	F4	—	37.98
1256	83	wrong_pitch	Отклонение ноты D5	D5	A5	38
1257	83	late	Задержка начала ноты	0 ms	778 ms	38
1258	83	articulation	Несоответствие длительности ноты	0.06s	0.19s	38
1259	83	missing_note	Пропущена нота D#4	D#4	—	38.01
1260	83	missing_note	Пропущена нота D6	D6	—	38.01
1261	83	missing_note	Пропущена нота E4	E4	—	38.03
1262	83	missing_note	Пропущена нота D5	D5	—	38.07
1263	83	missing_note	Пропущена нота F4	F4	—	38.08
1264	83	missing_note	Пропущена нота E7	E7	—	38.1
1265	83	wrong_pitch	Отклонение ноты E4	E4	B5	38.19
1266	83	late	Задержка начала ноты	0 ms	743 ms	38.19
1267	83	articulation	Несоответствие длительности ноты	0.02s	0.14s	38.19
1268	83	missing_note	Пропущена нота D5	D5	—	38.2
1269	83	missing_note	Пропущена нота D6	D6	—	38.2
1270	83	missing_note	Пропущена нота F4	F4	—	38.21
1271	83	missing_note	Пропущена нота D5	D5	—	38.27
1272	83	missing_note	Пропущена нота D#4	D#4	—	38.29
1273	83	missing_note	Пропущена нота F5	F5	—	38.3
1274	83	missing_note	Пропущена нота G#5	G#5	—	38.3
1275	83	missing_note	Пропущена нота G6	G6	—	38.3
1276	83	missing_note	Пропущена нота D#7	D#7	—	38.3
1277	83	wrong_pitch	Отклонение ноты F#4	F#4	D#6	38.4
1278	83	late	Задержка начала ноты	0 ms	731 ms	38.4
1279	83	articulation	Несоответствие длительности ноты	0.02s	0.14s	38.4
1280	83	missing_note	Пропущена нота G#5	G#5	—	38.4
1281	83	missing_note	Пропущена нота D5	D5	—	38.41
1282	83	missing_note	Пропущена нота D6	D6	—	38.41
1283	83	missing_note	Пропущена нота C#6	C#6	—	38.42
1284	83	missing_note	Пропущена нота A6	A6	—	38.42
1285	83	missing_note	Пропущена нота E4	E4	—	38.43
1286	83	missing_note	Пропущена нота D#5	D#5	—	38.44
1287	83	missing_note	Пропущена нота F5	F5	—	38.44
1288	83	missing_note	Пропущена нота D5	D5	—	38.47
1289	83	missing_note	Пропущена нота D#4	D#4	—	38.5
1290	83	missing_note	Пропущена нота G6	G6	—	38.51
1291	83	missing_note	Пропущена нота F5	F5	—	38.51
1292	83	missing_note	Пропущена нота D#7	D#7	—	38.51
1293	83	missing_note	Пропущена нота A5	A5	—	38.52
1294	83	missing_note	Пропущена нота F#5	F#5	—	38.53
1295	83	missing_note	Пропущена нота F#4	F#4	—	38.6
1296	83	missing_note	Пропущена нота D4	D4	—	38.6
1297	83	missing_note	Пропущена нота D5	D5	—	38.62
1298	83	missing_note	Пропущена нота D6	D6	—	38.62
1299	83	missing_note	Пропущена нота E4	E4	—	38.64
1300	83	missing_note	Пропущена нота A6	A6	—	38.64
1301	83	missing_note	Пропущена нота D5	D5	—	38.69
1302	83	missing_note	Пропущена нота F4	F4	—	38.7
1303	83	missing_note	Пропущена нота D#4	D#4	—	38.71
1304	83	missing_note	Пропущена нота F5	F5	—	38.71
1305	83	missing_note	Пропущена нота C7	C7	—	38.71
1306	83	missing_note	Пропущена нота E4	E4	—	38.74
1307	83	missing_note	Пропущена нота E4	E4	—	38.79
1308	83	missing_note	Пропущена нота F#4	F#4	—	38.81
1309	83	missing_note	Пропущена нота D5	D5	—	38.81
1310	83	missing_note	Пропущена нота F5	F5	—	38.81
1311	83	missing_note	Пропущена нота D6	D6	—	38.83
1312	83	missing_note	Пропущена нота E4	E4	—	38.85
1313	83	missing_note	Пропущена нота A6	A6	—	38.85
1314	83	missing_note	Пропущена нота E4	E4	—	38.9
1315	83	missing_note	Пропущена нота D5	D5	—	38.9
1316	83	missing_note	Пропущена нота C7	C7	—	38.92
1317	83	wrong_pitch	Отклонение ноты D4	D4	A5	38.93
1318	83	late	Задержка начала ноты	0 ms	788 ms	38.93
1319	83	articulation	Несоответствие длительности ноты	0.02s	0.33s	38.93
1320	83	missing_note	Пропущена нота E4	E4	—	38.95
1321	83	wrong_pitch	Отклонение ноты F4	F4	C#6	39.02
1322	83	late	Задержка начала ноты	0 ms	731 ms	39.02
1323	83	articulation	Несоответствие длительности ноты	0.03s	0.19s	39.02
1324	83	missing_note	Пропущена нота D#5	D#5	—	39.03
1325	83	missing_note	Пропущена нота D6	D6	—	39.05
1326	83	missing_note	Пропущена нота B4	B4	—	39.05
1327	83	missing_note	Пропущена нота A5	A5	—	39.05
1328	83	missing_note	Пропущена нота A6	A6	—	39.05
1329	83	missing_note	Пропущена нота C#6	C#6	—	39.06
1330	83	missing_note	Пропущена нота E4	E4	—	39.12
1331	83	missing_note	Пропущена нота A5	A5	—	39.13
1332	83	missing_note	Пропущена нота E7	E7	—	39.14
1333	83	missing_note	Пропущена нота D#4	D#4	—	39.23
1334	83	missing_note	Пропущена нота F#6	F#6	—	39.23
1335	83	missing_note	Пропущена нота F5	F5	—	39.24
1336	83	missing_note	Пропущена нота C#7	C#7	—	39.24
1337	83	wrong_pitch	Отклонение ноты E4	E4	A5	39.27
1338	83	late	Задержка начала ноты	0 ms	777 ms	39.27
1339	83	articulation	Несоответствие длительности ноты	0.02s	0.31s	39.27
1340	83	missing_note	Пропущена нота F#5	F#5	—	39.27
1341	83	wrong_pitch	Отклонение ноты C#7	C#7	E6	39.31
1342	83	late	Задержка начала ноты	0 ms	766 ms	39.31
1343	83	articulation	Несоответствие длительности ноты	0.05s	0.30s	39.31
1344	83	missing_note	Пропущена нота F5	F5	—	39.33
1345	83	missing_note	Пропущена нота F4	F4	—	39.34
1346	83	missing_note	Пропущена нота C7	C7	—	39.34
1347	83	missing_note	Пропущена нота E4	E4	—	39.37
1348	83	missing_note	Пропущена нота E4	E4	—	39.41
1349	83	missing_note	Пропущена нота D5	D5	—	39.44
1350	83	missing_note	Пропущена нота F4	F4	—	39.45
1351	83	missing_note	Пропущена нота D6	D6	—	39.45
1352	83	missing_note	Пропущена нота A6	A6	—	39.47
1353	83	missing_note	Пропущена нота E4	E4	—	39.48
1354	83	missing_note	Пропущена нота D5	D5	—	39.52
1355	83	missing_note	Пропущена нота F4	F4	—	39.53
1356	83	missing_note	Пропущена нота F6	F6	—	39.53
1357	83	missing_note	Пропущена нота F5	F5	—	39.55
1358	83	missing_note	Пропущена нота C7	C7	—	39.55
1359	83	wrong_pitch	Отклонение ноты E4	E4	A5	39.64
1360	83	late	Задержка начала ноты	0 ms	719 ms	39.64
1361	83	articulation	Несоответствие длительности ноты	0.02s	0.28s	39.64
1362	83	wrong_pitch	Отклонение ноты C#7	C#7	E6	39.65
1363	83	late	Задержка начала ноты	0 ms	730 ms	39.65
1364	83	articulation	Несоответствие длительности ноты	0.12s	0.17s	39.65
1365	83	missing_note	Пропущена нота F#6	F#6	—	39.65
1366	83	missing_note	Пропущена нота G6	G6	—	39.66
1367	83	missing_note	Пропущена нота F#5	F#5	—	39.66
1368	83	missing_note	Пропущена нота C7	C7	—	39.74
1369	83	missing_note	Пропущена нота F6	F6	—	39.74
1370	83	missing_note	Пропущена нота F5	F5	—	39.76
1371	83	missing_note	Пропущена нота E4	E4	—	39.78
1372	83	missing_note	Пропущена нота E4	E4	—	39.83
1373	83	missing_note	Пропущена нота F#4	F#4	—	39.84
1374	83	wrong_pitch	Отклонение ноты D5	D5	A5	39.85
1375	83	late	Задержка начала ноты	0 ms	788 ms	39.85
1376	83	articulation	Несоответствие длительности ноты	0.03s	0.19s	39.85
1377	83	missing_note	Пропущена нота D6	D6	—	39.85
1378	83	missing_note	Пропущена нота E4	E4	—	39.87
1379	83	missing_note	Пропущена нота A6	A6	—	39.87
1380	83	wrong_pitch	Отклонение ноты D5	D5	C#6	39.91
1381	83	late	Задержка начала ноты	0 ms	765 ms	39.91
1382	83	articulation	Несоответствие длительности ноты	0.07s	0.21s	39.91
1383	83	missing_note	Пропущена нота F4	F4	—	39.94
1384	83	missing_note	Пропущена нота C#5	C#5	—	39.97
1385	83	missing_note	Пропущена нота C#6	C#6	—	39.97
1386	83	missing_note	Пропущена нота B4	B4	—	39.98
1387	83	missing_note	Пропущена нота F7	F7	—	39.99
1388	83	missing_note	Пропущена нота G#6	G#6	—	40
1389	83	missing_note	Пропущена нота D5	D5	—	40.03
1390	83	missing_note	Пропущена нота E4	E4	—	40.05
1391	83	missing_note	Пропущена нота C5	C5	—	40.06
1392	83	missing_note	Пропущена нота F4	F4	—	40.07
1393	83	missing_note	Пропущена нота E7	E7	—	40.07
1394	83	missing_note	Пропущена нота G6	G6	—	40.08
1395	83	missing_note	Пропущена нота C6	C6	—	40.08
1396	83	missing_note	Пропущена нота E4	E4	—	40.09
1397	83	missing_note	Пропущена нота E4	E4	—	40.13
1398	83	missing_note	Пропущена нота F4	F4	—	40.15
1399	83	missing_note	Пропущена нота A5	A5	—	40.16
1400	83	missing_note	Пропущена нота E6	E6	—	40.16
1401	83	missing_note	Пропущена нота A4	A4	—	40.17
1402	83	missing_note	Пропущена нота C#7	C#7	—	40.19
1403	83	missing_note	Пропущена нота E4	E4	—	40.2
1404	83	missing_note	Пропущена нота G7	G7	—	40.22
1405	83	missing_note	Пропущена нота B4	B4	—	40.24
1406	83	missing_note	Пропущена нота F4	F4	—	40.26
1407	83	missing_note	Пропущена нота D4	D4	—	40.28
1408	83	missing_note	Пропущена нота C5	C5	—	40.28
1409	83	missing_note	Пропущена нота F4	F4	—	40.34
1410	83	missing_note	Пропущена нота A5	A5	—	40.36
1411	83	missing_note	Пропущена нота E6	E6	—	40.36
1412	83	missing_note	Пропущена нота C#7	C#7	—	40.38
1413	83	missing_note	Пропущена нота A4	A4	—	40.38
1414	83	missing_note	Пропущена нота E4	E4	—	40.41
1415	83	wrong_pitch	Отклонение ноты G7	G7	F5	40.43
1416	83	late	Задержка начала ноты	0 ms	787 ms	40.43
1417	83	articulation	Несоответствие длительности ноты	0.06s	0.17s	40.43
1418	83	missing_note	Пропущена нота E4	E4	—	40.44
1419	83	missing_note	Пропущена нота F4	F4	—	40.47
1420	83	missing_note	Пропущена нота C5	C5	—	40.48
1421	83	missing_note	Пропущена нота C6	C6	—	40.49
1422	83	missing_note	Пропущена нота E4	E4	—	40.51
1423	83	missing_note	Пропущена нота G6	G6	—	40.51
1424	83	missing_note	Пропущена нота D#5	D#5	—	40.56
1425	83	missing_note	Пропущена нота C6	C6	—	40.63
1426	83	wrong_pitch	Отклонение ноты F4	F4	D#5	40.94
1427	83	late	Задержка начала ноты	0 ms	577 ms	40.94
1428	83	articulation	Несоответствие длительности ноты	0.03s	0.30s	40.94
1429	83	wrong_pitch	Отклонение ноты D5	D5	F#6	40.94
1430	83	late	Задержка начала ноты	0 ms	612 ms	40.94
1431	83	articulation	Несоответствие длительности ноты	0.03s	0.15s	40.94
1432	83	wrong_pitch	Отклонение ноты C#6	C#6	F#5	40.94
1433	83	late	Задержка начала ноты	0 ms	612 ms	40.94
1434	83	articulation	Несоответствие длительности ноты	0.06s	0.30s	40.94
1435	83	missing_note	Пропущена нота D#6	D#6	—	40.94
1436	83	missing_note	Пропущена нота F#7	F#7	—	40.95
1437	83	missing_note	Пропущена нота D7	D7	—	40.95
1438	83	missing_note	Пропущена нота B4	B4	—	40.97
1439	83	missing_note	Пропущена нота E4	E4	—	40.98
1440	83	missing_note	Пропущена нота A6	A6	—	40.99
1441	83	missing_note	Пропущена нота D#5	D#5	—	41
1442	83	wrong_pitch	Отклонение ноты D5	D5	D#5	41.02
1443	83	late	Задержка начала ноты	0 ms	799 ms	41.02
1444	83	articulation	Несоответствие длительности ноты	1.00s	0.15s	41.02
1445	83	wrong_pitch	Отклонение ноты E4	E4	G#5	42.49
1446	83	articulation	Несоответствие длительности ноты	0.09s	0.19s	42.49
1447	83	wrong_pitch	Отклонение ноты D5	D5	F5	42.5
1448	83	articulation	Несоответствие длительности ноты	0.07s	0.15s	42.5
1449	83	wrong_pitch	Отклонение ноты A4	A4	G5	42.5
1450	83	late	Задержка начала ноты	0 ms	193 ms	42.5
1451	83	articulation	Несоответствие длительности ноты	0.29s	0.17s	42.5
1452	83	wrong_pitch	Отклонение ноты A6	A6	F#5	42.51
1453	83	early	Преждевременное начало ноты	0 ms	-352 ms	42.51
1454	83	articulation	Несоответствие длительности ноты	0.03s	0.21s	42.51
1455	83	wrong_pitch	Отклонение ноты D7	D7	D#5	42.51
1456	83	early	Преждевременное начало ноты	0 ms	-386 ms	42.51
1457	83	articulation	Несоответствие длительности ноты	0.10s	0.16s	42.51
1458	83	wrong_pitch	Отклонение ноты F#5	F#5	G#5	42.53
1459	83	late	Задержка начала ноты	0 ms	460 ms	42.53
1460	83	articulation	Несоответствие длительности ноты	0.05s	0.15s	42.53
1461	83	wrong_pitch	Отклонение ноты F4	F4	D#5	43.22
1462	83	articulation	Несоответствие длительности ноты	0.02s	0.15s	43.22
1463	83	wrong_pitch	Отклонение ноты C#5	C#5	D5	43.22
1464	83	late	Задержка начала ноты	0 ms	343 ms	43.22
1465	83	articulation	Несоответствие длительности ноты	0.13s	0.27s	43.22
1466	83	wrong_pitch	Отклонение ноты A4	A4	B4	43.22
1467	83	late	Задержка начала ноты	0 ms	623 ms	43.22
1468	83	articulation	Несоответствие длительности ноты	0.72s	0.17s	43.22
1469	83	late	Задержка начала ноты	0 ms	611 ms	43.23
1470	83	articulation	Несоответствие длительности ноты	0.15s	0.26s	43.23
1471	83	missing_note	Пропущена нота E4	E4	—	43.24
1472	83	missing_note	Пропущена нота F4	F4	—	43.48
1473	83	missing_note	Пропущена нота E6	E6	—	43.48
1474	83	missing_note	Пропущена нота D5	D5	—	43.48
1475	83	missing_note	Пропущена нота F#6	F#6	—	43.49
1476	83	missing_note	Пропущена нота D7	D7	—	43.5
1477	83	missing_note	Пропущена нота E4	E4	—	43.51
1478	83	missing_note	Пропущена нота F#5	F#5	—	43.52
1479	83	wrong_pitch	Отклонение ноты A5	A5	D5	44.13
1480	83	late	Задержка начала ноты	0 ms	436 ms	44.13
1481	83	articulation	Несоответствие длительности ноты	0.10s	0.21s	44.13
1482	83	wrong_pitch	Отклонение ноты E4	E4	D5	44.14
1483	83	late	Задержка начала ноты	0 ms	633 ms	44.14
1484	83	articulation	Несоответствие длительности ноты	0.07s	0.21s	44.14
1485	83	missing_note	Пропущена нота C#5	C#5	—	44.14
1486	83	missing_note	Пропущена нота A4	A4	—	44.14
1487	83	wrong_pitch	Отклонение ноты G#5	G#5	B4	44.27
1488	83	late	Задержка начала ноты	0 ms	726 ms	44.27
1489	83	articulation	Несоответствие длительности ноты	0.03s	0.24s	44.27
1490	83	missing_note	Пропущена нота F#4	F#4	—	44.4
1491	83	missing_note	Пропущена нота A5	A5	—	44.4
1492	83	missing_note	Пропущена нота E5	E5	—	44.4
1493	83	missing_note	Пропущена нота D#4	D#4	—	44.41
1494	83	missing_note	Пропущена нота A4	A4	—	44.41
1495	83	missing_note	Пропущена нота G5	G5	—	44.42
1496	83	missing_note	Пропущена нота E4	E4	—	44.44
1497	83	wrong_pitch	Отклонение ноты F4	F4	D#5	45.26
1498	83	late	Задержка начала ноты	0 ms	505 ms	45.26
1499	83	articulation	Несоответствие длительности ноты	0.03s	0.31s	45.26
1500	83	missing_note	Пропущена нота A5	A5	—	45.26
1501	83	missing_note	Пропущена нота E6	E6	—	45.27
1502	83	missing_note	Пропущена нота D5	D5	—	45.27
1503	83	missing_note	Пропущена нота A4	A4	—	45.27
1504	83	wrong_pitch	Отклонение ноты E4	E4	D#5	45.29
1505	83	late	Задержка начала ноты	0 ms	784 ms	45.29
1506	83	articulation	Несоответствие длительности ноты	0.06s	0.26s	45.29
1507	83	missing_note	Пропущена нота F#6	F#6	—	45.29
1508	83	missing_note	Пропущена нота F#5	F#5	—	45.31
1509	83	missing_note	Пропущена нота F#4	F#4	—	45.49
1510	83	missing_note	Пропущена нота D5	D5	—	45.49
1511	83	missing_note	Пропущена нота D4	D4	—	45.5
1512	83	missing_note	Пропущена нота E6	E6	—	45.5
1513	83	missing_note	Пропущена нота A6	A6	—	45.5
1514	83	missing_note	Пропущена нота A5	A5	—	45.51
1515	83	wrong_pitch	Отклонение ноты A4	A4	D#5	45.53
1516	83	late	Задержка начала ноты	0 ms	795 ms	45.53
1517	83	articulation	Несоответствие длительности ноты	0.09s	0.17s	45.53
1518	83	missing_note	Пропущена нота F#5	F#5	—	45.55
1519	83	missing_note	Пропущена нота A5	A5	—	45.71
1520	83	missing_note	Пропущена нота E6	E6	—	45.71
1521	83	missing_note	Пропущена нота C#5	C#5	—	45.72
1522	83	missing_note	Пропущена нота A4	A4	—	45.72
1523	83	missing_note	Пропущена нота E5	E5	—	45.73
1524	83	missing_note	Пропущена нота C#6	C#6	—	45.74
1525	83	missing_note	Пропущена нота E4	E4	—	45.74
1526	83	missing_note	Пропущена нота G#5	G#5	—	45.8
1527	83	wrong_pitch	Отклонение ноты F#4	F#4	D5	45.94
1528	83	late	Задержка начала ноты	0 ms	690 ms	45.94
1529	83	articulation	Несоответствие длительности ноты	0.02s	0.22s	45.94
1530	83	missing_note	Пропущена нота A5	A5	—	45.95
1531	83	missing_note	Пропущена нота E5	E5	—	45.95
1532	83	missing_note	Пропущена нота E4	E4	—	45.97
1533	83	missing_note	Пропущена нота A4	A4	—	45.97
1534	83	missing_note	Пропущена нота G5	G5	—	45.98
1535	83	missing_note	Пропущена нота G#5	G#5	—	45.99
1536	83	wrong_pitch	Отклонение ноты F#4	F#4	D5	46.4
1537	83	late	Задержка начала ноты	0 ms	457 ms	46.4
1538	83	articulation	Несоответствие длительности ноты	0.02s	0.21s	46.4
1539	83	wrong_pitch	Отклонение ноты A5	A5	D5	46.4
1540	83	late	Задержка начала ноты	0 ms	666 ms	46.4
1541	83	articulation	Несоответствие длительности ноты	0.05s	0.17s	46.4
1542	83	missing_note	Пропущена нота C#4	C#4	—	46.41
1543	83	missing_note	Пропущена нота D5	D5	—	46.41
1544	83	missing_note	Пропущена нота E6	E6	—	46.41
1545	83	missing_note	Пропущена нота A4	A4	—	46.42
1546	83	missing_note	Пропущена нота E4	E4	—	46.43
1547	83	wrong_pitch	Отклонение ноты F#5	F#5	D5	46.44
1548	83	late	Задержка начала ноты	0 ms	793 ms	46.44
1549	83	missing_note	Пропущена нота D5	D5	—	46.49
1550	83	wrong_pitch	Отклонение ноты F4	F4	D5	46.81
1551	83	late	Задержка начала ноты	0 ms	723 ms	46.81
1552	83	articulation	Несоответствие длительности ноты	0.03s	0.20s	46.81
1553	83	missing_note	Пропущена нота D5	D5	—	46.84
1554	83	missing_note	Пропущена нота A4	A4	—	46.84
1555	83	missing_note	Пропущена нота E4	E4	—	46.85
1556	83	wrong_pitch	Отклонение ноты E4	E4	A4	47.26
1557	83	late	Задержка начала ноты	0 ms	550 ms	47.26
1558	83	articulation	Несоответствие длительности ноты	0.10s	0.34s	47.26
1559	83	missing_note	Пропущена нота A5	A5	—	47.26
1560	83	missing_note	Пропущена нота C#5	C#5	—	47.27
1561	83	missing_note	Пропущена нота C#6	C#6	—	47.27
1562	83	missing_note	Пропущена нота A4	A4	—	47.27
1563	83	missing_note	Пропущена нота D5	D5	—	47.71
1564	83	missing_note	Пропущена нота E4	E4	—	47.71
1565	83	missing_note	Пропущена нота A4	A4	—	47.71
1566	83	missing_note	Пропущена нота F#5	F#5	—	47.72
1567	83	missing_note	Пропущена нота C#7	C#7	—	47.72
1568	83	missing_note	Пропущена нота D7	D7	—	47.73
1569	83	missing_note	Пропущена нота D5	D5	—	47.79
1570	83	missing_note	Пропущена нота G4	G4	—	47.93
1571	83	missing_note	Пропущена нота E4	E4	—	47.94
1572	83	missing_note	Пропущена нота C5	C5	—	47.95
1573	83	missing_note	Пропущена нота E5	E5	—	47.97
1574	83	missing_note	Пропущена нота E4	E4	—	47.98
1575	83	wrong_pitch	Отклонение ноты G#5	G#5	A5	48.02
1576	83	late	Задержка начала ноты	0 ms	792 ms	48.02
1577	83	articulation	Несоответствие длительности ноты	0.03s	0.34s	48.02
1578	83	missing_note	Пропущена нота F#4	F#4	—	48.17
1579	83	missing_note	Пропущена нота A4	A4	—	48.19
1580	83	wrong_pitch	Отклонение ноты E4	E4	D5	48.28
1581	83	late	Задержка начала ноты	0 ms	722 ms	48.28
1582	83	articulation	Несоответствие длительности ноты	0.08s	0.15s	48.28
1583	83	missing_note	Пропущена нота A5	A5	—	48.37
1584	83	wrong_pitch	Отклонение ноты A4	A4	A#5	48.4
1585	83	late	Задержка начала ноты	0 ms	780 ms	48.4
1586	83	articulation	Несоответствие длительности ноты	0.07s	0.15s	48.4
1587	83	missing_note	Пропущена нота E4	E4	—	48.44
1588	83	missing_note	Пропущена нота A5	A5	—	48.56
1589	83	missing_note	Пропущена нота E4	E4	—	48.56
1590	83	missing_note	Пропущена нота A4	A4	—	48.57
1591	83	wrong_pitch	Отклонение ноты C6	C6	D5	48.66
1592	83	late	Задержка начала ноты	0 ms	710 ms	48.66
1593	83	articulation	Несоответствие длительности ноты	0.03s	0.14s	48.66
1594	83	missing_note	Пропущена нота F#4	F#4	—	48.73
1595	83	missing_note	Пропущена нота C5	C5	—	48.76
1596	83	missing_note	Пропущена нота C6	C6	—	48.79
1597	83	missing_note	Пропущена нота C5	C5	—	48.83
1598	83	missing_note	Пропущена нота E4	E4	—	48.92
1599	83	wrong_pitch	Отклонение ноты E4	E4	D#6	49.03
1600	83	late	Задержка начала ноты	0 ms	792 ms	49.03
1601	83	articulation	Несоответствие длительности ноты	0.05s	0.14s	49.03
1602	83	missing_note	Пропущена нота C5	C5	—	49.05
1603	83	missing_note	Пропущена нота E4	E4	—	49.17
1604	83	wrong_pitch	Отклонение ноты C6	C6	D5	49.19
1605	83	late	Задержка начала ноты	0 ms	792 ms	49.19
1606	83	articulation	Несоответствие длительности ноты	0.08s	0.19s	49.19
1607	83	missing_note	Пропущена нота C5	C5	—	49.22
1608	83	missing_note	Пропущена нота A4	A4	—	49.24
1609	83	wrong_pitch	Отклонение ноты E5	E5	G5	49.5
1610	83	late	Задержка начала ноты	0 ms	675 ms	49.5
1611	83	articulation	Несоответствие длительности ноты	0.59s	0.16s	49.5
1612	83	missing_note	Пропущена нота F4	F4	—	49.51
1613	83	missing_note	Пропущена нота A5	A5	—	49.6
1614	83	missing_note	Пропущена нота A4	A4	—	49.63
1615	83	missing_note	Пропущена нота E4	E4	—	49.69
1616	83	wrong_pitch	Отклонение ноты B5	B5	F#5	49.73
1617	83	late	Задержка начала ноты	0 ms	768 ms	49.73
1618	83	articulation	Несоответствие длительности ноты	0.03s	0.31s	49.73
1619	83	missing_note	Пропущена нота G#5	G#5	—	49.81
1620	83	missing_note	Пропущена нота F4	F4	—	49.83
1621	83	missing_note	Пропущена нота E7	E7	—	49.84
1622	83	wrong_pitch	Отклонение ноты E7	E7	D5	49.95
1623	83	late	Задержка начала ноты	0 ms	686 ms	49.95
1624	83	articulation	Несоответствие длительности ноты	0.07s	0.14s	49.95
1625	83	wrong_pitch	Отклонение ноты A4	A4	F#5	50.06
1626	83	late	Задержка начала ноты	0 ms	755 ms	50.06
1627	83	articulation	Несоответствие длительности ноты	0.12s	0.30s	50.06
1628	83	missing_note	Пропущена нота E4	E4	—	50.07
1629	83	missing_note	Пропущена нота E4	E4	—	50.12
1630	83	missing_note	Пропущена нота B5	B5	—	50.14
1631	83	wrong_pitch	Отклонение ноты F4	F4	D5	50.15
1632	83	late	Задержка начала ноты	0 ms	790 ms	50.15
1633	83	articulation	Несоответствие длительности ноты	0.02s	0.15s	50.15
1634	83	missing_note	Пропущена нота E7	E7	—	50.17
1635	83	missing_note	Пропущена нота E4	E4	—	50.22
1636	83	missing_note	Пропущена нота E6	E6	—	50.23
1637	83	missing_note	Пропущена нота F4	F4	—	50.24
1638	83	missing_note	Пропущена нота A4	A4	—	50.24
1639	83	missing_note	Пропущена нота E4	E4	—	50.27
1640	83	missing_note	Пропущена нота E4	E4	—	50.31
1641	83	wrong_pitch	Отклонение ноты F#4	F#4	F#5	50.34
1642	83	late	Задержка начала ноты	0 ms	778 ms	50.34
1643	83	articulation	Несоответствие длительности ноты	0.02s	0.14s	50.34
1644	83	missing_note	Пропущена нота C#5	C#5	—	50.34
1645	83	missing_note	Пропущена нота C#6	C#6	—	50.35
1646	83	missing_note	Пропущена нота E4	E4	—	50.37
1647	83	missing_note	Пропущена нота G#6	G#6	—	50.37
1648	83	missing_note	Пропущена нота F7	F7	—	50.37
1649	83	missing_note	Пропущена нота F#4	F#4	—	50.44
1650	83	missing_note	Пропущена нота D#4	D#4	—	50.44
1651	83	missing_note	Пропущена нота E6	E6	—	50.44
1652	83	missing_note	Пропущена нота A5	A5	—	50.44
1653	83	missing_note	Пропущена нота A4	A4	—	50.45
1654	83	missing_note	Пропущена нота C#5	C#5	—	50.47
1655	83	missing_note	Пропущена нота E4	E4	—	50.48
1656	83	missing_note	Пропущена нота F#4	F#4	—	50.55
1657	83	missing_note	Пропущена нота D#4	D#4	—	50.55
1658	83	missing_note	Пропущена нота B5	B5	—	50.55
1659	83	missing_note	Пропущена нота C6	C6	—	50.55
1660	83	missing_note	Пропущена нота C5	C5	—	50.56
1661	83	missing_note	Пропущена нота E7	E7	—	50.56
1662	83	missing_note	Пропущена нота G6	G6	—	50.57
1663	83	missing_note	Пропущена нота E4	E4	—	50.58
1664	83	wrong_pitch	Отклонение ноты E4	E4	A5	50.63
1665	83	late	Задержка начала ноты	0 ms	778 ms	50.63
1666	83	articulation	Несоответствие длительности ноты	0.02s	0.20s	50.63
1667	83	missing_note	Пропущена нота A5	A5	—	50.64
1668	83	missing_note	Пропущена нота E6	E6	—	50.64
1669	83	missing_note	Пропущена нота F4	F4	—	50.65
1670	83	missing_note	Пропущена нота A4	A4	—	50.65
1671	83	missing_note	Пропущена нота E4	E4	—	50.67
1672	83	missing_note	Пропущена нота B4	B4	—	50.73
1673	83	missing_note	Пропущена нота F4	F4	—	50.73
1674	83	missing_note	Пропущена нота C6	C6	—	50.74
1675	83	missing_note	Пропущена нота C5	C5	—	50.76
1676	83	missing_note	Пропущена нота E7	E7	—	50.77
1677	83	wrong_pitch	Отклонение ноты G6	G6	D5	50.78
1678	83	late	Задержка начала ноты	0 ms	789 ms	50.78
1679	83	articulation	Несоответствие длительности ноты	0.03s	0.14s	50.78
1680	83	missing_note	Пропущена нота E4	E4	—	50.78
1681	83	missing_note	Пропущена нота A5	A5	—	50.84
1682	83	missing_note	Пропущена нота E6	E6	—	50.85
1683	83	missing_note	Пропущена нота A4	A4	—	50.86
1684	83	missing_note	Пропущена нота E4	E4	—	50.87
1685	83	missing_note	Пропущена нота F4	F4	—	50.94
1686	83	missing_note	Пропущена нота C6	C6	—	50.94
1687	83	missing_note	Пропущена нота C5	C5	—	50.95
1688	83	wrong_pitch	Отклонение ноты E7	E7	D6	50.97
1689	83	late	Задержка начала ноты	0 ms	790 ms	50.97
1690	83	articulation	Несоответствие длительности ноты	0.06s	0.14s	50.97
1691	83	missing_note	Пропущена нота E4	E4	—	50.98
1692	83	missing_note	Пропущена нота G6	G6	—	50.98
1693	83	missing_note	Пропущена нота F4	F4	—	51.03
1694	83	missing_note	Пропущена нота D#4	D#4	—	51.05
1695	83	missing_note	Пропущена нота A5	A5	—	51.05
1696	83	missing_note	Пропущена нота E6	E6	—	51.06
1697	83	missing_note	Пропущена нота A4	A4	—	51.06
1698	83	wrong_pitch	Отклонение ноты F4	F4	D5	51.13
1699	83	late	Задержка начала ноты	0 ms	767 ms	51.13
1700	83	articulation	Несоответствие длительности ноты	0.03s	0.14s	51.13
1701	83	wrong_pitch	Отклонение ноты E5	E5	D6	51.16
1702	83	late	Задержка начала ноты	0 ms	767 ms	51.16
1703	83	articulation	Несоответствие длительности ноты	0.44s	0.21s	51.16
1704	83	missing_note	Пропущена нота F4	F4	—	51.17
1705	83	missing_note	Пропущена нота D#6	D#6	—	51.17
1706	83	missing_note	Пропущена нота F4	F4	—	51.27
1707	83	missing_note	Пропущена нота A5	A5	—	51.27
1708	83	missing_note	Пропущена нота A4	A4	—	51.28
1709	83	missing_note	Пропущена нота E4	E4	—	51.3
1710	83	missing_note	Пропущена нота B5	B5	—	51.37
1711	83	missing_note	Пропущена нота F5	F5	—	51.38
1712	83	missing_note	Пропущена нота E7	E7	—	51.38
1713	83	missing_note	Пропущена нота E4	E4	—	51.4
1714	83	wrong_pitch	Отклонение ноты D#4	D#4	D6	51.49
1715	83	late	Задержка начала ноты	0 ms	743 ms	51.49
1716	83	articulation	Несоответствие длительности ноты	0.02s	0.15s	51.49
1717	83	missing_note	Пропущена нота A4	A4	—	51.5
1718	83	missing_note	Пропущена нота E4	E4	—	51.51
1719	83	missing_note	Пропущена нота F4	F4	—	51.58
1720	83	wrong_pitch	Отклонение ноты B5	B5	D6	51.59
1721	83	late	Задержка начала ноты	0 ms	789 ms	51.59
1722	83	articulation	Несоответствие длительности ноты	0.03s	0.14s	51.59
1723	83	missing_note	Пропущена нота E7	E7	—	51.6
1724	83	missing_note	Пропущена нота E4	E4	—	51.67
1725	83	missing_note	Пропущена нота E6	E6	—	51.69
1726	83	missing_note	Пропущена нота D#4	D#4	—	51.7
1727	83	missing_note	Пропущена нота F4	F4	—	51.7
1728	83	missing_note	Пропущена нота A4	A4	—	51.71
1729	83	missing_note	Пропущена нота E4	E4	—	51.72
1730	83	wrong_pitch	Отклонение ноты B5	B5	D5	51.79
1731	83	late	Задержка начала ноты	0 ms	743 ms	51.79
1732	83	articulation	Несоответствие длительности ноты	0.03s	0.15s	51.79
1733	83	missing_note	Пропущена нота F5	F5	—	51.8
1734	83	missing_note	Пропущена нота E7	E7	—	51.8
1735	83	missing_note	Пропущена нота D#4	D#4	—	51.88
1736	83	missing_note	Пропущена нота E6	E6	—	51.9
1737	83	missing_note	Пропущена нота A4	A4	—	51.9
1738	83	missing_note	Пропущена нота E4	E4	—	51.92
1739	83	wrong_pitch	Отклонение ноты F4	F4	F#5	51.99
1740	83	late	Задержка начала ноты	0 ms	742 ms	51.99
1741	83	articulation	Несоответствие длительности ноты	0.03s	0.15s	51.99
1742	83	missing_note	Пропущена нота C#5	C#5	—	52
1743	83	missing_note	Пропущена нота C#6	C#6	—	52
1744	83	missing_note	Пропущена нота G#6	G#6	—	52.02
1745	83	missing_note	Пропущена нота F7	F7	—	52.03
1746	83	missing_note	Пропущена нота F4	F4	—	52.07
1747	83	wrong_pitch	Отклонение ноты E6	E6	D5	52.09
1748	83	late	Задержка начала ноты	0 ms	777 ms	52.09
1749	83	articulation	Несоответствие длительности ноты	0.09s	0.14s	52.09
1750	83	missing_note	Пропущена нота A5	A5	—	52.09
1751	83	missing_note	Пропущена нота A4	A4	—	52.1
1752	83	missing_note	Пропущена нота E4	E4	—	52.13
1753	83	missing_note	Пропущена нота C5	C5	—	52.2
1754	83	missing_note	Пропущена нота B5	B5	—	52.21
1755	83	missing_note	Пропущена нота F4	F4	—	52.21
1756	83	missing_note	Пропущена нота E7	E7	—	52.21
1757	83	missing_note	Пропущена нота C6	C6	—	52.21
1758	83	missing_note	Пропущена нота G6	G6	—	52.22
1759	83	missing_note	Пропущена нота E4	E4	—	52.23
1760	83	wrong_pitch	Отклонение ноты F4	F4	F5	52.29
1761	83	late	Задержка начала ноты	0 ms	742 ms	52.29
1762	83	articulation	Несоответствие длительности ноты	0.03s	0.31s	52.29
1763	83	missing_note	Пропущена нота E6	E6	—	52.29
1764	83	missing_note	Пропущена нота A5	A5	—	52.29
1765	83	missing_note	Пропущена нота G7	G7	—	52.31
1766	83	missing_note	Пропущена нота A4	A4	—	52.31
1767	83	missing_note	Пропущена нота E4	E4	—	52.33
1768	83	missing_note	Пропущена нота C#6	C#6	—	52.33
1769	83	wrong_pitch	Отклонение ноты F#4	F#4	D5	52.4
1770	83	late	Задержка начала ноты	0 ms	776 ms	52.4
1771	83	articulation	Несоответствие длительности ноты	0.02s	0.14s	52.4
1772	83	missing_note	Пропущена нота C6	C6	—	52.4
1773	83	missing_note	Пропущена нота C5	C5	—	52.41
1774	83	missing_note	Пропущена нота E4	E4	—	52.43
1775	83	missing_note	Пропущена нота G6	G6	—	52.43
1776	83	missing_note	Пропущена нота E6	E6	—	52.5
1777	83	missing_note	Пропущена нота A5	A5	—	52.5
1778	83	missing_note	Пропущена нота A4	A4	—	52.51
1779	83	wrong_pitch	Отклонение ноты B4	B4	F5	52.57
1780	83	late	Задержка начала ноты	0 ms	776 ms	52.57
1781	83	articulation	Несоответствие длительности ноты	0.03s	0.28s	52.57
1782	83	missing_note	Пропущена нота E4	E4	—	52.58
1783	83	missing_note	Пропущена нота C6	C6	—	52.59
1784	83	missing_note	Пропущена нота F4	F4	—	52.6
1785	83	missing_note	Пропущена нота E7	E7	—	52.6
1786	83	missing_note	Пропущена нота C5	C5	—	52.6
1787	83	missing_note	Пропущена нота G6	G6	—	52.63
1788	83	missing_note	Пропущена нота E4	E4	—	52.63
1789	83	missing_note	Пропущена нота F4	F4	—	52.7
1790	83	missing_note	Пропущена нота A5	A5	—	52.7
1791	83	missing_note	Пропущена нота E6	E6	—	52.71
1792	83	missing_note	Пропущена нота A4	A4	—	52.71
1793	83	missing_note	Пропущена нота F4	F4	—	52.8
1794	83	missing_note	Пропущена нота E5	E5	—	52.8
1795	83	wrong_pitch	Отклонение ноты E4	E4	F5	52.84
1796	83	late	Задержка начала ноты	0 ms	787 ms	52.84
1797	83	articulation	Несоответствие длительности ноты	0.05s	0.15s	52.84
1798	83	missing_note	Пропущена нота A5	A5	—	52.91
1799	83	missing_note	Пропущена нота F#4	F#4	—	52.92
1800	83	missing_note	Пропущена нота B4	B4	—	52.93
1801	83	missing_note	Пропущена нота F4	F4	—	53.01
1802	83	missing_note	Пропущена нота B5	B5	—	53.02
1803	83	missing_note	Пропущена нота E7	E7	—	53.06
1804	83	missing_note	Пропущена нота E4	E4	—	53.1
1805	83	wrong_pitch	Отклонение ноты A4	A4	A5	53.14
1806	83	late	Задержка начала ноты	0 ms	788 ms	53.14
1807	83	articulation	Несоответствие длительности ноты	0.07s	0.31s	53.14
1808	83	missing_note	Пропущена нота E4	E4	—	53.15
1809	83	missing_note	Пропущена нота G#5	G#5	—	53.17
1810	83	missing_note	Пропущена нота D#4	D#4	—	53.22
1811	83	missing_note	Пропущена нота G5	G5	—	53.22
1812	83	missing_note	Пропущена нота F5	F5	—	53.23
1813	83	missing_note	Пропущена нота D7	D7	—	53.24
1814	83	missing_note	Пропущена нота E4	E4	—	53.31
1815	83	missing_note	Пропущена нота E6	E6	—	53.33
1816	83	missing_note	Пропущена нота A5	A5	—	53.33
1817	83	missing_note	Пропущена нота F4	F4	—	53.34
1818	83	missing_note	Пропущена нота A4	A4	—	53.34
1819	83	missing_note	Пропущена нота E4	E4	—	53.36
1820	83	missing_note	Пропущена нота F4	F4	—	53.43
1821	83	missing_note	Пропущена нота E5	E5	—	53.43
1822	83	wrong_pitch	Отклонение ноты A5	A5	C#6	53.52
1823	83	late	Задержка начала ноты	0 ms	741 ms	53.52
1824	83	missing_note	Пропущена нота A4	A4	—	53.55
1825	83	missing_note	Пропущена нота E4	E4	—	53.56
1826	83	wrong_pitch	Отклонение ноты F#4	F#4	D5	53.63
1827	83	late	Задержка начала ноты	0 ms	776 ms	53.63
1828	83	articulation	Несоответствие длительности ноты	0.02s	0.14s	53.63
1829	83	missing_note	Пропущена нота E4	E4	—	53.66
1830	83	missing_note	Пропущена нота F4	F4	—	53.72
1831	83	missing_note	Пропущена нота A5	A5	—	53.73
1832	83	missing_note	Пропущена нота D#4	D#4	—	53.74
1833	83	missing_note	Пропущена нота G7	G7	—	53.74
1834	83	missing_note	Пропущена нота A4	A4	—	53.74
1835	83	missing_note	Пропущена нота E4	E4	—	53.77
1836	83	wrong_pitch	Отклонение ноты G7	G7	C6	53.84
1837	83	late	Задержка начала ноты	0 ms	741 ms	53.84
1838	83	articulation	Несоответствие длительности ноты	0.07s	0.17s	53.84
1839	83	missing_note	Пропущена нота D#5	D#5	—	53.84
1840	83	missing_note	Пропущена нота A4	A4	—	53.85
1841	83	missing_note	Пропущена нота E4	E4	—	53.86
1842	83	missing_note	Пропущена нота A#6	A#6	—	53.86
1843	83	wrong_pitch	Отклонение ноты E6	E6	D5	53.93
1844	83	late	Задержка начала ноты	0 ms	787 ms	53.93
1845	83	articulation	Несоответствие длительности ноты	0.10s	0.15s	53.93
1846	83	missing_note	Пропущена нота A5	A5	—	53.93
1847	83	missing_note	Пропущена нота G7	G7	—	53.94
1848	83	missing_note	Пропущена нота A4	A4	—	53.95
1849	83	missing_note	Пропущена нота E4	E4	—	53.97
1850	83	missing_note	Пропущена нота F4	F4	—	54.02
1851	83	missing_note	Пропущена нота D#4	D#4	—	54.03
1852	83	missing_note	Пропущена нота D#5	D#5	—	54.03
1853	83	missing_note	Пропущена нота G7	G7	—	54.05
1854	83	missing_note	Пропущена нота E6	E6	—	54.06
1855	83	missing_note	Пропущена нота A#6	A#6	—	54.07
1856	83	wrong_pitch	Отклонение ноты F4	F4	A5	54.12
1857	83	late	Задержка начала ноты	0 ms	787 ms	54.12
1858	83	articulation	Несоответствие длительности ноты	0.02s	0.33s	54.12
1859	83	missing_note	Пропущена нота D#4	D#4	—	54.13
1860	83	missing_note	Пропущена нота E6	E6	—	54.13
1861	83	missing_note	Пропущена нота A5	A5	—	54.14
1862	83	missing_note	Пропущена нота A4	A4	—	54.15
1863	83	missing_note	Пропущена нота F4	F4	—	54.22
1864	83	missing_note	Пропущена нота B5	B5	—	54.23
1865	83	missing_note	Пропущена нота C5	C5	—	54.24
1866	83	missing_note	Пропущена нота E7	E7	—	54.24
1867	83	missing_note	Пропущена нота C6	C6	—	54.24
1868	83	missing_note	Пропущена нота G6	G6	—	54.26
1869	83	missing_note	Пропущена нота E4	E4	—	54.27
1870	83	missing_note	Пропущена нота F4	F4	—	54.33
1871	83	missing_note	Пропущена нота E6	E6	—	54.33
1872	83	missing_note	Пропущена нота A5	A5	—	54.33
1873	83	missing_note	Пропущена нота A4	A4	—	54.34
1874	83	missing_note	Пропущена нота E4	E4	—	54.36
1875	83	wrong_pitch	Отклонение ноты D4	D4	A5	54.44
1876	83	late	Задержка начала ноты	0 ms	786 ms	54.44
1877	83	articulation	Несоответствие длительности ноты	0.02s	0.16s	54.44
1878	83	missing_note	Пропущена нота F4	F4	—	54.44
1879	83	missing_note	Пропущена нота C5	C5	—	54.44
1880	83	missing_note	Пропущена нота E7	E7	—	54.44
1881	83	missing_note	Пропущена нота E4	E4	—	54.47
1882	83	missing_note	Пропущена нота F4	F4	—	54.53
1883	83	missing_note	Пропущена нота A5	A5	—	54.53
1884	83	missing_note	Пропущена нота E6	E6	—	54.53
1885	83	missing_note	Пропущена нота A4	A4	—	54.55
1886	83	wrong_pitch	Отклонение ноты E5	E5	D5	54.63
1887	83	late	Задержка начала ноты	0 ms	751 ms	54.63
1888	83	missing_note	Пропущена нота D#4	D#4	—	54.64
1889	83	missing_note	Пропущена нота F#4	F#4	—	54.64
1890	83	missing_note	Пропущена нота C#5	C#5	—	54.74
1891	83	wrong_pitch	Отклонение ноты F#4	F#4	F#5	54.84
1892	83	late	Задержка начала ноты	0 ms	716 ms	54.84
1893	83	articulation	Несоответствие длительности ноты	0.02s	0.30s	54.84
1894	83	missing_note	Пропущена нота C6	C6	—	54.85
1895	83	missing_note	Пропущена нота E7	E7	—	54.86
1896	83	missing_note	Пропущена нота C5	C5	—	54.86
1897	83	missing_note	Пропущена нота E4	E4	—	54.87
1898	83	missing_note	Пропущена нота G6	G6	—	54.88
1899	83	missing_note	Пропущена нота F4	F4	—	54.93
1900	83	missing_note	Пропущена нота D#4	D#4	—	54.94
1901	83	missing_note	Пропущена нота E6	E6	—	54.94
1902	83	missing_note	Пропущена нота A5	A5	—	54.94
1903	83	missing_note	Пропущена нота C#7	C#7	—	54.97
1904	83	missing_note	Пропущена нота A4	A4	—	54.97
1905	83	missing_note	Пропущена нота E4	E4	—	55.02
1906	83	missing_note	Пропущена нота C6	C6	—	55.05
1907	83	wrong_pitch	Отклонение ноты C5	C5	F#5	55.06
1908	83	late	Задержка начала ноты	0 ms	798 ms	55.06
1909	83	articulation	Несоответствие длительности ноты	0.09s	0.17s	55.06
1910	83	missing_note	Пропущена нота G6	G6	—	55.09
1911	83	missing_note	Пропущена нота E4	E4	—	55.09
1912	83	missing_note	Пропущена нота C#5	C#5	—	55.14
1913	83	missing_note	Пропущена нота F4	F4	—	55.15
1914	83	missing_note	Пропущена нота F7	F7	—	55.16
1915	83	missing_note	Пропущена нота E4	E4	—	55.17
1916	83	missing_note	Пропущена нота G#6	G#6	—	55.17
1917	83	wrong_pitch	Отклонение ноты C6	C6	D5	55.19
1918	83	late	Задержка начала ноты	0 ms	798 ms	55.19
1919	83	articulation	Несоответствие длительности ноты	0.02s	0.14s	55.19
1920	83	missing_note	Пропущена нота F4	F4	—	55.24
1921	83	missing_note	Пропущена нота C5	C5	—	55.24
1922	83	missing_note	Пропущена нота G6	G6	—	55.26
1923	83	missing_note	Пропущена нота C6	C6	—	55.26
1924	83	missing_note	Пропущена нота E7	E7	—	55.26
1925	83	missing_note	Пропущена нота E4	E4	—	55.28
1926	83	missing_note	Пропущена нота E4	E4	—	55.33
1927	83	missing_note	Пропущена нота F#4	F#4	—	55.35
1928	83	missing_note	Пропущена нота E6	E6	—	55.35
1929	83	missing_note	Пропущена нота A5	A5	—	55.35
1930	83	missing_note	Пропущена нота A4	A4	—	55.36
1931	83	missing_note	Пропущена нота C#7	C#7	—	55.36
1932	83	wrong_pitch	Отклонение ноты E4	E4	F5	55.38
1933	83	late	Задержка начала ноты	0 ms	786 ms	55.38
1934	83	articulation	Несоответствие длительности ноты	0.02s	0.29s	55.38
1935	83	missing_note	Пропущена нота E4	E4	—	55.42
1936	83	missing_note	Пропущена нота C7	C7	—	55.47
1937	83	missing_note	Пропущена нота D#6	D#6	—	55.47
1938	83	missing_note	Пропущена нота G#5	G#5	—	55.47
1939	83	missing_note	Пропущена нота E4	E4	—	55.49
1940	83	missing_note	Пропущена нота G#4	G#4	—	55.49
1941	83	missing_note	Пропущена нота F#4	F#4	—	55.56
1942	83	missing_note	Пропущена нота D6	D6	—	55.57
1943	83	missing_note	Пропущена нота G4	G4	—	55.58
1944	83	missing_note	Пропущена нота E4	E4	—	55.6
1945	83	missing_note	Пропущена нота B6	B6	—	55.6
1946	83	wrong_pitch	Отклонение ноты E5	E5	F5	55.66
1947	83	late	Задержка начала ноты	0 ms	797 ms	55.66
1948	83	missing_note	Пропущена нота B5	B5	—	55.66
1949	83	missing_note	Пропущена нота E4	E4	—	55.67
1950	83	missing_note	Пропущена нота D7	D7	—	55.7
1951	83	missing_note	Пропущена нота F4	F4	—	55.76
1952	83	missing_note	Пропущена нота D6	D6	—	55.77
1953	83	missing_note	Пропущена нота G4	G4	—	55.78
1954	83	missing_note	Пропущена нота E4	E4	—	55.79
1955	83	wrong_pitch	Отклонение ноты B5	B5	D5	55.86
1956	83	late	Задержка начала ноты	0 ms	785 ms	55.86
1957	83	missing_note	Пропущена нота E4	E4	—	55.87
1958	83	missing_note	Пропущена нота D7	D7	—	55.9
1959	83	missing_note	Пропущена нота D6	D6	—	55.97
1960	83	missing_note	Пропущена нота G5	G5	—	55.97
1961	83	missing_note	Пропущена нота G4	G4	—	55.98
1962	83	missing_note	Пропущена нота E4	E4	—	56
1963	83	missing_note	Пропущена нота F4	F4	—	56.07
1964	83	missing_note	Пропущена нота B5	B5	—	56.08
1965	83	missing_note	Пропущена нота C#7	C#7	—	56.08
1966	83	missing_note	Пропущена нота A5	A5	—	56.08
1967	83	missing_note	Пропущена нота A4	A4	—	56.09
1968	83	missing_note	Пропущена нота E4	E4	—	56.1
1969	83	wrong_pitch	Отклонение ноты E5	E5	G#5	57.16
1970	83	articulation	Несоответствие длительности ноты	0.50s	0.21s	57.16
1971	83	wrong_pitch	Отклонение ноты G5	G5	F5	57.17
1972	83	late	Задержка начала ноты	0 ms	377 ms	57.17
1973	83	articulation	Несоответствие длительности ноты	0.06s	0.16s	57.17
1974	83	wrong_pitch	Отклонение ноты E4	E4	D5	57.17
1975	83	late	Задержка начала ноты	0 ms	529 ms	57.17
1976	83	articulation	Несоответствие длительности ноты	0.09s	0.21s	57.17
1977	83	wrong_pitch	Отклонение ноты A5	A5	C5	57.17
1978	83	late	Задержка начала ноты	0 ms	726 ms	57.17
1979	83	articulation	Несоответствие длительности ноты	0.47s	0.16s	57.17
1980	83	missing_note	Пропущена нота E7	E7	—	57.19
1981	83	missing_note	Пропущена нота C#6	C#6	—	57.19
1982	83	wrong_pitch	Отклонение ноты D#4	D#4	C#5	57.87
1983	83	late	Задержка начала ноты	0 ms	191 ms	57.87
1984	83	articulation	Несоответствие длительности ноты	0.02s	0.14s	57.87
1985	83	wrong_pitch	Отклонение ноты E5	E5	C5	57.87
1986	83	late	Задержка начала ноты	0 ms	354 ms	57.87
1987	83	wrong_pitch	Отклонение ноты G5	G5	A4	57.87
1988	83	late	Задержка начала ноты	0 ms	516 ms	57.87
1989	83	wrong_pitch	Отклонение ноты A5	A5	A#4	57.88
1990	83	late	Задержка начала ноты	0 ms	679 ms	57.88
1991	83	articulation	Несоответствие длительности ноты	0.06s	0.16s	57.88
1992	83	missing_note	Пропущена нота B5	B5	—	57.88
1993	83	missing_note	Пропущена нота D4	D4	—	57.9
1994	83	wrong_pitch	Отклонение ноты D7	D7	G#4	57.91
1995	83	late	Задержка начала ноты	0 ms	795 ms	57.91
1996	83	articulation	Несоответствие длительности ноты	0.03s	0.14s	57.91
1997	83	missing_note	Пропущена нота E4	E4	—	57.92
1998	83	wrong_pitch	Отклонение ноты E5	E5	G4	58.15
1999	83	late	Задержка начала ноты	0 ms	760 ms	58.15
2000	83	articulation	Несоответствие длительности ноты	0.40s	0.21s	58.15
2001	83	missing_note	Пропущена нота F4	F4	—	58.16
2002	83	missing_note	Пропущена нота B6	B6	—	58.16
2003	83	missing_note	Пропущена нота E7	E7	—	58.16
2004	83	missing_note	Пропущена нота A5	A5	—	58.16
2005	83	missing_note	Пропущена нота B4	B4	—	58.17
2006	83	missing_note	Пропущена нота B5	B5	—	58.17
2007	83	missing_note	Пропущена нота C#6	C#6	—	58.17
2008	83	missing_note	Пропущена нота G5	G5	—	58.19
2009	83	missing_note	Пропущена нота E4	E4	—	58.2
2010	83	wrong_pitch	Отклонение ноты D#5	D#5	A4	58.81
2011	83	late	Задержка начала ноты	0 ms	480 ms	58.81
2012	83	articulation	Несоответствие длительности ноты	0.05s	0.19s	58.81
2013	83	wrong_pitch	Отклонение ноты G5	G5	C5	58.81
2014	83	late	Задержка начала ноты	0 ms	654 ms	58.81
2015	83	missing_note	Пропущена нота G4	G4	—	58.83
2016	83	missing_note	Пропущена нота B4	B4	—	58.83
2017	83	missing_note	Пропущена нота F5	F5	—	58.83
2018	83	missing_note	Пропущена нота A5	A5	—	58.83
2019	83	missing_note	Пропущена нота E4	E4	—	58.83
2020	83	missing_note	Пропущена нота B5	B5	—	58.83
2021	83	missing_note	Пропущена нота C4	C4	—	58.84
2022	83	missing_note	Пропущена нота D7	D7	—	58.84
2023	83	wrong_pitch	Отклонение ноты E5	E5	A4	58.86
2024	83	late	Задержка начала ноты	0 ms	795 ms	58.86
2025	83	articulation	Несоответствие длительности ноты	0.03s	0.21s	58.86
2026	83	wrong_pitch	Отклонение ноты E5	E5	C5	59.06
2027	83	late	Задержка начала ноты	0 ms	748 ms	59.06
2028	83	articulation	Несоответствие длительности ноты	0.33s	0.20s	59.06
2029	83	missing_note	Пропущена нота E4	E4	—	59.07
2030	83	missing_note	Пропущена нота B5	B5	—	59.07
2031	83	missing_note	Пропущена нота B4	B4	—	59.08
2032	83	missing_note	Пропущена нота F#7	F#7	—	59.08
2033	83	missing_note	Пропущена нота D6	D6	—	59.08
2034	83	missing_note	Пропущена нота C#6	C#6	—	59.09
2035	83	missing_note	Пропущена нота G#5	G#5	—	59.12
2036	83	missing_note	Пропущена нота E4	E4	—	59.12
2037	83	missing_note	Пропущена нота C6	C6	—	59.13
2038	83	wrong_pitch	Отклонение ноты F4	F4	D5	59.88
2039	83	late	Задержка начала ноты	0 ms	166 ms	59.88
2040	83	articulation	Несоответствие длительности ноты	0.03s	0.50s	59.88
2041	83	wrong_pitch	Отклонение ноты E5	E5	D5	59.88
2042	83	late	Задержка начала ноты	0 ms	665 ms	59.88
2043	83	articulation	Несоответствие длительности ноты	0.59s	0.22s	59.88
2044	83	missing_note	Пропущена нота A5	A5	—	59.9
2045	83	missing_note	Пропущена нота C4	C4	—	59.91
2046	83	missing_note	Пропущена нота B5	B5	—	59.91
2047	83	missing_note	Пропущена нота C#6	C#6	—	59.91
2048	83	missing_note	Пропущена нота E4	E4	—	59.92
2049	83	missing_note	Пропущена нота F5	F5	—	59.93
2050	83	missing_note	Пропущена нота B5	B5	—	60.12
2051	83	missing_note	Пропущена нота E7	E7	—	60.12
2052	83	missing_note	Пропущена нота D4	D4	—	60.13
2053	83	missing_note	Пропущена нота G5	G5	—	60.14
2054	83	missing_note	Пропущена нота C#6	C#6	—	60.27
2055	83	missing_note	Пропущена нота F#4	F#4	—	60.33
2056	83	missing_note	Пропущена нота G5	G5	—	60.34
2057	83	missing_note	Пропущена нота C4	C4	—	60.35
2058	83	missing_note	Пропущена нота B4	B4	—	60.35
2059	83	missing_note	Пропущена нота B5	B5	—	60.35
2060	83	missing_note	Пропущена нота D7	D7	—	60.37
2061	83	wrong_pitch	Отклонение ноты F#4	F#4	A#4	60.56
2062	83	late	Задержка начала ноты	0 ms	699 ms	60.56
2063	83	articulation	Несоответствие длительности ноты	0.05s	0.64s	60.56
2064	83	wrong_pitch	Отклонение ноты F#7	F#7	D#5	60.57
2065	83	late	Задержка начала ноты	0 ms	699 ms	60.57
2066	83	articulation	Несоответствие длительности ноты	0.10s	0.50s	60.57
2067	83	wrong_pitch	Отклонение ноты B5	B5	G5	60.57
2068	83	late	Задержка начала ноты	0 ms	711 ms	60.57
2069	83	articulation	Несоответствие длительности ноты	0.16s	0.51s	60.57
2070	83	missing_note	Пропущена нота E5	E5	—	60.57
2071	83	missing_note	Пропущена нота B4	B4	—	60.58
2072	83	missing_note	Пропущена нота A5	A5	—	60.58
2073	83	missing_note	Пропущена нота C#6	C#6	—	60.58
2074	83	missing_note	Пропущена нота D6	D6	—	60.58
2075	83	missing_note	Пропущена нота B5	B5	—	60.74
2076	83	missing_note	Пропущена нота B5	B5	—	61
2077	83	missing_note	Пропущена нота E5	E5	—	61
2078	83	missing_note	Пропущена нота A5	A5	—	61
2079	83	missing_note	Пропущена нота F#4	F#4	—	61.01
2080	83	missing_note	Пропущена нота D4	D4	—	61.02
2081	83	missing_note	Пропущена нота C#6	C#6	—	61.02
2082	83	missing_note	Пропущена нота F4	F4	—	61.03
2083	83	missing_note	Пропущена нота G5	G5	—	61.03
2084	83	missing_note	Пропущена нота F5	F5	—	61.05
2085	83	missing_note	Пропущена нота E4	E4	—	61.06
2086	83	wrong_pitch	Отклонение ноты C4	C4	A#4	61.44
2087	83	late	Задержка начала ноты	0 ms	780 ms	61.44
2088	83	articulation	Несоответствие длительности ноты	0.03s	0.23s	61.44
2089	83	wrong_pitch	Отклонение ноты F4	F4	D5	61.44
2090	83	late	Задержка начала ноты	0 ms	792 ms	61.44
2091	83	articulation	Несоответствие длительности ноты	0.03s	0.16s	61.44
2092	83	missing_note	Пропущена нота B5	B5	—	61.44
2093	83	missing_note	Пропущена нота E7	E7	—	61.44
2094	83	wrong_pitch	Отклонение ноты C#6	C#6	F5	61.45
2095	83	late	Задержка начала ноты	0 ms	792 ms	61.45
2096	83	missing_note	Пропущена нота B4	B4	—	61.47
2097	83	missing_note	Пропущена нота G5	G5	—	61.48
2098	83	missing_note	Пропущена нота E4	E4	—	61.48
2099	83	missing_note	Пропущена нота C#6	C#6	—	61.63
2100	83	wrong_pitch	Отклонение ноты F4	F4	A#4	61.86
2101	83	late	Задержка начала ноты	0 ms	745 ms	61.86
2102	83	articulation	Несоответствие длительности ноты	0.02s	0.59s	61.86
2103	83	wrong_pitch	Отклонение ноты E5	E5	D#5	61.86
2104	83	late	Задержка начала ноты	0 ms	757 ms	61.86
2105	83	articulation	Несоответствие длительности ноты	0.16s	0.51s	61.86
2106	83	wrong_pitch	Отклонение ноты A5	A5	G5	61.87
2107	83	late	Задержка начала ноты	0 ms	757 ms	61.87
2108	83	articulation	Несоответствие длительности ноты	0.06s	0.50s	61.87
2109	83	missing_note	Пропущена нота G5	G5	—	61.87
2110	83	missing_note	Пропущена нота B5	B5	—	61.87
2111	83	missing_note	Пропущена нота F#7	F#7	—	61.88
2112	83	missing_note	Пропущена нота E4	E4	—	61.88
2113	83	missing_note	Пропущена нота D7	D7	—	61.88
2114	83	missing_note	Пропущена нота C4	C4	—	61.9
2115	83	missing_note	Пропущена нота F4	F4	—	62.3
2116	83	missing_note	Пропущена нота E5	E5	—	62.3
2117	83	missing_note	Пропущена нота A5	A5	—	62.3
2118	83	missing_note	Пропущена нота B5	B5	—	62.31
2119	83	missing_note	Пропущена нота E7	E7	—	62.31
2120	83	missing_note	Пропущена нота C#6	C#6	—	62.31
2121	83	missing_note	Пропущена нота E4	E4	—	62.34
2122	83	missing_note	Пропущена нота D#5	D#5	—	62.52
2123	83	missing_note	Пропущена нота E4	E4	—	62.53
2124	83	missing_note	Пропущена нота G5	G5	—	62.53
2125	83	missing_note	Пропущена нота B5	B5	—	62.55
2126	83	missing_note	Пропущена нота E5	E5	—	62.74
2127	83	wrong_pitch	Отклонение ноты F4	F4	A4	62.81
2128	83	late	Задержка начала ноты	0 ms	791 ms	62.81
2129	83	articulation	Несоответствие длительности ноты	0.03s	0.19s	62.81
2130	83	wrong_pitch	Отклонение ноты E4	E4	E5	62.92
2131	83	late	Задержка начала ноты	0 ms	698 ms	62.92
2132	83	articulation	Несоответствие длительности ноты	0.08s	0.19s	62.92
2133	83	wrong_pitch	Отклонение ноты G5	G5	C#5	62.98
2134	83	late	Задержка начала ноты	0 ms	640 ms	62.98
2135	83	articulation	Несоответствие длительности ноты	0.30s	0.20s	62.98
2136	83	missing_note	Пропущена нота E4	E4	—	63.1
2137	83	wrong_pitch	Отклонение ноты E4	E4	A4	63.23
2138	83	late	Задержка начала ноты	0 ms	733 ms	63.23
2139	83	articulation	Несоответствие длительности ноты	0.09s	0.68s	63.23
2140	83	wrong_pitch	Отклонение ноты G6	G6	D5	63.28
2141	83	late	Задержка начала ноты	0 ms	698 ms	63.28
2142	83	articulation	Несоответствие длительности ноты	0.03s	0.84s	63.28
2143	83	wrong_pitch	Отклонение ноты G5	G5	F#5	63.29
2144	83	late	Задержка начала ноты	0 ms	698 ms	63.29
2145	83	articulation	Несоответствие длительности ноты	0.16s	0.82s	63.29
2146	83	wrong_pitch	Отклонение ноты B5	B5	D6	63.84
2147	83	late	Задержка начала ноты	0 ms	209 ms	63.84
2148	83	articulation	Несоответствие длительности ноты	0.56s	0.26s	63.84
2149	83	missing_note	Пропущена нота F4	F4	—	63.85
2150	83	missing_note	Пропущена нота C6	C6	—	63.85
2151	83	missing_note	Пропущена нота A5	A5	—	63.85
2152	83	missing_note	Пропущена нота F#7	F#7	—	63.85
2153	83	missing_note	Пропущена нота F4	F4	—	63.93
2154	83	missing_note	Пропущена нота A5	A5	—	63.94
2155	83	missing_note	Пропущена нота A#5	A#5	—	63.99
2156	83	missing_note	Пропущена нота D#4	D#4	—	64.02
2157	83	missing_note	Пропущена нота D#6	D#6	—	64.02
2158	83	missing_note	Пропущена нота C#6	C#6	—	64.02
2159	83	missing_note	Пропущена нота E6	E6	—	64.02
2160	83	missing_note	Пропущена нота F5	F5	—	64.03
2161	83	missing_note	Пропущена нота A5	A5	—	64.03
2162	83	missing_note	Пропущена нота F6	F6	—	64.03
2163	83	missing_note	Пропущена нота E4	E4	—	64.06
2164	83	missing_note	Пропущена нота D#6	D#6	—	64.06
2165	83	missing_note	Пропущена нота E6	E6	—	64.26
2166	83	wrong_pitch	Отклонение ноты B5	B5	D#5	64.67
2167	83	late	Задержка начала ноты	0 ms	591 ms	64.67
2168	83	wrong_pitch	Отклонение ноты F4	F4	G6	64.69
2169	83	late	Задержка начала ноты	0 ms	591 ms	64.69
2170	83	articulation	Несоответствие длительности ноты	0.02s	0.24s	64.69
2171	83	wrong_pitch	Отклонение ноты A5	A5	G5	64.69
2172	83	late	Задержка начала ноты	0 ms	603 ms	64.69
2173	83	articulation	Несоответствие длительности ноты	0.07s	0.37s	64.69
2174	83	missing_note	Пропущена нота F#7	F#7	—	64.7
2175	83	missing_note	Пропущена нота E4	E4	—	64.71
2176	83	missing_note	Пропущена нота E4	E4	—	64.76
2177	83	missing_note	Пропущена нота C#6	C#6	—	64.76
2178	83	wrong_pitch	Отклонение ноты A5	A5	D#5	64.77
2179	83	late	Задержка начала ноты	0 ms	788 ms	64.77
2180	83	articulation	Несоответствие длительности ноты	0.08s	0.19s	64.77
2181	83	missing_note	Пропущена нота E4	E4	—	64.83
2182	83	missing_note	Пропущена нота C6	C6	—	64.84
2183	83	missing_note	Пропущена нота G#5	G#5	—	64.85
2184	83	missing_note	Пропущена нота E6	E6	—	64.85
2185	83	missing_note	Пропущена нота C#6	C#6	—	64.87
2186	83	missing_note	Пропущена нота F5	F5	—	64.87
2187	83	missing_note	Пропущена нота G6	G6	—	64.87
2188	83	missing_note	Пропущена нота A5	A5	—	64.87
2189	83	missing_note	Пропущена нота E4	E4	—	64.9
2190	83	missing_note	Пропущена нота C#6	C#6	—	64.93
2191	83	wrong_pitch	Отклонение ноты E6	E6	C#5	65.08
2192	83	late	Задержка начала ноты	0 ms	754 ms	65.08
2193	83	articulation	Несоответствие длительности ноты	0.22s	0.14s	65.08
2194	83	wrong_pitch	Отклонение ноты F4	F4	A#4	65.47
2195	83	late	Задержка начала ноты	0 ms	684 ms	65.47
2196	83	articulation	Несоответствие длительности ноты	0.03s	0.17s	65.47
2197	83	wrong_pitch	Отклонение ноты A5	A5	D#5	65.47
2198	83	late	Задержка начала ноты	0 ms	684 ms	65.47
2199	83	articulation	Несоответствие длительности ноты	0.06s	0.19s	65.47
2200	83	wrong_pitch	Отклонение ноты B5	B5	G5	65.47
2201	83	late	Задержка начала ноты	0 ms	696 ms	65.47
2202	83	articulation	Несоответствие длительности ноты	0.36s	0.19s	65.47
2203	83	missing_note	Пропущена нота F#7	F#7	—	65.49
2204	83	missing_note	Пропущена нота E4	E4	—	65.5
2205	83	missing_note	Пропущена нота A#5	A#5	—	65.52
2206	83	missing_note	Пропущена нота F4	F4	—	65.57
2207	83	missing_note	Пропущена нота C6	C6	—	65.59
2208	83	missing_note	Пропущена нота E6	E6	—	65.69
2209	83	missing_note	Пропущена нота C#6	C#6	—	65.69
2210	83	missing_note	Пропущена нота D#6	D#6	—	65.69
2211	83	missing_note	Пропущена нота F4	F4	—	65.7
2212	83	missing_note	Пропущена нота A5	A5	—	65.7
2213	83	missing_note	Пропущена нота E4	E4	—	65.78
2214	83	missing_note	Пропущена нота D6	D6	—	65.79
2215	83	missing_note	Пропущена нота E4	E4	—	65.83
2216	83	missing_note	Пропущена нота B5	B5	—	65.85
2217	83	missing_note	Пропущена нота C#6	C#6	—	65.88
2218	83	missing_note	Пропущена нота A5	A5	—	65.88
2219	83	missing_note	Пропущена нота F4	F4	—	65.9
2220	83	wrong_pitch	Отклонение ноты E4	E4	D5	65.97
2221	83	late	Задержка начала ноты	0 ms	753 ms	65.97
2222	83	articulation	Несоответствие длительности ноты	0.03s	0.15s	65.97
2223	83	wrong_pitch	Отклонение ноты A#5	A#5	A4	66.1
2224	83	late	Задержка начала ноты	0 ms	613 ms	66.1
2225	83	wrong_pitch	Отклонение ноты F4	F4	F#5	66.12
2226	83	late	Задержка начала ноты	0 ms	613 ms	66.12
2227	83	articulation	Несоответствие длительности ноты	0.02s	0.26s	66.12
2228	83	missing_note	Пропущена нота C6	C6	—	66.12
2229	83	missing_note	Пропущена нота F7	F7	—	66.12
2230	83	missing_note	Пропущена нота F#7	F#7	—	66.13
2231	83	missing_note	Пропущена нота E4	E4	—	66.14
2232	83	missing_note	Пропущена нота G#5	G#5	—	66.15
2233	83	missing_note	Пропущена нота F#5	F#5	—	66.33
2234	83	missing_note	Пропущена нота F4	F4	—	66.34
2235	83	missing_note	Пропущена нота E4	E4	—	66.36
2236	83	wrong_pitch	Отклонение ноты F#4	F#4	A4	66.55
2237	83	late	Задержка начала ноты	0 ms	752 ms	66.55
2238	83	articulation	Несоответствие длительности ноты	0.02s	0.22s	66.55
2239	83	wrong_pitch	Отклонение ноты C6	C6	F#5	66.55
2240	83	late	Задержка начала ноты	0 ms	764 ms	66.55
2241	83	articulation	Несоответствие длительности ноты	0.05s	0.19s	66.55
2242	83	missing_note	Пропущена нота F#7	F#7	—	66.55
2243	83	missing_note	Пропущена нота A#5	A#5	—	66.56
2244	83	missing_note	Пропущена нота B5	B5	—	66.56
2245	83	missing_note	Пропущена нота F5	F5	—	66.57
2246	83	missing_note	Пропущена нота A5	A5	—	66.58
2247	83	wrong_pitch	Отклонение ноты F4	F4	A4	67.2
2248	83	late	Задержка начала ноты	0 ms	321 ms	67.2
2249	83	articulation	Несоответствие длительности ноты	0.03s	0.30s	67.2
2250	83	wrong_pitch	Отклонение ноты A5	A5	A4	67.2
2251	83	late	Задержка начала ноты	0 ms	625 ms	67.2
2252	83	wrong_pitch	Отклонение ноты D4	D4	E6	67.21
2253	83	late	Задержка начала ноты	0 ms	625 ms	67.21
2254	83	articulation	Несоответствие длительности ноты	0.02s	0.17s	67.21
2255	83	wrong_pitch	Отклонение ноты E7	E7	C#5	67.21
2256	83	late	Задержка начала ноты	0 ms	625 ms	67.21
2257	83	articulation	Несоответствие длительности ноты	0.08s	0.24s	67.21
2258	83	wrong_pitch	Отклонение ноты E4	E4	E5	67.23
2259	83	late	Задержка начала ноты	0 ms	613 ms	67.23
2260	83	articulation	Несоответствие длительности ноты	0.02s	0.29s	67.23
2261	83	missing_note	Пропущена нота G#5	G#5	—	67.26
2262	83	missing_note	Пропущена нота F4	F4	—	67.28
2263	83	missing_note	Пропущена нота D4	D4	—	67.29
2264	83	missing_note	Пропущена нота E7	E7	—	67.31
2265	83	missing_note	Пропущена нота B5	B5	—	67.33
2266	83	missing_note	Пропущена нота C#6	C#6	—	67.33
2267	83	missing_note	Пропущена нота D#4	D#4	—	67.38
2268	83	missing_note	Пропущена нота D#7	D#7	—	67.38
2269	83	missing_note	Пропущена нота B5	B5	—	67.38
2270	83	missing_note	Пропущена нота C#6	C#6	—	67.38
2271	83	missing_note	Пропущена нота D6	D6	—	67.38
2272	83	missing_note	Пропущена нота F5	F5	—	67.4
2273	83	missing_note	Пропущена нота D7	D7	—	67.4
2274	83	missing_note	Пропущена нота D#6	D#6	—	67.41
2275	83	missing_note	Пропущена нота A5	A5	—	67.44
2276	83	missing_note	Пропущена нота C#6	C#6	—	67.45
2277	83	missing_note	Пропущена нота F4	F4	—	67.47
2278	83	wrong_pitch	Отклонение ноты A5	A5	A4	68.05
2279	83	late	Задержка начала ноты	0 ms	252 ms	68.05
2280	83	articulation	Несоответствие длительности ноты	0.28s	0.16s	68.05
2281	83	wrong_pitch	Отклонение ноты F4	F4	D5	68.06
2282	83	late	Задержка начала ноты	0 ms	298 ms	68.06
2283	83	articulation	Несоответствие длительности ноты	0.02s	0.15s	68.06
2284	83	wrong_pitch	Отклонение ноты E7	E7	A4	68.06
2285	83	late	Задержка начала ноты	0 ms	414 ms	68.06
2286	83	wrong_pitch	Отклонение ноты E4	E4	A4	68.08
2287	83	late	Задержка начала ноты	0 ms	565 ms	68.08
2288	83	articulation	Несоответствие длительности ноты	0.02s	0.17s	68.08
2289	83	wrong_pitch	Отклонение ноты F4	F4	E5	68.14
2290	83	late	Задержка начала ноты	0 ms	530 ms	68.14
2291	83	articulation	Несоответствие длительности ноты	0.03s	0.17s	68.14
2292	83	missing_note	Пропущена нота B5	B5	—	68.14
2293	83	missing_note	Пропущена нота E4	E4	—	68.17
2294	83	missing_note	Пропущена нота B5	B5	—	68.19
2295	83	missing_note	Пропущена нота F4	F4	—	68.22
2296	83	missing_note	Пропущена нота C#6	C#6	—	68.22
2297	83	missing_note	Пропущена нота D#6	D#6	—	68.23
2298	83	missing_note	Пропущена нота D7	D7	—	68.23
2299	83	missing_note	Пропущена нота D4	D4	—	68.24
2300	83	missing_note	Пропущена нота D6	D6	—	68.26
2301	83	missing_note	Пропущена нота E4	E4	—	68.27
2302	83	missing_note	Пропущена нота C6	C6	—	68.28
2303	83	missing_note	Пропущена нота C#6	C#6	—	68.29
2304	83	wrong_pitch	Отклонение ноты F4	F4	A4	68.84
2305	83	late	Задержка начала ноты	0 ms	390 ms	68.84
2306	83	articulation	Несоответствие длительности ноты	0.03s	0.79s	68.84
2307	83	wrong_pitch	Отклонение ноты B5	B5	D6	68.84
2308	83	late	Задержка начала ноты	0 ms	401 ms	68.84
2309	83	articulation	Несоответствие длительности ноты	0.05s	0.47s	68.84
2310	83	wrong_pitch	Отклонение ноты E7	E7	D5	68.84
2311	83	late	Задержка начала ноты	0 ms	413 ms	68.84
2312	83	articulation	Несоответствие длительности ноты	0.09s	0.72s	68.84
2313	83	missing_note	Пропущена нота A5	A5	—	68.84
2314	83	missing_note	Пропущена нота B5	B5	—	68.93
2315	83	missing_note	Пропущена нота C#6	C#6	—	69.03
2316	83	missing_note	Пропущена нота F4	F4	—	69.05
2317	83	missing_note	Пропущена нота B5	B5	—	69.05
2318	83	missing_note	Пропущена нота E4	E4	—	69.08
2319	83	wrong_pitch	Отклонение ноты F4	F4	A6	69.26
2320	83	late	Задержка начала ноты	0 ms	634 ms	69.26
2321	83	articulation	Несоответствие длительности ноты	0.03s	0.16s	69.26
2322	83	missing_note	Пропущена нота A5	A5	—	69.27
2323	83	wrong_pitch	Отклонение ноты B5	B5	A5	69.5
2324	83	late	Задержка начала ноты	0 ms	773 ms	69.5
2325	83	articulation	Несоответствие длительности ноты	0.03s	0.20s	69.5
2326	83	missing_note	Пропущена нота F5	F5	—	69.5
2327	83	missing_note	Пропущена нота D#7	D#7	—	69.5
2328	83	missing_note	Пропущена нота G#5	G#5	—	69.5
2329	83	missing_note	Пропущена нота E4	E4	—	69.52
2330	83	missing_note	Пропущена нота A5	A5	—	69.53
2331	83	wrong_pitch	Отклонение ноты E5	E5	D5	69.7
2332	83	late	Задержка начала ноты	0 ms	773 ms	69.7
2333	83	articulation	Несоответствие длительности ноты	0.24s	0.14s	69.7
2334	83	missing_note	Пропущена нота F4	F4	—	69.71
2335	83	missing_note	Пропущена нота D#6	D#6	—	69.72
2336	83	missing_note	Пропущена нота E4	E4	—	69.73
2337	83	missing_note	Пропущена нота B6	B6	—	69.73
2338	83	missing_note	Пропущена нота A5	A5	—	69.92
2339	83	missing_note	Пропущена нота F4	F4	—	69.93
2340	83	missing_note	Пропущена нота E7	E7	—	69.93
2341	83	missing_note	Пропущена нота B5	B5	—	69.94
2342	83	missing_note	Пропущена нота E4	E4	—	69.97
2343	83	missing_note	Пропущена нота F4	F4	—	70.01
2344	83	wrong_pitch	Отклонение ноты E5	E5	D5	70.57
2345	83	late	Задержка начала ноты	0 ms	296 ms	70.57
2346	83	articulation	Несоответствие длительности ноты	0.48s	0.30s	70.57
2347	83	wrong_pitch	Отклонение ноты F4	F4	E5	70.58
2348	83	late	Задержка начала ноты	0 ms	690 ms	70.58
2349	83	articulation	Несоответствие длительности ноты	0.03s	0.23s	70.58
2350	83	missing_note	Пропущена нота B6	B6	—	70.58
2351	83	missing_note	Пропущена нота B4	B4	—	70.59
2352	83	missing_note	Пропущена нота E4	E4	—	70.62
2353	83	wrong_pitch	Отклонение ноты F5	F5	A4	70.76
2354	83	late	Задержка начала ноты	0 ms	736 ms	70.76
2355	83	articulation	Несоответствие длительности ноты	0.06s	0.13s	70.76
2356	83	missing_note	Пропущена нота A5	A5	—	70.76
2357	83	missing_note	Пропущена нота F4	F4	—	70.77
2358	83	missing_note	Пропущена нота B5	B5	—	70.77
2359	83	missing_note	Пропущена нота E4	E4	—	70.79
2360	83	wrong_pitch	Отклонение ноты F4	F4	A4	71.76
2361	83	articulation	Несоответствие длительности ноты	0.03s	0.15s	71.76
2362	83	wrong_pitch	Отклонение ноты B6	B6	A5	71.76
2363	83	articulation	Несоответствие длительности ноты	0.34s	0.15s	71.76
2364	83	wrong_pitch	Отклонение ноты E5	E5	A5	71.76
2365	83	early	Преждевременное начало ноты	0 ms	-110 ms	71.76
2366	83	articulation	Несоответствие длительности ноты	0.57s	0.19s	71.76
2367	83	wrong_pitch	Отклонение ноты E4	E4	A5	71.79
2368	83	late	Задержка начала ноты	0 ms	202 ms	71.79
2369	83	articulation	Несоответствие длительности ноты	0.02s	0.15s	71.79
2370	83	wrong_pitch	Отклонение ноты F4	F4	A4	71.84
2371	83	late	Задержка начала ноты	0 ms	318 ms	71.84
2372	83	articulation	Несоответствие длительности ноты	0.02s	0.15s	71.84
2373	83	wrong_pitch	Отклонение ноты D#4	D#4	A5	71.85
2374	83	late	Задержка начала ноты	0 ms	481 ms	71.85
2375	83	articulation	Несоответствие длительности ноты	0.02s	0.16s	71.85
2376	83	wrong_pitch	Отклонение ноты E4	E4	A4	71.87
2377	83	late	Задержка начала ноты	0 ms	585 ms	71.87
2378	83	articulation	Несоответствие длительности ноты	0.03s	0.14s	71.87
2379	83	wrong_pitch	Отклонение ноты E4	E4	E5	71.92
2380	83	late	Задержка начала ноты	0 ms	748 ms	71.92
2381	83	articulation	Несоответствие длительности ноты	0.02s	0.21s	71.92
2382	83	missing_note	Пропущена нота F4	F4	—	71.94
2383	83	missing_note	Пропущена нота B4	B4	—	71.95
2384	83	missing_note	Пропущена нота E4	E4	—	71.97
2385	83	missing_note	Пропущена нота E4	E4	—	72.01
2386	83	wrong_pitch	Отклонение ноты E4	E4	A4	72.06
2387	83	late	Задержка начала ноты	0 ms	782 ms	72.06
2388	83	articulation	Несоответствие длительности ноты	0.03s	0.22s	72.06
2389	83	missing_note	Пропущена нота F#4	F#4	—	72.16
2390	83	missing_note	Пропущена нота B6	B6	—	72.16
2391	83	missing_note	Пропущена нота B4	B4	—	72.19
2392	83	missing_note	Пропущена нота E4	E4	—	72.21
2393	83	wrong_pitch	Отклонение ноты E5	E5	C#5	72.35
2394	83	late	Задержка начала ноты	0 ms	724 ms	72.35
2395	83	articulation	Несоответствие длительности ноты	0.53s	0.20s	72.35
2396	83	wrong_pitch	Отклонение ноты A5	A5	E4	72.4
2397	83	late	Задержка начала ноты	0 ms	700 ms	72.4
2398	83	articulation	Несоответствие длительности ноты	0.52s	0.20s	72.4
2399	83	missing_note	Пропущена нота F4	F4	—	72.41
2400	83	missing_note	Пропущена нота B5	B5	—	72.41
2401	83	missing_note	Пропущена нота E4	E4	—	72.43
2402	83	wrong_pitch	Отклонение ноты E5	E5	A4	72.94
2403	83	late	Задержка начала ноты	0 ms	316 ms	72.94
2404	83	articulation	Несоответствие длительности ноты	1.12s	0.15s	72.94
2405	83	wrong_pitch	Отклонение ноты F4	F4	C#5	73.03
2406	83	late	Задержка начала ноты	0 ms	398 ms	73.03
2407	83	articulation	Несоответствие длительности ноты	0.02s	0.30s	73.03
2408	83	wrong_pitch	Отклонение ноты B6	B6	A4	73.03
2409	83	late	Задержка начала ноты	0 ms	503 ms	73.03
2410	83	wrong_pitch	Отклонение ноты E4	E4	C#5	73.07
2411	83	late	Задержка начала ноты	0 ms	666 ms	73.07
2412	83	articulation	Несоответствие длительности ноты	0.02s	0.14s	73.07
2413	83	missing_note	Пропущена нота E4	E4	—	73.1
2414	83	missing_note	Пропущена нота F4	F4	—	73.27
2415	83	missing_note	Пропущена нота G#6	G#6	—	73.27
2416	83	missing_note	Пропущена нота D4	D4	—	73.28
2417	83	missing_note	Пропущена нота G#5	G#5	—	73.28
2418	83	missing_note	Пропущена нота E4	E4	—	73.3
2419	83	wrong_pitch	Отклонение ноты F4	F4	E5	73.36
2420	83	late	Задержка начала ноты	0 ms	770 ms	73.36
2421	83	articulation	Несоответствие длительности ноты	0.03s	0.22s	73.36
2422	83	missing_note	Пропущена нота G6	G6	—	73.36
2423	83	missing_note	Пропущена нота G5	G5	—	73.37
2424	83	missing_note	Пропущена нота E4	E4	—	73.4
2425	83	missing_note	Пропущена нота F#5	F#5	—	73.44
2426	83	missing_note	Пропущена нота G5	G5	—	73.47
2427	83	missing_note	Пропущена нота F4	F4	—	73.48
2428	83	missing_note	Пропущена нота B6	B6	—	73.48
2429	83	missing_note	Пропущена нота D#4	D#4	—	73.49
2430	83	missing_note	Пропущена нота E4	E4	—	73.51
2431	83	wrong_pitch	Отклонение ноты C7	C7	G#5	73.73
2432	83	late	Задержка начала ноты	0 ms	688 ms	73.73
2433	83	articulation	Несоответствие длительности ноты	0.03s	0.14s	73.73
2434	83	wrong_pitch	Отклонение ноты F4	F4	E4	73.73
2435	83	late	Задержка начала ноты	0 ms	734 ms	73.73
2436	83	articulation	Несоответствие длительности ноты	0.05s	0.17s	73.73
2437	83	missing_note	Пропущена нота E4	E4	—	73.77
2438	83	wrong_pitch	Отклонение ноты E4	E4	A4	73.97
2439	83	late	Задержка начала ноты	0 ms	606 ms	73.97
2440	83	articulation	Несоответствие длительности ноты	0.10s	0.14s	73.97
2441	83	wrong_pitch	Отклонение ноты B5	B5	G#5	73.97
2442	83	late	Задержка начала ноты	0 ms	769 ms	73.97
2443	83	articulation	Несоответствие длительности ноты	0.13s	0.16s	73.97
2444	83	missing_note	Пропущена нота F5	F5	—	74.06
2445	83	missing_note	Пропущена нота F4	F4	—	74.07
2446	83	missing_note	Пропущена нота C6	C6	—	74.07
2447	83	missing_note	Пропущена нота E4	E4	—	74.16
2448	83	missing_note	Пропущена нота B5	B5	—	74.17
2449	83	missing_note	Пропущена нота D7	D7	—	74.21
2450	83	missing_note	Пропущена нота F4	F4	—	74.26
2451	83	missing_note	Пропущена нота G5	G5	—	74.27
2452	83	missing_note	Пропущена нота D6	D6	—	74.28
2453	83	missing_note	Пропущена нота G4	G4	—	74.28
2454	83	missing_note	Пропущена нота E4	E4	—	74.31
2455	83	missing_note	Пропущена нота F#4	F#4	—	74.37
2456	83	wrong_pitch	Отклонение ноты A5	A5	A4	74.38
2457	83	late	Задержка начала ноты	0 ms	791 ms	74.38
2458	83	articulation	Несоответствие длительности ноты	0.03s	0.14s	74.38
2459	83	missing_note	Пропущена нота G5	G5	—	74.38
2460	83	missing_note	Пропущена нота E6	E6	—	74.4
2461	83	missing_note	Пропущена нота A4	A4	—	74.4
2462	83	missing_note	Пропущена нота E4	E4	—	74.42
2463	83	missing_note	Пропущена нота G#5	G#5	—	74.42
2464	83	missing_note	Пропущена нота F#4	F#4	—	74.48
2465	83	missing_note	Пропущена нота A#5	A#5	—	74.48
2466	83	missing_note	Пропущена нота A#4	A#4	—	74.49
2467	83	missing_note	Пропущена нота E4	E4	—	74.52
2468	83	wrong_pitch	Отклонение ноты F4	F4	C#5	74.58
2469	83	late	Задержка начала ноты	0 ms	780 ms	74.58
2470	83	articulation	Несоответствие длительности ноты	0.02s	0.18s	74.58
2471	83	missing_note	Пропущена нота A5	A5	—	74.58
2472	83	missing_note	Пропущена нота C#7	C#7	—	74.59
2473	83	missing_note	Пропущена нота E6	E6	—	74.59
2474	83	missing_note	Пропущена нота E4	E4	—	74.6
2475	83	missing_note	Пропущена нота A4	A4	—	74.6
2476	83	missing_note	Пропущена нота G#5	G#5	—	74.64
2477	83	missing_note	Пропущена нота D#6	D#6	—	74.64
2478	83	missing_note	Пропущена нота D6	D6	—	74.69
2479	83	missing_note	Пропущена нота G5	G5	—	74.69
2480	83	missing_note	Пропущена нота B6	B6	—	74.7
2481	83	missing_note	Пропущена нота G4	G4	—	74.7
2482	83	wrong_pitch	Отклонение ноты E4	E4	A4	74.78
2483	83	late	Задержка начала ноты	0 ms	746 ms	74.78
2484	83	articulation	Несоответствие длительности ноты	0.09s	0.15s	74.78
2485	83	missing_note	Пропущена нота B5	B5	—	74.79
2486	83	missing_note	Пропущена нота D7	D7	—	74.83
2487	83	missing_note	Пропущена нота D6	D6	—	74.88
2488	83	missing_note	Пропущена нота G4	G4	—	74.9
2489	83	wrong_pitch	Отклонение ноты F#4	F#4	C5	74.97
2490	83	late	Задержка начала ноты	0 ms	745 ms	74.97
2491	83	articulation	Несоответствие длительности ноты	0.02s	0.16s	74.97
2492	83	missing_note	Пропущена нота E4	E4	—	74.99
2493	83	missing_note	Пропущена нота B5	B5	—	74.99
2494	83	missing_note	Пропущена нота D7	D7	—	75.03
2495	83	wrong_pitch	Отклонение ноты D6	D6	A4	75.09
2496	83	late	Задержка начала ноты	0 ms	780 ms	75.09
2497	83	articulation	Несоответствие длительности ноты	0.06s	0.15s	75.09
2498	83	missing_note	Пропущена нота G5	G5	—	75.09
2499	83	missing_note	Пропущена нота G4	G4	—	75.1
2500	83	missing_note	Пропущена нота F4	F4	—	75.19
2501	83	missing_note	Пропущена нота D#6	D#6	—	75.19
2502	83	missing_note	Пропущена нота G#5	G#5	—	75.19
2503	83	missing_note	Пропущена нота C7	C7	—	75.2
2504	83	missing_note	Пропущена нота G#4	G#4	—	75.21
2505	83	missing_note	Пропущена нота E4	E4	—	75.23
2506	83	wrong_pitch	Отклонение ноты G4	G4	C5	75.24
2507	83	late	Задержка начала ноты	0 ms	791 ms	75.24
2508	83	articulation	Несоответствие длительности ноты	0.02s	0.15s	75.24
2509	83	missing_note	Пропущена нота A5	A5	—	75.26
2510	83	missing_note	Пропущена нота G#4	G#4	—	75.27
2511	83	missing_note	Пропущена нота F4	F4	—	75.28
2512	83	missing_note	Пропущена нота A#5	A#5	—	75.28
2513	83	missing_note	Пропущена нота B5	B5	—	75.29
2514	83	missing_note	Пропущена нота A#4	A#4	—	75.29
2515	83	missing_note	Пропущена нота E4	E4	—	75.3
2516	83	missing_note	Пропущена нота A4	A4	—	75.34
2517	83	missing_note	Пропущена нота A5	A5	—	75.36
2518	83	missing_note	Пропущена нота D#4	D#4	—	75.38
2519	83	missing_note	Пропущена нота F#7	F#7	—	75.4
2520	83	missing_note	Пропущена нота B5	B5	—	75.4
2521	83	missing_note	Пропущена нота F4	F4	—	75.41
2522	83	missing_note	Пропущена нота F#6	F#6	—	75.41
2523	83	missing_note	Пропущена нота B4	B4	—	75.41
2524	83	missing_note	Пропущена нота D#7	D#7	—	75.42
2525	83	missing_note	Пропущена нота E4	E4	—	75.43
2526	83	missing_note	Пропущена нота F4	F4	—	75.47
2527	83	missing_note	Пропущена нота C#5	C#5	—	75.48
2528	83	missing_note	Пропущена нота D6	D6	—	75.49
2529	83	missing_note	Пропущена нота E4	E4	—	75.52
2530	83	missing_note	Пропущена нота D5	D5	—	75.52
2531	83	wrong_pitch	Отклонение ноты F4	F4	C5	75.56
2532	83	late	Задержка начала ноты	0 ms	791 ms	75.56
2533	83	articulation	Несоответствие длительности ноты	0.03s	0.14s	75.56
2534	83	missing_note	Пропущена нота D#5	D#5	—	75.57
2535	83	missing_note	Пропущена нота F5	F5	—	75.59
2536	83	missing_note	Пропущена нота G7	G7	—	75.59
2537	83	missing_note	Пропущена нота E4	E4	—	75.62
2538	83	missing_note	Пропущена нота E4	E4	—	75.66
2539	83	missing_note	Пропущена нота E6	E6	—	75.67
2540	83	missing_note	Пропущена нота E5	E5	—	75.7
2541	83	missing_note	Пропущена нота B6	B6	—	75.71
2542	83	missing_note	Пропущена нота B5	B5	—	75.8
2543	83	missing_note	Пропущена нота F4	F4	—	75.8
2544	83	missing_note	Пропущена нота C#6	C#6	—	75.8
2545	83	missing_note	Пропущена нота D6	D6	—	75.8
2546	83	missing_note	Пропущена нота B4	B4	—	75.81
2547	83	missing_note	Пропущена нота D5	D5	—	75.81
2548	83	missing_note	Пропущена нота A6	A6	—	75.81
2549	83	missing_note	Пропущена нота E4	E4	—	75.84
2550	83	missing_note	Пропущена нота D#6	D#6	—	75.86
2551	83	wrong_pitch	Отклонение ноты E4	E4	E5	75.87
2552	83	late	Задержка начала ноты	0 ms	790 ms	75.87
2553	83	articulation	Несоответствие длительности ноты	0.03s	0.27s	75.87
2554	83	missing_note	Пропущена нота C#6	C#6	—	75.87
2555	83	missing_note	Пропущена нота D5	D5	—	75.88
2556	83	missing_note	Пропущена нота E6	E6	—	75.9
2557	83	missing_note	Пропущена нота F4	F4	—	75.91
2558	83	missing_note	Пропущена нота B6	B6	—	75.91
2559	83	missing_note	Пропущена нота E5	E5	—	75.91
2560	83	missing_note	Пропущена нота E4	E4	—	75.93
2561	83	missing_note	Пропущена нота B6	B6	—	75.99
2562	83	missing_note	Пропущена нота G6	G6	—	76
2563	83	missing_note	Пропущена нота D#4	D#4	—	76.01
2564	83	missing_note	Пропущена нота G5	G5	—	76.01
2565	83	missing_note	Пропущена нота G#5	G#5	—	76.01
2566	83	missing_note	Пропущена нота D7	D7	—	76.01
2567	83	missing_note	Пропущена нота E4	E4	—	76.05
2568	83	missing_note	Пропущена нота G5	G5	—	76.06
2569	83	missing_note	Пропущена нота E4	E4	—	76.09
2570	83	missing_note	Пропущена нота G#5	G#5	—	76.1
2571	83	missing_note	Пропущена нота F4	F4	—	76.12
2572	83	missing_note	Пропущена нота G5	G5	—	76.12
2573	83	missing_note	Пропущена нота E4	E4	—	76.14
2574	83	missing_note	Пропущена нота E6	E6	—	76.14
2575	83	missing_note	Пропущена нота D#7	D#7	—	76.14
2576	83	missing_note	Пропущена нота E4	E4	—	76.17
2577	83	missing_note	Пропущена нота F#4	F#4	—	76.2
2578	83	missing_note	Пропущена нота F5	F5	—	76.21
2579	83	missing_note	Пропущена нота D7	D7	—	76.21
2580	83	missing_note	Пропущена нота G6	G6	—	76.21
2581	83	wrong_pitch	Отклонение ноты G5	G5	A5	76.22
2582	83	late	Задержка начала ноты	0 ms	790 ms	76.22
2583	83	articulation	Несоответствие длительности ноты	0.10s	0.17s	76.22
2584	83	missing_note	Пропущена нота E4	E4	—	76.24
2585	83	missing_note	Пропущена нота E4	E4	—	76.28
2586	83	missing_note	Пропущена нота E5	E5	—	76.3
2587	83	missing_note	Пропущена нота F4	F4	—	76.31
2588	83	missing_note	Пропущена нота B6	B6	—	76.31
2589	83	missing_note	Пропущена нота G5	G5	—	76.34
2590	83	missing_note	Пропущена нота E4	E4	—	76.34
2591	83	wrong_pitch	Отклонение ноты F#4	F#4	A4	76.41
2592	83	late	Задержка начала ноты	0 ms	732 ms	76.41
2593	83	articulation	Несоответствие длительности ноты	0.02s	0.15s	76.41
2594	83	missing_note	Пропущена нота F#7	F#7	—	76.42
2595	83	missing_note	Пропущена нота D6	D6	—	76.42
2596	83	missing_note	Пропущена нота D5	D5	—	76.43
2597	83	missing_note	Пропущена нота E4	E4	—	76.44
2598	83	missing_note	Пропущена нота F4	F4	—	76.49
2599	83	missing_note	Пропущена нота E5	E5	—	76.51
2600	83	wrong_pitch	Отклонение ноты E4	E4	G5	76.56
2601	83	late	Задержка начала ноты	0 ms	789 ms	76.56
2602	83	articulation	Несоответствие длительности ноты	0.03s	0.14s	76.56
2603	83	missing_note	Пропущена нота F4	F4	—	76.6
2604	83	missing_note	Пропущена нота B5	B5	—	76.62
2605	83	missing_note	Пропущена нота C#6	C#6	—	76.62
2606	83	missing_note	Пропущена нота A6	A6	—	76.62
2607	83	missing_note	Пропущена нота D6	D6	—	76.62
2608	83	missing_note	Пропущена нота D4	D4	—	76.63
2609	83	missing_note	Пропущена нота B4	B4	—	76.63
2610	83	missing_note	Пропущена нота D5	D5	—	76.63
2611	83	missing_note	Пропущена нота E4	E4	—	76.65
2612	83	missing_note	Пропущена нота E5	E5	—	76.66
2613	83	wrong_pitch	Отклонение ноты E4	E4	A4	76.69
2614	83	late	Задержка начала ноты	0 ms	790 ms	76.69
2615	83	articulation	Несоответствие длительности ноты	0.03s	0.14s	76.69
2616	83	missing_note	Пропущена нота F5	F5	—	76.71
2617	83	missing_note	Пропущена нота E4	E4	—	76.73
2618	83	missing_note	Пропущена нота F4	F4	—	76.83
2619	83	missing_note	Пропущена нота B5	B5	—	76.84
2620	83	missing_note	Пропущена нота G#6	G#6	—	76.84
2621	83	missing_note	Пропущена нота A5	A5	—	76.84
2622	83	wrong_pitch	Отклонение ноты E7	E7	E5	76.86
2623	83	late	Задержка начала ноты	0 ms	790 ms	76.86
2624	83	articulation	Несоответствие длительности ноты	0.05s	0.31s	76.86
2625	83	missing_note	Пропущена нота E4	E4	—	76.87
2626	83	missing_note	Пропущена нота E5	E5	—	76.92
2627	83	missing_note	Пропущена нота F#7	F#7	—	76.92
2628	83	missing_note	Пропущена нота B5	B5	—	76.92
2629	83	missing_note	Пропущена нота D#4	D#4	—	76.94
2630	83	missing_note	Пропущена нота A#5	A#5	—	76.95
2631	83	missing_note	Пропущена нота A5	A5	—	76.98
2632	83	wrong_pitch	Отклонение ноты D#7	D#7	A4	77.07
2633	83	late	Задержка начала ноты	0 ms	709 ms	77.07
2634	83	articulation	Несоответствие длительности ноты	0.03s	0.14s	77.07
2635	83	missing_note	Пропущена нота C#6	C#6	—	77.07
2636	83	missing_note	Пропущена нота E6	E6	—	77.07
2637	83	missing_note	Пропущена нота F4	F4	—	77.08
2638	83	missing_note	Пропущена нота A5	A5	—	77.08
2639	83	missing_note	Пропущена нота D4	D4	—	77.09
2640	83	missing_note	Пропущена нота F6	F6	—	77.09
2641	83	missing_note	Пропущена нота G6	G6	—	77.09
2642	83	missing_note	Пропущена нота D#6	D#6	—	77.1
2643	83	missing_note	Пропущена нота C6	C6	—	77.1
2644	83	missing_note	Пропущена нота E4	E4	—	77.12
2645	83	missing_note	Пропущена нота A5	A5	—	77.13
2646	83	missing_note	Пропущена нота C#6	C#6	—	77.15
2647	83	missing_note	Пропущена нота E4	E4	—	77.16
4635	86	wrong_pitch	Отклонение ноты A4	A4	G1	0
4636	86	articulation	Несоответствие длительности ноты	0.08s	0.56s	0
4637	86	wrong_pitch	Отклонение ноты E4	E4	G1	0.01
4638	86	late	Задержка начала ноты	±500 ms	551 ms	0.01
4639	86	articulation	Несоответствие длительности ноты	0.02s	0.60s	0.01
4640	86	wrong_pitch	Отклонение ноты E6	E6	C4	0.01
4641	86	late	Задержка начала ноты	±500 ms	1457 ms	0.01
4642	86	articulation	Несоответствие длительности ноты	0.04s	0.16s	0.01
4643	86	missing_note	Пропущена нота E4	E4	—	0.15
4644	86	missing_note	Пропущена нота B5	B5	—	0.15
4645	86	missing_note	Пропущена нота B4	B4	—	0.16
4646	86	missing_note	Пропущена нота C#5	C#5	—	0.29
4647	86	missing_note	Пропущена нота C#6	C#6	—	0.29
4648	86	missing_note	Пропущена нота E4	E4	—	0.3
4649	86	wrong_pitch	Отклонение ноты D5	D5	D4	0.41
4650	86	late	Задержка начала ноты	±500 ms	1458 ms	0.41
4651	86	articulation	Несоответствие длительности ноты	0.08s	0.20s	0.41
4652	86	missing_note	Пропущена нота E4	E4	—	0.42
4653	86	missing_note	Пропущена нота A6	A6	—	0.45
4654	86	missing_note	Пропущена нота E5	E5	—	0.56
4655	86	missing_note	Пропущена нота E4	E4	—	0.57
4656	86	missing_note	Пропущена нота E4	E4	—	0.67
4657	86	missing_note	Пропущена нота D5	D5	—	0.67
4658	86	missing_note	Пропущена нота A6	A6	—	0.69
4659	86	wrong_pitch	Отклонение ноты D5	D5	E4	0.78
4660	86	late	Задержка начала ноты	±500 ms	1480 ms	0.78
4661	86	articulation	Несоответствие длительности ноты	0.02s	0.17s	0.78
4662	86	missing_note	Пропущена нота A4	A4	—	0.8
4663	86	missing_note	Пропущена нота E4	E4	—	0.81
4664	86	missing_note	Пропущена нота C#5	C#5	—	0.81
4665	86	missing_note	Пропущена нота C#6	C#6	—	0.81
4666	86	missing_note	Пропущена нота A#4	A#4	—	0.92
4667	86	missing_note	Пропущена нота E4	E4	—	0.93
4668	86	missing_note	Пропущена нота B5	B5	—	0.93
4669	86	missing_note	Пропущена нота B4	B4	—	0.94
4670	86	missing_note	Пропущена нота E4	E4	—	1.06
4671	86	missing_note	Пропущена нота A4	A4	—	1.06
4672	86	missing_note	Пропущена нота E6	E6	—	1.07
4673	86	wrong_pitch	Отклонение ноты B5	B5	F4	1.17
4674	86	late	Задержка начала ноты	±500 ms	1469 ms	1.17
4675	86	articulation	Несоответствие длительности ноты	0.06s	0.21s	1.17
4676	86	missing_note	Пропущена нота E4	E4	—	1.19
4677	86	missing_note	Пропущена нота B4	B4	—	1.19
4678	86	missing_note	Пропущена нота B4	B4	—	1.28
4679	86	missing_note	Пропущена нота A4	A4	—	1.3
4680	86	missing_note	Пропущена нота E4	E4	—	1.3
4681	86	missing_note	Пропущена нота C#6	C#6	—	1.3
4682	86	missing_note	Пропущена нота C#5	C#5	—	1.3
4683	86	missing_note	Пропущена нота D#4	D#4	—	1.42
4684	86	missing_note	Пропущена нота D5	D5	—	1.43
4685	86	missing_note	Пропущена нота E4	E4	—	1.44
4686	86	missing_note	Пропущена нота A6	A6	—	1.44
4687	86	missing_note	Пропущена нота F#7	F#7	—	1.44
4688	86	wrong_pitch	Отклонение ноты E5	E5	G4	1.56
4689	86	late	Задержка начала ноты	±500 ms	1474 ms	1.56
4690	86	articulation	Несоответствие длительности ноты	0.08s	0.21s	1.56
4691	86	missing_note	Пропущена нота E4	E4	—	1.57
4692	86	missing_note	Пропущена нота D5	D5	—	1.67
4693	86	missing_note	Пропущена нота E4	E4	—	1.69
4694	86	missing_note	Пропущена нота A6	A6	—	1.69
4695	86	missing_note	Пропущена нота D5	D5	—	1.77
4696	86	missing_note	Пропущена нота C#5	C#5	—	1.8
4697	86	missing_note	Пропущена нота C#6	C#6	—	1.8
4698	86	missing_note	Пропущена нота E4	E4	—	1.81
4699	86	missing_note	Пропущена нота E4	E4	—	1.92
4700	86	missing_note	Пропущена нота B5	B5	—	1.92
4701	86	missing_note	Пропущена нота B4	B4	—	1.93
4702	86	missing_note	Пропущена нота A5	A5	—	2.03
4703	86	missing_note	Пропущена нота E4	E4	—	2.05
4704	86	missing_note	Пропущена нота A4	A4	—	2.05
4705	86	missing_note	Пропущена нота E6	E6	—	2.05
4706	86	missing_note	Пропущена нота D4	D4	—	2.09
4707	86	missing_note	Пропущена нота A#4	A#4	—	2.16
4708	86	missing_note	Пропущена нота E4	E4	—	2.16
4709	86	missing_note	Пропущена нота B5	B5	—	2.16
4710	86	missing_note	Пропущена нота B4	B4	—	2.19
4711	86	missing_note	Пропущена нота C#5	C#5	—	2.29
4712	86	missing_note	Пропущена нота C#6	C#6	—	2.29
4713	86	missing_note	Пропущена нота E4	E4	—	2.3
4714	86	wrong_pitch	Отклонение ноты D5	D5	B4	2.4
4715	86	late	Задержка начала ноты	±500 ms	1462 ms	2.4
4716	86	articulation	Несоответствие длительности ноты	0.07s	0.20s	2.4
4717	86	missing_note	Пропущена нота E4	E4	—	2.42
4718	86	missing_note	Пропущена нота A6	A6	—	2.43
4719	86	missing_note	Пропущена нота E4	E4	—	2.53
4720	86	missing_note	Пропущена нота E5	E5	—	2.55
4721	86	missing_note	Пропущена нота E4	E4	—	2.66
4722	86	missing_note	Пропущена нота D5	D5	—	2.66
4723	86	missing_note	Пропущена нота A6	A6	—	2.67
4724	86	wrong_pitch	Отклонение ноты A4	A4	C5	2.79
4725	86	late	Задержка начала ноты	±500 ms	1496 ms	2.79
4726	86	articulation	Несоответствие длительности ноты	0.02s	0.17s	2.79
4727	86	missing_note	Пропущена нота C#5	C#5	—	2.79
4728	86	missing_note	Пропущена нота C#6	C#6	—	2.79
4729	86	missing_note	Пропущена нота E4	E4	—	2.8
4730	86	missing_note	Пропущена нота G#6	G#6	—	2.81
4731	86	missing_note	Пропущена нота E4	E4	—	2.92
4732	86	missing_note	Пропущена нота B5	B5	—	2.92
4733	86	missing_note	Пропущена нота B4	B4	—	2.93
4734	86	missing_note	Пропущена нота F4	F4	—	3.03
4735	86	missing_note	Пропущена нота A4	A4	—	3.03
4736	86	missing_note	Пропущена нота E6	E6	—	3.05
4737	86	missing_note	Пропущена нота E4	E4	—	3.06
4738	86	missing_note	Пропущена нота E4	E4	—	3.12
4739	86	missing_note	Пропущена нота D#4	D#4	—	3.15
4740	86	wrong_pitch	Отклонение ноты B5	B5	D5	3.16
4741	86	late	Задержка начала ноты	±500 ms	1496 ms	3.16
4742	86	missing_note	Пропущена нота E4	E4	—	3.17
4743	86	missing_note	Пропущена нота B4	B4	—	3.19
4744	86	missing_note	Пропущена нота B4	B4	—	3.26
4745	86	missing_note	Пропущена нота A4	A4	—	3.29
4746	86	missing_note	Пропущена нота E4	E4	—	3.29
4747	86	missing_note	Пропущена нота C#6	C#6	—	3.29
4748	86	missing_note	Пропущена нота C#5	C#5	—	3.3
4749	86	missing_note	Пропущена нота D5	D5	—	3.4
4750	86	missing_note	Пропущена нота E4	E4	—	3.43
4751	86	missing_note	Пропущена нота A6	A6	—	3.43
4752	86	missing_note	Пропущена нота F4	F4	—	3.53
4753	86	missing_note	Пропущена нота E5	E5	—	3.55
4754	86	missing_note	Пропущена нота E4	E4	—	3.56
4755	86	late	Задержка начала ноты	±500 ms	1455 ms	3.66
4756	86	articulation	Несоответствие длительности ноты	0.04s	0.21s	3.66
4757	86	missing_note	Пропущена нота E4	E4	—	3.67
4758	86	missing_note	Пропущена нота A6	A6	—	3.67
4759	86	missing_note	Пропущена нота D5	D5	—	3.76
4760	86	missing_note	Пропущена нота A4	A4	—	3.79
4761	86	missing_note	Пропущена нота C#6	C#6	—	3.79
4762	86	missing_note	Пропущена нота E4	E4	—	3.8
4763	86	missing_note	Пропущена нота C#5	C#5	—	3.8
4764	86	missing_note	Пропущена нота D4	D4	—	3.9
4765	86	missing_note	Пропущена нота A#4	A#4	—	3.91
4766	86	missing_note	Пропущена нота B5	B5	—	3.91
4767	86	missing_note	Пропущена нота E4	E4	—	3.92
4768	86	missing_note	Пропущена нота B4	B4	—	3.93
4769	86	missing_note	Пропущена нота D4	D4	—	3.95
4770	86	wrong_pitch	Отклонение ноты E4	E4	F5	4.02
4771	86	late	Задержка начала ноты	±500 ms	1485 ms	4.02
4772	86	articulation	Несоответствие длительности ноты	0.02s	0.16s	4.02
4773	86	missing_note	Пропущена нота A4	A4	—	4.02
4774	86	missing_note	Пропущена нота E6	E6	—	4.03
4775	86	missing_note	Пропущена нота D4	D4	—	4.08
4776	86	missing_note	Пропущена нота E4	E4	—	4.15
4777	86	missing_note	Пропущена нота B5	B5	—	4.15
4778	86	missing_note	Пропущена нота B4	B4	—	4.16
4779	86	missing_note	Пропущена нота C#6	C#6	—	4.28
4780	86	missing_note	Пропущена нота A4	A4	—	4.29
4781	86	missing_note	Пропущена нота E4	E4	—	4.29
4782	86	missing_note	Пропущена нота C#5	C#5	—	4.29
4783	86	wrong_pitch	Отклонение ноты C#6	C#6	G5	4.41
4784	86	late	Задержка начала ноты	±500 ms	1491 ms	4.41
4785	86	articulation	Несоответствие длительности ноты	0.02s	0.19s	4.41
4786	86	missing_note	Пропущена нота E4	E4	—	4.41
4787	86	missing_note	Пропущена нота D5	D5	—	4.41
4788	86	missing_note	Пропущена нота E4	E4	—	4.53
4789	86	missing_note	Пропущена нота E5	E5	—	4.53
4790	86	missing_note	Пропущена нота D5	D5	—	4.65
4791	86	missing_note	Пропущена нота E4	E4	—	4.66
4792	86	missing_note	Пропущена нота A6	A6	—	4.66
4793	86	missing_note	Пропущена нота D5	D5	—	4.74
4794	86	missing_note	Пропущена нота A4	A4	—	4.78
4795	86	missing_note	Пропущена нота C#6	C#6	—	4.78
4796	86	wrong_pitch	Отклонение ноты E4	E4	A5	4.79
4797	86	late	Задержка начала ноты	±500 ms	1496 ms	4.79
4798	86	articulation	Несоответствие длительности ноты	0.02s	0.17s	4.79
4799	86	missing_note	Пропущена нота C#5	C#5	—	4.79
4800	86	missing_note	Пропущена нота G#6	G#6	—	4.84
4801	86	missing_note	Пропущена нота A#4	A#4	—	4.9
4802	86	missing_note	Пропущена нота E4	E4	—	4.91
4803	86	missing_note	Пропущена нота B5	B5	—	4.91
4804	86	missing_note	Пропущена нота B4	B4	—	4.92
4805	86	missing_note	Пропущена нота E4	E4	—	5.05
4806	86	missing_note	Пропущена нота E6	E6	—	5.05
4807	86	missing_note	Пропущена нота A4	A4	—	5.05
4808	86	missing_note	Пропущена нота D4	D4	—	5.09
4809	86	missing_note	Пропущена нота E4	E4	—	5.16
4810	86	missing_note	Пропущена нота B5	B5	—	5.16
4811	86	missing_note	Пропущена нота B4	B4	—	5.17
4812	86	wrong_pitch	Отклонение ноты E4	E4	B5	5.28
4813	86	late	Задержка начала ноты	±500 ms	1449 ms	5.28
4814	86	articulation	Несоответствие длительности ноты	0.03s	0.19s	5.28
4815	86	missing_note	Пропущена нота C#5	C#5	—	5.28
4816	86	missing_note	Пропущена нота C#6	C#6	—	5.28
4817	86	missing_note	Пропущена нота E4	E4	—	5.38
4818	86	missing_note	Пропущена нота D5	D5	—	5.38
4819	86	missing_note	Пропущена нота A6	A6	—	5.41
4820	86	missing_note	Пропущена нота E4	E4	—	5.5
4821	86	missing_note	Пропущена нота E5	E5	—	5.52
4822	86	missing_note	Пропущена нота A4	A4	—	5.64
4823	86	missing_note	Пропущена нота E4	E4	—	5.64
4824	86	missing_note	Пропущена нота D5	D5	—	5.64
4825	86	missing_note	Пропущена нота A6	A6	—	5.66
4826	86	missing_note	Пропущена нота D5	D5	—	5.74
4827	86	missing_note	Пропущена нота C#5	C#5	—	5.77
4828	86	missing_note	Пропущена нота A4	A4	—	5.78
4829	86	missing_note	Пропущена нота E4	E4	—	5.78
4830	86	missing_note	Пропущена нота C#6	C#6	—	5.78
4831	86	missing_note	Пропущена нота G#6	G#6	—	5.85
4832	86	missing_note	Пропущена нота E4	E4	—	5.88
4833	86	missing_note	Пропущена нота B4	B4	—	5.91
4834	86	missing_note	Пропущена нота E6	E6	—	6.02
4835	86	missing_note	Пропущена нота A4	A4	—	6.02
4836	86	missing_note	Пропущена нота E4	E4	—	6.03
4837	86	wrong_pitch	Отклонение ноты D4	D4	B5	6.07
4838	86	late	Задержка начала ноты	±500 ms	1495 ms	6.07
4839	86	articulation	Несоответствие длительности ноты	0.02s	0.15s	6.07
4840	86	missing_note	Пропущена нота E4	E4	—	6.14
4841	86	missing_note	Пропущена нота B4	B4	—	6.14
4842	86	missing_note	Пропущена нота A4	A4	—	6.27
4843	86	missing_note	Пропущена нота C#6	C#6	—	6.27
4844	86	missing_note	Пропущена нота E4	E4	—	6.28
4845	86	missing_note	Пропущена нота C#5	C#5	—	6.28
4846	86	missing_note	Пропущена нота E4	E4	—	6.4
4847	86	missing_note	Пропущена нота D5	D5	—	6.4
4848	86	missing_note	Пропущена нота F#7	F#7	—	6.41
4849	86	wrong_pitch	Отклонение ноты E5	E5	A5	6.51
4850	86	late	Задержка начала ноты	±500 ms	1448 ms	6.51
4851	86	articulation	Несоответствие длительности ноты	0.08s	0.19s	6.51
4852	86	missing_note	Пропущена нота E4	E4	—	6.52
4853	86	missing_note	Пропущена нота E4	E4	—	6.63
4854	86	missing_note	Пропущена нота D5	D5	—	6.63
4855	86	missing_note	Пропущена нота A6	A6	—	6.65
4856	86	missing_note	Пропущена нота E4	E4	—	6.77
4857	86	missing_note	Пропущена нота C#5	C#5	—	6.77
4858	86	missing_note	Пропущена нота C#6	C#6	—	6.77
4859	86	wrong_pitch	Отклонение ноты G#6	G#6	G5	6.81
4860	86	late	Задержка начала ноты	±500 ms	1495 ms	6.81
4861	86	articulation	Несоответствие длительности ноты	0.02s	0.20s	6.81
4862	86	missing_note	Пропущена нота E4	E4	—	6.88
4863	86	missing_note	Пропущена нота B5	B5	—	6.88
4864	86	missing_note	Пропущена нота B4	B4	—	6.9
4865	86	missing_note	Пропущена нота D5	D5	—	6.9
4866	86	missing_note	Пропущена нота B4	B4	—	6.99
4867	86	missing_note	Пропущена нота E6	E6	—	7.01
4868	86	missing_note	Пропущена нота A4	A4	—	7.01
4869	86	missing_note	Пропущена нота E4	E4	—	7.02
4870	86	missing_note	Пропущена нота D4	D4	—	7.06
4871	86	missing_note	Пропущена нота B5	B5	—	7.13
4872	86	missing_note	Пропущена нота E4	E4	—	7.14
4873	86	missing_note	Пропущена нота B4	B4	—	7.15
4874	86	wrong_pitch	Отклонение ноты C#5	C#5	F5	7.26
4875	86	late	Задержка начала ноты	±500 ms	1483 ms	7.26
4876	86	articulation	Несоответствие длительности ноты	0.05s	0.16s	7.26
4877	86	missing_note	Пропущена нота C#6	C#6	—	7.26
4878	86	missing_note	Пропущена нота A#4	A#4	—	7.27
4879	86	missing_note	Пропущена нота E4	E4	—	7.27
4880	86	missing_note	Пропущена нота D5	D5	—	7.37
4881	86	missing_note	Пропущена нота E4	E4	—	7.38
4882	86	missing_note	Пропущена нота A6	A6	—	7.38
4883	86	missing_note	Пропущена нота E6	E6	—	7.51
4884	86	missing_note	Пропущена нота E4	E4	—	7.52
4885	86	missing_note	Пропущена нота E5	E5	—	7.52
4886	86	wrong_pitch	Отклонение ноты D6	D6	E5	7.64
4887	86	late	Задержка начала ноты	±500 ms	1488 ms	7.64
4888	86	articulation	Несоответствие длительности ноты	0.05s	0.21s	7.64
4889	86	missing_note	Пропущена нота E4	E4	—	7.65
4890	86	missing_note	Пропущена нота A6	A6	—	7.65
4891	86	missing_note	Пропущена нота D5	D5	—	7.65
4892	86	missing_note	Пропущена нота E4	E4	—	7.77
4893	86	missing_note	Пропущена нота C#5	C#5	—	7.77
4894	86	missing_note	Пропущена нота C#6	C#6	—	7.77
4895	86	missing_note	Пропущена нота A4	A4	—	7.78
4896	86	missing_note	Пропущена нота G#6	G#6	—	7.8
4897	86	missing_note	Пропущена нота A#4	A#4	—	7.88
4898	86	missing_note	Пропущена нота B5	B5	—	7.88
4899	86	missing_note	Пропущена нота E4	E4	—	7.9
4900	86	missing_note	Пропущена нота B4	B4	—	7.91
4901	86	missing_note	Пропущена нота F4	F4	—	8
4902	86	missing_note	Пропущена нота E6	E6	—	8.01
4903	86	missing_note	Пропущена нота A5	A5	—	8.01
4904	86	missing_note	Пропущена нота E4	E4	—	8.02
4905	86	missing_note	Пропущена нота A4	A4	—	8.02
4906	86	missing_note	Пропущена нота D4	D4	—	8.06
4907	86	missing_note	Пропущена нота F4	F4	—	8.13
4908	86	missing_note	Пропущена нота A#4	A#4	—	8.13
4909	86	missing_note	Пропущена нота B5	B5	—	8.14
4910	86	missing_note	Пропущена нота A4	A4	—	8.15
4911	86	missing_note	Пропущена нота E4	E4	—	8.15
4912	86	missing_note	Пропущена нота B4	B4	—	8.15
4913	86	missing_note	Пропущена нота A4	A4	—	8.27
4914	86	missing_note	Пропущена нота E4	E4	—	8.27
4915	86	missing_note	Пропущена нота C#6	C#6	—	8.27
4916	86	missing_note	Пропущена нота C#5	C#5	—	8.28
4917	86	missing_note	Пропущена нота G#6	G#6	—	8.33
4918	86	missing_note	Пропущена нота D5	D5	—	8.36
4919	86	wrong_pitch	Отклонение ноты E4	E4	C5	8.4
4920	86	late	Задержка начала ноты	±500 ms	1483 ms	8.4
4921	86	articulation	Несоответствие длительности ноты	0.02s	0.19s	8.4
4922	86	missing_note	Пропущена нота A6	A6	—	8.41
4923	86	missing_note	Пропущена нота E4	E4	—	8.52
4924	86	missing_note	Пропущена нота E5	E5	—	8.52
4925	86	missing_note	Пропущена нота D#4	D#4	—	8.63
4926	86	missing_note	Пропущена нота D5	D5	—	8.64
4927	86	missing_note	Пропущена нота E4	E4	—	8.65
4928	86	missing_note	Пропущена нота A6	A6	—	8.65
4929	86	missing_note	Пропущена нота D5	D5	—	8.73
4930	86	wrong_pitch	Отклонение ноты E4	E4	B4	8.77
4931	86	late	Задержка начала ноты	±500 ms	1494 ms	8.77
4932	86	articulation	Несоответствие длительности ноты	0.02s	0.26s	8.77
4933	86	missing_note	Пропущена нота C#5	C#5	—	8.77
4934	86	missing_note	Пропущена нота A4	A4	—	8.78
4935	86	missing_note	Пропущена нота C#6	C#6	—	8.78
4936	86	missing_note	Пропущена нота E4	E4	—	8.87
4937	86	missing_note	Пропущена нота B5	B5	—	8.88
4938	86	missing_note	Пропущена нота B4	B4	—	8.9
4939	86	missing_note	Пропущена нота A4	A4	—	9.02
4940	86	missing_note	Пропущена нота E6	E6	—	9.02
4941	86	missing_note	Пропущена нота E4	E4	—	9.03
4942	86	missing_note	Пропущена нота B5	B5	—	9.14
4943	86	missing_note	Пропущена нота E4	E4	—	9.15
4944	86	missing_note	Пропущена нота B4	B4	—	9.15
4945	86	wrong_pitch	Отклонение ноты D4	D4	A4	9.19
4946	86	late	Задержка начала ноты	±500 ms	1494 ms	9.19
4947	86	articulation	Несоответствие длительности ноты	0.03s	0.14s	9.19
4948	86	missing_note	Пропущена нота E4	E4	—	9.24
4949	86	missing_note	Пропущена нота A4	A4	—	9.24
4950	86	missing_note	Пропущена нота C#6	C#6	—	9.26
4951	86	missing_note	Пропущена нота C#5	C#5	—	9.26
4952	86	missing_note	Пропущена нота G#6	G#6	—	9.28
4953	86	missing_note	Пропущена нота D4	D4	—	9.34
4954	86	missing_note	Пропущена нота D6	D6	—	9.37
4955	86	missing_note	Пропущена нота E4	E4	—	9.38
4956	86	missing_note	Пропущена нота A6	A6	—	9.38
4957	86	missing_note	Пропущена нота D5	D5	—	9.38
4958	86	missing_note	Пропущена нота D4	D4	—	9.42
4959	86	missing_note	Пропущена нота E4	E4	—	9.51
4960	86	missing_note	Пропущена нота E5	E5	—	9.51
4961	86	late	Задержка начала ноты	±500 ms	1476 ms	9.62
4962	86	articulation	Несоответствие длительности ноты	0.01s	0.20s	9.62
4963	86	missing_note	Пропущена нота A6	A6	—	9.63
4964	86	missing_note	Пропущена нота D5	D5	—	9.63
4965	86	missing_note	Пропущена нота E4	E4	—	9.64
4966	86	missing_note	Пропущена нота D5	D5	—	9.73
4967	86	missing_note	Пропущена нота A4	A4	—	9.76
4968	86	missing_note	Пропущена нота C#5	C#5	—	9.76
4969	86	missing_note	Пропущена нота C#6	C#6	—	9.76
4970	86	missing_note	Пропущена нота E4	E4	—	9.77
4971	86	missing_note	Пропущена нота G#6	G#6	—	9.79
4972	86	missing_note	Пропущена нота D5	D5	—	9.85
4973	86	missing_note	Пропущена нота A#4	A#4	—	9.87
4974	86	missing_note	Пропущена нота E4	E4	—	9.87
4975	86	missing_note	Пропущена нота B5	B5	—	9.87
4976	86	missing_note	Пропущена нота B4	B4	—	9.9
4977	86	missing_note	Пропущена нота D4	D4	—	9.93
4978	86	late	Задержка начала ноты	±500 ms	1493 ms	10
4979	86	articulation	Несоответствие длительности ноты	0.03s	0.20s	10
4980	86	missing_note	Пропущена нота A5	A5	—	10
4981	86	missing_note	Пропущена нота A4	A4	—	10.01
4982	86	missing_note	Пропущена нота E6	E6	—	10.01
4983	86	missing_note	Пропущена нота D4	D4	—	10.06
4984	86	missing_note	Пропущена нота B5	B5	—	10.12
4985	86	missing_note	Пропущена нота E4	E4	—	10.13
4986	86	missing_note	Пропущена нота B4	B4	—	10.14
4987	86	missing_note	Пропущена нота D4	D4	—	10.16
4988	86	missing_note	Пропущена нота C5	C5	—	10.19
4989	86	missing_note	Пропущена нота B4	B4	—	10.22
4990	86	missing_note	Пропущена нота A4	A4	—	10.26
4991	86	missing_note	Пропущена нота C#6	C#6	—	10.26
4992	86	missing_note	Пропущена нота C#5	C#5	—	10.27
4993	86	missing_note	Пропущена нота E4	E4	—	10.27
4994	86	missing_note	Пропущена нота D4	D4	—	10.3
4995	86	missing_note	Пропущена нота D5	D5	—	10.31
4996	86	missing_note	Пропущена нота E4	E4	—	10.38
4997	86	missing_note	Пропущена нота A6	A6	—	10.38
4998	86	wrong_pitch	Отклонение ноты E5	E5	E4	10.49
4999	86	late	Задержка начала ноты	±500 ms	1470 ms	10.49
5000	86	articulation	Несоответствие длительности ноты	0.06s	0.15s	10.49
5001	86	missing_note	Пропущена нота E4	E4	—	10.5
5002	86	missing_note	Пропущена нота B6	B6	—	10.51
5003	86	missing_note	Пропущена нота E4	E4	—	10.62
5004	86	missing_note	Пропущена нота D5	D5	—	10.62
5005	86	missing_note	Пропущена нота A6	A6	—	10.63
5006	86	missing_note	Пропущена нота F4	F4	—	10.73
5007	86	missing_note	Пропущена нота A4	A4	—	10.74
5008	86	missing_note	Пропущена нота C#6	C#6	—	10.74
5009	86	missing_note	Пропущена нота C#5	C#5	—	10.74
5010	86	missing_note	Пропущена нота E4	E4	—	10.76
5011	86	missing_note	Пропущена нота G#6	G#6	—	10.78
5012	86	wrong_pitch	Отклонение ноты B5	B5	D4	10.86
5013	86	late	Задержка начала ноты	±500 ms	1469 ms	10.86
5014	86	articulation	Несоответствие длительности ноты	0.08s	0.21s	10.86
5015	86	missing_note	Пропущена нота E4	E4	—	10.87
5016	86	missing_note	Пропущена нота B4	B4	—	10.87
5017	86	missing_note	Пропущена нота E6	E6	—	10.99
5018	86	missing_note	Пропущена нота A5	A5	—	10.99
5019	86	missing_note	Пропущена нота E4	E4	—	11
5020	86	missing_note	Пропущена нота A4	A4	—	11
5021	86	missing_note	Пропущена нота D4	D4	—	11.07
5022	86	missing_note	Пропущена нота E4	E4	—	11.09
5023	86	missing_note	Пропущена нота B5	B5	—	11.1
5024	86	missing_note	Пропущена нота B4	B4	—	11.13
5025	86	missing_note	Пропущена нота D4	D4	—	11.16
5026	86	missing_note	Пропущена нота B4	B4	—	11.21
5027	86	missing_note	Пропущена нота E4	E4	—	11.24
5028	86	missing_note	Пропущена нота C#6	C#6	—	11.24
5029	86	missing_note	Пропущена нота C#5	C#5	—	11.24
5030	86	missing_note	Пропущена нота G#6	G#6	—	11.26
5031	86	late	Задержка начала ноты	±500 ms	1487 ms	11.29
5032	86	articulation	Несоответствие длительности ноты	0.04s	0.42s	11.29
5033	86	missing_note	Пропущена нота A4	A4	—	11.36
5034	86	missing_note	Пропущена нота D6	D6	—	11.36
5035	86	missing_note	Пропущена нота E4	E4	—	11.37
5036	86	missing_note	Пропущена нота D5	D5	—	11.37
5037	86	missing_note	Пропущена нота A6	A6	—	11.38
5038	86	missing_note	Пропущена нота E4	E4	—	11.48
5039	86	missing_note	Пропущена нота E5	E5	—	11.49
5040	86	missing_note	Пропущена нота E4	E4	—	11.6
5041	86	missing_note	Пропущена нота D5	D5	—	11.6
5042	86	missing_note	Пропущена нота A6	A6	—	11.62
5043	86	missing_note	Пропущена нота D5	D5	—	11.7
5044	86	missing_note	Пропущена нота C#5	C#5	—	11.74
5045	86	missing_note	Пропущена нота C#6	C#6	—	11.74
5046	86	missing_note	Пропущена нота A4	A4	—	11.76
5047	86	missing_note	Пропущена нота E4	E4	—	11.76
5048	86	missing_note	Пропущена нота G#6	G#6	—	11.78
5049	86	missing_note	Пропущена нота D5	D5	—	11.84
5050	86	missing_note	Пропущена нота A#4	A#4	—	11.85
5051	86	missing_note	Пропущена нота B5	B5	—	11.85
5052	86	missing_note	Пропущена нота E4	E4	—	11.86
5053	86	missing_note	Пропущена нота B4	B4	—	11.87
5054	86	missing_note	Пропущена нота A5	A5	—	11.98
5055	86	missing_note	Пропущена нота E4	E4	—	11.99
5056	86	missing_note	Пропущена нота E6	E6	—	11.99
5057	86	missing_note	Пропущена нота A4	A4	—	11.99
5058	86	missing_note	Пропущена нота D4	D4	—	12.03
5059	86	missing_note	Пропущена нота E4	E4	—	12.09
5060	86	missing_note	Пропущена нота B5	B5	—	12.09
5061	86	missing_note	Пропущена нота B4	B4	—	12.12
5062	86	missing_note	Пропущена нота F#6	F#6	—	12.15
5063	86	missing_note	Пропущена нота C#5	C#5	—	12.22
5064	86	missing_note	Пропущена нота A4	A4	—	12.23
5065	86	missing_note	Пропущена нота E4	E4	—	12.23
5066	86	missing_note	Пропущена нота C#6	C#6	—	12.23
5067	86	missing_note	Пропущена нота G#6	G#6	—	12.26
5068	86	missing_note	Пропущена нота A4	A4	—	12.34
5069	86	missing_note	Пропущена нота E4	E4	—	12.34
5070	86	missing_note	Пропущена нота D5	D5	—	12.34
5071	86	missing_note	Пропущена нота A6	A6	—	12.36
5072	86	wrong_pitch	Отклонение ноты E5	E5	C4	12.47
5073	86	late	Задержка начала ноты	±500 ms	1481 ms	12.47
5074	86	articulation	Несоответствие длительности ноты	0.06s	0.16s	12.47
5075	86	missing_note	Пропущена нота E4	E4	—	12.48
5076	86	missing_note	Пропущена нота B6	B6	—	12.51
5077	86	missing_note	Пропущена нота A4	A4	—	12.58
5078	86	missing_note	Пропущена нота D6	D6	—	12.58
5079	86	missing_note	Пропущена нота E4	E4	—	12.59
5080	86	missing_note	Пропущена нота D5	D5	—	12.59
5081	86	missing_note	Пропущена нота A6	A6	—	12.6
5082	86	missing_note	Пропущена нота D4	D4	—	12.63
5083	86	missing_note	Пропущена нота A4	A4	—	12.71
5084	86	missing_note	Пропущена нота C#6	C#6	—	12.71
5085	86	missing_note	Пропущена нота C#5	C#5	—	12.71
5086	86	missing_note	Пропущена нота E4	E4	—	12.72
5087	86	missing_note	Пропущена нота G#6	G#6	—	12.74
5088	86	missing_note	Пропущена нота E4	E4	—	12.84
5089	86	missing_note	Пропущена нота B5	B5	—	12.84
5090	86	missing_note	Пропущена нота B4	B4	—	12.85
5091	86	missing_note	Пропущена нота A5	A5	—	12.95
5092	86	missing_note	Пропущена нота E4	E4	—	12.97
5093	86	missing_note	Пропущена нота A4	A4	—	12.97
5094	86	missing_note	Пропущена нота E6	E6	—	12.97
5095	86	missing_note	Пропущена нота D4	D4	—	13.01
5096	86	missing_note	Пропущена нота A#4	A#4	—	13.08
5097	86	missing_note	Пропущена нота B5	B5	—	13.08
5098	86	missing_note	Пропущена нота E4	E4	—	13.09
5099	86	missing_note	Пропущена нота B4	B4	—	13.1
5100	86	missing_note	Пропущена нота A5	A5	—	13.13
5101	86	missing_note	Пропущена нота D4	D4	—	13.14
5102	86	missing_note	Пропущена нота B4	B4	—	13.19
5103	86	missing_note	Пропущена нота A4	A4	—	13.21
5104	86	missing_note	Пропущена нота C#6	C#6	—	13.21
5105	86	missing_note	Пропущена нота E4	E4	—	13.22
5106	86	missing_note	Пропущена нота C#5	C#5	—	13.22
5107	86	missing_note	Пропущена нота B5	B5	—	13.23
5108	86	missing_note	Пропущена нота E4	E4	—	13.34
5109	86	missing_note	Пропущена нота D6	D6	—	13.34
5110	86	missing_note	Пропущена нота D5	D5	—	13.35
5111	86	missing_note	Пропущена нота A6	A6	—	13.35
5112	86	missing_note	Пропущена нота D5	D5	—	13.43
5113	86	missing_note	Пропущена нота E5	E5	—	13.47
5114	86	missing_note	Пропущена нота E4	E4	—	13.48
5115	86	missing_note	Пропущена нота E4	E4	—	13.58
5116	86	missing_note	Пропущена нота D5	D5	—	13.58
5117	86	missing_note	Пропущена нота A4	A4	—	13.71
5118	86	missing_note	Пропущена нота C#6	C#6	—	13.71
5119	86	missing_note	Пропущена нота E4	E4	—	13.72
5120	86	missing_note	Пропущена нота C#5	C#5	—	13.72
5121	86	missing_note	Пропущена нота D4	D4	—	13.76
5122	86	missing_note	Пропущена нота G#6	G#6	—	13.77
5123	86	missing_note	Пропущена нота D5	D5	—	13.81
5124	86	missing_note	Пропущена нота E4	E4	—	13.83
5125	86	missing_note	Пропущена нота B5	B5	—	13.83
5126	86	missing_note	Пропущена нота B4	B4	—	13.85
5127	86	missing_note	Пропущена нота D4	D4	—	13.88
5128	86	missing_note	Пропущена нота A5	A5	—	13.95
5129	86	missing_note	Пропущена нота E4	E4	—	13.97
5130	86	missing_note	Пропущена нота A4	A4	—	13.97
5131	86	missing_note	Пропущена нота E6	E6	—	13.97
5132	86	missing_note	Пропущена нота D4	D4	—	14.01
5133	86	missing_note	Пропущена нота B5	B5	—	14.08
5134	86	missing_note	Пропущена нота E4	E4	—	14.09
5135	86	missing_note	Пропущена нота A4	A4	—	14.09
5136	86	missing_note	Пропущена нота B4	B4	—	14.09
5137	86	missing_note	Пропущена нота F4	F4	—	14.2
5138	86	missing_note	Пропущена нота A4	A4	—	14.21
5139	86	missing_note	Пропущена нота C#5	C#5	—	14.21
5140	86	missing_note	Пропущена нота C#6	C#6	—	14.21
5141	86	missing_note	Пропущена нота E4	E4	—	14.22
5142	86	missing_note	Пропущена нота G#6	G#6	—	14.22
5143	86	missing_note	Пропущена нота D5	D5	—	14.27
5144	86	missing_note	Пропущена нота E4	E4	—	14.35
5145	86	missing_note	Пропущена нота A6	A6	—	14.35
5146	86	missing_note	Пропущена нота D4	D4	—	14.42
5147	86	missing_note	Пропущена нота E5	E5	—	14.47
5148	86	missing_note	Пропущена нота B6	B6	—	14.48
5149	86	missing_note	Пропущена нота E4	E4	—	14.48
5150	86	missing_note	Пропущена нота D5	D5	—	14.58
5151	86	missing_note	Пропущена нота E4	E4	—	14.59
5152	86	missing_note	Пропущена нота A6	A6	—	14.59
5153	86	missing_note	Пропущена нота C#6	C#6	—	14.71
5154	86	missing_note	Пропущена нота A4	A4	—	14.72
5155	86	missing_note	Пропущена нота E4	E4	—	14.72
5156	86	missing_note	Пропущена нота C#5	C#5	—	14.72
5157	86	missing_note	Пропущена нота G#6	G#6	—	14.77
5158	86	missing_note	Пропущена нота E4	E4	—	14.85
5159	86	missing_note	Пропущена нота B5	B5	—	14.86
5160	86	missing_note	Пропущена нота B4	B4	—	14.87
5161	86	missing_note	Пропущена нота D5	D5	—	14.92
5162	86	missing_note	Пропущена нота A5	A5	—	15
5163	86	missing_note	Пропущена нота E4	E4	—	15.01
5164	86	missing_note	Пропущена нота E6	E6	—	15.01
5165	86	missing_note	Пропущена нота A4	A4	—	15.01
3644	84	wrong_pitch	Отклонение ноты B5	B5	F4	0
3645	84	late	Задержка начала ноты	±500 ms	533 ms	0.14
3646	84	wrong_pitch	Отклонение ноты C6	C6	G#4	0.15
3647	84	late	Задержка начала ноты	±500 ms	577 ms	0.22
3648	84	articulation	Несоответствие длительности ноты	0.03s	0.16s	0.22
3649	84	late	Задержка начала ноты	±500 ms	724 ms	0.24
3650	84	articulation	Несоответствие длительности ноты	0.04s	0.27s	0.24
3651	84	wrong_pitch	Отклонение ноты G5	G5	B4	0.27
3652	84	late	Задержка начала ноты	±500 ms	1139 ms	0.27
3653	84	wrong_pitch	Отклонение ноты G4	G4	E4	0.28
3654	84	late	Задержка начала ноты	±500 ms	950 ms	0.28
3655	84	wrong_pitch	Отклонение ноты D#4	D#4	B4	0.29
3656	84	late	Задержка начала ноты	±500 ms	1355 ms	0.29
3657	84	articulation	Несоответствие длительности ноты	0.04s	0.17s	0.29
3658	84	missing_note	Пропущена нота D6	D6	—	0.29
3659	84	late	Задержка начала ноты	±500 ms	1471 ms	0.36
3660	84	articulation	Несоответствие длительности ноты	0.04s	0.24s	0.36
3661	84	missing_note	Пропущена нота G#4	G#4	—	0.4
3662	84	missing_note	Пропущена нота G#5	G#5	—	0.4
3663	84	missing_note	Пропущена нота D#6	D#6	—	0.41
3664	84	missing_note	Пропущена нота D#4	D#4	—	0.42
3665	84	missing_note	Пропущена нота G4	G4	—	0.47
3666	84	missing_note	Пропущена нота G4	G4	—	0.52
3667	84	missing_note	Пропущена нота D6	D6	—	0.53
3668	84	missing_note	Пропущена нота D#4	D#4	—	0.55
3669	84	late	Задержка начала ноты	±500 ms	1427 ms	0.62
3670	84	articulation	Несоответствие длительности ноты	0.03s	0.14s	0.62
3671	84	missing_note	Пропущена нота F5	F5	—	0.64
3672	84	missing_note	Пропущена нота C6	C6	—	0.65
3673	84	missing_note	Пропущена нота F4	F4	—	0.65
3674	84	wrong_pitch	Отклонение ноты D#4	D#4	D#5	0.76
3675	84	late	Задержка начала ноты	±500 ms	1461 ms	0.76
3676	84	articulation	Несоответствие длительности ноты	0.03s	0.24s	0.76
3677	84	missing_note	Пропущена нота B5	B5	—	0.77
3678	84	missing_note	Пропущена нота E5	E5	—	0.77
3679	84	missing_note	Пропущена нота E4	E4	—	0.78
3680	84	wrong_pitch	Отклонение ноты D#4	D#4	D#5	1.06
3681	84	late	Задержка начала ноты	±500 ms	1350 ms	1.06
3682	84	articulation	Несоответствие длительности ноты	0.03s	0.20s	1.06
3683	84	missing_note	Пропущена нота B5	B5	—	1.07
3684	84	missing_note	Пропущена нота E4	E4	—	1.08
3685	84	missing_note	Пропущена нота E4	E4	—	1.13
3686	84	missing_note	Пропущена нота D#4	D#4	—	1.17
3687	84	missing_note	Пропущена нота A#4	A#4	—	1.17
3688	84	missing_note	Пропущена нота F#4	F#4	—	1.19
3689	84	wrong_pitch	Отклонение ноты E4	E4	D5	1.45
3690	84	late	Задержка начала ноты	±500 ms	1189 ms	1.45
3691	84	articulation	Несоответствие длительности ноты	0.04s	0.17s	1.45
3692	84	wrong_pitch	Отклонение ноты D#4	D#4	D5	1.49
3693	84	late	Задержка начала ноты	±500 ms	1322 ms	1.49
3694	84	articulation	Несоответствие длительности ноты	0.04s	0.20s	1.49
3695	84	wrong_pitch	Отклонение ноты A4	A4	D5	1.57
3696	84	late	Задержка начала ноты	±500 ms	1424 ms	1.57
3697	84	articulation	Несоответствие длительности ноты	0.03s	0.18s	1.57
3698	84	missing_note	Пропущена нота A5	A5	—	1.59
3699	84	missing_note	Пропущена нота A#4	A#4	—	1.59
3700	84	missing_note	Пропущена нота G5	G5	—	1.59
3701	84	missing_note	Пропущена нота E4	E4	—	1.6
3702	84	missing_note	Пропущена нота D6	D6	—	1.6
3703	84	missing_note	Пропущена нота G4	G4	—	1.6
3704	84	missing_note	Пропущена нота B6	B6	—	1.62
3705	84	missing_note	Пропущена нота D#4	D#4	—	1.63
3706	84	wrong_pitch	Отклонение ноты D#4	D#4	D5	1.87
3707	84	late	Задержка начала ноты	±500 ms	1246 ms	1.87
3708	84	articulation	Несоответствие длительности ноты	0.04s	0.17s	1.87
3709	84	wrong_pitch	Отклонение ноты G4	G4	D5	1.91
3710	84	late	Задержка начала ноты	±500 ms	1379 ms	1.91
3711	84	articulation	Несоответствие длительности ноты	0.05s	0.28s	1.91
3712	84	missing_note	Пропущена нота E4	E4	—	2.02
3713	84	missing_note	Пропущена нота D5	D5	—	2.03
3714	84	wrong_pitch	Отклонение ноты A#4	A#4	D5	2.29
3715	84	late	Задержка начала ноты	±500 ms	1208 ms	2.29
3716	84	articulation	Несоответствие длительности ноты	0.04s	0.19s	2.29
3717	84	late	Задержка начала ноты	±500 ms	1405 ms	2.29
3718	84	missing_note	Пропущена нота E4	E4	—	2.3
3719	84	wrong_pitch	Отклонение ноты C#5	C#5	F#5	2.43
3720	84	late	Задержка начала ноты	±500 ms	1428 ms	2.43
3721	84	missing_note	Пропущена нота A#4	A#4	—	2.44
3722	84	missing_note	Пропущена нота D#5	D#5	—	2.45
3723	84	missing_note	Пропущена нота G#6	G#6	—	2.45
3724	84	missing_note	Пропущена нота D#4	D#4	—	2.47
3725	84	missing_note	Пропущена нота A4	A4	—	2.52
3726	84	missing_note	Пропущена нота D#5	D#5	—	2.55
3727	84	missing_note	Пропущена нота D#4	D#4	—	2.56
3728	84	missing_note	Пропущена нота G#6	G#6	—	2.56
3729	84	missing_note	Пропущена нота A#4	A#4	—	2.6
3730	84	missing_note	Пропущена нота E4	E4	—	2.62
3731	84	missing_note	Пропущена нота D#5	D#5	—	2.63
3732	84	missing_note	Пропущена нота A4	A4	—	2.64
3733	84	missing_note	Пропущена нота D#4	D#4	—	2.65
3734	84	missing_note	Пропущена нота D#5	D#5	—	2.7
3735	84	missing_note	Пропущена нота E4	E4	—	2.71
3736	84	missing_note	Пропущена нота E4	E4	—	2.78
3737	84	missing_note	Пропущена нота D#5	D#5	—	2.78
3738	84	missing_note	Пропущена нота A#4	A#4	—	2.83
3739	84	missing_note	Пропущена нота E4	E4	—	2.84
3740	84	missing_note	Пропущена нота D#4	D#4	—	2.86
3741	84	wrong_pitch	Отклонение ноты E4	E4	B4	3.02
3742	84	late	Задержка начала ноты	±500 ms	1395 ms	3.02
3743	84	articulation	Несоответствие длительности ноты	0.03s	0.14s	3.02
3744	84	missing_note	Пропущена нота D#5	D#5	—	3.02
3745	84	missing_note	Пропущена нота G#6	G#6	—	3.02
3746	84	missing_note	Пропущена нота D#5	D#5	—	3.13
3747	84	wrong_pitch	Отклонение ноты C#5	C#5	A4	3.15
3748	84	late	Задержка начала ноты	±500 ms	1477 ms	3.15
3749	84	articulation	Несоответствие длительности ноты	0.03s	0.14s	3.15
3750	84	missing_note	Пропущена нота D#4	D#4	—	3.16
3751	84	missing_note	Пропущена нота A#6	A#6	—	3.16
3752	84	missing_note	Пропущена нота E4	E4	—	3.27
3753	84	missing_note	Пропущена нота E5	E5	—	3.27
3754	84	wrong_pitch	Отклонение ноты D#5	D#5	G4	3.36
3755	84	late	Задержка начала ноты	±500 ms	1489 ms	3.36
3756	84	missing_note	Пропущена нота D#4	D#4	—	3.4
3757	84	missing_note	Пропущена нота A#6	A#6	—	3.4
3758	84	missing_note	Пропущена нота A#4	A#4	—	3.49
3759	84	missing_note	Пропущена нота C#5	C#5	—	3.49
3760	84	missing_note	Пропущена нота G#6	G#6	—	3.5
3761	84	missing_note	Пропущена нота D#4	D#4	—	3.51
3762	84	wrong_pitch	Отклонение ноты C#5	C#5	G4	3.58
3763	84	late	Задержка начала ноты	±500 ms	1485 ms	3.58
3764	84	articulation	Несоответствие длительности ноты	0.05s	0.15s	3.58
3765	84	missing_note	Пропущена нота A#4	A#4	—	3.62
3766	84	missing_note	Пропущена нота E4	E4	—	3.63
3767	84	missing_note	Пропущена нота B5	B5	—	3.63
3768	84	late	Задержка начала ноты	±500 ms	1478 ms	3.76
3769	84	articulation	Несоответствие длительности ноты	0.15s	0.42s	3.76
3770	84	missing_note	Пропущена нота E4	E4	—	3.77
3771	84	missing_note	Пропущена нота D#4	D#4	—	3.79
3772	84	missing_note	Пропущена нота F4	F4	—	3.86
3773	84	missing_note	Пропущена нота G#4	G#4	—	3.87
3774	84	missing_note	Пропущена нота D#4	D#4	—	3.9
3775	84	missing_note	Пропущена нота A4	A4	—	3.97
3776	84	missing_note	Пропущена нота G5	G5	—	4.01
3777	84	missing_note	Пропущена нота E4	E4	—	4.02
3778	84	missing_note	Пропущена нота D6	D6	—	4.02
3779	84	missing_note	Пропущена нота G4	G4	—	4.02
3780	84	missing_note	Пропущена нота D#4	D#4	—	4.05
3781	84	wrong_pitch	Отклонение ноты E4	E4	A#4	4.29
3782	84	late	Задержка начала ноты	±500 ms	1328 ms	4.29
3783	84	articulation	Несоответствие длительности ноты	0.03s	0.26s	4.29
3784	84	missing_note	Пропущена нота D#4	D#4	—	4.31
3785	84	late	Задержка начала ноты	±500 ms	1447 ms	4.41
3786	84	articulation	Несоответствие длительности ноты	0.05s	0.16s	4.41
3787	84	missing_note	Пропущена нота C6	C6	—	4.41
3788	84	missing_note	Пропущена нота E4	E4	—	4.42
3789	84	missing_note	Пропущена нота C5	C5	—	4.43
3790	84	missing_note	Пропущена нота E7	E7	—	4.45
3791	84	wrong_pitch	Отклонение ноты C5	C5	E4	4.66
3792	84	late	Задержка начала ноты	±500 ms	1333 ms	4.66
3793	84	missing_note	Пропущена нота E4	E4	—	4.69
3794	84	missing_note	Пропущена нота D#5	D#5	—	4.69
3795	84	missing_note	Пропущена нота C6	C6	—	4.69
3796	84	missing_note	Пропущена нота E7	E7	—	4.71
3797	84	missing_note	Пропущена нота D#4	D#4	—	4.72
3798	84	missing_note	Пропущена нота G6	G6	—	4.72
3799	84	wrong_pitch	Отклонение ноты B4	B4	E4	4.79
3800	84	late	Задержка начала ноты	±500 ms	1427 ms	4.79
3801	84	articulation	Несоответствие длительности ноты	0.04s	0.20s	4.79
3802	84	missing_note	Пропущена нота A#4	A#4	—	4.81
3803	84	missing_note	Пропущена нота E4	E4	—	4.81
3804	84	missing_note	Пропущена нота D#5	D#5	—	4.81
3805	84	missing_note	Пропущена нота B5	B5	—	4.81
3806	84	missing_note	Пропущена нота F#6	F#6	—	4.84
3807	84	missing_note	Пропущена нота B4	B4	—	4.84
3808	84	missing_note	Пропущена нота D#4	D#4	—	4.85
3809	84	wrong_pitch	Отклонение ноты F4	F4	A4	5.08
3810	84	late	Задержка начала ноты	±500 ms	1343 ms	5.08
3811	84	articulation	Несоответствие длительности ноты	0.03s	0.20s	5.08
3812	84	missing_note	Пропущена нота A#4	A#4	—	5.09
3813	84	missing_note	Пропущена нота D#5	D#5	—	5.09
3814	84	missing_note	Пропущена нота F#6	F#6	—	5.1
3815	84	missing_note	Пропущена нота B4	B4	—	5.1
3816	84	missing_note	Пропущена нота D#4	D#4	—	5.12
3817	84	wrong_pitch	Отклонение ноты E4	E4	A4	5.24
3818	84	late	Задержка начала ноты	±500 ms	1350 ms	5.24
3819	84	articulation	Несоответствие длительности ноты	0.05s	0.20s	5.24
3820	84	missing_note	Пропущена нота G#6	G#6	—	5.26
3821	84	wrong_pitch	Отклонение ноты F4	F4	A4	5.29
3822	84	late	Задержка начала ноты	±500 ms	1493 ms	5.29
3823	84	articulation	Несоответствие длительности ноты	0.01s	0.21s	5.29
3824	84	missing_note	Пропущена нота E4	E4	—	5.3
3825	84	wrong_pitch	Отклонение ноты E4	E4	A#4	5.5
3826	84	late	Задержка начала ноты	±500 ms	1456 ms	5.5
3827	84	missing_note	Пропущена нота G#6	G#6	—	5.53
3828	84	missing_note	Пропущена нота A#4	A#4	—	5.62
3829	84	wrong_pitch	Отклонение ноты E4	E4	G4	5.66
3830	84	late	Задержка начала ноты	±500 ms	1498 ms	5.66
3908	84	missing_note	Пропущена нота A#4	A#4	—	7.56
3831	84	articulation	Несоответствие длительности ноты	0.03s	0.17s	5.66
3832	84	missing_note	Пропущена нота F#4	F#4	—	5.66
3833	84	missing_note	Пропущена нота B4	B4	—	5.74
3834	84	missing_note	Пропущена нота E4	E4	—	5.74
3835	84	missing_note	Пропущена нота A#4	A#4	—	5.76
3836	84	missing_note	Пропущена нота D#4	D#4	—	5.77
3837	84	wrong_pitch	Отклонение ноты A4	A4	E4	5.84
3838	84	late	Задержка начала ноты	±500 ms	1479 ms	5.84
3839	84	articulation	Несоответствие длительности ноты	0.01s	0.16s	5.84
3840	84	missing_note	Пропущена нота B4	B4	—	5.84
3841	84	missing_note	Пропущена нота F#4	F#4	—	5.85
3842	84	missing_note	Пропущена нота A#4	A#4	—	5.85
3843	84	missing_note	Пропущена нота D#4	D#4	—	5.86
3844	84	missing_note	Пропущена нота E4	E4	—	5.91
3845	84	missing_note	Пропущена нота D#4	D#4	—	5.94
3846	84	missing_note	Пропущена нота E4	E4	—	5.99
3847	84	missing_note	Пропущена нота A#4	A#4	—	6
3848	84	missing_note	Пропущена нота D#4	D#4	—	6.01
3849	84	missing_note	Пропущена нота F#4	F#4	—	6.01
3850	84	wrong_pitch	Отклонение ноты E4	E4	C#5	6.14
3851	84	late	Задержка начала ноты	±500 ms	1369 ms	6.14
3852	84	articulation	Несоответствие длительности ноты	0.04s	0.19s	6.14
3853	84	wrong_pitch	Отклонение ноты E4	E4	A4	6.24
3854	84	late	Задержка начала ноты	±500 ms	1467 ms	6.24
3855	84	articulation	Несоответствие длительности ноты	0.03s	0.20s	6.24
3856	84	missing_note	Пропущена нота A#4	A#4	—	6.26
3857	84	late	Задержка начала ноты	±500 ms	1450 ms	6.41
3858	84	articulation	Несоответствие длительности ноты	0.03s	0.20s	6.41
3859	84	missing_note	Пропущена нота D#4	D#4	—	6.43
3860	84	missing_note	Пропущена нота A4	A4	—	6.51
3861	84	wrong_pitch	Отклонение ноты G5	G5	A4	6.53
3862	84	late	Задержка начала ноты	±500 ms	1486 ms	6.53
3863	84	missing_note	Пропущена нота G4	G4	—	6.55
3864	84	missing_note	Пропущена нота D6	D6	—	6.56
3865	84	missing_note	Пропущена нота D#4	D#4	—	6.57
3866	84	missing_note	Пропущена нота E4	E4	—	6.65
3867	84	missing_note	Пропущена нота B5	B5	—	6.66
3868	84	missing_note	Пропущена нота E4	E4	—	6.72
3869	84	missing_note	Пропущена нота A#4	A#4	—	6.78
3870	84	missing_note	Пропущена нота C#5	C#5	—	6.78
3871	84	missing_note	Пропущена нота E4	E4	—	6.79
3872	84	missing_note	Пропущена нота D#5	D#5	—	6.79
3873	84	late	Задержка начала ноты	±500 ms	1474 ms	6.81
3874	84	articulation	Несоответствие длительности ноты	0.04s	0.17s	6.81
3875	84	missing_note	Пропущена нота A#5	A#5	—	6.92
3876	84	wrong_pitch	Отклонение ноты E4	E4	C#5	6.93
3877	84	late	Задержка начала ноты	±500 ms	1489 ms	6.93
3878	84	articulation	Несоответствие длительности ноты	0.03s	0.14s	6.93
3879	84	missing_note	Пропущена нота A#4	A#4	—	6.93
3880	84	missing_note	Пропущена нота D#4	D#4	—	6.95
3881	84	missing_note	Пропущена нота E5	E5	—	7.05
3882	84	missing_note	Пропущена нота B5	B5	—	7.06
3883	84	missing_note	Пропущена нота E4	E4	—	7.06
3884	84	missing_note	Пропущена нота D#4	D#4	—	7.15
3885	84	missing_note	Пропущена нота F#4	F#4	—	7.16
3886	84	missing_note	Пропущена нота A#4	A#4	—	7.16
3887	84	wrong_pitch	Отклонение ноты A4	A4	E4	7.27
3888	84	late	Задержка начала ноты	±500 ms	1419 ms	7.27
3889	84	articulation	Несоответствие длительности ноты	0.04s	0.27s	7.27
3890	84	missing_note	Пропущена нота F#4	F#4	—	7.3
3891	84	missing_note	Пропущена нота G5	G5	—	7.31
3892	84	missing_note	Пропущена нота G4	G4	—	7.33
3893	84	missing_note	Пропущена нота D6	D6	—	7.33
3894	84	missing_note	Пропущена нота D#4	D#4	—	7.34
3895	84	missing_note	Пропущена нота E4	E4	—	7.37
3896	84	missing_note	Пропущена нота D#4	D#4	—	7.41
3897	84	missing_note	Пропущена нота G4	G4	—	7.41
3898	84	late	Задержка начала ноты	±500 ms	1495 ms	7.43
3899	84	articulation	Несоответствие длительности ноты	0.05s	0.30s	7.43
3900	84	missing_note	Пропущена нота B5	B5	—	7.43
3901	84	missing_note	Пропущена нота G#6	G#6	—	7.44
3902	84	wrong_pitch	Отклонение ноты D#5	D#5	C5	7.49
3903	84	late	Задержка начала ноты	±500 ms	1462 ms	7.49
3904	84	articulation	Несоответствие длительности ноты	0.03s	0.26s	7.49
3905	84	missing_note	Пропущена нота E4	E4	—	7.49
3906	84	missing_note	Пропущена нота D#4	D#4	—	7.53
3907	84	missing_note	Пропущена нота C#5	C#5	—	7.55
3909	84	missing_note	Пропущена нота F#4	F#4	—	7.56
3910	84	missing_note	Пропущена нота G#6	G#6	—	7.58
3911	84	late	Задержка начала ноты	±500 ms	1499 ms	7.67
3912	84	late	Задержка начала ноты	±500 ms	1497 ms	7.69
3913	84	articulation	Несоответствие длительности ноты	0.03s	0.19s	7.69
3914	84	missing_note	Пропущена нота D#4	D#4	—	7.71
3915	84	missing_note	Пропущена нота E5	E5	—	7.8
3916	84	missing_note	Пропущена нота E4	E4	—	7.81
3917	84	missing_note	Пропущена нота B5	B5	—	7.81
3918	84	missing_note	Пропущена нота G#6	G#6	—	7.83
3919	84	wrong_pitch	Отклонение ноты D#4	D#4	G5	7.93
3920	84	late	Задержка начала ноты	±500 ms	1444 ms	7.93
3921	84	articulation	Несоответствие длительности ноты	0.01s	0.24s	7.93
3922	84	missing_note	Пропущена нота E4	E4	—	7.94
3923	84	missing_note	Пропущена нота G#6	G#6	—	7.94
3924	84	missing_note	Пропущена нота A#4	A#4	—	7.95
3925	84	missing_note	Пропущена нота C#5	C#5	—	7.95
3926	84	missing_note	Пропущена нота F7	F7	—	8.01
3927	84	wrong_pitch	Отклонение ноты E4	E4	G5	8.12
3928	84	late	Задержка начала ноты	±500 ms	1469 ms	8.12
3929	84	missing_note	Пропущена нота F#4	F#4	—	8.23
3930	84	missing_note	Пропущена нота A#4	A#4	—	8.23
3931	84	missing_note	Пропущена нота E4	E4	—	8.27
3932	84	missing_note	Пропущена нота G#6	G#6	—	8.27
3933	84	wrong_pitch	Отклонение ноты F7	F7	E5	8.29
3934	84	late	Задержка начала ноты	±500 ms	1474 ms	8.29
3935	84	articulation	Несоответствие длительности ноты	0.10s	0.23s	8.29
3936	84	wrong_pitch	Отклонение ноты A#5	A#5	C5	8.37
3937	84	late	Задержка начала ноты	±500 ms	1390 ms	8.37
3938	84	wrong_pitch	Отклонение ноты A#4	A#4	E4	8.38
3939	84	late	Задержка начала ноты	±500 ms	1365 ms	8.38
3940	84	missing_note	Пропущена нота E4	E4	—	8.4
3941	84	missing_note	Пропущена нота F#4	F#4	—	8.4
3942	84	missing_note	Пропущена нота D#5	D#5	—	8.4
3943	84	missing_note	Пропущена нота G5	G5	—	8.4
3944	84	missing_note	Пропущена нота D7	D7	—	8.41
3945	84	missing_note	Пропущена нота F5	F5	—	8.42
3946	84	missing_note	Пропущена нота E4	E4	—	8.45
3947	84	wrong_pitch	Отклонение ноты E5	E5	E4	8.64
3948	84	late	Задержка начала ноты	±500 ms	1322 ms	8.64
3949	84	articulation	Несоответствие длительности ноты	0.04s	0.19s	8.64
3950	84	wrong_pitch	Отклонение ноты D#4	D#4	A#4	8.67
3951	84	late	Задержка начала ноты	±500 ms	1479 ms	8.67
3952	84	articulation	Несоответствие длительности ноты	0.05s	0.26s	8.67
3953	84	wrong_pitch	Отклонение ноты D7	D7	F#5	8.67
3954	84	late	Задержка начала ноты	±500 ms	1490 ms	8.67
3955	84	missing_note	Пропущена нота F#6	F#6	—	8.73
3956	84	missing_note	Пропущена нота E4	E4	—	8.79
3957	84	missing_note	Пропущена нота C#6	C#6	—	8.8
3958	84	missing_note	Пропущена нота B5	B5	—	8.8
3959	84	missing_note	Пропущена нота G#6	G#6	—	8.81
3960	84	missing_note	Пропущена нота A#4	A#4	—	8.83
3961	84	missing_note	Пропущена нота C6	C6	—	8.83
3962	84	missing_note	Пропущена нота C#5	C#5	—	8.83
3963	84	missing_note	Пропущена нота F7	F7	—	8.87
3964	84	missing_note	Пропущена нота G#6	G#6	—	8.93
3965	84	missing_note	Пропущена нота F4	F4	—	8.97
3966	84	missing_note	Пропущена нота G#6	G#6	—	8.99
3967	84	missing_note	Пропущена нота E4	E4	—	9
3968	84	wrong_pitch	Отклонение ноты G#6	G#6	D5	9.05
3969	84	late	Задержка начала ноты	±500 ms	1484 ms	9.05
3970	84	articulation	Несоответствие длительности ноты	0.04s	0.15s	9.05
3971	84	missing_note	Пропущена нота C6	C6	—	9.13
3972	84	missing_note	Пропущена нота F7	F7	—	9.13
3973	84	missing_note	Пропущена нота G#6	G#6	—	9.13
3974	84	missing_note	Пропущена нота E4	E4	—	9.13
3975	84	wrong_pitch	Отклонение ноты F5	F5	B4	9.22
3976	84	late	Задержка начала ноты	±500 ms	1477 ms	9.22
3977	84	articulation	Несоответствие длительности ноты	0.05s	0.16s	9.22
3978	84	missing_note	Пропущена нота F4	F4	—	9.26
3979	84	missing_note	Пропущена нота A#4	A#4	—	9.26
3980	84	missing_note	Пропущена нота D#5	D#5	—	9.28
3981	84	missing_note	Пропущена нота G#5	G#5	—	9.28
3982	84	missing_note	Пропущена нота F#5	F#5	—	9.28
3983	84	missing_note	Пропущена нота D#4	D#4	—	9.29
3984	84	missing_note	Пропущена нота G5	G5	—	9.33
3985	84	missing_note	Пропущена нота E4	E4	—	9.34
3986	84	wrong_pitch	Отклонение ноты D#5	D#5	F#5	9.47
3987	84	late	Задержка начала ноты	±500 ms	1493 ms	9.47
3988	84	articulation	Несоответствие длительности ноты	0.04s	0.15s	9.47
3989	84	wrong_pitch	Отклонение ноты E4	E4	A4	9.48
3990	84	late	Задержка начала ноты	±500 ms	1340 ms	9.48
3991	84	articulation	Несоответствие длительности ноты	0.03s	0.20s	9.48
3992	84	late	Задержка начала ноты	±500 ms	1492 ms	9.6
3993	84	articulation	Несоответствие длительности ноты	0.04s	0.17s	9.6
3994	84	late	Задержка начала ноты	±500 ms	1422 ms	9.67
3995	84	articulation	Несоответствие длительности ноты	0.03s	0.15s	9.67
3996	84	missing_note	Пропущена нота A#4	A#4	—	9.69
3997	84	missing_note	Пропущена нота F#4	F#4	—	9.69
3998	84	missing_note	Пропущена нота C6	C6	—	9.69
3999	84	missing_note	Пропущена нота E6	E6	—	9.69
4000	84	missing_note	Пропущена нота D#5	D#5	—	9.7
4001	84	missing_note	Пропущена нота D#4	D#4	—	9.7
4002	84	missing_note	Пропущена нота A#6	A#6	—	9.7
4003	84	wrong_pitch	Отклонение ноты D5	D5	A4	9.71
4004	84	late	Задержка начала ноты	±500 ms	1497 ms	9.71
4005	84	missing_note	Пропущена нота E4	E4	—	9.73
4006	84	missing_note	Пропущена нота C6	C6	—	9.81
4007	84	missing_note	Пропущена нота F#4	F#4	—	9.83
4008	84	missing_note	Пропущена нота E7	E7	—	9.83
4009	84	missing_note	Пропущена нота C5	C5	—	9.83
4010	84	missing_note	Пропущена нота D#4	D#4	—	9.84
4011	84	missing_note	Пропущена нота G6	G6	—	9.84
4012	84	wrong_pitch	Отклонение ноты E6	E6	D5	9.95
4013	84	late	Задержка начала ноты	±500 ms	1373 ms	9.95
4014	84	missing_note	Пропущена нота A4	A4	—	9.95
4015	84	missing_note	Пропущена нота G#5	G#5	—	9.97
4016	84	missing_note	Пропущена нота C5	C5	—	9.97
4017	84	missing_note	Пропущена нота D#4	D#4	—	9.98
4018	84	wrong_pitch	Отклонение ноты E4	E4	B4	10
4019	84	late	Задержка начала ноты	±500 ms	1481 ms	10
4020	84	articulation	Несоответствие длительности ноты	0.03s	0.14s	10
4021	84	missing_note	Пропущена нота G7	G7	—	10
4022	84	missing_note	Пропущена нота F4	F4	—	10.02
4023	84	missing_note	Пропущена нота G#5	G#5	—	10.03
4024	84	missing_note	Пропущена нота F#5	F#5	—	10.08
4025	84	missing_note	Пропущена нота C#7	C#7	—	10.09
4026	84	wrong_pitch	Отклонение ноты D#5	D#5	A4	10.1
4027	84	late	Задержка начала ноты	±500 ms	1499 ms	10.1
4028	84	articulation	Несоответствие длительности ноты	0.04s	0.20s	10.1
4029	84	missing_note	Пропущена нота E6	E6	—	10.13
4030	84	missing_note	Пропущена нота D#6	D#6	—	10.22
4031	84	missing_note	Пропущена нота A#4	A#4	—	10.23
4032	84	missing_note	Пропущена нота D#5	D#5	—	10.23
4033	84	missing_note	Пропущена нота F#4	F#4	—	10.24
4034	84	missing_note	Пропущена нота D#4	D#4	—	10.24
4035	84	missing_note	Пропущена нота E4	E4	—	10.28
4036	84	wrong_pitch	Отклонение ноты G7	G7	F#5	10.31
4037	84	late	Задержка начала ноты	±500 ms	1463 ms	10.31
4038	84	articulation	Несоответствие длительности ноты	0.04s	0.22s	10.31
4039	84	missing_note	Пропущена нота E4	E4	—	10.33
4040	84	missing_note	Пропущена нота F#4	F#4	—	10.34
4041	84	missing_note	Пропущена нота A5	A5	—	10.34
4042	84	missing_note	Пропущена нота A4	A4	—	10.35
4043	84	missing_note	Пропущена нота E6	E6	—	10.35
4044	84	missing_note	Пропущена нота D#4	D#4	—	10.36
4045	84	missing_note	Пропущена нота G7	G7	—	10.37
4046	84	missing_note	Пропущена нота E4	E4	—	10.4
4047	84	missing_note	Пропущена нота F4	F4	—	10.42
4048	84	missing_note	Пропущена нота E4	E4	—	10.44
4049	84	missing_note	Пропущена нота F#4	F#4	—	10.49
4050	84	missing_note	Пропущена нота B4	B4	—	10.49
4051	84	missing_note	Пропущена нота G7	G7	—	10.49
4052	84	wrong_pitch	Отклонение ноты D#4	D#4	D#5	10.5
4053	84	late	Задержка начала ноты	±500 ms	1489 ms	10.5
4054	84	articulation	Несоответствие длительности ноты	0.04s	0.16s	10.5
4055	84	missing_note	Пропущена нота E6	E6	—	10.5
4056	84	wrong_pitch	Отклонение ноты A4	A4	E4	10.51
4057	84	late	Задержка начала ноты	±500 ms	1499 ms	10.51
4058	84	articulation	Несоответствие длительности ноты	0.05s	0.14s	10.51
4059	84	missing_note	Пропущена нота A#6	A#6	—	10.58
4060	84	missing_note	Пропущена нота F4	F4	—	10.6
4061	84	missing_note	Пропущена нота C5	C5	—	10.6
4062	84	missing_note	Пропущена нота C6	C6	—	10.6
4063	84	missing_note	Пропущена нота E7	E7	—	10.62
4064	84	missing_note	Пропущена нота F#4	F#4	—	10.63
4065	84	missing_note	Пропущена нота D#4	D#4	—	10.63
4066	84	missing_note	Пропущена нота G6	G6	—	10.63
4067	84	late	Задержка начала ноты	±500 ms	1406 ms	10.71
4068	84	articulation	Несоответствие длительности ноты	0.03s	0.19s	10.71
4069	84	wrong_pitch	Отклонение ноты C5	C5	E4	10.73
4070	84	late	Задержка начала ноты	±500 ms	1379 ms	10.73
4071	84	articulation	Несоответствие длительности ноты	0.10s	0.63s	10.73
4072	84	missing_note	Пропущена нота A5	A5	—	10.73
4073	84	missing_note	Пропущена нота F#4	F#4	—	10.74
4074	84	missing_note	Пропущена нота A4	A4	—	10.74
4075	84	missing_note	Пропущена нота E6	E6	—	10.74
4076	84	missing_note	Пропущена нота G#5	G#5	—	10.76
4077	84	missing_note	Пропущена нота G7	G7	—	10.76
4078	84	missing_note	Пропущена нота D#4	D#4	—	10.77
4079	84	wrong_pitch	Отклонение ноты E4	E4	A4	10.79
4080	84	late	Задержка начала ноты	±500 ms	1497 ms	10.79
4081	84	articulation	Несоответствие длительности ноты	0.03s	0.33s	10.79
4082	84	missing_note	Пропущена нота G#5	G#5	—	10.8
4083	84	wrong_pitch	Отклонение ноты F4	F4	F#5	10.81
4084	84	late	Задержка начала ноты	±500 ms	1493 ms	10.81
4085	84	articulation	Несоответствие длительности ноты	0.03s	0.33s	10.81
4086	84	missing_note	Пропущена нота E4	E4	—	10.84
4087	84	missing_note	Пропущена нота E5	E5	—	10.85
4088	84	missing_note	Пропущена нота A#4	A#4	—	10.86
4089	84	missing_note	Пропущена нота F#5	F#5	—	10.86
4090	84	missing_note	Пропущена нота C#7	C#7	—	10.87
4091	84	missing_note	Пропущена нота D#4	D#4	—	10.88
4092	84	missing_note	Пропущена нота A4	A4	—	10.9
4093	84	missing_note	Пропущена нота E4	E4	—	10.91
4094	84	missing_note	Пропущена нота E4	E4	—	10.95
4095	84	missing_note	Пропущена нота A#4	A#4	—	10.99
4096	84	missing_note	Пропущена нота D#5	D#5	—	10.99
4097	84	missing_note	Пропущена нота F#4	F#4	—	11
4098	84	missing_note	Пропущена нота C#5	C#5	—	11
4099	84	missing_note	Пропущена нота G7	G7	—	11
4100	84	missing_note	Пропущена нота D#4	D#4	—	11.01
4101	84	missing_note	Пропущена нота E6	E6	—	11.01
4102	84	missing_note	Пропущена нота E4	E4	—	11.03
4103	84	missing_note	Пропущена нота F#5	F#5	—	11.03
4104	84	missing_note	Пропущена нота A#6	A#6	—	11.06
4105	84	wrong_pitch	Отклонение ноты G7	G7	A4	11.08
4106	84	late	Задержка начала ноты	±500 ms	1481 ms	11.08
4107	84	missing_note	Пропущена нота F#4	F#4	—	11.1
4108	84	missing_note	Пропущена нота G#5	G#5	—	11.1
4109	84	missing_note	Пропущена нота E6	E6	—	11.1
4110	84	missing_note	Пропущена нота A4	A4	—	11.1
4111	84	missing_note	Пропущена нота D#4	D#4	—	11.12
4112	84	missing_note	Пропущена нота C#7	C#7	—	11.13
4113	84	missing_note	Пропущена нота E4	E4	—	11.15
4114	84	missing_note	Пропущена нота E4	E4	—	11.2
4115	84	wrong_pitch	Отклонение ноты G5	G5	E5	11.23
4116	84	late	Задержка начала ноты	±500 ms	1467 ms	11.23
4117	84	articulation	Несоответствие длительности ноты	0.04s	0.16s	11.23
4118	84	wrong_pitch	Отклонение ноты F#4	F#4	C6	11.24
4119	84	late	Задержка начала ноты	±500 ms	1476 ms	11.24
4120	84	articulation	Несоответствие длительности ноты	0.03s	0.26s	11.24
4121	84	missing_note	Пропущена нота F5	F5	—	11.24
4122	84	missing_note	Пропущена нота D#4	D#4	—	11.26
4123	84	missing_note	Пропущена нота F#6	F#6	—	11.26
4124	84	missing_note	Пропущена нота F#5	F#5	—	11.27
4125	84	missing_note	Пропущена нота C#7	C#7	—	11.28
4126	84	late	Задержка начала ноты	±500 ms	1215 ms	11.55
4127	84	articulation	Несоответствие длительности ноты	0.04s	0.24s	11.55
4128	84	wrong_pitch	Отклонение ноты C#7	C#7	C6	11.55
4129	84	late	Задержка начала ноты	±500 ms	1378 ms	11.55
4130	84	missing_note	Пропущена нота G#5	G#5	—	11.57
4131	84	missing_note	Пропущена нота G6	G6	—	11.57
4132	84	wrong_pitch	Отклонение ноты E4	E4	A4	11.59
4133	84	late	Задержка начала ноты	±500 ms	1486 ms	11.59
4134	84	articulation	Несоответствие длительности ноты	0.04s	0.37s	11.59
4135	84	late	Задержка начала ноты	±500 ms	1484 ms	11.6
4136	84	articulation	Несоответствие длительности ноты	0.07s	0.37s	11.6
4137	84	missing_note	Пропущена нота F4	F4	—	11.63
4138	84	missing_note	Пропущена нота F#5	F#5	—	11.66
4139	84	missing_note	Пропущена нота D#5	D#5	—	11.71
4140	84	missing_note	Пропущена нота E5	E5	—	11.71
4141	84	missing_note	Пропущена нота B5	B5	—	11.71
4142	84	missing_note	Пропущена нота G#5	G#5	—	11.72
4143	84	missing_note	Пропущена нота C6	C6	—	11.72
4144	84	missing_note	Пропущена нота F#4	F#4	—	11.73
4145	84	missing_note	Пропущена нота D#4	D#4	—	11.74
4146	84	missing_note	Пропущена нота E4	E4	—	11.77
4147	84	late	Задержка начала ноты	±500 ms	1451 ms	12
4148	84	articulation	Несоответствие длительности ноты	0.05s	0.30s	12
4149	84	late	Задержка начала ноты	±500 ms	1415 ms	12.01
4150	84	articulation	Несоответствие длительности ноты	0.04s	0.30s	12.01
4151	84	wrong_pitch	Отклонение ноты G5	G5	E5	12.01
4152	84	late	Задержка начала ноты	±500 ms	1426 ms	12.01
4153	84	articulation	Несоответствие длительности ноты	0.04s	0.27s	12.01
4154	84	missing_note	Пропущена нота D#5	D#5	—	12.02
4155	84	missing_note	Пропущена нота D#4	D#4	—	12.03
4156	84	missing_note	Пропущена нота E4	E4	—	12.06
4157	84	missing_note	Пропущена нота F4	F4	—	12.15
4158	84	missing_note	Пропущена нота A5	A5	—	12.15
4159	84	missing_note	Пропущена нота G7	G7	—	12.16
4160	84	missing_note	Пропущена нота A4	A4	—	12.16
4161	84	missing_note	Пропущена нота E6	E6	—	12.16
4162	84	missing_note	Пропущена нота D#4	D#4	—	12.17
4163	84	missing_note	Пропущена нота F#5	F#5	—	12.17
4164	84	missing_note	Пропущена нота F#6	F#6	—	12.17
4165	84	missing_note	Пропущена нота C#7	C#7	—	12.19
4166	84	late	Задержка начала ноты	±500 ms	1199 ms	12.45
4167	84	articulation	Несоответствие длительности ноты	0.03s	0.17s	12.45
4168	84	late	Задержка начала ноты	±500 ms	1359 ms	12.47
4169	84	articulation	Несоответствие длительности ноты	0.04s	0.15s	12.47
4170	84	wrong_pitch	Отклонение ноты C#7	C#7	C#6	12.47
4171	84	late	Задержка начала ноты	±500 ms	1359 ms	12.47
4172	84	missing_note	Пропущена нота G6	G6	—	12.48
4173	84	missing_note	Пропущена нота D#4	D#4	—	12.48
4174	84	late	Задержка начала ноты	±500 ms	1489 ms	12.52
4175	84	articulation	Несоответствие длительности ноты	0.07s	0.17s	12.52
4176	84	missing_note	Пропущена нота F#5	F#5	—	12.58
4177	84	missing_note	Пропущена нота A#4	A#4	—	12.6
4178	84	missing_note	Пропущена нота F4	F4	—	12.6
4179	84	missing_note	Пропущена нота B5	B5	—	12.62
4180	84	missing_note	Пропущена нота D#5	D#5	—	12.62
4181	84	missing_note	Пропущена нота C6	C6	—	12.62
4182	84	missing_note	Пропущена нота B4	B4	—	12.63
4183	84	missing_note	Пропущена нота C#5	C#5	—	12.63
4184	84	missing_note	Пропущена нота E6	E6	—	12.63
4185	84	missing_note	Пропущена нота A#6	A#6	—	12.63
4186	84	missing_note	Пропущена нота E4	E4	—	12.66
4187	84	wrong_pitch	Отклонение ноты G7	G7	D#5	12.7
4188	84	late	Задержка начала ноты	±500 ms	1470 ms	12.7
4189	84	articulation	Несоответствие длительности ноты	0.04s	0.16s	12.7
4190	84	missing_note	Пропущена нота E4	E4	—	12.72
4191	84	missing_note	Пропущена нота G7	G7	—	12.77
4192	84	wrong_pitch	Отклонение ноты A#5	A#5	D5	12.9
4193	84	late	Задержка начала ноты	±500 ms	1401 ms	12.9
4194	84	articulation	Несоответствие длительности ноты	0.07s	0.45s	12.9
4195	84	missing_note	Пропущена нота F#4	F#4	—	12.92
4196	84	missing_note	Пропущена нота D#4	D#4	—	12.93
4197	84	missing_note	Пропущена нота B5	B5	—	12.95
4198	84	missing_note	Пропущена нота A#5	A#5	—	13.05
4199	84	missing_note	Пропущена нота F#4	F#4	—	13.06
4200	84	missing_note	Пропущена нота G#5	G#5	—	13.06
4201	84	missing_note	Пропущена нота F5	F5	—	13.06
4202	84	missing_note	Пропущена нота G7	G7	—	13.07
4203	84	missing_note	Пропущена нота D#4	D#4	—	13.08
4204	84	late	Задержка начала ноты	±500 ms	1481 ms	13.1
4205	84	articulation	Несоответствие длительности ноты	0.03s	0.21s	13.1
4206	84	missing_note	Пропущена нота F4	F4	—	13.2
4207	84	missing_note	Пропущена нота A#4	A#4	—	13.2
4208	84	missing_note	Пропущена нота C#7	C#7	—	13.2
4209	84	missing_note	Пропущена нота F#5	F#5	—	13.2
4210	84	missing_note	Пропущена нота F#6	F#6	—	13.2
4211	84	missing_note	Пропущена нота F#4	F#4	—	13.22
4212	84	missing_note	Пропущена нота D#4	D#4	—	13.22
4213	84	wrong_pitch	Отклонение ноты F5	F5	E4	13.29
4214	84	late	Задержка начала ноты	±500 ms	1472 ms	13.29
4215	84	articulation	Несоответствие длительности ноты	0.03s	0.18s	13.29
4216	84	missing_note	Пропущена нота A#4	A#4	—	13.34
4217	84	missing_note	Пропущена нота D#5	D#5	—	13.34
4218	84	missing_note	Пропущена нота F#4	F#4	—	13.35
4219	84	missing_note	Пропущена нота C6	C6	—	13.35
4220	84	missing_note	Пропущена нота D#4	D#4	—	13.36
4221	84	missing_note	Пропущена нота A#6	A#6	—	13.37
4222	84	wrong_pitch	Отклонение ноты D6	D6	A4	13.47
4223	84	late	Задержка начала ноты	±500 ms	1442 ms	13.47
4224	84	late	Задержка начала ноты	±500 ms	1429 ms	13.48
4225	84	articulation	Несоответствие длительности ноты	0.03s	0.17s	13.48
4226	84	wrong_pitch	Отклонение ноты D#4	D#4	D5	13.49
4227	84	late	Задержка начала ноты	±500 ms	1451 ms	13.49
4228	84	articulation	Несоответствие длительности ноты	0.03s	0.14s	13.49
4229	84	missing_note	Пропущена нота D5	D5	—	13.49
4230	84	missing_note	Пропущена нота A6	A6	—	13.5
4231	84	missing_note	Пропущена нота E4	E4	—	13.51
4232	84	late	Задержка начала ноты	±500 ms	1495 ms	13.57
4233	84	articulation	Несоответствие длительности ноты	0.04s	0.15s	13.57
4234	84	late	Задержка начала ноты	±500 ms	1467 ms	13.59
4235	84	articulation	Несоответствие длительности ноты	0.03s	0.53s	13.59
4236	84	missing_note	Пропущена нота A#4	A#4	—	13.59
4237	84	missing_note	Пропущена нота G#6	G#6	—	13.6
4238	84	missing_note	Пропущена нота C#5	C#5	—	13.6
4239	84	missing_note	Пропущена нота F#4	F#4	—	13.62
4240	84	missing_note	Пропущена нота D6	D6	—	13.62
4241	84	missing_note	Пропущена нота D#4	D#4	—	13.63
4242	84	missing_note	Пропущена нота C6	C6	—	13.63
4243	84	missing_note	Пропущена нота E4	E4	—	13.65
4244	84	missing_note	Пропущена нота E4	E4	—	13.7
4245	84	missing_note	Пропущена нота A5	A5	—	13.72
4246	84	missing_note	Пропущена нота F#4	F#4	—	13.73
4247	84	missing_note	Пропущена нота A4	A4	—	13.73
4248	84	missing_note	Пропущена нота E6	E6	—	13.73
4249	84	wrong_pitch	Отклонение ноты G7	G7	F#5	13.78
4250	84	late	Задержка начала ноты	±500 ms	1447 ms	13.78
4251	84	articulation	Несоответствие длительности ноты	0.05s	0.19s	13.78
4252	84	missing_note	Пропущена нота F#5	F#5	—	13.86
4253	84	missing_note	Пропущена нота C#6	C#6	—	13.86
4254	84	missing_note	Пропущена нота F#4	F#4	—	13.87
4255	84	missing_note	Пропущена нота D#4	D#4	—	13.9
4256	84	missing_note	Пропущена нота D6	D6	—	13.95
4257	84	missing_note	Пропущена нота G5	G5	—	13.95
4258	84	missing_note	Пропущена нота F4	F4	—	14
4259	84	missing_note	Пропущена нота B6	B6	—	14.01
4260	84	missing_note	Пропущена нота G4	G4	—	14.01
4261	84	missing_note	Пропущена нота D#4	D#4	—	14.02
4262	84	wrong_pitch	Отклонение ноты E4	E4	C#6	14.07
4263	84	late	Задержка начала ноты	±500 ms	1489 ms	14.07
4264	84	articulation	Несоответствие длительности ноты	0.04s	0.19s	14.07
4265	84	missing_note	Пропущена нота A4	A4	—	14.1
4266	84	missing_note	Пропущена нота F#4	F#4	—	14.12
4267	84	missing_note	Пропущена нота E6	E6	—	14.12
4268	84	missing_note	Пропущена нота G7	G7	—	14.13
4269	84	missing_note	Пропущена нота D#4	D#4	—	14.14
4270	84	missing_note	Пропущена нота E4	E4	—	14.16
4271	84	missing_note	Пропущена нота D5	D5	—	14.21
4272	84	missing_note	Пропущена нота E4	E4	—	14.21
4273	84	wrong_pitch	Отклонение ноты B4	B4	F#5	14.24
4274	84	late	Задержка начала ноты	±500 ms	1482 ms	14.24
4275	84	articulation	Несоответствие длительности ноты	0.03s	0.19s	14.24
4276	84	missing_note	Пропущена нота D5	D5	—	14.24
4277	84	missing_note	Пропущена нота E4	E4	—	14.26
4278	84	missing_note	Пропущена нота D#6	D#6	—	14.26
4279	84	missing_note	Пропущена нота F#4	F#4	—	14.27
4280	84	missing_note	Пропущена нота A#4	A#4	—	14.27
4281	84	missing_note	Пропущена нота D#5	D#5	—	14.27
4282	84	missing_note	Пропущена нота F#7	F#7	—	14.27
4283	84	missing_note	Пропущена нота D#4	D#4	—	14.28
4284	84	missing_note	Пропущена нота E6	E6	—	14.28
4285	84	missing_note	Пропущена нота A4	A4	—	14.29
4286	84	missing_note	Пропущена нота E4	E4	—	14.3
4287	84	missing_note	Пропущена нота D5	D5	—	14.3
4288	84	missing_note	Пропущена нота D#5	D#5	—	14.33
4289	84	wrong_pitch	Отклонение ноты A#4	A#4	E5	14.38
4290	84	late	Задержка начала ноты	±500 ms	1482 ms	14.38
4291	84	articulation	Несоответствие длительности ноты	0.04s	0.15s	14.38
4292	84	missing_note	Пропущена нота F#6	F#6	—	14.38
4293	84	missing_note	Пропущена нота G#5	G#5	—	14.4
4294	84	missing_note	Пропущена нота F#5	F#5	—	14.4
4295	84	missing_note	Пропущена нота C#7	C#7	—	14.4
4296	84	missing_note	Пропущена нота F#4	F#4	—	14.41
4297	84	missing_note	Пропущена нота A#5	A#5	—	14.44
4298	84	missing_note	Пропущена нота F5	F5	—	14.45
4299	84	missing_note	Пропущена нота G5	G5	—	14.47
4300	84	missing_note	Пропущена нота E4	E4	—	14.48
4301	84	missing_note	Пропущена нота F#5	F#5	—	14.49
4302	84	wrong_pitch	Отклонение ноты B5	B5	D#5	14.5
4303	84	late	Задержка начала ноты	±500 ms	1496 ms	14.5
4304	84	articulation	Несоответствие длительности ноты	0.03s	0.16s	14.5
4305	84	missing_note	Пропущена нота G#5	G#5	—	14.51
4306	84	missing_note	Пропущена нота C#7	C#7	—	14.51
4307	84	missing_note	Пропущена нота C6	C6	—	14.51
4308	84	missing_note	Пропущена нота G7	G7	—	14.51
4309	84	missing_note	Пропущена нота F#4	F#4	—	14.52
4310	84	missing_note	Пропущена нота D#4	D#4	—	14.53
4311	84	missing_note	Пропущена нота B5	B5	—	14.55
4312	84	missing_note	Пропущена нота E4	E4	—	14.56
4313	84	missing_note	Пропущена нота C6	C6	—	14.57
4314	84	missing_note	Пропущена нота D#4	D#4	—	14.63
4315	84	missing_note	Пропущена нота A4	A4	—	14.63
4316	84	wrong_pitch	Отклонение ноты E4	E4	C#5	14.66
4317	84	late	Задержка начала ноты	±500 ms	1480 ms	14.66
4318	84	articulation	Несоответствие длительности ноты	0.03s	0.15s	14.66
4319	84	missing_note	Пропущена нота G#5	G#5	—	14.66
4320	84	missing_note	Пропущена нота B5	B5	—	14.66
4321	84	missing_note	Пропущена нота F5	F5	—	14.66
4322	84	missing_note	Пропущена нота D#4	D#4	—	14.69
4323	84	missing_note	Пропущена нота E4	E4	—	14.71
4324	84	wrong_pitch	Отклонение ноты F#5	F#5	A4	14.79
4325	84	late	Задержка начала ноты	±500 ms	1481 ms	14.79
4326	84	missing_note	Пропущена нота F#6	F#6	—	14.79
4327	84	missing_note	Пропущена нота C#7	C#7	—	14.79
4328	84	missing_note	Пропущена нота F#4	F#4	—	14.8
4329	84	missing_note	Пропущена нота D#4	D#4	—	14.81
4330	84	wrong_pitch	Отклонение ноты A#4	A#4	F#4	14.93
4331	84	late	Задержка начала ноты	±500 ms	1480 ms	14.93
4332	84	articulation	Несоответствие длительности ноты	0.03s	0.15s	14.93
4333	84	missing_note	Пропущена нота D#5	D#5	—	14.93
4334	84	missing_note	Пропущена нота E4	E4	—	14.94
4335	84	missing_note	Пропущена нота E6	E6	—	14.94
4336	84	missing_note	Пропущена нота F5	F5	—	14.94
4337	84	missing_note	Пропущена нота D#4	D#4	—	14.97
4338	84	missing_note	Пропущена нота F#5	F#5	—	14.98
4339	84	missing_note	Пропущена нота D5	D5	—	15.05
4340	84	missing_note	Пропущена нота F#4	F#4	—	15.07
4341	84	missing_note	Пропущена нота D#4	D#4	—	15.07
4342	84	missing_note	Пропущена нота E4	E4	—	15.1
4343	84	missing_note	Пропущена нота C#5	C#5	—	15.17
4344	84	late	Задержка начала ноты	±500 ms	1495 ms	15.19
4345	84	articulation	Несоответствие длительности ноты	0.04s	0.22s	15.19
4346	84	missing_note	Пропущена нота G#6	G#6	—	15.2
4347	84	missing_note	Пропущена нота F#4	F#4	—	15.21
4348	84	missing_note	Пропущена нота D#4	D#4	—	15.21
4349	84	missing_note	Пропущена нота A4	A4	—	15.3
4350	84	missing_note	Пропущена нота F#4	F#4	—	15.31
4351	84	missing_note	Пропущена нота G#5	G#5	—	15.31
4352	84	missing_note	Пропущена нота E6	E6	—	15.31
4353	84	missing_note	Пропущена нота D#4	D#4	—	15.33
4354	84	missing_note	Пропущена нота G7	G7	—	15.33
4355	84	missing_note	Пропущена нота E4	E4	—	15.36
4356	84	wrong_pitch	Отклонение ноты F4	F4	F#5	15.38
4357	84	late	Задержка начала ноты	±500 ms	1496 ms	15.38
4358	84	articulation	Несоответствие длительности ноты	0.04s	0.20s	15.38
4359	84	missing_note	Пропущена нота C#6	C#6	—	15.45
4360	84	missing_note	Пропущена нота F#4	F#4	—	15.45
4361	84	missing_note	Пропущена нота D#4	D#4	—	15.48
4362	84	missing_note	Пропущена нота A#6	A#6	—	15.48
4363	84	wrong_pitch	Отклонение ноты G5	G5	A4	15.55
4364	84	late	Задержка начала ноты	±500 ms	1491 ms	15.55
4365	84	wrong_pitch	Отклонение ноты G4	G4	C#6	15.59
4366	84	late	Задержка начала ноты	±500 ms	1471 ms	15.59
4367	84	articulation	Несоответствие длительности ноты	0.10s	0.20s	15.59
4368	84	missing_note	Пропущена нота D6	D6	—	15.59
4369	84	missing_note	Пропущена нота B6	B6	—	15.6
4370	84	missing_note	Пропущена нота D#4	D#4	—	15.62
4371	84	missing_note	Пропущена нота G4	G4	—	15.69
4372	84	missing_note	Пропущена нота F#4	F#4	—	15.7
4373	84	missing_note	Пропущена нота E6	E6	—	15.71
4374	84	missing_note	Пропущена нота A4	A4	—	15.71
4375	84	missing_note	Пропущена нота D#4	D#4	—	15.72
4376	84	missing_note	Пропущена нота G7	G7	—	15.72
4377	84	wrong_pitch	Отклонение ноты E4	E4	A4	15.76
4378	84	late	Задержка начала ноты	±500 ms	1478 ms	15.76
4379	84	articulation	Несоответствие длительности ноты	0.03s	0.19s	15.76
4380	84	late	Задержка начала ноты	±500 ms	1437 ms	15.79
4381	84	articulation	Несоответствие длительности ноты	0.04s	0.19s	15.79
4382	84	missing_note	Пропущена нота D#5	D#5	—	15.8
4383	84	missing_note	Пропущена нота C6	C6	—	15.85
4384	84	missing_note	Пропущена нота F4	F4	—	15.86
4385	84	missing_note	Пропущена нота G7	G7	—	15.86
4386	84	missing_note	Пропущена нота D#4	D#4	—	15.87
4387	84	missing_note	Пропущена нота A#6	A#6	—	15.88
4388	84	missing_note	Пропущена нота E4	E4	—	15.9
4389	84	wrong_pitch	Отклонение ноты A#4	A#4	C#6	15.98
4390	84	late	Задержка начала ноты	±500 ms	1405 ms	15.98
4391	84	articulation	Несоответствие длительности ноты	0.04s	0.20s	15.98
4392	84	missing_note	Пропущена нота E6	E6	—	15.98
4393	84	missing_note	Пропущена нота F#5	F#5	—	15.98
4394	84	missing_note	Пропущена нота F#6	F#6	—	15.98
4395	84	missing_note	Пропущена нота C#7	C#7	—	15.99
4396	84	missing_note	Пропущена нота F#4	F#4	—	16
4397	84	missing_note	Пропущена нота D#4	D#4	—	16
4398	84	missing_note	Пропущена нота G#5	G#5	—	16.03
4399	84	missing_note	Пропущена нота A#5	A#5	—	16.03
4400	84	late	Задержка начала ноты	±500 ms	1483 ms	16.06
4401	84	articulation	Несоответствие длительности ноты	0.03s	0.20s	16.06
4402	84	missing_note	Пропущена нота F#5	F#5	—	16.07
4403	84	missing_note	Пропущена нота A#5	A#5	—	16.1
4404	84	missing_note	Пропущена нота C6	C6	—	16.1
4405	84	missing_note	Пропущена нота D#4	D#4	—	16.13
4406	84	missing_note	Пропущена нота F#5	F#5	—	16.13
4407	84	late	Задержка начала ноты	±500 ms	1440 ms	16.24
4408	84	articulation	Несоответствие длительности ноты	0.04s	0.16s	16.24
4409	84	missing_note	Пропущена нота B5	B5	—	16.24
4410	84	missing_note	Пропущена нота F5	F5	—	16.24
4411	84	missing_note	Пропущена нота G7	G7	—	16.26
4412	84	missing_note	Пропущена нота D#4	D#4	—	16.27
4413	84	wrong_pitch	Отклонение ноты B5	B5	D#5	16.37
4414	84	late	Задержка начала ноты	±500 ms	1464 ms	16.37
4415	84	missing_note	Пропущена нота E4	E4	—	16.38
4416	84	missing_note	Пропущена нота A#4	A#4	—	16.38
4417	84	missing_note	Пропущена нота D#5	D#5	—	16.38
4418	84	missing_note	Пропущена нота G#5	G#5	—	16.38
4419	84	missing_note	Пропущена нота F#4	F#4	—	16.4
4420	84	missing_note	Пропущена нота F#7	F#7	—	16.4
4421	84	missing_note	Пропущена нота D#4	D#4	—	16.41
4422	84	missing_note	Пропущена нота A#5	A#5	—	16.41
4423	84	missing_note	Пропущена нота E4	E4	—	16.43
4424	84	missing_note	Пропущена нота C6	C6	—	16.43
4425	84	missing_note	Пропущена нота B5	B5	—	16.5
4426	84	missing_note	Пропущена нота A5	A5	—	16.51
4427	84	missing_note	Пропущена нота G#5	G#5	—	16.52
4428	84	missing_note	Пропущена нота F5	F5	—	16.52
4429	84	missing_note	Пропущена нота F#4	F#4	—	16.53
4430	84	missing_note	Пропущена нота D#4	D#4	—	16.53
4431	84	missing_note	Пропущена нота G5	G5	—	16.55
4432	84	missing_note	Пропущена нота B5	B5	—	16.55
4433	84	missing_note	Пропущена нота E4	E4	—	16.57
4434	84	late	Задержка начала ноты	±500 ms	1487 ms	16.64
4435	84	articulation	Несоответствие длительности ноты	0.04s	0.16s	16.64
4436	84	missing_note	Пропущена нота G#6	G#6	—	16.64
4437	84	missing_note	Пропущена нота F#4	F#4	—	16.65
4438	84	missing_note	Пропущена нота G#5	G#5	—	16.65
4439	84	missing_note	Пропущена нота D#4	D#4	—	16.66
4440	84	missing_note	Пропущена нота D#7	D#7	—	16.73
4441	84	wrong_pitch	Отклонение ноты F#5	F#5	E4	16.78
4442	84	late	Задержка начала ноты	±500 ms	1486 ms	16.78
4443	84	missing_note	Пропущена нота F#4	F#4	—	16.8
4444	84	missing_note	Пропущена нота D#4	D#4	—	16.8
4445	84	missing_note	Пропущена нота C#7	C#7	—	16.8
4446	84	missing_note	Пропущена нота E4	E4	—	16.84
4447	84	missing_note	Пропущена нота E5	E5	—	16.88
4448	84	wrong_pitch	Отклонение ноты F4	F4	C5	16.9
4449	84	late	Задержка начала ноты	±500 ms	1491 ms	16.9
4450	84	articulation	Несоответствие длительности ноты	0.03s	0.16s	16.9
4451	84	missing_note	Пропущена нота F#4	F#4	—	16.92
4452	84	missing_note	Пропущена нота D#4	D#4	—	16.93
4453	84	missing_note	Пропущена нота E5	E5	—	17.01
4454	84	missing_note	Пропущена нота D#5	D#5	—	17.02
4455	84	late	Задержка начала ноты	±500 ms	1490 ms	17.03
4456	84	articulation	Несоответствие длительности ноты	0.03s	0.19s	17.03
4457	84	missing_note	Пропущена нота F#4	F#4	—	17.05
4458	84	missing_note	Пропущена нота D#4	D#4	—	17.06
4459	84	missing_note	Пропущена нота A#6	A#6	—	17.06
4460	84	missing_note	Пропущена нота E4	E4	—	17.08
4461	84	missing_note	Пропущена нота G7	G7	—	17.1
4462	84	missing_note	Пропущена нота E5	E5	—	17.13
4463	84	missing_note	Пропущена нота D#6	D#6	—	17.15
4464	84	missing_note	Пропущена нота F#4	F#4	—	17.17
4465	84	missing_note	Пропущена нота A4	A4	—	17.17
4466	84	missing_note	Пропущена нота D#4	D#4	—	17.2
4467	84	missing_note	Пропущена нота G7	G7	—	17.21
4468	84	missing_note	Пропущена нота E4	E4	—	17.22
4469	84	missing_note	Пропущена нота A5	A5	—	17.24
4470	84	missing_note	Пропущена нота A4	A4	—	17.24
4471	84	missing_note	Пропущена нота E4	E4	—	17.27
4472	84	missing_note	Пропущена нота A#4	A#4	—	17.29
4473	84	missing_note	Пропущена нота C#5	C#5	—	17.3
4474	84	late	Задержка начала ноты	±500 ms	1488 ms	17.31
4475	84	articulation	Несоответствие длительности ноты	0.03s	0.15s	17.31
4476	84	missing_note	Пропущена нота G#6	G#6	—	17.31
4477	84	missing_note	Пропущена нота D#4	D#4	—	17.33
4478	84	missing_note	Пропущена нота E4	E4	—	17.35
4479	84	missing_note	Пропущена нота C5	C5	—	17.43
4480	84	missing_note	Пропущена нота C6	C6	—	17.43
4481	84	missing_note	Пропущена нота F#4	F#4	—	17.44
4482	84	missing_note	Пропущена нота D#4	D#4	—	17.45
4483	84	missing_note	Пропущена нота G6	G6	—	17.48
4484	84	missing_note	Пропущена нота C5	C5	—	17.52
4485	84	missing_note	Пропущена нота B5	B5	—	17.56
4486	84	missing_note	Пропущена нота F#4	F#4	—	17.57
4487	84	missing_note	Пропущена нота B4	B4	—	17.57
4488	84	missing_note	Пропущена нота F#6	F#6	—	17.57
4489	84	missing_note	Пропущена нота D#4	D#4	—	17.58
4490	84	missing_note	Пропущена нота B4	B4	—	17.64
4491	84	wrong_pitch	Отклонение ноты A4	A4	E4	17.66
4492	84	late	Задержка начала ноты	±500 ms	1497 ms	17.66
4493	84	wrong_pitch	Отклонение ноты D#4	D#4	A#4	17.69
4494	84	late	Задержка начала ноты	±500 ms	1482 ms	17.69
4495	84	articulation	Несоответствие длительности ноты	0.05s	0.16s	17.69
4496	84	wrong_pitch	Отклонение ноты E4	E4	F#5	17.81
4497	84	late	Задержка начала ноты	±500 ms	1355 ms	17.81
4498	84	missing_note	Пропущена нота B5	B5	—	17.81
4499	84	missing_note	Пропущена нота A#5	A#5	—	17.83
4500	84	missing_note	Пропущена нота F#5	F#5	—	17.85
4501	84	missing_note	Пропущена нота A#4	A#4	—	17.85
4502	84	wrong_pitch	Отклонение ноты G5	G5	E4	17.86
4503	84	late	Задержка начала ноты	±500 ms	1498 ms	17.86
4504	84	wrong_pitch	Отклонение ноты F4	F4	B4	17.98
4505	84	late	Задержка начала ноты	±500 ms	1373 ms	17.98
4506	84	articulation	Несоответствие длительности ноты	0.03s	0.21s	17.98
4507	84	wrong_pitch	Отклонение ноты A#4	A#4	E4	17.99
4508	84	late	Задержка начала ноты	±500 ms	1499 ms	17.99
4509	84	articulation	Несоответствие длительности ноты	0.08s	0.23s	17.99
4510	84	missing_note	Пропущена нота E4	E4	—	18
4511	84	missing_note	Пропущена нота E4	E4	—	18.05
4512	84	missing_note	Пропущена нота A#4	A#4	—	18.09
4513	84	missing_note	Пропущена нота B4	B4	—	18.12
4514	84	missing_note	Пропущена нота G#5	G#5	—	18.12
4515	84	wrong_pitch	Отклонение ноты E4	E4	A5	18.19
4516	84	late	Задержка начала ноты	±500 ms	1488 ms	18.19
4517	84	articulation	Несоответствие длительности ноты	0.05s	0.16s	18.19
4518	84	wrong_pitch	Отклонение ноты A#5	A#5	D#5	18.2
4519	84	late	Задержка начала ноты	±500 ms	1486 ms	18.2
4520	84	wrong_pitch	Отклонение ноты A#4	A#4	D#4	18.21
4521	84	late	Задержка начала ноты	±500 ms	1472 ms	18.21
4522	84	articulation	Несоответствие длительности ноты	0.04s	0.14s	18.21
4523	84	missing_note	Пропущена нота D5	D5	—	18.21
4524	84	missing_note	Пропущена нота E4	E4	—	18.24
4525	84	wrong_pitch	Отклонение ноты B5	B5	D#5	18.31
4526	84	late	Задержка начала ноты	±500 ms	1489 ms	18.31
4527	84	articulation	Несоответствие длительности ноты	0.05s	0.23s	18.31
4528	84	wrong_pitch	Отклонение ноты D#5	D#5	A5	18.33
4529	84	late	Задержка начала ноты	±500 ms	1487 ms	18.33
4607	84	missing_note	Пропущена нота E4	E4	—	19.41
4530	84	articulation	Несоответствие длительности ноты	0.03s	0.26s	18.33
4531	84	wrong_pitch	Отклонение ноты D6	D6	D#4	18.33
4532	84	late	Задержка начала ноты	±500 ms	1475 ms	18.33
4533	84	missing_note	Пропущена нота A#4	A#4	—	18.34
4534	84	missing_note	Пропущена нота C6	C6	—	18.34
4535	84	missing_note	Пропущена нота G#5	G#5	—	18.35
4536	84	missing_note	Пропущена нота D5	D5	—	18.35
4537	84	missing_note	Пропущена нота E4	E4	—	18.37
4538	84	missing_note	Пропущена нота B5	B5	—	18.37
4539	84	missing_note	Пропущена нота F4	F4	—	18.42
4540	84	late	Задержка начала ноты	±500 ms	1488 ms	18.45
4541	84	articulation	Несоответствие длительности ноты	0.08s	0.16s	18.45
4542	84	missing_note	Пропущена нота B5	B5	—	18.47
4543	84	missing_note	Пропущена нота A#5	A#5	—	18.49
4544	84	missing_note	Пропущена нота E4	E4	—	18.52
4545	84	wrong_pitch	Отклонение ноты G#6	G#6	E4	18.59
4546	84	late	Задержка начала ноты	±500 ms	1489 ms	18.59
4547	84	articulation	Несоответствие длительности ноты	0.05s	0.17s	18.59
4548	84	missing_note	Пропущена нота F#5	F#5	—	18.59
4549	84	late	Задержка начала ноты	±500 ms	1498 ms	18.6
4550	84	wrong_pitch	Отклонение ноты E4	E4	F#5	18.64
4551	84	late	Задержка начала ноты	±500 ms	1446 ms	18.64
4552	84	articulation	Несоответствие длительности ноты	0.05s	0.28s	18.64
4553	84	missing_note	Пропущена нота A#5	A#5	—	18.7
4554	84	missing_note	Пропущена нота A#4	A#4	—	18.71
4555	84	missing_note	Пропущена нота G5	G5	—	18.72
4556	84	missing_note	Пропущена нота F4	F4	—	18.72
4557	84	late	Задержка начала ноты	±500 ms	1472 ms	18.76
4558	84	articulation	Несоответствие длительности ноты	0.14s	0.28s	18.76
4559	84	wrong_pitch	Отклонение ноты C6	C6	E5	18.84
4560	84	late	Задержка начала ноты	±500 ms	1365 ms	18.84
4561	84	articulation	Несоответствие длительности ноты	0.03s	0.21s	18.84
4562	84	missing_note	Пропущена нота A4	A4	—	18.84
4563	84	missing_note	Пропущена нота G#5	G#5	—	18.84
4564	84	missing_note	Пропущена нота D6	D6	—	18.86
4565	84	missing_note	Пропущена нота E4	E4	—	18.88
4566	84	missing_note	Пропущена нота F4	F4	—	18.92
4567	84	missing_note	Пропущена нота A5	A5	—	18.95
4568	84	missing_note	Пропущена нота G#5	G#5	—	18.98
4569	84	missing_note	Пропущена нота C6	C6	—	18.98
4570	84	missing_note	Пропущена нота A#6	A#6	—	18.98
4571	84	missing_note	Пропущена нота F#5	F#5	—	18.99
4572	84	missing_note	Пропущена нота E4	E4	—	18.99
4573	84	wrong_pitch	Отклонение ноты G#6	G#6	E6	19
4574	84	late	Задержка начала ноты	±500 ms	1499 ms	19
4575	84	late	Задержка начала ноты	±500 ms	1497 ms	19.01
4576	84	missing_note	Пропущена нота E4	E4	—	19.05
4577	84	missing_note	Пропущена нота C#6	C#6	—	19.05
4578	84	missing_note	Пропущена нота E4	E4	—	19.09
4579	84	missing_note	Пропущена нота F#6	F#6	—	19.1
4580	84	missing_note	Пропущена нота F7	F7	—	19.1
4581	84	missing_note	Пропущена нота C6	C6	—	19.12
4582	84	missing_note	Пропущена нота B5	B5	—	19.12
4583	84	missing_note	Пропущена нота G6	G6	—	19.12
4584	84	late	Задержка начала ноты	±500 ms	1492 ms	19.17
4585	84	articulation	Несоответствие длительности ноты	0.04s	0.14s	19.17
4586	84	wrong_pitch	Отклонение ноты B5	B5	E6	19.22
4587	84	late	Задержка начала ноты	±500 ms	1450 ms	19.22
4588	84	articulation	Несоответствие длительности ноты	0.07s	0.14s	19.22
4589	84	wrong_pitch	Отклонение ноты F7	F7	E4	19.23
4590	84	late	Задержка начала ноты	±500 ms	1413 ms	19.23
4591	84	articulation	Несоответствие длительности ноты	0.08s	0.19s	19.23
4592	84	missing_note	Пропущена нота E4	E4	—	19.27
4593	84	missing_note	Пропущена нота B5	B5	—	19.29
4594	84	wrong_pitch	Отклонение ноты B5	B5	F6	19.34
4595	84	late	Задержка начала ноты	±500 ms	1464 ms	19.34
4596	84	articulation	Несоответствие длительности ноты	0.03s	0.22s	19.34
4597	84	wrong_pitch	Отклонение ноты C6	C6	E4	19.34
4598	84	late	Задержка начала ноты	±500 ms	1476 ms	19.34
4599	84	articulation	Несоответствие длительности ноты	0.05s	0.20s	19.34
4600	84	missing_note	Пропущена нота F#6	F#6	—	19.35
4601	84	missing_note	Пропущена нота E4	E4	—	19.35
4602	84	missing_note	Пропущена нота D7	D7	—	19.35
4603	84	missing_note	Пропущена нота G#6	G#6	—	19.36
4604	84	missing_note	Пропущена нота F7	F7	—	19.36
4605	84	missing_note	Пропущена нота B6	B6	—	19.36
4606	84	missing_note	Пропущена нота B5	B5	—	19.37
4608	84	missing_note	Пропущена нота F4	F4	—	19.44
4609	84	missing_note	Пропущена нота E4	E4	—	19.47
4610	84	wrong_pitch	Отклонение ноты G#6	G#6	F6	19.53
4611	84	late	Задержка начала ноты	±500 ms	1453 ms	19.53
4612	84	articulation	Несоответствие длительности ноты	0.04s	0.19s	19.53
4613	84	late	Задержка начала ноты	±500 ms	1401 ms	19.57
4614	84	articulation	Несоответствие длительности ноты	0.04s	0.21s	19.57
4615	84	wrong_pitch	Отклонение ноты A2	A2	E4	20.86
4616	84	articulation	Несоответствие длительности ноты	0.04s	0.17s	20.86
4617	84	missing_note	Пропущена нота G#2	G#2	—	20.9
4618	84	missing_note	Пропущена нота A4	A4	—	20.9
4619	84	missing_note	Пропущена нота E5	E5	—	21
4620	84	missing_note	Пропущена нота F#5	F#5	—	21
4621	84	missing_note	Пропущена нота B4	B4	—	21
4622	84	missing_note	Пропущена нота D#7	D#7	—	21.01
4623	84	missing_note	Пропущена нота F#4	F#4	—	21.02
4624	84	missing_note	Пропущена нота G7	G7	—	21.02
4625	84	missing_note	Пропущена нота F5	F5	—	21.02
4626	84	missing_note	Пропущена нота A5	A5	—	21.02
4627	84	missing_note	Пропущена нота F3	F3	—	21.03
4628	84	missing_note	Пропущена нота A4	A4	—	21.03
4629	84	missing_note	Пропущена нота E4	E4	—	21.05
4630	84	missing_note	Пропущена нота G#5	G#5	—	21.05
4631	84	missing_note	Пропущена нота D6	D6	—	21.05
4632	84	missing_note	Пропущена нота C#5	C#5	—	21.05
4633	84	missing_note	Пропущена нота D#6	D#6	—	21.05
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notifications (id, user_id, type, title, is_read, link, created_at) FROM stdin;
1	3	report_ready	Отчёт готов	f	/reports/10	2026-06-01 08:32:56.598+03
2	4	report_ready	Отчёт готов	f	/reports/20	2026-06-01 08:32:56.704+03
3	5	report_ready	Отчёт готов	f	/reports/30	2026-06-01 08:32:56.807+03
4	6	report_ready	Отчёт готов	f	/reports/40	2026-06-01 08:32:56.9+03
5	7	report_ready	Отчёт готов	f	/reports/50	2026-06-01 08:32:56.985+03
6	8	report_ready	Отчёт готов	f	/reports/60	2026-06-01 08:32:57.068+03
7	9	report_ready	Отчёт готов	t	/reports/70	2026-06-01 08:32:57.164+03
8	10	report_ready	Отчёт готов	f	/reports/80	2026-06-01 08:32:57.253+03
10	1	achievement	Получено достижение: Первый шаг	t	/profile	2026-06-01 09:20:17.439+03
9	1	report_ready	Отчёт готов	t	/reports/81	2026-06-01 09:20:17.426+03
11	1	report_ready	Отчёт готов	t	/reports/82	2026-06-01 09:35:06.625+03
12	1	report_ready	Отчёт готов	t	/reports/83	2026-06-01 09:58:47.903+03
13	1	achievement	Получено достижение: Отличник	t	/profile	2026-06-01 09:58:47.918+03
14	1	report_ready	Отчёт готов	t	/reports/84	2026-06-01 10:12:20.663+03
15	11	suggestion_rejected	Произведение «123» отклонено	t	/suggest	2026-06-01 13:47:17.965+03
17	11	achievement	Получено достижение: Первый шаг	t	/profile	2026-06-01 13:50:09.228+03
16	11	report_ready	Отчёт готов	t	/reports/85	2026-06-01 13:50:09.211+03
18	11	report_ready	Отчёт готов	t	/reports/86	2026-06-01 14:17:08.198+03
19	11	achievement	Получено достижение: Отличник	t	/profile	2026-06-01 14:17:08.214+03
20	11	suggestion_approved	Произведение «Соната» принято в библиотеку	t	/library	2026-06-01 14:27:20.663+03
21	11	suggestion_rejected	Произведение «Скерцо» отклонено	t	/suggest	2026-06-01 14:29:58.665+03
\.


--
-- Data for Name: recommendations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.recommendations (id, user_id, report_id, text, created_at) FROM stdin;
1	3	1	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.501+03
2	3	2	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.513+03
3	3	3	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.524+03
4	3	4	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.534+03
5	3	5	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.542+03
6	3	6	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.552+03
7	3	7	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.562+03
8	3	8	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.573+03
9	3	9	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.584+03
10	3	10	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.596+03
11	4	11	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.616+03
12	4	12	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.625+03
13	4	13	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.635+03
14	4	14	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.644+03
15	4	15	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.653+03
16	4	16	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.663+03
17	4	17	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.674+03
18	4	18	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.683+03
19	4	19	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.692+03
20	4	20	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.702+03
21	5	21	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.722+03
22	5	22	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.731+03
23	5	23	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.741+03
24	5	24	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.751+03
25	5	25	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.759+03
26	5	26	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.769+03
27	5	27	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.778+03
28	5	28	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.787+03
29	5	29	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.796+03
30	5	30	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.805+03
31	6	31	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.816+03
32	6	32	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.825+03
33	6	33	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.833+03
34	6	34	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.844+03
35	6	35	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.852+03
36	6	36	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.862+03
37	6	37	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.871+03
38	6	38	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.88+03
39	6	39	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.889+03
40	6	40	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.898+03
41	7	41	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.912+03
42	7	42	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.921+03
43	7	43	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.93+03
44	7	44	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.94+03
45	7	45	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.947+03
46	7	46	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.954+03
47	7	47	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.962+03
48	7	48	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.969+03
49	7	49	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.976+03
50	7	50	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.984+03
51	8	51	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:56.995+03
52	8	52	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.002+03
53	8	53	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.009+03
54	8	54	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.017+03
55	8	55	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.024+03
56	8	56	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.034+03
57	8	57	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.042+03
58	8	58	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.049+03
59	8	59	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.057+03
60	8	60	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.066+03
61	9	61	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.081+03
62	9	62	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.089+03
63	9	63	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.097+03
64	9	64	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.106+03
65	9	65	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.114+03
66	9	66	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.124+03
67	9	67	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.133+03
68	9	68	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.144+03
69	9	69	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.152+03
70	9	70	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.162+03
71	10	71	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.175+03
72	10	72	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.186+03
73	10	73	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.194+03
74	10	74	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.203+03
75	10	75	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.213+03
76	10	76	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.221+03
77	10	77	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.229+03
78	10	78	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.238+03
79	10	79	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.245+03
80	10	80	Практикуйте с метрономом для улучшения ритма.	2026-06-01 08:32:57.252+03
81	1	81	Практикуйте хроматическую гамму в медленном темпе с тюнером.	2026-06-01 09:20:17.419+03
82	1	81	Удерживайте каждую ноту 3 секунды, контролируя чистоту интонации.	2026-06-01 09:20:17.419+03
83	1	82	Проверьте, что аудиофайл содержит достаточно громкую запись инструмента без длинной тишины.	2026-06-01 09:35:06.622+03
84	1	82	Попробуйте загрузить WAV-файл или другой MP3, если текущая запись не распознаётся.	2026-06-01 09:35:06.622+03
90	1	83	Разберите «Концерт номер 2» по тактам и сыграйте каждый такт отдельно.	2026-06-01 10:08:11.666+03
91	1	83	Добавьте упражнения Шрадика на независимость и точность пальцев в медленном темпе.	2026-06-01 10:08:11.666+03
92	1	83	Практикуйте обычную гамму в медленном темпе с тюнером, добиваясь ровной интонации на каждой ступени.	2026-06-01 10:08:11.666+03
93	1	83	Добавьте хроматическую гамму, чтобы точнее контролировать полутоны.	2026-06-01 10:08:11.666+03
94	1	83	Снизьте темп и постепенно увеличивайте скорость с метрономом.	2026-06-01 10:08:11.666+03
100	1	84	Практикуйте обычную гамму в медленном темпе с тюнером, добиваясь ровной интонации на каждой ступени.	2026-06-01 10:17:36.826+03
101	1	84	Добавьте хроматическую гамму, чтобы точнее контролировать полутоны.	2026-06-01 10:17:36.827+03
102	1	84	Снизьте темп и постепенно увеличивайте скорость с метрономом.	2026-06-01 10:17:36.827+03
103	1	84	Сыграйте обычную гамму под метроном, следя за точным началом каждой ноты.	2026-06-01 10:17:36.827+03
104	1	84	Практикуйте упражнения Шрадика на ровность атаки и одинаковую работу пальцев.	2026-06-01 10:17:36.827+03
105	11	85	Проверьте, что аудиофайл содержит достаточно громкую запись инструмента без длинной тишины.	2026-06-01 13:50:09.188+03
106	11	85	Попробуйте загрузить WAV-файл или другой MP3, если текущая запись не распознаётся.	2026-06-01 13:50:09.188+03
107	11	86	Практикуйте обычную гамму в медленном темпе с тюнером, добиваясь ровной интонации на каждой ступени.	2026-06-01 14:17:08.195+03
108	11	86	Добавьте хроматическую гамму, чтобы точнее контролировать полутоны.	2026-06-01 14:17:08.195+03
109	11	86	Практикуйте упражнения Шрадика на ровность атаки и одинаковую работу пальцев.	2026-06-01 14:17:08.195+03
110	11	86	Практикуйте упражнения на staccato и legato попеременно.	2026-06-01 14:17:08.195+03
111	11	86	Снизьте темп и постепенно увеличивайте скорость с метрономом.	2026-06-01 14:17:08.195+03
\.


--
-- Data for Name: recordings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.recordings (id, user_id, composition_id, audio_path, status, uploaded_at) FROM stdin;
1	3	4	uploads/audio/demo-3-0.wav	completed	2026-05-22 08:32:56.481+03
2	3	5	uploads/audio/demo-3-1.wav	completed	2026-05-23 08:32:56.505+03
3	3	6	uploads/audio/demo-3-2.wav	completed	2026-05-24 08:32:56.515+03
4	3	7	uploads/audio/demo-3-3.wav	completed	2026-05-25 08:32:56.526+03
5	3	8	uploads/audio/demo-3-4.wav	completed	2026-05-26 08:32:56.536+03
6	3	9	uploads/audio/demo-3-5.wav	completed	2026-05-27 08:32:56.545+03
7	3	10	uploads/audio/demo-3-6.wav	completed	2026-05-28 08:32:56.554+03
8	3	11	uploads/audio/demo-3-7.wav	completed	2026-05-29 08:32:56.564+03
9	3	12	uploads/audio/demo-3-8.wav	completed	2026-05-30 08:32:56.575+03
10	3	13	uploads/audio/demo-3-9.wav	completed	2026-05-31 08:32:56.586+03
11	4	5	uploads/audio/demo-4-0.wav	completed	2026-05-22 08:32:56.608+03
12	4	6	uploads/audio/demo-4-1.wav	completed	2026-05-23 08:32:56.618+03
13	4	7	uploads/audio/demo-4-2.wav	completed	2026-05-24 08:32:56.627+03
14	4	8	uploads/audio/demo-4-3.wav	completed	2026-05-25 08:32:56.638+03
15	4	9	uploads/audio/demo-4-4.wav	completed	2026-05-26 08:32:56.646+03
16	4	10	uploads/audio/demo-4-5.wav	completed	2026-05-27 08:32:56.655+03
17	4	11	uploads/audio/demo-4-6.wav	completed	2026-05-28 08:32:56.665+03
18	4	12	uploads/audio/demo-4-7.wav	completed	2026-05-29 08:32:56.675+03
19	4	13	uploads/audio/demo-4-8.wav	completed	2026-05-30 08:32:56.684+03
20	4	14	uploads/audio/demo-4-9.wav	completed	2026-05-31 08:32:56.693+03
21	5	6	uploads/audio/demo-5-0.wav	completed	2026-05-22 08:32:56.714+03
22	5	7	uploads/audio/demo-5-1.wav	completed	2026-05-23 08:32:56.723+03
23	5	8	uploads/audio/demo-5-2.wav	completed	2026-05-24 08:32:56.733+03
24	5	9	uploads/audio/demo-5-3.wav	completed	2026-05-25 08:32:56.743+03
25	5	10	uploads/audio/demo-5-4.wav	completed	2026-05-26 08:32:56.753+03
26	5	11	uploads/audio/demo-5-5.wav	completed	2026-05-27 08:32:56.761+03
27	5	12	uploads/audio/demo-5-6.wav	completed	2026-05-28 08:32:56.771+03
28	5	13	uploads/audio/demo-5-7.wav	completed	2026-05-29 08:32:56.78+03
29	5	14	uploads/audio/demo-5-8.wav	completed	2026-05-30 08:32:56.789+03
30	5	15	uploads/audio/demo-5-9.wav	completed	2026-05-31 08:32:56.798+03
31	6	7	uploads/audio/demo-6-0.wav	completed	2026-05-22 08:32:56.81+03
32	6	8	uploads/audio/demo-6-1.wav	completed	2026-05-23 08:32:56.818+03
33	6	9	uploads/audio/demo-6-2.wav	completed	2026-05-24 08:32:56.826+03
34	6	10	uploads/audio/demo-6-3.wav	completed	2026-05-25 08:32:56.835+03
35	6	11	uploads/audio/demo-6-4.wav	completed	2026-05-26 08:32:56.845+03
36	6	12	uploads/audio/demo-6-5.wav	completed	2026-05-27 08:32:56.854+03
37	6	13	uploads/audio/demo-6-6.wav	completed	2026-05-28 08:32:56.864+03
38	6	14	uploads/audio/demo-6-7.wav	completed	2026-05-29 08:32:56.873+03
39	6	15	uploads/audio/demo-6-8.wav	completed	2026-05-30 08:32:56.882+03
40	6	16	uploads/audio/demo-6-9.wav	completed	2026-05-31 08:32:56.892+03
41	7	8	uploads/audio/demo-7-0.wav	completed	2026-05-22 08:32:56.906+03
42	7	9	uploads/audio/demo-7-1.wav	completed	2026-05-23 08:32:56.914+03
43	7	10	uploads/audio/demo-7-2.wav	completed	2026-05-24 08:32:56.923+03
44	7	11	uploads/audio/demo-7-3.wav	completed	2026-05-25 08:32:56.932+03
45	7	12	uploads/audio/demo-7-4.wav	completed	2026-05-26 08:32:56.941+03
46	7	13	uploads/audio/demo-7-5.wav	completed	2026-05-27 08:32:56.949+03
47	7	14	uploads/audio/demo-7-6.wav	completed	2026-05-28 08:32:56.956+03
48	7	15	uploads/audio/demo-7-7.wav	completed	2026-05-29 08:32:56.963+03
49	7	16	uploads/audio/demo-7-8.wav	completed	2026-05-30 08:32:56.971+03
50	7	17	uploads/audio/demo-7-9.wav	completed	2026-05-31 08:32:56.978+03
51	8	9	uploads/audio/demo-8-0.wav	completed	2026-05-22 08:32:56.989+03
52	8	10	uploads/audio/demo-8-1.wav	completed	2026-05-23 08:32:56.996+03
53	8	11	uploads/audio/demo-8-2.wav	completed	2026-05-24 08:32:57.003+03
54	8	12	uploads/audio/demo-8-3.wav	completed	2026-05-25 08:32:57.011+03
55	8	13	uploads/audio/demo-8-4.wav	completed	2026-05-26 08:32:57.019+03
56	8	14	uploads/audio/demo-8-5.wav	completed	2026-05-27 08:32:57.026+03
57	8	15	uploads/audio/demo-8-6.wav	completed	2026-05-28 08:32:57.035+03
58	8	16	uploads/audio/demo-8-7.wav	completed	2026-05-29 08:32:57.043+03
59	8	17	uploads/audio/demo-8-8.wav	completed	2026-05-30 08:32:57.051+03
60	8	18	uploads/audio/demo-8-9.wav	completed	2026-05-31 08:32:57.059+03
61	9	10	uploads/audio/demo-9-0.wav	completed	2026-05-22 08:32:57.074+03
62	9	11	uploads/audio/demo-9-1.wav	completed	2026-05-23 08:32:57.083+03
63	9	12	uploads/audio/demo-9-2.wav	completed	2026-05-24 08:32:57.09+03
64	9	13	uploads/audio/demo-9-3.wav	completed	2026-05-25 08:32:57.098+03
65	9	14	uploads/audio/demo-9-4.wav	completed	2026-05-26 08:32:57.107+03
66	9	15	uploads/audio/demo-9-5.wav	completed	2026-05-27 08:32:57.116+03
67	9	16	uploads/audio/demo-9-6.wav	completed	2026-05-28 08:32:57.125+03
68	9	17	uploads/audio/demo-9-7.wav	completed	2026-05-29 08:32:57.136+03
69	9	18	uploads/audio/demo-9-8.wav	completed	2026-05-30 08:32:57.146+03
70	9	19	uploads/audio/demo-9-9.wav	completed	2026-05-31 08:32:57.154+03
71	10	11	uploads/audio/demo-10-0.wav	completed	2026-05-22 08:32:57.167+03
72	10	12	uploads/audio/demo-10-1.wav	completed	2026-05-23 08:32:57.178+03
73	10	13	uploads/audio/demo-10-2.wav	completed	2026-05-24 08:32:57.188+03
74	10	14	uploads/audio/demo-10-3.wav	completed	2026-05-25 08:32:57.196+03
75	10	15	uploads/audio/demo-10-4.wav	completed	2026-05-26 08:32:57.205+03
76	10	16	uploads/audio/demo-10-5.wav	completed	2026-05-27 08:32:57.215+03
77	10	17	uploads/audio/demo-10-6.wav	completed	2026-05-28 08:32:57.222+03
78	10	18	uploads/audio/demo-10-7.wav	completed	2026-05-29 08:32:57.231+03
79	10	19	uploads/audio/demo-10-8.wav	completed	2026-05-30 08:32:57.239+03
80	10	20	uploads/audio/demo-10-9.wav	completed	2026-05-31 08:32:57.247+03
81	1	23	C:\\bru\\3_course\\2_sem\\svch\\project\\server\\uploads\\audio\\1780294807607-982440845.mp3	completed	2026-06-01 09:20:07.614+03
82	1	23	C:\\bru\\3_course\\2_sem\\svch\\project\\server\\uploads\\audio\\1780295701103-646906544.mp3	completed	2026-06-01 09:35:01.109+03
83	1	23	C:\\bru\\3_course\\2_sem\\svch\\project\\server\\uploads\\audio\\1780297120852-962628791.wav	completed	2026-06-01 09:58:41.038+03
84	1	36	C:\\bru\\3_course\\2_sem\\svch\\project\\server\\uploads\\audio\\1780297934731-375632617.wav	completed	2026-06-01 10:12:14.752+03
85	11	17	C:\\bru\\3_course\\2_sem\\svch\\project\\server\\uploads\\audio\\1780310993864-342794439.wav	completed	2026-06-01 13:49:53.91+03
86	11	33	C:\\bru\\3_course\\2_sem\\svch\\project\\server\\uploads\\audio\\1780312621117-900409196.mp3	completed	2026-06-01 14:17:01.123+03
\.


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reports (id, recording_id, total_score, intonation, rhythm, articulation, created_at) FROM stdin;
1	1	70	74	68	68	2026-05-22 08:32:56.481+03
2	2	81	94	91	59	2026-05-23 08:32:56.505+03
3	3	68	66	79	58	2026-05-24 08:32:56.515+03
4	4	79	72	78	87	2026-05-25 08:32:56.526+03
5	5	70	83	60	68	2026-05-26 08:32:56.536+03
6	6	78	77	78	79	2026-05-27 08:32:56.545+03
7	7	70	92	57	60	2026-05-28 08:32:56.554+03
8	8	81	91	59	93	2026-05-29 08:32:56.564+03
9	9	62	60	58	68	2026-05-30 08:32:56.575+03
10	10	77	59	90	82	2026-05-31 08:32:56.586+03
11	11	72	66	91	60	2026-05-22 08:32:56.608+03
12	12	71	69	72	72	2026-05-23 08:32:56.618+03
13	13	70	56	82	71	2026-05-24 08:32:56.627+03
14	14	81	82	74	87	2026-05-25 08:32:56.638+03
15	15	79	63	79	94	2026-05-26 08:32:56.646+03
16	16	75	77	79	70	2026-05-27 08:32:56.655+03
17	17	79	81	67	90	2026-05-28 08:32:56.665+03
18	18	66	83	57	57	2026-05-29 08:32:56.675+03
19	19	68	76	56	73	2026-05-30 08:32:56.684+03
20	20	80	89	63	88	2026-05-31 08:32:56.693+03
21	21	65	55	55	85	2026-05-22 08:32:56.714+03
22	22	77	86	64	80	2026-05-23 08:32:56.723+03
23	23	73	85	62	73	2026-05-24 08:32:56.733+03
24	24	72	70	58	88	2026-05-25 08:32:56.743+03
25	25	69	60	66	80	2026-05-26 08:32:56.753+03
26	26	82	67	92	88	2026-05-27 08:32:56.761+03
27	27	67	69	65	67	2026-05-28 08:32:56.771+03
28	28	80	64	91	85	2026-05-29 08:32:56.78+03
29	29	59	57	55	65	2026-05-30 08:32:56.789+03
30	30	82	67	87	92	2026-05-31 08:32:56.798+03
31	31	59	58	57	63	2026-05-22 08:32:56.81+03
32	32	74	74	69	80	2026-05-23 08:32:56.818+03
33	33	65	70	57	68	2026-05-24 08:32:56.826+03
34	34	85	78	84	92	2026-05-25 08:32:56.835+03
35	35	77	75	75	81	2026-05-26 08:32:56.845+03
36	36	72	68	85	64	2026-05-27 08:32:56.854+03
37	37	84	82	76	93	2026-05-28 08:32:56.864+03
38	38	67	79	56	66	2026-05-29 08:32:56.873+03
39	39	81	67	83	92	2026-05-30 08:32:56.882+03
40	40	78	87	86	60	2026-05-31 08:32:56.892+03
41	41	68	80	65	58	2026-05-22 08:32:56.906+03
42	42	70	62	73	76	2026-05-23 08:32:56.914+03
43	43	70	77	69	64	2026-05-24 08:32:56.923+03
44	44	76	94	65	68	2026-05-25 08:32:56.932+03
45	45	63	56	71	61	2026-05-26 08:32:56.941+03
46	46	78	56	85	94	2026-05-27 08:32:56.949+03
47	47	71	60	60	94	2026-05-28 08:32:56.956+03
48	48	76	77	78	74	2026-05-29 08:32:56.963+03
49	49	70	77	59	73	2026-05-30 08:32:56.971+03
50	50	73	75	81	62	2026-05-31 08:32:56.978+03
51	51	72	59	88	69	2026-05-22 08:32:56.989+03
52	52	72	63	93	60	2026-05-23 08:32:56.996+03
53	53	74	61	94	68	2026-05-24 08:32:57.003+03
54	54	65	60	55	81	2026-05-25 08:32:57.011+03
55	55	85	84	79	92	2026-05-26 08:32:57.019+03
56	56	69	81	68	57	2026-05-27 08:32:57.026+03
57	57	59	56	57	64	2026-05-28 08:32:57.035+03
58	58	79	90	59	89	2026-05-29 08:32:57.043+03
59	59	68	55	81	67	2026-05-30 08:32:57.051+03
60	60	75	72	64	88	2026-05-31 08:32:57.059+03
61	61	74	76	64	82	2026-05-22 08:32:57.074+03
62	62	73	71	83	66	2026-05-23 08:32:57.083+03
63	63	75	74	93	58	2026-05-24 08:32:57.09+03
64	64	71	62	77	73	2026-05-25 08:32:57.098+03
65	65	75	81	64	80	2026-05-26 08:32:57.107+03
66	66	71	80	62	72	2026-05-27 08:32:57.116+03
67	67	72	61	89	66	2026-05-28 08:32:57.125+03
68	68	63	60	60	70	2026-05-29 08:32:57.136+03
69	69	74	67	64	92	2026-05-30 08:32:57.146+03
70	70	72	66	67	84	2026-05-31 08:32:57.154+03
71	71	71	80	63	71	2026-05-22 08:32:57.167+03
72	72	75	67	93	65	2026-05-23 08:32:57.178+03
73	73	76	72	77	78	2026-05-24 08:32:57.188+03
74	74	74	55	80	86	2026-05-25 08:32:57.196+03
75	75	83	84	81	85	2026-05-26 08:32:57.205+03
76	76	80	79	74	86	2026-05-27 08:32:57.215+03
77	77	79	88	92	57	2026-05-28 08:32:57.222+03
78	78	82	88	90	67	2026-05-29 08:32:57.231+03
79	79	74	73	87	61	2026-05-30 08:32:57.239+03
80	80	64	76	59	57	2026-05-31 08:32:57.247+03
81	81	72	72	75	70	2026-06-01 09:20:17.406+03
82	82	0	0	0	0	2026-06-01 09:35:06.614+03
83	83	34	0	49	52	2026-06-01 09:58:47.889+03
84	84	73	59	78	83	2026-06-01 10:12:20.6+03
85	85	0	0	0	0	2026-06-01 13:50:09.02+03
86	86	84	66	93	93	2026-06-01 14:17:08.16+03
\.


--
-- Data for Name: user_achievements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_achievements (id, user_id, achievement_id, earned_at) FROM stdin;
1	3	1	2026-06-01 08:32:56.602+03
2	4	1	2026-06-01 08:32:56.706+03
3	5	1	2026-06-01 08:32:56.809+03
4	6	1	2026-06-01 08:32:56.902+03
5	7	1	2026-06-01 08:32:56.987+03
6	8	1	2026-06-01 08:32:57.07+03
7	9	1	2026-06-01 08:32:57.166+03
8	10	1	2026-06-01 08:32:57.254+03
9	1	1	2026-06-01 09:20:17.437+03
10	1	3	2026-06-01 09:58:47.916+03
11	11	1	2026-06-01 13:50:09.226+03
12	11	3	2026-06-01 14:17:08.213+03
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, login, email, password, role, avatar, status, instrument, registration_date) FROM stdin;
1	admin	admin@music.local	$2a$10$hRXHDEQESZEHoqXDKiadCeIl0wbvqhklRiaNq3HNeEZE5fS8UzWmu	admin	\N	active	\N	2026-06-01 08:32:54.716+03
2	admin2	admin2@music.local	$2a$10$TV4JztffLzBwiWnLse9dx.NeL.ySjSR0EWBe4IuG039/hS5VEIAK.	admin	\N	active	\N	2026-06-01 08:32:54.931+03
11	polly	avepalina@gmail.com	$2a$10$7uVx5Xf1Fp7F6pVu9zqcJe9M9toYN1Oq4kURPp4uObFSonKnqeb2.	musician	\N	active	\N	2026-06-01 08:50:08.388+03
3	musician1	musician1@music.local	$2a$10$pPTXG0yaxkNECQ4xuzs6xO8r2X1K87kNkKlpWKJV..Bo5n9rPk23u	musician	\N	active	Гитара	2026-06-01 08:32:55.112+03
4	musician2	musician2@music.local	$2a$10$mmGOhWkyhPfSVS1WXZ3xAuCcrS/EOhuQt7uvYs3S1kNTqZm.8JHbG	musician	\N	active	Флейта	2026-06-01 08:32:55.271+03
5	musician3	musician3@music.local	$2a$10$YHPZLqo4EcQnkoGCido67u/vB2iNTSIsWbL7tGofSf0IkLzE8NctO	musician	\N	active	Скрипка	2026-06-01 08:32:55.42+03
6	musician4	musician4@music.local	$2a$10$zxeL5cDnKjkd0oXbCs8XXOAv.wYGumVS9Fxy4j8dX6dhotfbso9Kq	musician	\N	active	Гитара	2026-06-01 08:32:55.564+03
7	musician5	musician5@music.local	$2a$10$Wfyi544bg43BRqAdvIkbTOqoQs00SQCMp23C6bnZhVOj1FenSOOAG	musician	\N	active	Скрипка	2026-06-01 08:32:55.723+03
8	musician6	musician6@music.local	$2a$10$pSZ4VHj.amF89fj3d7AoUOXyz.tOqr2Ke5t6eBV2/mHgif/eEqqgy	musician	\N	active	Скрипка	2026-06-01 08:32:55.898+03
9	musician7	musician7@music.local	$2a$10$H8wEJ570gjYpIhMxyd8qMuIO60hgEbsaFL5ijLNwKzamn0iSrzb2a	musician	\N	active	Гитара	2026-06-01 08:32:56.074+03
10	musician8	musician8@music.local	$2a$10$jesWCNBAUD4eEdRsWd3wdegWgwT14CRytsLfrD5YlgnfZN4tBmSli	musician	\N	active	Гитара	2026-06-01 08:32:56.24+03
\.


--
-- Name: achievements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.achievements_id_seq', 5, true);


--
-- Name: composition_suggestions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.composition_suggestions_id_seq', 9, true);


--
-- Name: compositions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.compositions_id_seq', 37, true);


--
-- Name: errors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.errors_id_seq', 5165, true);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.notifications_id_seq', 21, true);


--
-- Name: recommendations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.recommendations_id_seq', 111, true);


--
-- Name: recordings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.recordings_id_seq', 86, true);


--
-- Name: reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reports_id_seq', 86, true);


--
-- Name: user_achievements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_achievements_id_seq', 12, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 11, true);


--
-- Name: achievements achievements_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key UNIQUE (code);


--
-- Name: achievements achievements_code_key1; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key1 UNIQUE (code);


--
-- Name: achievements achievements_code_key10; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key10 UNIQUE (code);


--
-- Name: achievements achievements_code_key11; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key11 UNIQUE (code);


--
-- Name: achievements achievements_code_key12; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key12 UNIQUE (code);


--
-- Name: achievements achievements_code_key13; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key13 UNIQUE (code);


--
-- Name: achievements achievements_code_key14; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key14 UNIQUE (code);


--
-- Name: achievements achievements_code_key15; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key15 UNIQUE (code);


--
-- Name: achievements achievements_code_key16; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key16 UNIQUE (code);


--
-- Name: achievements achievements_code_key17; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key17 UNIQUE (code);


--
-- Name: achievements achievements_code_key2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key2 UNIQUE (code);


--
-- Name: achievements achievements_code_key3; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key3 UNIQUE (code);


--
-- Name: achievements achievements_code_key4; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key4 UNIQUE (code);


--
-- Name: achievements achievements_code_key5; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key5 UNIQUE (code);


--
-- Name: achievements achievements_code_key6; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key6 UNIQUE (code);


--
-- Name: achievements achievements_code_key7; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key7 UNIQUE (code);


--
-- Name: achievements achievements_code_key8; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key8 UNIQUE (code);


--
-- Name: achievements achievements_code_key9; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_code_key9 UNIQUE (code);


--
-- Name: achievements achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);


--
-- Name: composition_suggestions composition_suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.composition_suggestions
    ADD CONSTRAINT composition_suggestions_pkey PRIMARY KEY (id);


--
-- Name: compositions compositions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compositions
    ADD CONSTRAINT compositions_pkey PRIMARY KEY (id);


--
-- Name: errors errors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.errors
    ADD CONSTRAINT errors_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: recommendations recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recommendations
    ADD CONSTRAINT recommendations_pkey PRIMARY KEY (id);


--
-- Name: recordings recordings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recordings
    ADD CONSTRAINT recordings_pkey PRIMARY KEY (id);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: reports reports_recording_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_recording_id_key UNIQUE (recording_id);


--
-- Name: user_achievements user_achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_email_key1; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key1 UNIQUE (email);


--
-- Name: users users_email_key10; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key10 UNIQUE (email);


--
-- Name: users users_email_key11; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key11 UNIQUE (email);


--
-- Name: users users_email_key12; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key12 UNIQUE (email);


--
-- Name: users users_email_key13; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key13 UNIQUE (email);


--
-- Name: users users_email_key14; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key14 UNIQUE (email);


--
-- Name: users users_email_key15; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key15 UNIQUE (email);


--
-- Name: users users_email_key16; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key16 UNIQUE (email);


--
-- Name: users users_email_key17; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key17 UNIQUE (email);


--
-- Name: users users_email_key18; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key18 UNIQUE (email);


--
-- Name: users users_email_key19; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key19 UNIQUE (email);


--
-- Name: users users_email_key2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key2 UNIQUE (email);


--
-- Name: users users_email_key20; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key20 UNIQUE (email);


--
-- Name: users users_email_key21; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key21 UNIQUE (email);


--
-- Name: users users_email_key22; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key22 UNIQUE (email);


--
-- Name: users users_email_key23; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key23 UNIQUE (email);


--
-- Name: users users_email_key24; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key24 UNIQUE (email);


--
-- Name: users users_email_key3; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key3 UNIQUE (email);


--
-- Name: users users_email_key4; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key4 UNIQUE (email);


--
-- Name: users users_email_key5; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key5 UNIQUE (email);


--
-- Name: users users_email_key6; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key6 UNIQUE (email);


--
-- Name: users users_email_key7; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key7 UNIQUE (email);


--
-- Name: users users_email_key8; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key8 UNIQUE (email);


--
-- Name: users users_email_key9; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key9 UNIQUE (email);


--
-- Name: users users_login_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key UNIQUE (login);


--
-- Name: users users_login_key1; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key1 UNIQUE (login);


--
-- Name: users users_login_key10; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key10 UNIQUE (login);


--
-- Name: users users_login_key11; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key11 UNIQUE (login);


--
-- Name: users users_login_key12; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key12 UNIQUE (login);


--
-- Name: users users_login_key13; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key13 UNIQUE (login);


--
-- Name: users users_login_key14; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key14 UNIQUE (login);


--
-- Name: users users_login_key15; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key15 UNIQUE (login);


--
-- Name: users users_login_key16; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key16 UNIQUE (login);


--
-- Name: users users_login_key17; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key17 UNIQUE (login);


--
-- Name: users users_login_key18; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key18 UNIQUE (login);


--
-- Name: users users_login_key19; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key19 UNIQUE (login);


--
-- Name: users users_login_key2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key2 UNIQUE (login);


--
-- Name: users users_login_key20; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key20 UNIQUE (login);


--
-- Name: users users_login_key21; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key21 UNIQUE (login);


--
-- Name: users users_login_key22; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key22 UNIQUE (login);


--
-- Name: users users_login_key23; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key23 UNIQUE (login);


--
-- Name: users users_login_key24; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key24 UNIQUE (login);


--
-- Name: users users_login_key25; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key25 UNIQUE (login);


--
-- Name: users users_login_key3; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key3 UNIQUE (login);


--
-- Name: users users_login_key4; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key4 UNIQUE (login);


--
-- Name: users users_login_key5; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key5 UNIQUE (login);


--
-- Name: users users_login_key6; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key6 UNIQUE (login);


--
-- Name: users users_login_key7; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key7 UNIQUE (login);


--
-- Name: users users_login_key8; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key8 UNIQUE (login);


--
-- Name: users users_login_key9; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key9 UNIQUE (login);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: composition_suggestions composition_suggestions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.composition_suggestions
    ADD CONSTRAINT composition_suggestions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: errors errors_report_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.errors
    ADD CONSTRAINT errors_report_id_fkey FOREIGN KEY (report_id) REFERENCES public.reports(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: recommendations recommendations_report_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recommendations
    ADD CONSTRAINT recommendations_report_id_fkey FOREIGN KEY (report_id) REFERENCES public.reports(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: recommendations recommendations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recommendations
    ADD CONSTRAINT recommendations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: recordings recordings_composition_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recordings
    ADD CONSTRAINT recordings_composition_id_fkey FOREIGN KEY (composition_id) REFERENCES public.compositions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: recordings recordings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recordings
    ADD CONSTRAINT recordings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: reports reports_recording_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_recording_id_fkey FOREIGN KEY (recording_id) REFERENCES public.recordings(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_achievements user_achievements_achievement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_achievement_id_fkey FOREIGN KEY (achievement_id) REFERENCES public.achievements(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_achievements user_achievements_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict TMntClileTn2d1xnQlbxlAMb5pJoSePHFy7OlV8ArSdpdh3t2fnsil8NsoQEajI

