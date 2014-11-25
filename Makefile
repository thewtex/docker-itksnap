default: nvidia

build: Dockerfile.in

nvidia: build
	cpp -DNVIDIA Dockerfile.in Dockerfile
	docker build -t itksnap .

mesa: build
	cpp -DMESA Dockerfile.in Dockerfile
	docker build -t itksnap .

.PHONY: default build nvidia
