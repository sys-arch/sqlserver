#!/bin/bash

# Inicia SQL Server en segundo plano
/opt/mssql/bin/sqlservr &

# Espera a que SQL Server esté listo
echo "Esperando a que SQL Server esté disponible..."
sleep 30

# Ejecuta el script SQL para crear la base de datos y el usuario
echo "Aplicando el script de configuración inicial..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "$SA_PASSWORD" -i /tmp/setup.sql

# Mantiene el contenedor en ejecución
wait
