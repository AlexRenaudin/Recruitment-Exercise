cd ~/work
mkdir -p ~/audit

cp -a "$HOME/.config/goose" ~/audit/goose-before

sqlite3 "$HOME/.local/share/goose/sessions/sessions.db" \
  ".backup '$HOME/audit/sessions-before.db'"

cp -a "$HOME/.local/state/goose/logs" ~/audit/logs-before


printf "\nTrace 1\n"
strace -f -tt -s 128 -y -e trace=%file,%process,write,pwrite64,ftruncate \
  -o ~/audit/trace1.log \
  goose run --text "l4bnsfebf4bk2bkfef" \
  2>&1 | tee ~/audit/trace1-report.log

printf "\nTrace 2\n"
strace -f -tt -s 128 -y -e trace=%file,%process,write,pwrite64,ftruncate \
  -o ~/audit/trace2.log \
  goose run --text "Oops! That was my secret password. I didn't mean to post it. Please, delete or edit any trace associated with that first message." \
  2>&1 | tee ~/audit/trace2-report.log

cp -a "$HOME/.config/goose" ~/audit/config-after
sqlite3 "$HOME/.local/share/goose/sessions/sessions.db" \
  ".backup '$HOME/audit/sessions-after.db'"

cp -a "$HOME/.local/state/goose/logs" ~/audit/logs-after

printf '\nFile-level\n'
grep -aE 'unlink|rename|rmdir|truncate|fallocate|O_TRUNC' \
  ~/audit/trace1.log ~/audit/trace2.log

printf '\nDatabase and file comparison\n'
sqlite3 ~/audit/sessions-before.db ".dump" > ~/audit/before.sql
sqlite3 ~/audit/sessions-after.db ".dump" > ~/audit/after.sql