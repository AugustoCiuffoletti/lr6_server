.PHONY: multiarch push build run clean

# Default values for variables
OWNER = mastrogeppetto
IMAGE  ?= lr6_server
TAG   ?= latest
# arm64 or amd64
ARCH ?= amd64
# apt source
LOCALBUILD ?= 0

# Push everything and create multiarch manifest
multiarch:
	ARCH=arm64 make push
	ARCH=amd64 make push
	docker manifest create \
		$(OWNER)/$(IMAGE):$(TAG) \
		--amend $(OWNER)/$(IMAGE):amd64-$(TAG) \
		--amend $(OWNER)/$(IMAGE):arm64-$(TAG)
	docker manifest push $(OWNER)/$(IMAGE):$(TAG)
# Push image on dockerhub
push:
	ARCH=$(ARCH) make build
	docker push $(OWNER)/$(IMAGE):$(ARCH)-$(TAG)
# Build the image
build:
	cp Dockerfile Dockerfile.$(ARCH)
	docker buildx build --load --platform linux/$(ARCH) -t $(OWNER)/$(IMAGE):$(ARCH)-$(TAG) -f Dockerfile.$(ARCH) .
#  Test run
run:
	docker run --rm -h server -p 2023:22 $(IMAGE):$(ARCH)-$(TAG)

# Remove images
clean:
	docker rmi $(IMAGE):$(ARCH)-$(TAG)
	docker image prune -f
