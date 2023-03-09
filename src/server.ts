import dotenv from "dotenv";

import express from "express";
import { postgraphile } from "postgraphile";
import PgSimplifyInflectorPlugin from "@graphile-contrib/pg-simplify-inflector";
import PgManyToManyPlugin from "@graphile-contrib/pg-many-to-many";
import ConnectionFilterPlugin from "postgraphile-plugin-connection-filter";
import SubscriptionsLds from "@graphile/subscriptions-lds";

dotenv.config();

const DATABASE_URL =
  process.env.DATABASE_URL || "postgres://user:pass@host:5432/dbname";
const ROOT_DATABASE_URL = process.env.ROOT_DATABASE_URL || DATABASE_URL;
const SCHEMA_NAMES = process.env.SCHEMA_NAMES
  ? process.env.SCHEMA_NAMES.split(",")
  : "public";
const PORT = process.env.PORT || 4000;

const postgraphileOptions = {
    watchPg: true,
    graphiql: true,
    enhanceGraphiql: true,
    subscriptions: false,
    appendPlugins: [
        PgSimplifyInflectorPlugin,
        PgManyToManyPlugin,
        ConnectionFilterPlugin,
        SubscriptionsLds,
    ],
}

const app = express();
app.use(postgraphile(ROOT_DATABASE_URL, SCHEMA_NAMES, postgraphileOptions));
app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`);
});