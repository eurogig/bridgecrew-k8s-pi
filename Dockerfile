FROM  arm64v8/python:3.8-slim-buster

COPY requirements.txt /requirements.txt

RUN apt-get update
RUN apt install -y git curl

RUN pip3 install -U bc-python-hcl2
RUN pip3 install -U bridgecrew
RUN pip3 install -U pipenv

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/arm64/kubectl \
    && chmod +x kubectl && mv kubectl /usr/local/bin
RUN groupadd -g 12000 -r bridgecrew && useradd -u 12000 --no-log-init -r -g bridgecrew bridgecrew
RUN mkdir /data && mkdir /app && mkdir /home/bridgecrew
RUN chown bridgecrew:bridgecrew /data /app /home/bridgecrew
RUN chmod -R a+w /usr/local/lib/python3.8/
COPY run_bridgecrew.sh /app
RUN chown bridgecrew:bridgecrew /app/run_bridgecrew.sh && chmod +x /app/run_bridgecrew.sh

ENTRYPOINT ["/app/run_bridgecrew.sh"]
