# Usa la imagen oficial de SQL Server en Docker para Linux
FROM mcr.microsoft.com/mssql/server:2019-latest

# Configura las variables de entorno necesarias
ENV ACCEPT_EULA=Y
ENV MSSQL_PID=Express
ENV SA_PASSWORD=YourStrongPassword!  # Cambia esto por una contraseña segura

# Expone el puerto SQL Server
EXPOSE 1433

# Inicia el servidor al ejecutar el contenedor
CMD /opt/mssql/bin/sqlservr
