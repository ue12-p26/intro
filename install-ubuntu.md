# Ubuntu Install

to reinstall a computer that can be lended to students

## 2025

used a ubuntu-24-lts (.3) install on a samsung USB-C 256G key

## 2026

- used ubuntu-26.04.1-desktop-amd64.iso
- on an old / small-ish USB key (and maybe that was a mistake...)

```bash
# on a mac

# double-check this first !!!
DISKNB=x

diskutil eraseDisk FAT32 UBUNTU MBRFormat /dev/disk${DISKNB}

dd if=/Users/tparment/Downloads/os-images/ubuntu-26.04.1-desktop-amd64.iso of=/dev/rdisk${DISKNB} bs=1m

diskutil eject /dev/disk${DISKNB}
```

```bash
# if needed to verify the download
shasum -a 256 ubuntu-26.04.1-desktop-amd64.iso
http https://releases.ubuntu.com/26.04.1/SHA256SUMS
```

### note on progress

- can type `Ctrl-T` in the terminal while `dd` is running to get a report on current progress (without interrupting of course)
- alteratively `gdd` (`brew install coreutils`) has a `status=progress` option

## how to install - our settings

- [ ] press **Escape**
- [ ] then choose **Boot Menu (F9)**  
- [ ] then in the list select **The USB Key** - probably the second entry ?
- [ ] at the bootloader: ***Try or Install Ubuntu***  
      **OR** you may want to pick the ***safe graphics*** entry instead
- [ ] Language English
- [ ] Keyboard French
- [ ] Connect to the internet (optionnel)
- [ ] Install Ubuntu
- [ ] Interactive installation
- [ ] Extended Selection
- [ ] Proprietary : none
- [ ] Erase disk and install
- [ ] no encryption
- [ ] Jean Mineur / password=jeanmineur
- [ ] Require my password to log in
- [ ] Time zone Paris
- [ ] Confirm install

more notes (when trying on a Dell laptop)

- on Dell the boot hotkeys are
  - F12 for boot loader
  - F2 for bios setup
- on the Dell, I went up to an installer message complaining about "**RST - Rapid Storage technology**" being enabled in the BIOS  
  this translates in BIOS terms into:  
  System Configuration -> SATA Operation -> pick 'AHCI' and not 'RAID enabled'
