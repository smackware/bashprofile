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
    . ~/workspace/.env
    let testNum=$1
    if [ -n "$testNum" ] && [ "$testNum" != "0" ]; then
        shift
        echo "Looking for test: $testNum"
        testFilePath=$(find $WORKSPACE_TOP/systests/ -type f -name "$testNum_*.py" | head -1)
        echo "Found test: $testFilePath"
        dockerize env LOGNAME="lital" run_test.sh "$testFilePath" "$@"
        exit $?
    fi
    dockerize env LOGNAME="lital" run_test.sh "$@"
}
