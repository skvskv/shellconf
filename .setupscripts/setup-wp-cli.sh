#!/usr/bin/env bash

WP_DIST_URL='https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar'
WP_DIST_BCOMP_URL='https://raw.githubusercontent.com/wp-cli/wp-cli/v1.5.1/utils/wp-completion.bash'
WP_CLI_PATHNAME=$(command -v wp)
IS_WP_CLI_INSTALLED=$?

set -euo pipefail
IFS=$'\n\t'
#set -o errtrace   # trap errors in functions as well
#set -o posix      # more strict failures in subshells

function acquire_sudo_if_necessary()
{
	test 0 -eq $(id -u) || sudo -v
}
function install_wpcli_globally()
{
	WP_CLI_DIR='/opt/wordpress/wp-cli/'
	WP_CLI_PHAR_FILENAME='wp.phar'
	WP_CLI_FILEPATHNAME="${WP_CLI_DIR}${WP_CLI_PHAR_FILENAME}"
	WP_CLI_SYMLINK_FILEPATHNAME='/usr/local/bin/wp'
	if test \! -e ${WP_CLI_FILEPATHNAME}
	then
		sudo mkdir -p ${WP_CLI_DIR}
		sudo wget -c -t 0 -T 10 -O ${WP_CLI_FILEPATHNAME} ${WP_DIST_URL}
		sudo chown root:root ${WP_CLI_FILEPATHNAME}
		sudo chmod 0755 ${WP_CLI_FILEPATHNAME}
	else
		if test \! -f ${WP_CLI_FILEPATHNAME}
		then
			echo "Target file already exists but is not regular!? ('${WP_CLI_FILEPATHNAME}'). "
			exit 2;
		fi
	fi
	if test \! -f ${WP_CLI_SYMLINK_FILEPATHNAME}
	then
		sudo ln -s ${WP_CLI_FILEPATHNAME} ${WP_CLI_SYMLINK_FILEPATHNAME}
		sudo chmod a+x /usr/local/bin/wp
	else
		if test \! -L ${WP_CLI_SYMLINK_FILEPATHNAME}
		then
			echo "Target file already exists but is not symlink!? (${WP_CLI_SYMLINK_FILEPATHNAME})."
			exit 2;
		fi
	fi
}
function install_bashcomp_locally()
{
	USER_BASHCOMP_URL=${WP_DIST_BCOMP_URL}
	USER_BASHCOMP_DIR="${HOME}/bash_completion.d"
	USER_BASHCOMP_RCFILE="${HOME}/.bash_completion"
	USER_BASHCOMP_FILEPATHNAME="${USER_BASHCOMP_DIR}/wp-cli.bash"

	if test \! -e ${USER_BASHCOMP_DIR}
	then
		mkdir ${USER_BASHCOMP_DIR}
	else
		if test \! -d ${USER_BASHCOMP_DIR}
		then
			echo "The bash completion dir is not a dir!? (${USER_BASHCOMP_DIR})."
			exit 3;
		fi
	fi
	if test \! -e ${USER_BASHCOMP_FILEPATHNAME}
	then
		wget -c -t 0 -T 10 -O ${USER_BASHCOMP_FILEPATHNAME} ${USER_BASHCOMP_URL}
		chmod 0644 ${USER_BASHCOMP_FILEPATHNAME}
	else
		if test \! -f ${USER_BASHCOMP_FILEPATHNAME}
		then
			echo "The bash completion script file exists but is not regular!? (${USER_BASHCOMP_FILEPATHNAME})."
			exit 3;
		fi
	fi
	if test \! -e ${USER_BASHCOMP_RCFILE}
	then
		touch ${USER_BASHCOMP_RCFILE}
		chmod go-w ${USER_BASHCOMP_RCFILE}
		echo 'test -d ~/'$(basename ${USER_BASHCOMP_DIR})' && for fn in ~/'$(basename ${USER_BASHCOMP_DIR})'/*.bash; do . $fn; done' > ${USER_BASHCOMP_RCFILE}
	else
		if test \! -f ${USER_BASHCOMP_RCFILE}	
		then
			echo "The bash completion rc file exists but is not regular!? (${USER_BASHCOMP_RCFILE})."
			exit 3;
		fi
	fi
}

if test 1 -eq ${IS_WP_CLI_INSTALLED}
then
	echo -e "Now you're gona install (if necessary) WP CLI and configure its autocompletion."
else
	echo -e "You seem to already have WP CLI installed. \nNow you'e gonna update (if necessary) WP CLI autocompletion."
fi

read -n 1 -t 120 -p 'Proceed? [Y/n]' answer
echo ''

case ${answer:0:1} in 
	y|Y )
		echo 'Ok, performing the operation.'
		if test 1 -eq ${IS_WP_CLI_INSTALLED}
		then 
			acquire_sudo_if_necessary
			install_wpcli_globally
		fi
		install_bashcomp_locally
	;;
	* )
		echo 'Dismissed'
		exit 100
	;;
esac

