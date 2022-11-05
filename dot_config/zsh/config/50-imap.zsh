# ref:
# https://www.funoracleapps.com/2022/01/how-to-access-imap-server-from-command.html

# $1: host
# $2: mode [ignored]
imap-connect() {
	openssl s_client -crlf -connect "$1":993
}

# https://support.google.com/mail/answer/7126229
# gmail: imap.google.com, port 993, require ssl
alias imap-connect-gmail='imap-connect imap.google.com'
