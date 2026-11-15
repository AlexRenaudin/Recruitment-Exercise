cd ~
mkdir -p ~/audit

printf "\n\nTrace \n\n"
strace -f -tt -s 512 -y -e trace=%file,%process,write,pwrite64,ftruncate \
  -o ~/audit/trace1.log \
  opencode run --model opencode/deepseek-v4.1-flash-free --auto "Hello!" \
  2>&1 | tee ~/audit/trace1-report.log

sqlite3 "$HOME/.local/share/opencode/opencode.db" ".backup '$HOME/audit/opencode-before.db'"

strace -f -tt -s 512 -y -e trace=%file,%process,write,pwrite64,ftruncate \
  -o ~/audit/trace2.log \
  opencode run --model opencode/deepseek-v4.1-flash-free -c --auto "Open the file "~/Recruitment Exercise/Scenario 2/Instructions_opencode.txt" and follow the instructions." \
  2>&1 | tee ~/audit/trace2-report.log

sqlite3 "$HOME/.local/share/opencode/opencode.db" ".backup '$HOME/audit/opencode-after.db'"

printf '\n\n Changes to database\n\n'
sqlite3 ~/audit/opencode-before.db   ".dump" > ~/audit/before.sql
sqlite3 ~/audit/opencode-after.db ".dump" > ~/audit/after.sql
diff ~/audit/before.sql ~/audit/after.sql