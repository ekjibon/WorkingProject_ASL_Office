for %%X in (*.SQL) do SQLCMD -S 10.10.50.2 -d gvhs_new_2018 -U gdbuser -P {GdbU$er}p@SS! -I -i "%%X" >> _ResultScript.txt