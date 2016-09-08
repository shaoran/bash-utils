#!/bin/bash
# author: Pablo Yanez Trujillo

# use add_cd_hook <hook> to add a hook to cd

if ! declare -F cd >/dev/null 2>&1 ; then
	function cd()
	{
		builtin cd "$@"
	}
fi

# at this point `cd' is a function, either defined by someone
# else like rvm or it is the function defined above.

__CD_HOOKS__=()

function add_cd_hook()
{
	local func args

	__CD_HOOKS__+=($1)
}

function __exec_cd_hook__()
{
	for i in "${__CD_HOOKS__[@]}" ; do
		${i}
	done
}


# if some else already overwrote 'cd' (like rvm)
# put that into a method and use that method instead
# of builtin cd
eval "$(echo "function __cd_hook_orig__()"; declare -f cd | tail -n +2)"

function cd()
{
	__cd_hook_orig__ "${@}"
	local result=$?

	if test ${result} -eq 0 ; then
		# execute hooks iff cd was successful.
		__exec_cd_hook__
	fi
	return $result
}
