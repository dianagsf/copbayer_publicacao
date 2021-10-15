const amplifyconfig =
    ''' {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CredentialsProvider": {
                    "CognitoIdentity": {
                        "Default": {
                            "PoolId": "us-east-1:23723184-56dd-4824-a5de-c582064a610e",
                            "Region": "us-east-1"
                        }
                    }
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-east-1_AApHu8JuN",
                        "AppClientId": "76ib3gook8j8g1v4bij3jnajeo",
                        "AppClientSecret": "10becuaf6p8eclp186qd634kgnebfc9bltc15rld460frldesahi",
                        "Region": "us-east-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH"
                    }
                },
                "S3TransferUtility": {
                    "Default": {
                        "Bucket": "copbayerfiles102212-copbayer",
                        "Region": "us-east-1"
                    }
                }
            }
        }
    },
    "storage": {
        "plugins": {
            "awsS3StoragePlugin": {
                "bucket": "copbayerfiles102212-copbayer",
                "region": "us-east-1",
                "defaultAccessLevel": "guest"
            }
        }
    }
}''';
