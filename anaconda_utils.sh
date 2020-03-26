#!/bin/bash
# collection of goodies for anaconda

function __print_load_anaconda_help__()
{
	cat << EOF >&2
usage: anaconda_load conda-inst [environment]

By default the collection of anaconda installations is
${1}. If you want a different directory for the collection,
set CONDA_COLLECTION_DIR to that directory.

conda-inst:

the directory where a anaconda is installed.

environment:

if you have multiple environments in the selected anaconda
installation, you can choose an environment. If nothing
is selected, the "root" environment is selected.
EOF
}

# helps to quicky load anaconda environments.
# The default directory where your anaconda
# installation are present is ~/anaconda
# use CONDA_COLLECTION_DIR
function load_anaconda()
{
	local conda_dir="${CONDA_COLLECTION_DIR:-${HOME}/anaconda}"

	if test "${1}" == "" ; then
		__print_load_anaconda_help__
		return 1
	fi

	local conda_install="${conda_dir}/${1}"

	if test ! -x "${conda_install}/bin/conda" ; then
		echo "'${1}' is not a anaconda installation in ${conda_dir}" >&2
		__print_load_anaconda_help__
		return 1
	fi

	local conda_env="${2}"

	if test "${2}" != "" && test "${2}" != "root" ; then
		if test ! -d "${conda_install}/envs/${2}" ; then
			echo "'${2}' is not an environment in ${conda_install}" >&2
			return 1
		fi
	else
		conda_env="${conda_install}"
	fi

	source "${conda_install}/bin/activate" "${conda_env}"
	return $?
}


# a method that can be executed as a hook of cd
# reads a .anacondarc file and loads the anaconda
# environment
function __anaconda_cd_hook()
{
	local src="./.anacondarc"

	test -f "${src}" || return 0

	local lines="$(wc -l ${src})"

	local conda_path="$(sed -e 1p -n ${src})"
	local conda_env="$(sed -e 2p -n ${src})"

	test "${conda_env}" == "" && conda_env="${conda_path}"

	local conda_act="${conda_path}/bin/activate"

	test -x "${conda_act}" || return 1
	
	source "${conda_act}" ${conda_env}
}

alias sactivate='source activate'
alias sdeactivate='source deactivate'

function echo_err()
{
	echo "$@" >> /tmp/err.log
}

function _anaconda_envs()
{
	local curr
	COMPREPLY=()

	cur="${COMP_WORDS[COMP_CWORD]}"

	local path="$(conda env list 2>/dev/null | egrep "^root[[:space:]]+[^[:space:]]*" | sed -e 's/\*//g' | awk '{ print $2 }')"

	local conda_envs="${path}/envs"

	test -d "${conda_envs}" || return 0

	COMPREPLY+=(root)
	COMPREPLY+=( $(builtin cd "${conda_envs}" ; compgen -d -- ${cur}) )
}

function __get_anaconda_envs__()
{
	builtin pushd "${1}" >/dev/null 2>&1

	local conda_envs="$(/bin/ls */ -d 2>/dev/null | sed -e 's/\///')"

	builtin popd >/dev/null 2>&1


	test "${conda_envs}" == "" && return

	COMPREPLY=( $(compgen -W "${conda_envs}" -- ${2}) )
	
}

function _load_anaconda()
{
	local curr prev
	COMPREPLY=()

	local conda_dir="${CONDA_COLLECTION_DIR:-${HOME}/anaconda}"

	test -d "${conda_dir}" || return

	test ${COMP_CWORD} -gt 2 && return

	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"

	if test ${COMP_CWORD} -lt 2 ; then
		COMPREPLY=( $(builtin cd "${conda_dir}" ; compgen -d -- ${cur}) )
		return
	fi

	test -d "${conda_dir}/${prev}/envs" || return   # prev is not a anaconda installation

	__get_anaconda_envs__ "${conda_dir}/${prev}/envs" "${cur}"
}

complete -F _anaconda_envs sactivate
#complete -F _anaconda_envs sdeactivate

complete -F _load_anaconda load_anaconda
