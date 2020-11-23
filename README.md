# pre requisite

[docker] (https://docs.docker.com/get-docker/)

# build dtndocker image
Build the base image in the project root containing 'dockerfile' with the following:

``` docker build -t iondtn . ```

# Run iondtn image as a container

``` docker run iondtn ```

use ```docker ps``` to see your running containers

# Run QoS example

```docker exec -it <CONTAINER ID> ./dotest```

Replace <CONTAINER ID>  with the container ID found from `docker ps`


# Notes
This repo uses examples directly from ion-open-source-4.0.0, which is available through [sourceforge](https://sourceforge.net/projects/ion-dtn/). This repo also includess an updated version of ion-open-source-4.0.0 which is modified for the docker base image. 
