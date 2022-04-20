# https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-2017&pivots=cs1-powershell#connect-to-sql-server
# Connect to the SQL container and run SQL commands

$SQL_SERVER = "sql1"

docker exec -it $SQL_SERVER "bash"

/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'letmein123!'

# You should see >1

CREATE DATABASE mydrivingDB
SELECT Name from sys.Databases
GO

# You should see mydrivingDB along with the other default databases

exit # exit for SQL
exit # exit for docker bash terminal

# https://docs.docker.com/network/bridge/
# Now create a network for the docker containers to speak on

docker network create my-netw

$SQL_PASSWORD = 'letmein123!'
$SQL_SERVER = 'sql1'

docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$SQL_PASSWORD" -p 1433:1433 --name $SQL_SERVER --hostname $SQL_SERVER --network my-netw -d mcr.microsoft.com/mssql/server:2017-latest
docker run -d -p 8080:80 --name poi -e "SQL_PASSWORD=$SQL_PASSWORD" -e "SQL_SERVER=$SQL_SERVER" --network my-netw -e "ASPNETCORE_ENVIRONMENT=Local" tripinsights/poi:1.0

# Import dataload from openhack (adds data to DB mydrivingDB)
docker run --network 'my-netw' -e SQLDB='mydrivingDB' -e SQLPASS='letmein123!' -e SQLUSER='sa' -e SQLFQDN='sql1' openhack/data-load:v1

# Create user for POI app to authenticate with
docker exec -it $SQL_SERVER "bash"

/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'letmein123!'

CREATE LOGIN sqladmin WITH PASSWORD = 'letmein123!'
USE mydrivingDB
CREATE USER sqladmin FOR LOGIN sqladmin
ALTER ROLE db_owner ADD MEMBER sqladmin
GO

# You should now be getting response 200 from Swagger: http://localhost:8080/api/docs/poi/index.html
