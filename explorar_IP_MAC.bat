@echo off
setlocal enabledelayedexpansion

rem :: Define la base de la dirección IP y el rango
set /p IP_BASE=Introduce IP Base: 
set /p START=Introduce IP Inicio: 
set /p END= Introduce IP Fin: 

rem :: Encabezado de la tabla (para escapar de los carácteres especiales se usa "^")
echo    +--------------------------------------+
echo    ^|    IP Address    ^|    MAC Address    ^|
echo    ^|------------------^|-------------------^|

rem :: Loop a través del rango de direcciones IP
for /l %%i in (%START%,1,%END%) do (
    set "IP_ADDRESS=%IP_BASE%.%%i"
    
rem :: Realiza un ping a la dirección IP
    ping -n 1 -w 1 !IP_ADDRESS! >nul
    
rem :: Usa arp para obtener la dirección MAC
rem :: Con tokens=2 estamos especificando que queremos el segundo argumento, es decir, la MAC como sale en el ejemplo:
rem :: Internet Address      Physical Address      Type
rem :: 192.168.1.254         00-1a-2b-3c-4d-5e     dynamic
rem :: En este caso, cada línea de la salida se divide en "tokens" separados por espacios o tabulaciones. Por ejemplo, en la última línea de la salida:
rem :: * El primer token es 192.168.1.254
rem :: * El segundo token es 00-1a-2b-3c-4d-5e
rem :: * El tercer token es dynamic
rem :: Por lo tanto, el comando for asignará este segundo token a la variable %%a, que luego se utiliza para establecer la variable MAC_ADDRESS en el script
    for /f "tokens=2" %%a in ('arp -a !IP_ADDRESS! ^| findstr !IP_ADDRESS!') do (
        set "MAC_ADDRESS=%%a"
    )
    
rem :: Imprime la dirección IP y la dirección MAC si se encontró una
    if defined MAC_ADDRESS (
        set "SPACES=   "
        if %%i lss 10 set "SPACES=    "
        if %%i gtr 99 set "SPACES=  "
        echo    ^|   !IP_ADDRESS!!SPACES!^| !MAC_ADDRESS! ^|
        set "MAC_ADDRESS="
    )
)
echo    +------------------+-------------------+

endlocal
