VERSION       = 1.0
NAME          = gitolite
OWNER         = lopesivan
MACHINENAME   = $(OWNER)/$(NAME)
DATE          = $(shell date '+%Y-%m-%d')
BASH          = /bin/sh

DOCKER_COMPOSE= docker-compose
DOCKER        = docker
CONTAINER_NAME= $(NAME)
EMAIL         = ivan@42algoritmos.local

latest        = $(VERSION)

all: status

run: export CONTAINER_NAME := $(CONTAINER_NAME)
run: export NAME           := $(NAME)
run: export OWNER          := $(OWNER)
run: export VERSION        := $(VERSION)
run: export DATE           := $(DATE)
run:
	$(DOCKER_COMPOSE) run --rm --name $(NAME) $(NAME)

up: export CONTAINER_NAME := $(CONTAINER_NAME)
up: export NAME           := $(NAME)
up: export OWNER          := $(OWNER)
up: export VERSION        := $(VERSION)
up: export DATE           := $(DATE)
up:
	$(DOCKER_COMPOSE) up -d

ps:
	$(DOCKER) ps -a

status:
	$(DOCKER) stats --all --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

info:
	$(DOCKER) inspect -f '{{ index .Config.Labels "build_version" }}' $(MACHINENAME):$(latest)

pause:
	$(DOCKER) $@ $(CONTAINER_NAME)
unpause:
	$(DOCKER) $@ $(CONTAINER_NAME)

images:
	$(DOCKER) images --format "{{.Repository}}:{{.Tag}}"| sort
ls:
	$(DOCKER) images --format "{{.ID}}: {{.Repository}}"
size:
	$(DOCKER) images --format "{{.Size}}\t: {{.Repository}}"
tags:
	$(DOCKER) images --format "{{.Tag}}\t: {{.Repository}}"| sort -t ':' -k2 -n

net:
	$(DOCKER) network ls

rm-network:
	$(DOCKER) network ls| awk '$$2 !~ "(bridge|host|none)" {print "docker network rm " $$1}' | sed '1d'

rmi:
	docker rmi $(MACHINENAME):$(latest)

rm-all:
	$(DOCKER) ps -aq -f status=exited| xargs $(DOCKER) rm

stop-all:
	$(DOCKER) ps -aq -f status=running| xargs $(DOCKER) stop

log:
	$(DOCKER) logs -f $(CONTAINER_NAME)

ip:
	$(DOCKER) ps -q \
	| xargs $(DOCKER) inspect --format '{{ .Name }}:{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'\
	| \sed 's/^.*://'

memory:
	$(DOCKER) inspect `$(DOCKER) ps -aq` | grep -i mem

fix:
	$(DOCKER) images -q --filter "dangling=true"| xargs $(DOCKER) rmi -f

stop:
	$(DOCKER) stop $(CONTAINER_NAME)

rm:
	$(DOCKER) rm $(CONTAINER_NAME)

exec:
	$(DOCKER) exec -it $(CONTAINER_NAME) $(BASH)

restart:
	$(DOCKER) restart  $(CONTAINER_NAME)

build: export CONTAINER_NAME := $(CONTAINER_NAME)
build: export NAME           := $(NAME)
build: export OWNER          := $(OWNER)
build: export VERSION        := $(VERSION)
build: export DATE           := $(DATE)
build:
	$(DOCKER_COMPOSE) build

unbuild: rmi

clean: stop rm

