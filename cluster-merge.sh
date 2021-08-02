init () {
    echo "Please log into your azure account"
    auth=$(az login)
}

merge () {
# Get all the subscrition on users account
    subs=$(az account list --output tsv --query '[].[id]')
    for sub in ${subs[@]}; do
        az account set --subscription $sub
        clusters=($(az aks list --output tsv --query '[].[name]'))
        rg=($(az aks list --output tsv --query '[].[resourceGroup]'))
        if [[ "${#clusters[@]}" -ne 0 && "${#rg[@]}" -ne 0 ]]; then
            for (( i=0; i < "${#clusters[@]}"; i++ )); do
                az aks get-credentials --admin --name "${clusters[$i]}" --resource-group "${rg[$i]}" --overwrite-existing
            done
        fi
    done
}

init
merge
