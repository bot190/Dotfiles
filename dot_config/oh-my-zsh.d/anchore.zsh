# TODO: update this to store the pull token in 1Password
export GITHUB_RELEASE_PULL_TOKEN=$(security find-generic-password -a "$USER" -s "GITHUB_RELEASE_PULL_TOKEN" -w)

alias sso='aws sso login --profile testing'
alias lzd='lazydocker -f /Users/benbeauregard/enterprise/dev-compose-files/docker-compose.yaml -f /Users/benbeauregard/enterprise/dev-compose-files/docker-compose.ui.yaml -f /Users/benbeauregard/enterprise/dev-compose-files/docker-compose.registry.yaml -f /Users/benbeauregard/enterprise/dev-compose-files/docker-compose.prometheus.yaml -f /Users/benbeauregard/enterprise/dev-compose-files/docker-compose.grafana.yaml -f /Users/benbeauregard/enterprise/dev-compose-files/docker-compose.feeds.yaml -f /Users/benbeauregard/enterprise/dev-compose-files/docker-compose.keycloak.yaml'

#anchorectl_env () {
#    system=$1
#    if [[ $system == "rc" ]] || [[ $system == "nightly" ]] || [[ $system == "preview" ]]; then
#        shift
#        $_anchorectl_path --password $(op read "op://Engineering Team/$system.anchore.ninja/password") --url http://api.$system.anchore.ninja:8228 $@
#    else
#        $_anchorectl_path $@
#    fi
#}

export PATH="/Users/benbeauregard/anchorectl/snapshot/darwin-build_darwin_arm64:$PATH"
alias ractl='anchorectl --config ~/.anchorectl.rc.yaml'
alias nactl='anchorectl --config ~/.anchorectl.nightly.yaml'
alias dactl='anchorectl --config ~/.anchorectl.dogfood.yaml'
alias lctl='anchorectl --config ~/.anchorectl.local.yaml'

cp_volume() {
    from=$1
    to=$2
    docker container run --rm -it -v "$from:/from" -v "$to:/to" alpine ash -c "cd /from ;  cp -av . /to"
}

restore_volume() {
    from=$1
    cp_volume "$from" "dev-compose-files_anchore-db-volume"
}

backup_volume() {
    to=$1
    cp_volume "dev-compose-files_anchore-db-volume" "$to"
}
