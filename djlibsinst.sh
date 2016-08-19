#!/bin/bash

### basic install script example ( to adapt ) :
# http://gis.stackexchange.com/questions/167687/how-to-enable-sfcgal-in-postgis#188649

# put everithingon stdout and in djlibsinst.log file
{
## Unsetting variables
unset CONFIRM		# confirmation variable - stores user answers during process interactions
unset VERSION		# version number transmiter - from 'vers[@]' to 'fileNms[@]'
unset CONFVER		# version confirmation in AcceptNewVersion() - suggested versions are predefined in 'vers[@]'
unset NEWVER		# version modification confirmation in AcceptNewVersion()
unset fileNAMEdatum	# temporary storage of PROJ.4-datumgrid filename while processing PROJ.4 package
unset projDIR		# extracted directory name from *.tar files
unset gotPACK		# wget command exit status catcher
unset instCONF		# installation confirmation in case package file or folder exists; set to "cancel" in case of download or extraction error
unset extdPACK		# extraction command exit status catcher
unset instFLAG		# package installation flags - correspond to arrays - if not set by command parameter this variable is autoset during the installation process
					# run the script to see usage help

## Setting variables
CURDIR=`pwd`		# current directory
sqliteRTREE='CFLAGS=-DSQLITE_ENABLE_RTREE=1'	# configuration for SQLite ./configure
	# https://docs.djangoproject.com/en/1.10/ref/contrib/gis/install/spatialite/#sqlite

## (Global) intermediate variables 
# fileNAME 		- a fileNms[@] element
# packageNAME 	- a nms[@] element
# VERSION		- a vers[@] element
# webSRC		- a srcs[@] element

## Arrays declarations
	# stored information : library name, package version, package filename, web source in form of url
# nms - Package and lib names // more about libray dependencies 
declare -a nms=("SQLite" "GEOS" "PROJ.4" "PROJ.4-datumgrid" "GDAL" "JSON-C" "libxml2" "FreeXL" "SpatiaLite" "PostGIS")

# vers - Package versions // Modify this array according to system or installation needs. Versions are applied in function applyVer()
declare -a vers=("3140100" "3.5.0" "4.9.2" "1.5" "2.1.1" "0.12.1-20160607" "2.9.4" "1.0.2" "4.3.0a" "2.2.2")
	# releases : august 2016

# fileNms - Package filenames // Might change during version evolution - modifiy as required
declare -a fileNms=("sqlite-autoconf-VVERSS.tar.gz" "geos-VVERSS.tar.bz2" "proj-VVERSS.tar.gz" "proj-datumgrid-VVERSS.tar.gz" "gdal-VVERSS.tar.gz" "json-c-VVERSS.tar.gz" "libxml2-VVERSS.tar.gz" "freexl-VVERSS.tar.gz" "libspatialite-VVERSS.tar.gz" "postgis-VVERSS.tar.gz")

# srcs - URL to package web resource
declare -a srcs=("https://www.sqlite.org/2016/" "http://download.osgeo.org/geos/" "http://download.osgeo.org/proj/" "http://download.osgeo.org/proj/" "http://download.osgeo.org/gdal/CURRENT/" "https://github.com/json-c/json-c/archive/" "ftp://xmlsoft.org/libxml2/" "http://www.gaia-gis.it/gaia-sins/" "http://www.gaia-gis.it/gaia-sins/" "http://download.osgeo.org/postgis/source/")

	# > bash arrays info and help
	#	http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_10_02.html
	#	http://mywiki.wooledge.org/BashGuide/Arrays


function ApplyVersion()
# The function applies version numbers to each package filename
# to update a version number change the corresponding string in 'vers[@]'
{
	i=0
	## loop through names and apply versions
	for name in "${fileNms[@]}"
	do
		newName=${name//VVERSS/${vers[i]}}		#http://www.thegeekstuff.com/2010/07/bash-string-manipulation
		#DEBUG echo "$newName"
		fileNms[i]="$newName"
		i=$((i+1))		
	done
}

function AcceptNewVersion()
# While installation process in motion package version can be modified before wget(ting) the package
# this function can be disabled in the main scope if all version numbers in vers[@] are set as wanted
{
	echo File ${fileNAME} is going to be downloaded
	if [ "$1" ]; then
		echo Find latest versions \@${1}
	fi
	read -p "Accept version <y/N> ? " CONFVER
	if [[ ! ${CONFVER} =~ [N] ]]; then
		echo "Ok, suggested version $VERSION confirmed !"
	else
		read -p "Enter version (needs to be available online) : " NEWVER
		newName=${fileNAME//$VERSION/$NEWVER}
		fileNAME=$newName	
		echo Version changed to $NEWVER
	fi
}

function Build()
{
	# function is called with parameter 'RTREE' required for SQLite
	echo "build parameter : " $1
	# for other packages the parameter is not set //a simple './configure' executes
	./configure $1
	make
	sudo make install
	sudo ldconfig
	# 'cd ..' in the caller scope
}

function GetPack()
{
	#DEBUG echo "Inside getpack"
	## if PROJ.4-datumgrid was already downloaded counter c is increased.
	#DEBUG echo filename datum -- ${fileNAMEdatum}
	# if [ -n "${fileNAMEdatum}" ] ; then	
	# 	c=$((c+1))
	# 	#DEBUG echo "Increasing c ?"
	# 	gotPACK=$?
	# 	return 0
	# fi
	#DEBUG echo "getpack before question"
	echo ""
	read -p "Ready to download, build & install '$packageNAME' ? <press Enter> " CONFIRM
	#DEBUG echo "getpack before confirmation"
	if [ -z ${CONFIRM} ] ; then
	# http://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash#13864829		
	# http://www.linuxquestions.org/questions/programming-9/bash-script-want-to-capture-return-key-and-assign-a-value-460746/#post2319310		
		#echo $VERSION $webSRC
		# > call function
		AcceptNewVersion "${webSRC}"
		#DEBUG echo "Processing $packageNAME..."
		wget "${webSRC}${fileNAME}"
		#DEBUG echo "we're downloading here"
		gotPACK=$?
	fi
}

function ExtractPack() {
	tar xf $1
	# storing command success/error
	extdPACK=$?
}

function InstallPack() {

	#DEBUG - verifiying filename echo "${fileNAME}"
	ExtractPack "${fileNAME}"

	## PROJ.4 requires PROJ.4-datumgrid for building
	if [ "${packageNAME}" = "PROJ.4" ] && [ ${extdPACK} -eq 0 ]
	then
		# d indexes the right package name
		d=$((c+1))
		# in this case it's right after PROJ.4 //fileNms[c+1]
		fileNAMEdatum="${fileNms[$d]}"
		echo "...adding '${nms[$d]}'... "
		# download also PROJ.4-datumgrid		
		wget "${webSRC}${fileNAMEdatum}"
		if [[ "$?" != 0 ]]; then
		# wget verification
			echo "${fileNAMEdatum} is not available. Impossible to properly build ${packageNAME} package."
			extdPACK=1
		else
			# folder name extraction
			# find it in the array  # remove file extension
			projpack="${fileNAME}"; projDIR=${projpack/.tar*/''}
			# and extract package in folder /nad/ inside proj.4		
			cd "${projDIR}/nad" 2>/dev/null
			ExtractPack "../../${fileNAMEdatum}"
			cd "../.."
			## PROJ.4-datumgrid extracted -> increasing counter c
			c=$d			
		fi
	fi

	## change dir - remove file extension (.tar and the rest of string which follows)
	cd ${fileNAME/.tar*/''} 2>/dev/null
#ERROR !	cd "${fileNAME}"	

	# Build if extraction Ok & changing directory OK
	if [ $extdPACK -eq 0 ] && [ $? -eq 0 ]; then
		# > call function with a parameter for SQLite
		echo $'\nExtraction ok ...ready to build'	
		if [ "${packageNAME}" = "SQLite" ]; then
			Build "${sqliteRTREE}"
		else
			Build
		fi
		cd ..
		echo "- $packageNAME processed -"		
	else	
		echo "Possible errors while extracting. $packageNAME not processed"
	fi
	echo ""
}


## - script main() -
##

#DEBUG echo ${fileNms[@]}
#DEBUG echo ${#nms[@]} ${#vers[@]} ${#fileNms[@]} ${#srcs[@]}
if [[ ! "${#nms[@]}|${#vers[@]}|${#fileNms[@]}|${#srcs[@]}" = "${#nms[@]}|${#nms[@]}|${#nms[@]}|${#nms[@]}" ]]
# If array contents don't correspond (this is only array length verification)
	# condition used : http://stackoverflow.com/questions/8812089/bash-test-mutual-equality-of-multiple-variables#8812218
then
	echo "Bad package configuration. Correct arrays nms[@], vers[@], fileNms[@], srcs[@]"
	echo "Exiting"
	exit
fi

## check parameter instFLAG
if [ "$1" ]; then
	instFLAG=$1
else 
	instFLAG="1111111111"		
fi
echo "Installation flag is ${instFLAG}"

## Initiation - applying version number to package filenames // eg. 'geos-VVERSS.tar.bz2' -> 'geos-3.5.0.tar.bz2'
# > call function
ApplyVersion

## Show package installation list
c=0
echo "The install comprise packages :"
for p in "${fileNms[@]}"
do
	# http://stackoverflow.com/questions/10551981/how-to-perform-a-for-loop-on-each-character-in-a-string-in-bash#10552175
	if [ ${instFLAG:$c:1} -eq 1 ]; then
		echo "$p"
	fi
	c=$((c+1))	
done
echo "Intallation of each particular package can be ommitted during install."
echo "'Hint': run the script with a parameter to specify which package to install. '010101010' would install every second package in the list."

#echo ${fileNms[@]}
echo ""
echo "This script verifies if an extracted folder with a package name already exits in current folder. It won't verify if packages and libraries exist on system."
echo "Before 'build/installing' packages read also https://github.com/zer0mode/divnotes/blob/master/python_django_set-custom.md#uninstall-guides"
echo ""
read -p "Continue installing in current folder '${CURDIR}' ? <y/N> " CONFIRM
if [[ ${CONFIRM} =~ [yY] ]]
then
	# loop through array
	# http://stackoverflow.com/questions/8880603/loop-through-array-of-strings-in-bash-script#8880633
	c=0	
	for p in "${nms[@]}"
	do
		fileNAME="${fileNms[c]}"
		#size=[ $c -le ${#instFLAG} ]
		#size=$?
		#echo $size
		if [ $c -lt ${#instFLAG} ] && [ ${instFLAG:$c:1} -eq 1 ]
		then
			packageNAME="${nms[c]}"
			VERSION="${vers[c]}"
			webSRC="${srcs[c]}"
#DEBUG
			# if [ $c -gt 1 ]; then
			# 	echo debug: checking projDIR...
			# 	d=$((c+1))				
			# 	projpack="${fileNms[$d]}"; projDIR=${projpack/.tar*/""}
			# 	echo $projDIR
			# fi

			fileEXISTS="${CURDIR}/${fileNAME}"
			#DEBUG echo ${fileEXISTS}
			# http://stackoverflow.com/questions/638975/how-do-i-tell-if-a-regular-file-does-not-exist-in-bash
			if [ -d ${fileEXISTS/.tar*/''} ]; then
			    read -p "Package $packageNAME already resides in current folder. Installation pertinent ? <press Enter> " instCONF
			else
				if [ -f ${fileEXISTS} ]; then
					# the file is present, set as received
					gotPACK=0					
				else
					# gotPACK status is set inside function call >
					GetPack
				fi
				#DEBUG echo $gotPACK				
				if [ ${gotPACK} -eq 0 ]; then
					echo "Tarball ${fileNAME} ready ...extracting"
				else
    				echo "Error downloading file. Jumping to next package"
    				#canceling package install
    				instCONF="cancel"
				fi			
			fi
			if [ -z ${instCONF} ]; then
				# > call function				
				InstallPack
			else
				echo "Skipping ${packageNAME}"
			fi
		else
			echo "${fileNAME} install flag not set ...checking next"
		fi
		# increase index
		c=$((c+1))		
	done
	echo ""
	echo "Check @'https://github.com/zer0mode/divnotes/blob/master/python_django_set-custom.md#setting-libraries-system-path' to setup the libraries' path."
	echo "- Process finished -"
else
	echo "Abandoned"
fi
echo $'Installation log saved in djangolibs-inst.log\n'
#DEBUG echo $CONFIRM $VERSION
## - end main() -
} | tee djlibsinst.log