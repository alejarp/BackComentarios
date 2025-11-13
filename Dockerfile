# Fase de construcción
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar el archivo del proyecto y restaurar dependencias (para un mejor caché)
COPY src/*.csproj ./src/
RUN dotnet restore ./src/*.csproj

# Copiar todo el código fuente al contenedor
COPY src/ ./

# Publicar la aplicación (en la carpeta /out)
RUN dotnet publish ./src/ -c Release -o /out

# Fase de ejecución
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base

# Establecer el directorio de trabajo donde se ejecutará la app
WORKDIR /app

# Copiar los archivos de la fase anterior (los archivos publicados)
COPY --from=build /out .

# Exponer el puerto donde la app estará escuchando
EXPOSE 80

# Comando para ejecutar la aplicación
ENTRYPOINT ["dotnet", "BEComentarios.dll"]
