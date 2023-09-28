write-host "*****************************************************************"
write-host "Script para cria��o de multicasos na apreens�o"
write-host "*****************************************************************"

if ($args.count -gt 1 ){
   write-host "Script n�o suporta multiplos argumentos. Saindo..."
   pause
   exit 
} 

# Search for folder "indexador"
# Returns a path to iped-search-app.jar
function FindJar ($path, $depth)
{
    if ($depth -le 0) {
        return
    }
    $subdirs = @(Get-ChildItem -Path $path -Dir -ErrorAction SilentlyContinue)
    $names = $subdirs | % {$_.Name}
    if ("indexador" -in $names){
        return "$($path)\indexador\lib\iped-search-app.jar"
    }
    foreach($s in $subdirs) {
        $f = FindJar $s.FullName $depth-1
        if ($f) {
            return $f
        }
    }
}

$ipedSearch = FindJar $args[0] 5

if ($ipedSearch){
   # show executed commands
   Set-PSDebug -Trace 1
   $ipedSearch
   $args[0]
   java -jar "$($ipedSearch)" -multicases "$($args[0])" --nologfile
}
else {
   write-host "N�o foi possivel encontrar arquivos IPED. Voc� est� fazendo multicasos em uma opera��o ou apreens�o?"
   write-host "O script suporta multicasos no maximo em operac�es. Saindo..."
}
pause
