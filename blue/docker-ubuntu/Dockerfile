# Use official Ubunbtu 16.04 image base
FROM ubuntu:16.04

# Update system package manager
RUN apt-get update --yes

# Install Python package manager (PIP)
RUN apt-get install --yes python-pip
RUN pip install --upgrade pip

# Install system libraries required for Blue
RUN apt-get install --yes build-essential
RUN apt-get install --yes libopenmpi-dev
RUN apt-get install --yes gfortran
RUN apt-get install --yes libvtk5-dev

# We use wget later to fetch conda
RUN apt-get install --yes wget

# Install sudo (required for changing file ownership to run as non-root user)
RUN apt-get -y install sudo

# Add the user UID:1000, GID:1000, home at /app
RUN groupadd -r docker -g 1000 && useradd -u 1000 -r -g docker -m -d /docker -s /sbin/nologin -c "Docker user" docker && chmod 755 /docker

# Add the user to the sudo group and allow them to call sudo with no password
RUN sudo adduser docker sudo && echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# All commands below will run as Blue user (i.e. non-root)
USER docker

# Install VTK via conda as the apt-get install --yes python-vtk version doesn't work
# Install conda
RUN wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O ~/miniconda.sh && bash ~/miniconda.sh -b -p /docker/miniconda

# Add conda directory to front of path
ENV PATH /docker/miniconda/bin:$PATH

# Install Python VTK
RUN conda install --yes vtk

# Copy Blue code compiled for Ubuntu (COPY always runs as root)
COPY secret-source/blue-source-ubuntu /blue

# Change owner of key directories to Blue user
RUN sudo chown -R docker: /blue

CMD /bin/bash
