#!/bin/bash
###########################################################
#                  INICIALIZACIONES PREVIAS          			#
###########################################################

rutaPrincipal=$( pwd )
RED='\033[0;31m'
NC='\033[0m' #COLOR ORIGINAL
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'

        echo -e "${PURPLE}__________________________________________________________________________________________ "
        echo -e "${CYAN}
.____       _____    ________ ____ ________________________________ ____________________
|    |     /  _  \  /  _____/|    |   \      \__    ___/\_   _____//   _____/\__    ___/
|    |    /  /_\  \/   \  ___|    |   /   |   \|    |    |    __)_ \_____  \   |    |
|    |___/    |    \    \_\  \    |  /    |    \    |    |        \/        \  |    |
|_______ \____|__  /\______  /______/\____|__  /____|   /_______  /_______  /  |____|
        \/       \/        \/                \/                 \/        \/"



###########################################################
#                  1) INSTALL APACHE                     #
###########################################################
apacheInstall(){
  dpkg -s apache2 >&/dev/null 	#se mira si existe el paquete apache2 y se envia el stdout y stderr a un archivo para que no se muestre por pantalla
  ultima=$? 					#se mira el codigo de respuesta que ha devuelto el ultimo comando
  if [ $ultima -eq 0 ]; then echo -e "${GREEN}apache2 already installed${NC}"	#si el codigo es 0 significará que se ha encontrado el paquete y que ya esta instalado

  else 						#si no se instala
    echo "Installing apache2..."
    sudo apt-get --assume-yes install apache2>&/dev/null
    echo -e "${GREEN}Installed${NC}"
  fi							#cerrar el if

}




###########################################################
#                  2) START APACHE                     #
###########################################################
apacheStart(){
  service apache2 status|grep 'Active: active (running)'>&/dev/null 	#se mira si existe el paquete apache2 y se envia el stdout y stderr a un archivo para que no se muestre por pantalla
  ultima=$? 							#se mira el codigo de respuesta que ha devuelto el ultimo comando
  if [ $ultima -eq 0 ]; then echo -e "${GREEN}Already started${NC}"	#si el codigo es 0 significará que se ha iniciado el apache

  else 						#si no, se inicia
    echo -e "${CYAN}Starting apache${NC}"
    sudo service apache2 start
    echo -e "${GREEN}ApacheStarted${NC}"

  fi							#cerrar el if

}


###########################################################
#                  3) TEST APACHE                     #
###########################################################

apacheTest(){
  dpkg -s net-tools>&/dev/null #se mira si existe el paquete netstat y se envia el stdout y stderr a un archivo para que no se muestre por pantalla
  ultima=$? 			#se mira el codigo de respuesta que ha devuelto el ultimo comando
  if [ $ultima -eq 0 ]; then echo -e "${GREEN}netstat already installed ${NC}"  #si el codigo es 0 significará que se ha encontrado el paquete y que ya esta instalado
  else 						#si no se instala
    echo "Installing netstat...${NC}"
    sudo apt-get --assume-yes install net-tools>&/dev/null
    echo -e "${GREEN}Installed${NC}"
  fi
  echo "Info about apache: "
  sudo netstat -anp | grep "apache2"

}

###########################################################
#                  4) ABRIR INDEX                     #
###########################################################
apacheIndex(){
  firefox http://127.0.0.1  #se abre firefox en la direccion http://127.0.0.1 (localhost)

}

###########################################################
#                  5) CREAR INDEX PERSONALIZADO           #
###########################################################
personalIndex(){
  sudo cp index.html /var/www/html/                 #se copia el index.html a la carpeta /var/www/html/
  sudo cp -r grupo /var/www/html/                   #se copia la carpeta grupo (fotos) a la carpeta /var/www/html/
  echo -e "${GREEN}ficheros copiados a /var/www/html/ ${NC}"
  apacheIndex

}
###########################################################
#                  6) CREAR VIRTUALHOST                   #
###########################################################
createVirtualhost(){
  sudo mkdir /var/www/laguntest
  sudo mkdir /var/www/laguntest/public_html            #creamos las carpetas necesarias
  sudo cp index.html /var/www/laguntest/public_html 	 #copiamos el index
  sudo cp -r grupo /var/www/laguntest/public_html		   #copiamos la carpeta grupo
  echo "Ficheros copiados a /var/www/laguntest/public_html"
  echo "Creando localhost "
  sudo cp ports.conf /etc/apache2/				            #copiamos la configuracion de los puertos a su sitio
  sudo cp grupo.es.conf /etc/apache2/sites-available  #copiamos la configuracion de la web a su sitio
  sudo a2ensite grupo.es.conf                         #hacemos el link con la configuracion
  sudo service apache2 restart                        #reiniciamos apache2
  echo -e "${GREEN}LOCALHOST creado ${NC}"

}
###########################################################
#                  7) TEST VIRTUALHOST                   #
###########################################################
virtualhostTest(){
  firefox http://localhost:8888/index.html            #se abre firefox en la direccion http://localhost:8888/index.html

}

###########################################################
#                  8) INSTALAR PHP                     #
###########################################################
phpInstall(){
dpkg -s php >&/dev/null 	#se mira si existe el paquete apache2 y se envia el stdout y stderr a un archivo para que no se muestre por pantalla
  ultima=$? 					#se mira el codigo de respuesta que ha devuelto el ultimo comando
  if [ $ultima -eq 0 ]; then echo -e "${GREEN}PHP already installed ${NC}"	#si el codigo es 0 significará que se ha encontrado el paquete y que ya esta instalado

  else 						#si no se instala
    echo "Installing php modules..."                    #instalamos modulos necesarios para PHP
    sudo apt --assume-yes install php libapache2-mod-php
    sudo apt --assume-yes install php-cli
    sudo apt --assume-yes install php7.4-cli
    echo "Restarting apache service..."
    sudo service apache2 restart                        #recargamos apache2
    sudo systemctl reload apache2                       #REINICIAMOS apache2
    echo -e "${GREEN}Installed${NC}"
  fi							#cerrar el if


}
###########################################################
#                  9) TEST PHP                            #
###########################################################
phpTest(){
  sudo cp test.php /var/www/laguntest/public_html
  firefox http://localhost:8888/test.php                #se abre firefox en la direccion http://localhost:8888/test.php
  echo -e "${GREEN}Tested${NC}"

}
#################################################################################
#                       10) INSTALAR PAQUETES LAGUNTEST                         #
#################################################################################
instalandoPaquetesUbuntuLagunTest(){ #se instalan los paquetes necesarios de laguntest
	sudo apt-get --assume-yes install python3-pip
	sudo apt-get --assume-yes install dos2unix
	sudo apt-get --assume-yes install librsvg2-bin
  echo -e "${GREEN}Alication Packages Installed${NC}"

}

#################################################################################
#                       11) CREAR VIRTUALENV                                    #
#################################################################################
creandoEntornoVirtualPython3(){
	sudo pip3 install virtualenv #instalamos virtualenv con el instalador de python
	cd /var/www/laguntest/public_html/ #navegamos hasta la carpeta del virtualhost

	if [ -d ".env" ] ; then echo -e "${GREEN}Virtual enviroment already created${NC}" #miramos si hay una carpeta .env en cuyo caso el virtualenv estara creado
	else
		sudo virtualenv -p python3 .env #si no creamos el entorno virtual
    echo -e "${GREEN}Virtual enviroment created${NC}"
	fi

}
###########################################################
#              12) INSTALAR LIBRERIAS PYTHON              #
###########################################################
instalandoLibreriasPythonLagunTest(){
  usuario=$(id -u) #se guarda en una variable el id del usuario actual
  grupo=$(id -g) #se guarda en una variable el id del grupo actual
  cd $rutaPrincipal #volvemos a la ruta ORIGINAL
  sudo chown $usuario:$grupo /var/www/laguntest/public_html #Se le da permisos al usuario actual y al grupo actual sobre el directorio
  source /var/www/laguntest/public_html/.env/bin/activate #se activa el entorno de python
  sudo cp ./requirements.txt /var/www/laguntest/public_html/.env #copiamos los requirements.txt
  cd /var/www/laguntest/public_html/.env                         #navegamos a la carpeta del entorno virtual
  sudo /var/www/laguntest/public_html/.env/bin/python -m pip install -r requirements.txt	#el comando que habia antes usaba pip3 que llamaba al instalador de paquetes de python e instalaba los paquetes en el ordenador. nosotros solo queremos instalarlos en el virtualenv asi que llamamos al pip del mismo
  echo -e "${GREEN}Python libraries installed${NC}"
  deactivate	#desactivamos el entorno
  cd $rutaPrincipal


}

###########################################################
#                  13) INSTALAR LAGUNTEST                 #
###########################################################
instalandoAplicacionLagunTest(){
  cd $rutaPrincipal
  sudo cp -r textos /var/www/laguntest/public_html/ #copiamos la carpeta textos
  sudo chmod +x webprocess.sh #le damos permiso de ejecucion al webprocess
  sudo cp  *.sh *.php *.py *.gif /var/www/laguntest/public_html/ #copiamos los archivos necesarios
  echo -e "${GREEN}Aplicacion instalada${NC}"

}
###########################################################
#                  14) PASO PROPIEDAD                     #
###########################################################
pasoPropiedad(){
  sudo chown -R www-data:www-data /var/www #le pasamos la propiedad a la carpeta /var/www
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
  #este programa es para hacer pruebas, primero se mete en el usuario www-data y despues tienes que meter los comandos que se han impreso. Asi ejecutaras el webprocess.sh



}



###########################################################
#                  16) VISUALIZAR APLICACION              #
###########################################################
visualizandoAplicacion(){
  sudo cp index.php /var/www/laguntest/public_html #copiamos el index.php que se ha creado al ejecutar webprocess.sh
  firefox http://localhost:8888/index.php          #lo abrimmos para visualizarlo
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
desktop=$( xdg-user-dir DESKTOP)                    #esto se usa para saber la ruta del escritorio
  read -p "Introduce <USUARIO>@<IP> " dir           #Se solicita la direccion a la que se va a conectar
  scp -r $rutaPrincipal $dir:$desktop  >&/dev/null  #se copia a traves de SSH la carpeta  en su escritorio
  echo -e "Laguntest Instalado"
# scp -r ./proyectoSistemas/ lsi@10.227.77.130:Escritorio (esta es la estructura que tiene que tener)

}
###########################################################
#            19) MOSTRAR INTENTOS DE CONEXION             #
###########################################################

mostrarIntentosConexion(){
  cat /var/log/auth.log > auth.log.txt
  cat /var/log/auth.log.1 >> auth.log.txt
  zcat /var/log/auth.log.2.gz >> auth.log.txt
  zcat /var/log/auth.log.3.gz >> auth.log.txt
  zcat /var/log/auth.log.4.gz >> auth.log.txt #Se guardan todos los archivos en un mismo fichero
  less auth.log.txt | tr -s ' ' '@' > conexiones.txt # se cambian todos los espacios por "@"
  for linea in `less conexiones.txt|grep 'Accepted@password'` #se asigna a las variables las columnas adecuadas
  do
    user=`echo $linea | cut -d@ -f9`
    dia=`echo $linea | cut -d@ -f2`
    mes=`echo $linea | cut -d@ -f1`
    hora=`echo $linea | cut -d@ -f3`
    echo -e "Status: [accept]   Account name: $user   Date: $mes/$dia/$hora " #se imprime los intentos satisfactorios
  done
  for linea in `less conexiones.txt|grep 'Failed@password'`
  do
    user=`echo $linea | cut -d@ -f9`
    dia=`echo $linea | cut -d@ -f2`
    mes=`echo $linea | cut -d@ -f1`
    hora=`echo $linea | cut -d@ -f3`
    echo -e "Status: [fail]   Account name: $user  Date: $mes/$dia/$hora "
  done
  rm conexiones.txt
  rm auth.log.txt
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
	else
    echo -e "${PURPLE}Asier Astorquiza, Iñigo Ozalla, Iker Valcarcel, Endika Eiros"
    exit 0
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

  echo -e "${PURPLE}Asier Astorquiza, Iñigo Ozalla, Iker Valcarcel, Endika Eiros${NC}"
  exit 0

}

###########################################################
#                   ### Main ###                          #
###########################################################

### Main ###
function main(){

    opcionmenuppal=0
    while test $opcionmenuppal -ne 21
    do
    	#Muestra el menu
                echo -e "${PURPLE}__________________________________________________________________________________________ ${NC}"
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
        echo -e "19) Ver intentos de SSH "
				echo -e "20) Fin  "
        echo -e "21) Todo   ${NC}"
        echo ""
        read -p "Elige una opcion: " opcionmenuppal
                echo -e "${PURPLE}__________________________________________________________________________________________ ${NC}"

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
        18) conectarssh;;
        19) mostrarIntentosConexion;;
        20) fin;;
        21) todo;;
        *) ;;

    	esac
      
    done

}
main
