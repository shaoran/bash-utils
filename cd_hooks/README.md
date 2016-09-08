# CD Hooks

I got this idea from [RVM](https://rvm.io/). Specially when you
have different projects that use different version of a language
(like ruby or python), having hooks inside `cd` that automatically
load the correct environment is a huge time saver.

If you are looking for something more sophisticated, take a look
at [smartcd](https://github.com/cxreg/smartcd).


# Usage

```shell
function do_something_hook()
{
	# you are now in the new directory
	# put your code here
	#
	# if for some reason you need to
	# change the directory, use
	#  builtin cd
	# so that you bypass the hooks,
	# otherwise you might enter into
	# an endless loop
}



source cd_hooks.sh

add_cd_hook do_something_hook
```
