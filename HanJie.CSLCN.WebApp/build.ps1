Write-Host "--�������ļ�-- at " [DateTime]::Now
Remove-Item bin\Release\netcoreapp2.2\publish\* -Confirm:$false -Recurse
dotnet publish -c Release

Remove-Item bin\Release\netcoreapp2.2\publish\wwwroot\*.js -Confirm:$false -Recurse
Remove-Item bin\Release\netcoreapp2.2\publish\wwwroot\*.css -Confirm:$false -Recurse
Remove-Item bin\Release\netcoreapp2.2\publish\wwwroot\3rdpartylicenses.txt -Confirm:$false -Recurse
Remove-Item bin\Release\netcoreapp2.2\publish\wwwroot\index.html -Confirm:$false -Recurse
Remove-Item bin\Release\netcoreapp2.2\publish\wwwroot\assets -Confirm:$false -Recurse

Write-Host "--����ǰ���ļ�-- at " [DateTime]::Now
s
cd ClientApp
ng build --prod
cd dist\ClientApp

Write-Host "--END-- at " [DateTime]::Now
Read-Host