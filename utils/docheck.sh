#!/bin/bash
set -o errexit
set -o pipefail

thisdir=`pwd`
singlestrain=$1



if [ $singlestrain != "all" ]; then
    strains=( $singlestrain )
else
    strains=( s288c sk1 cbs n44 )
fi

platforms=( ont pacbio miseq )

#pass2D, all2D
ont_s288c=( e224e33eb558d0df946f2ef8ad72a9f8 eef848b246c4c60f1365a7ca420fe3a3 )
ont_sk1=( )
ont_cbs=( )
ont_n44=( )
#whole, 31X_ont_emu
pacbio_s288c=( f09a852839b5f34d281fe9c39895ca85 6eb72fff9cc036b963a625543a05a9c3 )
pacbio_sk1=( )
pacbio_cbs=( )
pacbio_n44=( )
#reads_1, reads_2
miseq_s288c=( 9db73b9fdecb965af3750ac0faa72dcc 600b5a0e0c0a63454ab83af3c939380c )
miseq_sk1=( )
miseq_cbs=( )
miseq_n44=( )

#file name details:
ontn=( pass2D all2D )
pacbion=( pacbio pacbio_ontemu_31X )

#### check fastqs ####
echo
for platform in "${platforms[@]}"; do  

    echo  " " Checking fastq files for $platform ...
    folder=fastqs/$platform
    if [ $platform != "miseq" ]; then name=${platform}n[0]; fi

    for strain in "${strains[@]}"; do   

	file=$folder/$strain/$strain\_"${!name}".fastq
	if [ $platform == "miseq" ]; then 
	    file=$folder/$strain\_1.fastq; 
	    file2=$folder/$strain\_2.fastq; 
	fi
	
	if [ -f $file ]; then 
	    checksum=$platform\_${strain}
	    thischecksum=`md5sum $file | awk '{print $1}'`
	    
	    if [ "${!checksum}" = "$thischecksum" ]; then 	echo "  " $thistrain $file  OK;
	    else echo "  Warning !!! " $thistrain $file  not OK !!!;  fi
	else
	    echo "    Cannot find fastq file for" $strain: $file ;
	    echo "      Run:  \"$ ./launchme.sh"  $strain\" to download the data 
	fi

	if [ $platform == "miseq" ]; then 
	    
	    if [ -f $file ]; then 
		checksum=$platform\_${strain}[1]
		thischecksum=`md5sum $file2 | awk '{print $1}'`
		
		if [ "${!checksum}" = "$thischecksum" ]; then 	echo "  " $thistrain $file2  OK;
		else echo "  Warning !!! " $thistrain $file2  not OK !!!;  fi
	    else
		echo "    Cannot find fastq file for" $strain\: $file2 ;
		echo "      Run:  \"$ ./launchme.sh"  $strain\" to download the data 
	    fi
	fi
	
	if [ $strain == "s288c" ] && [ $platform != "miseq" ]; then
	    name=${platform}n[1]
	    file=$folder/$strain/$strain\_"${!name}".fastq
	   
	    if [ -f $file ]; then 
		checksum=$platform\_${strain}[1]
		thischecksum=`md5sum $file | awk '{print $1}'`
		
		if [ "${!checksum}" = "$thischecksum" ]; then 	echo "  " $thistrain $file  OK;
		else echo "  Warning !!! " $thistrain $file  not OK !!!;  fi
	    else
		echo "    Cannot find fastq file for" $strain\: $file ;
		echo "      Run:  \"$ ./launchme.sh"  $strain\" to download the data 
	    fi
	fi
    done
done