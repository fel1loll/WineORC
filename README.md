Fork from PlaceholderLabs WineORC script, with the addtion of more revivals, :P.

This script is ***not supported, authorized, or afilliated in any way, shape or form*** by the official devs of these private-servers.

## Supported Revivals
* SyntaxEco (unchanged from the original script)
* Austiblox
* ECS:R

## Revivals on this script that i need to fix
* Projekt Placeholder

## Current Issues
Austiblox and ECS:R client downloads links are from my google drive. Reason being that, Austiblox uses MEGA to download their client, which is impossible to download with (for example) wget without the use of special tools, and ECS.R needs you to be logged in to download clients from their website. If this script gets some attention i will try to fix that, in the meantime its all i have to give.

## Notes
Please be patient on the installation of Austiblox, since the DotNet dependencies take a huge time to fullfil in Linux with WINE.

## This next section is from the original page, if you have any problem with the script, pretty please file a Issue report. Thanks!

## ⚡ What this does
This script will download dependencies, register URI and install the private-server of choice. It can also install DXVK, and uninstall the revival of choice.

## ⚠️ Requirements
The needed packages are:
- `sudo`
- The latest WINE (preferably wine-staging)
- `wget`
- `curl`

The script can install WINE for you. However, only some distros are supported, so if it fails then you should install WINE and the other dependencies manually.

## 💻 How to use it

1. Download the latest release from the Releases page (or just clone this repo via git)
2. Open a terminal and cd into where the script is downloaded.
3. Run `chmod +x wineorc.sh`
4. Run `./wineorc.sh` and follow the prompts.
5. Once installed, play a game and it should work!

See `./wineorc.sh --help` for all available options.

## ⬆️ How to update the revival
You should do these steps if the revival has recently been updated:

1. Download the latest Wineorc version (get it from the Releases tab)

2. Run `./wineorc.sh uninstall`, then select your revival. Enter your password if prompted.

3. Run the script normally.

If the script has an out of date launcher, create an issue and it will be updated. You can also open a pull request with the latest link, and I'll accept it.

## ❗ Troubleshooting
If the revival crashes/doesn't launch, try to:

1. Make sure all necessary optional wine dependencies are installed. You can install them on Arch Linux by running these commands:

`sudo pacman -S expac &&
sudo pacman -S $(expac '%n %o' | grep ^wine)`

If you're not on arch, see [here](https://wiki.winehq.org/Building_Wine#Satisfying_Build_Dependencies) for all the dependencies.

2. Uninstalling the revival (use `./wineorc.sh uninstall` and then select the revival) and then reinstalling it again. (this really can help)

If those don't work, create a Github Issue.

## Credits

* DarDarDar for original wineORC

* [doitsujin/dxvk](https://github.com/doitsujin/dxvk), licensed under the zlib license

* Team PlaceholdeR for wineORC 2.7+ builds

* vl1 for making the Polygon guide

* calones for helping me, and putting up with me being dumb

* thexkey for helping me alot making the Placeholder helper

* itteh, genosmrpg, jackd900, pizzaboxer, kinery and thexkey for making great revivals


<div align="center" class="tip" markdown="1" style>

![itteblox working](https://raw.githubusercontent.com/PlaceholderLabs/Wineorc/main/photos/ittebloxlinux.png)

ItteBlox 2016 working on Arch Linux via wineORC

</div>
