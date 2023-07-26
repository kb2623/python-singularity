BUILD_DEFINITION_FILE:=python.def
IMAGE_FILE:=python.sif
CONTAINER_NAME:=python

SINGULARITY_CACHEDIR=$(pwd)/build

all: build start

build: $(BUILD_DEFINITION_FILE)
	singularity build --fakeroot $(IMAGE_FILE) $(BUILD_DEFINITION_FILE)

start: $(IMAGE_FILE)
	singularity instance start $(IMAGE_FILE) $(CONTAINER_NAME)

stop: $(shell singularity instance list $(CONTAINER_NAME))
	singularity instance stop $(CONTAINER_NAME)

clean:
	rm -f ${IMAGE_FILE}
