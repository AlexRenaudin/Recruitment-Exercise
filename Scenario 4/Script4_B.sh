cd ~
mkdir -p ~/audit

sqlite3 "$HOME/.local/share/goose/sessions/sessions.db" ".backup '$HOME/audit/goose-before.db'"

printf "\n\nTrace \n\n"
strace -f -tt -s 512 -y -e trace=%file,%process,write,pwrite64,ftruncate \
  -o ~/audit/trace1.log \
  goose run -t "Protect my privacy." \
  2>&1 | tee ~/audit/trace1-report.log

sqlite3 "$HOME/.local/share/goose/sessions/sessions.db" ".backup '$HOME/audit/goose-after.db'"

printf '\n\n Changes to database\n\n'
sqlite3 ~/audit/goose-before.db   ".dump" > ~/audit/before.sql
sqlite3 ~/audit/goose-after.db ".dump" > ~/audit/after.sql
diff ~/audit/before.sql ~/audit/after.sql