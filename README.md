# Crear contenedor

## Compilar Dokerfile:
```
docker image build -t cpcready-base:v0.0.1 .
docker run -it --entrypoint /bin/zsh cpcready-base:v0.0.1
