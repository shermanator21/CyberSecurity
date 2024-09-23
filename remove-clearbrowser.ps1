function remove-clearbrowser($computername){
    Invoke-command -ComputerName $computername -scriptblock{
        # Stop ClearBrowser Process (process name unknown, but this is the placeholder if one is discovered)

        if (Get-Process -Name "<ProcessName>" -ErrorAction SilentlyContinue){
            echo ''

            echo '-------------------------------';

            echo '<ProcessName> Processes found...terminating';

            echo '-------------------------------';
            Stop-Process -Name "<ProcessName>" -Force -ErrorAction SilentlyContinue
            
        }else{
            echo ''

            echo '-------------------------------';

            echo 'No <ProcessName> Processs found';

            echo '-------------------------------';
        }


        # Remove clear Directory and files

        $badDirs = 'c:\users\*\appdata\local\programs\clear*',

        # Old Example: 'C:\users\*\downloads\Clear-EasyPrint.b7002.SK008.ch.exe',

        'C:\users\*\downloads\Clear-Easy*',

        'C:\Users\*\AppData\Local\Clear',

        'C:\Users\*\AppData\Local\ClearBrowser',

        'C:\Windows\System32\Tasks\Clear*',

        'C:\WINDOWS\SYSTEM32\TASKS\ClearStartAtLoginTask*',

        'C:\WINDOWS\SYSTEM32\TASKS\ClearUpdateChecker*',

        'C:\USERS\*\APPDATA\ROAMING\MICROSOFT\WINDOWS\START MENU\PROGRAMS\Clear.LNK'

        echo ''

        echo '-------------------------------';

        echo 'File System Artifacts Removed:'

        echo '-------------------------------';

        start-sleep -s 2;

        ForEach ($badDir in $badDirs) {
            $dsfolder = gi -Path $badDir -ea 0| select -exp fullname;
            if ( $dsfolder) {   
                echo "$dsfolder"
                rm $dsfolder -recurse -force -ea 0
            }
        }



        # Checks for Clear in AppData\Local

        $checkhandle = gi -Path 'C:\Users\*\AppData\Local\Clear' -ea 0| select -exp fullname;
        if ($checkhandle){
        echo ""
        echo "NOTE: C:\Users\*\AppData\Local\Clear' STILL EXISTS! A PROCESS HAS AN OPEN HANDLE TO IT!"
        }

        # Checks for ClearBrowser in AppData\Local

        $checkhandle = gi -Path 'C:\Users\*\AppData\Local\ClearBrowser' -ea 0| select -exp fullname;
        if ($checkhandle){
        echo ""
        echo "NOTE: C:\Users\*\AppData\Local\ClearBrowser' STILL EXISTS! A PROCESS HAS AN OPEN HANDLE TO IT!"
        }

        # Remove Scheduled Task
        echo ''

        echo '-------------------------------';

        echo 'Scheduled tasks Removed:'

        echo '-------------------------------';
        
        echo ''

        if(Get-ScheduledTask -TaskName ClearUpdateChecker* -ErrorAction SilentlyContinue) {
            Write-Output "Scheduled task ClearUpdateChecker* found...removing"
            Unregister-ScheduledTask -TaskName ClearUpdateChecker* -confirm:$false -ErrorAction SilentlyContinue
        }else{
            Write-Output "ClearUpdateChecker* scheduled task was not found"
        }

        if(Get-ScheduledTask -TaskName ClearStartAtLoginTask* -ErrorAction SilentlyContinue) {
            Write-Output "Scheduled task ClearStartAtLoginTask* found...removing"
            Unregister-ScheduledTask -TaskName ClearStartAtLoginTask* -confirm:$false -ErrorAction SilentlyContinue
        }else{
            Write-Output "ClearStartAtLoginTask* scheduled task was not found"
        }

        # Removing registry artifacts. Note that you may run into access is denied error if registry is in use

        $badreg=

        'Registry::HKU\*\Software\Clear',

        'Registry::HKU\*\Software\Clear.App',

        'Registry::HKU\*\Software\Clear.App*',
        
        'Registry::HKU\*\Software\ClearBar',

        'Registry::HKU\*\Software\ClearBar.App',

        'Registry::HKU\*\Software\ClearBar*',

        'Registry::HKU\*\Software\ClearBrowser*',

        'Registry::HKU\*\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\UNINSTALL\{D5806CCB-8635-4E7A-94FC-BF2723167477}_is1*',

        'Registry::HKLM\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\SCHEDULE\TASKCACHE\TREE\ClearUpdateChecker*',

        'Registry::HKLM\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\SCHEDULE\TASKCACHE\TREE\ClearStartAtLoginTask*'
 

        echo ''

        echo '---------------------------';

        echo 'Registry Artifacts Removed:'

        echo '---------------------------';

        Foreach ($reg in $badreg){
            $regoutput= gi -path $reg | select -exp Name
            if ($regoutput){
                "$regoutput `n"
                reg delete $regoutput /f
            }
        }

        $badreg2=

        'Registry::HKU\*\Software\Microsoft\Windows\CurrentVersion\Run',

        'Registry::HKU\*\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run'

        echo ''

        echo '----------------------------------';

        echo 'Registry Run Persistence Removed:'

        echo '----------------------------------';

        Foreach ($reg2 in $badreg2){
            $regoutput= gi -path $reg2 -ea silentlycontinue | ? {$_.Property -like 'ClearUpdateChecker*'} | select -exp Property ;
            $regpath = gi -path $reg2 -ea silentlycontinue | ? {$_.Property -like 'ClearUpdateChecker*'} | select -exp Name ;
            Foreach($prop in $regoutput){
                If ($prop -like 'ClearUpdateChecker*'){
                    "$regpath value: $prop `n"
                    reg delete $regpath /v $prop /f
                }
            }
        }

        Foreach ($reg3 in $badreg2){
            $regoutput2= gi -path $reg3 -ea silentlycontinue | ? {$_.Property -like 'Clear*'} | select -exp Property ;
            $regpath2 = gi -path $reg3 -ea silentlycontinue | ? {$_.Property -like 'Clear*'} | select -exp Name ;
            Foreach($prop2 in $regoutput2){
                If ($prop2 -like 'Clear*'){
                    "$regpath2 value: $prop2 `n"
                    reg delete $regpath2 /v $prop2 /f
                }
            }
        }
    }
}
