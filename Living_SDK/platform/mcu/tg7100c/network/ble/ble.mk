NAME := ble

$(NAME)_COMPONENTS += platform/mcu/tg7100c/network/ble/blestack
$(NAME)_COMPONENTS += platform/mcu/tg7100c/network/ble/blecontroller
$(NAME)_COMPONENTS += platform/mcu/tg7100c/network/ble/breeze_adapter

CONFIG_BT_STACK_CLI:=1

##################################################################################
##################################################################################

$(NAME)_SOURCES := ./version.c

GLOBAL_CFLAGS   += -DBFLB_BLE
GLOBAL_CFLAGS   += -DCFG_BLE
GLOBAL_CFLAGS   += -DCFG_SLEEP

GLOBAL_CFLAGS   += -DCFG_FREERTOS
GLOBAL_CFLAGS   += -DARCH_RISCV

CONFIG_BT_CONN 	?=1
GLOBAL_CFLAGS += -DCFG_CON=$(CONFIG_BT_CONN)
#CONFIG_BLE_TX_BUFF_DATA ?=$(CONFIG_BT_CONN)
CONFIG_BLE_TX_BUFF_DATA ?=2
GLOBAL_CFLAGS += -DCFG_BLE_TX_BUFF_DATA=$(CONFIG_BLE_TX_BUFF_DATA)
CONFIG_BT_ALLROLES ?=0
CONFIG_BT_CENTRAL ?=0
CONFIG_BT_OBSERVER ?=1
CONFIG_BT_PERIPHERAL ?=1
CONFIG_BT_BROADCASTER ?=0
CONFIG_BT_SETTINGS ?=0
CONFIG_BT_WIFIPROV_SERVER ?=0
CONFIG_BLE_TP_SERVER ?=0
CONFIG_BLE_STACK_DBG_PRINT ?=1
CONFIG_BT_STACK_PTS ?=0
#If BLE host generate random value by software
CONFIG_BT_GEN_RANDOM_BY_SW ?=0
CONFIG_CHIP_NAME := TG7100C
CONFIG_DISABLE_BT_CONTRLLER_PRIVACY ?= 1

ifeq ($(CONFIG_BT_MESH),1)
CONFIG_BT_MESH_PB_ADV ?=1
CONFIG_BT_MESH_PB_GATT ?=1
CONFIG_BT_MESH_FRIEND ?=1
CONFIG_BT_MESH_LOW_POWER ?=1
CONFIG_BT_MESH_PROXY ?=1
CONFIG_BT_MESH_GATT_PROXY ?=1
CONFIG_BT_MESH_MODEL_GEN_SRV ?=1
endif

CONFIG_DISABLE_BT_SMP ?= 1
CONFIG_DISABLE_BT_HOST_PRIVACY ?= 1

$(info "running ble common.mk $(CONFIG_CHIP_NAME)")
ifeq ($(CONFIG_CHIP_NAME),TG7100C)
GLOBAL_CFLAGS   += -DTG7100C_BLE_CONTROLLER
GLOBAL_CFLAGS   += -DCONFIG_SET_TX_PWR
GLOBAL_CFLAGS   += -DHOST_TG7100C
endif


ifeq ($(CONFIG_CHIP_NAME),BL702)
GLOBAL_CFLAGS   += -DBL702
GLOBAL_CFLAGS   += -DHOST_BL702
endif

ifeq ($(CONFIG_DBG_RUN_ON_FPGA), 1)
$(NAME)_CFLAGS   += -DCFG_DBG_RUN_ON_FPGA
endif

##########################################
############## BLE STACK #################
##########################################
CONFIG_BT_ALLROLES ?=1
ifeq ($(CONFIG_BT_ALLROLES),1)
GLOBAL_CFLAGS   += -DCONFIG_BT_ALLROLES
GLOBAL_CFLAGS   += -DCONFIG_BT_CENTRAL
GLOBAL_CFLAGS   += -DCONFIG_BT_OBSERVER
GLOBAL_CFLAGS   += -DCONFIG_BT_PERIPHERAL
GLOBAL_CFLAGS   += -DCONFIG_BT_BROADCASTER
else
ifeq ($(CONFIG_BT_CENTRAL),1)
GLOBAL_CFLAGS   += -DCONFIG_BT_CENTRAL
endif
ifeq ($(CONFIG_BT_OBSERVER),1)
GLOBAL_CFLAGS  += -DCONFIG_BT_OBSERVER
endif
ifeq ($(CONFIG_BT_PERIPHERAL),1)
GLOBAL_CFLAGS   += -DCONFIG_BT_PERIPHERAL
endif
ifeq ($(CONFIG_BT_BROADCASTER),1)
GLOBAL_CFLAGS  += -DCONFIG_BT_BROADCASTER
endif

endif

ifneq ($(CONFIG_DBG_RUN_ON_FPGA), 1)
ifeq ($(CONFIG_BT_SETTINGS), 1)
GLOBAL_CFLAGS  += -DCONFIG_BT_SETTINGS
endif
endif

ifeq ($(CONFIG_BLE_MFG),1)
GLOBAL_CFLAGS   += -DCONFIG_BLE_MFG
ifeq ($(CONFIG_BLE_MFG_HCI_CMD),1)
GLOBAL_CFLAGS   += -DCONFIG_BLE_MFG_HCI_CMD
endif
endif

ifeq ($(CONFIG_BT_GEN_RANDOM_BY_SW),1)
GLOBAL_CFLAGS  += -DCONFIG_BT_GEN_RANDOM_BY_SW
endif

GLOBAL_CFLAGS   += -DCONFIG_BT_L2CAP_DYNAMIC_CHANNEL \
			-DCONFIG_BT_GATT_CLIENT \
			-DCONFIG_BT_CONN \
 			-DCONFIG_BT_GATT_DIS_PNP \
 			-DCONFIG_BT_GATT_DIS_SERIAL_NUMBER \
 			-DCONFIG_BT_GATT_DIS_FW_REV \
 			-DCONFIG_BT_GATT_DIS_HW_REV \
 			-DCONFIG_BT_GATT_DIS_SW_REV \
 			-DCONFIG_BT_ECC \
 			-DCONFIG_BT_GATT_DYNAMIC_DB \
 			-DCONFIG_BT_GATT_SERVICE_CHANGED \
 			-DCONFIG_BT_KEYS_OVERWRITE_OLDEST \
 			-DCONFIG_BT_KEYS_SAVE_AGING_COUNTER_ON_PAIRING \
 			-DCONFIG_BT_BONDABLE \
 			-DCONFIG_BT_HCI_VS_EVT_USER \
 			-DCONFIG_BT_ASSERT 

ifneq ($(CONFIG_DISABLE_BT_SMP), 1)
GLOBAL_CFLAGS   += -DCONFIG_BT_SMP \
 			-DCONFIG_BT_SIGNING
endif

ifneq ($(CONFIG_DBG_RUN_ON_FPGA), 1)
GLOBAL_CFLAGS  += -DCONFIG_BT_SETTINGS_CCC_LAZY_LOADING \
 			-DCONFIG_BT_SETTINGS_USE_PRINTK
endif

ifeq ($(CONFIG_BLE_STACK_DBG_PRINT),1)
GLOBAL_CFLAGS  += -DCFG_BLE_STACK_DBG_PRINT
endif
ifeq ($(CONFIG_BT_OAD_SERVER),1)
GLOBAL_CFLAGS   += -DCONFIG_BT_OAD_SERVER
endif
ifeq ($(CONFIG_BT_OAD_CLIENT),1)
GLOBAL_CFLAGS   += -DCONFIG_BT_OAD_CLIENT
endif
ifeq ($(CONFIG_BT_REMOTE_CONTROL),1)
GLOBAL_CFLAGS   += -DCONFIG_BT_REMOTE_CONTROL
endif

ifneq ($(CONFIG_DISABLE_BT_HOST_PRIVACY), 1)
GLOBAL_CFLAGS  += -DCONFIG_BT_PRIVACY
endif

#ifneq ($(CONFIG_BT_REMOTE_CONTROL),1)
#ifneq ($(CONFIG_BT_MESH),1)
#CFLAGS += -DCONFIG_BT_PRIVACY
#endif
#endif

ifeq ($(CONFIG_BLE_TP_SERVER),1)
GLOBAL_CFLAGS   += -DCONFIG_BLE_TP_SERVER
endif

ifeq ($(CONFIG_BT_STACK_PTS),1)
GLOBAL_CFLAGS   += -DCONFIG_BT_STACK_PTS
endif
ifeq ($(PTS_TEST_CASE_INSUFFICIENT_KEY),1)
GLOBAL_CFLAGS   += -DPTS_TEST_CASE_INSUFFICIENT_KEY
endif
ifeq ($(PTS_GAP_SLAVER_CONFIG_INDICATE_CHARC),1)
GLOBAL_CFLAGS   += -DPTS_GAP_SLAVER_CONFIG_INDICATE_CHARC
endif

##########################################
############## BLE MESH ##################
##########################################

ifeq ($(CONFIG_BT_MESH),1)

GLOBAL_CFLAGS   += -DCONFIG_BT_MESH
GLOBAL_CFLAGS   += -DCONFIG_BT_MESH_PROV
#CFLAGS += -DCONFIG_BT_SETTINGS
ifeq ($(CONFIG_BT_MESH_PB_ADV),1)
GLOBAL_CFLAGS  += -DCONFIG_BT_MESH_PB_ADV
endif
ifeq ($(CONFIG_BT_MESH_PB_GATT),1)
GLOBAL_CFLAGS  += -DCONFIG_BT_MESH_PB_GATT
endif
ifeq ($(CONFIG_BT_MESH_FRIEND),1)
GLOBAL_CFLAGS   += -DCONFIG_BT_MESH_FRIEND
endif
ifeq ($(CONFIG_BT_MESH_LOW_POWER),1)
GLOBAL_CFLAGS   += -DCONFIG_BT_MESH_LOW_POWER
endif
ifeq ($(CONFIG_BT_MESH_PROXY),1)
GLOBAL_CFLAGS   += -DCONFIG_BT_MESH_PROXY
endif
ifeq ($(CONFIG_BT_MESH_GATT_PROXY),1)
GLOBAL_CFLAGS  += -DCONFIG_BT_MESH_GATT_PROXY
endif
ifeq ($(CONFIG_BLE_STACK_DBG_PRINT),1)
GLOBAL_CFLAGS   += -DCFG_BLE_STACK_DBG_PRINT
endif
ifeq ($(CONFIG_BT_MESH_MODEL_GEN_SRV),1)
GLOBAL_CFLAGS  += -DCONFIG_BT_MESH_MODEL_GEN_SRV
endif 

endif

#GLOBAL_INCLUDES += $(COMPONENT_ADD_INCLUDEDIRS)
