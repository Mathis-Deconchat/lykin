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

INSERT INTO lykin.operation_categories (name) VALUES ('Courses');
INSERT INTO lykin.operation_categories (name) VALUES ('Restauration');
INSERT INTO lykin.operation_categories (name) VALUES ('Loisirs');
INSERT INTO lykin.operation_categories (name) VALUES ('Santé');
INSERT INTO lykin.operation_categories (name) VALUES ('Autre');




-- Table: "lykin"."operation" --
CREATE TABLE IF NOT EXISTS lykin.operation (
    "id" SERIAL PRIMARY KEY,
    "amount" TEXT NOT NULL,
    "description" TEXT NOT NULL,
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

-- Table : "lykin"."groups_types" --
CREATE TABLE IF NOT EXISTS lykin.groups_types (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "color" TEXT NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "deleted_at" TIMESTAMP,
    "created_by" TEXT,
    "updated_by" TEXT

);

INSERT INTO lykin.groups_types (name, description, color) VALUES ('Colocation', 'Gérez vos dépenses, tâches récurrentes et bien plus avec vos collocs', 'blue');
INSERT INTO lykin.groups_types (name, description, color) VALUES ('Couple', 'Mieux gérer son argent au sein d''un couple, en collocation ou chacun chez soi', 'green');
INSERT INTO lykin.groups_types (name, description, color) VALUES ('Tout seul', 'Pour toi qui gère seul ton argent et tes tâches quotidiennes','purple');
INSERT INTO lykin.groups_types (name, description, color) VALUES ('Entre amis', 'Gérez vos dépenses, tâches récurrentes et bien plus avec vos amis', 'yellow');

-- Table: "lykin"."groups" --
CREATE TABLE IF NOT EXISTS lykin.groups (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "slug_id" TEXT NOT NULL,
    "type_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "deleted_at" TIMESTAMP,
    "created_by" TEXT,
    "updated_by" TEXT,
    "code" TEXT,
    FOREIGN KEY ("type_id") REFERENCES lykin.groups_types ("id")
);

-- Table: "lykin"."users2groups" --
CREATE TABLE IF NOT EXISTS lykin.users_2_groups (
    "id" SERIAL PRIMARY KEY,
    "user_id" TEXT NOT NULL,
    "group_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "deleted_at" TIMESTAMP,
    FOREIGN KEY ("group_id") REFERENCES lykin.groups ("id")
);


-- Generate a code for every group --
CREATE OR REPLACE FUNCTION generate_code() RETURNS TRIGGER AS $$
DECLARE
    _code TEXT;
BEGIN
    LOOP
        _code := CONCAT(LEFT(MD5(random()::text), 5), '-', LEFT(MD5(random()::text), 3), '-', LEFT(MD5(random()::text), 5));
        EXIT WHEN NOT EXISTS(SELECT 1 FROM lykin.groups WHERE code = _code);
    END LOOP;
    NEW.code := _code;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_code
BEFORE INSERT ON lykin.groups
FOR EACH ROW
WHEN (NEW.code IS NULL)
EXECUTE FUNCTION generate_code();

-- Create a function to get the user_id from the JWT token --
CREATE OR REPLACE FUNCTION lykin.get_user_id()
    RETURNS TEXT
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN nullif (current_setting('jwt.claims.user_id', 't'), '');
END;
$$;


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


CREATE OR REPLACE FUNCTION lykin.add_user_to_group(_input_code TEXT)
    RETURNS lykin.groups
    LANGUAGE plpgsql
    AS $$
DECLARE
    _input_group_id INTEGER;
    _input_user_id TEXT;
    group_info lykin.groups%ROWTYPE;
BEGIN
    -- Check if the code is null, and raise an error if it is
    IF _input_code IS NULL THEN
        RAISE EXCEPTION 'Invalid input parameter: code cannot be null';
    END IF;

    -- Get the user ID
    _input_user_id  := lykin.get_user_id();

    -- Find the group ID for the given code
    SELECT id INTO _input_group_id FROM lykin.groups WHERE code = _input_code;

    -- If the group ID is not found, raise an error
    IF _input_group_id IS NULL THEN
        RAISE EXCEPTION 'Invalid input parameter: code is not valid';
    END IF;

    -- Check if the user is already part of the group, and raise an error if they are
    IF EXISTS (
        SELECT 1 FROM lykin.users_2_groups
        WHERE _input_user_id  = user_id AND _input_group_id = group_id
    ) THEN
        RAISE EXCEPTION 'User is already a member of the group';
    END IF;

    -- Add the user to the group and return the group information
    INSERT INTO lykin.users_2_groups (user_id, group_id)
    VALUES (_input_user_id , _input_group_id);
    SELECT * INTO group_info FROM lykin.groups WHERE id = _input_group_id;
    RETURN group_info;
END;
$$;




