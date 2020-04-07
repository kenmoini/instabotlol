# Use the official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.7-slim

ENV USER
ENV PASS

# Install production dependencies.
RUN pip install instapy \
 && wget https://raw.githubusercontent.com/kenmoini/instabotlol/master/app.py

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
CMD python app.py
