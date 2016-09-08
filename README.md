# bash-utils
A collection of bash scripts that makes live as a developer easier

# Description

As a Ruby, Python & C developer I constantly have to develop new
software and maintain our old software as well. That means that
very often I have different versions of Ruby, Python, frameworks,
C libraries in a sandbox, etc.

RVM & Anaconda are great because they help maintaining versions
of the languages and frameworks that cannot be installed through
packet manager like `apt-get`.

RVM has been an inspiration for my scripts, it is very nice that you can
set a `.ruby-version` file in your directory and load an specific
ruby environment once you change into that directory, without
having to worry about paths, etc.

I very well aware of other projects like [smartcd](https://github.com/cxreg/smartcd),
and some of my script may seem obsolete in comparison. I don't care, I still want to
share mine and if someone finds them usefull and wants to use them and/or
improve them, then be my guest.

----

# Autoloading scripts

I hate having long `.bashrc` files, so I put my "extensions" inside `~/.bash_load` directory.
Then I only have to add this code in my `.bashrc`

```shell
BASH_LOAD_DIR=${HOME}/.bash_load

if test -d ${BASH_LOAD_DIR} ; then
	for i in ${BASH_LOAD_DIR}/*.sh ; do
		test -r "${i}" && source "${i}"
	done
fi
```

The files inside `~/.bash_load` are named with a numerical prefix. By
doing this I have some controll over the order in which file get to be
sourced.
