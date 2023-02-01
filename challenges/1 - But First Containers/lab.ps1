# 1 - Build Docker image for POI application
cd /workspaces/2023-openhack-containers/team-work/src/poi
docker build -t poi .

# 2 - Start SQL Server container
docker pull mcr.microsoft.com/mssql/server:2017-latest
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=ChangeMe12345@@" -p 1433:1433 --name sql1 -d mcr.microsoft.com/mssql/server:2017-latest

# 3 - Create database inside SQL Server container
docker exec -it sql1 "bash"

/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "ChangeMe12345@@"
CREATE DATABASE mydrivingDB;
GO
SELECT Name from sys.Databases;

docker login registryckv0271.azurecr.io -u registryckv0271 -p du27RiWErrrqGEGghmSwCI0dPXYhtc1z2kU18z1MP3+ACRCIQhh7

# 4 - Run Data Load application
docker run --network host -e SQLFQDN=localhost -e SQLUSER=sa -e SQLPASS="ChangeMe12345@@" -e SQLDB=mydrivingDB registryckv0271.azurecr.io/dataload:1.0

# 5 - Run POI application
docker run -e ASPNETCORE_ENVIRONMENT="local" -e SQL_SERVER="sql1" -e SQL_USER="sa" -e SQL_PASSWORD="ChangeMe12345@@" -p 8080:80 --name poi poi

# 6 - Test POI application
http://localhost:8080/api/poi/healthcheck

# 7 - Build and push all components` images to ACR
docker build -t registryckv0271.azurecr.io/dataload:1.0 -f Dockerfile.dataload .
dockerfile_0 = user-java
dockerfile_1 = tripviewer
dockerfile_2 = userprofile
dockerfile_3 = poi
dockerfile_4 = trips

# user-java
cd /workspaces/2023-openhack-containers/team-work/src/user-java

docker build . -t registryckv0271.azurecr.io/user-java:latest
docker push registryckv0271.azurecr.iouser-java:latest

# trip-viewer
cd /workspaces/2023-openhack-containers/team-work/src/trip-viewer

docker build . -t registryckv0271.azurecr.io/trip-viewer:latest
docker push registryckv0271.azurecr.io/trip-viewer:latest

# userprofile
cd /workspaces/2023-openhack-containers/team-work/src/userprofile

docker build . -t registryckv0271.azurecr.io/userprofile:latest
docker push registryckv0271.azurecr.io/userprofile:latest

# poi
cd /workspaces/2023-openhack-containers/team-work/src/poi
docker build -t registryckv0271.azurecr.io/poi:latest
docker push registryckv0271.azurecr.io/poi:latest

# trips
cd /workspaces/2023-openhack-containers/team-work/src/trips

docker build . -t registryckv0271.azurecr.io/trips:latest
docker push registryckv0271.azurecr.io/trips:latest