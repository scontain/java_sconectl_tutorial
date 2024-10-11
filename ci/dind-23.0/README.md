# Build and Deploy the CI Docker Image

This image is used to run the jobs in the Demo repository.
We use the registry `registry.scontain.com` to store the image under path `cicd/tabajara/ci-docker-demo`.

Whenever this image gets updated, e.g., a new package is added, rebuild it an push it to the registry as follows.

```console
export REVISION=2
cd ci/dind-23.0
docker build . -t registry.scontain.com/cicd/tabajara/ci-docker-demo:23.0-dind-r${REVISION}
docker push registry.scontain.com/cicd/tabajara/ci-docker-demo:23.0-dind-r${REVISION}
```

Once the image has successfully been uploaded, update the Github workflows to use the newest revision.
