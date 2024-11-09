# Usa la imagen oficial de SQL Server para Linux
FROM mcr.microsoft.com/mssql/server:2019-latest

# Configura las variables de entorno necesarias
ENV ACCEPT_EULA=Y
ENV MSSQL_PID=Express
ENV SA_PASSWORD=YourStrongPassword!

# Instala gnupg y sqlcmd, y configura SSL
USER root
RUN apt-get update && \
    apt-get install -y gnupg gnupg2 gnupg1 curl apt-transport-https && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | tee /etc/apt/sources.list.d/msprod.list && \
    apt-get update && \
    apt-get install -y mssql-tools unixodbc-dev && \
    rm -rf /var/lib/apt/lists/* && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# Configurar SSL para SQL Server
RUN mkdir -p /etc/ssl/certs && \
    mkdir -p /etc/ssl/private && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/sqlserver.key \
    -out /etc/ssl/certs/sqlserver.crt \
    -subj "/CN=localhost"

# Cambiar permisos de los certificados para SQL Server
RUN chmod 600 /etc/ssl/private/sqlserver.key && \
    chmod 644 /etc/ssl/certs/sqlserver.crt

# Configuración de SQL Server para usar SSL/TLS
ENV MSSQL_SSL_CERTIFICATE=/etc/ssl/certs/sqlserver.crt
ENV MSSQL_SSL_KEY=/etc/ssl/private/sqlserver.key
ENV MSSQL_TCP_PORT=1433

# Expone el puerto SQL Server
EXPOSE 1433

# Copia el archivo de configuración SQL
COPY setup.sql /tmp/setup.sql

# Ejecuta SQL Server y aplica el script de configuración tras un pequeño delay
CMD /opt/mssql/bin/sqlservr & \
    sleep 30 && \
    /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -i /tmp/setup.sql
