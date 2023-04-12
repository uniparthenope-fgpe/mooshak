FROM mooshak/mooshak:2.2.0.5-light

# configs
ARG PORT=80

# update PATH
ENV JAVA_HOME /usr/local/openjdk-8
ENV PATH $JAVA_HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates netbase xz-utils curl \
  && rm -rf /var/lib/apt/lists/*

# install python

RUN apt-get update \
  && apt-get install -y python3 python3-pip

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/python3 /usr/local/bin/python3

# install ML python library

RUN pip install --upgrade pip

COPY requirements.txt .
RUN pip install -r requirements.txt

ENV PYTHONWARNINGS ignore

# install JavaScript
ENV NODEJS_VERSION v14.7.0

RUN curl https://nodejs.org/dist/${NODEJS_VERSION}/node-${NODEJS_VERSION}-linux-x64.tar.xz -O

RUN mkdir -p /usr/local/node && tar -xf node-${NODEJS_VERSION}-linux-x64.tar.xz -C /usr/local/node --strip-components=1 && rm node-${NODEJS_VERSION}-linux-x64.tar.xz
RUN ln -s /usr/local/node/bin/node /usr/local/bin/node
RUN ln -s /usr/local/node/bin/npm /usr/local/bin/npm
RUN ln -s /usr/local/node/bin/npx /usr/local/bin/npx

# add FGPE sample data
COPY data /home/mooshak/data
COPY scripts /home/mooshak/scripts

# Expose port
EXPOSE ${PORT}

# add volume
VOLUME [ "/home/mooshak/data" ]

# Run Mooshak server
ENTRYPOINT [ "/home/mooshak/tomcat8/bin/catalina.sh", "run" ]
