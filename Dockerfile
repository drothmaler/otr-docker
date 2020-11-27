FROM debian:buster-slim

LABEL maintainer="Juergen Bruester github@devilscab.de"

# add repos for avidemux		
COPY sources.list.d/*.list /etc/apt/sources.list.d/

RUN apt-get update -oAcquire::AllowInsecureRepositories=true \
	&& apt-get install -y --no-install-recommends apt-utils gnupg \
	&& apt-get install -y --allow-unauthenticated --no-install-recommends deb-multimedia-keyring \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends  \
		avidemux-cli  \
		bc  \
		bzip2  \
		ca-certificates \
		curl  \
		dialog  \
		ffmpeg  \
		gnupg \
		procps \
	&& apt-get autoremove \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV TOOLS=/otr-tools
WORKDIR ${TOOLS}
ENV PATH $PATH:"${TOOLS}"

# install otrdecoder
RUN curl -#fsSL --compressed http://www.onlinetvrecorder.com/downloads/otrdecoder-bin-64bit-linux-static-v519.tar.bz2 | tar -xj --strip-components 1 \
	&& chmod +x otrdecoder

# install multicut
RUN curl -#fsSLO --compressed https://raw.githubusercontent.com/crushcoder/multicut_light-1/master/multicut_light.sh \
	&& chmod +x multicut_light.sh \
	&& ln -s multicut_light.sh multicut.sh \
	&& ln -s /root/ /home/root
COPY multicut_light.rc /root/.multicut_light.rc

RUN curl -#fsSLO --compressed https://raw.githubusercontent.com/m23project/otrcut.sh/master/otrcut.sh \
	&& chmod +x otrcut.sh

# batch script
COPY functions.sh auto.sh ff.sh ffall.sh mcall.sh ./
RUN chmod +x functions.sh auto.sh ff.sh ffall.sh mcall.sh

COPY README_de.md README.md /

WORKDIR /otr

CMD ["auto.sh"]