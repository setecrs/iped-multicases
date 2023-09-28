write-host "*****************************************************************"
write-host "Script para criação de multicasos na apreensão"
write-host "*****************************************************************"

if ($args.count -gt 1 ){
   write-host "Script não suporta multiplos argumentos. Saindo..."
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
   write-host "Não foi possivel encontrar arquivos IPED. Você está fazendo multicasos em uma operação ou apreensão?"
   write-host "O script suporta multicasos no maximo em operacões. Saindo..."
}
pause
