CREATE SCHEMA IF NOT EXISTS "webinno" AUTHORIZATION "postgres";
SET search_path TO "webinno";

CREATE ROLE IF NOT EXISTS "webinno" ;
GRANT "webinno" TO "postgres";
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA "webinno" TO "webinno";
GRANT USAGE ON ALL SEQUENCES IN SCHEMA "webinno" TO "webinno";

CREATE TABLE IF NOT EXISTS "webinno"."groups" (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL
);

ALTER TABLE "webinno"."groups" ENABLE ROW LEVEL SECURITY;

CREATE TYPE "webinno"."event_status" AS ENUM ('public', 'private');

CREATE TABLE IF NOT EXISTS "webinno"."event" (
    "id" SERIAL PRIMARY KEY,
    "date" DATE NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "group_organizer_id" INTEGER NOT NULL,
    "event_status" "webinno"."event_status" NOT NULL DEFAULT 'public',
    FOREIGN KEY ("group_organizer_id") REFERENCES "webinno"."groups" ("id")
);

ALTER TABLE "webinno"."event" ENABLE ROW LEVEL SECURITY;

CREATE TABLE IF NOT EXISTS "webinno"."presentation" (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "user_id" TEXT NOT NULL
);

INSERT INTO webinno.presentation (name, description, user_id)
VALUES 
  ('Introduction to Data Science', 'This presentation covers the basics of data science', 'user_1'),
  ('Advanced SQL Techniques', 'This presentation explores advanced SQL techniques', 'user_1'),
  ('Machine Learning for Beginners', 'This presentation introduces machine learning for beginners', 'user_2'),
  ('Data Visualization with D3', 'This presentation demonstrates how to use D3 for data visualization', 'user_2'),
  ('Web Scraping with Python', 'This presentation shows how to scrape data from the web using Python', 'user_2'),
  ('Big Data Analytics', 'This presentation covers big data analytics techniques and tools', 'user_3'),
  ('Introduction to R', 'This presentation introduces R programming language for data analysis', 'user_3'),
  ('Data Mining with Weka', 'This presentation demonstrates how to use Weka for data mining', 'user_3'),
  ('Text Analytics with NLTK', 'This presentation shows how to perform text analytics using NLTK', 'user_4'),
  ('Data Warehousing Fundamentals', 'This presentation covers the basics of data warehousing', 'user_4');

ALTER TABLE "webinno"."presentation" ENABLE ROW LEVEL SECURITY;

-- Get CURRENT NIE --
CREATE OR REPLACE FUNCTION webinno.get_id ()
    RETURNS text
    AS $$
BEGIN
    RETURN nullif (current_setting('jwt.claims.user_id', 't'), '');
END;
$$
LANGUAGE plpgsql
STABLE;

DROP POLICY IF EXISTS presentation_policy ON webinno.presentation;
CREATE POLICY presentation_policy ON webinno.presentation  TO "webinno" USING (
    user_id = webinno.get_id()
);

CREATE TABLE "webinno"."group2users" (
    "id" SERIAL PRIMARY KEY,
    "group_id" INTEGER NOT NULL,
    "user_id" TEXT NOT NULL,
    FOREIGN KEY ("group_id") REFERENCES "webinno"."groups" ("id")
);

ALTER TABLE "webinno"."group2users" ENABLE ROW LEVEL SECURITY;






