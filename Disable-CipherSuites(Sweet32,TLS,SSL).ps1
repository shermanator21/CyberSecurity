$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL"

#Disable 3DES (Sweet32)
New-Item -Path $Path\Ciphers -Name "Triple DES"
New-Item -Path $Path\Ciphers -Name "Triple DES 168"
New-ItemProperty -Path "$Path\Ciphers\Triple DES" -Name Enabled -PropertyType DWord -Value "00000000" -Force
New-ItemProperty -Path "$Path\Ciphers\Triple DES 168" -Name Enabled -PropertyType DWord -Value "00000000" -Force

#Disable TLS 1.0 and 1.1
<#
New-Item -Path $Path\Protocols -Name "TLS 1.0"
New-Item -Path "$Path\Protocols\TLS 1.0" -Name "Server"
New-Item -Path $Path\Protocols -Name "TLS 1.1"
New-Item -Path "$Path\Protocols\TLS 1.1" -Name "Server"
New-ItemProperty -Path "$Path\Protocols\TLS 1.0\Server" -Name Enabled -PropertyType DWord -Value "00000000" -Force
New-ItemProperty -Path "$Path\Protocols\TLS 1.1\Server" -Name Enabled -PropertyType DWord -Value "00000000" -Force
#>

#Disable SSL2.0 and 3.0
<#
New-Item -Path $Path\Protocols -Name "SSL 2.0"
New-Item -Path "$Path\Protocols\SSL 2.0" -Name "Server"
New-Item -Path $Path\Protocols -Name "SSL 3.0"
New-Item -Path "$Path\Protocols\SSL 3.0" -Name "Server"
New-ItemProperty -Path "$Path\Protocols\SSL 2.0\Server" -Name Enabled -PropertyType DWord -Value "00000000" -Force
New-ItemProperty -Path "$Path\Protocols\SSL 3.0\Server" -Name Enabled -PropertyType DWord -Value "00000000" -Force
#>