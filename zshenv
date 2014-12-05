export PATH=/usr/local/sbin:/usr/local/bin:$PATH
export JAVA_TOOL_OPTIONS='-Dfile.encoding=UTF8'
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
if [ -f ~/.zshenv.local ]; then
  . ~/.zshenv.local
fi
