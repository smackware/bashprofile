alias drm="docker rm"
alias dps="docker ps"
alias dl='docker ps -l -q'
alias docker_ip="docker inspect --format '{{ .NetworkSettings.IPAddress }}' "
docker_shell() { docker exec -i -t "$1" bash; }
docker_logf() { docker logs -f "$1"; }
