Write-Host "--�������ļ�-- at " [DateTime]::Now

Remove-Item bin/Release/netcoreapp2.2/publish/* -Confirm:$false -Recurse
dotnet publish -c Release

Remove-Item bin/Release/netcoreapp2.2/publish/wwwroot/*.js -Confirm:$false -Recurse
Remove-Item bin/Release/netcoreapp2.2/publish/wwwroot/*.css -Confirm:$false -Recurse
Remove-Item bin/Release/netcoreapp2.2/publish/wwwroot/3rdpartylicenses.txt -Confirm:$false -Recurse
Remove-Item bin/Release/netcoreapp2.2/publish/wwwroot/index.html -Confirm:$false -Recurse
Remove-Item bin/Release/netcoreapp2.2/publish/wwwroot/assets -Confirm:$false -Recurse
Remove-Item bin/Release/netcoreapp2.2/publish/appsettings.*.json -Confirm:$false -Recurse
Remove-Item bin/Release/netcoreapp2.2/publish/*.pdb -Confirm:$false -Recurse

Write-Host "--����ǰ���ļ�-- at " ([DateTime]::Now)

cd ClientApp
ng build --prod
cd dist/ClientApp

Write-Host "--�滻WEBCDN·��-- at " ([DateTime]::Now)

[System.IO.File]::WriteAllText("ClientApp/dist/ClientApp/index.html",[System.IO.File]::ReadAllText("ClientApp/dist/ClientApp/index.html").Replace("<link href=""/assets/bootstrap/","<link href=""http://webcdn.cities-skylines.cn/bootstrap/").Replace("<script src=""/assets/bootstrap/","<script src=""http://webcdn.cities-skylines.cn/bootstrap/").Replace("href=""styles","href=""http://webcdn.cities-skylines.cn/angular-clientapp/styles").Replace("<script src=""polyfills","<script src=""http://webcdn.cities-skylines.cn/angular-clientapp/polyfills").Replace("<script src=""scripts","<script src=""http://webcdn.cities-skylines.cn/angular-clientapp/scripts").Replace("<script src=""main","<script src=""http://webcdn.cities-skylines.cn/angular-clientapp/main").Replace("<script src=""runtime","<script src=""http://webcdn.cities-skylines.cn/angular-clientapp/runtime"))
[System.IO.File]::WriteAllText("ClientApp/dist/ClientApp/index.html",[System.IO.File]::ReadAllText("ClientApp/dist/ClientApp/index.html").Replace("<base href=""/"">","<base href=""/"">`n    <meta name=""keywords"" content=""���������,����,����,MOD,�̳�,��Ƶ,�ٿ�,ά��,��������"">`n    <meta name=""description"" content=""�����һ��С����,�������Ѳ��ĵ� ��������� ���߰ٿ�ȫ�顣�ٿ�ȫ�� ��ѧ��ָ�� �����б� MOD �Ƽ� ��Ӫ ��̱��б� ��Ϣ��ͼ�б� ��· ��ͨ ������ͨ����"">"))
Copy-Item -Path * -Destination ../../../bin/Release/netcoreapp2.2/publish/wwwroot -Confirm:$false -Recurse

<#
<meta name="keywords" content="���������,����,����,MOD,�̳�,��Ƶ,�ٿ�,ά��,��������">
<meta name="description" content="�����һ��С����,�������Ѳ��ĵ� ��������� ���߰ٿ�ȫ�顣�ٿ�ȫ�� ��ѧ��ָ�� �����б� MOD �Ƽ� ��Ӫ ��̱��б� ��Ϣ��ͼ�б� ��· ��ͨ ������ͨ����">
#>

cd ../../../

./qshell.exe account ��ţAK ��ţSK ��ţBucketName
Write-Host "ɾ�� CDN ǰ���ļ�"
./qshell.exe listbucket ��ţBucketName -p "angular-clientapp/" -o ./tpl.startwith.angularclientapp.txt
./qshell.exe batchdelete --force ��ţBucketName -i ./tpl.startwith.angularclientapp.txt
Write-Host "�ϴ� CDN ǰ���ļ�"
foreach($item in [System.IO.Directory]::GetFiles("./ClientApp/dist/ClientApp","*.js"))
{
    $storageName = "angular-clientapp/" + [System.IO.Path]::GetFileName($item)
    Write-Host $storageName
    ./qshell.exe fput ��ţBucketName $storageName $item --overwrite
}
foreach($item in [System.IO.Directory]::GetFiles("./ClientApp/dist/ClientApp","*.css"))
{
    $storageName = "angular-clientapp/" + [System.IO.Path]::GetFileName($item)
    Write-Host $storageName
    ./qshell.exe fput ��ţBucketName $storageName $item --overwrite
}

Write-Host "�ϴ�����ļ�"
foreach($item in [System.IO.Directory]::GetFiles("./bin/Release/netcoreapp2.2/publish","*.dll"))
{
    Write-Host $item
    pscp -pw ���������� $item root@������IP:/root/cslcn
}
pscp -pw ���������� "./bin/Release/netcoreapp2.2/publish/wwwroot/index.html" root@������IP:/root/cslcn/wwwroot
pscp -pw ���������� "./bin/Release/netcoreapp2.2/publish/wwwroot/3rdpartylicenses.txt" root@������IP:/root/cslcn/wwwroot

Write-Host "���� cslcn ����"
ssh root@������IP "systemctl restart cslcn.service"

Write-Host "���� at " ([System.DateTime]::Now) 
Read-Host