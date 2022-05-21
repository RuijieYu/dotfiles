# try to color ip
alias ip='ip -c'

# brief ip output
alias i='ip -br'

local ip v
for ip in i ip; do
    for v in 4 6; do
        alias "$ip$v=$ip -$v"
    done
done
