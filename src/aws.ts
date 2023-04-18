import {
  CognitoIdentityProviderClient,
  AddCustomAttributesCommand,
  ListUsersCommand,
  AdminGetUserCommand,
} from "@aws-sdk/client-cognito-identity-provider";
import dotenv from "dotenv";

dotenv.config();

const cognitoClient = new CognitoIdentityProviderClient({
  region: "eu-west-3",
});

// const command = new ListUsersCommand({
//     UserPoolId: "eu-west-3_rftiJ1pB7",
//     AttributesToGet: ["email"],
//     Limit: 60,
// });

const command = new AdminGetUserCommand({
  UserPoolId: "eu-west-3_rftiJ1pB7",
  Username: "eb41bbf0-ee54-4067-b512-78387e909a94",
});

cognitoClient.send(command).then((response) => {
  console.log(response);
});
