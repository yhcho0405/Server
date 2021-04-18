name_of_image="youncho"
name_of_container="test"
docker build -t ${name_of_image} .
docker run --name ${name_of_container} -it -p80:80 -p443:443 ${name_of_image}
