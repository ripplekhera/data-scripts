#!/bin/bash

users=("bbivin" "rgupta" "chedge" "susmit" "mpeterson" "aacosta" "tsimonetta" "cody_norris" "Lisa_Grimes" "sinziana" "dsingleterry" "lnguyen" "jsaldana" "jlandau" "cperez" "lsrigiri" "Suchet_Vatish" "cedwards" "lgordia" "kanonh" "gkhuang" "bmeskauskis" "pkoteras" "Allison_Steinberg" "Jason_Schieck" "Bill_Johnston" "csavino" "Richard_Margetic" "kdoyle" "smitra" "testing%20api" "ripplek" "chris_shelton" "Mandeep_Goraya" "Connie_Bensen" "Ashish_Seth" "jhubbard" "rschiess" "cwilke" "cjohnson" "Karthik" "lkumari" "jsmonaaa" "Gretchen_Garretsen" "tbailey" "jbyerly" "Ravinder_J" "Claudia_Escobar" "Chris_Hornsby" "Chris_Shelton" "rkhera3" "kmarriott" "George_Sadler" "Gustavo_Velho" "lanidame" "bcarew" "acamden" "Jyoti_Sahay" "kdaruvalla" "wmanuel" "sbeebe" "munish" "rhildebrandt" "bmelinat_test_user" "Lola_Bakare" "Damian_Fernandez" "Shesha_Shah" "RiUnPi6zpc7Q" "abrown" "jboateng" "Natalie_Kortum" "msokunbi" "Chaitanya_Dhaval" "franka" "davidgair" "Alex_Park" "Suchitra_Kolluru" "suhlir" "alexyim" "Ryan_Garcia" "tgregorski" "jmihalic" "cdragseth" "rhampton" "Jen_Bruce" "Jason_Duty" "junliao" "aoreck" "Tiina_Hameenanttila" "sbhutani%20" "ewalker" "Sarah_Finley" "richchen" "mmillanti" "Goril_Mathisen" "rjensen" "kmitsumoto" "driojas" "Maribel_Sierra" "dtrevino" "wandrews" "logan_lawler" "Michael_J_Fox" "andrew_durrett" "Chitra_Thankaswamy" "lbakare" "btestington" "rbinhammer" "srichardson" "pleblanc" "kentlang" "Todd_Smart" "Brett_Bridges" "skolluru" "Ahmed_Tariq%20" "vdoddi" "Kristin_Zibell" "kjelinek" "jcochran" "asolin" "sarahf" "lbonilla" "awilmoth" "Richard_Binhammer" "Rajiv_Narang" "pduggal" "Angela_Adams" "andreasvoss" "mtoledano" "rthompson" "rishabh" "dtablizo" "adalmia" "Tunde_Ehindero" "bvaughn" "jdavis" "Shiloh_Uhlir" "enystrom" "dchen1" "Amaris_Tenison" "rdaulong" "kfowler")



listuser()
{
	for user in "${users[@]}"
	do 
		userjson=$(curl -s localhost:8098/riak/user/$user)
		if [ "$userjson" == "not found" ]
		then 
			echo "user ${user} not found"
		else
			echo "user ${user} deleted"
		fi
	#	echo -e "\n"
	done
}

deleteuser()
{
	for user in "${users[@]}"
	do 
		userjson=$(curl -s -XDELETE localhost:8098/riak/user/$user)
		if [ "$userjson" == "not found" ]
		then 
			echo "user ${user} not found"
		else
			echo "user ${user} deleted"
		fi
	#	echo -e "\n"
	done
}



deleteuser