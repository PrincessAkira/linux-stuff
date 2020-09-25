#!/bin/bash
PS3='Choose your Option: '
foods=("Auto-Install" "Optimise" "Other Opti stuff" "Quit")
select fav in "${foods[@]}"; do
	case $fav in
	"Auto-Install")
		echo "Starting"
		sudo pacman-key --recv-keys AEE1E900
		echo '[codelinsoft-eos-repository] 
            SigLevel = PackageRequired
            Server = https://repository.codelinsoft.it/eos-repository' >> /etc/pacman.conf
		pacman-key --recv-key EA50C866329648EE
		pacman-key --lsign-key EA50C866329648EE
		echo '[andontie-aur]
            Server = https://aur.andontie.net/$arch' >> /etc/pacman.conf
		pacman -Syy
		pacman -Syu
		pacman -S linux-zen linux-zen-headers nvidia-installer kwin-lowlatency yay codelinsoft-keyring eos-settings-manager neofetch cpupower git dg-desktop-portal ark unrar kdeconnect sshfs dolphin okular konsole kate noto-fonts noto-fonts-cjk ttf-dejavu ttf-liberation ttf-opensans freetype2-cleartype gwenview -y
		pacman -Rnsc discover oxygen plasma-vault -y
		sed -i -e 's/linux /vmlinuz-linux/linux /vmlinuz-linux-zen/' boot/loader/entries/arch.conf
		sed -i -e 's/initrd /initramfs-linux.img/initrd /initramfs-linux-zen.img/' boot/loader/entries/arch.conf
		ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
		ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
		ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
		echo 'export FREETYPE_PROPERTIES="truetype:interpreter-version=40"' >> /etc/profile.d/freetype2.sh
		yay -S otf-san-francisco-pro -y
		sudo nano /etc/udev/rules.d/60-ioschedulers.rules
		echo 'ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"' >> /etc/udev/rules.d/60-ioschedulers.rules
		sudo journalctl --vacuum-size=100M
		sudo journalctl --vacuum-time=2weeks
		sudo nano /etc/systemd/journald.conf.d/fw-tty12.conf
		echo '[Journal]
ForwardToConsole=yes
TTYPath=/dev/tty12
MaxLevelConsole=info' >> /etc/systemd/journald.conf.d/fw-tty12.conf
		sudo systemctl restart systemd-journald.service
		;;
	"Optimise")
		echo "Now optimizing"
		sudo cpupower frequency-set -g performance
		echo 32 >/sys/block/sdb/queue/iosched/fifo_batch
		ionice -c 3 command
		timedatectl set-local-rtc 1
		sudo pacman -Scc
		yay gamemode 1 -y
		echo 'bit.trip.runner -I -n -4
		Amnesia.bin64 -I -n -4
		hl2.exe -I -n -4 -a 0x1 #Wine with GLSL enabled' >> /etc/schedtoold.conf

		;;
	"Other Opti stuff")
		pacman -S tee -y
		yay tee 1 -y
		sudo tee -a /etc/sysctl.d/99-sysctl.conf <<-EOF
			vm.swappiness=1
			vm.vfs_cache_pressure=50
			vm.dirty_background_bytes=16777216
			vm.dirty_bytes=50331648
		EOF
		break
		;;
	"Quit")
		echo "User requested exit"
		exit
		;;
	*) echo "invalid option $REPLY" ;;
	esac
done