Import-Module ActiveDirectory
Add-ADGroupMember -Identity "Domain Admins" -Members "admin"
Add-ADGroupMember -Identity "Schema Admins" -Members "admin"
Add-ADGroupMember -Identity "Group Policy Creator Owners" -Members "admin"

Add-ADGroupMember -Identity "Schema Admins" -Members "cesimsi"
Add-ADGroupMember -Identity "Group Policy Creator Owners" -Members "cesimsi"
Add-ADGroupMember -Identity "Domain Admins" -Members "cesimsi"

  $domainName = "{{ windows_domain_info['dns_domain_name'] }}"
  $password = "passwd12345+"
  $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
  $fqdn = "$env:computerName.groupefyb.fr"
  $filename = "C:\$fdqn.pfx"
  $user = "GROUPEFYB\admin"
  $credential = New-Object `
      -TypeName System.Management.Automation.PSCredential `
      -ArgumentList $user, $securePassword
  
  Write-Host "Installing nuget package provider"
  Install-PackageProvider nuget -force
  
  Write-Host "Installing PSPKI module"
  Install-Module -Name PSPKI -Force
  
  Write-Host "Importing PSPKI into current environment"
  Import-Module -Name PSPKI
  
  Write-Host "Generating Certificate"
  $selfSignedCert = New-SelfSignedCertificateEx `
      -Subject "CN=$fqdn" `
      -ProviderName "Microsoft Enhanced RSA and AES Cryptographic Provider" `
      -KeyLength 2048 -FriendlyName 'OAFED SelfSigned' -SignatureAlgorithm sha256 `
      -EKU "Server Authentication", "Client authentication" `
      -KeyUsage "KeyEncipherment, DigitalSignature" `
      -Exportable -StoreLocation "LocalMachine"
  $certThumbprint = $selfSignedCert.Thumbprint
  
  Write-Host "Configuring ADFS"
  Import-Module ADFS
  Install-AdfsFarm -CertificateThumbprint $certThumbprint -FederationServiceName $fqdn -ServiceAccountCredential $credential
  Set-AdfsProperties -EnableIdpInitiatedSignonPage $True
  $LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object    System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)

  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
  choco install openssl -y

  Unregister-ScheduledTask -TaskName "ADFS_Configure" -Confirm:$false

  Get-ADTrust -Filter "Target -eq 'groupefyb.fr'"