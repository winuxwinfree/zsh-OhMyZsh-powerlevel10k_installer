#!/bin/bash
#Zsh+OhMyZsh+Powerlevel10k installer for Debian PI
#Script made by androrama fenixlinux.com
timeshift () {
    if [ `uname -m` = "x86_64" ]; then
    sudo apt install timeshift || echo "Error installing Timeshift, try doing an -apt update- before. Maybe it's not in your repositories."
    echo
    echo "Process finished. It's recommended to make a backup with Timeshift to go back if something goes wrong."
    echo 
    elif [ `getconf LONG_BIT` = "32" ]; then
    cd $DIRECTORY
    wget -qnc --continue https://github.com/teejee2008/timeshift/releases/download/v20.11.1/timeshift_20.11.1_armhf.deb -P ~/Downloads || error 'Failed to download timeshift!'
    sudo apt install -y --fix-broken ~/Downloads/timeshift_20.11.1_armhf.deb |
    zenity --progress \
    --title="Installing Timeshift" \
    --text="Installing Timeshift, as soon as the process is completed you will have a shortcut in Menu > System-Tools." \
    --percentage=0|| echo 'Failed to install .deb file!'
    rm -f timeshift_20.11.1_armhf.deb* 
    echo 
    echo
    echo "Process finished. It's recommended to make a backup with Timeshift to go back if something goes wrong."
    echo
    sleep 2
    elif [ `getconf LONG_BIT` = "64" ]; then
    wget -qnc --continue https://github.com/teejee2008/timeshift/releases/download/v20.11.1/timeshift_20.11.1_arm64.deb -P ~/Downloads || echo 'Failed to download timeshift!'
    ssudo apt install -y --fix-broken ~/Downloads/timeshift_20.11.1_arm64.deb || echo 'Failed to install .deb file!'
    zenity --progress \
    --title="Installing Timeshift" \
    --text="Installing Timeshift, as soon as the process is completed you will have a shortcut in Menu > System-Tools" \
    --percentage=0|| echo 'Failed to install .deb file!'
    rm -f timeshift_20.11.1_arm64.deb*
    echo 
    echo "Process finished. It's recommended to make a backup with Timeshift to go back if something goes wrong."
    echo
    sleep 2
    fi
}
REQUIRED_PKG="zsh"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
	tfile=`mktemp`
	echo "
-The installer does't work properly? Contact us: fenixlinux.com
-You can uninstall ZSH launching this script again.
-ZSH description: 
 *The Z shell (Zsh) is a Unix shell that can be used as an interactive login shell and as a command interpreter for shell scripting. Zsh is an extended Bourne shell with many improvements, including some features of Bash, ksh, and tcsh.
 *Oh My Zsh is an open source, community-driven framework for managing your zsh configuration.
 *Powerlevel10k is a theme for Zsh. It emphasizes speed, flexibility and out-of-the-box experience."> "$tfile"
if zenity --text-info --title="ZSH Installer V1 Debian* PI" --filename="$tfile"
 #Delete about tmp file
    rm -f "$tfile"
 then
	echo "Dpkg/apt unlock"
	sudo fuser -vki /var/lib/dpkg/lock
	sudo rm /var/lib/dpkg/lock
	sudo rm /var/lib/apt/lists/lock 2>/dev/null 
	sudo rm /var/cache/apt/archives/lock 2>/dev/null 
	sudo dpkg --configure -a
  #Install a backup program
    REQUIRED_PKG="timeshift"
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
    echo Checking for $REQUIRED_PKG: $PKG_OK
    if [ "" = "$PKG_OK" ]; then
    if zenity --question --title="Install timeshift" --text="Timeshift is a tool that allows you to create a restore point. Install it?"
     then
        timeshift
    fi
    fi
    if zenity --question --title="Continue?" --text="It's time to make a bakcup, continue?"
    then
		echo "Delete about tmp file"
		rm -f "$tfile"
		#Install
		echo "Install zsh"
		sudo apt-get update
		sudo apt install git-core curl
		sudo apt-get install zsh -y
		echo "Set ZSH to be the default shell instead of bash."
		chsh -s /bin/zsh
		echo "Check the default shell."
		echo $0			 
		echo "Install Oh My ZSH!"
		zenity --info  --width=400 \
					--text="Type exit and press enter to continue when zsh opens."
		sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
		#Install powerlevel10k
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
		echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>! ~/.zshrc
		source ~/.zshrc
		sudo apt-get install zsh-syntax-highlighting
		sudo apt-get install zsh-autosuggestions
		sudo apt-get install fonts-powerline
		git clone https://github.com/abertsch/Menlo-for-Powerline.git
		cd Menlo-for-Powerline
		sudo mv Menlo* /usr/share/fonts
		echo "Go to Terminal -> Preferences, and set font to Powerline to display more characters."
		echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
		 zenity --info  --width=400 \
					--text="Done. You can customize Powerlevel10k in the future with the - p10k configure - command."
		   #Support
		if zenity --info  --width=400 \
		--text="That's all, don't forget to support the developers of these amazing applications if you like them."
			then
		xdg-open 'https://github.com/ohmyzsh' &>/dev/null
		xdg-open 'https://fenixlinux.com/pdownload' &>/dev/null
		exec zsh
		fi
	 fi
	 else
	 exit 1
	 fi
 else
	 #Uninstall the program
		 if zenity --question --title="Uninstall zsh, OhMyZsh, Powerlevel10k" --text="Zsh is installed, do you want to uninstall it?"
			then
			   sudo apt-get --purge remove zsh
			   chsh -s /bin/bash
			   exec bash
			   echo "Process completed."
			   exit 1
		 fi
 fi
 exit 1
