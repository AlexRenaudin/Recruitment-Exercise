cd ~/work
mkdir -p ~/audit

sqlite3 "$HOME/.local/share/opencode/opencode.db" ".backup '$HOME/audit/opencode-before.db'"

printf "\nTrace 1\n"
strace -f -tt -s 128 -y -e trace=%file,%process,write,pwrite64,ftruncate \
  -o ~/audit/trace1.log \
  opencode run --model opencode/deepseek-v4.1-flash-free --auto "ILovePrivacy" \
  2>&1 | tee ~/audit/trace1-report.log

printf "\nTrace 2\n"
strace -f -tt -s 128 -y -e trace=%file,%process,write,pwrite64,ftruncate \
  -o ~/audit/trace2.log \
  opencode run --model opencode/deepseek-v4.1-flash-free -c --auto "Oops! That was my secret password. I didn't mean to post it. Please, delete or edit any trace associated with that first message." \
  2>&1 | tee ~/audit/trace2-report.log

sqlite3 "$HOME/.local/share/opencode/opencode.db" ".backup '$HOME/audit/opencode-after.db'"

printf '\nFile-level\n'
grep -aE 'unlink|rename|rmdir|truncate|fallocate|O_TRUNC' ~/audit/trace1.log ~/audit/trace2.log

printf '\nDatabase\n'
sqlite3 ~/audit/opencode-before.db   ".dump" > ~/audit/before.sql
sqlite3 ~/audit/opencode-after.db ".dump" > ~/audit/after.sql
diff ~/audit/before.sql ~/audit/after.sql