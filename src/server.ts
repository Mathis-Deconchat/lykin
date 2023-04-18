import dotenv from "dotenv";

import express from "express";
import { makePluginHook, postgraphile } from "postgraphile";
import PgSimplifyInflectorPlugin from "@graphile-contrib/pg-simplify-inflector";
import PgManyToManyPlugin from "@graphile-contrib/pg-many-to-many";
import ConnectionFilterPlugin from "postgraphile-plugin-connection-filter";
import SubscriptionsLds from "@graphile/subscriptions-lds";
import { CognitoJwtVerifier } from "aws-jwt-verify";
const cors = require("cors");
const { default: PgPubsub } = require("@graphile/pg-pubsub");

dotenv.config();

const verifier = CognitoJwtVerifier.create({
  clientId: "3hu9uv4mji3r734puchibacvma",
  userPoolId: "eu-west-3_rftiJ1pB7",
  tokenUse: "id",
});

const DATABASE_URL =
  process.env.DATABASE_URL || "postgres://user:pass@host:5432/dbname";
const ROOT_DATABASE_URL = process.env.ROOT_DATABASE_URL || DATABASE_URL;
const SCHEMA_NAMES = process.env.SCHEMA_NAMES
  ? process.env.SCHEMA_NAMES.split(",")
  : "public";
const PORT = process.env.PORT || 4000;

const pluginHook = makePluginHook([PgPubsub]);

const postgraphileOptions = {
  pluginHook,
  watchPg: true,
  graphiql: true,
  enhanceGraphiql: true,
  subscriptions: true, // Enable PostGraphile websocket capabilities
  simpleSubscriptions: true,
  exportGqlSchemaPath: "schema.graphql",
  appendPlugins: [
    PgSimplifyInflectorPlugin,
    PgManyToManyPlugin,
    ConnectionFilterPlugin,
  ],
  cors: true,

  pgSettings: async (req: any) => {
    console.log(req.headers);

    const settings: any = {};

    settings["role"] = "default-role-no-jwt";

    if (req.headers.authorization) {
      const token = req.headers.authorization.split(" ")[1];
      try {
        const tokenDecoded = await verifier.verify(token);
        settings["role"] = "lykin_user";
        settings["jwt.claims.user_id"] = tokenDecoded.sub;
      } catch (err) {
        console.log(err);
      }
    }

    // Temp fix for testing
    if (req.headers["dev_user"]) {
      settings["role"] = "lykin_user";
      settings["jwt.claims.user_id"] = req.headers["dev_user"];
    }

    if (req.headers["dev_role"]) {
      if (req.headers["dev_role"] === "admin") {
        settings["jwt.claims.user_role"] = "admin";
      }
      if (req.headers["dev_role"] === "user") {
        settings["jwt.claims.user_role"] = "user";
      }
    }

    return settings;
  },
};

const app = express();
app.use(cors());
app.use(postgraphile(ROOT_DATABASE_URL, SCHEMA_NAMES, postgraphileOptions));

app.get("/hello", (req, res) => {
  res.send("Hello World!");
});
app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});
