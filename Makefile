.PHONY: base_container production_container docker

# The name of the image created by this project
docker_image = defence-request-service-auth

# Produced tag is https://registry.hub.docker.com/u/oskarpearson/defence-request-service-auth/${docker_image}:tagvalue
docker_publish_prefix = oskarpearson

# Default: tag and push containers
all: force_filesystem_timestamps build_all_containers tag push
	echo Docker containers built and pushed successfully

# Improve cacheability by forcing the timestamps of all files to be consistent across builds
force_filesystem_timestamps:
	find . -not -iwholename '*.git*' -exec touch -t 200001010000.00 {} \;

# Build all docker containers
build_all_containers: base_container development_container production_container

base_container:
	cp -a docker/Dockerfile-base Dockerfile
	docker build -t "${docker_image}:base_localbuild" .
	rm -f Dockerfile

development_container: base_container
	cp -a docker/Dockerfile-development Dockerfile
	docker build -t "${docker_image}:development_localbuild" .
	rm -f Dockerfile

production_container: base_container
	cp -a docker/Dockerfile-production Dockerfile
	docker build -t "${docker_image}:production_localbuild" .
	rm -f Dockerfile

# Tag repos
tag:
ifndef DOCKER_IMAGE_TAG
	$(error DOCKER_IMAGE_TAG must be set to be able to push a version to the docker repo)
endif
	docker tag "${docker_image}:base_localbuild" "${docker_publish_prefix}/${docker_image}:base_${DOCKER_IMAGE_TAG}"
	docker tag "${docker_image}:development_localbuild" "${docker_publish_prefix}/${docker_image}:development_${DOCKER_IMAGE_TAG}"
	docker tag "${docker_image}:production_localbuild" "${docker_publish_prefix}/${docker_image}:production_${DOCKER_IMAGE_TAG}"
	echo Tagged successfully

# Push tagged repos to the registry
push:
ifndef DOCKER_IMAGE_TAG
	$(error DOCKER_IMAGE_TAG must be set to be able to push a version to the docker repo)
endif
	docker push "${docker_publish_prefix}/${docker_image}:base_${DOCKER_IMAGE_TAG}"
	docker push "${docker_publish_prefix}/${docker_image}:development_${DOCKER_IMAGE_TAG}"
	docker push "${docker_publish_prefix}/${docker_image}:production_${DOCKER_IMAGE_TAG}"

	echo Pushed successfully
