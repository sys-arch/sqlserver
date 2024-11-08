# Usa la imagen oficial de SQL Server para Linux
FROM mcr.microsoft.com/mssql/server:2019-latest

# Configura las variables de entorno necesarias
ENV ACCEPT_EULA=Y
ENV MSSQL_PID=Express
ENV SA_PASSWORD=Y08rStr0ngP4ssword!

# Expone el puerto SQL Server
EXPOSE 1433

# Copia el archivo de inicialización
COPY setup.sql /tmp/setup.sql

# Cambia a usuario root para ejecutar el script y otros permisos
USER root

# Cambia el propietario de la carpeta temporal para el usuario mssql
RUN chown mssql /tmp/setup.sql

# Cambia de nuevo a usuario mssql para ejecutar SQL Server y configura los permisos
USER mssql

# Ejecuta SQL Server con el script de inicialización
CMD /opt/mssql/bin/sqlservr & sleep 30 && /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -i /tmp/setup.sql
