--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases
--

DROP DATABASE admin;
DROP DATABASE curveball;




--
-- Drop roles
--

DROP ROLE admin;
DROP ROLE postgres;


--
-- Roles
--

CREATE ROLE admin;
ALTER ROLE admin WITH SUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md50ad6d5512f7e31720e807302e404fcbf';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;






--
-- Database creation
--

CREATE DATABASE admin WITH TEMPLATE = template0 OWNER = postgres;
CREATE DATABASE curveball WITH TEMPLATE = template0 OWNER = admin;
REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


\connect admin

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4 (Debian 10.4-2.pgdg90+1)
-- Dumped by pg_dump version 10.4 (Debian 10.4-2.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- PostgreSQL database dump complete
--

\connect curveball

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4 (Debian 10.4-2.pgdg90+1)
-- Dumped by pg_dump version 10.4 (Debian 10.4-2.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: answer_submission; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.answer_submission (
    question uuid NOT NULL,
    "user" uuid NOT NULL,
    choice uuid NOT NULL,
    submitted timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.answer_submission OWNER TO admin;

--
-- Name: prizes; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.prizes (
    prize_id integer NOT NULL,
    prize text,
    sent boolean DEFAULT false,
    amount_paid integer,
    user_id uuid NOT NULL,
    quiz_id uuid NOT NULL
);


ALTER TABLE public.prizes OWNER TO admin;

--
-- Name: prizes_prize_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.prizes_prize_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.prizes_prize_id_seq OWNER TO admin;

--
-- Name: prizes_prize_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.prizes_prize_id_seq OWNED BY public.prizes.prize_id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.questions (
    question_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    question text NOT NULL,
    sent timestamp without time zone,
    expired timestamp without time zone,
    question_num integer NOT NULL,
    quiz_id uuid NOT NULL
);


ALTER TABLE public.questions OWNER TO admin;

--
-- Name: questions_choices; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.questions_choices (
    choice_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    question uuid,
    text character varying(64) NOT NULL,
    is_answer boolean DEFAULT false NOT NULL
);


ALTER TABLE public.questions_choices OWNER TO admin;

--
-- Name: quizzes; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.quizzes (
    quiz_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    active boolean DEFAULT false NOT NULL,
    title text NOT NULL,
    pot_amount bigint DEFAULT '0'::bigint NOT NULL,
    completed boolean DEFAULT false NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.quizzes OWNER TO admin;

--
-- Name: shows; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.shows (
    show_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "time" timestamp without time zone NOT NULL,
    title character varying(64) NOT NULL
);


ALTER TABLE public.shows OWNER TO admin;

--
-- Name: users; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.users (
    user_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255),
    phone character varying(15),
    enabled boolean DEFAULT true NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    last_accessed timestamp without time zone DEFAULT now() NOT NULL,
    referred boolean DEFAULT false NOT NULL,
    username character varying(15) NOT NULL,
    password character varying(255) NOT NULL,
    photo text DEFAULT 'http://pixelartmaker.com/art/a27e62d4a45d2bc.png'::text NOT NULL
);


ALTER TABLE public.users OWNER TO admin;

--
-- Name: winners; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.winners (
    winner_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    quiz uuid NOT NULL,
    "user" uuid,
    amount_won integer NOT NULL
);


ALTER TABLE public.winners OWNER TO admin;

--
-- Name: prizes prize_id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.prizes ALTER COLUMN prize_id SET DEFAULT nextval('public.prizes_prize_id_seq'::regclass);


--
-- Data for Name: answer_submission; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.answer_submission (question, "user", choice, submitted) FROM stdin;
\.


--
-- Data for Name: prizes; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.prizes (prize_id, prize, sent, amount_paid, user_id, quiz_id) FROM stdin;
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.questions (question_id, created, question, sent, expired, question_num, quiz_id) FROM stdin;
e2773d3f-0e16-41b5-accc-608a1251f18b	2018-06-16 01:43:42.229217	What is your favorite color?	\N	\N	1	7f0dccf9-e128-4bf3-b0e1-f9fee1793e21
3c9e8fae-7ca1-4249-a799-f2d8e9fb355f	2018-06-16 01:43:42.263443	What is your favorite animal?	\N	\N	2	7f0dccf9-e128-4bf3-b0e1-f9fee1793e21
\.


--
-- Data for Name: questions_choices; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.questions_choices (choice_id, question, text, is_answer) FROM stdin;
ea50520c-8612-4895-a301-11ac88eb08a3	e2773d3f-0e16-41b5-accc-608a1251f18b	Blue	f
9493863b-d35c-4cf5-97c9-2943f7d67e5c	e2773d3f-0e16-41b5-accc-608a1251f18b	Red	f
2724b5cb-d480-4a0f-95a3-7ee7bddaef06	e2773d3f-0e16-41b5-accc-608a1251f18b	Green	t
49943c14-204d-4ca3-a4db-531b4e5af48b	3c9e8fae-7ca1-4249-a799-f2d8e9fb355f	Cat	f
31ee380e-ba4d-4da8-a22b-5be0bcdc5568	3c9e8fae-7ca1-4249-a799-f2d8e9fb355f	Dog	f
32f9c294-4385-4c88-9bb3-c2640031bb20	3c9e8fae-7ca1-4249-a799-f2d8e9fb355f	Watermelon	t
\.


--
-- Data for Name: quizzes; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.quizzes (quiz_id, active, title, pot_amount, completed, created) FROM stdin;
7f0dccf9-e128-4bf3-b0e1-f9fee1793e21	t	Test Quiz	50000	f	2018-06-12 03:02:06.752574
\.


--
-- Data for Name: shows; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.shows (show_id, "time", title) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.users (user_id, name, phone, enabled, created, last_accessed, referred, username, password, photo) FROM stdin;
13923882-0c8e-4821-9663-ed567a46867f	test user	111-111-1111	t	2018-06-10 17:51:06.365497	2018-06-10 17:51:06.365497	f	testman	$2b$10$6DkvmCDTMpT/Lqq12r6bK.VplNT0VU5XmDdCRIEGD2ZTPs0Y0No0S	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
1d0719d5-78fa-4d71-ae88-46f2d1201c89	test user	111-111-1111	t	2018-06-10 17:54:21.715256	2018-06-10 17:54:21.715256	f	testman1	$2b$10$DzGXvMoLwjH229m5pNtLE.AXbKBbG5.utjhE2AHwr2dsyOkklmea2	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
227da329-fd3c-43ba-b415-349250ebfb12	test user	111-111-1111	t	2018-06-10 17:56:02.826216	2018-06-10 17:56:02.826216	f	testman2	$2b$10$Hp6yaEjdSqUNms0.J/mIeOuFErHr3K/Q85/9zsKKGPKp5tydZSnia	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
548cd4ca-63c3-4bcc-96c7-18dde2c91ee0	test user	111-111-1111	t	2018-06-10 17:56:38.21155	2018-06-10 17:56:38.21155	f	testman3	$2b$10$Q6SCynGTzkKdyqVcVtvCgO3Jed11mcI8LFcN2fxfrnqfvFR5vTLce	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
b76591b5-bb44-4668-a7d8-0ec37dead1bc	test user	111-111-1111	t	2018-06-10 18:02:44.187851	2018-06-10 18:02:44.187851	f	testman4	$2b$10$cMaqReIBCVoE/TBEIuV6PeOehl7q2zUA27J5HB7wHuTsIZ7pu2L02	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
73c95583-1f8f-459e-bdff-74a7f91115b7	test user	111-111-1111	t	2018-06-10 18:51:41.439999	2018-06-10 18:51:41.439999	f	testman6	$2b$10$Eor8xto22/cMxR.cE43LSu/X0jrlVmU6AbuuOgvvNFlI7AupZ2R.e	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
01b68408-6a54-4d18-a3d6-52a6dea3edbf	test user	111-111-1111	t	2018-06-10 19:12:43.000996	2018-06-10 19:12:43.000996	f	testman9	$2b$10$AUTq0/SbNZq97WUPfFUkZOukWF9V6/601dffIqhXv0X1hr3N/OPq.	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
b27ed9fa-9ddb-4212-99a0-51be605a3ef0	newName	newPhone	t	2018-06-11 01:51:43.120488	2018-06-11 01:51:43.120488	f	94bb1d95-5e52-4	$2b$10$Wnm/9S4nlcWULKRFIev.EO9OVvnJzmVKBqiaSmsu8GF9Vk3pYOr4O	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
8441ddb2-fe5d-4cc7-97bd-d54bfe37bf7a	test user	111-111-1111	t	2018-06-11 01:29:32.521042	2018-06-11 01:29:32.521042	f	testman10	$2b$10$mULlaW0SF02g5L7DZaXCX.mrmIfAy4MjxBkfmGNbtrhsGGGJCjedW	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
b7220cdc-a6ff-46e5-ad11-4b33a8ca5bfd	test-user	phone	t	2018-06-11 01:38:34.070821	2018-06-11 01:38:34.070821	f	1d6c2da5-4812-4	$2b$10$ITZiFIq7qMVq9MtxovGkUuYae0XvWwIzn2Z0nFZICgalGPxg5MwY6	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
85173069-1682-43bd-b0f0-b68a00fb8d2a	test-user	phone	t	2018-06-11 01:40:03.191973	2018-06-11 01:40:03.191973	f	54cc1334-b9b5-4	$2b$10$IxR7ErOvXIdOiRIkq8M5yeg8xCYgH5Xg0OWJuBxqpMIg5slkRBxbK	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
79ace820-df4b-4f30-b10a-06d2f8b30c19	test-user	phone	t	2018-06-11 01:40:59.222925	2018-06-11 01:40:59.222925	f	128f6550-093a-4	$2b$10$YujhVF4rIcOMCftH8Li3F.4/rq.fgmc9/A3tT9pbo/9Bu1DDOZx16	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
532ed3a7-90bb-4b4b-aa21-379b83a289a4	test-user	phone	t	2018-06-11 01:41:20.16305	2018-06-11 01:41:20.16305	f	62ae380b-e814-4	$2b$10$NaUIZmi3XxQs8i4wDbkNOuQacWdzdrJ.VbQn4RgWGI27KWJt4O7lG	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
4acffd88-df45-4ffa-a063-f7f609c709b6	newName	newPhone	t	2018-06-11 01:42:22.519429	2018-06-11 01:42:22.519429	f	fa112201-8596-4	$2b$10$XuAbFT0/hraNQIh.vXps1e5LXzW1rPTGX.4gnevnVg1cwo1Y.J3za	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
bba0a535-8893-4eae-b359-30c9c1edcfad	newName	newPhone	t	2018-06-11 01:46:16.567157	2018-06-11 01:46:16.567157	f	a410334a-b879-4	$2b$10$P6qVwnZRNXJ3UwJvSWbtLulkYlCi1WbKspD1WzmQbLFdptRCrJpwa	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
b5f37d99-d7ec-416d-8682-376c4813db29	newName	newPhone	t	2018-06-11 01:46:59.584793	2018-06-11 01:46:59.584793	f	3833a944-a1c0-4	$2b$10$KlGN5i7JLndjqgMLDt1nBetVDdCQZqzNwDCv1g57zxxhbXyJHNwAS	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
a591d8e8-a4ea-4c48-bdee-d4c9fb0ce89f	newName	newPhone	t	2018-06-11 01:47:26.823583	2018-06-11 01:47:26.823583	f	eafd82ba-1ab7-4	$2b$10$vglM8.FfJmOEG44Ly5Ed8uo7PSCro5CkKne0T1o8SYW4.aL815E4y	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
61320848-3971-4664-835f-f968962defb3	newName	newPhone	t	2018-06-11 01:48:40.462858	2018-06-11 01:48:40.462858	f	522682f9-a5f8-4	$2b$10$hrbPJS8jDSK7lzUStxtmM.lLIFS3wj4XZEkS9ug230/CiBMnFlIR6	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
ade6ef06-dfa3-4f78-85c3-a9daadd81e21	newName	newPhone	t	2018-06-11 01:49:25.479212	2018-06-11 01:49:25.479212	f	2a118431-30fd-4	$2b$10$FZKui5NifhUJ3NSBYZXU5ORhTe4lLIYVnQBus7kpYNZUngDqQEKum	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
75fb47fb-a9eb-4107-87ec-2f410dbe006d	newName	newPhone	t	2018-06-11 01:49:35.482694	2018-06-11 01:49:35.482694	f	6e7b4032-0f74-4	$2b$10$5huUwKP8SRkk9l1u7LbwouRmZFBj/g48PeHeSPAUxxpjKv6lLn5Fa	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
b4ecc7fa-4779-440c-a252-71bf1d853b46	newName	newPhone	t	2018-06-11 01:49:48.968565	2018-06-11 01:49:48.968565	f	e2175c28-4834-4	$2b$10$ZbrqvZrsnxoiuFeVDnORNeJDBJqzXU6DCb07nKJeSWoLtZf0CFdcS	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
63251c19-fa3f-4bd8-b0fe-110c49b3f58f	newName	newPhone	t	2018-06-11 01:49:56.123259	2018-06-11 01:49:56.123259	f	67c45d9f-4c02-4	$2b$10$CwSXoay..QyCguMu.DyKq..Al0k1ILCen3ZuVNNG1q6Y8pV90Fllq	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
8a7a861b-c3ce-4fac-b827-daf0e135aca3	newName	newPhone	t	2018-06-11 01:50:16.871913	2018-06-11 01:50:16.871913	f	916e0db0-dc1f-4	$2b$10$GSOdiird/pI1Bs3uMFct1..98HPpZ7WqymJXaeC6elmLBvYqEsV2G	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
ab1a038d-d9b0-4dc9-92b8-c5143d82f82b	test-user	phone	t	2018-06-11 01:51:43.302329	2018-06-11 01:51:43.302329	f	166b4b03-20ad-4	$2b$10$hZ7527ZkP79VxMXE17dBeO6aceTzUOQM9WPr0M4e6HCod2b1PoFfW	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
51910bae-19ab-4498-bf99-b00919b66340	newName	newPhone	t	2018-06-11 01:51:51.085445	2018-06-11 01:51:51.085445	f	d2f31a37-255e-4	$2b$10$5NNz1xWNvPC9f292FI18iOIc4MZrhc5gpnv68HzVSEyuKu8/hVcBu	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
7eb83466-e6c6-48e5-aac4-cc26d15287ec	test-user	phone	t	2018-06-11 01:51:51.246011	2018-06-11 01:51:51.246011	f	8afa9592-ead2-4	$2b$10$yZ5SA2IqfeN9xw5JpPWPhuxgQ.2YzWuuUKD7Asw7r6yuFQheWPgYK	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
3bfd8212-8f5a-4993-b4b7-6c156ede072f	newName	newPhone	t	2018-06-11 01:53:57.779579	2018-06-11 01:53:57.779579	f	13e41574-288f-4	$2b$10$NHNwtcYOd0hvV9OPAhXiduv3g2dRaA0n0.eHQkYYcosxVJV5.3RUa	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
f66e042d-ae06-4af2-8d97-f46ea03ee45a	test-user	phone	t	2018-06-11 01:53:57.937254	2018-06-11 01:53:57.937254	f	30f5f284-7f85-4	$2b$10$1iYa4H7h5JJIHPVKpaqjRuOz1AzaY7UjbOgd0kzbLxXQpPYjyvjYu	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
4b8162f4-5b1d-441f-aefc-46495baf740b	test-user	phone	t	2018-06-14 03:05:19.570527	2018-06-14 03:05:19.570527	f	41775193-2af1-4	$2b$10$bb7bhtJisIqra.2f.V0f8uPGDyhaps8FjECmragfvyZ1ljuusqtfq	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
17a31c24-f7a9-4c50-a627-7f5fcbd22788	test-user	phone	t	2018-06-14 03:05:19.73063	2018-06-14 03:05:19.73063	f	d17c9f64-42f8-4	$2b$10$FNAzcgAsMbWirc.NfndJGOvROJZLTa5cVt/b10vVSD9CsD9p44Vf.	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
d9bff66a-a9e3-456b-b200-633fe3a13436	test-user	phone	t	2018-06-14 03:05:30.484448	2018-06-14 03:05:30.484448	f	1aacbd74-e057-4	$2b$10$BoVJ.57Wz7g5fATdh9F17.ctTV2KU9G9eMsEv3HJ7ZzF0qZDfo80S	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
c08f4a3c-8d53-4e36-b9aa-c417e904e9ca	test-user	phone	t	2018-06-14 03:05:30.63486	2018-06-14 03:05:30.63486	f	35f481e6-eb8d-4	$2b$10$BYVxeghEe6KcbhGgxkye6uXiV433jZTtTM6UTABchp9dvrUNiue1q	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
7dcf0191-bed3-453c-a871-7f2fb73138cd	test-user	phone	t	2018-06-14 03:11:57.756767	2018-06-14 03:11:57.756767	f	504cf4e7-4e77-4	$2b$10$wP.1JHmBPYTLJUwlU17/3usYEOmYLFrQ5DXINTiGSA4Lx1H356d5G	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
578df1cb-3e64-4042-bfa9-ec79c28ea3b9	test-user	phone	t	2018-06-14 03:11:57.901932	2018-06-14 03:11:57.901932	f	9eb3661d-73ca-4	$2b$10$Ffowba31w8NoUKFoZZcRtuO62yhAw8SYfO12.PCf9lmp43XW5SP/a	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
2e1bdc7e-607f-4d6d-b4e3-1e4c4767cf86	test-user	phone	t	2018-06-14 03:13:01.812891	2018-06-14 03:13:01.812891	f	39d26fb0-5014-4	$2b$10$ay/Dr260jiOn8BlaCqo5leYC7J7wF1Sd1X6CMFboVaccEzEjjIxry	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
a1ce6fe4-fc18-4e36-af64-6c87d8cf7325	test-user	phone	t	2018-06-14 03:13:01.957688	2018-06-14 03:13:01.957688	f	4cc11f30-1c41-4	$2b$10$7Jmv7BfFX.yVcLHzjhdGGu5QMx8QrFMTtyRJGaOoChVQm9PtaHidm	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
e4df093a-97b7-4d35-9df7-38079bf87ef8	test-user	phone	t	2018-06-14 03:16:37.179137	2018-06-14 03:16:37.179137	f	24568447-d24f-4	$2b$10$hMgoViX4GMQnVHoDsb/yqu.nwR.Vv.kq6KeK4VZgd4vr69LajvBsC	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
8b70719a-5f07-4abd-a281-7ad531ceb4e2	test-user	phone	t	2018-06-14 03:16:37.324605	2018-06-14 03:16:37.324605	f	10af66f3-bda6-4	$2b$10$mPjEQw9ocUy6/Kp9AxxFNunrDfxSFcPj7LaDQ6WHmn3jbevjZfZwK	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
15b89977-5443-463b-a5ce-25c89ef8acdb	test-user	phone	t	2018-06-14 03:16:56.671267	2018-06-14 03:16:56.671267	f	b5a5f7dc-c128-4	$2b$10$qTwsaNYZOGWvoGHPcj7vSuK2RSsub0N.XQuP8Vy7SPqfj55AzV.MS	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
65dbbda9-b078-40ed-83c8-2db0e3c7b0a8	test-user	phone	t	2018-06-14 03:16:56.818209	2018-06-14 03:16:56.818209	f	977ee045-b85c-4	$2b$10$EaMZWgQTd9VNPkFqMmEeAegDNF6jyn.a/SH8AzK1SjSh/SI8mfLsK	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
e9bdbff8-38b6-4d5e-b2cd-cd5d7ba8fbd9	test-user	phone	t	2018-06-14 03:19:16.816574	2018-06-14 03:19:16.816574	f	05992cd8-cd96-4	$2b$10$eH/4xSqFlMUmIOvvSiwmje89HmN01qV2swWB4JB19.pVGyWm5xJ8G	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
b2f90fc3-853e-4dba-b7fa-93a0a4803967	test-user	phone	t	2018-06-14 03:19:16.965242	2018-06-14 03:19:16.965242	f	7c19a5f3-8be5-4	$2b$10$WrP4wKvFb1PUeMcOUruYgeeBGvebEpFCBkHR3s906SVhS17KdjOPO	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
17ca660f-1167-4aec-8912-3c5f6a1f886d	test-user	phone	t	2018-06-14 03:22:32.091977	2018-06-14 03:22:32.091977	f	699bd381-aaaa-4	$2b$10$tVmZNsyjkcootmK5632YT.foH8wMuhfxNWgJ374/0hbIvT12Fwr2q	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
bb3e28e0-5e5c-4f67-849d-c50c31726829	test-user	phone	t	2018-06-14 03:22:32.268567	2018-06-14 03:22:32.268567	f	9c031993-9012-4	$2b$10$QaVNq9h7YIu1D4p6DIieyeHigwTi1wOdzLF4mmTuv06snAjh8jD3O	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
11d129f3-a464-45f0-a797-97d5c350e4bd	test-user	phone	t	2018-06-14 03:24:01.480408	2018-06-14 03:24:01.480408	f	c875fda3-5110-4	$2b$10$5B/7woykO2CyzcUF9K1ZEe12vqOL7Tg1BRW0bT8I5ree4C76K00m.	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
f2685811-fef6-4410-a3e3-fd53d68517c0	test-user	phone	t	2018-06-14 03:24:01.660609	2018-06-14 03:24:01.660609	f	6996861c-9102-4	$2b$10$eWibOwZ7tD3mvAD2NWVt5e1Nm9eaj2Yjy7kkdKiC6SYkPQ/XEqvsm	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
4315b418-4040-46f3-9709-731907095f13	test-user	phone	t	2018-06-14 03:26:57.65112	2018-06-14 03:26:57.65112	f	f0896e59-bfad-4	$2b$10$XwlfyKrxhlF3Kxz.hy3ijOtvd8vEB5ZxqJerJ8yBpCWATaml6WByq	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
994585ff-e255-412c-a8a4-35f4365efc7c	test-user	phone	t	2018-06-14 03:26:57.830714	2018-06-14 03:26:57.830714	f	f74e788f-fce8-4	$2b$10$d20zAGHsNMfXnyMr.bYy1ueNxUza4ZHXTnj7TRWzV7oR680UHL01y	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
88c87961-2d3b-49a4-a4c6-7a0f386e5040	test-user	phone	t	2018-06-14 03:29:19.723891	2018-06-14 03:29:19.723891	f	eedf1b3c-c734-4	$2b$10$jZOHrf9Vf0JVyb9ifiVSOur2x7gX6aaALW4970r0dz0tUs1wq/J1q	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
2a4a7c93-bcf9-4dbe-ad91-842742168e7b	test-user	phone	t	2018-06-14 03:29:19.924925	2018-06-14 03:29:19.924925	f	7946fde1-7a2f-4	$2b$10$0lISrvEgaAxWlJoT5aYLSuRZi.3DVbaZk1xtNHoibRASyv2WfGNsa	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
bde7f0cf-586d-4c83-972b-8f2b27d42756	test-user	phone	t	2018-06-14 03:31:24.216275	2018-06-14 03:31:24.216275	f	3c26dc66-8367-4	$2b$10$bpkJcpQX0JHKLQHVfWjR1OMZDVXH4I9B6541BOlK.tzYn9epeIlia	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
51e382e7-0423-4f25-b86a-c73f93dcd799	test-user	phone	t	2018-06-14 03:31:24.404113	2018-06-14 03:31:24.404113	f	0a283ac0-b114-4	$2b$10$H5N6y.StXnxBYY4cvUEls.iX32pR6csP8Z4WNTyx758pPtICIjdUi	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
5d611fb3-5616-4a10-a40d-837f4c6d2853	test-user	phone	t	2018-06-14 03:34:24.254659	2018-06-14 03:34:24.254659	f	e23996fd-aae3-4	$2b$10$A5.YkEDZ3N1xQU/uU4lvs.MZVITLIT/TEk0BDPKUYSvVRqz5oiAsq	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
25e6b670-e9a7-4b5b-aef5-f23fd641633f	test-user	phone	t	2018-06-14 03:34:24.429356	2018-06-14 03:34:24.429356	f	a4447fab-4313-4	$2b$10$nufXxCDgHKaRd5/p4AyLteJODJULodxEX.StUsbJ9UF4WBMq6Omqe	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
f250ef78-816e-44d8-95c4-322099351520	test-user	phone	t	2018-06-14 03:35:08.741566	2018-06-14 03:35:08.741566	f	ad9218a6-cf83-4	$2b$10$UPPu0Rd97SlIF/UFQz2HpOHLjhfQi1gVKhNvw3BYJZWElX9Y8wmji	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
d3c4535b-9071-4cce-83a5-fdeb6f96a63c	test-user	phone	t	2018-06-14 03:35:08.906869	2018-06-14 03:35:08.906869	f	b26c87b4-c2f1-4	$2b$10$egxIWDwxQrvZiIX34Z.twu4.ruC21sUE1zKA2Uu1D.aUtr/.K1yUO	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
3ed7e70f-9d0e-4807-898f-3eda7dc33f9a	test-user	phone	t	2018-06-14 03:36:05.304341	2018-06-14 03:36:05.304341	f	3ec31832-1136-4	$2b$10$NGNPGx0MZokjgukm3hSKq.ozOfZlwXj4eMIyrH9MlCqcJ1K37Qn9O	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
b25eacbd-a6f1-4c6e-8f43-107ad3805898	test-user	phone	t	2018-06-14 03:36:05.470741	2018-06-14 03:36:05.470741	f	d1c5f1d5-a997-4	$2b$10$.OT9FpzCYbGj9IDL7doHyeB1vsynM.nSDUzCgnG6PIKbn8BWTHYrq	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
0b2c733e-294b-4f02-b087-b5ff77b61109	test-user	phone	t	2018-06-14 03:36:47.988095	2018-06-14 03:36:47.988095	f	a8d9180d-07e7-4	$2b$10$mtJ4ML7qR4C4KgDU0GkEbeZcvDctU/Uh7pF0Is1/ezYXD9PJ4ATCi	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
f6146052-cd0e-4436-ae46-4e5fb21f3f93	test-user	phone	t	2018-06-14 03:36:48.158348	2018-06-14 03:36:48.158348	f	80d3f762-5c81-4	$2b$10$H7JKA0CNHr/87/5JvXo8gur9cWTXcwMoaspU38GaSq8Wr3KXh/umS	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
e265cad7-41f4-4eba-ae8b-08cfbb237a0d	newName	newPhone	t	2018-06-14 03:39:15.981601	2018-06-14 03:39:15.981601	f	c063db8d-8d06-4	$2b$10$v7IHJg6H6GGze4oEDqT6BOlGmKdgCKvZWC1nZbYOTCQlFZF5EXlzC	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
20d2e45a-c7fe-4da8-9902-c915f7952e05	test-user	phone	t	2018-06-14 03:39:16.150912	2018-06-14 03:39:16.150912	f	4ce781f5-16fb-4	$2b$10$K4ju7HfVsuYtDHRk9rUcHOh3NLqIuI3oqLuSOV.Tku78JwCSgLx7W	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
fce9282c-4ccf-4689-85d0-43f827943ab0	newName	newPhone	t	2018-06-14 10:41:59	2018-06-14 10:41:59	f	ba16d00a-a102-4	$2b$10$Tpp1ZcDq04pypcbFA4GGzee.8xz4rlLl1.3dXBbqQNd/KsuQB8.3S	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
5eabefbc-8645-4813-a283-80b66137d117	test-user	phone	t	2018-06-14 03:41:59.290995	2018-06-14 03:41:59.290995	f	a3e50a41-e62a-4	$2b$10$JlUcm8s4mv4vKma4.ZvxRuJqrCmv4032hXeCnGK71F3Y0TxbSBq32	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
1f9a6e07-78c2-44a6-acde-59b44f4d0c07	test user	111-111-1111	t	2018-06-14 04:54:49.185309	2018-06-14 04:54:49.185309	f	testman11	$2b$10$HNgpGIBA6AzWzXUv.QY0Mu.aDDAI45qZGFIFt2ZeJOaXFV7xaxNJC	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
5f7be1e4-60fc-486d-ae26-7276c9056479	test user4	444-444-5554	t	2018-06-10 18:03:51.233868	2018-06-10 18:03:51.233868	f	testman5	$2b$10$cYvr7IZD1WyRg12rT837Ke/L.SapRSitDrGCHwLs/vkV8DO/X350a	https://d2gg9evh47fn9z.cloudfront.net/800px_COLOURBOX25103401.jpg
0fe92240-41cc-48fb-b54d-be685af240f4	newName	newPhone	t	2018-06-14 05:09:26.717431	2018-06-14 05:09:26.717431	f	6c8d3e7b-af6b-4	$2b$10$H3CXF62gUlieEhyALmoQx.gRS3m8mM0F6CszOKO3IOjbFwK7oEcu2	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
fe88b870-b8a1-4d3b-8c55-1535609cf699	test-user	phone	t	2018-06-14 05:09:26.903325	2018-06-14 05:09:26.903325	f	0876fc7e-2ed8-4	$2b$10$tEngG36bOYzFiT/m2eUnNOYjMCPWfGJum2rA0AqzT98QWwhEjN.tq	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
2dce8fab-2ebb-44d7-849c-39559dac1dfa	newName	newPhone	t	2018-06-14 05:11:48.222762	2018-06-14 05:11:48.222762	f	7bd4b43d-1b68-4	$2b$10$C7gkJTRwg3lq3JOF5tBwfOLRGmwFGWVyBv0ifsjhvRuX/Wb1udh.q	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
36095fd5-2d9a-4f2c-8449-6fb67e02041c	test-user	phone	t	2018-06-14 05:11:48.4034	2018-06-14 05:11:48.4034	f	3d466005-e779-4	$2b$10$pJhNw6YgJQChBa3.UbOjluESDcsxFAqkRu6a1YBn95Jzx8XHQQet6	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
2dbcf8d1-12dc-46ba-8b38-e22e81a82b71	test user	111-111-1111	t	2018-06-16 05:22:42.063564	2018-06-16 05:22:42.063564	f	testman12	$2b$10$eXIfsUJdraKbpqYqHaK2/ePbbKfnPF3kA1h42gWZapMYrpVfTORWS	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
4a69a364-6303-41a5-9684-6c81455e17b7	\N	\N	t	2018-06-16 05:26:03.525169	2018-06-16 05:26:03.525169	f	e21c75b3-00ba-4	$2b$10$TikbSutwqSTsoI5.xBezC.VGOzBikxL8kFJxXlSFOxJsRejJyxQR.	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
f8680a70-3ccc-4e72-9129-f4a171f6de8d	\N	\N	t	2018-06-16 05:27:21.912715	2018-06-16 05:27:21.912715	f	5fe31772-ec75-4	$2b$10$6o4cg0mg1oaB9fpYWPcTE.BPsmOCXmf3ZDYkqitjHc9I3OsmJpuUq	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
de189d0a-7c01-4130-9e96-ecc43894ede1	\N	\N	t	2018-06-16 05:27:22.099431	2018-06-16 05:27:22.099431	f	213c5669-d35b-4	$2b$10$BjcclqC7nWVVFxvsDriT1Otj7P7OgbHj5GtJqcHghzaj8TUmZmwA2	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
976fb00f-d3c7-42e1-844d-ca6ec8eafee0	\N	\N	t	2018-06-16 05:27:22.282047	2018-06-16 05:27:22.282047	f	ee82b4cb-31d8-4	$2b$10$yy9bkNJdrZ1VmoeLtFQg2e0lYmSUI6lHjPaYCUbTY.q6VaRqlNyVO	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
2e856635-91f2-4538-8c02-75653d8e521d	\N	\N	t	2018-06-16 05:27:42.463271	2018-06-16 05:27:42.463271	f	c8f3f0a8-e536-4	$2b$10$8y9qRN.vnYjGQg8mnUWYsOL/Hntt0G8HFjIZ8CXIqkT4PZnvQ5mRu	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
b684b356-1cb0-47eb-9071-df8dd3afa419	\N	\N	t	2018-06-16 05:27:42.651543	2018-06-16 05:27:42.651543	f	d73f2d5f-b1b4-4	$2b$10$gbfxz7bxXK6WqW5gC2wmH.e68gGETxNa86YUgepabPzWfL4BllUFO	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
0af5c2cf-964b-45f5-8c53-c493dce53c21	\N	\N	t	2018-06-16 05:27:42.830635	2018-06-16 05:27:42.830635	f	ed995819-dd5b-4	$2b$10$kCJWO4N0FjSkawCpVGEV.ej0jlvuE.6DWobi8AoI6E92YdQDrAvVy	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
4e056e08-d596-4396-98ed-a3de4b97d68e	\N	\N	t	2018-06-16 05:28:23.68268	2018-06-16 05:28:23.68268	f	5c421bea-ff4a-4	$2b$10$OqFI7HMfFWDjAeETS2ltMO.39/qRPM/2PF5vUTROHz61/yn5yL5la	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
e4007cfe-21f0-41e5-ac25-d41fed3db100	\N	\N	t	2018-06-16 05:28:23.862567	2018-06-16 05:28:23.862567	f	d72ab649-aba7-4	$2b$10$1QB1GL5cOqLiMq/JQB0YIOLJUFyYN0mtQctCN4av/N7UQOl09L1VW	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
1951c897-c96c-463b-8f3b-d89df860d3e1	\N	\N	t	2018-06-16 05:28:24.045897	2018-06-16 05:28:24.045897	f	28389a02-5616-4	$2b$10$x0bxwZQO1f25A8W/6iE0pu.HYyOi1hGtD9nlub1PELgZ1UvxQeMx.	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
b24ae3eb-5ce1-4cfc-95ac-cda8689f5101	\N	\N	t	2018-06-16 05:29:39.378614	2018-06-16 05:29:39.378614	f	ecf0322f-429d-4	$2b$10$GmdNCfuH4r2Nx0r2T.2yuuW8i9tPAEj9t2B/Wn.UPB09lgiBlSSwK	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
00ac10da-9222-4348-bfff-e5e6d9f8a037	\N	\N	t	2018-06-16 05:29:39.608626	2018-06-16 05:29:39.608626	f	5d4256c7-af24-4	$2b$10$fTA6gT8F4bxqF80bW/T0wekqp63miRWXXa/MSlCWrccTEFLJZoUmi	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
288f5c55-98a4-43bb-bec3-8050d3e8d9a1	\N	\N	t	2018-06-16 05:29:39.787202	2018-06-16 05:29:39.787202	f	9cc864c1-3300-4	$2b$10$7WGhYteGuuro/rFu0tbjteTZF0gUV.AdyHH4c1eFhjJetEnQIaYTe	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
69101389-b024-4808-8def-6a8881caa316	\N	\N	t	2018-06-16 05:31:16.691367	2018-06-16 05:31:16.691367	f	e33b5277-1f57-4	$2b$10$5X31fMePe5MOAN5I18GcB.HvwU157HGVdS2wkIWiNkenzYJGXbv9O	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
41cd0a62-3d51-4239-aded-59d21d20b494	newName	\N	t	2018-06-16 05:31:16.87101	2018-06-16 05:31:16.87101	f	6896ee06-fed5-4	$2b$10$yi67xiTWOQOOyoLgSHDC8OQvvpowRk../N67etA/Cw6lYdIaCxskm	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
ad151365-ecf9-46e8-95bc-74464f158e88	\N	\N	t	2018-06-16 05:31:17.044288	2018-06-16 05:31:17.044288	f	4099045b-7c30-4	$2b$10$xOHBNsiTkzIYhkkph07VU.KnjffsqzWtCXHnhc9oDTpt6RkKBCU06	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
a6cbfe5d-4f66-4d79-b3dc-b361abb4b6b9	\N	\N	t	2018-06-16 05:32:55.150777	2018-06-16 05:32:55.150777	f	236b9626-b39d-4	$2b$10$x0pjgRgqhmYt3PBG/rkHn.ujs90fiVG5bq5AZo5BU2tmbOSYht6QW	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
cc30efbc-0daf-4d27-8e1a-3137ab3f29ba	\N	\N	t	2018-06-16 05:32:55.320765	2018-06-16 05:32:55.320765	f	4d0d9c7c-6018-4	$2b$10$KNFOoBU1sMXjJu2QKTl/vOf94kHWvZY6tWjyddgrtOhLdkdp3AqtK	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
7c7f2eb6-b5de-4a48-9a1d-d4f5b35e4cf8	\N	\N	t	2018-06-16 05:32:55.487254	2018-06-16 05:32:55.487254	f	9e1c7d7c-067b-4	$2b$10$hcTgbxvIY4JqHQJHrOgNze1uQ2Y48tJIXOTIaQIfrvKbvYnmxQmae	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
2f8ece7e-2bfe-44cb-8572-560ba77899ab	\N	\N	t	2018-06-16 05:34:39.500094	2018-06-16 05:34:39.500094	f	babc0cd1-c46f-4	$2b$10$U27FACGA.KpT7kkiBKNzFOuf.c7ijreXBl/Uq6CbKQptzRFg2vg76	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
18c448cd-d3cb-4778-918b-ffd664964ac9	newName	\N	t	2018-06-16 05:34:39.667948	2018-06-16 05:34:39.667948	f	1a7a957c-6467-4	$2b$10$awJ74wqfjz0lP836JMfxZuVtpZw5d45fl4d2D8dGlk2ckI3kMiU7K	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
d6a8c37a-8b69-46c9-9258-c307ef8daca5	\N	\N	t	2018-06-16 05:34:39.839556	2018-06-16 05:34:39.839556	f	79d38cd3-950f-4	$2b$10$YySU5zsZv2XF10LAdjnK3OBFVhUFh.Gt3WgnX3lWV/o4T9D1u88w6	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
5ae015b7-8f4c-4991-9d03-2c25509d7ea0	\N	\N	t	2018-06-16 05:41:32.814203	2018-06-16 05:41:32.814203	f	ddec2074-4e53-4	$2b$10$XYohfhO7xfOCfONaGJ06hOJbI1t6cuVq/W2RFATm9.J9s/V1oMwTi	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
124d32a2-7228-4a8e-aad3-01a00e64a395	\N	\N	t	2018-06-16 05:41:32.998422	2018-06-16 05:41:32.998422	f	593b3145-0fac-4	$2b$10$6pFkP.IM2g1neaPjjvp.cuZMnjbWGa.mnhFkbU/aE4KYw5l56LOt2	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
7c6d0b69-eee0-46a4-bf57-15036f54a1d5	newName	\N	t	2018-06-16 05:41:33.155778	2018-06-16 05:41:33.155778	f	27e1f836-f3da-4	$2b$10$SoPRFGSSEleJwbs4NJPRQeKgSAGZLbV5iia8SFOLZZ7/tSeq0rnrK	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
f26df00e-97fd-43c0-b188-ea622d8985d9	\N	\N	t	2018-06-16 05:41:33.329555	2018-06-16 05:41:33.329555	f	8c25fade-611a-4	$2b$10$reJdWp2GaxOUrPod/l9uYO5ZqwybX.UokJ2L/hGvRS8MSIwTERDlO	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
2725a699-16c0-44f7-aafe-4114055ed284	\N	\N	t	2018-06-16 05:43:48.119062	2018-06-16 05:43:48.119062	f	616e2e63-aac6-4	$2b$10$5uCZBgZ1EsGXjSG/k7Eg6enpaTNVkApDN6TyWhCSLCZELW1dKw2JK	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
753926de-7c04-4a74-bc51-c3db1c4ed7d3	\N	\N	t	2018-06-16 05:43:48.300263	2018-06-16 05:43:48.300263	f	a9ca5c17-00a1-4	$2b$10$LlGNDiltuOwp3XnpZhPdBOYgMpFWSmNPjYZfBnAWomSXs3q5KPgcu	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
d35988e3-ea31-4009-b496-97d904e122cc	\N	\N	t	2018-06-16 05:43:48.466292	2018-06-16 05:43:48.466292	f	69f5d66c-a832-4	$2b$10$DVGvPWmZvns6QXxkyRsuuuTa3gcQQttogJmAageHmCzhmDo1sSDE6	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
134c9b70-5fe0-43a0-9956-b811075d76e5	newName	\N	t	2018-06-16 05:43:48.690716	2018-06-16 05:43:48.690716	f	fec3ae7c-c177-4	$2b$10$/NEBzJqar6XAqfyQ17AK5OgelTeMNwC/osWMh7U1CotQrdJa8uS2a	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
9cef2078-a08e-4421-96bc-c3cd3a54a949	\N	\N	t	2018-06-16 05:43:48.871328	2018-06-16 05:43:48.871328	f	19496346-5978-4	$2b$10$dEKKCYMUq4ZsHb/qXDBVDepfZgNPicGPsTlSI5GzofnEPyiAmFRsC	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
43a02cea-6fd3-427e-b8a4-7b1cb3652f99	\N	\N	t	2018-06-16 05:51:22.232886	2018-06-16 05:51:22.232886	f	7d92b3ff-c69c-4	$2b$10$KXdq9DYN4r5Am/nU2W64oeosDO7slRdPVu79aAIj0tICQ1lQo7Pie	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
f39df5d1-ec62-4b1b-bfcd-650a7f3b21e5	\N	\N	t	2018-06-16 05:51:22.412381	2018-06-16 05:51:22.412381	f	9ba6391f-ed0f-4	$2b$10$.x2ZfcPQhc0ZZEaj0eI6YOW5pfkTvjPqEZFNeGeUhpsz8aGvOpX3a	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
913ce13b-47be-4a6f-bbb9-d8684d7c0250	\N	\N	t	2018-06-16 05:51:22.547671	2018-06-16 05:51:22.547671	f	6bea3f25-9978-4	$2b$10$KUvQ0ec8W5tXpUiV6xWaNOc8nMVDmxN9KeQdM7HZ6DB4Im1Fp40ZC	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
3f87a65f-7c44-4acd-9136-d1b1710d0482	\N	\N	t	2018-06-16 05:51:22.711151	2018-06-16 05:51:22.711151	f	bae8440e-41bc-4	$2b$10$4mo.cVDZ0Day3CuOkYJgDepxdsrhTORKAvkdnwa0gvWbwapzqGL4m	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
a6978140-eb28-4898-ab55-61856cf24ef8	newName	\N	t	2018-06-16 05:51:22.932529	2018-06-16 05:51:22.932529	f	cff9abe1-9f64-4	$2b$10$TT03a64GRUDPeVIcX2DXT.3eLaaIcsjfi60IQ8YAQk9rLSIUBNVq6	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
495b744b-d071-4660-b24e-7bfc9bb1f1e6	\N	\N	t	2018-06-16 05:51:23.112801	2018-06-16 05:51:23.112801	f	02698a0c-ea56-4	$2b$10$fQnkNGgHlHomPJtydL6jieqIMtmydLjGk1ma6.pTW2At5/QdVD1Dy	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
5980774e-eeb1-4077-ba6f-d2c246881c26	\N	\N	t	2018-06-16 05:52:14.13039	2018-06-16 05:52:14.13039	f	66b3d66f-c717-4	$2b$10$skk.4q//XnvkJcJ68GGct.x92j1BefEOEPWllU4OwBLrcmWTAtKOq	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
9e6b9726-f415-46c2-8e0b-4780337955b7	\N	\N	t	2018-06-16 05:52:14.315048	2018-06-16 05:52:14.315048	f	840e00d9-d9cc-4	$2b$10$RJjdgL0tKrh74cUrGJ0Y3.OHOL87J4eONxDZrZRsFH69g360UPDKS	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
1fe32fdd-9736-4192-bc81-7b6696044bd4	\N	\N	t	2018-06-16 05:52:14.459087	2018-06-16 05:52:14.459087	f	7c435447-2d69-4	$2b$10$np5tJXb5xAuWy9vOF03GbeAc.uOBGuQz.RyIK2/Owcl4tXPWqnnO6	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
0ca09f5d-7d7e-45f4-bfa8-5bdde75b12f1	\N	\N	t	2018-06-16 05:52:14.627293	2018-06-16 05:52:14.627293	f	a4babb76-8e73-4	$2b$10$0YEf9FqeWVc0NhI0ihho4uEasuQTWbyEbvSRqsGFrouvLTVPIhIBK	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
80ba8971-31a5-4aaf-8d6d-1c8636b623b1	newName	\N	t	2018-06-16 05:52:14.856472	2018-06-16 05:52:14.856472	f	08478a2b-b97e-4	$2b$10$vijmNqeksqtydAvgGrzG8O.IqPo/NPuoH7fw75z00HutdiV5lVRMu	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
c3de5988-618f-48ad-9a65-7b90bc97eebd	\N	\N	t	2018-06-16 05:52:15.044364	2018-06-16 05:52:15.044364	f	6c5c3bd2-c932-4	$2b$10$XtSrffahPPFuuy.TLRHoauM0V8uHyKTlty..1pY6mALKzHBLIuPJG	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
bb2985af-5bcb-4424-96c9-84ea7941fbfe	\N	\N	t	2018-06-16 05:53:16.078767	2018-06-16 05:53:16.078767	f	b8fa8d28-9b37-4	$2b$10$YVoA8Szh3y3X6Ql5hSBbkeQaX5w7Nd4RSeyHg3lM33dd8O7jxxdwy	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
dd3ed4e9-a5c6-4070-91e2-841bc84ef0b7	\N	\N	t	2018-06-16 05:53:16.270652	2018-06-16 05:53:16.270652	f	8d63f22d-33f2-4	$2b$10$DSvS7pwbYi8/0e2WU4ckGONRzRfDhpXLHGfeKuUNoMrnbKHUclglK	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
85131bfc-d596-4341-bf80-d848abb1b5a4	\N	\N	t	2018-06-16 05:53:16.412639	2018-06-16 05:53:16.412639	f	4335c0ed-5885-4	$2b$10$QQjqYMachJeNKL8I90Pd1uHu2tyjmNJARYI2Wpv3QjnqutrqBiEyu	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
649b0011-685b-4807-8e1e-894134caf1e7	\N	\N	t	2018-06-16 05:53:16.575307	2018-06-16 05:53:16.575307	f	acc5e898-78cc-4	$2b$10$N/x9NvcI04ywK4WNXQ8sqei5ceqyNXCfP0XUENHcDpxFefMW79F0W	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
2524540c-b335-42b6-97d8-5f14ea518be7	newName	\N	t	2018-06-16 05:53:16.799698	2018-06-16 05:53:16.799698	f	3dd9d3ca-111c-4	$2b$10$di6OVB7B1ShvUJkyHYjRg.Wxa5F4Wk4DQ5kxE.o1tepTU.z3w25Ay	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
2758a1e1-7b9c-4a98-b278-713bb3e40788	\N	\N	t	2018-06-16 05:53:16.979394	2018-06-16 05:53:16.979394	f	151cd3ef-08b0-4	$2b$10$vxI.baFeFIQA68.0aZygC.1NLFxUte/yGmLby9CDb7aBkKRPGILCy	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
67a975e5-59c8-442b-94d8-4c5c03d21189	\N	\N	t	2018-06-16 05:56:21.32766	2018-06-16 05:56:21.32766	f	fc3e7ba1-f792-4	$2b$10$xj46xTXSHSiJZ37jTUE43eoU941jEc8eRGpdrixFIGYPyTICWuSBK	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
6bf773db-1be2-4d6d-9022-5b503f39fd83	\N	\N	t	2018-06-16 05:57:14.692522	2018-06-16 05:57:14.692522	f	2b9977fa-f3f4-4	$2b$10$mFP0fXC92l908l1U1OF4/um2hCUoz5.PqSpkq7m2I9qJgyABLTZE6	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
e2a89ef2-a609-49cc-a010-6a24cdd1218d	\N	\N	t	2018-06-16 05:57:48.458039	2018-06-16 05:57:48.458039	f	a19abceb-010e-4	$2b$10$NRW18T3OuxBklzxdSsGtI.aklJlT5AaSjepMe4nrBDnl8Euq82mtq	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
e36eb328-f8ad-43e2-8b9c-4ea0371c7a72	\N	\N	t	2018-06-16 05:58:32.246167	2018-06-16 05:58:32.246167	f	73900720-5815-4	$2b$10$uMqc6JN89wXsMqoGeQ7L3.lvkorZ1Ix0Vls3Z8V7xi64higWL12RO	http://pixelartmaker.com/art/a27e62d4a45d2bc.png
\.


--
-- Data for Name: winners; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.winners (winner_id, quiz, "user", amount_won) FROM stdin;
\.


--
-- Name: prizes_prize_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.prizes_prize_id_seq', 1, false);


--
-- Name: answer_submission answer_submission_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.answer_submission
    ADD CONSTRAINT answer_submission_pkey PRIMARY KEY (question, "user", choice);


--
-- Name: prizes prizes_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.prizes
    ADD CONSTRAINT prizes_pkey PRIMARY KEY (prize_id);


--
-- Name: questions_choices questions_choices_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.questions_choices
    ADD CONSTRAINT questions_choices_pkey PRIMARY KEY (choice_id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (question_id);


--
-- Name: questions questions_quiz_id_question_num_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_quiz_id_question_num_key UNIQUE (quiz_id, question_num);


--
-- Name: quizzes quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (quiz_id);


--
-- Name: shows shows_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.shows
    ADD CONSTRAINT shows_pkey PRIMARY KEY (show_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: winners winners_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.winners
    ADD CONSTRAINT winners_pkey PRIMARY KEY (winner_id);


--
-- Name: answer_submission_choice_fkey; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX answer_submission_choice_fkey ON public.answer_submission USING btree (choice);


--
-- Name: answer_submission_question_fkey; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX answer_submission_question_fkey ON public.answer_submission USING btree (question);


--
-- Name: answer_submission_user_fkey; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX answer_submission_user_fkey ON public.answer_submission USING btree ("user");


--
-- Name: questions_choices_question_fkey; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX questions_choices_question_fkey ON public.questions_choices USING btree (question);


--
-- Name: quiz_fkey; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX quiz_fkey ON public.questions USING btree (quiz_id);


--
-- Name: user; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX "user" ON public.winners USING btree ("user");


--
-- Name: winners_quix_fkey; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX winners_quix_fkey ON public.winners USING btree (quiz);


--
-- Name: prizes prizes_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.prizes
    ADD CONSTRAINT prizes_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(quiz_id);


--
-- Name: prizes prizes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.prizes
    ADD CONSTRAINT prizes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: questions_choices questions_choices_question_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.questions_choices
    ADD CONSTRAINT questions_choices_question_fkey FOREIGN KEY (question) REFERENCES public.questions(question_id) ON DELETE CASCADE;


--
-- Name: questions questions_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(quiz_id);


--
-- Name: winners quiz; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.winners
    ADD CONSTRAINT quiz FOREIGN KEY (quiz) REFERENCES public.quizzes(quiz_id);


--
-- Name: CONSTRAINT quiz ON winners; Type: COMMENT; Schema: public; Owner: admin
--

COMMENT ON CONSTRAINT quiz ON public.winners IS 'Winner for this quiz';


--
-- Name: answer_submission user; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.answer_submission
    ADD CONSTRAINT "user" FOREIGN KEY ("user") REFERENCES public.users(user_id);


--
-- Name: CONSTRAINT "user" ON answer_submission; Type: COMMENT; Schema: public; Owner: admin
--

COMMENT ON CONSTRAINT "user" ON public.answer_submission IS 'User who submitted the answer';


--
-- Name: winners user; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.winners
    ADD CONSTRAINT "user" FOREIGN KEY ("user") REFERENCES public.users(user_id);


--
-- Name: CONSTRAINT "user" ON winners; Type: COMMENT; Schema: public; Owner: admin
--

COMMENT ON CONSTRAINT "user" ON public.winners IS 'the user who won';


--
-- PostgreSQL database dump complete
--

\connect postgres

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4 (Debian 10.4-2.pgdg90+1)
-- Dumped by pg_dump version 10.4 (Debian 10.4-2.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- PostgreSQL database dump complete
--

\connect template1

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4 (Debian 10.4-2.pgdg90+1)
-- Dumped by pg_dump version 10.4 (Debian 10.4-2.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

