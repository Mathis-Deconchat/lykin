-- helper function to create role if not exist
CREATE OR REPLACE FUNCTION lykin.create_role_if_not_exist (role_name text)
    RETURNS void
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT
            1
        FROM
            pg_roles
        WHERE
            rolname = role_name) THEN
    EXECUTE format('CREATE ROLE %s', role_name);
END IF;
END;
$$
LANGUAGE 'plpgsql';

-- helper function to revoke all privileges of role on all of schema
CREATE OR REPLACE FUNCTION lykin.revoke_privileges_of_role_on_schema (role_name text, schema_name text)
    RETURNS void
    AS $$
BEGIN
    EXECUTE format('REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA %s FROM %s', schema_name, role_name);
    EXECUTE format('REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA %s FROM %s', schema_name, role_name);
    EXECUTE format('REVOKE ALL PRIVILEGES ON ALL ROUTINES IN SCHEMA %s FROM %s', schema_name, role_name);
    EXECUTE format('REVOKE ALL PRIVILEGES ON SCHEMA %s FROM %s', schema_name, role_name);
END;
$$
LANGUAGE 'plpgsql';

-- helper function to set all privileges for a role on a schema
CREATE OR REPLACE FUNCTION lykin.set_all_privileges_for_role_on_schema (role_name text, schema_name text)
    RETURNS void
    AS $$
BEGIN
    EXECUTE format('GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA %s TO %s', schema_name, role_name);
    EXECUTE format('GRANT USAGE ON ALL SEQUENCES IN SCHEMA %s TO %s', schema_name, role_name);
    EXECUTE format('GRANT EXECUTE ON ALL ROUTINES IN SCHEMA %s TO %s', schema_name, role_name);
    EXECUTE format('GRANT USAGE ON SCHEMA %s TO %s', schema_name, role_name);
END;
$$
LANGUAGE 'plpgsql';

-- helper function to revoke all privileges on security_functions for a role on schema
CREATE OR REPLACE FUNCTION lykin.revoke_security_functions_for_role_on_schema (role_name text, schema_name text)
    RETURNS void
    AS $$
BEGIN
    EXECUTE format('REVOKE ALL PRIVILEGES ON FUNCTION %s.create_role_if_not_exist FROM %s', schema_name, role_name);
    EXECUTE format('REVOKE ALL PRIVILEGES ON FUNCTION %s.revoke_privileges_of_role_on_schema FROM %s', schema_name, role_name);
    EXECUTE format('REVOKE ALL PRIVILEGES ON FUNCTION %s.set_all_privileges_for_role_on_schema FROM %s', schema_name, role_name);
    EXECUTE format('REVOKE ALL PRIVILEGES ON FUNCTION %s.revoke_security_functions_for_role_on_schema FROM %s', schema_name, role_name);
    EXECUTE format('REVOKE ALL PRIVILEGES ON FUNCTION %s.set_roles_and_privileges FROM %s', schema_name, role_name);
END;
$$
LANGUAGE 'plpgsql';


-- MAIN FUNCTION TO CALL TO SET ROLES AND PRIVILEGES
CREATE OR REPLACE FUNCTION lykin.set_roles_and_privileges ()
    RETURNS VOID
    AS $$
BEGIN

    PERFORM
        lykin.create_role_if_not_exist ('lykin_user');
    PERFORM
        lykin.revoke_privileges_of_role_on_schema ('lykin_user', 'lykin');
    PERFORM
        lykin.revoke_security_functions_for_role_on_schema ('lykin_user', 'lykin');
    PERFORM
        lykin.set_all_privileges_for_role_on_schema ('lykin_user', 'lykin');


    GRANT USAGE ON SCHEMA lykin TO lykin_user;

    GRANT lykin_user TO postgres;
END;
$$
LANGUAGE 'plpgsql';

SELECT 1 FROM lykin.set_roles_and_privileges ();
