BUILD_DEFINITION_FILE:=python.def
IMAGE_FILE:=python.sif
CONTAINER_NAME:=python

PYTHON_VERSION_MAJOR=3
PYTHON_VERSION_MINOR_FIRST=11
PYTHON_VERSION_MINOR_SECOND=0

SINGULARITY_CACHEDIR=$(pwd)/build

TEMP_FILE := $(shell mktemp)

all: build start

build: $(BUILD_DEFINITION_FILE)
	sed 's/PYTHON_VERSION_MAJOR=0/PYTHON_VERSION_MAJOR=${PYTHON_VERSION_MAJOR}/g' $(BUILD_DEFINITION_FILE) \
		| sed 's/PYTHON_VERSION_MINOR_FIRST=0/PYTHON_VERSION_MINOR_FIRST=${PYTHON_VERSION_MINOR_FIRST}/g' \
		| sed 's/PYTHON_VERSION_MINOR_SECOND=0/PYTHON_VERSION_MINOR_SECOND=${PYTHON_VERSION_MINOR_SECOND}/g' > $(TEMP_FILE)
	singularity build --fakeroot $(IMAGE_FILE) $(TEMP_FILE)
	rm -f $(TEMP_FILE)

start: $(IMAGE_FILE)
	singularity instance start $(IMAGE_FILE) $(CONTAINER_NAME)

stop: $(shell singularity instance list $(CONTAINER_NAME))
	singularity instance stop $(CONTAINER_NAME)

clean:
	rm -f ${IMAGE_FILE}
