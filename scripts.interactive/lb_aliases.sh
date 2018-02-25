alias d=dockerize

alias ssht="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

prep_rootfs()
{
    pushd $WORKSPACE_TOP/rootfs
    for rootfs_type in "$@"; do
        dockerize make rootfs_"$rootfs_type"
        dockerize make checkin_rootfs_"$rootfs_type"
    done
    popd
}


clean_local_osmosis_cache()
{
    sudo rm -rf /var/lib/osmosis
}

remove_label_from_osmosis()
{
     dockerize osmosis eraselabel --objectStores=osmosis:1010 "$@"
}

list_osmosis_labels()
{
     dockerize osmosis listlabels --objectStores=osmosis:1010
}


run_test()
{
    cd $HOME/workspace
    . .env
    testNum=$(printf "%02d" $1)
    echo $LNAME
    echo "==============================================================="
    echo $testNum
    if [ -n "$testNum" ] && [ "$testNum" != "00" ]; then
        shift
        echo "Looking for test: $testNum"
        testFilePath=$(find $WORKSPACE_TOP/systests/ -type f -name "${testNum}_*.py" | head -1)
        LNAME="$USER-$(basename $testFilePath)-$$"
        echo "Found test: $testFilePath"
        dockerize env LOGNAME="$LNAME" run_test.sh "$testFilePath" "$@"
        return $?
    fi
    LNAME="$USER-$(basename $1)-$$"
    dockerize env LOGNAME="$LNAME" run_test.sh "$@"
}

get_lab_box()
{
    dockerize testos_cli -u tcp://labgw:22222 -t virtual -r $1
}
