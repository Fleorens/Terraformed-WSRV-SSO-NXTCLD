$MyCert = $(Get-AdfsCertificate -CertificateType "Token-Signing" | Select-Object -ExpandProperty Thumbprint)
$InsertLineBreaks=1
$oMachineCert=get-item Cert:\CurrentUser\My\$MyCert
$oPem=new-object System.Text.StringBuilder
$oPem.AppendLine("-----BEGIN CERTIFICATE-----")
$oPem.AppendLine([System.Convert]::ToBase64String($oMachineCert.RawData,$InsertLineBreaks))
$oPem.AppendLine("-----END CERTIFICATE-----")
$oPem.ToString() | out-file C:\Users\Administrator\Desktop\adfs_pem.pem