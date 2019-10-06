# setting maintainer
LABEL maintainer="@securitychops"

# grabbing latest ubuntu image
FROM ubuntu:latest

# setup new user account and add to sudo
RUN apt-get update && \
    echo "Y" | apt-get install -y sudo && \
    useradd -m $USERNAME && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    adduser $PASSWORD sudo && \
    echo '%sudo ALL=(ALL) ALL' >> /etc/sudoers

# setting default user to whatever is provided
USER $USERNAME

# setting working directory to user home directory
WORKDIR /home/$USERNAME

COPY .start.sh .

RUN mkdir -p ~/.config/s3fs && \
    mkdir -p ~/mahbucket && \
    export PATH=$PATH:~/ && \
    echo $PASSWORD | sudo -S chmod +x .start.sh && \
    echo $PASSWORD | sudo -S apt-get install -y git && \
    echo $PASSWORD | sudo -S apt-get install -y golang-go && \
    echo $PASSWORD | sudo -S apt-get install -y s3fs && \
    go get github.com/subfinder/subfinder

# run our script first yo dawg
CMD ["bash", ".start.sh"]
