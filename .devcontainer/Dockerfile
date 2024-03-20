FROM python:3.11

RUN apt update --fix-missing && apt upgrade -y
RUN apt-get install -y openssh-client openssh-server sshpass iputils-ping

RUN pip install --upgrade pip setuptools wheel && \
    pip install --upgrade virtualenv && \ 
    pip install ansible==9.3.0

WORKDIR /playbooks
ENV PYTHONPATH=.