# build dtndocker image
Build the base image in the project root containing 'dockerfile' with the following:

``` docker build -t iondtn . ```

# Run iondtn image as a container

``` docker run iondtn ```

use ```docker ps``` to see your running containers

# Run QoS example

```docker exec -it <CONTAINER ID> ./dotest```

Replace <CONTAINER ID>  with the container ID found from `docker ps`
