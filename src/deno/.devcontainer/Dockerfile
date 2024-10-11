FROM denoland/deno:bin-${templateOption:denoVersion} AS deno
FROM mcr.microsoft.com/devcontainers/typescript-node:${templateOption:nodeVersion}
COPY --from=deno /deno /usr/local/bin/deno