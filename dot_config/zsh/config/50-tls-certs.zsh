# ref: https://stackoverflow.com/a/59412853
show-cert() {
    local server="$1" port="${2:-443}" full="$3"
    openssl \
        s_client \
        -showcerts \
        -servername "$server" \
        -connect "$server":"$port" <<<Q |
        openssl x509 -text |
        if "$full"; then cat; else grep -iA2 "Validity"; fi
}

# read the file $1 assuming a PEM certificate; if $1 is - or
# empty, use stdin
read-cert() {
    local pem_file="$1"
    case "$pem_file" in
    '' | -) openssl x509 -text ;;
    *) openssl x509 -text -in "$pem_file" ;;
    esac
}
