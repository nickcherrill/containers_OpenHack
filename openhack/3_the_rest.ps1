

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

	Set-Location -Path ".\src\trips"
	Get-Location

	docker build -f $dockerfilePath[4] -t "tripinsights/trips:1.0" .
	docker run -d -p 8081:80 --name trips -e "SQL_PASSWORD=$SQL_PASSWORD" -e "SQL_SERVER=$SQL_SERVER" -e "ASPNETCORE_ENVIRONMENT=Production" tripinsights/trips:1.0

	Set-Location -Path $originalLocation
	Set-Location -Path ".\src\tripviewer"
	Get-Location

	docker build -f $dockerfilePath[1] -t "tripinsights/tripviewer:1.0" .
	docker run -d -p 8082:80 --name tripviewer -e "SQL_PASSWORD=$SQL_PASSWORD" -e "SQL_SERVER=$SQL_SERVER" -e "ASPNETCORE_ENVIRONMENT=Production" tripinsights/tripviewer:1.0

	Set-Location -Path $originalLocation
	Set-Location -Path ".\src\user-java"
	Get-Location

	docker build -f $dockerfilePath[0] -t "tripinsights/user-java:1.0" .
	docker run -d -p 8083:80 --name user-java -e "SQL_PASSWORD=$SQL_PASSWORD" -e "SQL_SERVER=$SQL_SERVER" -e "ASPNETCORE_ENVIRONMENT=Production" tripinsights/user-java:1.0

	Set-Location -Path $originalLocation
	Set-Location -Path ".\src\userprofile"
	Get-Location

	docker build -f $dockerfilePath[2] -t "tripinsights/userprofile:1.0" .
	docker run -d -p 8084:80 --name userprofile -e "SQL_PASSWORD=$SQL_PASSWORD" -e "SQL_SERVER=$SQL_SERVER" -e "ASPNETCORE_ENVIRONMENT=Production" tripinsights/userprofile:1.0
}

Set-Location $originalLocation



az acr build --registry registryxcw9261 -f C:\Users\Nick\Documents\Repos\OpenHack\04-2022\containers_OpenHack\dockerfiles\Dockerfile_3 --image tripinsights/poi:v1 .