.PHONY: base_container production_container docker

# The name of the image created by this project
docker_image = defence-request-service-auth

# Produced tags is registry.service.dsd.io/defence-request-service/${docker_image}:tagvalue
docker_publish_prefix = registry.service.dsd.io/defence-request-service

# Default: tag and push containers
all: build_all_containers tag push
	echo Docker containers built and pushed successfully

# Build all docker containers
build_all_containers: base_container development_container production_container

base_container:
	docker build -t "${docker_image}:base_localbuild" -f docker/Dockerfile-base .

development_container: base_container
	docker build -t "${docker_image}:development_localbuild" -f docker/Dockerfile-development .

production_container: base_container
	docker build -t "${docker_image}:production_localbuild" -f docker/Dockerfile-production .

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
