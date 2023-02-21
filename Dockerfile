FROM fedora:37

LABEL MAINTAINER="Abdul Pasaribu" \
    "GitHub Link"="https://github.com/misterabdul"

RUN dnf -y update && dnf -y install http://rpms.remirepo.net/fedora/remi-release-37.rpm \
    && dnf -y install dnf-plugins-core && dnf config-manager --set-enabled remi \
    && dnf -y install supervisor sudo curl openssh-clients wget vim git tmux unzip tar \
        procps-ng zsh zsh-syntax-highlighting zsh-autosuggestions \
    && mkdir -p /var/run/supervisor && touch /var/run/supervisor/supervisor.sock \
    && ln -sf /usr/bin/zsh /bin/sh && ln -sf /usr/bin/zsh /usr/bin/sh
COPY ./etc/ /etc/

RUN dnf -y module enable postgresql:15 && dnf -y install postgresql postgresql-server postgresql-contrib \
        && cd /var/lib/pgsql/data && su postgres -c "pg_ctl -D /var/lib/pgsql/data initdb" \
        && mkdir -p /var/log/postgresql && chown -R postgres:postgres /var/log/postgresql \
    && dnf -y module enable redis:remi-7.0 && dnf -y install redis \
    && dnf -y module enable nodejs:18 && dnf -y install nodejs npm \
    && dnf -y module enable php:remi-8.2 && dnf -y install php php-common php-pdo php-cli php-fpm php-mbstring \
        php-opcache php-sodium php-xml php-pgsql php-pecl-msgpack php-pecl-igbinary php-pecl-redis5 php-gd composer \
    && cd /usr/local && wget https://golang.google.cn/dl/go1.20.linux-amd64.tar.gz \
        && tar -xzvf go1.20.linux-amd64.tar.gz && rm go1.20.linux-amd64.tar.gz

RUN adduser -ms "$(which zsh)" cicd-bot && usermod -aG wheel cicd-bot && su cicd-bot -c \
    'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k \
    && git clone --depth=1 https://github.com/amix/vimrc.git $HOME/.vim_runtime \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm ls-remote \
    && nvm install lts/hydrogen && nvm install lts/gallium && nvm install lts/fermium && nvm alias default system'
COPY ["./home/.zshrc", "./home/.p10k.zsh", "./home/.vimrc", "/home/cicd-bot/"]

SHELL [ "/usr/bin/zsh" ]
ENTRYPOINT [ "/usr/bin/zsh" ]
USER "cicd-bot"
WORKDIR /home/cicd-bot/app
