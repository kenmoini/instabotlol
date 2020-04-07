# Use the official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.7-slim

ENV USER defaultUser
ENV PASS defaultPass
ENV SIMULATION True

RUN apt-get update && apt-get install -y --no-install-recommends wget git \
	&& rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/kenmoini/instabotlol \
 && cd instabotlol \
 && pip install -r requirements.txt \
 && cp main.py ..
 
CMD python main.py
