
function remove-wavebrowser($computername){
    Invoke-command -computername $computername -scriptblock{
        # Stop Wave Browser Processes

        if (Get-Process -Name wavebrowser -ErrorAction SilentlyContinue){
            echo ''

            echo '-------------------------------';

            echo 'wavebrowser Processes found...terminating';

            echo '-------------------------------';
            Stop-Process -Name wavebrowser -Force -ErrorAction SilentlyContinue
            
        }else{
            echo ''

            echo '-------------------------------';

            echo 'No wavebrowser Processs found';

            echo '-------------------------------';
        }
        
        if (Get-Process -Name SWUpdaterCrashHandler* -ErrorAction SilentlyContinue){
            echo ''

            echo '-------------------------------';

            echo 'SWUpdaterCrashHandler* Processes found...terminating';

            echo '-------------------------------';
            Get-Process -Name SWUpdaterCrashHandler* | %{Stop-Process -Name $_.name -Force -ErrorAction SilentlyContinue}
            
        }else{
            echo ''

            echo '-------------------------------';

            echo 'No SWUpdaterCrashHandler* Processs found';

            echo '-------------------------------';
        }
        if (Get-Process -Name SWUpdater -ErrorAction SilentlyContinue){
            echo ''

            echo '-------------------------------';

            echo 'SWUpdater Processes found...terminating';

            echo '-------------------------------';
            Get-Process -Name SWUpdater | %{Stop-Process -Name $_.name -Force -ErrorAction SilentlyContinue}
            
        }else{
            echo ''

            echo '-------------------------------';

            echo 'No SWUpdater Processs found';

            echo '-------------------------------';
        }
        # Remove wavebrowser Directory and files

        $badDirs = 'C:\Users\*\Wavesor Software',

        'C:\Users\*\Downloads\Wave Browser*.exe',

        'C:\Users\*\AppData\Local\WaveBrowser',

        'C:\Windows\System32\Tasks\Wavesor Software_*',

        'C:\WINDOWS\SYSTEM32\TASKS\WAVESORSWUPDATERTASKUSER*CORE',

        'C:\WINDOWS\SYSTEM32\TASKS\WAVESORSWUPDATERTASKUSER*UA',

        'C:\USERS\*\APPDATA\ROAMING\MICROSOFT\WINDOWS\START MENU\PROGRAMS\WAVEBROWSER.LNK',

        'C:\USERS\*\APPDATA\ROAMING\MICROSOFT\INTERNET EXPLORER\QUICK LAUNCH\WAVEBROWSER.LNK',

        'C:\USERS\*\APPDATA\ROAMING\MICROSOFT\INTERNET EXPLORER\QUICK LAUNCH\USER PINNED\TASKBAR\WAVEBROWSER.LNK'

        echo ''

        echo '-------------------------------';

        echo 'File System Artifacts Removed;'

        echo '-------------------------------';

        start-sleep -s 2;

        ForEach ($badDir in $badDirs) {
            $dsfolder = gi -Path $badDir -ea 0| select -exp fullname;
            if ( $dsfolder) {   
                echo "$dsfolder"
                rm $dsfolder -recurse -force -ea 0
            }
        }

        $checkhandle = gi -Path 'C:\Users\*\AppData\Local\WaveBrowser' -ea 0| select -exp fullname;
        if ($checkhandle){
        echo ""
        echo "NOTE: C:\Users\*\AppData\Local\WaveBrowser' STILL EXISTS! A PROCESS HAS AN OPEN HANDLE TO IT!"
        }

        # Remove Scheduled Task
        echo ''

        echo '-------------------------------';

        echo 'Scheduled tasks Removed;'

        echo '-------------------------------';

        if(Get-ScheduledTask -TaskName WavesorSWUpdater* -ErrorAction SilentlyContinue) {
            Write-Output "Scheduled task WavesorSWUpdater* found...removing"
            Unregister-ScheduledTask -TaskName WavesorSWUpdater* -confirm:$false -ErrorAction SilentlyContinue
        }else{
            Write-Output "WavesorSWUpdater* scheduled task was not found"
        }

        if(Get-ScheduledTask -TaskName WaveBrowser-StartAtLogin* -ErrorAction SilentlyContinue) {
            Write-Output "Scheduled task WaveBrowser-StartAtLogin* found...removing"
            Unregister-ScheduledTask -TaskName WaveBrowser-StartAtLogin* -confirm:$false -ErrorAction SilentlyContinue
        }else{
            Write-Output "WaveBrowser-StartAtLogin* scheduled task was not found"
        }

        # Remove Reg

        $badreg=

        'Registry::HKU\*\Software\WaveBrowser',

        'Registry::HKU\*\SOFTWARE\CLIENTS\STARTMENUINTERNET\WaveBrowser.*',

        'Registry::HKU\*\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\APP PATHS\wavebrowser.exe',

        'Registry::HKU\*\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\UNINSTALL\WaveBrowser',

        'Registry::HKU\*\Software\Wavesor',

        'Registry::HKLM\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\SCHEDULE\TASKCACHE\TREE\WavesorSWUpdaterTaskUser*UA',

        'Registry::HKLM\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\SCHEDULE\TASKCACHE\TREE\WavesorSWUpdaterTaskUser*Core',

        'Registry::HKLM\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\SCHEDULE\TASKCACHE\TREE\Wavesor Software_*'

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
            $regoutput= gi -path $reg2 -ea silentlycontinue | ? {$_.Property -like 'Wavesor SWUpdater'} | select -exp Property ;
            $regpath = gi -path $reg2 -ea silentlycontinue | ? {$_.Property -like 'Wavesor SWUpdater'} | select -exp Name ;
            Foreach($prop in $regoutput){
                If ($prop -like 'Wavesor SWUpdater'){
                    "$regpath value: $prop `n"
                    reg delete $regpath /v $prop /f
                }
            }
        }
    }
}