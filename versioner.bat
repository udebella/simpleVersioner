
@cls
@set cheminFichierASauvegarder=C:\Users\Ubu\AppData\Roaming\.minecraft\saves
@set cheminSauvegarde=E:\Jeux\Minecraft\Sauvegarde

:VerifierParametres
@rem Vérification du paramètre 1
@IF [%1] NEQ [] (
	set cheminFichierASauvegarder=%1
)
@IF [%2] NEQ [] (
	set cheminSauvegarde=%2
)
@IF exist "%cheminFichierASauvegarder%\*.*" (
	@echo Dossier a sauvegarder: %cheminFichierASauvegarder%
) ELSE (
	@set erreur=1
	@goto Explications
)
@rem Vérification du paramètre 2
@IF exist "%cheminSauvegarde%\*.*" (
	@echo Chemin du dossier de sauvegarde: %cheminSauvegarde%
) ELSE (
	@set erreur=2
	@goto Explications
)
@goto NumeroVersion

:NumeroVersion
@dir /B %cheminSauvegarde% | find /v /c "" > tmp.txt
@set /p numeroVersion=<tmp.txt
@del tmp.txt
@echo Numero de version: %numeroVersion%
@pause
@goto Menu

:Menu
@cls
@echo Choisissez une option:
@echo 1- Effectuer une sauvegarde
@echo 2- Effectuer un backup
@echo 3- Clean backups
@echo 4- Quitter

@set/p input=Votre choix :
@if "%input%"=="1" goto CopieDossier
@if "%input%"=="2" goto ChooseBackup
@if "%input%"=="3" goto CleanBackups
@if "%input%"=="4" goto Fin
@echo Erreur: Mauvais choix du menu
@pause
@goto Menu

:CopieDossier
@xcopy "%cheminFichierASauvegarder%" "%cheminSauvegarde%\%NumeroVersion%" /e /i
@set /a NumeroVersion=%NumeroVersion%+1
@pause
@goto Menu

:ChooseBackup
@cls
@echo Choisissez la version a backuper:
@echo q- Annuler
@set /a nbrBackup=%numeroVersion%-1
@for /L %%i in (0,1,%nbrBackup%) do @echo %%i- Version %%i
@set/p backup=Votre choix :
@if "%backup%"=="q" goto Menu
@if %backup% LSS 0 goto AfficherErreurMenu
@if %backup% GTR %numeroVersion% goto AfficherErreurMenu
@goto ReverseBackup

:CleanBackups
@cls
@set /a nbrBackup=%numeroVersion%-2
@set /a lastVersion=%numeroVersion%-1
@if %nbrBackup% LSS 0 goto NoBackupToClean
@echo Suppression des sauvegardes de 0 a %nbrBackup%
@for /L %%i in (0,1,%nbrBackup%) do @rd %cheminSauvegarde%\%%i /S /Q
@ren "%cheminSauvegarde%\%lastVersion%" "0"
@set numeroVersion=1
@pause
@goto Menu

:NoBackupToClean
@echo Il n'y a pas de backup a clean
@pause
@goto Menu

:AfficherErreurMenu
@echo Erreur: Mauvais choix du menu
@pause
@goto ChooseBackup

:ReverseBackup
@echo %cheminSauvegarde%\%backup%
@xcopy /Y "%cheminSauvegarde%\%backup%" "%cheminFichierASauvegarder%" /e /i
@pause
@goto Menu


:Explications
@rem On ecrit en rouge
@cls
@echo Erreur: Parametre numero %erreur% invalide.
@echo Le premier parametre est le chemin du dossier a sauvegarder.
@echo Le second parametre est le chemin du dossier ou doit être faite la sauvegarde.
@goto Fin

:Fin
exit