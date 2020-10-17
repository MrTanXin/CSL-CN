Write-Host "--�������ļ�-- at " [DateTime]::Now

Remove-Item bin\Release\netcoreapp2.2\publish\* -Confirm:$false -Recurse
dotnet publish -c Release

Remove-Item bin\Release\netcoreapp2.2\publish\wwwroot\*.js -Confirm:$false -Recurse
Remove-Item bin\Release\netcoreapp2.2\publish\wwwroot\*.css -Confirm:$false -Recurse
Remove-Item bin\Release\netcoreapp2.2\publish\wwwroot\3rdpartylicenses.txt -Confirm:$false -Recurse
Remove-Item bin\Release\netcoreapp2.2\publish\wwwroot\index.html -Confirm:$false -Recurse
Remove-Item bin\Release\netcoreapp2.2\publish\wwwroot\assets -Confirm:$false -Recurse
Remove-Item bin\Release\netcoreapp2.2\publish\appsettings.*.json -Confirm:$false -Recurse
Remove-Item bin\Release\netcoreapp2.2\publish\*.pdb -Confirm:$false -Recurse

Write-Host "--����ǰ���ļ�-- at " [DateTime]::Now

cd ClientApp
ng build --prod
cd dist\ClientApp

Write-Host "--�滻WEBCDN·��-- at " [DateTime]::Now

[System.IO.File]::WriteAllText("ClientApp/dist/ClientApp/index.html",[System.IO.File]::ReadAllText("ClientApp/dist/ClientApp/index.html").Replace("<link href=""/assets/bootstrap/","<link href=""http://webcdn.cities-skylines.cn/bootstrap/").Replace("<script src=""/assets/bootstrap/","<script src=""http://webcdn.cities-skylines.cn/bootstrap/").Replace("href=""styles.","href=""http://webcdn.cities-skylines.cn/angular-clientapp/styles.").Replace("<script src=""runtime.","<script src=""http://webcdn.cities-skylines.cn/angular-clientapp/runtime.").Replace("<script src=""polyfills","<script src=""http://webcdn.cities-skylines.cn/angular-clientapp/polyfills").Replace("<script src=""scripts.","<script src=""http://webcdn.cities-skylines.cn/angular-clientapp/scripts.").Replace("<script src=""main.","<script src=""http://webcdn.cities-skylines.cn/angular-clientapp/main."))
Copy-Item -Path * -Destination ../../../bin/Release/netcoreapp2.2/publish/wwwroot -Confirm:$false -Recurse

Invoke-Item ../../../bin/Release/netcoreapp2.2/publish/

<#
<meta name="keywords" content="���������,����,����,MOD,�̳�,��Ƶ,�ٿ�,ά��,��������">
<meta name="description" content="�����һ��С����,�������Ѳ��ĵ� ��������� ���߰ٿ�ȫ�顣�ٿ�ȫ�� ��ѧ��ָ�� �����б� MOD �Ƽ� ��Ӫ ��̱��б� ��Ϣ��ͼ�б� ��· ��ͨ ������ͨ����">
#>

Write-Host "--END-- at " [DateTime]::Now
Read-Host