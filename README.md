# ias-python3-script-infra

## DEPRECATED

This library will not receive any more updates.
It has been forked to:

* [ias_python3_script_infra2](https://github.com/theias/ias_python3_script_infra2)

During the course of improving things, the primary interface to creating an
IAS.Infra object was changed away from requiring a single value, which corresponded
to the location from which all relative paths from the "binary" were calculated.
I'm now using ```sys.argv[0]``` for that, and that doesn't need to be passed in
to the constructor.

This was necessary because I should have made the first and only parameter
optional, and I should have made it a dictionary.

## The Actual Docs

A framework has been developed so that programs (such as those written in Bash, Perl, and Python) use a (somewhat) standardized:

* source repository layout
* logging infrastructure
* file system layout when installed

The laouts mentioned above refer to:

* input directory
* output directory
* log directory (currently they log to syslog, I need to add the option of logging to files)
* configuration directory ('etc')

so that they behave nicely with each other.

This needs to be documented more.

# License

copyright (C) 2017 Martin VanWinkle, Institute for Advanced Study

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

See 

* http://www.gnu.org/licenses/

## Description

* bin/app.py - currently the python example.

# Supplemental Documentation

Supplemental documentation for this project can be found here:

* [Supplemental Documentation](./doc/index.md)

# Usage

## Install Project Template Generator
You will want to install the code that creates project directories in the correct layout.

On all systems you need to install the fakeroot package.

On deb systems you need to install build-essential.

On rpm systems you need to install rpmbuild.

<pre>
# Install the project template generator:
git clone https://github.com/theias/ias_package_shell
cd ias_package_shell
# If you're on a debian based system:
fakeroot make clean install debsetup debbuild
# If you're on an rpm based system:
fakeroot make clean install rpmspec rpmbuild
</pre>

Install the package that was generated.

## Install Python Library (this project)

<pre>
# Install the project template generator:
git clone https://github.com/theias/ias_python3_script_infra
cd ias_package_shell
# If you're on a debian based system:
fakeroot make clean install debsetup debbuild
# If you're on an rpm based system:
fakeroot make clean install rpmspec rpmbuild
</pre>

Install the package that was generated.  (notice the pattern? :) )

## cd Somewhere and Experiment

<pre>
cd /var/tmp
/opt/IAS/bin/ias-package-shell/package_shell.pl
# Answer the questions.

# Add the sample app to your project template
cp /opt/IAS/bin/ias-python3-script-infra/app.py (name of resultant directory)/src/bin
</pre>

... and have fun! (I hope!)


