write-host "*****************************************************************************************"
write-host "MULTICASES para IPED 4.x. Script para criacao de multicasos em operacoes ou apreensoes"
write-host "*****************************************************************************************"

if ($args.count -gt 1 ){
   write-host "Este script não suporta multiplos argumentos. Saindo..."
   pause
   exit
}

# Search for folder "iped"
# Returns a path to iped-search-app.jar
function FindJar ($path, $depth)
{
    if ($depth -le 0) {
        return
    }
    $subdirs = @(Get-ChildItem -Path $path -Dir -ErrorAction SilentlyContinue)
    $names = $subdirs | % {$_.Name}
    if ("iped" -in $names){
        return "$($path)\iped\lib\iped-search-app.jar"
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
   write-host "O script suporta multicasos no máximo em OPERACOES. Saindo..."
}
pause
