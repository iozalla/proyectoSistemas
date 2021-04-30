#!/bin/bash
###########################################################
#                  1) INICIALIZACIONES PREVIAS          #
###########################################################
rutaPrincipal=$( pwd )
###########################################################
#                  1) INSTALL APACHE                     #
###########################################################
apacheInstall(){
  dpkg -s apache2 >&/dev/null 	#se mira si existe el paquete apache2 y se envia el stdout y stderr a un archivo para que no se muestre por pantalla
  ultima=$? 					#se mira el codigo de respuesta que ha devuelto el ultimo comando
  if [ $ultima -eq 0 ]; then echo "apache2 already installed"	#si el codigo es 0 significará que se ha encontrado el paquete y que ya esta instalado

  else 						#si no se instala
    echo "Installing apache2..."
    sudo apt-get --assume-yes install apache2>&/dev/null
    echo "Installed"
  fi							#cerrar el if
}




###########################################################
#                  2) START APACHE                     #
###########################################################
apacheStart(){
  service apache2 status|grep 'Active: active (running)'>&/dev/null 	#se mira si existe el paquete apache2 y se envia el stdout y stderr a un archivo para que no se muestre por pantalla
  ultima=$? 							#se mira el codigo de respuesta que ha devuelto el ultimo comando
  if [ $ultima -eq 0 ]; then echo "already started"	#si el codigo es 0 significará que se ha iniciado el apache

  else 						#si no, se inicia
    echo "starting apache"
    sudo service apache2 start

  fi							#cerrar el if
}


###########################################################
#                  3) Ver puertos Apache                  #
###########################################################
installNetstat(){
  dpkg -s net-tools>&/dev/null 	#se mira si existe el paquete netstat y se envia el stdout y stderr a un archivo para que no se muestre por pantalla
  ultima=$? 					#se mira el codigo de respuesta que ha devuelto el ultimo comando
  if [ $ultima -eq 0 ]; then echo "netstat already installed "	#si el codigo es 0 significará que se ha encontrado el paquete y que ya esta instalado

  else 						#si no se instala
    echo "Installing netstat..."
    sudo apt-get --assume-yes install net-tools>&/dev/null
    echo "Installed"
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
  echo "ficheros copiados a /var/www/html/ "
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
  if [ $ultima -eq 0 ]; then echo "apache2 already installed"	#si el codigo es 0 significará que se ha encontrado el paquete y que ya esta instalado

  else 						#si no se instala
    echo "Installing php modules..."
    sudo apt-get --assume-yes install php libapache2−mod−php>&/dev/null

    sudo apt-get --assume-yes install php-cli >&/dev/null
    sudo apt-get --assume-yes install php7.4-cli >&/dev/null
    echo "Restarting apache service..."
    sudo service apache2 restart
    sudo systemctl reload apache2
    echo "Installed"
  fi							#cerrar el if

}
###########################################################
#                  9) TEST PHP                            #
###########################################################
phpTest(){
  sudo cp test.php /var/www/laguntest/public_html
  firefox http://localhost:8888/test.php
}
#################################################################################
#                       10) INSTALAR PAQUETES LAGUNTEST                         #
#################################################################################
instalandoPaquetesUbuntuLagunTest(){
	sudo apt-get --assume-yes install python3-pip
	sudo apt-get --assume-yes install dos2unix
	sudo apt-get --assume-yes install librsvg2-bin
}

#################################################################################
#                       11) CREAR VIRTUALENV                                    #
#################################################################################
creandoEntornoVirtualPython3(){
	sudo pip3 install virtualenv
	cd /var/www/laguntest/public_html/

	if [ -d ".env" ] ; then echo "Virtual enviroment already created"
	else
		sudo virtualenv -p python3 .env
	fi
}
###########################################################
#                  12)INSTALAR LIBRERIAS PYTHON           #
###########################################################
instalandoLibreriasPythonLagunTest(){
  usuario=$(id -u) #se guarda en una variable el id del usuario actual
  grupo=$(id -g) #se guarda en una variable el id del grupo actual
  echo $rutaPrincipal
  cd $rutaPrincipal
  sudo chown $usuario:$grupo /var/www/laguntest/public_html #Se le da permisos al usuario actual y al grupo actual sobre el directorio
  source /var/www/laguntest/public_html/.env/bin/activate #se activa el entorno de python
  sudo cp ./requirements.txt /var/www/laguntest/public_html/.env
  sudo pip3 install -r requirements.txt
  deactivate
}

###########################################################
#                  13) INSTALAR LAGUNTEST                 #
###########################################################
instalandoAplicacionLagunTest(){
  cp -r textos /var/www/laguntest/public_html/ #copiamos la carpeta textos
  sudo chmod +x webprocess.sh
  cp  *.sh *.php *.py *.gif /var/www/laguntest/public_html/

}
###########################################################
#                  14) PASO PROPIEDAD                     #
###########################################################
pasoPropiedad(){
  sudo chown -R www-data:www-data /var/www
}

###########################################################
#                  16) PASO PROPIEDAD                     #
###########################################################
visualizandoAplicacion(){

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
  read -p "Introduce <USUARIO>@<IP>" $ssh           #Se solicita la direccion a la que se va a conectar
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

### Main ###
function main(){
  opcionmenuppal=0
  while test $opcionmenuppal -ne 20
  do
  	#Muestra el menu
        	echo -e "1) Instala Apache \n"
          echo -e "2) Arrancar el servicio apache \n"
          echo -e "3) Informacion APACHE    \n"
          echo -e "4) Visualizar web por defecto     \n"
          echo -e "5) Personalizar index.html     \n"
          echo -e "6) Crear VIRTUALHOST     \n"
          echo -e "7) Test VIRTUALHOST     \n"
          echo -e "8) Instalar PHP     \n"
          echo -e "9) ...     \n"

  	      echo -e "20) fin \n"
          echo -e "9) Test PHP    \n"
          echo -e "10) Instalar paquetes LAGUNTEST   \n"
          echo -e "11) Crear entorno virtual Python3   \n"
          echo -e "12) Instalar librerias Python    \n"
          echo -e "13) Instalar LAGUNTEST   \n"
          echo -e "14) Pasar propiedad   \n"
          echo -e "15) Prueba de webprocess.sh (no usar)   \n"
          echo -e "16) Visualizar aplicacion   \n"
          echo -e "17) Ver logs   \n"
          echo -e "18) Conectar SSH    \n"
          echo -e "19) No hay 19   \n"
  	      echo -e "20) fin   \n"
          read -p "Elige una opcion:" opcionmenuppal

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
        15) echo "no hay 15";;
        16) visualizandoAplicacion;;
        17) viendoLogs;;
        18) echo "no hay 18";;
        19) echo "no hay 19";;
        20) fin;;
  			*) ;;

  	esac
  done

  echo "Fin del Programa"
  exit 0<
}
main
