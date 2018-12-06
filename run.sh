#!/usr/bin/sh

function clone()
{
    local repository=$1
    local username=$2
    local password=$3
    
    echo "Start getting ${repository}"
    
    expect <<EOF
    set timeout 30
    spawn git clone --bare ${repository}
    expect {
       "Username for *" {
           send "${username}\n"
           expect "Password for *"
           send "${password}\n"
        }
       "Password for *" { send "${password}\n" }
    }
    expect eof
EOF
}

function push()
{
    local repository=$1
    local username=$2
    local password=$3
    
    echo "Start sending git information to ${repository}"
    
    expect <<EOF
    set timeout 300
    spawn git push --mirror ${repository}
    expect {
       "Username for *" {
           send "${username}\n"
           expect "Password for *"
           send "${password}\n"
        }
       "Password for *" { send "${password}\n" }
    }
    expect eof
EOF
    echo "${repository} done."
}

function sync()
{
    local formRepository=https://github.com/old.git
    local toRepository=https://github.com/new.git
    
    echo "Start synchronizing ..."
    mkdir /tmp/app
    cd /tmp/app
    
    clone ${formRepository} username password
    local gitPath=$(echo ${formRepository} | grep -E '\w*\.git$' -o)
    if [[ -d $gitPath ]];then
        cd $gitPath
        
        # Send to remote git
        push ${toRepository} username password
        
        # Clear
        rm -rf /tmp/app/${gitPath}
    else
        echo "Synchronization failure: Cloning didn't work."
    fi
    
    echo "fulfilled synchronously."
}

while true
do
    sync
    sleep 10
done
