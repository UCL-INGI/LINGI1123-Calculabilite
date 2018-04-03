#!/bin/bash
#Script d'update pour git

branch_default="master" # nom de la branche sur laquelle faire la màj
if [ -n "$1" ]
then
	if [ "$1" = "-h" ]
	then
		echo "Script de mise à jour du dépôt du syllabus concernant le cours de Calculabilité LINGI1123"
		echo "donné par le Professeur Yves Deville à l'UCL, l'Université Catholique de Louvain,"
		echo "et disponible à l'URL suivante : https://github.com/UCL-INGI/LINGI1123-Calculabilite"
		echo "\nIl configure automatiquement une remote upstream et une branche master"
		echo "si ceux-ci ne sont pas définis et met à jour le dépôt local sur cette branche master."
		echo "\nUTILISATION: sh update.sh [OPTIONS | NOM-BRANCHE]"
		echo "[OPTIONS]: -h: affiche l'aide"
		echo "[NOM-BRANCHE]: Nom de la branche sur laquelle il faudrait effectuer les modifications"
		echo "(par défault il s'agit de master)"
		exit 0
	else
		branch_default=$1
	fi
fi
URL="https://github.com/UCL-INGI/LINGI1123-Calculabilite.git"

# On vérifie qu'il existe bien une remote upstream pointant vers le dépôt
remote=$(git remote)
rep=$(echo $remote | grep -o "upstream")
#Si une branche s'appelle upstream, grep nous le dira sinon ce sera une ligne blanche
#echo $rep
if [ -n "$rep" ]
then
	# rep est non nul, donc il existe une remote s'appellant upstream
	urlUpstream=$(git remote get-url $rep)
	if [ "$urlUpstream" != $URL ]
	then
		git remote remove upstream
		git remote add upstream $URL
		echo "remote upstream modifiée pour l'url $URL"
	fi
else
	# rep est nul, il faut créer une remote upstream
	git remote add upstream $URL
	echo "remote upstream ajoutée pour l'url $URL"
fi

# On vérifie qu'il existe bien une branche master
branch=$(git branch)
rep2=$(echo $branch | grep -o $branch_default)
if [ -z "$rep2" ]
then
	git checkout -b $branch_default
fi

git fetch upstream
git merge upstream/$branch_default

exit 0
