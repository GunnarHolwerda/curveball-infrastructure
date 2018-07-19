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
-- Data for Name: migrations; Type: TABLE DATA; Schema: quizrunner; Owner: admin
--

COPY quizrunner.migrations (id, name, run_on) FROM stdin;
1	/20180716023428-ticker-and-sports	2018-07-15 21:57:22.891
\.


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: quizrunner; Owner: admin
--

SELECT pg_catalog.setval('quizrunner.migrations_id_seq', 36, true);


--
-- PostgreSQL database dump complete
--

