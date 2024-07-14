
# NPS修改版

### 0.`cmd/npc2`,`cmd/nps2`为修改版,`cmd/npc`,`cmd/nps`为原版

### 1.参数由`-server`格式改为长短格式`--server/-s`,见`-h`

### 2.命令行参数可追加在文件尾部,实现单文件启动,例如`echo 'CMDLINE: --server xxx:1234 --vkey zzzz'>>npc2`

### 3.命令行参数支持加密,例如`./nps2 --encryptcmd '--server xxx:1234 --vkey zzzz'`, 客户端: `./npc2 --cmd XXXXXXX(加密后的参数)`

### 4.加密后的参数同样支持追加到文件尾部的方式,例如`echo 'CMDLINE: --cmd XXXX'>>npc2`

