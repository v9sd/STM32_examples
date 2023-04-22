/*
 * This code based on:
 * https://github.com/zephyrproject-rtos/zephyr/blob/main/drivers/disk/ramdisk.c
 */

#include <string.h>
#include <zephyr/types.h>
#include <zephyr/drivers/disk.h>
#include <errno.h>
#include <zephyr/init.h>
#include <zephyr/device.h>
#include <zephyr/logging/log.h>
#include <zephyr/kernel.h>
#include <zephyr/drivers/gpio.h>

#define DISK_TLED_NAME "TESTLED"

#define TLED_SECTOR_SIZE 512
#define TLED_VOLUME_SIZE (TLED_SECTOR_SIZE * 1)
#define TLED_SECTOR_COUNT (TLED_VOLUME_SIZE / TLED_SECTOR_SIZE)

static uint8_t ramdisk_buf[TLED_VOLUME_SIZE];

#define LED0_NODE DT_ALIAS(led0)

static void *lba_to_address(uint32_t lba)
{
	return &ramdisk_buf[lba * TLED_SECTOR_SIZE];
}

static int disk_TLED_access_status(struct disk_info *disk)
{
	return DISK_STATUS_OK;
}

static int disk_TLED_access_init(struct disk_info *disk)
{
	return 0;
}

static int disk_TLED_access_read(struct disk_info *disk, uint8_t *buff,
				uint32_t sector, uint32_t count)
{
	uint32_t last_sector = sector + count;

	if (last_sector < sector || last_sector > TLED_SECTOR_COUNT) {
		return -EIO;
	}

	memcpy(buff, lba_to_address(sector), count * TLED_SECTOR_SIZE);

	return 0;
}

static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(LED0_NODE, gpios);

static int disk_TLED_access_write(struct disk_info *disk, const uint8_t *buff,
				 uint32_t sector, uint32_t count)
{
	uint32_t last_sector = sector + count;

	if (last_sector < sector || last_sector > TLED_SECTOR_COUNT) {
		return -EIO;
	}

	void * write_address = lba_to_address(sector);
	if(buff != NULL && write_address == ramdisk_buf && count != 0)
	{
		gpio_pin_set_dt(&led, *buff&0x1);
	}

	memcpy(lba_to_address(sector), buff, count * TLED_SECTOR_SIZE);

	return 0;
}

static int disk_TLED_access_ioctl(struct disk_info *disk, uint8_t cmd, void *buff)
{
	switch (cmd) {
	case DISK_IOCTL_CTRL_SYNC:
		break;
	case DISK_IOCTL_GET_SECTOR_COUNT:
		*(uint32_t *)buff = TLED_SECTOR_COUNT;
		break;
	case DISK_IOCTL_GET_SECTOR_SIZE:
		*(uint32_t *)buff = TLED_SECTOR_SIZE;
		break;
	case DISK_IOCTL_GET_ERASE_BLOCK_SZ:
		*(uint32_t *)buff  = 1U;
		break;
	default:
		return -EINVAL;
	}

	return 0;
}

static const struct disk_operations ram_disk_ops = {
	.init = disk_TLED_access_init,
	.status = disk_TLED_access_status,
	.read = disk_TLED_access_read,
	.write = disk_TLED_access_write,
	.ioctl = disk_TLED_access_ioctl,
};

static struct disk_info TLED_disk = {
	.name = DISK_TLED_NAME,
	.ops = &ram_disk_ops,
};

static int disk_ram_init(const struct device *dev)
{
	ARG_UNUSED(dev);

	int ret = 0;

	if (!gpio_is_ready_dt(&led)) {
		return -EINVAL;
	}

	ret = gpio_pin_configure_dt(&led, GPIO_OUTPUT_ACTIVE);
	if (ret < 0) {
		return ret;
	}

	gpio_pin_set_dt(&led, 0);

	return disk_access_register(&TLED_disk);
}

SYS_INIT(disk_ram_init, APPLICATION, CONFIG_KERNEL_INIT_PRIORITY_DEFAULT);
