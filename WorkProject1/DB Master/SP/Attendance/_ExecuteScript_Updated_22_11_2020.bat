for %%X in (*.SQL) do sqlcmd -S 192.168.20.2 -d ASL_Office_DB -U adbuser -P "adb@A^g5nEHY-N" -I -i "%%X" 
for %%X in (*.SQL) do sqlcmd -S 192.168.20.2 -d ASL_Office_DB_test -U adbuser -P "adb@A^g5nEHY-N" -I -i "%%X" 
pause




































