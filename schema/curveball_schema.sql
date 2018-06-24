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
-- PostgreSQL database dump complete
--

