#!/bin/bash
PID=$$
FIFO=/tmp/FIFO${PID}
mkfifo $FIFO

#recherche du dossier .conky
DOSSIER_CONKY="$HOME/.conky"
CONKY_EMBARQUE="/usr/local/bin/conky_switcher/conky"
CONKY_CONFIG="$HOME/.conkyconfig"



PREMIER_LANCEMENT(){
		[[ ! -d $DOSSIER_CONKY ]] && mkdir -p $DOSSIER_CONKY
		
		cd $CONKY_EMBARQUE
		for ck in `ls`
		do
			if [ -f $ck ]; then
			{
				NOM=$(basename $ck)
				
				if [ ! -f $DOSSIER_CONKY/$NOM ]; then
				{
					cp $ck $DOSSIER_CONKY; 
					[[ ! -e $HOME/.conky-sw ]] && > $HOME/.conky-sw
					[[ -e $HOME/.conky-sw ]] && echo "False|False|$DOSSIER_CONKY/$NOM" >> $HOME/.conky-sw
				}
				fi
			}
			fi	

		done
		cd -
}

treeconky(){
    echo "$(1)"
	#gestion des différents cas
	num_ligne=$(cut -d '@' -f1 <<< $@ )
	variable=$(cut -d '@' -f2 <<< $@ )
	etat_conky=$(cut -d '|' -f1 <<< $variable )
	autostart_conky=$(cut -d '|' -f2 <<< $variable )
	fichier_conky=$(cut -d '|' -f3 <<< $variable )
	
	#écriture du fichier de conky
	> $HOME/.conky-sw
	echo "TREE@@SAVE@@treeconky@@$HOME/.conky-sw"
	
	#gestion du démarrage
	if [ "$autostart_conky" = "True" ];
	then
		activer_autostart "$fichier_conky"
	else
		desactiver_autostart "$fichier_conky"
	fi
	
	#gestion du lancement
	#ajouter une un moyen pour arreter un conky particulier
	if [ "$etat_conky" = "True" ];
	then
		activer_conky "$fichier_conky"
	else
		desactiver_conky "$fichier_conky"
	fi
	
}

activer_autostart(){
	BASENAME=$(basename $1)
	ETAT=$(grep -i $BASENAME $HOME/.config/livarp-start.sh)
	if [ "$ETAT" = "" ];then
	echo "(sleep 3s && conky -c $1 ) &" >> $HOME/.config/livarp-start.sh
	fi
}

desactiver_autostart(){
	NOM=$(basename $1)
	sed -i '/'"$NOM"'/d' $HOME/.config/livarp-start.sh
}

activer_conky(){
	PID=$( ps ax | grep "$1" | head -n 1 | awk '{print $5}')
	if [ "$PID" != "conky" ]
	then
		conky -c $1 &
	fi
}

desactiver_conky(){
	PID=$(ps -ax | grep "conky -c $1" | awk '{print $1}')
	kill $PID
}

ajouter_ligne(){
	[[ -r $CONKY_CONFIG ]] && source $CONKY_CONFIG
	
	if [ "$i" = "" ];
	then
	i=0
	fi 
	
	echo "TREE@@INSERT@@treeconky@@$i@@False|False|$1"
	
	> $HOME/.conky-sw
	echo "TREE@@SAVE@@treeconky@@$HOME/.conky-sw"
	(( i = $i + 1 ))
	[[ -r $CONKY_CONFIG ]]  && echo "i=$i" >> $CONKY_CONFIG
}

_supprimerconky(){
	desactiver_conky "$fichier_conky"
	desactiver_autostart "$fichier_conky"
	
	#on supprime la ligne du treeview
	echo "TREE@@CELL@@treeconky@@@@"
	
	> $HOME/.conky-sw
	echo "TREE@@SAVE@@treeconky@@$HOME/.conky-sw"
}

_boutoneditconky(){
	[[ -e $fichier_conky ]] && geany $fichier_conky &
}

_boutonstopconky(){
	if [ "$(pidof conky)" ]; then
    killall conky
    fi
    
    if [ -e $HOME/.conky-sw ]; then
    { 
		> $HOME/.conky-sw1
		while read line
		do
		{
			autostart_conky=$(cut -d '|' -f2 <<< $line )
			fichier_conky=$(cut -d '|' -f3 <<< $line )
			echo "False|$autostart_conky|$fichier_conky" >> $HOME/.conky-sw1
		}
		done < $HOME/.conky-sw
	
		mv $HOME/.conky-sw1 $HOME/.conky-sw
		echo "TREE@@CLEAR@@treeconky"
		echo "TREE@@LOAD@@treeconky@@$HOME/.conky-sw"	
	}
	fi
}

button_ok_filechoose1()
{ # Récupère le chemin complet de la sélection
    echo "GET@filechooserdialog2.get_filename()"
}

_filechooserdialog2()
{
    if [[ "$1" = "clicked" ]]; then
        echo "GET@filechooserdialog2.get_filename()"   
        [[ -f $nouveau_conky ]] && ajouter_ligne "$nouveau_conky"
    elif [[ "$1" = "my_callback" ]]; then  
        echo " "
        [[ -f $nouveau_conky ]] && ajouter_ligne "$nouveau_conky"
    else
		echo "$@" 
        nouveau_conky="$@"
    fi
}


DEMARRAGE(){	
	PREMIER_LANCEMENT
	
	#modification des variables d'activation si autostart
	if [ -e $HOME/.conky-sw ];
	then
	{
		> $HOME/.conky-sw1
		while read line
		do
			autostart_conky=$(cut -d '|' -f2 <<< $line )
			etat_conky=$(cut -d '|' -f1 <<< $line )
			fichier_conky=$(cut -d '|' -f3 <<< $line )
			PID=$( ps ax | grep "$fichier_conky" | head -n 1 | awk '{print $5}')
		
			if [ "$PID" = "conky" ];
			then
			{
				echo "True|$autostart_conky|$fichier_conky" >> $HOME/.conky-sw1
			}
			else
			{
				echo "False|$autostart_conky|$fichier_conky" >> $HOME/.conky-sw1
			}	
			fi 
		done < $HOME/.conky-sw
		mv $HOME/.conky-sw1 $HOME/.conky-sw
	}
	fi
	

	[[ -e $HOME/.conky-sw ]] && echo "TREE@@LOAD@@treeconky@@$HOME/.conky-sw"	
	echo 'SET@window2.show()'
}


DEMARRAGE


################################################################################
while read ligne; do
    if [[ "$ligne" =~ GET@ ]]; then
       eval ${ligne#*@}
       echo "DEBUG => in boucle bash :" ${ligne#*@}
    else
       echo "DEBUG=> in bash NOT GET" $ligne # ${ligne/\*/\\\*}
       #${ligne/\*/\\\*} #
       $ligne
   fi
done < <(while true; do
    read entree < $FIFO
    [[ "$entree" == "QuitNow" ]] && break 
     echo $entree
done)


exit
