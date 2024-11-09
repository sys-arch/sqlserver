# Usa la imagen oficial de SQL Server para Linux
FROM mcr.microsoft.com/mssql/server:2019-latest

# Configura las variables de entorno necesarias
ENV ACCEPT_EULA=Y
ENV MSSQL_PID=Express
ENV SA_PASSWORD=YourStrongPassword!

# Instala gnupg y sqlcmd
USER root
RUN apt-get update && \
    apt-get install -y gnupg gnupg2 gnupg1 curl apt-transport-https && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | tee /etc/apt/sources.list.d/msprod.list && \
    apt-get update && \
    apt-get install -y mssql-tools unixodbc-dev && \
    rm -rf /var/lib/apt/lists/* && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# Copia el archivo de configuración SQL
COPY setup.sql /tmp/setup.sql
RUN chmod 644 /tmp/setup.sql

# Cambiar permisos de la carpeta /var/opt/mssql para evitar errores de permisos
RUN chown -R mssql:mssql /var/opt/mssql

# Cambia a usuario mssql
USER mssql

# Expone el puerto SQL Server
EXPOSE 1433

# Script de inicio
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Usamos el entrypoint.sh para iniciar SQL Server y aplicar el script SQL
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
