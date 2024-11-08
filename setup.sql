-- Crear la base de datos reuneme
CREATE DATABASE reuneme;

-- Cambiar a la base de datos reuneme
USE reuneme;

-- Desactivar el usuario sa para mayor seguridad
ALTER LOGIN sa DISABLE;

-- Crear un nuevo usuario llamado reuneme con permisos similares a sa
CREATE LOGIN reuneme WITH PASSWORD = 'StrongPass!123$', CHECK_POLICY = ON;
ALTER SERVER ROLE sysadmin ADD MEMBER reuneme;

-- Cambiar la base de datos por defecto del usuario
ALTER LOGIN reuneme WITH DEFAULT_DATABASE = reuneme;
