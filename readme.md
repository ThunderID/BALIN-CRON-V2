## Attention
Make sure to run balin api container before running cron container

## Docker image
This version contain dockerfile to build it's own images

1. build image 
	docker build -t balin/cron .
2. run container 
	docker run -d balin/cron 

## Working directory
1.  change laravel folder for balin api (Dockerfile line 43)
2.	change .env path (Dockerfile line 46)