# Use the official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.7-slim

ENV USER defaultUser
ENV PASS defaultPass

RUN apt-get update && apt-get install -y --no-install-recommends wget git \
	&& rm -rf /var/lib/apt/lists/*

RUN pip install instapy \
 && git clone https://github.com/kenmoini/instabotlol \
 && cp instabotlol/app.py .
 
CMD python app.py
