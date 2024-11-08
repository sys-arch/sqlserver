# Usa la imagen oficial de SQL Server para Linux
FROM mcr.microsoft.com/mssql/server:2019-latest

# Configura las variables de entorno necesarias
ENV ACCEPT_EULA=Y
ENV MSSQL_PID=Express
ENV SA_PASSWORD=Y08rStr0ngP4ssword!

# Instala las herramientas de línea de comandos de SQL Server (incluyendo sqlcmd)
USER root
RUN apt-get update && apt-get install -y curl apt-transport-https && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | tee /etc/apt/sources.list.d/msprod.list && \
    apt-get update && apt-get install -y mssql-tools unixodbc-dev && \
    rm -rf /var/lib/apt/lists/* && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# Expone el puerto SQL Server
EXPOSE 1433

# Copia el archivo de configuración
COPY setup.sql /tmp/setup.sql

# Ejecuta SQL Server y luego aplica el script de configuración tras un pequeño delay
CMD /opt/mssql/bin/sqlservr & \
    sleep 30 && \
    /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -i /tmp/setup.sql
