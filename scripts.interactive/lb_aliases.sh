prep_rootfs()
{
    pushd $WORKSPACE_TOP/rootfs
    dockerize make rootfs_"$1"
    dockerize make checkin_rootfs_"$1"
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
    pushd $HOME/workspace
    . .env
    testNum=$(printf "%02d" $1)
    echo $testNum
    if [ -n "$testNum" ] && [ "$testNum" != "00" ]; then
        shift
        echo "Looking for test: $testNum"
        testFilePath=$(find $WORKSPACE_TOP/systests/ -type f -name "${testNum}_*.py" | head -1)
        echo "Found test: $testFilePath"
        dockerize env LOGNAME="lital" run_test.sh "$testFilePath" "$@"
        return $?
    fi
    dockerize env LOGNAME="lital" run_test.sh "$@"
    popd
}

get_lab_box()
{
    dockerize testos_cli -u tcp://labgw:22222 -t virtual
}
