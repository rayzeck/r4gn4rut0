@echo off
setlocal EnableDelayedExpansion

:: Define nome do atualizacoes
set "atualizacoes=atualizacoes.txt"
if exist "%atualizacoes%" del "%atualizacoes%"

echo Gerando %atualizacoes% na pasta:
echo %cd%
echo.

:: Loop por todos os arquivos da pasta e subpastas
for /R %%F in (*) do (
    if /I not "%%~nxF"=="atualizacoes.txt" (
        set "full=%%F"
        set "rel=%%F"
        set "rel=!rel:%cd%\=!"
        if "!rel:~0,1!"=="\" set "rel=!rel:~1!"

        set "hash="

        for /f "skip=1 tokens=1" %%H in ('certutil -hashfile "%%F" SHA256 ^| find /v "certutil"') do (
            if not defined hash (
                set "hash=%%H"
            )
        )

        if defined hash (
            echo !rel!^|!hash!^|>> "%atualizacoes%"
        )
    )
)

echo.
echo atualizacoes.txt criado com sucesso!
echo Pressione qualquer tecla para sair...
pause >nul
