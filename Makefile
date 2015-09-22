# Running a command like this will push tags like base_123, development_123, and
# production_123 to the private repo:
#
# DOCKER_IMAGE_TAG=123 DOCKER_PUBLISH_PREFIX=repo.name.here/username make

.PHONY: base_container production_container docker

# The name of the image created by this project
DOCKER_IMAGE = ds-auth

ifndef DOCKER_PUBLISH_PREFIX
	# Default tag is oskarpearson/${DOCKER_IMAGE}/${DOCKER_IMAGE}:tagvalue
	DOCKER_PUBLISH_PREFIX = oskarpearson
endif

ifndef DOCKER_IMAGE_TAG
	DOCKER_IMAGE_TAG = localbuild
endif

# Default: tag and push containers
all:  build_all_containers tag push
	@echo Build Complete

# Improve cacheability by forcing the timestamps of all files to be consistent across builds
force_filesystem_timestamps:
	find . -not -iwholename '*.git*' -exec touch -t 200001010000.00 {} \;

# Build all docker containers
build_all_containers: force_filesystem_timestamps base_container test_container 

base_container:
	docker build -t "${DOCKER_IMAGE}:production_${DOCKER_IMAGE_TAG}" .
	
test_container: base_container
	docker build -t "${DOCKER_IMAGE}:test_${DOCKER_IMAGE_TAG}" .
	
# Tag repos
tag:
ifeq (${DOCKER_IMAGE_TAG}, localbuild)
	@echo Not tagging localbuild containers
else
	docker tag -f "${DOCKER_IMAGE}:base_${DOCKER_IMAGE_TAG}" "${DOCKER_PUBLISH_PREFIX}/${DOCKER_IMAGE}:base_${DOCKER_IMAGE_TAG}"
	docker tag -f "${DOCKER_IMAGE}:test_${DOCKER_IMAGE_TAG}" "${DOCKER_PUBLISH_PREFIX}/${DOCKER_IMAGE}:test_${DOCKER_IMAGE_TAG}"
	@echo Tagged successfully
endif

# Push tagged repos to the registry
push:
ifeq (${DOCKER_IMAGE_TAG}, localbuild)
	@echo Not pushing localbuild containers
else
	docker push "${DOCKER_PUBLISH_PREFIX}/${DOCKER_IMAGE}:base_${DOCKER_IMAGE_TAG}"
	docker push "${DOCKER_PUBLISH_PREFIX}/${DOCKER_IMAGE}:test_${DOCKER_IMAGE_TAG}"

	@echo Pushed successfully
endif
