CREATE SCHEMA IF NOT EXISTS "finance" AUTHORIZATION "postgres";

SET search_path TO "finance";

-- Table: "finance"."users" --
CREATE TABLE IF NOT EXISTS finance.users (
    "id" SERIAL PRIMARY KEY,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "deleted_at" TIMESTAMP
);

-- Table : "finance"."spending_categories" --
CREATE TABLE IF NOT EXISTS finance.spending_categories (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "deleted_at" TIMESTAMP
);

-- Table: "finance"."spending" --
CREATE TABLE IF NOT EXISTS finance.spending (
    "id" SERIAL PRIMARY KEY,
    "amount" NUMERIC(10,2) NOT NULL,
    "description" TEXT NOT NULL,
    "date" DATE NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "deleted_at" TIMESTAMP,
    "s3Key" TEXT,
    "category_id" INTEGER,
    FOREIGN KEY ("category_id") REFERENCES finance.spending_categories ("id")

);



-- Table: "finance"."users2spending" --
CREATE TABLE IF NOT EXISTS finance.users_2_spending (
    "id" SERIAL PRIMARY KEY,
    "user_id" INTEGER NOT NULL,
    "spending_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "deleted_at" TIMESTAMP,
    FOREIGN KEY ("user_id") REFERENCES "users" ("id"),
    FOREIGN KEY ("spending_id") REFERENCES finance.spending ("id")
);

