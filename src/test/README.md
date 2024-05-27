# Assignment 2 - FIT5225 - Clayton Group 44 (CloudSnap) - Test Directory
In this directory, we provide a series of scripts and test data useful for testing the internal API directly (i.e. without first copying test data onto the bastion host).

To use it, run

```
./bastion_forward.sh $IDENTITY $BASTION_IP
```

which, for example, could look like `./bastion_forward.sh ~/.ssh/aws/id_rsa 3.95.65.75`, and then (leaving this connection up), run

```
./send.sh $METHOD $PATH $FILE
```

which might look like `./send.sh POST iod test_data/test-case.json`. This allows you to invoke the internal API directly. Alternatively, if you'd rather not use the send script, you can simply direct CURL requests to https://localhost:8080

