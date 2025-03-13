function New-Shortcut() {

  <#
  .SYNOPSIS
      Creates a new shortcut pointing to the specified file or directory, with
      support for relative paths and automatic link name generation.

  .DESCRIPTION
      New-Shortcut is a function that creates a shortcut based on the Target specified
      by the user. It also accepts the parameter Name, which can be a name to create a
      link in current directory, or a path to the link. Optionally, arguments may be
      specified to the shortcut, usually useful when creating shortcuts for executables.
      NOTE: This will automatically overwrite any existing shortcut with the same name.

  .PARAMETER Target
      Target file or directory for which a shortcut will be created. This can be an
      absolute path or a relative path, which will be resolved.
      This parameter is the first positional parameter, so it does not have to be
      specifically identified with the -Target option.

  .PARAMETER Name
      (Optional) Name or path for the new shortcut. If not provided, the name of the
      target file or directory will be used. The extension '.lnk' is automatically
      added, and if it is provided manually, it is trimmed and re-added to avoid the
      shortcut having duplicate .lnk extensions.
      This parameter is the second positional parameter, so it does not have to be
      explicitly specified using the -Name option, but instead, just providing the
      string as second string in the command call (even if -Args is specified first
      or in-between Target and Name.)

  .PARAMETER Args
      (Optional) Arguments to be passed to the target file. It can be used for
      directories aswell, but that will have no effect.
      This is not a positional parameter, and needs to be explicitly specified with
      the -Args option.

  .EXAMPLE
      New-Shortcut "C:\ProgramData\Microsoft\Windows\Start Menu\Programs" "Start Menu (All Users)"

  .EXAMPLE
      New-Shortcut C:\Windows\System32\cmd.exe -Args '/C "echo Hello & pause"' "Say Hello"

  .NOTES
       Author: Arttu H. (2art)
        Email: 2art@pm.me
      Website: https://github.com/2art
  #>

  param (
    [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Path to the target file or directory. This can be both, full path or a relative path.")]
    [string]$Target,

    [Parameter(Mandatory = $false, Position = 2, HelpMessage = "Name or path for the new shortcut to be created. Extension .lnk is added automatically. If not provided, the name of the target file or directory is used.")]
    [string]$Name = "",

    [Parameter(Mandatory = $false, HelpMessage = "Optional arguments to pass to the target")]
    [string]$Args = ""
  )

  $resolvedPath = Resolve-Path $Target

  # Check if Name is provided
  if ($Name.trim() -eq "") {
    # Name not provided; Extract the final part of the path, which is the actual target
    $finalName = $resolvedPath.Path.TrimEnd('\') -replace '^(?:.*[/\\])*(.+)$', '$1.lnk'
  } else {
    # Name was provided; Trim possible manually added .lnk extension, and add it back here
    $finalName = $Name.TrimEnd('.lnk') + ".lnk"
  }

  # If creating a local link, prepend current working directory to form a full path
  if ($finalName -notmatch '.*[/\\].*') {
    $finalName = $PWD.Path + "\$finalName"
  }

  # Create shell object which is used to create the actual shortcut.
  $WshShell = New-Object -COMObject WScript.Shell
  $Shortcut = $WshShell.CreateShortcut($finalName)
  $Shortcut.TargetPath = $resolvedPath.Path
  if ($Args.trim() -ne "") { $Shortcut.Arguments = $Args }

  # Shortcut has been configured; Save it to the filesystem.
  $Shortcut.Save()
  Write-Output "    `"$finalName`"`n -> `"$resolvedPath`" $Args"
}
