# Copyright 2022 Xilinx Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ROOT_DIR=$(realpath $(dir $(lastword $(MAKEFILE_LIST))))
ABS_BUILD_PATH=$(ROOT_DIR)/build
PETALINUX_PROJ_NAME=petalinux
ABS_SW_PATH=$(ABS_BUILD_PATH)/$(PETALINUX_PROJ_NAME)
PETALINUX_DIR=$(ABS_SW_PATH)
PETALINUX_CONFIG=$(PETALINUX_DIR)/project-spec/configs/config
PETALINUX_ROOTFS_CONFIG=$(PETALINUX_DIR)/project-spec/configs/rootfs_config
XSA_PATH 	?=${PLATFORM_REPO_PATHS}/xilinx_zcu104_base_202220_1/hw/
XSA_NAME	?=hw
IMAGE_DIR=$(ABS_BUILD_PATH)/$(PETALINUX_PROJ_NAME)/images/linux/
.PHONY: help

help:
	@echo "Makefile usage"
	@echo "make all XSA_PATH=<path/to/base_platform/>  	## to generate Linux Image and SDK tool by using Petalinux with pre-exported XSA file or base paltform "
	

all: check-xsa petalinux_proj petalinux_build 
sd_card:check-xsa petalinux_proj petalinux_build sdimg

check-xsa:
ifeq ($(wildcard $(XSA_PATH)/$(XSA_NAME).xsa),)
	@echo "'XSA_PATH' is not accesible, please either download base platform  from Xilinx official website and set this flag to sepcify the PLATFORM_PATH which contains xsa file, or provide yourself  xsa file path"
	@make help
	@echo "exit ....." && exit 1
endif
	mkdir hw -p && cp $(XSA_PATH)/$(XSA_NAME).xsa hw/
#Extensible xsa dose not include the bit file. using  extnesible XSA to build the linux image would cause hung in boot stage.  So transfer the extensible XSA to a fixed XSA for building the Linux image and test it.
	cd hw; vivado -mode batch -notrace -source ../convert_to_fixed_xsa.tcl


update_dtsi:
	@cp -f system-user.dtsi $(PETALINUX_DIR)/project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi

update_config:
	# PetaLinux Config: Use EXT4 as rootfs format
	echo "CONFIG_SUBSYSTEM_ROOTFS_EXT4=y" >> $(PETALINUX_CONFIG)
	@echo "set Machine name according to board "
	# PetaLinux Config: Use ZCU104 device tree  
	echo 'CONFIG_SUBSYSTEM_MACHINE_NAME="zcu104-revc"' >> $(PETALINUX_CONFIG)
	echo 'CONFIG_YOCTO_MACHINE_NAME="zcu104-zynqmp"' >> $(PETALINUX_CONFIG)
	# For GCC < 6.0, enable prebuilt build tools
	echo "CONFIG_YOCTO_BUILDTOOLS_EXTENDED=y" >> $(PETALINUX_CONFIG)

update_rootfs_config:
	# PetaLinux Rootfs: Enable XRT
	echo 'CONFIG_xrt=y' >> $(PETALINUX_ROOTFS_CONFIG)
	# echo 'CONFIG_xrt-dev=y' >> $(PETALINUX_ROOTFS_CONFIG)
	# PetaLinux Rootfs: Enable DNF
	echo 'CONFIG_dnf=y' >> $(PETALINUX_ROOTFS_CONFIG)
	echo 'CONFIG_imagefeature-package-management=y' >> $(PETALINUX_ROOTFS_CONFIG)
	# PetaLinux Rootfs: Enable packages for EoU
	echo 'CONFIG_e2fsprogs-resize2fs=y' >> $(PETALINUX_ROOTFS_CONFIG)
	echo 'CONFIG_parted=y' >> $(PETALINUX_ROOTFS_CONFIG)
	echo 'CONFIG_resize-part=y' >> $(PETALINUX_ROOTFS_CONFIG)
	# PetaLinux Rootfs: Enable Vitis AI demo dependencies
	echo 'CONFIG_packagegroup-petalinux-opencv=y' >> $(PETALINUX_ROOTFS_CONFIG)
	echo 'CONFIG_mesa-megadriver=y' >> $(PETALINUX_ROOTFS_CONFIG)
	echo 'CONFIG_packagegroup-petalinux-x11=y' >> $(PETALINUX_ROOTFS_CONFIG)
	echo 'CONFIG_packagegroup-petalinux-v4lutils=y' >> $(PETALINUX_ROOTFS_CONFIG)
	echo 'CONFIG_packagegroup-petalinux-matchbox=y' >> $(PETALINUX_ROOTFS_CONFIG)



petalinux_proj:
	mkdir -p $(ABS_BUILD_PATH);cd $(ABS_BUILD_PATH); petalinux-create -t project --template zynqMP --force -n $(PETALINUX_PROJ_NAME)
	$(MAKE)  update_config
	petalinux-config -p $(PETALINUX_DIR) --get-hw-description=hw/xsa_file_for_petalinux.xsa --silentconfig
	$(MAKE)  update_rootfs_config
	$(MAKE)  update_dtsi
	petalinux-config -p $(PETALINUX_DIR) --silentconfig

petalinux_build:
	petalinux-build -p $(PETALINUX_DIR)
	cd $(PETALINUX_DIR) && petalinux-package --fpga --boot --u-boot
petalinux_build_sdk:
	petalinux-build -p $(PETALINUX_DIR) --sdk
	cd $(PETALINUX_DIR) && petalinux-package --sysroot
sdimg:
	mkdir -p sd_card 
	cp $(IMAGE_DIR)/BOOT.BIN sd_card/
	cp $(IMAGE_DIR)/boot.scr sd_card/
	cp $(IMAGE_DIR)/system.dtb sd_card/
	cp $(IMAGE_DIR)/Image sd_card/
	cp run_app.sh sd_card/
	$(XILINX_VITIS)/scripts/vitis/util/mkfsImage.sh -s sd_card -o sd_card.img -m 1 -e $(IMAGE_DIR)/rootfs.ext4
clean:
	$(RM) -rf $(ABS_BUILD_PATH) hw* sd* -rf *.log _x vivado* 

