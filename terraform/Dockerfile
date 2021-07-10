FROM hashicorp/terraform:1.0.2
RUN apk add --no-cache aws-cli curl openssl bash-completion \
    && curl -L https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/aws-iam-authenticator > /usr/local/bin/aws-iam-authenticator \
    && chmod +x /usr/local/bin/aws-iam-authenticator \
    && printf "# Shell completion\nsource '/usr/share/bash-completion/bash_completion'" > $HOME/.bashrc \
