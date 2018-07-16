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

ALTER TABLE ONLY quizrunner.winners DROP CONSTRAINT winners_user_fkey;
ALTER TABLE ONLY quizrunner.winners DROP CONSTRAINT winners_quiz_fkey;
ALTER TABLE ONLY quizrunner.questions DROP CONSTRAINT questions_quiz_id_fkey;
ALTER TABLE ONLY quizrunner.questions_choices DROP CONSTRAINT questions_choices_question_id_fkey;
ALTER TABLE ONLY quizrunner.answer_submission DROP CONSTRAINT answer_submission_user_id_fkey;
ALTER TABLE ONLY quizrunner.answer_submission DROP CONSTRAINT answer_submission_question_id_fkey;
ALTER TABLE ONLY quizrunner.answer_submission DROP CONSTRAINT answer_submission_choice_id_fkey;
DROP INDEX quizrunner.winners_user_id_fkey;
DROP INDEX quizrunner.winners_quiz_id_fkey;
DROP INDEX quizrunner.quiz_fkey;
DROP INDEX quizrunner.questions_quiz_fkey;
DROP INDEX quizrunner.questions_choices_question_id_fkey;
DROP INDEX quizrunner.answer_submission_user_id_fkey;
DROP INDEX quizrunner.answer_submission_question_id_fkey;
DROP INDEX quizrunner.answer_submission_choice_id_fkey;
ALTER TABLE ONLY quizrunner.winners DROP CONSTRAINT winners_pkey;
ALTER TABLE ONLY quizrunner.users DROP CONSTRAINT users_username_key;
ALTER TABLE ONLY quizrunner.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY quizrunner.quizzes DROP CONSTRAINT quizzes_pkey;
ALTER TABLE ONLY quizrunner.questions DROP CONSTRAINT questions_pkey;
ALTER TABLE ONLY quizrunner.questions_choices DROP CONSTRAINT questions_choices_pkey;
ALTER TABLE ONLY quizrunner.migrations DROP CONSTRAINT migrations_pkey;
ALTER TABLE ONLY quizrunner.answer_submission DROP CONSTRAINT answer_submission_pkey;
ALTER TABLE quizrunner.migrations ALTER COLUMN id DROP DEFAULT;
DROP TABLE quizrunner.winners;
DROP TABLE quizrunner.users;
DROP TABLE quizrunner.quizzes;
DROP TABLE quizrunner.questions_choices;
DROP TABLE quizrunner.questions;
DROP SEQUENCE quizrunner.migrations_id_seq;
DROP TABLE quizrunner.migrations;
DROP TABLE quizrunner.answer_submission;
DROP EXTENSION "uuid-ossp";
DROP EXTENSION plpgsql;
DROP SCHEMA quizrunner;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: quizrunner; Type: SCHEMA; Schema: -; Owner: admin
--

CREATE SCHEMA quizrunner;


ALTER SCHEMA quizrunner OWNER TO admin;

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
-- Name: answer_submission; Type: TABLE; Schema: quizrunner; Owner: admin
--

CREATE TABLE quizrunner.answer_submission (
    question_id uuid NOT NULL,
    user_id uuid NOT NULL,
    choice_id uuid NOT NULL,
    submitted timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE quizrunner.answer_submission OWNER TO admin;

--
-- Name: migrations; Type: TABLE; Schema: quizrunner; Owner: admin
--

CREATE TABLE quizrunner.migrations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    run_on timestamp without time zone NOT NULL
);


ALTER TABLE quizrunner.migrations OWNER TO admin;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: quizrunner; Owner: admin
--

CREATE SEQUENCE quizrunner.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE quizrunner.migrations_id_seq OWNER TO admin;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: quizrunner; Owner: admin
--

ALTER SEQUENCE quizrunner.migrations_id_seq OWNED BY quizrunner.migrations.id;


--
-- Name: questions; Type: TABLE; Schema: quizrunner; Owner: admin
--

CREATE TABLE quizrunner.questions (
    question_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    question text NOT NULL,
    sent timestamp without time zone,
    expired timestamp without time zone,
    question_num integer NOT NULL,
    quiz_id uuid NOT NULL,
    ticker character varying(64) NOT NULL,
    sport character varying(64) NOT NULL
);


ALTER TABLE quizrunner.questions OWNER TO admin;

--
-- Name: questions_choices; Type: TABLE; Schema: quizrunner; Owner: admin
--

CREATE TABLE quizrunner.questions_choices (
    choice_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    question_id uuid NOT NULL,
    text character varying(64) NOT NULL,
    is_answer boolean DEFAULT false NOT NULL
);


ALTER TABLE quizrunner.questions_choices OWNER TO admin;

--
-- Name: quizzes; Type: TABLE; Schema: quizrunner; Owner: admin
--

CREATE TABLE quizrunner.quizzes (
    quiz_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    active boolean DEFAULT false NOT NULL,
    title text NOT NULL,
    pot_amount bigint DEFAULT '0'::bigint NOT NULL,
    completed boolean DEFAULT false NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE quizrunner.quizzes OWNER TO admin;

--
-- Name: users; Type: TABLE; Schema: quizrunner; Owner: admin
--

CREATE TABLE quizrunner.users (
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


ALTER TABLE quizrunner.users OWNER TO admin;

--
-- Name: winners; Type: TABLE; Schema: quizrunner; Owner: admin
--

CREATE TABLE quizrunner.winners (
    quiz_id uuid NOT NULL,
    user_id uuid NOT NULL,
    amount_won integer NOT NULL
);


ALTER TABLE quizrunner.winners OWNER TO admin;

--
-- Name: migrations id; Type: DEFAULT; Schema: quizrunner; Owner: admin
--

ALTER TABLE ONLY quizrunner.migrations ALTER COLUMN id SET DEFAULT nextval('quizrunner.migrations_id_seq'::regclass);


--
-- Name: answer_submission answer_submission_pkey; Type: CONSTRAINT; Schema: quizrunner; Owner: admin
--

ALTER TABLE ONLY quizrunner.answer_submission
    ADD CONSTRAINT answer_submission_pkey PRIMARY KEY (question_id, user_id, choice_id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: quizrunner; Owner: admin
--

ALTER TABLE ONLY quizrunner.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: questions_choices questions_choices_pkey; Type: CONSTRAINT; Schema: quizrunner; Owner: admin
--

ALTER TABLE ONLY quizrunner.questions_choices
    ADD CONSTRAINT questions_choices_pkey PRIMARY KEY (choice_id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: quizrunner; Owner: admin
--

ALTER TABLE ONLY quizrunner.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (question_id);


--
-- Name: quizzes quizzes_pkey; Type: CONSTRAINT; Schema: quizrunner; Owner: admin
--

ALTER TABLE ONLY quizrunner.quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (quiz_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: quizrunner; Owner: admin
--

ALTER TABLE ONLY quizrunner.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: quizrunner; Owner: admin
--

ALTER TABLE ONLY quizrunner.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: winners winners_pkey; Type: CONSTRAINT; Schema: quizrunner; Owner: admin
--

ALTER TABLE ONLY quizrunner.winners
    ADD CONSTRAINT winners_pkey PRIMARY KEY (quiz_id, user_id);


--
-- Name: answer_submission_choice_id_fkey; Type: INDEX; Schema: quizrunner; Owner: admin
--

CREATE INDEX answer_submission_choice_id_fkey ON quizrunner.answer_submission USING btree (choice_id);


--
-- Name: answer_submission_question_id_fkey; Type: INDEX; Schema: quizrunner; Owner: admin
--

CREATE INDEX answer_submission_question_id_fkey ON quizrunner.answer_submission USING btree (question_id);


--
-- Name: answer_submission_user_id_fkey; Type: INDEX; Schema: quizrunner; Owner: admin
--

CREATE INDEX answer_submission_user_id_fkey ON quizrunner.answer_submission USING btree (user_id);


--
-- Name: questions_choices_question_id_fkey; Type: INDEX; Schema: quizrunner; Owner: admin
--

CREATE INDEX questions_choices_question_id_fkey ON quizrunner.questions_choices USING btree (question_id);


--
-- Name: questions_quiz_fkey; Type: INDEX; Schema: quizrunner; Owner: admin
--

CREATE INDEX questions_quiz_fkey ON quizrunner.questions USING btree (quiz_id);


--
-- Name: quiz_fkey; Type: INDEX; Schema: quizrunner; Owner: admin
--

CREATE INDEX quiz_fkey ON quizrunner.questions USING btree (quiz_id);


--
-- Name: winners_quiz_id_fkey; Type: INDEX; Schema: quizrunner; Owner: admin
--

CREATE INDEX winners_quiz_id_fkey ON quizrunner.winners USING btree (quiz_id);


--
-- Name: winners_user_id_fkey; Type: INDEX; Schema: quizrunner; Owner: admin
--

CREATE INDEX winners_user_id_fkey ON quizrunner.winners USING btree (user_id);


--
-- Name: answer_submission answer_submission_choice_id_fkey; Type: FK CONSTRAINT; Schema: quizrunner; Owner: admin
--

ALTER TABLE ONLY quizrunner.answer_submission
    ADD CONSTRAINT answer_submission_choice_id_fkey FOREIGN KEY (choice_id) REFERENCES quizrunner.questions_choices(choice_id);


--
-- Name: answer_submission answer_submission_question_id_fkey; Type: FK CONSTRAINT; Schema: quizrunner; Owner: admin
--

ALTER TABLE ONLY quizrunner.answer_submission
    ADD CONSTRAINT answer_submission_question_id_fkey FOREIGN KEY (question_id) REFERENCES quizrunner.questions(question_id);


--
-- Name: answer_submission answer_submission_user_id_fkey; Type: FK CONSTRAINT; Schema: quizrunner; Owner: admin
--

ALTER TABLE ONLY quizrunner.answer_submission
    ADD CONSTRAINT answer_submission_user_id_fkey FOREIGN KEY (user_id) REFERENCES quizrunner.users(user_id);


--
-- Name: questions_choices questions_choices_question_id_fkey; Type: FK CONSTRAINT; Schema: quizrunner; Owner: admin
--

ALTER TABLE ONLY quizrunner.questions_choices
    ADD CONSTRAINT questions_choices_question_id_fkey FOREIGN KEY (question_id) REFERENCES quizrunner.questions(question_id);


--
-- Name: questions questions_quiz_id_fkey; Type: FK CONSTRAINT; Schema: quizrunner; Owner: admin
--

ALTER TABLE ONLY quizrunner.questions
    ADD CONSTRAINT questions_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES quizrunner.quizzes(quiz_id);


--
-- Name: winners winners_quiz_fkey; Type: FK CONSTRAINT; Schema: quizrunner; Owner: admin
--

ALTER TABLE ONLY quizrunner.winners
    ADD CONSTRAINT winners_quiz_fkey FOREIGN KEY (quiz_id) REFERENCES quizrunner.quizzes(quiz_id);


--
-- Name: winners winners_user_fkey; Type: FK CONSTRAINT; Schema: quizrunner; Owner: admin
--

ALTER TABLE ONLY quizrunner.winners
    ADD CONSTRAINT winners_user_fkey FOREIGN KEY (user_id) REFERENCES quizrunner.users(user_id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

