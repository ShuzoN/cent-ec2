DNF=$(shell which dnf)
YUM=$(shell which yum)
SYSTEMCTL=$(shell which systemctl)
CURL=$(shell which curl)
DOCKER_COMPOSE_VERSION=1.27.4
DOCKER_COMPOSE_URL:="https://github.com/docker/compose/releases/download/$(DOCKER_COMPOSE_VERSION)/docker-compose-$(shell uname -s)-$(shell uname -m)"
DOCKER_COMPOSE=/usr/local/bin/docker-compose

init:
	$(YUM) install -y dnf

.$(DNF):
	$(DNF) update
	$(DNF) upgrade
	$(DNF) install -y 'dnf-command(config-manager)'
	$(DNF) config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

install: init .$(DNF) install/docker install/docker-compose

install/docker:
	$(DNF) install -y docker-ce docker-ce-cli containerd.io
	$(SYSTEMCTL) start docker
	$(SYSTEMCTL) enable docker

install/docker-compose:
	$(CURL) -L $(DOCKER_COMPOSE_URL) -o $(DOCKER_COMPOSE)
	chmod +x $(DOCKER_COMPOSE)

