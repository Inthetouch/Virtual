FROM ubuntu:latest

RUN apt-get update && apt-get install -y bash

COPY test.sh /test.sh

RUN /test.sh

CMD ["/bin/bash", "./test.sh"]