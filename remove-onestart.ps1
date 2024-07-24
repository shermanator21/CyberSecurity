# OneStart removal script

# Source: https://www.reddit.com/r/crowdstrike/comments/15z3y02/comment/jxf6vb7/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button


function remove-onelaunch($computername){
    Invoke-command -computername $computername -scriptblock{

        # find running processes with "OneStart/DBar" in them
        $valid_path = "C:\Users\*\AppData\Roaming\OneStart\*"

        $process_names = @("DBar")

        foreach ($proc in $process_names){

        $OL_processes = Get-Process | Where-Object { $_.Name -like $proc }

        if ($OL_processes.Count -eq 0){

        Write-Output "No $proc processes were found."

        }

        else {

        write-output "The following processes contained $proc and file paths will be checked: $OL_processes"

        foreach ($process in $OL_processes){

        $path = $process.Path

        if ($path -like $valid_path){

        Stop-Process $process -Force

        Write-Output "$proc process file path matches and has been stopped."

        }

        else {

        Write-Output "$proc file path doesn't match and process was not stopped."

        }

        }

        }

        }

        Start-Sleep -Seconds 2

        $file_paths = @("\AppData\Roaming\OneStart\", "\AppData\local\OneStart.ai" )

        # iterate through users for onestart related directories and deletes them

        foreach ($folder in (get-childitem c:\users)) {

        foreach ($fpath in $file_paths){

        $path = $folder.pspath + $fpath

        if (test-path $path) {

        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue

        write-output "$path has been deleted."

        }

        }

        }

        $reg_paths = @("\software\OneStart.ai")

        # iterate through users for onestart related registry keys and removes them

        foreach ($registry_hive in (get-childitem registry::hkey_users)) {

        foreach ($regpath in $reg_paths){

        $path = $registry_hive.pspath + $regpath

        if (test-path $path) {

        Remove-item -Path $path -Recurse -Force

        write-output "$path has been removed."

        }

        }

        }

        $reg_properties = @("OneStartBar", "OneStartBarUpdate", "OneStartUpdate")

        foreach($registry_hive in (get-childitem registry::hkey_users)){

        foreach ($property in $reg_properties){

        $path = $registry_hive.pspath + "\software\microsoft\windows\currentversion\run"

        if (test-path $path){

        $reg_key = Get-Item $path

        $prop_value = $reg_key.GetValueNames() | Where-Object { $_ -like $property }

        if ($prop_value){

        Remove-ItemProperty $path $prop_value

        Write-output "$path\$prop_value registry property value has been removed."

        }

        }

        }

        }

        $schtasknames = @("OneStart Chromium", "OneStart Updater")

        $c = 0

        # find onestart related scheduled tasks and unregister them

        foreach ($task in $schtasknames){

        $clear_tasks = get-scheduledtask -taskname $task -ErrorAction SilentlyContinue

        if ($clear_tasks){

        $c++

        Unregister-ScheduledTask -TaskName $task -Confirm:$false

        Write-Output "Scheduled task '$task' has been removed."

        }

        }

        if ($c -eq 0){

        Write-Output "No OneStart scheduled tasks were found."

        }
    }
}