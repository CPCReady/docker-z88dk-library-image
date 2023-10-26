# Crear contenedor

## Compilar Dokerfile:
```
docker image build -t sdk-develop:v0.0.1 .
docker run -it --entrypoint /bin/zsh sdk-develop:v0.0.1
```
## Tag image
```
git tag v1.0.2 -m "XXXXXXXXXX"
git push --tags
```

## Publicar
```
docker login ghcr.io -u XXXXXXXX --password-stdin
docker push ghcr.io/cpcready/docker-z88dk-library-image:v1.0.1
```