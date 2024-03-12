FROM python:3.11

RUN apt update --fix-missing && apt upgrade -y
RUN apt-get install -y openssh-client openssh-server sshpass

RUN pip install --upgrade pip setuptools wheel && \
    pip install --upgrade virtualenv && \ 
    pip install ansible==2.9

#WORKDIR /playbooks
ENV PYTHONPATH=.