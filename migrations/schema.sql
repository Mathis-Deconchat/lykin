-- create table for users
CREATE TABLE finance.users (
  user_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  cognito_key TEXT NOT NULL,
  max_spending_limit DECIMAL(10, 2) NOT NULL,
  "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
  "updated_at" TIMESTAMP NOT NULL DEFAULT NOW(),
  "deleted_at" TIMESTAMP
);

CREATE TABLE finance.groups_types (
  id SERIAL PRIMARY KEY,
  group_type_name TEXT NOT NULL
);

-- create table for groups
CREATE TABLE finance.groups (
  group_id SERIAL PRIMARY KEY,
  group_name TEXT NOT NULL,
  group_type_id INTEGER REFERENCES finance.groups_types(id),
);

-- create table for mapping users to groups
CREATE TABLE finance.group_members (
  group_id INTEGER REFERENCES groups(group_id),
  user_id INTEGER REFERENCES users(user_id),
  PRIMARY KEY (group_id, user_id)
);

-- Table : "finance"."operation_categories" --
CREATE TABLE IF NOT EXISTS finance.operation_categories (
    "id" SERIAL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "deleted_at" TIMESTAMP
);

-- create table for spendings
CREATE TABLE finance.operation (
  spending_id SERIAL PRIMARY KEY,
  description TEXT NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  spender_id INTEGER REFERENCES users(user_id),
  category_id INTEGER REFERENCES operation_categories(id),
    "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "deleted_at" TIMESTAMP
);

-- create table for group spending limits
CREATE TABLE finance.group_spending_limits (
  group_id INTEGER REFERENCES groups(group_id),
  max_spending_limit DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (group_id)
);

CREATE TABLE finance.group_spending_limits_history (
  group_id INTEGER REFERENCES groups(group_id),
  max_spending_limit DECIMAL(10, 2) NOT NULL,
  timestamp TIMESTAMP NOT NULL,
  PRIMARY KEY (group_id, timestamp)
);

-- create table for user spending limits
CREATE TABLE finance.user_spending_limits (
  user_id INTEGER REFERENCES users(user_id),
  max_spending_limit DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (user_id)
);

CREATE TABLE finance.group_tasks_status (
  id SERIAL PRIMARY KEY,
  status_name TEXT NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "deleted_at" TIMESTAMP
);


CREATE TABLE finance.group_tasks (
  task_id SERIAL PRIMARY KEY,
  group_id INTEGER REFERENCES groups(group_id),
  task_name TEXT NOT NULL,
  task_description TEXT NOT NULL,
  task_status_id INTEGER REFERENCES group_tasks_status(id),
  task_creator_id INTEGER REFERENCES users(user_id),
  task_assignee_id INTEGER REFERENCES users(user_id),
  task_due_date TIMESTAMP NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "updated_at" TIMESTAMP NOT NULL DEFAULT NOW(),
    "deleted_at" TIMESTAMP
);