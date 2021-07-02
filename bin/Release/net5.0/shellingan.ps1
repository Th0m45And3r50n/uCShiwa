function Invoke-Shellingan{
    <#
    .SYNOPSIS
        Simple Recursive Powershell Command Obfuscation - for training purpose

    .DESCRIPTION
        https://github.com/Aif4thah/Shellingan

    .PARAMETER cmd
        command (mandatory)

    .PARAMETER iex
        add invoke-expression (usefull to execute your commands)

    .PARAMETER recurse
        number of obfuscation loop (increase output length!)

    .OUTPUTS
        Then you just have to copy-paste the output where you want execute it.

    .EXAMPLE
        Invoke-Shellingan -cmd 'write helloworld' -iex $true -recurse 1

    .NOTES
        TO DO: Pipe, sleep time

    #>
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string] $cmd,

        [Parameter(Mandatory=$false, Position=1)]
        [System.Boolean] $iex,

        [Parameter(Mandatory=$false, Position=2)]
        [int] $recurse
    
    )begin{

        if(-not $rot){
            Write-Verbose "<cmd> : $cmd" 
            Write-Verbose "<iex> : $iex" 
            Write-Verbose "<rec> : $recurse"
        }

        function rul($in){
            Write-Verbose "<0> Randomnize Case..."
            $array = $in.Toupper(),$in.ToLower()
            for($i=0; $i -lt $in.length; $i++){
                $output += ($array[(get-random -min 0 -max 2)][$i]).ToString()
            }
            return $output
        }

        function concat($in){
            Write-Verbose "<0> Randomnize Concatenation..."
            $output='"'
            for($i=0; $i -lt $in.length; $i++){
                $output += ($in[$i]).ToString()
                if((Get-Random -Minimum 0 -Maximum 2) -and ($i -lt $in.length) ){ $output += '"+"' }
            }
            return $output + '"' + "|iex"
        }

    }Process{

        Write-Verbose "<0> Bytes Rotation..."
        [byte[]] $scriptBytes = [system.Text.Encoding]::UTF8.GetBytes((rul(concat($cmd))))  
        $rot = Get-Random -Maximum 254 -Minimum 5
        $derot = 255 - $rot
        $rotbytes = [system.Text.Encoding]::UTF8.GetBytes('')
        $scriptBytes |%{ $rotbytes += ($_ + $rot)%255}

        Write-Verbose "<0> Back to [string]..."
        $output = ""
        $rotBytes |%{$output += $_.tostring() + ","}
        $output = $output -replace ".$"

        Write-Verbose "<0> Payload Generation..."
        $rand1 = Get-Random -Maximum 254 -Minimum 5 ; $rand2 = Get-Random -Maximum 254 -Minimum 5 ; $rand3 = Get-Random -Maximum 254 -Minimum 5
        $output =  "`$$rand2=255;`$$rand1=[sYsTeM.TeXT.eNcOdInG];`$$rand3=`$$rand1::utF8.gEtbYtES('');`$$rand1::asCii.gEtsTRiNG(`$(([bYtE]" + $output + ")|%{`$$rand3+=(`$_+(`$$rand2+$derot))%`$$rand2};`$$rand3))"
    
    }end{   

        if($iex){$output+= "|iex"}
        if($recurse -gt 1){Invoke-Shellingan $output $iex ($recurse-=1)  }
        else{
            write-host -ForegroundColor DarkRed "<O>Shellingan<0>"
            return rul($output)
        }
    }
}
