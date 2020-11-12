ARG BASE_IMAGE=python:3.6-buster
FROM $BASE_IMAGE

# install project requirements
COPY src/requirements.in /tmp/requirements.in
RUN pip install -r /tmp/requirements.in && rm -f /tmp/requirements.in

# add kedro user
ARG KEDRO_UID=999
ARG KEDRO_GID=0
RUN groupadd -f -g ${KEDRO_GID} kedro_group && \
useradd -d /home/kedro -s /bin/bash -g ${KEDRO_GID} -u ${KEDRO_UID} kedro

# copy the whole project except what is in .dockerignore
WORKDIR /home/kedro
COPY . .
RUN chown -R kedro:${KEDRO_GID} /home/kedro
USER kedro
RUN chmod -R a+w /home/kedro

EXPOSE 8888

CMD ["kedro", "run"]
