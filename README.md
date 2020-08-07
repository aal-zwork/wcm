### Install

    cp example.env default.env
    sudo docker-compose run --rm --entrypoint rclone motion config
    sudo docker-compose up

### Help tools

#### Show audio

    sudo docker-compose run --rm --entrypoint arecord motion -L 
    sudo docker-compose run --rm --entrypoint aplay motion -l 
