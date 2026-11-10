FROM docker
WORKDIR /usr/src/app
COPY builder.sh .
RUN chmod +x builder.sh
ENTRYPOINT ["./builder.sh"]

#docker run -e DOCKER_USERNAME=syncopated1 -e DOCKER_PASSWORD= -v /var/run/docker.sock:/var/run/docker.sock builder mluukkai/express_app syncopated1/testing
  