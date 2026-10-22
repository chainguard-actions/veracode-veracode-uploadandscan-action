#!/bin/sh -l

#required parameters
appname=$1
createprofile=$2
filepath=$3
version=$4
vid=$5
vkey=$6

#optional parameters
createsandbox=$7
sandboxname=$8
scantimeout=$9
exclude=${10}
include=${11}
criticality=${12}

pattern=${13}
replacement=${14}
sandboxid=${15}
scanallnonfataltoplevelmodules=${16}
selected=${17}
selectedpreviously=${18}
teams=${19}
toplevel=${20}
deleteincompletescan=${21}
scanpollinginterval=${22}
javawrapperversion=${23}
debug=${24}
includenewmodules=${25}
maxretrycount=${26}


echo "Required Information"
echo "===================="
echo "appname: $appname"
echo "createprofile: $createprofile"
echo "filepath: $filepath"
echo "version: $version"
if [ "$vid" ]
then
echo "vid: ***"
else
echo "vid:"
fi

if [ "$vkey" ]
then
echo "vkey: ***"
else
echo "vkey:"
fi
echo ""
echo "Optional Information"
echo "===================="
echo "createsandbox: $createsandbox"
echo "sandboxname: $sandboxname"
echo "scantimeout: $scantimeout"
echo "exclude: $exclude"
echo "include: $include"
echo "criticality: $criticality"
echo "pattern: $pattern"
echo "replacement: $replacement"
echo "sandboxid: $sandboxid"
echo "scanallnonfataltoplevelmodules: $scanallnonfataltoplevelmodules"
echo "selected: $selected"
echo "selectedpreviously: $selectedpreviously"
echo "teams: $teams"
echo "toplevel: $toplevel"
echo "deleteincompletescan: $deleteincompletescan"
echo "scanpollinginterval: $scanpollinginterval"
echo "javawrapperversion: $javawrapperversion"
echo "debug: $debug"
echo "includenewmodules: $includenewmodules"
echo "maxretrycount: $maxretrycount"


#Check if required parameters are set

if [ -z "$appname" ] || [ -z "$createprofile" ] || [ -z "$filepath" ] || [ -z "$version" ] || [ -z "$vid" ] || [ -z "$vkey" ]
then
        echo "Missing required parameter. Please check that all required parameters are set"
        exit 1
fi



#required wrapper arguments (built as a positional argument list; no generated script, no eval)
echo ""
set -- \
        -filepath "$filepath" \
        -version "$version" \
        -action "uploadandscan" \
        -appname "$appname" \
        -vid "$vid" \
        -vkey "$vkey"

#create additional arguments on optional input

if [ "$createsandbox" = true ]
then
    set -- "$@" -createsandbox=true
elif [ "$createsandbox" = false ]
then
    set -- "$@" -createsandbox=false
fi

if [ "$sandboxname" ]
then
        if [ "$sandboxid" ]
        then
                echo "ERRRO: sandboxname cannot go together with sandboxid"
                exit 1
        else
                set -- "$@" -sandboxname "$sandboxname"
        fi
fi

if [ "$scantimeout" ]
then
   set -- "$@" -scantimeout "$scantimeout"
fi

if [ "$exclude" ]
then
        if [ "$selectedpreviously" ] || [ "$toplevel" ] || [ "$selected" ] || [ "$selectedpreviously" ]
        then
                echo "ERROR: exclude cannot go together with selectedpreviously, toplevel, selected, selectedpreviously"
                exit 1
        else
                set -- "$@" -exclude "$exclude"
        fi
fi

if [ "$include" ]
then
        if [ "$selectedpreviously" ] || [ "$toplevel" ] || [ "$selected" ] || [ "$selectedpreviously" ]
        then
                echo "ERROR: include cannot go together with selectedpreviously, toplevel, selected, selectedpreviously"
                exit 1
        else
                set -- "$@" -include "$include"
        fi
fi

if [ -z "$include" ] && [ -z "$exclude" ]
then
    set -- "$@" -autoscan "true"
fi

if [ "$criticality" ]
then
    set -- "$@" -criticality "$criticality"
fi

if [ "$pattern" ]
then
        if [ "$replacement" ]
        then
                set -- "$@" -pattern "$pattern"
        else
                echo "ERROR: pattern always need the replacement parameter as well"
                exit 1
        fi
fi

if [ "$replacement" ]
then
       if [ "$pattern" ]
        then
                set -- "$@" -replacement "$replacement"
        else
                echo "ERROR: replacement always need the pattern parameter as well"
                exit 1
        fi
fi

if [ "$sandboxid" ]
then
        if [ "$sandboxname" ]
        then
                echo "ERROR: sandboxid cannot got together with sandboxname"
                exit 1
        else
                set -- "$@" -sandboxid "$sandboxid"
        fi
fi

if [ "$scanallnonfataltoplevelmodules" ]
then
    set -- "$@" -scanallnonfataltoplevelmodules "$scanallnonfataltoplevelmodules"
fi

if [ "$selected" ]
then
        if [ "$selectedpreviously" ] || [ "$toplevel" ] || [ "$scanallnonfataltoplevelmodules" ] || [ "$exclude" ] || [ "$include" ]
        then
                echo "ERROR: selected cannot go together with selectedpreviously, toplevel, scanallnonfataltoplevelmodules, exclude, include"
                exit 1
        else
                # upstream behavior preserved
                set -- "$@" -selectedpreviously "$selectedpreviously"
        fi
fi

if [ "$selectedpreviously" ]
then
        if [ "$selected" ] || [ "$toplevel" ] || [ "$scanallnonfataltoplevelmodules" ] || [ "$exclude" ] || [ "$include" ]
        then
                echo "ERROR: selectedpreviously cannot go together with selected, toplevel, scanallnonfataltoplevelmodules, exclude, include"
                exit 1
        else
                set -- "$@" -selectedpreviously "$selectedpreviously"
        fi
fi

if [ "$teams" ]
then
    set -- "$@" -teams "$teams"
fi

if [ "$toplevel" ]
then
        if [ "$selected" ] || [ "$selectedpreviously" ] || [ "$scanallnonfataltoplevelmodules" ] || [ "$exclude" ] || [ "$include" ]
        then
                echo "ERROR: toplevel cannot go together with selected, selectedpreviously, scanallnonfataltoplevelmodules, exclude, include"
                exit 1
        else
               set -- "$@" -toplevel "$toplevel"
        fi
fi

if [ "$deleteincompletescan" ]
then
    set -- "$@" -deleteincompletescan "$deleteincompletescan"
fi


if [ "$scanpollinginterval" ]
then
    set -- "$@" -scanpollinginterval "$scanpollinginterval"
fi


set -- "$@" -createprofile "$createprofile"

if [ -z "$javawrapperversion" ]
then #fetch latest wrapper version from Maven
    javawrapperversion=$(curl https://repo1.maven.org/maven2/com/veracode/vosp/api/wrappers/vosp-api-wrappers-java/maven-metadata.xml | grep latest |  cut -d '>' -f 2 | cut -d '<' -f 1)
fi

echo "javawrapperversion: $javawrapperversion"

if [ "$debug" ]
then
    set -- "$@" -debug "$debug"
fi

if [ "$includenewmodules" ]
then
    set -- "$@" -includenewmodules "$includenewmodules"
fi

if [ "$maxretrycount" ]
then
    set -- "$@" -maxretrycount "$maxretrycount"
fi

curl -sS -o VeracodeJavaAPI.jar "https://repo1.maven.org/maven2/com/veracode/vosp/api/wrappers/vosp-api-wrappers-java/$javawrapperversion/vosp-api-wrappers-java-$javawrapperversion.jar"
echo "Running: java -jar VeracodeJavaAPI.jar (arguments built from inputs; credentials masked)"
java -jar VeracodeJavaAPI.jar "$@"
