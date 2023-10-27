#!/bin/bash
# Made by DarDarDar, 2022
# wineORC 2.8+ by PlaceholderLabs, 2023

if [ $EUID == "0" ]; then
	echo "Please run this script as a non-root. "
	exit
fi

if [ "$1" == "--version" ]
then
	echo "Wineorc v2.8 "
	echo "License: MIT (see https://github.com/PlaceholderLabs/wineORC/blob/main/LICENSE) "
	exit
fi

if [ "$1" == "--help" ]
then
	echo "wineORC: The only script that matters (real) "
	echo "Usage: ./wineorc.sh [OPTION]... "
	echo ""
	echo "Options: "
	echo "	uninstall: uninstalls a selected private server from a list of options "
	echo "	dxvk: installs dxvk, the directx to vulkan translation layer, to a wineprefix from a list of options. this can drastically improve performance in some private servers "
	echo "	--version: prints the version of wineorc that is being ran "
	echo "	--help: what you're reading right now, you beautiful human being "
	echo ""
	echo "Example: "
	echo "	./wineorc.sh dxvk "
	exit
fi

uninstall ()
{
	echo "Uninstalling $CURRENT now.. "
	sleep 3
	if [ $CURRENT == "Placeholder" ]
	then
		rm $HOME/.placeholder -rf
		sudo rm /usr/share/applications/placeholder.desktop
	fi
	if [ $CURRENT == "SyntaxEco" ]
	then
		rm $HOME/.syntaxeco -rf
		sudo rm /usr/share/applications/syntaxeco.desktop
	fi
	if [ $CURRENT == "Austiblox" ]
	then
		rm $HOME/.austiblox -rf
		sudo rm /usr/share/applications/austiblox.desktop
	fi
	if [ $CURRENT == "ECSR" ]
	then
		rm $HOME/.ecsr -rf
		sudo rm /usr/share/applications/ecsr.desktop
	fi
	sudo update-desktop-database
	echo "Uninstall done. Run the script again if you'd like to reinstall. "
        exit
}

if [ "$1" == "uninstall" ] || [ "$2" == "uninstall" ]
then
	echo "Please select the revival you'd like to uninstall: "
	echo "1. Placeholder "
	echo "2. SyntaxEco "
	echo "3. Austiblox "
	echo "4. ECSR "
	read UNINSTALLOPT 
	if [ $UNINSTALLOPT == "1" ]
	then
		CURRENT="Placeholder"
		uninstall
	fi
	if [ $UNINSTALLOPT == "2" ]
	then
		CURRENT="SyntaxEco"
	 	uninstall	
	fi
	if [ $UNINSTALLOPT == "3" ]
	then
		CURRENT="Austiblox"
		uninstall
	fi
	if [ $UNINSTALLOPT == "4" ]
	then
		CURRENT="ECSR"
		uninstall
	fi
fi
if [ "$1" == "dxvk" ] || [ "$2" == "dxvk" ]
then
	echo "Please select the wineprefix you'd like DXVK to install to: "
	echo "1. Placeholder wineprefix "
	echo "2. SyntaxEco wineprefix "
	echo "3. Austiblox wineprefix "
	echo "4. ECSR wineprefix "
	read DXVKOPT
	mkdir $HOME/tmp
	cd $HOME/tmp
	wget https://github.com/doitsujin/dxvk/releases/download/v2.0/dxvk-2.0.tar.gz
	tar -xf dxvk-2.0.tar.gz
	cd dxvk-2.0
	if [ $DXVKOPT == "1" ]
	then
		WINEPREFIX=$HOME/.placeholder ./setup_dxvk.sh install
	fi
        if [ $DXVKOPT == "2" ]
        then
                WINEPREFIX=$HOME/.syntaxeco ./setup_dxvk.sh install
        fi
		if [ $DXVKOPT == "3" ]
        then
                WINEPREFIX=$HOME/.austiblox ./setup_dxvk.sh install
        fi
	if [ $DXVKOPT == "4" ]
	then
		WINEPREFIX=$HOME/.ecsr ./setup_dxvk.sh install
	fi
	cd $HOME
	rm tmp -rf
	echo "DXVK has been installed to selected wineprefix. "
	exit
fi

winetricksinstaller ()
{
    echo "Please accept any prompts it gives you, and enter your password if necessary. "
    sleep 3
    DISTRO=`cat /etc/*release | grep DISTRIB_ID | cut -d '=' -f 2` # gets distro name
    if [ $DISTRO == "Ubuntu" ] || [ $DISTRO == "LinuxMint" ] || [ $DISTRO == "Pop" ]
    then 
		VERSION=`lsb_release --release | cut -f2`
		if [ $VERSION == "18.04" ] || [ $VERSION == "19.3" ]
				then
				echo "The version (of your OS) you are currently on might not have the winetricks package in their repos, if so, the installation of said package will promptly fail. "
		fi
        sudo apt update
        sudo apt install --install-recommends winetricks
    fi
    if [ $DISTRO == "Debian" ]
    then
        echo "If this fails, then a 32-bit multiarch does not exist. You should make one by following this guide: https://wiki.debian.org/Multiarch/HOWTO "
        sleep 3
        sudo apt-get install winetricks
    fi
    if [ $DISTRO == "ManjaroLinux" ]
    then
        echo "If this fails, please file a issue in the GitHub repo "
        sleep 3
        sudo pacman -S winetricks
    fi
    if [ $DISTRO == "Fedora" ]
    then
        sudo dnf install winetricks
    fi

    if [ $DISTRO == "Gentoo" ]
    then
        sudo emerge --ask app-emulation/winetricks
    fi
    if [ ! -x /usr/bin/winetricks ]
    then
        echo "It seems the script couldn't install winetricks for you. Please install it manually. "
	exit
    fi
}

wineinstaller ()
{
    echo "Please accept any prompts it gives you, and enter your password if necessary. "
    sleep 3
    DISTRO=`cat /etc/*release | grep DISTRIB_ID | cut -d '=' -f 2` # gets distro name
    if [ $DISTRO == "Ubuntu" ] || [ $DISTRO == "LinuxMint" ] || [ $DISTRO == "Pop" ]
    then
	sudo dpkg --add-architecture i386 # wine installation prep
	sudo mkdir -pm755 /etc/apt/keyrings
	sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
        VERSION=`lsb_release --release | cut -f2`
        if [ $VERSION == "22.04" ] || [ $VERSION == "21" ]
			        then
				        wget -nc https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources
				        sudo mv winehq-jammy.sources /etc/apt/sources.list.d/
        fi
        if [ $VERSION == "21.10" ]
			        then
         				wget -nc https://dl.winehq.org/wine-builds/ubuntu/dists/impish/winehq-impish.sources
				        sudo mv winehq-impish.sources /etc/apt/sources.list.d/
        fi
        if [ $VERSION == "20.04" ] || [ $VERSION == "20.3" ]
			        then
				        wget -nc https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources
				        sudo mv winehq-focal.sources /etc/apt/sources.list.d/
        fi
        if [ $VERSION == "18.04" ] || [ $VERSION == "19.3" ]
			        then
				        wget -nc https://dl.winehq.org/wine-builds/ubuntu/dists/bionic/winehq-bionic.sources
				        sudo mv winehq-bionic.sources /etc/apt/sources.list.d/
        fi
        sudo apt update
        sudo apt install --install-recommends winehq-staging
    fi
    if [ $DISTRO == "Debian" ]
    then
        echo "If this fails, then a 32-bit multiarch does not exist. You should make one by following this guide: https://wiki.debian.org/Multiarch/HOWTO "
        sleep 3
        sudo apt-get install wine-development
    fi
    if [ $DISTRO == "ManjaroLinux" ]
    then
        echo "If this fails, then the multilib repo is disabled in /etc/pacman.conf. The dependencies cannot be installed if this is disabled, so please enable it. "
        sleep 3
        sudo pacman -S wine-staging wine-mono expac # Arch Linux wine comes with a incredibly minimal package, so let's use expac to download everything it needs
	sudo pacman -S $(expac '%n %o' | grep ^wine)
    fi
    if [ $DISTRO == "Fedora" ]
    then
        sudo dnf install wine
    fi

    if [ $DISTRO == "Gentoo" ]
    then
        sudo emerge --ask virtual/wine-staging
    fi
    if [ ! -x /usr/bin/wine ]
    then
        echo "It seems the script couldn't install wine for you. Please install it manually. "
	exit
    fi
}

winecheck ()
{
    if [ ! -x /usr/bin/wine ]
    then
        read -p "Wine doesn't seem to be installed. This is required for the script to run. Would you like the script to install it for you? [y/n] " WINEINSTALLOPT
        if [ $WINEINSTALLOPT = "y" ]
        then
            wineinstaller
        else
            echo "OK, the script *won't* install wine for you. Please kill the script and install it manually. If you're sure it's installed, then don't kill the script. "
            sleep 3
        fi
    else
        echo "wine is installed, skipping check.. "
    fi
}

winetrickscheck ()
{
    if [ ! -x /usr/bin/winetricks ]
    then
        read -p "winetricks doesn't seem to be installed. This is required for certain revivals to get up and running. Would you like the script to install it for you? [y/n] " WINETRICKSINSTALLOPT
        if [ $WINETRICKSINSTALLOPT = "y" ]
        then
            winetricksinstaller
        else
            echo "OK, the script *won't* install winetricks for you. Please kill the script and install it manually. If you're sure it's installed, then don't kill the script. "
            sleep 3
        fi
    else
        echo "winetricks is installed, skipping check.. "
    fi
}

othercheck ()
{
	if [ ! -x /usr/bin/wget ]
	then
		echo "wget seems to not be installed. Please kill the script then install wget via your package manager. "
		echo "If you're sure it's installed, then don't kill the script. "
		sleep 3
	else
		echo "wget is installed, skipping check.. "
	fi
	if [ $CURRENT == "Placeholder" ] || [ $CURRENT == "SyntaxEco" ]
	then	
		if [ ! -x /usr/bin/curl ]
		then
			echo "curl seems to not be installed. Please kill the script then install curl via your package manager. "
			echo "If you're sure it's installed, then don't kill the script. "
			sleep 3
		else
			echo "curl is installed, skipping check.. "
		fi
	fi
}

uri ()
{
	if [ $CURRENT == "Austiblox" ]
	then
		touch austiblox.desktop
		echo "[Desktop Entry]" >> austiblox.desktop
		echo "Name=Austiblox Launcher" >> austiblox.desktop
		echo "Comment=https://austiblox.net/" >> austiblox.desktop
		echo "Type=Application" >> austiblox.desktop
		echo "Exec=env WINEPREFIX=$HOME/.austiblox wine $HOME/.austiblox/drive_c/Austiblox/AustibloxLauncher.exe %U" >> austiblox.desktop
		echo "MimeType=x-scheme-handler/austiblox" >> austiblox.desktop
	fi

	if [ $CURRENT == "Placeholder" ]
	then
		touch placeholder.desktop
		echo "[Desktop Entry]" >> placeholder.desktop
		echo "Name=Placeholder Player" >> placeholder.desktop
		echo "Comment=https://placeholder16.tk/" >> placeholder.desktop
		echo "Type=Application" >> placeholder.desktop
		echo "Exec=env WINEPREFIX=$HOME/.placeholder wine $HOME/.placeholder/drive_c/users/$USER/AppData/Local/Placeholder/Versions/$PLACEHOLDERVER/PlaceholderPlayerLauncher.exe %u" >> placeholder.desktop
		echo "MimeType=x-scheme-handler/placeholder-player-placeholder16" >> placeholder.desktop
	fi

	if [ $CURRENT == "ECSR" ]
	then
		touch ecsr.desktop
		echo "[Desktop Entry]" >> ecsr.desktop
		echo "Name=ECS:R Player" >> ecsr.desktop
		echo "Comment=https://ecsr.io" >> ecsr.desktop
		echo "Type=Application" >> ecsr.desktop
		echo "Exec=env WINEPREFIX=$HOME/.ecsr wine $HOME/.ecsr/drive_c/users/$USER/AppData/Local/ECSR/Versions/ECSRClient081023/RobloxPlayerLauncher.exe %u" >> ecsr.desktop
		echo "MimeType=x-scheme-handler/ecsr-player" >> ecsr.desktop
	fi

	if [ $CURRENT == "SyntaxEco" ]
	then
		touch syntaxeco.desktop
		echo "[Desktop Entry]" >> syntaxeco.desktop
		echo "Name=Syntax" >> syntaxeco.desktop
		echo "Comment=https://syntax.eco" >> syntaxeco.desktop
		echo "Type=Application" >> syntaxeco.desktop
		echo "Exec=env WINEPREFIX=$HOME/.syntaxeco wine $HOME/.syntaxeco/drive_c/users/$USER/AppData/Local/Syntax/Versions/$SYNTAXVER/SyntaxPlayerLauncher.exe %u" >> syntaxeco.desktop
		echo "MimeType=x-scheme-handler/roblox-player-syntax" >> syntaxeco.desktop
	fi

	sudo mv *.desktop /usr/share/applications
	sudo update-desktop-database
}

austiblox ()
{
	winecheck
	winetrickscheck
	othercheck
	echo "$CURRENT is now being installed, this certain revival may take a long time. "
	sleep 3
	# austibloxes version is static, no need to ask da servers
	mkdir $HOME/.austiblox
	WINEPREFIX=$HOME/.austiblox winecfg -v win7
	mkdir $HOME/tmp
	cd $HOME/tmp
	WINEPREFIX=$HOME/.austiblox winetricks dotnet45 # WIP : MAKE WINETRICKS A REQUIRMENTS AND INSTALL IT FOR THE USER IF THEY DONT HAVE IT. <<<< SOMWAT DON <<<< DON I THINK HAVENT TESTED
	WINEPREFIX=$HOME/.austiblox wineserver -k
	wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1z8KMYU42isINYXi7lQf0-rOqetb2r90M' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1z8KMYU42isINYXi7lQf0-rOqetb2r90M" -O Austiblox.exe && rm -rf /tmp/cookies.txt # austiblox uses mega, and there is no way to download files from mega with wget, only with special tools. so i decided to upload it to my google drive :P
	WINEPREFIX=$HOME/.austiblox wine Austiblox.exe
	uri
}

placeholder ()
{
	winecheck
	othercheck
	echo "$CURRENT is now being installed, please wait as this may take some time. "
        sleep 3
	PLACEHOLDERVER=`curl https://setup.placeholder16.tk/version` # uri
	mkdir $HOME/.placeholder
	WINEPREFIX=$HOME/.placeholder winecfg -v win10
	mkdir $HOME/tmp
	cd $HOME/tmp
	wget https://setup.placeholder16.tk/PlaceholderPlayerLauncher.exe
	echo "Your browser may open to the Placeholder website when this is ran. Just close it. "
	WINEPREFIX=$HOME/.placeholder wine PlaceholderPlayerLauncher.exe
	uri
}

syntaxeco ()
{
	winecheck
	othercheck
	echo "$CURRENT is now being installed, please wait as this may take some time. "
	sleep 3
	PLACEHOLDERVER=`curl https://setup.syntax.eco/version` # uri
	mkdir $HOME/.syntaxeco
	WINEPREFIX=$HOME/.syntaxeco winecfg -v win10
	mkdir $HOME/tmp
	cd $HOME/tmp
	wget https://setup.syntax.eco/SyntaxPlayerLauncher.exe # BRO, WHY DID HE NOT JUST FOLLOW THE CDN SCHEMA FULLY? << why he so mad? -feli
	echo "Your browser may open to the SyntaxEco website when this is ran. Just close it. "
	WINEPREFIX=$HOME/.syntaxeco wine SyntaxPlayerLauncher.exe
	uri
}

ecsr ()
{
	winecheck
	othercheck
	echo "$CURRENT is now being installed, please wait as this may take some time. "
	sleep 3
	# ECSRVER= # ecsr dont have a way to tell the version that i know of, but when i do find one (or one is made), i will try to implement it here
	mkdir $HOME/.ecsr
	WINEPREFIX=$HOME/.ecsr winecfg -v win10
	mkdir $HOME/tmp
	cd $HOME/tmp
	wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1ALj_MrptMf98IZF29yvCABcxbhnysV2g' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1ALj_MrptMf98IZF29yvCABcxbhnysV2g" -O RobloxPlayerLauncher.exe && rm -rf /tmp/cookies.txt # u can't download from ecs:r without being logged in, so i decided to upload it to my drive again :PPPPPP / jank solution, clean one didn't work , but this does doe
	echo "Your browser may open to the ECSR website when this is ran. Just close it. "
	WINEPREFIX=$HOME/.ecsr wine RobloxPlayerLauncher.exe
	uri
}


echo "Welcome to Wineorc, please select an revival to install. (see --help for other options) "
echo "1. Placeholder "
echo "2. SyntaxEco "
echo "3. Austiblox "
echo "4. ECSR "
read OPT
if [ $OPT == "1" ]
then
	CURRENT="Placeholder"
	placeholder
fi
if [ $OPT == "2" ]
then
	CURRENT="SyntaxEco"
	syntaxeco
fi
if [ $OPT == "3" ]
then
	CURRENT="Austiblox"
	austiblox
fi
if [ $OPT == "4" ]
then
	CURRENT="ECSR"
	ecsr
fi


wineserver -k
cd $HOME
rm tmp -rf
echo "$CURRENT should now be installed! Try playing a game and it should work! "
exit

