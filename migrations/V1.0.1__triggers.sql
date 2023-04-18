
-- lykin.tasks --
DROP TRIGGER IF EXISTS set_fields_created_byat ON lykin.tasks;
CREATE TRIGGER set_fields_created_byat
    BEFORE INSERT ON lykin.tasks
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


-- lykin.groups_types --
DROP TRIGGER IF EXISTS set_fields_created_byat ON lykin.groups_types;
CREATE TRIGGER set_fields_created_byat
    BEFORE INSERT ON lykin.groups_types
    FOR EACH ROW
    EXECUTE PROCEDURE lykin.set_fields_created_byat();


-- lykin.groups --
DROP TRIGGER IF EXISTS set_fields_created_byat ON lykin.groups;
CREATE TRIGGER set_fields_created_byat
    BEFORE INSERT ON lykin.groups
    FOR EACH ROW
    EXECUTE PROCEDURE lykin.set_fields_created_byat();



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

-- lykin.groups_types --
DROP TRIGGER IF EXISTS set_fields_updated_byat ON lykin.groups_types;
CREATE TRIGGER set_fields_updated_byat
    BEFORE UPDATE ON lykin.groups_types
    FOR EACH ROW
    EXECUTE PROCEDURE lykin.set_fields_updated_byat();

-- lykin.groups --
DROP TRIGGER IF EXISTS set_fields_updated_byat ON lykin.groups;
CREATE TRIGGER set_fields_updated_byat
    BEFORE UPDATE ON lykin.groups
    FOR EACH ROW
    EXECUTE PROCEDURE lykin.set_fields_updated_byat();

-- lykin.users_2_groups --