default: nvidia

build: Dockerfile.in

nvidia: build
	cpp -DNVIDIA Dockerfile.in Dockerfile
	docker build -t itksnap .

.PHONY: all build nvidia
