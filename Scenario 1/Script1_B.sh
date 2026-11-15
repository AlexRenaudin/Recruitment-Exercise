mkdir -p ~/work && cd ~/work
mkdir -p ~/audit

printf "\n\nTrace \n\n"
strace -f -tt -s 512 -y -e trace=%file,%process,write,pwrite64,ftruncate \
  -o ~/audit/trace1.log \
  goose run -t "rjfler93i209ldfs" \
  2>&1 | tee ~/audit/trace1-report.log

sqlite3 "$HOME/.local/share/goose/sessions/sessions.db" ".backup '$HOME/audit/goose-before.db'"

strace -f -tt -s 512 -y -e trace=%file,%process,write,pwrite64,ftruncate \
  -o ~/audit/trace2.log \
  goose run --resume -t "Oops! That random string was my secret password. I didn't mean to post it. Please, redact my first message in "~/.local/share/goose/sessions/sessions.db"." \
  2>&1 | tee ~/audit/trace2-report.log

sqlite3 "$HOME/.local/share/goose/sessions/sessions.db" ".backup '$HOME/audit/goose-after.db'"

printf '\n\n Changes to database\n\n'
sqlite3 ~/audit/goose-before.db   ".dump" > ~/audit/before.sql
sqlite3 ~/audit/goose-after.db ".dump" > ~/audit/after.sql
diff ~/audit/before.sql ~/audit/after.sql