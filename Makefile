YUM=$(shell which yum)
SYSTEMCTL=$(shell which systemctl)
CURL=$(shell which curl)
DOCKER_COMPOSE_VERSION=1.27.4
DOCKER_COMPOSE_URL:="https://github.com/docker/compose/releases/download/$(DOCKER_COMPOSE_VERSION)/docker-compose-$(shell uname -s)-$(shell uname -m)"
DOCKER_COMPOSE=/usr/local/bin/docker-compose

.$(YUM):
	$(YUM) update
	$(YUM) upgrade
	$(YUM) install -y yum-utils device-mapper-persistent-data lvm2
	yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

install: .$(YUM) install/docker install/docker-compose

install/docker:
	$(YUM) install -y docker-ce docker-ce-cli containerd.io
	$(SYSTEMCTL) start docker
	$(SYSTEMCTL) enable docker

install/docker-compose:
	$(CURL) -L $(DOCKER_COMPOSE_URL) -o $(DOCKER_COMPOSE)
	chmod +x $(DOCKER_COMPOSE)

