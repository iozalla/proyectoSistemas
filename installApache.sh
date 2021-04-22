  #!/bin/bash



installApache(){
  dpkg -s apache2 >&/dev/null 	#se mira si existe el paquete apache2 y se envia el stdout y stderr a un archivo para que no se muestre por pantalla
  ultima=$? 					#se mira el codigo de respuesta que ha devuelto el ultimo comando
  if [ $ultima -eq 0 ]; then echo "apache2 already installed"	#si el codigo es 0 significará que se ha encontrado el paquete y que ya esta instalado

  else 						#si no se instala
    echo "Installing apache2..."
    sudo apt-get --assume-yes install apache2>&/dev/null
    echo "Installed"
  fi							#cerrar el if
}


apacheStart(){
  service apache2 status|grep 'Active: active (running)'>&/dev/null 	#se mira si existe el paquete apache2 y se envia el stdout y stderr a un archivo para que no se muestre por pantalla
  ultima=$? 							#se mira el codigo de respuesta que ha devuelto el ultimo comando
  if [ $ultima -eq 0 ]; then echo "already started"	#si el codigo es 0 significará que se ha iniciado el apache

  else 						#si no, se inicia
    echo "starting apache"
    sudo service apache2 start

  fi							#cerrar el if
}



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


apacheTest(){
  echo "Info about apache: "
  sudo netstat -anp | grep "apache2"
}

apacheIndex(){
  firefox http://127.0.0.1
}

personalIndex(){
  sudo cp index.html /var/www/html/
  sudo cp -r grupo /var/www/html/
  echo "ficheros copiados a /var/www/html/ "
  apacheIndex
}

createVirtualhost(){
  sudo mkdir /var/www/laguntest
  sudo mkdir /var/www/laguntest/public_php
  sudo cp index.html /var/www/laguntest/public_php 		#copiamos el index
  sudo cp -r grupo /var/www/laguntest/public_php		#copiamos la carpeta grupo

  echo "ficheros copiados a /var/www/laguntest/public_html"
  echo "creando localhost "
  sudo cp ports.conf /etc/apache2/				#copiamos la configuracion de los puertos a su sitio
  sudo cp grupo.es.conf /etc/apache2/sites-available
  sudo a2ensite grupo.es.conf
  sudo service apache2 restart
  firefox http://localhost:8888/index.html
}
phpInstall(){
dpkg -s php >&/dev/null 	#se mira si existe el paquete apache2 y se envia el stdout y stderr a un archivo para que no se muestre por pantalla
  ultima=$? 					#se mira el codigo de respuesta que ha devuelto el ultimo comando
  if [ $ultima -eq 0 ]; then echo "apache2 already installed"	#si el codigo es 0 significará que se ha encontrado el paquete y que ya esta instalado

  else 						#si no se instala
    echo "Installing php modules..."
    sudo apt-get --assume-yes install php libapache2−mod−php>&/dev/null
    sudo apt-get --assume-yes install php libapache2-mod-php
    sudo apt-get --assume-yes install php-cli >&/dev/null
    sudo apt-get --assume-yes install php7.4-cli >&/dev/null
    echo "Restarting apache service..."
    sudo service apache2 restart
    sudo systemctl reload apache2
    echo "Installed"
  fi							#cerrar el if

}
phpTest(){
  sudo cp test.php /var/www/laguntest/public_php
  firefox http://localhost:8888/test.php
}
instalandoPaquetesUbuntuLagunTest(){

	sudo apt-get --assume-yes install python3-pip
	sudo apt-get --assume-yes install dos2unix
	sudo apt-get --assume-yes install librsvg2-bin

}
creandoEntornoVirtualPython3(){
	sudo pip3 install virtualenv
	cd /var/www/laguntest/public_html/

	if [ -d ".env" ] ; then echo "Virtual enviroment already created"
	else
		sudo virtualenv -p python3 .env
	fi
}
instalandoLibreriasPythonLagunTest(){
  usuario=$(id -s)
  grupo=$(id -g)
  chwon $usuario[:$grupo] var/www/laguntest/public_html
  source virtualenv/bin/activate
}

installApache
apacheStart
installNetstat
personalIndex
apacheIndex
createVirtualhost
phpInstall
phpTest
instalandoPaquetesUbuntuLagunTest
creandoEntornoVirtualPython3
instalandoLibreriasPythonLagunTest
