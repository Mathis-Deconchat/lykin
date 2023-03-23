CREATE SCHEMA IF NOT EXISTS "lykin" AUTHORIZATION "postgres";

SET search_path TO "lykin";



-- Table : "lykin"."operation_categories" --
CREATE TABLE IF NOT EXISTS lykin.operation_categories (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "deleted_at" TIMESTAMP,
    "created_by" TEXT,
    "updated_by" TEXT

);

-- Table: "lykin"."operation" --
CREATE TABLE IF NOT EXISTS lykin.operation (
    "id" SERIAL PRIMARY KEY,
    "amount" NUMERIC(10,2) NOT NULL,
    "description" TEXT NOT NULL,
    "date" DATE NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "deleted_at" TIMESTAMP,
    "s3Key" TEXT,
    "category_id" INTEGER,
    "created_by" TEXT,
    "updated_by" TEXT ,
    FOREIGN KEY ("category_id") REFERENCES lykin.operation_categories ("id")

);

-- Table: "lykin"."users2operation" --
CREATE TABLE IF NOT EXISTS lykin.users_2_operation (
    "id" SERIAL PRIMARY KEY,
    "user_id" INTEGER NOT NULL,
    "operation_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "deleted_at" TIMESTAMP,
    FOREIGN KEY ("operation_id") REFERENCES lykin.operation ("id")
);

-- Table: "lykin"."task_status" --
CREATE TABLE IF NOT EXISTS lykin.task_status (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "deleted_at" TIMESTAMP,
    "created_by" TEXT,
    "updated_by" TEXT

);

INSERT INTO lykin.task_status (name, created_by) VALUES ('New', '123');
INSERT INTO lykin.task_status (name, created_by) VALUES ('In progress', '123');
INSERT INTO lykin.task_status (name, created_by) VALUES ('Done', '123');

-- Table: "lykin"."tasks" --
CREATE TABLE IF NOT EXISTS lykin.tasks (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "status_id" INTEGER NOT NULL,
    "due_date" DATE,
    "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "deleted_at" TIMESTAMP,
    "created_by" TEXT ,
    "updated_by" TEXT ,
    FOREIGN KEY ("status_id") REFERENCES lykin.task_status ("id")
);

-- SET_FIELDS_CREATED_BYAT --
CREATE OR REPLACE FUNCTION lykin.set_fields_created_byat ()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.created_by = nullif (current_setting('jwt.claims.user_id', 't'), '');
    NEW.created_at = now();
    RETURN NEW;
END;
$$;

-- lykin.tasks --
DROP TRIGGER IF EXISTS set_fields_created_byat ON lykin.tasks;
CREATE TRIGGER set_fields_created_byat
    BEFORE UPDATE ON lykin.tasks
    FOR EACH ROW
    EXECUTE PROCEDURE lykin.set_fields_created_byat();

-- lykin.opeation--
DROP TRIGGER IF EXISTS set_fields_created_byat ON lykin.operation;
CREATE TRIGGER set_fields_created_byat
    BEFORE INSERT ON lykin.operation
    FOR EACH ROW
    EXECUTE PROCEDURE lykin.set_fields_created_byat();


-- lykin.operation_category --
DROP TRIGGER IF EXISTS set_fields_created_byat ON lykin.operation_categories;
CREATE TRIGGER set_fields_created_byat
    BEFORE INSERT ON lykin.operation_categories
    FOR EACH ROW
    EXECUTE PROCEDURE lykin.set_fields_created_byat();

-- lykin.task_status --
DROP TRIGGER IF EXISTS set_fields_created_byat ON lykin.task_status;
CREATE TRIGGER set_fields_created_byat
    BEFORE INSERT ON lykin.task_status
    FOR EACH ROW
    EXECUTE PROCEDURE lykin.set_fields_created_byat();




-- SET_FIELDS_UPDATED_BYAT --
CREATE OR REPLACE FUNCTION lykin.set_fields_updated_byat ()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_by = nullif (current_setting('jwt.claims.user_id', 't'), '');
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;

-- lykin.tasks --
DROP TRIGGER IF EXISTS set_fields_updated_byat ON lykin.tasks;
CREATE TRIGGER set_fields_updated_byat
    BEFORE UPDATE ON lykin.tasks
    FOR EACH ROW
    EXECUTE PROCEDURE lykin.set_fields_updated_byat();

-- lykin.opeation--
DROP TRIGGER IF EXISTS set_fields_updated_byat ON lykin.operation;
CREATE TRIGGER set_fields_updated_byat
    BEFORE UPDATE ON lykin.operation
    FOR EACH ROW
    EXECUTE PROCEDURE lykin.set_fields_updated_byat();

-- lykin.operation_category --
DROP TRIGGER IF EXISTS set_fields_updated_byat ON lykin.operation_categories;
CREATE TRIGGER set_fields_updated_byat
    BEFORE UPDATE ON lykin.operation_categories
    FOR EACH ROW
    EXECUTE PROCEDURE lykin.set_fields_updated_byat();

-- lykin.task_status --
DROP TRIGGER IF EXISTS set_fields_updated_byat ON lykin.task_status;
CREATE TRIGGER set_fields_updated_byat
    BEFORE UPDATE ON lykin.task_status
    FOR EACH ROW
    EXECUTE PROCEDURE lykin.set_fields_updated_byat();


