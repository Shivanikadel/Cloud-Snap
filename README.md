# Assignment 2 - FIT5225 - Clayton Group 44 (CloudSnap)
Git repository for Assignment 2 of FIT5225 Clayton Group 44.

The design documentation is contained in the [`documentation`](./documentation/README.md) directory, whilst the application infrastructure and code is contained in the [`src`](./src/README.md) directory.

Before getting started applying infrastructure, be sure to install the required python dependencies for each AWS Lambda. This can be achieved using

```
./install-dependencies.sh
```

in the root directory.

Note that some manual set up is required. We need to deploy the application, then enable the Cognito hosted UI, and provide the client ID and hosted UI URL to the frontend component. Then, the frontend must be built and uploaded to S3.
