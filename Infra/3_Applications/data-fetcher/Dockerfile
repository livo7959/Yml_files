# using ubuntu LTS version
FROM ubuntu:24.04 AS builder-image

# avoid stuck build due to user prompt
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install --no-install-recommends -y build-essential curl gnupg2 python3.12 python3.12-dev python3.12-venv python3-pip python3-wheel \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  # Install Azure CLI
  && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
  # create and activate virtual environment
  # using final folder name to avoid path issues with packages
  && python3.12 -m venv /home/myuser/venv

ENV PATH="/home/myuser/venv/bin:$PATH" \
  COMMON_PACKAGE_PATH=../common \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_NO_CACHE_DIR=off

# install requirements
WORKDIR /common
COPY ./python/common/. .
COPY ./3_Applications/data-fetcher/requirements.txt .
RUN pip3 install wheel \
  && pip3 install -r requirements.txt

# using ubuntu LTS version
FROM ubuntu:24.04 AS runner-image

RUN apt-get update \
  && apt-get install --no-install-recommends -y python3.12 python3-venv \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && useradd --create-home myuser
COPY --from=builder-image /home/myuser/venv /home/myuser/venv
COPY --from=builder-image /usr/bin/az /usr/bin/az
COPY --from=builder-image /opt/az/ /opt/az/

# make sure all messages always reach console
ENV PYTHONUNBUFFERED=1 \
  APP_HOME=/app \
  VIRTUAL_ENV=/home/myuser/venv \
  PATH="/home/myuser/venv/bin:$PATH"

USER myuser
RUN mkdir /home/myuser/code
WORKDIR /home/myuser/code
COPY ./3_Applications/data-fetcher/src/. .

CMD ["python", "main.py"]
