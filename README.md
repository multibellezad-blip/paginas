# paginas

Landing pages estáticas, una carpeta por marca:

- `egopixel/` → egopixel.com
- `joryx/` → joryx.com

Cada carpeta es una imagen Docker independiente (`nginx:alpine` sirviendo el HTML)
y se despliega como una **aplicación separada en Coolify**, apuntando las dos al
mismo repositorio. Así cada dominio tiene su propio contenedor, su propio
certificado SSL y su propio deploy: tocar una web no reinicia la otra.

## Configuración en Coolify

Repite estos pasos **dos veces**, una por sitio.

1. **New Resource → Application → Private Repository (GitHub App)** y elige este repo.
2. **Branch**: `main`.
3. **Build Pack**: `Dockerfile`.
4. **Base Directory**: `/egopixel` (en la segunda app, `/joryx`).
5. **Dockerfile Location**: `/Dockerfile`.
   Si el build no lo encuentra, pon la ruta completa: `/egopixel/Dockerfile`.
6. **Ports Exposes**: `80`.
7. **Domains**: `https://egopixel.com` (en la otra, `https://joryx.com`).
   Escribe el `https://` — es lo que hace que Coolify pida el certificado a Let's Encrypt.
8. **Health Check**: activado, `Path: /`, `Port: 80`.
9. Deploy.

## DNS

En el registrador de cada dominio, apuntando a la IP del servidor de Coolify:

| Tipo | Nombre | Valor              |
|------|--------|--------------------|
| A    | `@`    | IP del servidor    |
| A    | `www`  | IP del servidor    |

El certificado solo se emite cuando el DNS ya resuelve a esa IP. Si despliegas
antes de propagar el DNS, vuelve a lanzar el deploy después.

## Probar en local

```sh
cd egopixel
docker build -t egopixel .
docker run --rm -p 8080:80 egopixel
# http://localhost:8080
```
