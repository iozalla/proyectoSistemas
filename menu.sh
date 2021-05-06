#!/bin/bash
###########################################################
#                  1) INICIALIZACIONES PREVIAS          #
###########################################################
rutaPrincipal=$( pwd )
RED='\033[0;31m'
NC='\033[0m' #COLOR ORIGINAL
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36'
PURPLE='\033[0;35m'
###########################################################
#                  1) INSTALL APACHE                     #
###########################################################
apacheInstall(){
  dpkg -s apache2 >&/dev/null 	#se mira si existe el paquete apache2 y se envia el stdout y stderr a un archivo para que no se muestre por pantalla
  ultima=$? 					#se mira el codigo de respuesta que ha devuelto el ultimo comando
  if [ $ultima -eq 0 ]; then echo -e "${GREEN}apache2 already installed"	#si el codigo es 0 significará que se ha encontrado el paquete y que ya esta instalado

  else 						#si no se instala
    echo "Installing apache2..."
    sudo apt-get --assume-yes install apache2>&/dev/null
    echo -e "${GREEN}Installed"
  fi							#cerrar el if
}




###########################################################
#                  2) START APACHE                     #
###########################################################
apacheStart(){
  service apache2 status|grep 'Active: active (running)'>&/dev/null 	#se mira si existe el paquete apache2 y se envia el stdout y stderr a un archivo para que no se muestre por pantalla
  ultima=$? 							#se mira el codigo de respuesta que ha devuelto el ultimo comando
  if [ $ultima -eq 0 ]; then echo -e "${GREEN}already started"	#si el codigo es 0 significará que se ha iniciado el apache

  else 						#si no, se inicia
    echo -e "${CYAN}starting apache"
    sudo service apache2 start
    echo -e "${GREEN}ApacheStarted"

  fi							#cerrar el if
}


###########################################################
#                  3) Ver puertos Apache                  #
###########################################################
installNetstat(){
  dpkg -s net-tools>&/dev/null 	#se mira si existe el paquete netstat y se envia el stdout y stderr a un archivo para que no se muestre por pantalla
  ultima=$? 					#se mira el codigo de respuesta que ha devuelto el ultimo comando
  if [ $ultima -eq 0 ]; then echo -e "${GREEN}netstat already installed "	#si el codigo es 0 significará que se ha encontrado el paquete y que ya esta instalado

  else 						#si no se instala
    echo "Installing netstat..."
    sudo apt-get --assume-yes install net-tools>&/dev/null
    echo -e "${GREEN}Installed"
  fi							#cerrar el if
}

###########################################################
#                  3) TEST APACHE                     #
###########################################################
apacheTest(){
  echo "Info about apache: "
  sudo netstat -anp | grep "apache2"
}

###########################################################
#                  4) ABRIR INDEX                     #
###########################################################
apacheIndex(){
  firefox http://127.0.0.1
}

###########################################################
#                  5) CREAR INDEX PERSONALIZADO           #
###########################################################
personalIndex(){
  sudo cp index.html /var/www/html/
  sudo cp -r grupo /var/www/html/
  echo -e "${GREEN}ficheros copiados a /var/www/html/ "
  apacheIndex
}
###########################################################
#                  6) CREAR VIRTUALHOST                   #
###########################################################
createVirtualhost(){
  sudo mkdir /var/www/laguntest
  sudo mkdir /var/www/laguntest/public_html
  sudo cp index.html /var/www/laguntest/public_html 	 #copiamos el index
  sudo cp -r grupo /var/www/laguntest/public_html		   #copiamos la carpeta grupo

  echo "ficheros copiados a /var/www/laguntest/public_html"
  echo "creando localhost "
  sudo cp ports.conf /etc/apache2/				#copiamos la configuracion de los puertos a su sitio
  sudo cp grupo.es.conf /etc/apache2/sites-available
  sudo a2ensite grupo.es.conf
  sudo service apache2 restart
  echo -e "${GREEN}LOCALHOST creado "
}
###########################################################
#                  7) TEST VIRTUALHOST                   #
###########################################################
virtualhostTest(){
  firefox http://localhost:8888/index.html
}

###########################################################
#                  8) INSTALAR PHP                     #
###########################################################
phpInstall(){
dpkg -s php >&/dev/null 	#se mira si existe el paquete apache2 y se envia el stdout y stderr a un archivo para que no se muestre por pantalla
  ultima=$? 					#se mira el codigo de respuesta que ha devuelto el ultimo comando
  if [ $ultima -eq 0 ]; then echo -e "${GREEN}PHP already installed"	#si el codigo es 0 significará que se ha encontrado el paquete y que ya esta instalado

  else 						#si no se instala
    echo "Installing php modules..."
    sudo apt-get --assume-yes install php libapache2−mod−php>&/dev/null

    sudo apt-get --assume-yes install php-cli >&/dev/null
    sudo apt-get --assume-yes install php7.4-cli >&/dev/null
    echo "Restarting apache service..."
    sudo service apache2 restart
    sudo systemctl reload apache2
    echo -e "${GREEN}Installed"
  fi							#cerrar el if

}
###########################################################
#                  9) TEST PHP                            #
###########################################################
phpTest(){
  sudo cp test.php /var/www/laguntest/public_html
  firefox http://localhost:8888/test.php
  echo -e "${GREEN}Tested"
}
#################################################################################
#                       10) INSTALAR PAQUETES LAGUNTEST                         #
#################################################################################
instalandoPaquetesUbuntuLagunTest(){
	sudo apt-get --assume-yes install python3-pip
	sudo apt-get --assume-yes install dos2unix
	sudo apt-get --assume-yes install librsvg2-bin
  echo -e "${GREEN}paquetes instalados"
}

#################################################################################
#                       11) CREAR VIRTUALENV                                    #
#################################################################################
creandoEntornoVirtualPython3(){
	sudo pip3 install virtualenv
	cd /var/www/laguntest/public_html/

	if [ -d ".env" ] ; then echo -e "${GREEN}Virtual enviroment already created"
	else
		sudo virtualenv -p python3 .env
	fi
}
###########################################################
#              12) INSTALAR LIBRERIAS PYTHON              #
###########################################################
instalandoLibreriasPythonLagunTest(){
  usuario=$(id -u) #se guarda en una variable el id del usuario actual
  grupo=$(id -g) #se guarda en una variable el id del grupo actual
  echo $rutaPrincipal
  cd $rutaPrincipal
  sudo chown $usuario:$grupo /var/www/laguntest/public_html #Se le da permisos al usuario actual y al grupo actual sobre el directorio
  ls /var/www/laguntest/public_html/
  source /var/www/laguntest/public_html/.env/bin/activate #se activa el entorno de python
  pip3 list
  sudo cp ./requirements.txt /var/www/laguntest/public_html/.env
  cd /var/www/laguntest/public_html/.env
  pip3 list
  sudo /var/www/laguntest/public_html/.env/bin/python -m pip install -r requirements.txt	#el comando que habia antes usaba pip3 que llamaba al instalador de paquetes de python e instalaba los paquetes en el ordenador. nosotros solo queremos instalarlos en el virtualenv asi que llamamos al pip del mismo
  pip3 list

  echo -e "${GREEN}LIBRERIAS instaladas"
  deactivate
  cd $rutaPrincipal

}

###########################################################
#                  13) INSTALAR LAGUNTEST                 #
###########################################################
instalandoAplicacionLagunTest(){
  cd $rutaPrincipal
  sudo cp -r textos /var/www/laguntest/public_html/ #copiamos la carpeta textos
  sudo chmod +x webprocess.sh
  sudo cp  *.sh *.php *.py *.gif /var/www/laguntest/public_html/
  echo -e "${GREEN}Aplicacion instalada${NC}"

}
###########################################################
#                  14) PASO PROPIEDAD                     #
###########################################################
pasoPropiedad(){
  sudo chown -R www-data:www-data /var/www
  echo -e "${GREEN}Hecho${NC}"
}

###########################################################
#     15) PROBAR QUE FUNCIONE EL WEBPROCESS.SH            #
###########################################################


pruebaWebprocess(){
  echo "1º cd /var/www/laguntest/public_html/"
  echo "2º ./webprocess.sh textos/english.doc.txt"
  echo "3º exit"
  echo "4º 16)"
  sudo su www-data -s /bin/bash

  echo -e "${GREEN}Webprocess ejecutado${NC}"

}



###########################################################
#                  16) VISUALIZAR APLICACION                    #
###########################################################
visualizandoAplicacion(){
  sudo cp index.php /var/www/laguntest/public_html
  firefox http://localhost:8888/index.php
  echo -e "${GREEN}Tested${NC}"
}

###########################################################
#                  17) VER LOGS                           #
###########################################################
viendoLogs(){
  tail -100 /var/log/apache2/error.log #muestra los errores
}
###########################################################
#                  18) CONECTAR SSH                       #
###########################################################
conectarssh(){
  read -p "${CYAN}Introduce <USUARIO>@<IP>${NC}" $ssh           #Se solicita la direccion a la que se va a conectar
  ssh $ssh                                          #Se realiza la conexion
  tar -czvf laguntest.tar.gz ./proyectoSistemas/    #
  sudo scp ~/laguntest.tar.gz $ssh:Escritorio
  ssh tar -zxvf laguntest.tar.gz
  rm laguntest.tar.gz
  ssh rm laguntest.tar.gz

  ssh ./proyectoSistemas/.installApache.sh

}
###########################################################
#                     20) SALIR                          #
###########################################################

function fin()
{
	echo -e "¿Quieres salir del programa?(S/N)\n"
        read respuesta
	if [ $respuesta == "N" ]
		then
			opcionmenuppal=0
		fi
}
###########################################################
#                     21) TODO                            #
###########################################################
function todo(){

  apacheInstall

  apacheStart

  apacheTest

  apacheIndex

  personalIndex

  createVirtualhost

  virtualhostTest

  phpInstall

  phpTest

  instalandoPaquetesUbuntuLagunTest

  creandoEntornoVirtualPython3

  instalandoLibreriasPythonLagunTest

  instalandoAplicacionLagunTest

  pasoPropiedad

  #pruebaWebprocess

  visualizandoAplicacion

  viendoLogs

  echo "no hay 18"

  echo "no hay 19"

  echo -e "${PURPLE}トマトとチョリソのマカロニ"
  echo "Asier Astorquiza, Iñigo Ozalla, Iker Valcarcel, Endika Eiros"
  exit 0

}

###########################################################
#                   ### Main ###                          #
###########################################################

### Main ###
function main(){

  if [ $1 -n ]; then todo
  else
    opcionmenuppal=0
    while test $opcionmenuppal -ne 20
    do
    	#Muestra el menu
        echo -e "_____________________________________________  "
      	echo -e "${YELLOW}1) Instala Apache "
        echo -e "2) Arrancar el servicio apache "
        echo -e "3) Informacion APACHE    "
        echo -e "4) Visualizar web por defecto     "
        echo -e "5) Personalizar index.html     "
        echo -e "6) Crear VIRTUALHOST     "
        echo -e "7) Test VIRTUALHOST     "
        echo -e "8) Instalar PHP     "
        echo -e "9) Test PHP    "
        echo -e "10) Instalar paquetes LAGUNTEST   "
        echo -e "11) Crear entorno virtual Python3   "
        echo -e "12) Instalar librerias Python    "
        echo -e "13) Instalar LAGUNTEST   "
        echo -e "14) Pasar propiedad   "
        echo -e "15) Prueba de webprocess.sh (no usar)   "
        echo -e "16) Visualizar aplicacion   "
        echo -e "17) Ver logs   "
        echo -e "18) Conectar SSH    "
        echo -e "19) No hay 19   "
	      echo -e "20) Fin   ${NC}"
        read -p "Elige una opcion: " opcionmenuppal
        echo ""

    	case $opcionmenuppal in

   		  1) apacheInstall;;
        2) apacheStart;;
        3) apacheTest;;
        4) apacheIndex;;
        5) personalIndex;;
        6) createVirtualhost;;
        7) virtualhostTest;;
        8) phpInstall;;
        9) phpTest;;
        10) instalandoPaquetesUbuntuLagunTest;;
        11) creandoEntornoVirtualPython3;;
        12) instalandoLibreriasPythonLagunTest;;
        13) instalandoAplicacionLagunTest;;
        14) pasoPropiedad;;
        15) pruebaWebprocess;;
        16) visualizandoAplicacion;;
        17) viendoLogs;;
        18) echo "no hay 18";;
        19) echo "no hay 19";;
        20) fin;;
  			*) ;;
    	esac
    done

    echo -e "${PURPLE}トマトとチョリソのマカロニ"
    echo "Asier Astorquiza, Iñigo Ozalla, Iker Valcarcel, Endika Eiros"
    exit 0

  fi
}
main
