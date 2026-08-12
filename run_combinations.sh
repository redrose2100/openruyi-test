#!/usr/bin/bash

rm -rf /home/ubuntu/demo/mugen/combination_results
mkdir -p /home/ubuntu/demo/mugen/combination_results

#===run combination/embedded_osv_at.json tests===
echo "===run combination/embedded_osv_at.json tests==="
export DOWNLOAD_BRANCH=openEuler-24.03-LTS
export FIND_TINY_DIR=/home/openeuler/tmp_image/tiny
export OS_RELEASE_NAME=openeuler


echo "---run execute_1" 
bash /home/ubuntu/demo/mugen/qemu_ctl.sh stop
rm -rf /home/ubuntu/demo/mugen/conf

bash /home/ubuntu/demo/mugen/mugen.sh -c --ip "192.168.136.132" --password "openEuler@123" --port "22" --user "root" --run_remote --put_all
export SDK_PATH=/opt/sdk/raspberrypi4-64/

mv /home/ubuntu/demo/mugen/suite2cases /home/ubuntu/demo/mugen/tmp_suite2cases
mv /home/ubuntu/demo/mugen/tmp_0_embedded_osv_at_at_test_for_device_suite /home/ubuntu/demo/mugen/suite2cases
bash /home/ubuntu/demo/mugen/mugen.sh -a -b
bash /home/ubuntu/demo/mugen/mugen.sh -a -s
mkdir -p /home/ubuntu/demo/mugen/combination_results/tmp_0_embedded_osv_at_at_test_for_device_suite_1
cp -r /home/ubuntu/demo/mugen/results/* /home/ubuntu/demo/mugen/combination_results/tmp_0_embedded_osv_at_at_test_for_device_suite_1
bash /home/ubuntu/demo/mugen/libs/locallibs/combination_do_clean.sh
mv /home/ubuntu/demo/mugen/suite2cases /home/ubuntu/demo/mugen/tmp_0_embedded_osv_at_at_test_for_device_suite
mv /home/ubuntu/demo/mugen/tmp_suite2cases /home/ubuntu/demo/mugen/suite2cases

echo "---run execute end"

export DOWNLOAD_BRANCH=
export FIND_TINY_DIR=
export OS_RELEASE_NAME=


echo "===run combination/embedded_osv_at.json tests end==="
#===run combination/embedded_osv_at.json tests end===
