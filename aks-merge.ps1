function login {
    Write-Output "Please log into your azure account"
    az login   
 }

function merge {
  
    $sub = @(az account list --output tsv --query '[].[id]')
    $ErrorActionPreference = "SilentlyContinue"
    ForEach ($item in $sub){
        az account set --subscription $item
        $clusters = @(az aks list --output tsv --query '[].[name]')
        $rg = @(az aks list --output tsv --query '[].[resourceGroup]')
        if ($clusters.Count -ne 0 -and $rg.Count -ne 0){
            Write-Output ("Subscription set to $item")
            for ($i = 0; $i -le ($clusters.Count - 1); $i += 1) { 
                az aks get-credentials --admin --name $clusters[$i] --resource-group $rg[$i] --overwrite-existing
                Write-Output ("Merged " + $clusters[$i]) 
            }     
        }

    }
}

login
merge


