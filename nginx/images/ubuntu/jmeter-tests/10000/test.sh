#!/bin/bash
set -e

ORANGE_COLOR='\033[0;33m'
DEFAULT_COLOR='\033[0;37m'
RED_COLOR='\033[0;31m'
GREEN_COLOR='\033[0;32m'
PURPLE_COLOR='\033[0;35m'
CYAN_COLOR='\033[0;36m'


TIME_WAITING_FINISH_CONTAINER_STATS=5
SETTINGS_TEST_FILE=test.jmx
TEST_RESULT_CSV_FILE=test-result.csv
CONTAINER_STATS_FILE=container-stats.csv
TEST_RESULT_DASHBOARD_FOLDER=html-reports/
BASE_PROJECT_PATH=$(pwd)/

docker_stats_pid=


default_message() {
    echo -e "$1$DEFAULT_COLOR"
}

danger_message() {
    echo -e "$RED_COLOR$1$DEFAULT_COLOR"
}

warning_message() {
    echo -e "$ORANGE_COLOR$1$DEFAULT_COLOR"
}

success_message() {
    echo -e "$GREEN_COLOR$1$DEFAULT_COLOR"
}

info_message() {
    echo -e "$CYAN_COLOR$1$DEFAULT_COLOR"
}

highlight_message() {
    echo -e "$PURPLE_COLOR$1$DEFAULT_COLOR"
}

init_docker_container() {
    info_message "Realizando o build da Imagem do docker \n"

    docker build $(pwd)/../../ --tag ubuntu-nginx-test;

    info_message "Build realizado \n"
    info_message "Executando o container \n"

    docker run -d -p 80:80 --name ubuntu-nginx-test --rm  ubuntu-nginx-test
    docker ps | grep ubuntu-nginx-test

    success_message "\n\nContainer em execução \n\n"
}

drop_docker_container() {
    info_message "Encerrando a execução container \n"

    docker stop ubuntu-nginx-test

    success_message "Execução encerrada \n"
}

init_docker_stats() {
    info_message "Iniciando o monitoramento de status do container"

    docker stats >> $CONTAINER_STATS_FILE &
    stats_pid=$!

    success_message "Container sendo monitorado e escrevendo a saída em: $CONTAINER_STATS_FILE"
    highlight_message "PID do processo de monitoramento $stats_pid"

    sleep $TIME_WAITING_FINISH_CONTAINER_STATS
}

finish_docker_stats()
{
    info_message "Finalizando o monitoramento do container"

    sleep $TIME_WAITING_FINISH_CONTAINER_STATS
    kill $stats_pid

    info_message "Processo do monitoramneto finalizado, PID $stats_pid"
    success_message "Container não está mais sendo monitorado, o conteúdo está disponível em: $CONTAINER_STATS_FILE"
}

prepare_jemiter_test() {
    warning_message "Iniciando a limpeza dos dados de testes anteriores"

    info_message "Arquivo de análisde de consumo do container disponível em: $CONTAINER_STATS_FILE"
    if [ -e "$CONTAINER_STATS_FILE" ];
    then
        rm $CONTAINER_STATS_FILE;
    fi

    info_message "Resultado final do tetes disponível em: $TEST_RESULT_CSV_FILE"
    if [ -e "$TEST_RESULT_CSV_FILE" ];
    then
        rm "$TEST_RESULT_CSV_FILE";
    fi

    info_message "Resultado final de dashaboard disponível em: $TEST_RESULT_DASHBOARD_FOLDER"
    if [ -e "$TEST_RESULT_DASHBOARD_FOLDER" ];
    then
        rm -Rf "$TEST_RESULT_DASHBOARD_FOLDER";
    fi
    mkdir "$TEST_RESULT_DASHBOARD_FOLDER";

    success_message "Limpeza finalizada"
}

init_jemiter_test() {

    info_message "iniciando o teste com o Apache Jmeter"
    info_message "Arquivo de configuração do teste: $BASE_PROJECT_PATH$SETTINGS_TEST_FILE"

    jmeter -n -t "$BASE_PROJECT_PATH$SETTINGS_TEST_FILE" \
        -l "$BASE_PROJECT_PATH$TEST_RESULT_CSV_FILE" \
        -e -o "$BASE_PROJECT_PATH$TEST_RESULT_DASHBOARD_FOLDER"

    success_message "Testes com o Apache Jmeter finalizado"
}

init_format_docker_stats_result() {
    info_message "Formantando os dados de status de consumo do container em $CONTAINER_STATS_FILE"

    sed -i '/CONTAINER/d' $CONTAINER_STATS_FILE
    sed -i 's/ \/ /,/g' $CONTAINER_STATS_FILE
    sed -i 's/%//g' $CONTAINER_STATS_FILE
    sed -i 's/ \{1,\}/,/g' $CONTAINER_STATS_FILE
    sed -i '1i CONTAINER ID,NAME,CPU %,MEM USAGE,LIMIT,MEM %,NET Input,NET Output,BLOCK Input,BLOCK Output,PIDS' $CONTAINER_STATS_FILE

    success_message "Formatação realizada em: $CONTAINER_STATS_FILE"
}

init_docker_container
prepare_jemiter_test
init_docker_stats
init_jemiter_test
finish_docker_stats
init_format_docker_stats_result
drop_docker_container