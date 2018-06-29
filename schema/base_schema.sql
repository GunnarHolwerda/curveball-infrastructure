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
    question_id uuid NOT NULL,
    user_id uuid NOT NULL,
    choice_id uuid NOT NULL,
    submitted timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.answer_submission OWNER TO admin;

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
    question_id uuid NOT NULL,
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
    quiz_id uuid NOT NULL,
    user_id uuid NOT NULL,
    amount_won integer NOT NULL
);


ALTER TABLE public.winners OWNER TO admin;

--
-- Data for Name: answer_submission; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.answer_submission (question_id, user_id, choice_id, submitted) FROM stdin;
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.questions (question_id, created, question, sent, expired, question_num, quiz_id) FROM stdin;
\.


--
-- Data for Name: questions_choices; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.questions_choices (choice_id, question_id, text, is_answer) FROM stdin;
\.


--
-- Data for Name: quizzes; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.quizzes (quiz_id, active, title, pot_amount, completed, created) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.users (user_id, name, phone, enabled, created, last_accessed, referred, username, password, photo) FROM stdin;
\.


--
-- Data for Name: winners; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.winners (quiz_id, user_id, amount_won) FROM stdin;
\.


--
-- Name: answer_submission answer_submission_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.answer_submission
    ADD CONSTRAINT answer_submission_pkey PRIMARY KEY (question_id, user_id, choice_id);


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
-- Name: quizzes quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (quiz_id);


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
    ADD CONSTRAINT winners_pkey PRIMARY KEY (quiz_id, user_id);


--
-- Name: answer_submission_choice_id_fkey; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX answer_submission_choice_id_fkey ON public.answer_submission USING btree (choice_id);


--
-- Name: answer_submission_question_id_fkey; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX answer_submission_question_id_fkey ON public.answer_submission USING btree (question_id);


--
-- Name: answer_submission_user_id_fkey; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX answer_submission_user_id_fkey ON public.answer_submission USING btree (user_id);


--
-- Name: questions_choices_question_id_fkey; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX questions_choices_question_id_fkey ON public.questions_choices USING btree (question_id);


--
-- Name: questions_quiz_fkey; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX questions_quiz_fkey ON public.questions USING btree (quiz_id);


--
-- Name: quiz_fkey; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX quiz_fkey ON public.questions USING btree (quiz_id);


--
-- Name: winners_quiz_id_fkey; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX winners_quiz_id_fkey ON public.winners USING btree (quiz_id);


--
-- Name: winners_user_id_fkey; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX winners_user_id_fkey ON public.winners USING btree (user_id);


--
-- Name: answer_submission answer_submission_choice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.answer_submission
    ADD CONSTRAINT answer_submission_choice_id_fkey FOREIGN KEY (choice_id) REFERENCES public.questions_choices(choice_id);


--
-- Name: answer_submission answer_submission_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.answer_submission
    ADD CONSTRAINT answer_submission_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(question_id);


--
-- Name: answer_submission answer_submission_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.answer_submission
    ADD CONSTRAINT answer_submission_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: questions_choices questions_choices_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.questions_choices
    ADD CONSTRAINT questions_choices_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(question_id);


--
-- Name: questions questions_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(quiz_id);


--
-- Name: winners winners_quiz_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.winners
    ADD CONSTRAINT winners_quiz_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(quiz_id);


--
-- Name: winners winners_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.winners
    ADD CONSTRAINT winners_user_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


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

