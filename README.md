# New-Shortcut (PowerShell Function)

This is a function that creates a new shortcut pointing to the specified file or
directory, with support for relative paths and automatic link name generation.

It creates a shortcut based on the Target specified by the user. It also accepts
the parameter Name,which can be a name to create a link in current directory, or
a path to the link. Optionally, arguments may be specified to the shortcut,
usually useful when creating shortcuts for executables.

NOTE: The function will overwrite any existing shortcut with the same name.

<br />
## Parameters:

**Target**
Target file or directory for which a shortcut will be created. This can be an
absolute path or a relative path, which will be resolved. This parameter is the
first positional parameter, so it does not have to be specifically identified
with the -Target option.

**Name (Optional)**
Name or path for the new shortcut. If not provided, the name of the target file
or directory will be used. The extension '.lnk' is automatically added, and if
it is provided manually, it is trimmed and re-added to avoid the shortcut having
duplicate .lnk extensions.

This parameter is the second positional parameter, so it does not have to be
explicitly specified using the -Name option, but instead, just providing the
string as second string in the command call (even if -Args is specified first
or in-between Target and Name.)

**Args (Optional)**
Arguments to be passed to the target file. It can be used for directories
aswell, but that will have no effect. This is not a positional parameter, and
needs to be explicitly specified with the -Args option.

<br />
## Example Usage:

Create a shortcut to the Start Menu directory of all users.
`New-Shortcut "C:\ProgramData\Microsoft\Windows\Start Menu\Programs" "Start Menu (All Users)"`

Create a shortcut that calls cmd.exe with some commands.
`New-Shortcut C:\Windows\System32\cmd.exe -Args '/C "echo Hello & pause"' "Say Hello"`

<br />
## Credits

**Author: Arttu H. (2art)**
**Email: [mailto:2art@pm.me](2art@pm.me)**
**Website: [https://github.com/2art](GitHub: 2art)**
