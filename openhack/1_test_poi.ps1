<#
.SYNOPSIS
	Our first challenge is to test the POI microservice.
	We're asked to try the POI app using an SQL instance, and the ReadMe for POI states:
	"The POI (Points Of Interest) API has a dependency on a SQL Server compatible database to store the points of interest."
#>

$originalLocation = Get-Location

if (-not ((Get-ChildItem -Path .\).Name -contains "dockerfiles")) {
	Write-Output "Please set your current working directory to Containers_OpenHack"
	Exit-PSSession
}
else {
	$dockerfilesPath = (Get-Location).Path + "\dockerfiles"
	$dockerfilePath = New-Object System.Collections.Generic.List[System.Object]
	foreach ($i in 0..4) {
		$dockerfilePath.Add($dockerfilesPath + "\Dockerfile_$i")
	}

	$SQL_PASSWORD = "letmein123!"
	$SQL_SERVER = "sql1"

	Set-Location -Path ".\src\poi"
	Get-Location

	docker build -f $dockerfilePath[3] -t "tripinsights/poi:1.0" .

	docker pull mcr.microsoft.com/mssql/server:2017-latest
	docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$SQL_PASSWORD" -p 1433:1433 --name $SQL_SERVER --hostname $SQL_SERVER -d mcr.microsoft.com/mssql/server:2017-latest
	docker build -f "$dockerFiles\Dockerfile_3" -t "tripinsights/poi:1.0"
	docker run -d -p 8080:80 --name poi -e "SQL_PASSWORD=$SQL_PASSWORD" -e "SQL_SERVER=$SQL_SERVER" -e "ASPNETCORE_ENVIRONMENT=Production" tripinsights/poi:1.0
}

Set-Location $originalLocation