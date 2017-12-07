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
    dockerize env LOGNAME="lital" run_test.sh "$@"
}
