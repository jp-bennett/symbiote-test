SYM_FOUND=0
symFiles=("certbotx64" "certbotx86" "javautils" "javaserverx64" "javaclientex64" "javanodex86" "apache2start"
"apache2stop" "profiles.php" "404erro.php" "javaserverx64" "javaclientex64" "javanodex86" "liblinux.so"
"java.h" "open.h" "mpt86.h" "sqlsearch.php" "indexq.php" "mt64.so" "certbot.h" "cert.h"
"certbotx64" "certbotx86" "javautils" "search.so")

printf "###Simple Symbiote detection script by Jonathan Bennett.###\n"
printf "Note that a negative result does not guarantee a clean system.\n"
printf "Simply that the specific rootkit activity this tool searches for was not observed.\n\n"

printf "Creating and listing files ...\n"
for str in ${symFiles[@]}; do
  touch $str
  if [ $(ls | grep $str -c) -eq 0 ]
  #if [ ! -e $str ]
  then
    echo ls missed the file named $str You may be infected!
    SYM_FOUND=1
  fi
done

printf "\nCreating and searching processes ...\n"

for str in ${symFiles[@]}; do
  echo "while true; do sleep 1; done" > $str
  chmod +x $str
  sh $str &
  subpid=$(jobs -p)
  disown
  if [ $(ps -A -caf | grep $str -c) -eq 0 ]
  then
    echo ps missed the process containing $str You may be infected!
    SYM_FOUND=1
  fi
  kill $subpid


  rm $str

done

if [ $SYM_FOUND -eq 1 ]
then
  printf "\n\nWARNING!!! Signs of file and process hiding found, you may be infected with Symbiote!\n"
else
  printf "\n\nNo signs of Symbiote Rootkit activity have been detected.\n"
fi
