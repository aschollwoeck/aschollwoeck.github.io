echo WebSite mit Hugo erstellen...
hugo.exe

echo Ordner kopieren
xcopy /y /s ".\public\*" "..\"

#echo Zu Github pushen
#git add --all
#git commit -m "Update"
#git push origin master