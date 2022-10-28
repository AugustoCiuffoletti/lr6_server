.PHONY: multiarch push build run clean

# Default values for variables
OWNER = mastrogeppetto
IMAGE  ?= lr6-server
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
	docker tag $(IMAGE):$(ARCH)-$(TAG) $(OWNER)/$(IMAGE):$(ARCH)-$(TAG)
	docker push $(OWNER)/$(IMAGE):$(ARCH)-$(TAG)
# Rebuild the image
build:
	cp Dockerfile Dockerfile.$(ARCH)
	docker buildx build --load --platform linux/$(ARCH) -t $(IMAGE):$(ARCH)-$(TAG) -f Dockerfile.$(ARCH) .
#  Test run
run:
	docker run --rm -d -h server -p 2022:22 $(REPO):$(TAG)

# Remove images
clean:
	docker rmi $(IMAGE):amd64-$(TAG)
	docker rmi $(IMAGE):arm64-$(TAG)
	docker image prune -f
