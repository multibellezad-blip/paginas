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
5. **Dockerfile Location**: dejalo en `/Dockerfile`.
   Coolify concatena este valor al *Base Directory*, no a la raiz del repo
   (en su codigo la ruta es `workdir + dockerfile_location`, y `workdir` ya
   incluye el base directory). Poner aqui `/egopixel/Dockerfile` lo romperia,
   porque buscaria `/egopixel/egopixel/Dockerfile`.
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

## Si el deploy falla con `open Dockerfile: no such file or directory`

En el log veras `transferring dockerfile: 2B`. Significa que Coolify busca el
Dockerfile donde no esta: el **Base Directory** sigue en `/` y en la raiz del
repo ya no hay Dockerfile.

Arreglo: en la aplicacion, **Build → Base Directory** = `/egopixel` o `/joryx`
segun el sitio, y **Dockerfile Location** en `/Dockerfile`. Luego redespliega.

Ojo tambien con el caso contrario: si una app despliega "correctamente" pero
muestra la web equivocada, es que tiene el Base Directory en `/` y esta
construyendo el Dockerfile antiguo de la raiz.
