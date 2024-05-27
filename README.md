# Functional Tests

Functional tests are found in [debian12/tests](debian12/tests)

The functional test do a series of zelta and zfs checks on two 
freshly created pools. The pools are re-created for each
test sequence.

Currently there is only one test sequence (see below)


## **Update the configuration before testing**
> [!IMPORTANT]  define env variables for your pool devices
> Update [debian12/tests/config.env](debian12/tests/config.env)

```sh
# update debian12/tests/config.env
# an nvme example, the ? would be replaced by a device number
export APOOL_DISK="nvme?n1"
export BPOOL_DISK="nvme?n1"
```

## Running the tests
You run the series of tests with the command 

### cd to [debian12/tests](debian12/tests)
```sh
cd debian12/tests
sudo ./run_all.sh
```

The script will exit with the number of tests that fail.
We seek an exit code of zero. If any errors are encountered
review the corresponding log file listed in the error message.
Logs are located here  [debian12/tests/logs](debian12/tests/logs)



# Other Zelta Test Configurations

For convenience, I’ve provided a vm-bhyve configuration including a blank pool file called “zelta” which you can pipe into “zfs receive” to get you started:

```cat zelta-test.zfs | zfs receive -v boot/vm/zelta.test```

(Where boot/vm is vm-bhyve’s VM configuration directory.) The  VM is configured to use the “zroot.img” file, which isn’t included (so I can practice with different OSes). To try with FreeBSD 14, you can do the following. If you use a VM name other than “zelta.test”, be sure to change the VM config file name.

```sh
fetch https://download.freebsd.org/releases/VM-IMAGES/14.0-RELEASE/amd64/Latest/FreeBSD-14.0-RELEASE-amd64-zfs.raw.xz -o - | unxz - > /boot/vm/zelta.test/zroot.img
vm start zelta.test
vm console zelta.test
```

Inside the VM:

```sh
zpool import zelta
````

Next, paste or download the zelta-tests script, edit the variables at the top and run zelta-tests.

Once complete, run zelta-test again to update the three backup targets. If you see zelta/Backups/myhost, zelta/BackupsReplicate, and zelta/BackupsDepth snapshots, the tests were probably successful.

Expected errors include git and ssh warnings, "nothing to replicate" after zpull, and a "zfs create" related error in the "check all features"zelta run. Check out the example*.out files to see what some successful tests look like.

Please report any other bugs to https://github.com/bellhyve/zelta
