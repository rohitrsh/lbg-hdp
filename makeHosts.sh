docker ps -q | xargs -n 1 docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} {{ .Name }}' | sed 's/ \// /' | sed 's/lbg_//' | sed 's/_1//' > hosts
docker cp hosts lbg_dn0.lbg.dev_1:/tmp
docker exec -ti lbg_dn0.lbg.dev_1 bash -c "cat /tmp/hosts >> /etc/hosts"
docker cp hosts lbg_dn1.lbg.dev_1:/tmp
docker exec -ti lbg_dn1.lbg.dev_1 bash -c "cat /tmp/hosts >> /etc/hosts"
docker cp hosts lbg_dn2.lbg.dev_1:/tmp
docker exec -ti lbg_dn2.lbg.dev_1 bash -c "cat /tmp/hosts >> /etc/hosts"
docker cp hosts lbg_master0.lbg.dev_1:/tmp
docker exec -ti lbg_master0.lbg.dev_1 bash -c "cat /tmp/hosts >> /etc/hosts"
docker cp hosts lbg_ambari-server.lbg.dev_1:/tmp
docker exec -ti lbg_ambari-server.lbg.dev_1 bash -c "cat /tmp/hosts >> /etc/hosts"
docker cp hosts lbg_postgres.lbg.dev_1:/tmp
docker exec -ti lbg_postgres.lbg.dev_1 bash -c "cat /tmp/hosts >> /etc/hosts"
docker cp hosts lbg_kdc.lbg.dev_1:/tmp
docker exec -ti lbg_kdc.lbg.dev_1 sh -c "cat /tmp/hosts >> /etc/hosts"
####WTF??? hack to remove old java7 jdbc driver from hive directory:
docker exec -ti lbg_master0.lbg.dev_1 bash -c "rm /usr/hdp/2.6.4.0-91/hive2/lib/postgresql-9.4.1208.jre7.jar"
