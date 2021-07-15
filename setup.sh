#!/bin/bash

mkdir /var/log/users_history
mkdir /var/log/sudo_history
chmod 777 /var/log/sudo_history
chmod +t /var/log/sudo_history

cat << _EOF_ > /etc/profile.d/users_history.sh
_fick=$(who am i|awk '{print $1}')
_dis=$(id -u $_fick)
#if ["$_dis" > 0]
if (( $_dis > 0 ))
then
	export HISTSIZE=10000
	export HISTTIMEFORMAT='%F %T'
	export HISTFILE=/var/log/users_history/history-users-$(who am I | awk '{print $1}';exit)-$(date +%F)
	export PROMPT_COMMAND='history -a'
fi
_EOF_

cat << __EOF__ >> /root/.bashrc
export HISTSIZE=10000
export HISTTIMEFORMAT='%F %T'
export HISTFILE=/var/log/sudo_history/history-sudo-$(who am I | awk '{print $1}';exit)-$(date +%F)
export PROMPT_COMMAND='history -a'
__EOF__
