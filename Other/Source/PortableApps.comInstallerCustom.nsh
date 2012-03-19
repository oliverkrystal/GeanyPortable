!macro CustomCodePreInstall	
	ReadINIStr $9 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
	StrCmp $9 "" "" +2
	StrCpy $9 "9.9.9.9" ;never, ever try to upgrade a fresh install
	WriteINIStr "$INSTDIR\Data\settings\GeanyPortableSettings.ini" "LastVersion" "UpdateFrom" "$9"
		;===Check if we need to deal with nonsense
		${VersionCompare} "$9" "0.20.0.0" $9 ;The reason for this code is because with the release of Geany 0.20 I changed how I was handling GTK.  This will update a user's GTK seamlessly
		${if} $9 == 2
			CreateDirectory "$INSTDIR\Preserve"
			CreateDirectory "$INSTDIR\Preserve\share"
			CreateDirectory "$INSTDIR\Preserve\lib\gtk-2.0"
			Rename "$INSTDIR\App\GTK\share\themes" "$INSTDIR\Preserve\share\themes"
			Rename "$INSTDIR\App\GTK\lib\gtk-2.0\2.10.0" "$INSTDIR\Preserve\lib\gtk-2.0\2.10.0"
			Rename "$INSTDIR\App\GTK\etc\gtk-2.0\gtkrc" "$INSTDIR\Data\settings\gtkrc"
		${endif}
!macroend


!macro CustomCodePostInstall
	ReadINIStr $9 "$INSTDIR\Data\settings\GeanyPortableSettings.ini" "LastVersion" "UpdateFrom"
	${VersionCompare} "$9" "0.20.0.0" $9 ;The reason for this code is because with the release of Geany 0.20 I changed how I was handling GTK.  This will update a user's GTK seamlessly
	${if} $9 == 2
		Rmdir /r "$INSTDIR\App\Geany\lib\gtk-2.0\2.10.0"
		Rmdir /r "$INSTDIR\App\Geany\share\themes"
		CopyFiles /SILENT "$INSTDIR\Preserve\share\themes" "$INSTDIR\App\Geany\share\themes"
		CopyFiles /SILENT  "$INSTDIR\Preserve\lib\gtk-2.0\2.10.0" "$INSTDIR\App\Geany\lib\gtk-2.0\2.10.0"
		RMDir /r "$INSTDIR\Preserve"
	${endif}
!macroend
