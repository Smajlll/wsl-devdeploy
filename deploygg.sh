#!/bin/bash
# TODO Opravit funkci mazání - momentálně pouze zavře program
# TODO Dodělat instalaci Doom Emacs
# TODO Dopsat že toto je pouze pro Debian based systémy
# TODO přidat na github


clear 
echo "Ahoj, vítej v DeployGG, prosím vyber si možnost"
echo " i) Nainstaluj a deployni všechny dev tools"
echo " u) Update systému a všech dev tools"
echo " d) Odinstalovat všechny dev tools"
echo " q) Odejít"

read input
if [[ $input == i ]]; then
		clear
		echo "Zvolil si instalaci"
		echo "Tato možnost nainstaluje všechny dev tools které jsem určil za vhodné"
		echo "také nakonfiguruje git a aktualizuje pip a npm."
		echo "Tento script si vytvoří vlastní složku ve tvém home adresáři."
		echo "Budeš několikrát dotázán na své heslo pro sudo."
		echo "Chceš pokračovat?"
		read input

		if [[ $input == y || $input == Y ]]; then
			# Po spuštění instalace a potvrzení
			mkdir ggdeployscript
			cd ggdeployscript
			echo "Pokračuji s instalací"

			sudo apt-get update -y && sudo apt-get upgrade -y # Aktualizuje systém

			# Vyčištění obrazovky
			sleep 2
			clear

			echo "Instaluji curl a wget"
			nainstalovat="curl wget" #Instalace curl a wget
			sudo apt-get install -y $nainstalovat

			sleep 2
			clear
			echo "Instalace node.js repositáře"
			# sudo su -c 'curl -sL https://deb.nodesource.com/setup_14.x | bash -' #Nainstaluje node repo - nefunguje
			sudo apt-get update -y && sudo apt-get upgrade -y # Aktualizuje systém
			# sudo apt install -y npm #Instaluje npm
			curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
			export NVM_DIR="$HOME/.nvm"
			[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
			[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
			nvm install node
			nvm use node 
			sudo npm install -g npm # Aktualizuje npm
			clear
			echo "Verze node.js:"
			nvm run node --version 
			echo "Verze npm:" # vypíše verze npm a node
			npm --version
			echo "Node.js a npm nainstalováno!"
			sleep 4

			echo "Instaluji git"
			sudo apt-get install git -y

			clear
			sleep 3

			echo "Zadej svoje celé jméno"
				read jmeno
			echo "Zadej svůj email"
				read email
					echo "Tvoje zvolené jméno je $jmeno a tvůj zvolený mail je $email."
			echo "Konfiguruji git"
				git config --global user.name "$jmeno"
				git config --global user.email "$email"
			echo "Git nastaven pro $jmeno, který má email $email"
			sleep 3
			clear

			echo "Instaluji python a pip"
			sudo apt-get install python3 python3-pip -y
			pip install -U pip

			echo "Přidávám pip do PATH"
				export PATH=/home/$USER/bin:$PATH
			sleep 3
			clear

			echo "Verze python:"
			python3 --version
			echo "Verze pip3:"
			pip3 --version
			sleep 5

			clear

			echo "Instaluji cmake a cpp"
			sudo apt-get install cmake cpp -y

			sleep 3
			clear

			echo "Verze cmake:"
				cmake --version
			echo "Verze cpp:"
				cpp --version

			sleep 10
			clear

			echo "Nainstalovat vim? (Yy/Nn)"
			read input
				if [[ $input == y || $input == Y ]]; then
					sudo apt-get install vim -y
				elif [[ $input == n || $input == N ]]; then
					echo "Vim nebude nainstalován!"
				else
					echo "Zadán neznámý příkaz, pokračuji bez instalace"
				fi
			sleep 5
			clear

			echo "Nainstalovat nvim? (Yy/Nn)"
			read input
				if [[ $input == y || $input == Y ]]; then
					sudo apt-get install neovim -y
					sleep 5
					clear
					echo "Stáhnout vim-plug pro nvim? (Yy/Nn)"
					read inputplug
						if [[ $inputplug == y || $inputplug == Y ]]; then
							echo "Stahuji vim-plug pro nvim"
								cd /home/$USER
								mkdir .config
								cd .config
								mkdir nvim
							sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \ 
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
						elif [[ $inputplug == n || $inputplug == N ]]; then
							echo "Okay, vim-plug nebude nainstalován."
						else
							echo "Neznámý příkaz, pokračuji bez instalace"
						fi
					cd /home/$USER/ggdeployscript

					echo "Stáhnout config pro nvim? (Yy/Nn)"
					read inputconf
						if [[ $inputconf == y || $inputconf == Y ]]; then
							echo "Stahuji config"
							cd /home/$USER/ggdeployscript
							curl -o init.vim https://raw.githubusercontent.com/Smajlll/config/main/nvim/init.vim

							sleep 5
							echo "Chceš překopírovat stažený init.vim do tvého config adresáře?"
							echo "UPOZORNĚNÍ: Toto přepíše tvůj momentální config v /home/$USER/.confg/nvim"
							echo "Chceš pokrčovat? (Yy/Nn)"
							read copyconf

								if [[ $copyconf == y || $copyconf == Y ]]; then
									cd /home/$USER/ggdeployscript
									cp /home/$USER/ggdeployscript/init.vim /home/$USER/.config/nvim/init.vim
									sleep 5
									clear

									echo "Config zkopírován na své místo!"
									echo "Pro instalaci všech pluginů, spusť nvim a spusť :PlugInstall"
								elif [[ $copyconf == n || $copyconf = N ]]; then
									echo "Config nebude zkopírován"
									echo "Můžeš jej sám zkopírovat pomocí"
									echo "cp /home/$USER/ggdeployscript/init.vim /home/$USER/.config/nvim/init.vim"
								else 
									echo "Neznámý příkaz, pokračuji bez kopírování configu"
									echo "Můžeš jej sám zkopírovat pomocí"
									echo "cp /home/$USER/ggdeployscript/init.vim /home/$USER/.config/nvim/init.vim"
								fi									


						elif [[ $inputconf == n || $inputconf == N ]]; then
							echo "Okay, config nebude stažen!"
						else
							echo "Neznámý příkaz, pokračuji bez stahování configu."
						fi

				elif [[ $input == n || $input == N ]]; then
					echo "NeoVim nebude nainstalován"
				else
					echo "Neznámý příkaz, pokračuji bez stažení"
				fi

			echo "Nainstalovat browsery pro debugging? (Yy/Nn)"
			read inputbrows
				if [[ $inputbrows == y || $inputbrows == Y ]]; then
					sudo apt-get update -y && sudo apt-get upgrade -y
					cd /home/$USER/ggdeployscript
					echo "Stahuji Google Chrome"
					wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
		
					echo "Stahuji Firefox"
					sudo apt-get install firefox > /dev/null
					sudo dpkg -i google-chrome-stable_current_amd64.deb > /dev/null
					
					sudo apt --fix-broken install -y

					echo "Instaluji Google Chrome"
					sudo dpkg -i google-chrome-stable_current_amd64.deb -y
					echo "Instaluji Firefox"
					sudo apt-get install firefox -y

					
				elif [[ $inputbrows == y || $inputbrows == Y ]]; then
					echo "Okay, browsery nebudou nainstalovány."
				else
					echo "Neznámá možnost, pokračuji bez instalace."
				fi
			echo "Nainstalovat VS Code? (Yy/Nn)"
			read inputcode
				if [[ $inputcode == y || $inputcode == Y ]]; then
					#echo "Chcete použít snap (Nedoporučeno) (Yy/Nn)"
					#read inputsnap
					#	if [[ $inputsnap == y || $inputsnap == Y ]]; then
					#		clear
					#		echo "Ujišťuji se že je snapd nainstalován"
					#		sleep 3

					#		sudo apt-get install snapd
					#		sleep 3
					#		echo "Aktivuji snapd"
					#		sudo systemctl enable --now snapd.socket
					#			sleep 5
					#		echo "Instaluji VS Code"
					#		sudo snap install code --classic
					#		sleep 5
					#		clear
					#		echo "VS Code nainstalován"
					#	else
							clear
							echo "Stahuji VS Code .deb balík."
							wget https://az764295.vo.msecnd.net/stable/8fa188b2b301d36553cbc9ce1b0a146ccb93351f/code_1.73.0-1667318785_amd64.deb
							echo "Instaluji VS Code!"
							sudo dpkg -i code_1.73.0-1667318785_amd64.deb > /dev/null
							sudo apt-get --fix-broken install -y > /dev/null
							sudo dpkg -i code_1.73.0-1667318785_amd64.deb
							sleep 5
							clear
							echo "VS Code nainstalován"
						fi
				elif [[ $inputcode == n || $inputcode == N ]]; then
					echo "Okay, VS Code nebude nainstalován."
				else
					echo "Neznámá možnost, pokračuji bez instalace VS Code."
				fi

			echo "Nainstalovat Github CLI?"
			read inputghcli
				if [[ $inputghcli == y || $inputghcli == Y ]]; then
					echo "Stahuji a instaluji Github CLI s Github GPG Signing Klíčem."
					curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
					&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
					&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
					&& sudo apt update \
					&& sudo apt install gh -y > /dev/null \
					&& sudo apt --fix-broken install \
					&& sudo apt install gh -Y
					sleep 5
					clear
					echo "Github CLI nainstalováno!"
					echo "Chceš se do Github CLI authentikovat nyní? (Yy/Nn)"
					read authcli
						if [[ $authcli == y || $authcli == Y ]]; then
							clear 
							echo "Zadej prosím svůj github authentication token:"
							read ghauth
							echo "Pokouším se authentikovat se zadaným Auth Tokenem"
							gh auth login --with-token $ghauth
						elif [[ $authcli == n || $authcli == N ]]; then
							echo "Okay, prozatím se nebudeš authentikovat do Github CLI."
							echo "Nezapomeň, authentikovat sse můžeš po dokončení tohoto scriptu pomocí:"
							echo "gh auth login --with-token <Tvůj GH Authentication Token>, nebo pomocí:"
							echo "gh auth login --web pro authentikaci ve tvém Web Browseru :D."
						else
							echo "Neznámá možnost, pokračuji bez authentikace."
							echo "Nezapomeň, authentikovat sse můžeš po dokončení tohoto scriptu pomocí:"
                                                        echo "gh auth login --with-token <Tvůj GH Authentication Token>, nebo pomocí:"
                                                        echo "gh auth login --web pro authentikaci ve tvém Web Browseru :D."
						fi
				elif [[ $inputghcli == n || $inputghcli == N ]]; then
					echo "Dobře, nebudu stahovat Github CLI."
				else
					echo "Neznámá možnost, pokračuji bez instalace."
				fi
# přidat instalaci doom emacs
			sleep 4
			clear
			echo "Gratuluji, došel jsi do konce tohoto scriptu, nyní by jsi měl mít všechny aplikace"
			echo "pro vývoj aplikací v c++, pythonu, node.js, html, css atd."
			echo "Díky že jsi použil tento script :D."
			echo " -Smajl"

			exit 1

		else
			echo "Ukončuji program"
			exit 1
		fi

elif [[ $input == d ]]; then
	clear

	echo "Zvolil jsi odinstalaci"
	echo "Tato možnost odinstaluje VŠECHNY BALÍKY které script nainstaloval při prvním spuštění."
	echo "UPOZORNĚNÍ: toto odinstaluje VŠECHNY aplikace které script nainstaloval"
	echo "to znamená také všechny USER DATA těchto aplikací a VŠECHNY JEJICH CONFIGY"
	echo "Chceš pokračovat? (Yy/Nn)"
	read inputrm
		if [[ $inputrm == y || $inputrm == Y ]]; then
			echo "Opravdu chceš pokračovat, tato akce je nevratná - pro pokračování napiš "Ano, chci pokračovat.""
			read inputrm
			if [[ $inputrm == "Ano, chci pokračovat." ]]; then
				echo "Probíhá zabíjení všech programů které systém nainstaloval"
					killall google-chrome
					killall google-chrome-stable
					killall code
					killall firefox
					killall cpp
					killall cmake
					killall git
					killall vim
					killall nvim
					killall gh
					killall python
					killall python3
					killall pip
					killall pip3
					killall node
					killall nodejs
					killall nvm
					killall npm
				echo "Probíhá odinstalace všech programů v repositářích"
					sudo apt-get remove --purge firefox cpp cmake git vim nvim gh python3 python3-pip -y 
				echo "Probíhá odinstalace nodejs"
					export NVM_DIR="$HOME/.nvm"
					[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
					[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
						nvm deactivate node
						nvm uninstall node
						sudo apt-get remove --purge npm
				echo "Probíhá instalace nvm"
					cd $HOME
					rm -rf ./.nvm
				echo "Probíhá odinstalace aplikací z .deb balíků"
					sudo apt-get purge '^code.*'
					sudo apt-get purge '^google-chrome*'
				echo "Odstraňuji pluginy a configuraci nvimu"
					rm -rf /home/$USER/.config/nvim
					rm -rf /home/$USER/.local/share/nvim
				echo "Mažu Google Chrome repositář"
					sudo rm /etc/apt/sources.list.d/google-chrome.list
				echo "Mažu Github CLI Repo"
					sudo rm /etc/apt/sources.list.d/github-cli.list
					cd $HOME
				echo "Mažu složku tohoto scriptu"
					rm -rf ggdeployscript
					clear
				echo "Všechny aplikace a jejich konfigurace byli odstraněny."
				echo "Také jsem odstranil všechny svoje přebitečné soubory."
				echo "Doufám že se ještě někdy uvidíme."
				echo "Díky že jsi použil tento script :D"
				echo " -Smajl"
			else 
				echo "Nebyl zadán správný string, ukončuji"
				exit 1
			fi
		else
			echo "Akce nebyla potvrzena pomocí Y/y, ukončuji"
			exit 1
		fi

elif [[ $input == u ]]; then
	echo "Nedokončeno, quiting..."
	exit 1
elif [[ $input = q ]]; then
	echo "Quiting..."
	exit 1
else 
	exit 1
fi
