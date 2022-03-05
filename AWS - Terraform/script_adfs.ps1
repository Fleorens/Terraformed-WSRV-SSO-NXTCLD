## Add new ad user for test

Import-Module ActiveDirectory
Add-ADGroupMember -Identity "Domain Admins" -Members "admin"
Add-ADGroupMember -Identity "Schema Admins" -Members "admin"
Add-ADGroupMember -Identity "Group Policy Creator Owners" -Members "admin"

Add-ADGroupMember -Identity "Schema Admins" -Members "cesimsi"
Add-ADGroupMember -Identity "Group Policy Creator Owners" -Members "cesimsi"
Add-ADGroupMember -Identity "Domain Admins" -Members "cesimsi"

## Set ADFS variable / Install & Configure

  $password = "passwd12345+"
  $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
  $fqdn = "$env:computerName.groupefyb.fr"
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

  Get-ADTrust -Filter "Target -eq 'groupefyb.fr'"

## Install Google Chrome (better for navigation than I.E)

  $LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object    System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)

## Import ADFS Token Key to .pem for x509 Certificate

 Invoke-Command -FilePath c:\script_get_x509.ps1 -Credential $credential -ComputerName $env:computerName

## Unregister Scheduled Task ADFS_Confiure

  Unregister-ScheduledTask -TaskName "ADFS_Configure" -Confirm:$false
