for %%X in (*.SQL) do SQLCMD -S 192.168.20.3 -d TEST_DB2 -U  -P  -I -i "%%X" >> _ResultScript.txt
@echo abumb_new_2018 >> _ResultScript.txt