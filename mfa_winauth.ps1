<#
.SYNOPSIS
Obtaining MFA for winauth via CLI.
#>
function mfa( $target_connection_name='sample'){
  # Adding References
  $winauth_path = 'C:\<my_path>\WinAuth\WinAuth.exe'
  [System.Reflection.Assembly]::LoadFile( $winauth_path ) | Out-Null


  # Configuration file path
  $configFile = (join-path $env:APPDATA '\WinAuth\winauth.xml')
  
  # WinAuth connection name
  $name = $target_connection_name
  
  # WinAuth password
  $password = ''
  
  # Open configuration file
  $fs = New-Object System.IO.FileStream( $configFile, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
  
  # Create XML file reader
  $reader = [System.Xml.XmlReader]::Create($fs)
  $conf = New-Object WinAuth.WinAuthConfig
  $conf.ReadXml( $reader, $password) | Out-Null

  # Get target
  $conf | Where-Object { $_.Name -eq $name } | Set-Variable wa
  # If not exist
  if ($null -eq $wa)
  {
      Write-Error ('Target[{0}] X does not exist in the configuration file.' -f $name)
      return
  }
  # Get one-time pass
  $onetime = $wa.CurrentCode
  Write-Host $onetime
  $onetime | Set-Clipboard
  
  # Close
  $fs.Close()
  $fs = $null
  $conf = $null
}
